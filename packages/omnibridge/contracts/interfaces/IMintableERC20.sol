pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IMintableERC20 is IERC20 {
    function mint(uint256 value) external;
}
