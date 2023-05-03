// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "solmate/tokens/ERC20.sol";

contract RewardsToken is ERC20 {
    constructor() ERC20("SOYLANA", "SOY", 18) {}

    address internal stakingContract;

    function setStakingContractAddress(address _addr) public {
        require(stakingContract == address(0), "Already set");
        stakingContract = _addr;        
    }

    function mint(address _to, uint _amount) public {
        require(msg.sender == stakingContract, "Only staking contract can mint");
        _mint(_to, _amount);
    }
}

contract MaticStaking {                          
                                                  
    RewardsToken rewardsToken;
    address immutable stMATICAddress = 0x3A58a54C066FdC0f2D55FC9C89F0415C92eBf3C4;  // for the ERC20 wrapper, from polygonscan stmatic contract

    enum MaticType {native, stMatic}
    uint public immutable stYield;
    mapping (address => mapping (MaticType => uint)) public stakeBalance;        
    mapping (address => mapping (MaticType => uint)) public stakeTime;           
    
    constructor(address _rewardsTokenAddress, uint _yield) {
        rewardsToken = RewardsToken(_rewardsTokenAddress);          
        stYield = _yield;
    }

    function claim() public {               // claim works on both stMATIC and MATIC            
        require(stakeBalance[msg.sender][MaticType.native] > 0 || stakeBalance[msg.sender][MaticType.stMatic] > 0, "Nothing to claim broski");
        uint stakingRewards = ((block.timestamp - stakeTime[msg.sender][MaticType.native]) * stakeBalance[msg.sender][MaticType.native] * stYield ) / (60*60*24*365);
        stakingRewards += ((block.timestamp - stakeTime[msg.sender][MaticType.stMatic]) * stakeBalance[msg.sender][MaticType.stMatic] * stYield ) / (60*60*24*365);
        rewardsToken.mint(msg.sender, stakingRewards);
        stakeTime[msg.sender][MaticType.native] = block.timestamp;        // reset staking clock
        stakeTime[msg.sender][MaticType.stMatic] = block.timestamp;        // reset staking clock
    }

    function stake(uint _amount) public payable {       // stMATIC stake function
        require(msg.value == 0, "Don't include a stMATIC amount if you're staking MATIC dude");
        require(_amount <= ERC20(stMATICAddress).balanceOf(msg.sender) && _amount > 0, "Can't stake zero or more tokens than you have bro");        // ZO: unnecesssary b/c tx will revert
        require(ERC20(stMATICAddress).allowance(msg.sender, address(this)) >= _amount, "Need to allow staking contract to stake your stMATIC by setting allowance in stMATIC contract");    // ZO: unnecesssary b/c tx will revert
        ERC20(stMATICAddress).transferFrom(msg.sender, address(this), _amount);    
        if(stakeBalance[msg.sender][MaticType.stMatic] > 0) { claim(); }
        stakeBalance[msg.sender][MaticType.stMatic] += _amount;
        stakeTime[msg.sender][MaticType.stMatic] = block.timestamp;
    }

    function stake() public payable {       // MATIC staking function, overloading stake()
        require(msg.value > 0, "Can't stake zero tokens bro; send MATIC that you want to stake");
        if(stakeBalance[msg.sender][MaticType.native] > 0) { claim(); }
        stakeBalance[msg.sender][MaticType.native] += msg.value;
        stakeTime[msg.sender][MaticType.native] = block.timestamp;
    }

    function unstakeMatic(uint _amount) public {        // need separate function to unstake matic vs stmatic
        require((stakeBalance[msg.sender][MaticType.native] >= _amount && _amount > 0), "Can't unstake zero or more than you have staked");
        claim();
        stakeBalance[msg.sender][MaticType.native] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    function unstakestMatic(uint _amount) public {
        require((stakeBalance[msg.sender][MaticType.stMatic] >= _amount && _amount > 0), "Can't unstake zero or more than you have staked");
        claim();
        stakeBalance[msg.sender][MaticType.stMatic] -= _amount;
        ERC20(stMATICAddress).transfer(msg.sender, _amount);
    }

    receive() external payable {}
}