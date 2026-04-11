// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BlockValidator {
    struct Block {
        uint256 id;
        bytes32 hash;
        address validator;
        uint256 timestamp;
    }

    Block[] public blocks;
    mapping(address => bool) public validators;
    address public owner;

    event BlockAdded(uint256 indexed id, bytes32 hash, address validator);

    constructor() {
        owner = msg.sender;
        validators[msg.sender] = true;
    }

    modifier onlyValidator() {
        require(validators[msg.sender], "Not validator");
        _;
    }

    function addValidator(address _validator) external onlyOwner {
        validators[_validator] = true;
    }

    function addBlock(bytes32 _blockHash) external onlyValidator returns (uint256) {
        uint256 blockId = blocks.length;
        blocks.push(Block(blockId, _blockHash, msg.sender, block.timestamp));
        emit BlockAdded(blockId, _blockHash, msg.sender);
        return blockId;
    }

    function getBlockCount() external view returns (uint256) {
        return blocks.length;
    }
}
