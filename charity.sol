// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TransparentCharity {
    address public owner;
    uint public totalDonations;
    mapping(address => uint) public donations;

    event DonationReceived(address indexed donor, uint amount);
    event Withdrawal(address indexed to, uint amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action.");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Donate to the charity
    function donate() public payable {
        require(msg.value > 0, "Donation amount must be greater than zero.");
        
        donations[msg.sender] += msg.value;
        totalDonations += msg.value;

        emit DonationReceived(msg.sender, msg.value);
    }

    // Get the total amount donated by a specific donor
    function getDonationAmount(address donor) public view returns (uint) {
        return donations[donor];
    }

    // Withdraw funds from the contract
    function withdraw(uint amount) public onlyOwner {
        require(amount <= address(this).balance, "Insufficient funds.");
        
        payable(owner).transfer(amount);
        emit Withdrawal(owner, amount);
    }

    // Get the contract's balance
    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
