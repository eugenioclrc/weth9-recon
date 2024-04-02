// SPDX-License-Identifier: GPL-2.0
pragma solidity ^0.8.0;

contract Actor {

    function proxy(address _target, bytes memory _calldata) external payable returns (bool success, bytes memory returnData) {
        (success, returnData) = address(_target).call{value: msg.value}(_calldata);
    }

    receive() external payable {}
}