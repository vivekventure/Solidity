// SPDX-License-Identifier: UNLICENSED
// Unaudited escrow contract written by VivekVentures

pragma solidity ^0.8.13;

import { ERC20 } from "solmate/tokens/ERC20.sol";

interface AggregatorV3Interface {
  function decimals() external view returns (uint8);

  function latestRoundData()
    external
    view
    returns (
      uint80 roundId,
      int256 answer,
      uint256 startedAt,
      uint256 updatedAt,
      uint80 answeredInRound
    );
}

contract BTCEscrow {
    
    address constant usdcAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;  // 6 decimals
    address constant wbtcAddress = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599;  // 8 decimals
    address chainlinkBTCFeed = 0xF4030086522a5bEEa4988F8cA5B36dbC97BeE88c;    // call decimals() to get decimals

    uint startTime;
    uint endTime;

    uint constant BET_LENGTH = 90 days;
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

    function sendUSDC() public {
        require(usdc.balanceOf(address(this)) == 0, "USDC already sent");
        require(msg.sender == balaji, "O) Only Balaji can send USDC");
        require(usdc.allowance(balaji, address(this)) >= 1_000_000*1e6, "Balaji must approve USDC");
        require(usdc.balanceOf(balaji) >= 1_000_000*1e6, "Balaji must have 1mm USDC in wallet");
        usdc.transferFrom(balaji, address(this), 1_000_000*1e6);
        balajiSent = true;
        if(otherdudeSent) { endTime = block.timestamp + BET_LENGTH; }
    }

    function sendWBTC() public {
        require(wbtc.balanceOf(address(this)) == 0, "WBTC already sent");
        require(msg.sender == otherdude, "Only Other Dude can send WBTC");
        require(wbtc.allowance(otherdude, address(this)) >= 1*1e8, "Other Dude must approve WBTC");
        require(wbtc.balanceOf(otherdude) >= 1*1e8, "Other Dude must have 1 WBTC in wallet");
        wbtc.transferFrom(otherdude, address(this), 1*1e8);
        otherdudeSent = true;
        if(balajiSent) { endTime = block.timestamp + BET_LENGTH; }
    }

    function claimWinner() public {
        require(block.timestamp >= endTime && endTime > 0, "Not at end of 90 days yet");
        uint btcpx = chainlinkBTC();
        if(btcpx > 1_000_000) {
            usdc.transfer(balaji, 1_000_000*1e6);
            wbtc.transfer(balaji, 1*1e8);
        } 
        else {
            usdc.transfer(otherdude, 1_000_000*1e6);
            wbtc.transfer(otherdude, 1*1e8);
        }
    }

    function chainlinkBTC() public view returns (uint) {
        (,int256 btcprice,,,) = AggregatorV3Interface(chainlinkBTCFeed).latestRoundData();      
        return (uint(btcprice) / (10**AggregatorV3Interface(chainlinkBTCFeed).decimals()));
    }
}

/* 
Other Implementation 1: 
https://twitter.com/0xngmi/status/1636867823229181957?s=20
https://etherscan.io/address/0xa4bfb9ae4999a97c5f93bEE59E4D126C904989aD#code

Other Implementation 2:
https://twitter.com/0xfoobar/status/1636841462921871360?s=20
https://etherscan.io/address/0x7fcce45372984b4e605ad5b0c2d24ebb260c02fa#code
*/
