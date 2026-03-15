// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * Standard ERC-20 interface. Used to interact with the USDC token contract:
 * transferFrom pulls tokens from the user into this contract on Deposit,
 * transfer sends tokens out to the recipient on Transfer.
 */
interface IERC20 {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

/**
 * @title  Simple USDC Stacks-Base Bridge
 * @author no-hive
 * @notice This contract is for testing purposes only.
 *         Production version must use SafeERC20.
 */
contract Bridge_sol {

    /**
     * Tracks the USDC balance held on this chain (own_balance)
     * and the mirrored balance available on the other chain (external_balance).
     * start_balance is recorded at deployment for accounting reference.
     */
    uint256 public own_balance;
    uint256 public external_balance;
    uint256 public start_balance;

    /**
     * Incremented on each Deposit to uniquely identify every bridge request.
     * Off-chain nodes use this nonce to match events across chains.
     */
    uint256 public nonce;

    /**
     * Address of the USDC ERC-20 token contract on this chain.
     */
    address public token;

    /**
     * Address of the FederationSync multisig contract.
     * Only this address is authorized to call Transfer().
     */
    address public multisig_contract;

    constructor(
        uint256 _own_balance,
        uint256 _external_balance,
        address _token,
        address _multisig_contract
    ) {
        own_balance       = _own_balance;
        external_balance  = _external_balance;
        start_balance     = _external_balance + _own_balance;
        token             = _token;
        multisig_contract = _multisig_contract;
        nonce             = 0;
    }

    /**
     * Validates that the other chain has sufficient funds to cover the transfer,
     * then updates the internal balance accounting and emits Request_Approved
     * to signal off-chain nodes to complete the transfer on the other chain.
     */
    function BridgeRequest(uint256 amount, string memory receiver) internal {
        require(external_balance > amount, "Insufficient funds on destination chain");
        external_balance -= amount;
        own_balance      += amount;
        emit Request_Approved(msg.sender, amount, receiver, nonce);
        nonce += 1;
    }

    /**
     * Entry point for users who want to bridge tokens to the other chain.
     * Pulls USDC from the caller's wallet into this contract,
     * then triggers BridgeRequest to update balances and notify the nodes.
     */
    function Deposit(uint256 amount, string memory receiver) external {
        require(amount > 0, "Amount must be greater than zero");
        bool success = IERC20(token).transferFrom(msg.sender, address(this), amount);
        require(success, "transferFrom failed");
        BridgeRequest(amount, receiver);
    }

    /**
     * Called exclusively by the FederationSync multisig contract
     * after 2-of-3 nodes reach consensus on a cross-chain transfer.
     * Sends USDC from this contract's balance to the recipient on this chain.
     */
    function Transfer(address recipient, uint256 amount) external {
        require(multisig_contract == msg.sender, "Caller is not the multisig contract");
        bool success = IERC20(token).transfer(recipient, amount);
        require(success, "Token transfer failed");
    }

    /**
     * Emitted by BridgeRequest to notify off-chain federation nodes
     * that a user has deposited funds and a cross-chain transfer should begin.
     * Nodes listen for this event and call confirmRequest() on FederationSync.
     */
    event Request_Approved(
        address indexed sender,
        uint256 amount,
        string  receiver,
        uint256 nonce
    );
}
