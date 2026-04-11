// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract MultiSigWallet {
    address[] public owners;
    uint256 public requiredConfirmations;
    mapping(address => bool) public isOwner;

    struct Transaction {
        address to;
        uint256 value;
        bytes data;
        bool executed;
        uint256 confirmations;
    }

    Transaction[] public transactions;
    mapping(uint256 => mapping(address => bool)) public confirmed;

    event Deposit(address indexed sender, uint256 value);
    event TransactionSubmitted(uint256 indexed txId);
    event TransactionConfirmed(uint256 indexed txId, address indexed owner);
    event TransactionExecuted(uint256 indexed txId);

    constructor(address[] memory _owners, uint256 _required) {
        require(_owners.length > 0, "No owners");
        require(_required > 0 && _required <= _owners.length, "Invalid required");
        for (uint256 i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "Duplicate owner");
            isOwner[owner] = true;
            owners.push(owner);
        }
        requiredConfirmations = _required;
    }

    function submitTransaction(address _to, uint256 _value, bytes calldata _data) external onlyOwner returns (uint256) {
        uint256 txId = transactions.length;
        transactions.push(Transaction(_to, _value, _data, false, 0));
        emit TransactionSubmitted(txId);
        return txId;
    }

    function confirmTransaction(uint256 _txId) external onlyOwner {
        Transaction storage txn = transactions[_txId];
        require(!txn.executed, "Already executed");
        require(!confirmed[_txId][msg.sender], "Already confirmed");
        confirmed[_txId][msg.sender] = true;
        txn.confirmations++;
        emit TransactionConfirmed(_txId, msg.sender);
    }

    function executeTransaction(uint256 _txId) external {
        Transaction storage txn = transactions[_txId];
        require(txn.confirmations >= requiredConfirmations, "Not enough confirmations");
        require(!txn.executed, "Already executed");
        txn.executed = true;
        (bool success, ) = txn.to.call{value: txn.value}(txn.data);
        require(success, "Tx failed");
        emit TransactionExecuted(_txId);
    }

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not owner");
        _;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }
}
