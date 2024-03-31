
// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseSetup} from "@chimera/BaseSetup.sol";
import {IWETH9} from "src/IWETH9.sol";
import {DeployWeth} from "src/DeployWeth.sol";

abstract contract Setup is BaseSetup {

    IWETH9 public weth;

    function setup() internal virtual override {
        DeployWeth d = new DeployWeth();
        weth = IWETH9(d.weth());
    }
}