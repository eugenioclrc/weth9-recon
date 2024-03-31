// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {Setup} from "./Setup.sol";

abstract contract BeforeAfter is Setup {

    struct Vars {
        //uint256 iWETH9_allowance;
        //uint256 iWETH9_balanceOf;
        uint256 iWETH9_totalSupply;
    }

    Vars internal _before;
    Vars internal _after;

    function __before() internal {
        //_before.iWETH9_allowance = iWETH9.allowance();
        //_before.iWETH9_balanceOf = iWETH9.balanceOf();
        _before.iWETH9_totalSupply = iWETH9.totalSupply();
    }

    function __after() internal {
        //_after.iWETH9_allowance = iWETH9.allowance();
        //_after.iWETH9_balanceOf = iWETH9.balanceOf();
        _after.iWETH9_totalSupply = iWETH9.totalSupply();
    }
}