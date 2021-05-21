// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

interface IStrategy {
    function getVotingPower(address _account) external view returns (uint);
}