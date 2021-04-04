// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

contract Inheritance {
    /* State Variables*/
    address payable public owner;
    address payable public inheritor;
    uint256 public inheritableAmount;
    uint256 lastDepositTime;
    uint256 timeLimit = 2628000; // 1 Months = 2628000 seconds

    /* Modifiers */
    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "This function is restricted to the contract's owner"
        );
        _;
    }

    modifier onlyInheritor() {
        require(
            msg.sender == inheritor,
            "This function is restricted to the contract's inheritor"
        );
        _;
    }

    /* Constructor */
    constructor() {
        owner = payable(msg.sender);
        lastDepositTime = block.timestamp;
    }

    /* Set Inheritor
    Sets the address of the inheritor
     */
    function setInheritor(address payable inheritorAddress) public onlyOwner {
        inheritor = inheritorAddress;
    }

    /* Deposit Inheritance
    Owner deposits ETH into the smart contract, and the value deposity is stored in inheritable Amunt
     */
    function depositInheritance() public payable onlyOwner {
        require(
            msg.value >= 0,
            "Deposit amount must be greater than or equals to 0"
        );
        inheritableAmount += msg.value;
        lastDepositTime = block.timestamp;
    }

    /* Withdraw Inheritance
    Owner withdraws ETH from the smart contract, and the value deposity is stored in inheritable Amunt
     */
    function withdrawInheritance(uint256 withdrawAmount) public onlyOwner {
        require(
            withdrawAmount >= 0,
            "Withdraw amount must be greater than or equals to 0"
        );
        require(
            withdrawAmount <= inheritableAmount,
            "Withdraw amount must be less than or equals to deposited amount"
        );

        inheritableAmount -= withdrawAmount;
        inheritor.transfer(withdrawAmount);
    }

    /* Inherit
    Allows inheritor to seize the funds of the smart contract after time limit has passed.
     */
    function inherit() public onlyInheritor {
        require(msg.sender == inheritor, "You are not the inheritor!");
        require(
            block.timestamp - lastDepositTime > timeLimit,
            "Time Limit is not up yet"
        );

        owner = inheritor;
    }
}
