# Solidity
This repo consists of a variety of Solidity projects, including the following:

1. EtherWallet.sol - Simple ETH wallet for basic functionality to move from EOA to smart contract.

2. EtherWalletApproval.sol - ETH wallet with approval functionality (exploring double mapping structure).

3. EscrowLinear.sol - Linear escrow contract with escrow setup in constructor and ability to withdraw all vested funds or specified amount.

4. Multisig.sol - Multisig structure that starts with 10 ETH in constructor and can receive more ETH or ERC20s. One owner address controls the multisig functionality, and multisig is customizable (# of signers can be adjusted). Executed transactions will result in a withdrawal of either ETH or the specified ERC20 contract. This is a baseline for future multisig and smart contract wallet functionality.
