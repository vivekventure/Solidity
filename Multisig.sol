// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { ERC20 } from "solmate/tokens/ERC20.sol";  // import Solmate for ERC20 transfer

contract Multisig {             // Generalized multisig to submit an eth withdrawal or erc20 withdrawal transaction

    address public immutable owner;

    // signer variables    
    mapping (address => bool) public isSigner;
    uint internal numSignersRequired;
    uint public totalNumberOfSigners;

    // txId counter and txSigned mapping from txID to signer address to true/false if signed 
    uint internal txId;
    mapping (uint => mapping(address => bool)) public txSigned;

    struct Tx {
        uint numSigned;
        address withdrawAddy;
        address erc20Addy;      
        uint withdrawAmt;
        bool isExec;
    }

    mapping (uint => Tx) public txs;

    constructor(address[] memory _signers, uint _numSigners) payable {  
        require(msg.value == 10 ether, "Gotta send 10 ETH to launch this multisig");       // start w 10 ETH for this multisig example; can remove this for more generalized multisig
        owner = msg.sender;                                                         // owner has god mode for multisig

        for(uint i; i < _signers.length; i++) {             
            address addr = _signers[i];                             // take in aray of signers, cycle through to add to isSigner mapping
            require(!isSigner[addr], "Can't have duplicate addresses broski");  
            isSigner[addr] = true;
            totalNumberOfSigners++;
        }
        require(_numSigners > 0, "Can't have zero signers");
        require(_numSigners <= totalNumberOfSigners, "Can't have more signers than you provided dude");
        numSignersRequired = _numSigners;                                               // set initial # of signers
    }

    receive() external payable {}                

    function proposeTx(uint _amount, address _withdrawAddy) public returns (uint) {        // anyone should be able to propose a withdrawal and specify amount and address (for ETH)
        txs[txId] = Tx({numSigned: 0,
                         withdrawAddy: _withdrawAddy, 
                         erc20Addy: address(0), 
                         withdrawAmt: _amount, 
                         isExec: false});
        txId++;
        return txId-1;
                                                    // maybe I should have a function to see all outstanding transactions / see all executed transactions? 
    }                                               // otherwise nobody will know which txId corresponds to which transaction

    function proposeTx(uint _amount, address _tokenAddy, address _withdrawAddy) public returns (uint) {
        txs[txId] = Tx({numSigned: 0,
                        withdrawAddy: _withdrawAddy, 
                        erc20Addy: _tokenAddy, 
                        withdrawAmt: _amount, 
                        isExec: false});
        txId++;
        return txId-1;
    }

    function signTx(uint _txId) public {               
        require(isSigner[msg.sender], "You're not a signer bro");
        require(!txSigned[_txId][msg.sender], "You already signed broski");
        require(_txId <= txId, "Can't sign a transaction that doesn't exist yet dude");
        txSigned[_txId][msg.sender] = true;
        txs[_txId].numSigned++;
    }

    function execTx(uint _txId) public {                // anyone should be able to execute transaction as long as enough signers signed (not just owner / signers can execute)
        require(!txs[_txId].isExec, "Tx already executed");
        require(txs[_txId].numSigned >= numSignersRequired, "Not enough signers to execute");

        if(txs[_txId].erc20Addy == address(0)) {    // if no ERC20 address is set, it's a regular ETH withdrawal
            require(txs[_txId].withdrawAmt <= address(this).balance, "Not enough ETH in wallet to execute withdrawal");
            txs[_txId].isExec = true;
            payable(txs[_txId].withdrawAddy).transfer(txs[_txId].withdrawAmt); 
        }
        else {          
            require(txs[_txId].withdrawAmt <= ERC20(txs[_txId].erc20Addy).balanceOf(address(this)), "Not enough tokens to withdraw");
            txs[_txId].isExec = true;
            ERC20(txs[_txId].erc20Addy).transfer(txs[_txId].withdrawAddy, txs[_txId].withdrawAmt);
        }
    }

    function addSigner(address _addr) public {
        require(msg.sender == owner, "Only owner can add a signer");
        require(!isSigner[_addr], "Need to add a *new* signer brotha");
        isSigner[_addr] = true;
        totalNumberOfSigners++;
    }

    function removeSigner(address _addr) public {             
        require(msg.sender == owner, "Only owner can remove a signer");
        require(isSigner[_addr], "Can only remove an existing signer brotha");
        isSigner[_addr] = false;            
        totalNumberOfSigners--;
    }

    function changeNumSigners(uint _numSigners) public {
        require(msg.sender == owner, "Only owner can change number of signers");
        require(_numSigners > 0, "Can't have zero signers loser");
        require(_numSigners <= totalNumberOfSigners, "Can't require more signers than you have dude");
        numSignersRequired = _numSigners;
    }

    function numSigners() public view returns (uint) {
        return totalNumberOfSigners;
    }
}