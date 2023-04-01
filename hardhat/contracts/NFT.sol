//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFT is ERC721{ 
    constructor() ERC721("Atharv","ATH"){
        for(uint i=0;i<5;i++){
            _mint(msg.sender, i);
        }
    }


    function tokenURI(tokenId) public pure override returns(string memory){
        return "ipfs://QmTy8w65yBXgyfG2ZBg5TrfB2hPjrDQH3RCQFJGkARStJb";
    }
}