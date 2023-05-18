// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "./IDEFI.sol";

// this contract liquidates ETH for DAI by sending ETH to contract, swapping for WETH, and trading that WETH for DAI on Uni v3
// also tests on Uniswap V2

contract ETHSellerUniswapV3 {

    address public univ3address = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
    address public daiAddress   = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public wethAddress  = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    IWETH weth = IWETH(wethAddress);
    IERC20 dai = IERC20(daiAddress);

    address immutable contractOwner;
    // uint immutable treasuryFee = 0.01 ether;        // add fee logic to function below and allow owner to withdraw for a treasury function

    constructor() {
        contractOwner = msg.sender;     // owner can withdraw treasury
    } 

    function sellMyETH(uint _amount) public payable {
        address owner = msg.sender;
        require(msg.value >= _amount, "Can't sell more ETH than you are sending bro");
        weth.deposit{value: msg.value}();   // now the contract owns WETH and 0 ETH
        weth.approve(univ3address, _amount);    // approve uniswap to access contract's WETH

        // make the weird ExactInputSingleParams struct for uniswap
        uint24 fee = 3000;                          // NEED TO USE 3000 fee tier
        uint256 deadline = block.timestamp + 30;    // making up a number
        uint256 amountOutMinimum = 0;   // just for default
        uint160 sqrtPriceLimitX96 = 0;  // wtf is this 

        IUniswapV3Router.ExactInputSingleParams memory params = IUniswapV3Router.
            ExactInputSingleParams({ 
            tokenIn: wethAddress, 
            tokenOut: daiAddress,
            fee: fee,
            recipient: address(this),
            deadline: deadline,
            amountIn: _amount,
            amountOutMinimum: amountOutMinimum,
            sqrtPriceLimitX96: sqrtPriceLimitX96
            }); 
        uint daiAmount = IUniswapV3Router(univ3address).exactInputSingle(params);
        dai.transfer(owner, daiAmount);     // send swapped DAI back to owner
        weth.transfer(owner, weth.balanceOf(address(this)));  // send any excess WETH back to owner
    }

}

contract ETHSellerUniswapV2 {
    address public univ2address = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address public daiAddress   = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public wethAddress  = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public aaveAddress = 0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9;

    // Curve stuff
    address public usdcAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public usdtAddress = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address public curveTriPoolAddress = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;

    IWETH weth = IWETH(wethAddress);
    IERC20 dai = IERC20(daiAddress);
    IERC20 usdc = IERC20(usdcAddress);

    address immutable contractOwner;
    // uint immutable treasuryFee = 0.01 ether;        // add fee logic to function below and allow owner to withdraw

    constructor() {
        contractOwner = msg.sender;     // owner can withdraw treasury
    } 

    function sellMyETH(uint _amount) public payable {
        address owner = msg.sender;
        require(msg.value >= _amount, "Can't sell more ETH than you are sending bro");
        weth.deposit{value: msg.value}();   // now the contract owns WETH and 0 ETH
        weth.approve(univ2address, _amount);    // approve uniswap to access contract's WETH

        address[] memory path = new address[](2);
        path[0] = wethAddress;
        path[1] = daiAddress;

        uint[] memory output = IUniswapV2Router01(univ2address).
            swapExactTokensForTokens(
                _amount,
                0,
                path,
                address(this),
                block.timestamp + 30
            );
        uint daiAmount = output[1];

        dai.transfer(owner, daiAmount);     // send swapped DAI back to owner
        weth.transfer(owner, weth.balanceOf(address(this)));  // send any excess WETH back to owner
    }

    // use Curve
    function swapDAIforUSDC(uint _amount) public {
        address eoa = msg.sender;
        require(dai.balanceOf(msg.sender) >= _amount, "Can't deposit more DAI than you have bro");
        dai.transferFrom(msg.sender, address(this), _amount);
        dai.approve(curveTriPoolAddress, _amount);

        ICurveTriPoolSwap curve = ICurveTriPoolSwap(curveTriPoolAddress);  // address of DAI USDC USDT curve pool

        curve.exchange(0, 1, _amount, 1);
        usdc.transfer(eoa, usdc.balanceOf(address(this)));     // send swapped USDC back to owner
    }

    // requires user to approve ETHSellerUniswapV2 contract to spend their DAI first
    // then contract has to approve Aave address to use contract's DAI
    function earnOnMyDAI(uint _amount) public {
        require(dai.balanceOf(msg.sender) >= _amount, "Can't deposit more DAI than you have bro");
        dai.transferFrom(msg.sender, address(this), _amount);
        dai.approve(aaveAddress, _amount);
        IAave(aaveAddress).deposit(daiAddress, _amount, msg.sender, 0);
    }
}

// contract to use Curve to swap ETH for stETH
contract swapETHforstETH {
    address stETHAddress = 0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84;
    address public curveSTETHAddress = 0xDC24316b9AE028F1497c275EB9192a3Ea0f67022;
    
    IERC20 stETH = IERC20(stETHAddress);

    function buystETH() public payable {
        require(msg.value > 0, "Can't swap 0 ETH");
        uint stETHAmount = ICurveSTETHSwap(curveSTETHAddress).exchange{value: msg.value}(0,1,msg.value,0);
        stETH.transfer(msg.sender, stETHAmount);
    }
}