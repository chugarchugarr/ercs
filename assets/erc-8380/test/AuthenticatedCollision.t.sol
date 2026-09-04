// SPDX-License-Identifier: CC0-1.0
pragma solidity ^0.8.28;

import {CoupledCredentialGuard} from "../CoupledCredentialGuard.sol";
import {DomainRegistry} from "../DomainRegistry.sol";
import {IUnclonableCredential} from "../IUnclonableCredential.sol";
import {CapabilityCommitment} from "../CapabilityCommitment.sol";
import {BindingVerifier, ActionTarget} from "./Harness.sol";

contract AuthenticatedCollisionTest {
    CoupledCredentialGuard guard;
    DomainRegistry registry;
    BindingVerifier verifier;
    ActionTarget target;
    uint256 constant AGENT = 5;
    uint256 constant DOMAIN = 1;
    uint256 constant EXPIRY = 1900000000;

    function setUp() public {
        registry = new DomainRegistry();
        registry.registerDomain(DOMAIN, address(this));
        verifier = new BindingVerifier();
        target = new ActionTarget();
        guard = new CoupledCredentialGuard(address(verifier), address(registry));
    }

    function _callData() internal pure returns (bytes memory) {
        return abi.encodeWithSignature("act()");
    }

    function _cap(bytes32 salt, uint256 index)
        internal view returns (IUnclonableCredential.Capability memory c)
    {
        bytes32 action = keccak256(abi.encode(address(target), _callData()));
        c = IUnclonableCredential.Capability({
            nullifier: CapabilityCommitment.computeNullifier(salt),
            capabilityCommitment: CapabilityCommitment.computeCapabilityCommitment(
                salt, AGENT, block.chainid, DOMAIN, index, action, address(this), EXPIRY
            ),
            agentId: AGENT,
            homeChainId: block.chainid,
            homeDomainId: DOMAIN,
            capabilityIndex: index,
            actionCommitment: action,
            executor: address(this),
            expiry: EXPIRY
        });
    }

    function _inputs(IUnclonableCredential.Capability memory c)
        internal pure returns (bytes32[] memory a)
    {
        a = new bytes32[](9);
        a[0] = c.capabilityCommitment;
        a[1] = bytes32(c.agentId);
        a[2] = bytes32(c.homeChainId);
        a[3] = bytes32(c.homeDomainId);
        a[4] = bytes32(c.capabilityIndex);
        a[5] = c.actionCommitment;
        a[6] = bytes32(uint256(uint160(c.executor)));
        a[7] = bytes32(c.expiry);
        a[8] = c.nullifier;
    }

    function _arm(IUnclonableCredential.Capability memory c, bytes memory proof) internal {
        guard.issue(c.capabilityCommitment, c.agentId, c.homeDomainId, c.capabilityIndex);
        verifier.issueProof(proof, _inputs(c));
    }

    function _selector(bytes memory returndata) internal pure returns (bytes4 sel) {
        if (returndata.length < 4) return bytes4(0);
        assembly { sel := mload(add(returndata, 32)) }
    }

    function _attempt(IUnclonableCredential.Capability memory c, bytes memory proof)
        internal returns (bool ok, bytes memory returndata)
    {
        return address(guard).call(
            abi.encodeWithSelector(guard.execute.selector, c, proof, address(target), _callData())
        );
    }

    function test_GapBelowHighWaterClassifiesUnissued() public {
        setUp();
        bytes32 salt = bytes32(uint256(1001));
        IUnclonableCredential.Capability memory first = _cap(salt, 1);
        _arm(first, "first");
        guard.execute(first, "first", address(target), _callData());

        guard.issue(keccak256("index-100"), AGENT, DOMAIN, 100);
        require(guard.highestIssuedIndex(AGENT, DOMAIN) == 100, "high-water mark");

        IUnclonableCredential.Capability memory gap = _cap(salt, 50);
        verifier.issueProof("gap", _inputs(gap));
        (bool ok, bytes memory err) = _attempt(gap, "gap");
        require(!ok, "gap collision must revert");
        require(
            _selector(err) == IUnclonableCredential.UnissuedNullifierCollision.selector,
            "gap must classify from issuance state, not ceiling"
        );
    }

    function test_IssuedSaltReuseClassifies() public {
        setUp();
        bytes32 salt = bytes32(uint256(1002));
        IUnclonableCredential.Capability memory first = _cap(salt, 1);
        _arm(first, "first");
        guard.execute(first, "first", address(target), _callData());

        IUnclonableCredential.Capability memory second = _cap(salt, 2);
        _arm(second, "second");
        (bool ok, bytes memory err) = _attempt(second, "second");
        require(!ok, "salt reuse must revert");
        require(
            _selector(err) == IUnclonableCredential.IssuedSaltReuse.selector,
            "issued reuse classification"
        );
    }

    function test_ForgedCollisionMetadataFailsProofFirst() public {
        setUp();
        bytes32 salt = bytes32(uint256(1003));
        IUnclonableCredential.Capability memory first = _cap(salt, 1);
        _arm(first, "first");
        guard.execute(first, "first", address(target), _callData());

        IUnclonableCredential.Capability memory forged = first;
        forged.capabilityIndex = 50;
        (bool ok, bytes memory err) = _attempt(forged, "first");
        require(!ok, "forged metadata must revert");
        require(_selector(err) == CoupledCredentialGuard.BadProof.selector, "must fail proof first");
    }

    function test_ExactReplayRemainsCredentialAlreadySpent() public {
        setUp();
        bytes32 salt = bytes32(uint256(1004));
        IUnclonableCredential.Capability memory first = _cap(salt, 1);
        _arm(first, "first");
        guard.execute(first, "first", address(target), _callData());
        require(
            guard.consumedCommitment(first.nullifier) == first.capabilityCommitment,
            "first spend anchors commitment"
        );

        (bool ok, bytes memory err) = _attempt(first, "first");
        require(!ok, "replay must revert");
        require(
            _selector(err) == IUnclonableCredential.CredentialAlreadySpent.selector,
            "same capability remains replay"
        );
    }
}
