// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FlashLoanExecutor {
    address public lender;
    uint256 public feeRate = 1;

    event FlashLoanExecuted(uint256 amount, uint256 fee);

    constructor(address _lender) {
        lender = _lender;
    }

    function executeFlashLoan(uint256 _amount) external {
        uint256 fee = (_amount * feeRate) / 100;
        uint256 total = _amount + fee;

        (bool success, ) = lender.call(abi.encodeWithSignature("flashLoan(uint256)", _amount));
        require(success, "Flashloan failed");

        payable(lender).transfer(total);
        emit FlashLoanExecuted(_amount, fee);
    }

    receive() external payable {}
}
