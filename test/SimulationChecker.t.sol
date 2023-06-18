// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import "forge-std/Test.sol";
import {SimulationChecker} from "src/SimulationChecker.sol";
import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";

contract FakeGiveawayTest is Test {
    SimulationChecker simulationChecker;
    MockERC20 token;

    function setUp() public {
        //vm.label(victim, "victim");
        token = new MockERC20("Mock", "MOCK", 18);
        simulationChecker = new SimulationChecker(address(token));
        token.mint(address(this), 100000000000000000000000000 * 10 ** 18);
        token.transfer(address(simulationChecker), 100000000000000000000 * 10 ** 18); 
    }

    function testBlockDiffucltyLog() public {
        simulationChecker.testBlockPrevrandao();
    }

    function testBlockbasefeeLog() public {
        simulationChecker.testBlockBasefee();
    }



    function testClaimBlockPrevrandao() public {
        simulationChecker.claimPrevrandao{value: 2 ether}();
        console.log(block.prevrandao);
        if (block.prevrandao == 0) {
            assertEq(token.balanceOf(address(simulationChecker)), 0);
        } else {
            assertEq(token.balanceOf(address(simulationChecker)), 1000 * 10 ** 18);
        }
    }

    function testBlocNumberDiff() public {
        vm.roll(10);
        simulationChecker.claimBlockDiff(5);
        assertEq(token.balanceOf(address(simulationChecker)), 0);

    }

    function testWithdraw() public {
        simulationChecker.claimPrevrandao{value: 2 ether}();
        token.transfer(address(simulationChecker), 1000 * 10 ** 18);
        simulationChecker.withdraw();
        assertEq(address(token).balance, 0);
    }

    receive() external payable {}
}
