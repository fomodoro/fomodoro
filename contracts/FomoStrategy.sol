// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "./interfaces/IBEP20.sol";
import "./interfaces/IStrategy.sol";

contract FomoStrategy is IStrategy {
    function getVotingPower(address _account, IBEP20 _token) external view override returns (uint) {
        return _token.balanceOf(_account);
    }
}