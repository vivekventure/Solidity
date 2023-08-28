// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract TicTacToe {
    bool public gameOn;
    bool public xTurn;  // X is player 1, O is player 2
    uint8[9] public board;   // 0 is empty, 1 is X, 2 is O
    address public owner;
    address public xPlayer;
    address public oPlayer;
    address public winner;
    uint public pot;

    constructor() {
        owner = msg.sender;
    }
    
    function offerGame(address challenger) public payable {
        require(!gameOn);
        require(xPlayer == address(0));
        xPlayer = msg.sender;
        pot = msg.value;
        oPlayer = challenger;
    }

    function withdrawPotBeforeGame() public {
        require(msg.sender == xPlayer);
        require(!gameOn);
        require(address(this).balance == pot);
        payable(xPlayer).transfer(pot);
        pot = 0;
        xPlayer = address(0);
        oPlayer = address(0);
    }

    function acceptGame() public payable {
        require(oPlayer == msg.sender);
        require(msg.value == pot);
        require(!gameOn);
        gameOn = true;
        pot += msg.value;
        xTurn = true;
    }

    function makeMove(uint8 move) public returns (uint8) {      // move is 0-8
        require(gameOn);
        require(msg.sender == (xTurn ? xPlayer : oPlayer));
        require(move >= 0 && move < 9);
        require(board[move] == 0);
        board[move] = xTurn ? 1 : 2;
        xTurn = !xTurn;
        if(checkGameOver()) {  
            xPlayer = address(0);
            oPlayer = address(0);
            for(uint i=0; i<9; i++) {
                board[i] = 0;
            }
        }
        return board[move];
    }

    function checkGameOver() internal returns (bool) { 
        if(board[0] == board[1] && board[1] == board[2] && board[0] != 0) {
            winner = board[0] == 1 ? xPlayer : oPlayer;
            gameOn = false;
            payable(winner).transfer(pot);
            pot = 0;
            return true;
        }
        else if(board[3] == board[4] && board[4] == board[5] && board[3] != 0) {
            winner = board[3] == 1 ? xPlayer : oPlayer;
            gameOn = false;
            payable(winner).transfer(pot);
            pot = 0;
            return true;
        }
        else if(board[6] == board[7] && board[7] == board[8] && board[6] != 0) {            
            winner = board[6] == 1 ? xPlayer : oPlayer;
            gameOn = false;
            payable(winner).transfer(pot);
            pot = 0;
            return true;
        }
        else if(board[0] == board[3] && board[3] == board[6] && board[0] != 0) {
            winner = board[0] == 1 ? xPlayer : oPlayer;
            gameOn = false;
            payable(winner).transfer(pot);
            pot = 0;
            return true;
        }
        else if(board[1] == board[4] && board[4] == board[7] && board[1] != 0) {
            winner = board[1] == 1 ? xPlayer : oPlayer;
            gameOn = false;
            payable(winner).transfer(pot);
            pot = 0;
            return true;
        }
        else if(board[2] == board[5] && board[5] == board[8] && board[2] != 0) {
            winner = board[2] == 1 ? xPlayer : oPlayer;
            gameOn = false;
            payable(winner).transfer(pot);
            pot = 0;
            return true;
        }
        else if(board[0] == board[4] && board[4] == board[8] && board[0] != 0) {
            winner = board[0] == 1 ? xPlayer : oPlayer;
            gameOn = false;
            payable(winner).transfer(pot);
            pot = 0;
            return true;
        }
        else if(board[2] == board[4] && board[4] == board[6] && board[2] != 0) {
            winner = board[2] == 1 ? xPlayer : oPlayer;
            gameOn = false;
            payable(winner).transfer(pot);
            pot = 0;
            return true;
        }
        else if(board[0] != 0 && board[1] != 0 && board[2] != 0 && board[3] != 0 && board[4] != 0 && board[5] != 0 && board[6] != 0 && board[7] != 0 && board[8] != 0) {
            gameOn = false;
            payable(xPlayer).transfer(pot/2);
            payable(oPlayer).transfer(pot/2);
            pot = 0;
            return true;
        }
        else {
            return false;
        }
    }

    function withdrawTips() public {
        require(msg.sender == owner);
        require(!gameOn);
        require(xPlayer == address(0));
        require(address(this).balance > 0);
        payable(owner).transfer(address(this).balance);
    }

    function tip() public payable {
        require(msg.value > 0);
    }
}
