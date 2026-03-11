// SPDX-License-Identifier: MIT

pragma solidity ^0.8.24;

interface IERC20 {
    // function transfer(address to, uint256 value) external returns (bool);
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

contract Bridge_sol {

constructor(uint256 _own_balance, uint256 _external_balance){
    own_balance = _own_balance;
    external_balance = _external_balance;
    start_balance = _external_balance + _own_balance;
}

// keeps the balance of both contracts + their sum
uint256 public own_balance;
uint256 public external_balance;
uint256 public start_balance;

// function user initialise to create a bridge transfer request.
function BridgeRequest (uint256 amount, string memory receiver) internal {
    require(external_balance > amount , "no funds on other blockchain");
    // in the future here will be an extra action that will 
    // return money to the user if there are not enough funds

external_balance -= amount;

own_balance += amount;

emit Request_Approved(msg.sender, amount, receiver);
}

// use this function to send token to the contract. then it starts the bridge request.
function deposit(address token, uint256 amount, string memory receiver) external {
        require(amount > 0, "amount = 0");

        bool success = IERC20(token).transferFrom(msg.sender, address(this), amount);
        require(success, "transferFrom failed");

        BridgeRequest (amount, receiver);

}

//event

event Request_Approved(address indexed sender, uint256 amount, string receiver);
}