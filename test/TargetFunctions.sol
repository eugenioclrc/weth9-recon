// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {BeforeAfter} from "./BeforeAfter.sol";
import {Properties} from "./Properties.sol";
import {vm} from "@chimera/Hevm.sol";

abstract contract TargetFunctions is BaseTargetFunctions, Properties, BeforeAfter {
    modifier _updateBeforeAfter() {
        __before();
        _;
        __after();
    }

    function assertTotalSupply() public {
        uint256 b = _before.iWETH9_totalSupply;
        uint256 a = _after.iWETH9_totalSupply;

        /// the follow invariants shouyld be triggered
        eq(iWETH9.totalSupply(), b, "totalSupply broken");
        eq(a, b, "totalSupply broken");
    }

    function iWETH9_deposit() public _updateBeforeAfter {
        iWETH9.deposit{value: 1}();
    }

    function iWETH9_approve(address guy, uint256 wad) public {
        iWETH9.approve(guy, wad);
    }

    function iWETH9_transfer(address dst, uint256 wad) public {
        iWETH9.transfer(dst, wad);
    }

    function iWETH9_transferFrom(address src, address dst, uint256 wad) public {
        iWETH9.transferFrom(src, dst, wad);
    }

    function iWETH9_withdraw(uint256 wad) public {
        iWETH9.withdraw(wad);
    }
}
