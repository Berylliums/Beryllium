pragma solidity 0.8.17;

interface IUpgradeabilityOwnerStorage {
    function upgradeabilityOwner() external view returns (address);
}
