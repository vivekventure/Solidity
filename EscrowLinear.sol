// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

contract EscrowLinear {
    address payable immutable withdrawAddress;
    uint public immutable startTime;
    uint public immutable endTime;
    uint public immutable depositAmount;
    uint public ethWithdrawn;

    constructor(address payable _withdrawAddress, uint _lockTime) payable {  
        withdrawAddress = _withdrawAddress;
        startTime = block.timestamp;
        endTime = _lockTime + startTime;
        depositAmount = msg.value;
    }
    
    // either withdraw all vested ETH
    function withdrawEther() external payable { 
        require(msg.sender == withdrawAddress, "Not your ETH bro");
        if(block.timestamp < endTime) {
            uint vested = (((block.timestamp - startTime) * depositAmount) / (endTime - startTime)) - ethWithdrawn;
            ethWithdrawn += vested; 
            payable(msg.sender).transfer((vested));
        }
        else { 
            ethWithdrawn = depositAmount;
            payable(msg.sender).transfer(address(this).balance); 
        }
    }
    
    // or withdraw a specific amount of vested ETH
    function withdrawEther(uint _amount) external payable { 
        require(msg.sender == withdrawAddress, "Not your ETH bro");
        if(block.timestamp < endTime) {
            uint withdrawn = (((block.timestamp - startTime) * depositAmount) / (endTime - startTime)) - ethWithdrawn;
            require(_amount <= withdrawn, "That's more ETH than you can withdraw bro");
            ethWithdrawn += _amount;
            payable(msg.sender).transfer((_amount));
        }
        else { 
            require(_amount <= depositAmount, "Can't withdraw more than you deposited bro");
            ethWithdrawn += _amount;
            payable(msg.sender).transfer(_amount); 
        } 
    }
}