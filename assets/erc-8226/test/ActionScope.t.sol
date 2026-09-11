// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {AgentMandate} from "../contracts/AgentMandate.sol";
import {ComplianceProvider} from "../contracts/ComplianceProvider.sol";
import {IAgentMandate} from "../contracts/interfaces/IAgentMandate.sol";
import {uRWA20} from "../contracts/mocks/uRWA20.sol";

contract ActionScopeTest is Test {
    AgentMandate mandate;
    ComplianceProvider compliance;
    uRWA20 token;

    address admin = makeAddr("admin");
    address complianceOwner = makeAddr("complianceOwner");
    address agent = makeAddr("agent");
    address principal = makeAddr("principal");

    bytes32 constant IDREF = keccak256("kyc-principal");

    function setUp() public {
        mandate = new AgentMandate(admin);
        compliance = new ComplianceProvider(complianceOwner);
        token = new uRWA20("Regulated", "RWA", admin);

        vm.prank(complianceOwner);
        compliance.grantPrincipal(principal, IDREF, 0);
    }

    function _instrumentAction(bytes4 selector, uint256 instrumentId) internal pure returns (bytes32) {
        return keccak256(abi.encode(selector, instrumentId));
    }

    function test_ParameterScopedActionDistinguishesInstrument() public {
        bytes32 instrumentOne = _instrumentAction(IERC20.transferFrom.selector, 1);
        bytes32 instrumentTwo = _instrumentAction(IERC20.transferFrom.selector, 2);

        bytes32[] memory actions = new bytes32[](1);
        actions[0] = instrumentOne;

        IAgentMandate.GrantMandateParams memory p = IAgentMandate.GrantMandateParams({
            agent: agent,
            validFrom: 0,
            validUntil: uint48(block.timestamp + 1 days),
            principal: principal,
            complianceProvider: address(compliance),
            identityRef: IDREF,
            asset: address(token),
            maxTransactionValue: type(uint256).max,
            maxCumulativeValue: type(uint256).max,
            metadata: bytes32(0),
            actions: actions,
            deadline: 0
        });

        vm.prank(principal);
        mandate.grantMandate(p, "");

        (bool ok, IAgentMandate.MandateReason reason) =
            mandate.canExecute(agent, principal, address(token), instrumentOne, 1);
        assertTrue(ok);
        assertEq(uint8(reason), uint8(IAgentMandate.MandateReason.OK));

        (ok, reason) = mandate.canExecute(agent, principal, address(token), instrumentTwo, 1);
        assertFalse(ok);
        assertEq(uint8(reason), uint8(IAgentMandate.MandateReason.ACTION_NOT_ENABLED));

        assertEq(instrumentOne, _instrumentAction(IERC20.transferFrom.selector, 1));
        assertNotEq(instrumentOne, instrumentTwo);
    }
}
