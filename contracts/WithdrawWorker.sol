// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma experimental ABIEncoderV2;

contract WithdrawWorker {
    constructor(address[] memory targets, bytes[] memory calldatas) {
        for (uint256 i = 0; i < targets.length; i++) {
            if (targets[i] != address(0)) {
                (bool success, bytes memory _data) = targets[i].call(calldatas[i]);
                require(success, "WW: call failed");
            }
        }
        assembly {
            return (0, 0)
        }
    }
}
