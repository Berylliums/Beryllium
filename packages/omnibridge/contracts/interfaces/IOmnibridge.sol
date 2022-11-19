// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

interface IOmnibridge {
    function relayTokens(
        address _token,
        address _receiver,
        uint256 _value
    ) external;

    function relayTokensAndCall(
        address token,
        address _receiver,
        uint256 _value,
        bytes memory _data
    ) external;
}
