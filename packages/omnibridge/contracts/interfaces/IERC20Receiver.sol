pragma solidity 0.8.17;

interface IERC20Receiver {
    function onTokenBridged(
        address token,
        uint256 value,
        bytes calldata data
    ) external;
}
