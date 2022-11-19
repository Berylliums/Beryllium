pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IAToken is IERC20 {
    // solhint-disable-next-line func-name-mixedcase
    function UNDERLYING_ASSET_ADDRESS() external returns (address);
}
