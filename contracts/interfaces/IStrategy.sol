// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "./IBEP20.sol";

interface IStrategy {
    function getVotingPower(address _account, IBEP20 _token) external view returns (uint);
}