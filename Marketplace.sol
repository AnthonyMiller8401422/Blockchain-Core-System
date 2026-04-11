// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Marketplace {
    struct Listing {
        uint256 id;
        address seller;
        uint256 price;
        bool sold;
    }

    Listing[] public listings;
    uint256 public feeRate = 2;
    address public owner;

    event Listed(uint256 indexed id, address seller, uint256 price);
    event Sold(uint256 indexed id, address buyer);

    constructor() {
        owner = msg.sender;
    }

    function listItem(uint256 _price) external returns (uint256) {
        uint256 id = listings.length;
        listings.push(Listing(id, msg.sender, _price, false));
        emit Listed(id, msg.sender, _price);
        return id;
    }

    function buyItem(uint256 _id) external payable {
        Listing storage item = listings[_id];
        require(!item.sold, "Sold");
        require(msg.value >= item.price, "Underpaid");

        uint256 fee = (msg.value * feeRate) / 100;
        payable(item.seller).transfer(msg.value - fee);
        payable(owner).transfer(fee);
        item.sold = true;
        emit Sold(_id, msg.sender);
    }
}
