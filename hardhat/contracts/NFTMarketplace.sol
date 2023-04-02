//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace {

    //Events
    event ListingCreated(
        address nftAddress,
        uint256 tokenId,
        uint256 price,
        address seller
    );
    event ListingCancelled(
        address nftAddress,
        uint256 tokenId, 
        address seller
    );

    event ListingUpdated(
        address nftAddress, 
        uint256 tokenId, 
        uint256 newPrice, 
        address seller
    );

    event ListingPurchased(
        address nftAddress,
        uint256 tokenId,
        address seller,
        address buyer
    );


    //Structs
    struct Listing {
        uint256 price;
        address seller;
    }

    mapping(address => mapping(uint256 => Listing)) public listings;


    //Modifiers
    modifier isNFTOwner(address nftAddress, uint256 tokenId) {
        require(
            IERC721(nftAddress).ownerOf(tokenId) == msg.sender,
            "Not an Owner"
        );
        _;
    }

    modifier validPrice(uint256 _price) {
        require(_price > 0, "Price should be greater than 0");
        _;
    }

    modifier isNotListed(address nftAddress, uint256 tokenId) {
        require(
            listings[nftAddress][tokenId].price == 0,
            "MRKT: Already listed"
        );
        _;
    }

    modifier isListed(address nftAddress, uint256 tokenId) {
        require(listings[nftAddress][tokenId].price > 0, "MRKT: Not listed");
        _;
    }


    function createListing(
        address nftAddress,
        uint256 tokenId,
        uint256 price
    )
        external
        isNotListed(nftAddress, tokenId)
        isNFTOwner(nftAddress, tokenId)
        validPrice(price)
    {
        IERC721 nftContract = IERC721(nftAddress);
        require(
            nftContract.isApprovedForAll(msg.sender, address(this)) ||
                nftContract.getApproved(tokenId) == address(this),
            "No Approval for NFT"
        );

        listings[nftAddress][tokenId] = Listing({
            price: price,
            seller: msg.sender
        });

        emit ListingCreated(nftAddress, tokenId, price, msg.sender);
    }

    function cancelListing(address nftAddress, uint256 tokenId) 
        external 
        isNFTOwner(nftAddress, tokenId)
        isListed(nftAddress, tokenId) 
    {

        delete listings[nftAddress][tokenId];

        emit ListingCancelled(nftAddress,tokenId,msg.sender);

    }
    
    function updateListing(
        address nftAddress, 
        uint256 tokenId, 
        uint256 newPrice
        ) 
        external
        isListed(nftAddress, tokenId) 
        isNFTOwner(nftAddress, tokenId) 
        validPrice(newPrice)
    {
        listings[nftAddress][tokenId].price = newPrice;

        emit ListingUpdated(nftAddress, tokenId, newPrice, msg.sender);
    } 

    function purchaseListing(address nftAddress, uint256 tokenId)
        external
        payable
        isListed(nftAddress,tokenId)
    {
        require(msg.value == listings[nftAddress][tokenId].price, "Incorrect Amount");

        //load the listing in a local copy
        Listing memory listing = listings[nftAddress][tokenId];

        delete listings[nftAddress][tokenId];

        IERC721(nftAddress).safeTransferFrom(listing.seller, msg.sender, tokenId);

        (bool sent, ) = payable(listing.seller).call{value:msg.value}("Thank You For NFT");
        require(sent,"Failed to transfer eth");

        emit ListingPurchased(nftAddress, tokenId ,listing.seller, msg.sender);
    }

}
