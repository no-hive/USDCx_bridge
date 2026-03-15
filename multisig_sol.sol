// SPDX-License-Identifier: MIT
pragma solidity ^0.8.32;

// interface of Bridge_sol.contract
interface {}

// contract with simple federation management
contract FederationSync {

// three nodes addresses
constructor (address _federation_node_1, address _federation_node_2, address federation_node_3;) {
federation_node_1 = _federation_node_1;
federation_node_2 = _federation_node_2;
federation_node_2 = _federation_node_3;
}

address public federation_node_1;
address public federation_node_2;
address public federation_node_3;

struct ConfirmedRequestsData {
boolean transfer_made;
boolean node_1_confirmation;
boolean node_2_confirmation;
boolean node_3_confirmation;
address node_1_sender;
address node_2_sender;
address node_3_sender;
uint256 node_1_amount;
uint256 node_2_amount;
uint256 node_3_amount;
string node_1_reciever;
string node_2_reciever;
string node_3_reciever;
}

uint256 nonce

mapping (uint256 => struct)


function ConfirmRequest (address indexed sender, uint256 amount, string receiver, nonce) public {

if msg.sender = federation_node_1 then node_param = 1

if msg.sender = federation_node_2 then node_param = 2

if msg.sender = federation_node_3 then node_param = 3

else error "not a federation node"



transfer_made = 1, "transfer already made".

check if boolean 1 = boolean 2 or boolean 1 = boolean 3 or boolean 2 = boolean 3

if succuess then transfer_made = 1

send this data to contract via interface

emit event




function ChangeNode1Contract (address new_addres) {

msg.sender == federation_node_1, "no right to do so"
federation_node_1 = new_address

emit event NodeContractChanged
}
}
}
event RequestRetratranslated (msg.sender, sender, amount, receiver, nonce)

emit event NodeContractChanged (msg.sender, new_contract)
