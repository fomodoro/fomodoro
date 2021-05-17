// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

contract Governance {
    struct Action {
        string name;
        address[] voter;
    }

    struct Proposal {
        bytes32 title;
        string detail;
        uint startTime;
        uint endTime;
        uint blockNumber;
        bytes32[] actionList;
    }

    struct Space {
        bytes32 name;
        bytes32 symbol;
        bytes32[] proposalList; 
    }

    bytes32[] public spaceList; // list of proposal keys so we can look them up
    mapping(bytes32 => Space) private spaceStructs; // random access by space key and proposal key
    mapping (bytes32 => Proposal) private proposalStructs;     
    mapping (bytes32 => Action) private actionStructs;

    function newSpace(bytes32 _spaceKey, bytes32 _name, bytes32 _symbol) public returns (bool success) {
        // Checking dups
        spaceStructs[_spaceKey].name = _name;
        spaceStructs[_spaceKey].symbol = _symbol;
        spaceList.push(_spaceKey);
        return true;
    }

    function getSpace(bytes32 _spaceKey) public view returns (Space memory) {
        return spaceStructs[_spaceKey];
    }

    function newProposal() public {

    }

    function getProposal() public {

    }

    function getVotes() public {

    }

    function vote() public payable {

    }
}