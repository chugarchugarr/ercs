#!/usr/bin/env python3
# Copyright (c) 2026 Joseph Angel Lerma
# SPDX-License-Identifier: MIT

import hashlib
import json
import os
import re
import sys
import urllib.request
from datetime import datetime, timezone
from pathlib import Path

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent

sys.path.insert(0, str(HERE))
import runner  # noqa: E402

MARKER = re.compile(r"RESOLUTION-FALSIFICATION\s+v0\.1", re.I)
BOUNDARY = re.compile(
    r"boundary:\s*(OUTCOME_RELEVANT_CLOSURE|EFFECTUATION_CLOSURE|CANON_FUTURE_SUFFICIENCY)",
    re.I,
)
RESULT = re.compile(r"result:\s*(NO_COUNTEREXAMPLE|COUNTEREXAMPLE)", re.I)
FIXTURE = re.compile(r"fixture:\s*(.+)", re.I)

def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()

def api_json(url: str, token: str):
    req = urllib.request.Request(
        url,
        headers={
            "Accept": "application/vnd.github+json",
            "Authorization": f"Bearer {token}",
            "X-GitHub-Api-Version": "2022-11-28",
        },
    )
    with urllib.request.urlopen(req) as r:
        return json.loads(r.read().decode("utf-8"))

def conformance():
    data = json.loads((HERE / "fixtures.json").read_text())
    mismatches = []
    results = []
    for fixture in data["fixtures"]:
        got = runner.evaluate(fixture)
        ok = got == fixture["expect"]
        results.append({
            "id": fixture["id"],
            "expected": fixture["expect"],
            "got": got,
            "matched": ok,
        })
        if not ok:
            mismatches.append(fixture["id"])
    return results, mismatches

def parse_review(review, author, head_sha):
    user = (review.get("user") or {}).get("login")
    body = review.get("body") or ""
    if not user or user.lower() == author.lower():
        return None
    if review.get("commit_id") != head_sha:
        return None
    if not MARKER.search(body):
        return None
    boundary = BOUNDARY.search(body)
    result = RESULT.search(body)
    if not boundary or not result:
        return None
    fixture = FIXTURE.search(body)
    return {
        "review_id": review.get("id"),
        "reviewer": user,
        "state": review.get("state"),
        "commit_id": review.get("commit_id"),
        "submitted_at": review.get("submitted_at"),
        "boundary": boundary.group(1).upper(),
        "result": result.group(1).upper(),
        "fixture": fixture.group(1).strip() if fixture else "NONE",
    }

def main():
    event_path = Path(os.environ["GITHUB_EVENT_PATH"])
    event = json.loads(event_path.read_text())
    pr = event.get("pull_request")
    if not pr:
        raise SystemExit("Resolution Gate requires a pull_request or pull_request_review event.")

    repo = os.environ["GITHUB_REPOSITORY"]
    token = os.environ["GITHUB_TOKEN"]
    number = pr["number"]
    author = pr["user"]["login"]
    head_sha = pr["head"]["sha"]
    base_sha = pr["base"]["sha"]

    fixture_results, mismatches = conformance()

    reviews = api_json(
        f"https://api.github.com/repos/{repo}/pulls/{number}/reviews?per_page=100",
        token,
    )
    qualifying = []
    for review in reviews:
        parsed = parse_review(review, author, head_sha)
        if parsed:
            qualifying.append(parsed)

    counterexamples = [r for r in qualifying if r["result"] == "COUNTEREXAMPLE"]
    no_counterexamples = [r for r in qualifying if r["result"] == "NO_COUNTEREXAMPLE"]

    if mismatches or counterexamples:
        result = "UNAUTHORIZED"
    elif no_counterexamples:
        result = "AUTHORIZED"
    else:
        result = "UNRESOLVED"

    receipt = {
        "receiptVersion": "0.1.0",
        "nonBearer": True,
        "basis": {
            "repository": repo,
            "pullRequest": number,
            "baseRef": pr["base"]["ref"],
            "baseSha": base_sha,
            "headRef": pr["head"]["ref"],
            "headSha": head_sha,
            "specSha256": sha256(ROOT / "SPEC.md"),
            "mergePolicySha256": sha256(ROOT / "MERGE_POLICY.md"),
            "falsificationProtocolSha256": sha256(ROOT / "FALSIFICATION_REVIEW.md"),
            "fixturesSha256": sha256(HERE / "fixtures.json"),
        },
        "evidence": {
            "conformanceFixtureCount": len(fixture_results),
            "conformanceMismatches": mismatches,
            "qualifyingExternalReviews": qualifying,
        },
        "result": result,
        "resolvedAt": datetime.now(timezone.utc).isoformat(),
        "semantics": (
            "This receipt records the result for the exact committed basis above. "
            "It is not bearer authority and does not remain authoritative after a load-bearing basis change."
        ),
    }

    out = ROOT / "resolution-receipt.json"
    out.write_text(json.dumps(receipt, indent=2) + "\n")
    print(json.dumps(receipt, indent=2))

if __name__ == "__main__":
    main()
