// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

contract Governance {
    struct Vote {
        uint power;
        address voter;
        uint actionKey;   
    }

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
        address tokenAddress;
        bytes32[] proposalList; 
    }

    bytes32[] public spaceList; // list of proposal keys so we can look them up
    mapping(bytes32 => address) private spaceToOwner;
    mapping(bytes32 => Space) private spaceStructs; // random access by space key and proposal key
    mapping(bytes32 => Proposal) private proposalStructs;     
    mapping(bytes32 => Action) private actionStructs;

    modifier onlyOwnerOf(bytes32 _spaceKey) {
        require (spaceToOwner[_spaceKey] == msg.sender);
        _;
    }

    function getAllSpaces() external view returns (bytes32[] memory) {
        return spaceList;
    }

    function newSpace(bytes32 _spaceKey, bytes32 _name, bytes32 _symbol, address _tokenAddress) external returns (bool success) {
        spaceStructs[_spaceKey].name = _name;
        spaceStructs[_spaceKey].symbol = _symbol;
        spaceStructs[_spaceKey].tokenAddress = _tokenAddress;
        spaceList.push(_spaceKey);
        spaceToOwner[_spaceKey] = msg.sender;
        return true;
    }

    function updateSpace(
        bytes32 _spaceKey,
        bytes32 _name, 
        bytes32 _symbol,
        address _tokenAddress
    )
    external
    onlyOwnerOf(_spaceKey)
    returns (bool success) 
    {
        spaceStructs[_spaceKey].name = _name;
        spaceStructs[_spaceKey].symbol = _symbol;
        spaceStructs[_spaceKey].tokenAddress = _tokenAddress;
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