// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

// Building upon Ether wallet and adding approvals
contract EtherWalletApproval {
    mapping (address => uint) public userBalance;
    mapping (address => mapping (address => uint)) public approvedAmt;  // Double mapping for approved amounts

    function depositEther() public payable {  
        userBalance[msg.sender] += msg.value; 
    }

    function walletBalance() public view returns (uint) {   // Don't need this function b/c can look up contract address on etherscan but oh well
        return address(this).balance;
    }

    function withdrawEther(uint _amount) external payable {        
        require(userBalance[msg.sender] >= _amount, "Can't withdraw more ETH than you have, bozo");
        userBalance[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount); 
    }

    function approveSpend(address _addr, uint _amt) external {
        approvedAmt[msg.sender][_addr] = _amt;
    }

    function withdrawOtherEther(address _addr, uint _amt) external payable {
        require(_amt <= approvedAmt[_addr][msg.sender], "You don't have that much ETH left to spend!");
        userBalance[_addr] -= _amt;
        approvedAmt[_addr][msg.sender] -= _amt;
        payable(msg.sender).transfer(_amt);
    }
}
    // some questions and takeaways:
    // can you cycle through a mapping to see all user balances? or see how many addresses in a mapping? NO - GENERALLY DON'T NEED TO AND NEED STRUCT / ARRAY IF SO
    // reentrancy: checks (require), effects (what balances change), interactions (transfer)
    // reentrancy issue: contract within withdraw() can call another withdraw()
    // approval will generally use double mapping as a standard
    // double mapping: from first, then to
    // modifier _; means where rest of function takes place; could be beginning of function vs end of function 


