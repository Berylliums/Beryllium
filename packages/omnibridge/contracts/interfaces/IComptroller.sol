pragma solidity 0.8.17;

interface IComptroller {
    function claimComp(
        address[] calldata holders,
        address[] calldata cTokens,
        bool borrowers,
        bool suppliers
    ) external;

    function compAccrued(address holder) external view returns (uint256);
}
