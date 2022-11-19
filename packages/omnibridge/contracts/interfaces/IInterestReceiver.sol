pragma solidity 0.8.17;

interface IInterestReceiver {
    function onInterestReceived(address _token) external;
}
