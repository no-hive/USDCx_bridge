// SPDX-License-Identifier: MIT

pragma solidity ^0.8.32;

interface IERC20 {
    /**
     * Transfers `amount` tokens from `sender` to `recipient`.
     * This function is used to transfer USDC tokens from user
     * wallet to smart contract balance. 
     */
    function transferFrom(address from, address to, uint256 value) external returns (bool);
}

    /**
     * @title Simple USDC Stacks-Base Bridge
     * @author no-hive
     * This contract is for testing purposes only.
     * Production version must use SafeTransfer.
     */
contract Bridge_sol {

    constructor(uint256 _own_balance, uint256 _external_balance){
        own_balance = _own_balance;
        external_balance = _external_balance;
        start_balance = _external_balance + _own_balance;
        nonce = 0;
    }

    // Keeps the balance of both contracts
    uint256 public own_balance;
    uint256 public external_balance;
    uint256 public start_balance;
    uint256 public nonce;

    /**
     * Handles the check of bridge contracts balances.
     * This function is called internally to manage the transfer process.
     */
    function BridgeRequest (uint256 amount, string memory receiver) internal {
        require(external_balance > amount , "no funds on other blockchain");
        /**
         * In the future here will be an extra action that will
         * return money to the user if there are not enough funds
         */
        external_balance -= amount;
        own_balance += amount;
        emit Request_Approved(msg.sender, amount, receiver, nonce);
        nonce += 1;
    }

    /**
     * Deposits tokens into the bridge contract.
     * This function is used to initiate a transfer of tokens from the 
     * current chain to another chain.
     */
    function deposit(address token, uint256 amount, string memory receiver) external {
        require(amount > 0, "amount = 0");
        bool success = IERC20(token).transferFrom(msg.sender, address(this), amount);
        require(success, "transferFrom failed");
        BridgeRequest (amount, receiver);
    }
    
    /**
     * Is used as a signal for off-chain nodes to call a 
     * function to complete the trasfer on another blockchain
     * This event is triggered when the `BridgeRequest` function is called.
     */
    event Request_Approved(address indexed sender, uint256 amount, string receiver, uint256 nonce);
}
