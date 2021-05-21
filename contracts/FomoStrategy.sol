// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FomoStrategy is Ownable {
    IERC20 token;

    function updateToken(IERC20 _token) external onlyOwner returns (bool success) {
       token = _token;
       return true;
    }

    function getVotingPower(address _account) external view returns (uint) {
        return token.balanceOf(_account);
    }
}