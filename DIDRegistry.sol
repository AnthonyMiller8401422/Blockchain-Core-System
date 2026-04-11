// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DIDRegistry {
    struct DID {
        string document;
        address controller;
        uint256 created;
        bool active;
    }

    mapping(string => DID) public dids;
    event DIDCreated(string indexed did, address controller);
    event DIDUpdated(string indexed did, string newDocument);

    function createDID(string calldata _did, string calldata _document) external {
        require(dids[_did].controller == address(0), "DID exists");
        dids[_did] = DID(_document, msg.sender, block.timestamp, true);
        emit DIDCreated(_did, msg.sender);
    }

    function updateDID(string calldata _did, string calldata _newDoc) external {
        DID storage did = dids[_did];
        require(did.controller == msg.sender, "Not controller");
        did.document = _newDoc;
        emit DIDUpdated(_did, _newDoc);
    }

    function deactivateDID(string calldata _did) external {
        DID storage did = dids[_did];
        require(did.controller == msg.sender, "Not controller");
        did.active = false;
    }
}
