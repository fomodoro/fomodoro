// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "./interfaces/IStrategy.sol";
import "./interfaces/IBEP20.sol";

contract Governance {
    struct Voter {
        uint256 power;
        address voter;
        uint256 choiceIndex;
    }

    struct Proposal {
        string txHash;
        uint256 startTime;
        uint256 endTime;
        uint256 blockNumber;
        uint256 numberOfChoices;
        uint256 voteCount;
        Voter[] voterList;
    }

    struct Space {
        bytes32 name;
        bytes32 symbol;
        IBEP20 token;
        IStrategy strategy;
        bytes32[] proposalList;
    }

    bytes32[] public spaceList; // list of proposal keys so we can look them up
    mapping(bytes32 => address) private spaceToOwner;
    mapping(bytes32 => Space) private spaceStructs; // random access by space key and proposal key
    mapping(bytes32 => Proposal) private proposalStructs; // proposalId => Proposal
    mapping(bytes32 => Voter) private voterStructs;
    mapping(bytes32 => bool) private voted; // check if address has voted for a proposal by hash(address, proposalId)
    mapping(bytes32 => bytes32) private proposalToSpace; // proposalId => space contains that proposal

    modifier onlyOwnerOf(bytes32 _spaceKey) {
        require(spaceToOwner[_spaceKey] == msg.sender);
        _;
    }

    function getAllSpaces() external view returns (bytes32[] memory) {
        return spaceList;
    }

    function newSpace(
        bytes32 _spaceKey,
        bytes32 _name,
        bytes32 _symbol,
        IBEP20 _token,
        IStrategy _strategy
    ) external returns (bool success) {
        spaceStructs[_spaceKey].name = _name;
        spaceStructs[_spaceKey].symbol = _symbol;
        spaceStructs[_spaceKey].token = _token;
        spaceStructs[_spaceKey].strategy = _strategy;
        spaceList.push(_spaceKey);
        spaceToOwner[_spaceKey] = msg.sender;
        return true;
    }

    function updateSpace(
        bytes32 _spaceKey,
        bytes32 _name,
        bytes32 _symbol,
        IBEP20 _token,
        IStrategy _strategy
    ) external onlyOwnerOf(_spaceKey) returns (bool success) {
        spaceStructs[_spaceKey].name = _name;
        spaceStructs[_spaceKey].symbol = _symbol;
        spaceStructs[_spaceKey].token = _token;
        spaceStructs[_spaceKey].strategy = _strategy;
        return true;
    }

    function getSpace(bytes32 _spaceKey) external view returns (Space memory) {
        return spaceStructs[_spaceKey];
    }

    function getProposals(bytes32 _spaceKey) external view returns (bytes32[] memory) {
        return spaceStructs[_spaceKey].proposalList;
    }

    function getProposal(bytes32 _proposalKey) external view returns (Proposal memory) {
        return proposalStructs[_proposalKey];
    }

    function newProposal(
        bytes32 _spaceKey,
        bytes32 _proposalId,
        string memory _txHash,
        uint256 _startTime,
        uint256 _endTime,
        uint256 _blockNumber,
        uint8 _numberOfChoices
    ) public {
        // require(spaceStructs[_spaceKey].tokenAddress != address(0));

        proposalStructs[_proposalId].txHash = _txHash;
        proposalStructs[_proposalId].startTime = _startTime;
        proposalStructs[_proposalId].endTime = _endTime;
        proposalStructs[_proposalId].blockNumber = _blockNumber;
        proposalStructs[_proposalId].numberOfChoices = _numberOfChoices;
        proposalToSpace[_proposalId] = _spaceKey;

        spaceStructs[_spaceKey].proposalList.push(_proposalId);
    }

    function getVoter(bytes32 _voterKey) external view returns (Voter memory) {
        return voterStructs[_voterKey];
    }

    function vote(bytes32 _proposalId, uint256 choiceIndex) public payable {
        // check if voted 
        require(voted[keccak256(abi.encodePacked(msg.sender, _proposalId))] == false, "Already voted");

        // TODO: check ended
        
        // get voting power
        // bytes32 spaceKey = proposalToSpace[_proposalId];
        // Space memory space = spaceStructs[spaceKey];
        // uint256 power = space.strategy.getVotingPower(msg.sender, space.token);
        uint power = 10;

        // vote
        Voter memory voter = Voter(power, msg.sender, choiceIndex);
        proposalStructs[_proposalId].voterList.push(voter);
        proposalStructs[_proposalId].voteCount += voter.power;
        voted[keccak256(abi.encodePacked(msg.sender, _proposalId))] = true;
    }
}
