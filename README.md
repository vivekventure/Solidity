# Solidity
This repo consists of a variety of Solidity projects, including the following:

1. <a href="https://github.com/vivekventure/Solidity/blob/main/EtherWallet.sol">EtherWallet.sol</a> - Simple ETH wallet for basic functionality to move from EOA to smart contract.

2. <a href="https://github.com/vivekventure/Solidity/blob/main/EtherWalletApproval.sol">EtherWalletApproval.sol</a> - ETH wallet with approval functionality (exploring double mapping structure).

3. <a href="https://github.com/vivekventure/Solidity/blob/main/EscrowLinear.sol">EscrowLinear.sol</a> - Linear escrow contract with escrow setup in constructor and ability to withdraw all vested funds or specified amount.

4. <a href="https://github.com/vivekventure/Solidity/blob/main/Multisig.sol">Multisig.sol</a> - Multisig structure that starts with 10 ETH in constructor and can receive more ETH or ERC20s. One owner address controls the multisig functionality, and multisig is customizable (# of signers can be adjusted). Executed transactions will result in a withdrawal of either ETH or the specified ERC20 contract. This is a baseline for future multisig and smart contract wallet functionality.

5. <a href="https://github.com/vivekventure/Solidity/blob/main/MaticStaking.sol">MaticStaking.sol</a> - Simple staking contract with an ERC20 rewards token where a user can stake either MATIC or stMATIC on Polygon and receive the rewards token while staked. Users can claim and then unstake either MATIC or stMATIC. Another building block baseline. 
Deployed <a href="https://polygonscan.com/address/0xf5f5a73362dd5701743400ebed94608ab168773e">here</a> with rewards token (SOYLANA) address <a href="https://polygonscan.com/token/0x0bf5d9127aa2250c8fefe5d3baf047fe2e329f85">here</a>. 

6. <a href="https://github.com/vivekventure/Solidity/blob/main/BTCEscrow.sol">BTCEscrow.sol</a> - A bare bones escrow contract for <a href="https://twitter.com/VivekVentures/status/1636846054703263746?s=20">Balaji's bet</a> where using a smart contract (instead of a trusted third party), Balaji and the Other Dude could deposit their collateral and programmatically claim victory rewards after the elapsed bet time (90 days). Uses the WBTC Chainlink price feed and WBTC as a proxy for BTC (since BTC does not have smart contracts).
