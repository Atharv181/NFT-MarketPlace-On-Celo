const { ethers } = require("hardhat");

async function main() {
  
  const NFT = await ethers.getContractFactory("NFT");
  const nft = await NFT.deploy();
  await nft.deployed();
  console.log("NFT deployed to: ",nft.address);


  const NFTMarketPlace = await ethers.getContractFactory("NFTMarketplace");
  const nftMarketPlace = await NFTMarketPlace.deploy();

  await nftMarketPlace.deployed();

  console.log("nftMarketPlace deployed to: ",nftMarketPlace.address);
}


main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
