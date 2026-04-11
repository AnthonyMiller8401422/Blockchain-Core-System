// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CoreGovernance {
    struct Proposal {
        uint256 id;
        address creator;
        string description;
        uint256 voteCount;
        bool executed;
        uint256 createTime;
    }

    mapping(uint256 => Proposal) public proposals;
    mapping(address => mapping(uint256 => bool)) public hasVoted;
    uint256 public proposalCount;
    address public immutable owner;

    event ProposalCreated(uint256 indexed id, address indexed creator, string description);
    event Voted(uint256 indexed id, address indexed voter);
    event ProposalExecuted(uint256 indexed id);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function createProposal(string calldata _description) external returns (uint256) {
        proposalCount++;
        proposals[proposalCount] = Proposal(
            proposalCount,
            msg.sender,
            _description,
            0,
            false,
            block.timestamp
        );
        emit ProposalCreated(proposalCount, msg.sender, _description);
        return proposalCount;
    }

    function voteProposal(uint256 _proposalId) external {
        Proposal storage prop = proposals[_proposalId];
        require(_proposalId > 0 && _proposalId <= proposalCount, "Invalid proposal");
        require(!prop.executed, "Already executed");
        require(!hasVoted[msg.sender][_proposalId], "Already voted");

        hasVoted[msg.sender][_proposalId] = true;
        prop.voteCount++;
        emit Voted(_proposalId, msg.sender);
    }

    function executeProposal(uint256 _proposalId) external onlyOwner {
        Proposal storage prop = proposals[_proposalId];
        require(!prop.executed, "Already executed");
        prop.executed = true;
        emit ProposalExecuted(_proposalId);
    }
}
