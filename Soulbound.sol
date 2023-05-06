// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import { ERC721 } from "solmate/tokens/ERC721.sol";

contract Soulbound is ERC721 {    
    address immutable owner;                // only owner can mint Soubound to a new address
    uint public nftID;                      // tracks NFT ID
    mapping(address => uint) public ownerToID;    // maps NFT ID to owner address and sets 0 to be no NFT minted
    uint immutable MAX_SUPPLY_PER_OWNER = 1;          // only 1 Soulbound per address for this spec
    mapping(uint256 => string) private _tokenURI;

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        owner = msg.sender;
        nftID = 1;      // start at 1 so that 0 means no NFT minted
    }

    function mint(address _to, string memory _uri) public {
        require(msg.sender == owner, "Only owner can mint Soubound to a new address");
        require(balanceOf(_to) < MAX_SUPPLY_PER_OWNER, "Max supply per wallet");
        ownerToID[_to] = nftID;
        nftID++;
        _mint(_to, nftID-1);
        _setTokenURI(nftID-1, _uri);
    }

    function burn() public {
        require(ownerToID[msg.sender] > 0, "Only a Soulbound owner can burn their Soulbound");
        _burn(ownerToID[msg.sender]);
        ownerToID[msg.sender] = 0;
    }

    function approve(address spender, uint256 id) public override {
        revert();
    }

    function setApprovalForAll(address operator, bool approved) public override {
        revert();
    }

    function transferFrom(address from, address to, uint256 id) public override {
        revert();
    }

    function safeTransferFrom(address from, address to, uint256 id) public override {
        revert();
    }

    function safeTransferFrom(address from, address to, uint256 id, bytes calldata data) public override {
        revert();
    }

    function tokenURI(uint256 id) public view virtual override returns (string memory) {    
        return _tokenURI[id];
    }

    function _setTokenURI(uint256 _nftId, string memory _uri) internal {
        _tokenURI[_nftId] = _uri;
    }
}