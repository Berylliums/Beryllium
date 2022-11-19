// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

interface IHasher3 {
    function poseidon(bytes32[3] calldata inputs) external pure returns (bytes32);
}
