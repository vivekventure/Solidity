// SPDX-License-Identifier: UNLICENSED
// Unaudited escrow contract written by VivekVentures

pragma solidity ^0.8.13;

import { ERC20 } from "solmate/tokens/ERC20.sol";

interface EACAggregatorProxy {
    function latestAnswer() external view returns (int256);
}

contract BTCEscrow {
    
    address constant usdcAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address constant wbtcAddress = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;
    address chainlinkBTCFeed = 0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c;

    uint startTime;
    uint endTime;

    address immutable balaji;
    address immutable otherdude;
    bool public balajiSent;
    bool public otherdudeSent;

    ERC20 usdc = ERC20(usdcAddress);
    ERC20 wbtc = ERC20(wbtcAddress);

    constructor(address _balaji, address _otherdude) {
        balaji = _balaji;
        otherdude = _otherdude;
    }

    receive() external payable {}

    function sendUSDC() public {
        require(usdc.balanceOf(address(this)) == 0, "USDC already sent");
        require(msg.sender == balaji, "O) Only Balaji can send USDC");
        require(usdc.allowance(balaji, address(this)) >= 1000000, "Balaji must approve USDC");
        require(usdc.balanceOf(balaji) >= 1000000, "Balaji must have 1mm USDC in wallet");
        usdc.transferFrom(balaji, address(this), 1000000);
        balajiSent = true;
        if(otherdudeSent) { endTime = block.timestamp + 90 days; }
    }

    function sendWBTC() public {
        require(wbtc.balanceOf(address(this)) == 0, "WBTC already sent");
        require(msg.sender == otherdude, "O) Only Other Dude can send WBTC");
        require(wbtc.allowance(otherdude, address(this)) >= 1, "Other Dude must approve WBTC");
        require(wbtc.balanceOf(otherdude) >= 1, "Other Dude must have 1 WBTC in wallet");
        wbtc.transferFrom(otherdude, address(this), 1);
        otherdudeSent = true;
        if(balajiSent) { endTime = block.timestamp + 90 days; }
    }

    function claimWinner() public {
        require(block.timestamp >= endTime && endTime > 0, "Not at end of 90 days yet");
        int256 btcprice = EACAggregatorProxy(chainlinkBTCFeed).latestAnswer();
        if(btcprice > 1000000) {
            usdc.transfer(balaji, 1000000);
            wbtc.transfer(balaji, 1);
        } 
        else {
            usdc.transfer(otherdude, 1000000);
            wbtc.transfer(otherdude, 1);
        }
    }
}