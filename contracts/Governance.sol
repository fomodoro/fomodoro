// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "./interfaces/IStrategy.sol";

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
        address tokenAddress;
        bytes32[] proposalList;
        IStrategy strategy;
    }

    bytes32[] public spaceList; // list of proposal keys so we can look them up
    mapping(bytes32 => address) private spaceToOwner;
    mapping(bytes32 => Space) private spaceStructs; // random access by space key and proposal key
    mapping(bytes32 => Proposal) private proposalStructs; // proposalId => Proposal
    // mapping(bytes32 => Voter) private voteStructs;
    mapping(address => mapping(bytes32 => bool)) private voted; // check if address has voted for a proposal
    mapping(bytes32 => Space) private proposalToSpace; // proposalId => space contains that proposal

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
        address _tokenAddress,
        IStrategy _strategy
    ) external returns (bool success) {
        spaceStructs[_spaceKey].name = _name;
        spaceStructs[_spaceKey].symbol = _symbol;
        spaceStructs[_spaceKey].tokenAddress = _tokenAddress;
        spaceStructs[_spaceKey].strategy = _strategy;
        spaceList.push(_spaceKey);
        spaceToOwner[_spaceKey] = msg.sender;
        return true;
    }

    function updateSpace(
        bytes32 _spaceKey,
        bytes32 _name,
        bytes32 _symbol,
        address _tokenAddress,
        IStrategy _strategy
    ) external onlyOwnerOf(_spaceKey) returns (bool success) {
        spaceStructs[_spaceKey].name = _name;
        spaceStructs[_spaceKey].symbol = _symbol;
        spaceStructs[_spaceKey].tokenAddress = _tokenAddress;
        spaceStructs[_spaceKey].strategy = _strategy;
        return true;
    }

    function getSpace(bytes32 _spaceKey) public view returns (Space memory) {
        return spaceStructs[_spaceKey];
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
        // spaceStructs[_spaceKey].proposalList.push(_proposalId);
        proposalToSpace[_proposalId] = spaceStructs[_spaceKey];
    }

    // function getProposal(bytes32 _proposalId)
    //     public
    //     view
    //     returns (Proposal memory)
    // {
    //     return proposalStructs[_proposalId];
    // }

    // function getVotes() public {}

    function vote(bytes32 _proposalId, uint256 choiceIndex) public payable {
        // check if voted 
        require(voted[msg.sender][_proposalId] == true, "Already voted");

        // TODO: check ended
        
        // get voting power
        uint256 power = 10;
        // uint256 power = proposalToSpace[_proposalId].strategy.getVotingPower(msg.sender);

        // vote
        Voter memory voter = Voter(power, msg.sender, choiceIndex);
        proposalStructs[_proposalId].voterList.push(voter);
        proposalStructs[_proposalId].voteCount += voter.power;
        voted[msg.sender][_proposalId] = true;
    }
}
