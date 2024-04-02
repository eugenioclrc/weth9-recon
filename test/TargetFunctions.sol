// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

import {BaseTargetFunctions} from "@chimera/BaseTargetFunctions.sol";
import {BeforeAfter} from "./BeforeAfter.sol";
import {Properties} from "./Properties.sol";
import {vm} from "@chimera/Hevm.sol";
import {Actor} from "./Actor.sol";

import {TOTAL_ETHER_IN_SYSTEM} from "./Constants.sol";

abstract contract TargetFunctions is BaseTargetFunctions, Properties, BeforeAfter {
  Actor[] internal _actors;
  mapping(Actor => bool) _isActor;

  Actor currentActor;
  
  function _addActor(Actor actor) internal {
    _actors.push(actor);
    _isActor[actor] = true;
  }

  modifier _createOrSelectActor(uint256 _rand) {
    
    if (_actors.length < 100 && address(this).balance > 0) {
      Actor actor = new Actor();
      _addActor(actor);
      uint256 balance = _rand % address(this).balance;

      address(actor).call{value: balance}("");
    }

    currentActor = _actors[_rand % _actors.length];
    _;

  }
  
  modifier _updateBeforeAfter() {
        __before();
        _;
        __after();
    }

    function assertTotalSupply_test() public {
      lte(_before.iWETH9_totalSupply, TOTAL_ETHER_IN_SYSTEM, "totalSupply");

      uint256 actorsBalance;
      uint256 actorsWethBalance;
      for(uint256 i = 0; i < _actors.length; i++) {
        actorsBalance += address(_actors[i]).balance;
        actorsWethBalance += iWETH9.balanceOf(address(_actors[i]));
      }

      eq(actorsBalance + address(this).balance + address(iWETH9).balance, TOTAL_ETHER_IN_SYSTEM, "sum balance should be constant");
      eq(actorsWethBalance + iWETH9.balanceOf(address(this)), iWETH9.totalSupply(), "sum of all weth should be equal to total supply");
      eq(iWETH9.totalSupply(), address(iWETH9).balance, "weth balance should be equal to total supply");
    }
    
    function iWETH9_deposit(uint256 amount, uint256 _rand) public _updateBeforeAfter _createOrSelectActor(_rand) {
      bool willWork = address(currentActor).balance >= amount;
      (bool s, ) = currentActor.proxy{value: amount}(address(iWETH9), abi.encodeWithSignature("deposit()"));
      
      t(s, "deposit should work");
    }
    
    function iWETH9_approve(address guy, uint256 wad, uint256 _rand) _createOrSelectActor(_rand) public {
        // iWETH9.approve(guy, wad);
        (bool s, ) = currentActor.proxy(address(iWETH9), abi.encodeWithSignature("approve(address,uint256)", guy, wad));
        t(s, "approve should always pass");
    }

    function iWETH9_transfer(address dst, uint256 wad, uint256 _rand) public _updateBeforeAfter _createOrSelectActor(_rand) {
        bool willWork = iWETH9.balanceOf(address(currentActor)) >= wad;
        (bool s, ) = currentActor.proxy(address(iWETH9), abi.encodeWithSignature("transfer(address,uint256)", dst, wad));
        if(willWork) {
          t(s, "weth transfer should  pass");
        } else {
          t(!s, "weth transfer should  fail");
        }
    }

    function iWETH9_transferFrom(address src, uint256 _dst, uint256 wad, uint256 _rand) public _updateBeforeAfter _createOrSelectActor(_rand) {
        address dst = address(_actors[_dst % _actors.length]);
        bool willWork = iWETH9.balanceOf(address(src)) >= wad && iWETH9.allowance(src, address(this)) >= wad;
        
        (bool s, ) = currentActor.proxy(address(iWETH9), abi.encodeWithSignature("transferFrom(address,address,uint256)", src, dst, wad));
        if(willWork) {
          t(s, "weth transferFrom should  pass");
        } else {
          t(!s, "weth transferFrom should  fail");
        } 
    }

    function iWETH9_withdraw(uint256 wad, uint256 _rand) public _updateBeforeAfter _createOrSelectActor(_rand) {
      uint256 balanceBeforeWETH = iWETH9.balanceOf(address(currentActor));
      uint256 balanceBefore = address(currentActor).balance;
      
      bool willWork = balanceBeforeWETH >= wad;

      (bool s, ) = currentActor.proxy(address(iWETH9), abi.encodeWithSignature("withdraw(uint256)", wad));
      
      if(willWork) {
        t(s, "weth withdraw should  pass");
        lte(balanceBeforeWETH - wad, iWETH9.balanceOf(address(currentActor)), "balance should decrease");
        eq(balanceBefore + wad, address(currentActor).balance, "balance should increase");
      } else {
        t(!s, "weth withdraw should  fail");
        eq(balanceBefore, address(currentActor).balance, "balance should not change");
        eq(balanceBeforeWETH, iWETH9.balanceOf(address(currentActor)), "balance should not change");
      }
    }
    receive() external payable {}
}
