// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {IWETH9} from "../src/IWETH9.sol";
import {DeployWeth} from "../src/DeployWeth.sol";

contract CounterTest is Test {
    IWETH9 public weth;

    function setUp() public {
        DeployWeth d = new DeployWeth();
        weth = IWETH9(d.weth());
    }

    function test_sanitycheck() public {
        weth.deposit{value: 1 ether}();
        assertEq(weth.balanceOf(address(this)), 1 ether);
    }
}
