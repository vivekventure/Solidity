// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Very simple Ether wallet for keeping ETH in a contract vs in an EOA; basic building block 1
contract EtherWallet {
    mapping (address => uint) userBalance;

    function depositEther() public payable {  
        userBalance[msg.sender] += msg.value; 
    } 

    function viewBalance(address _addr) external view returns (uint) {
        return userBalance[_addr];
    }

    // unnecessary function b/c can look up contract address on etherscan but oh well
    function walletBalance() public view returns (uint) {
        return address(this).balance;
    }

    // removed nonReentrant modifier, used CEI pattern instead
    function withdrawEther(uint _amount) external payable {        
        require(userBalance[msg.sender] >= _amount, "Can't withdraw more ETH than you have");
        userBalance[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    } 
}