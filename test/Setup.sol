// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseSetup} from "@chimera/BaseSetup.sol";
import {IWETH9} from "src/IWETH9.sol";
import {DeployWeth} from "src/DeployWeth.sol";

import {TOTAL_ETHER_IN_SYSTEM} from "./Constants.sol";

abstract contract Setup is BaseSetup {
    IWETH9 public iWETH9;

    function setup() internal virtual override {
        DeployWeth d = new DeployWeth();
        iWETH9 = IWETH9(d.weth());

        /// @dev lets ensure we start with TOTAL_ETHER_IN_SYSTEM, should be 3_000_000 ether
        require(address(this).balance == TOTAL_ETHER_IN_SYSTEM, "wrong start balance");

    }
}
