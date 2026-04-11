// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TokenTimelock {
    address public beneficiary;
    uint256 public releaseTime;
    address public token;

    constructor(address _token, address _beneficiary, uint256 _releaseTime) {
        require(_releaseTime > block.timestamp, "Past time");
        token = _token;
        beneficiary = _beneficiary;
        releaseTime = _releaseTime;
    }

    function release() external {
        require(block.timestamp >= releaseTime, "Not yet");
        require(msg.sender == beneficiary, "Not beneficiary");

        (bool success, ) = token.call(abi.encodeWithSignature("transfer(address,uint256)", beneficiary, address(this).balance));
        require(success, "Transfer failed");
    }

    receive() external payable {}
}
