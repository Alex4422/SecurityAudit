/**
    @dev We should specify the licence
*/
// SPDX-License-Identifier: MIT

/**
    @dev We should specify a specific version of solidity
*/
pragma solidity 0.8.9;

/**
    @title Crowdsale
    @author Alex
    @notice Allows to estimate the values of goods during a crowdsale
    @dev We use an event
*/
contract Crowdsale {

    /**
        @dev It's recommended to write events
    */
    event LogDepositReceived(address _dest);
    event RefundInvestors(address _investor, uint256 _amountRefund, uint _dateRefund);

    /**
        @dev With the update of solidity, we don't have to write this anymore
    */
    //using SafeMath for uint256;

    address public owner; // the owner of the contract
    address public escrow; // wallet to collect raised ETH
    uint256 public totalDeposit = 0; // Total amount raised in ETH
    
    mapping (address => uint256) public balances; // Balances in incoming Ether

    /**
        @author Alex
        @notice Initialises the state variables of the contract
        @param _escrow who is the escrow here?
        @dev We must use the constructor instead a function (i.e. function Crowdsale)
    */
    constructor (address _escrow) public{
        owner = msg.sender;
        // add address of the specific contract
        escrow = _escrow;
    }

    /**
        @notice Saves Wei in balances associated with the address of msg.sender and in totalDeposit
        @dev We use the emit of the event LogDepositReceived. Do not use function() public & write the visibility.
             We have to declare the function payable to receive Ether
    */
    //it is more appropriate to use receive Ether function here
    receive() payable external {
        //We use + instead of add
        balances[msg.sender] = balances[msg.sender] + (msg.value); //value in wei
        totalDeposit = totalDeposit + msg.value;

        //it's more safe to use the function transfer here
        payable(escrow).transfer(msg.value);

        emit LogDepositReceived(msg.sender);
    }

    /**
        @notice Allow to get the money when you recover the good : refund investor
    */
    function withdrawPayments() public{
        address payee = msg.sender;
        uint256 payment = balances[payee];

        // to be sure the balance of investor is not equal to 0
        require(payment != 0);
        // to be sure the balance of investor is greater or equal to payment.
        require(address(this).balance >= payment);
        //We move the assignment here to avoid re-entrency
        balances[payee] = 0;

        //Transfer is more secure than send function. Payee must be payable to receive Ethers
        payable(payee).transfer(payment);

        //We use - instead of sub
        totalDeposit = totalDeposit - payment;

        emit RefundInvestors(payee,payment,block.timestamp);
    }
}