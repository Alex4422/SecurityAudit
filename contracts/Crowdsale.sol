//We should specify the licence
// SPDX-License-Identifier: MIT

//pb
//pragma solidity ^0.5.12;
pragma solidity 0.8.9;

/**
    @title Crowdsale
    @author Alex
    @notice Allows to estimate the values of goods during a crowdsale
    @dev We use an event
*/
contract Crowdsale {

    //Events
    event LogDepositReceived(address _dest);


    //pb no need of that
    //using SafeMath for uint256;

    //Variables
    address public owner; // the owner of the contract
    address public escrow; // wallet to collect raised ETH
    uint256 public savedBalance = 0; // Total amount raised in ETH
    mapping (address => uint256) public balances; // Balances in incoming Ether

    // Initialization
    /*function Crowdsale(address _escrow) public{
        //pb
        //owner = tx.origin;
        owner = msg.sender;
        // add address of the specific contract
        escrow = _escrow;
    }*/

    /**
        @author Alex
        @notice Initialises the state variables of the contract
        @param _escrow who is the escrow here?
    */
    //We must use the constructor instead a function
    constructor (address _escrow) public{
        owner = msg.sender;
        // add address of the specific contract
        escrow = _escrow;
    }

    /**
        title deposit
        @notice Saves Wei in balances associated with the address of msg.sender and in savedBalance
        reexplain please?
        @dev We use the emit of the event LogDepositReceived
    */
    // function to receive ETH
    // NOT TO USE THIS (no secure) HERE & write the visibility
    //Write emit of event here
    //function() public {
    function deposit() payable external{
        //balances[msg.sender] = balances[msg.sender].add(msg.value);
        balances[msg.sender] = balances[msg.sender] + (msg.value); //value in wei
        //savedBalance = savedBalance.add(msg.value);
        savedBalance = savedBalance + msg.value;

        //payable(escrow).send(msg.value);
        payable(escrow).transfer(msg.value);

        emit LogDepositReceived(msg.sender);
    }

    /**
        title withdrawPayments
        @notice Allow to get the money when you recover the good

    */
    // refund investor
    function withdrawPayments() public{
        address payee = msg.sender;
        uint256 payment = balances[payee];

        // to be sure the balance of investor is not equal to 0
        require(payment != 0);
        // to be sure the balance of investor is greater or equal to payment.
        require(address(this).balance >= payment);
        //We move the assignment here to avoid re-entrency
        balances[payee] = 0;

        //pb
        //payee.send(payment);

        //payee.transfer(payment);

        //Transfer is more secure than send.
        //payee must be payable to receive Ether
        payable(payee).transfer(payment);

        //savedBalance = savedBalance.sub(payment);
        //savedBalance = savedBalance(payment) - payment;
        savedBalance = savedBalance - payment;

        //pb to avoid re-entrency
        //balances[payee] = 0;
    }
}