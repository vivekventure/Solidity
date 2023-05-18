# Solidity
This repo consists of a variety of Solidity projects, including the following:

1. <a href="https://github.com/vivekventure/Solidity/blob/main/EtherWallet.sol">EtherWallet.sol</a> - Simple ETH wallet for basic functionality to move from EOA to smart contract.

2. <a href="https://github.com/vivekventure/Solidity/blob/main/EtherWalletApproval.sol">EtherWalletApproval.sol</a> - ETH wallet with approval functionality (exploring double mapping structure).

3. <a href="https://github.com/vivekventure/Solidity/blob/main/EscrowLinear.sol">EscrowLinear.sol</a> - Linear escrow contract with escrow setup in constructor and ability to withdraw all vested funds or specified amount.

4. <a href="https://github.com/vivekventure/Solidity/blob/main/Multisig.sol">Multisig.sol</a> - Multisig structure that starts with 10 ETH in constructor and can receive more ETH or ERC20s. One owner address controls the multisig functionality, and multisig is customizable (# of signers can be adjusted). Executed transactions will result in a withdrawal of either ETH or the specified ERC20 contract. This is a baseline for future multisig and smart contract wallet functionality.

5. <a href="https://github.com/vivekventure/Solidity/blob/main/MaticStaking.sol">MaticStaking.sol</a> - Simple staking contract with an ERC20 rewards token where a user can stake either MATIC or stMATIC on Polygon and receive the rewards token while staked. Users can claim and then unstake either MATIC or stMATIC. Another building block baseline. 
Deployed <a href="https://polygonscan.com/address/0xf5f5a73362dd5701743400ebed94608ab168773e">here</a> with rewards token (SOYLANA) address <a href="https://polygonscan.com/token/0x0bf5d9127aa2250c8fefe5d3baf047fe2e329f85">here</a>. 

6. <a href="https://github.com/vivekventure/Solidity/blob/main/BTCEscrow.sol">BTCEscrow.sol</a> - A bare bones escrow contract for <a href="https://twitter.com/VivekVentures/status/1636846054703263746?s=20">Balaji's bet</a> where using a smart contract (instead of a trusted third party), Balaji and the Other Dude could deposit their collateral and programmatically claim victory rewards after the elapsed bet time (90 days). Uses the WBTC Chainlink price feed and WBTC as a proxy for BTC (since BTC does not have smart contracts).

7. <a href="https://github.com/vivekventure/Solidity/blob/main/Soulbound.sol">Soulbound.sol</a> - Initial proposed spec for a Soulbound token which inherits from ERC721 standard and will be immediately compatible with major NFT platforms and applications. Potential use cases of this Soulbound token spec: since only 1 Soulbound can be minted to each address, this suits 1 of 1 applications like ID, KYC/AML badges, membership cards, certificates of completion, etc

8. <a href="https://github.com/vivekventure/Solidity/blob/main/IDEFI.sol">IDEFI.sol</a> - The IDEFI interface that simplifies DeFi interactions into one library. IDEFI aggregates popular interfaces used in DeFi - specifically ERC20, WETH, Uniswap v3, Uniswap v2, Curve, Lido, Aave v2, Chainlink price feeds. Additionally, the interface contains comments with relevant contract addresses and docs needed to call relevant DeFi functions.

9. <a href="https://github.com/vivekventure/Solidity/blob/main/ETHSeller.sol">ETHSeller.sol</a> - Example DeFi interactions using the IDEFI.sol interface detailed above; sell ETH on Uniswap v3, Uniswap v2, execute a StableSwap on Curve, and convert ETH to stETH on curve. Building blocks for apps that abstract away DeFi interactions for mass adoption.
