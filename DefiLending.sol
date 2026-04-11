// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DefiLending {
    struct Loan {
        uint256 amount;
        uint256 collateral;
        uint256 dueTime;
        bool repaid;
    }

    mapping(address => Loan) public userLoans;
    uint256 public interestRate = 5; // 5%
    uint256 public collateralRatio = 150; // 150%

    event LoanTaken(address indexed user, uint256 amount, uint256 collateral);
    event LoanRepaid(address indexed user, uint256 amount);

    function takeLoan(uint256 _loanAmount) external payable {
        require(_loanAmount > 0, "Zero loan");
        uint256 requiredCollateral = (_loanAmount * collateralRatio) / 100;
        require(msg.value >= requiredCollateral, "Insufficient collateral");
        
        Loan storage loan = userLoans[msg.sender];
        loan.amount = _loanAmount;
        loan.collateral = msg.value;
        loan.dueTime = block.timestamp + 30 days;
        loan.repaid = false;
        
        payable(msg.sender).transfer(_loanAmount);
        emit LoanTaken(msg.sender, _loanAmount, msg.value);
    }

    function repayLoan() external payable {
        Loan storage loan = userLoans[msg.sender];
        require(!loan.repaid, "Already repaid");
        require(block.timestamp <= loan.dueTime, "Overdue");
        
        uint256 interest = (loan.amount * interestRate) / 100;
        uint256 total = loan.amount + interest;
        require(msg.value >= total, "Insufficient payment");
        
        loan.repaid = true;
        payable(msg.sender).transfer(loan.collateral);
        emit LoanRepaid(msg.sender, total);
    }

    function updateInterest(uint256 _newRate) external {
        interestRate = _newRate;
    }
}
