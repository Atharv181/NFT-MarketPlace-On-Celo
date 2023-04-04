import {
  ListingCancelled,
  ListingCreated,
  ListingPurchased,
  ListingUpdated,
} from "../generated/NFTMarketplace/NFTMarketplace";
import { store } from "@graphprotocol/graph-ts";
import { ListingEntity } from "../generated/schema";

export function handleListingCreated(event: ListingCreated): void {
  const id =
    event.params.nftAddress.toHex() +
    "-" +
    event.params.tokenId.toString() +
    "-" +
    event.params.seller.toHex();

  let listing = new ListingEntity(id);

  // Set the properties of the listing, as defined in the schema,
  // based on the event
  listing.seller = event.params.seller;
  listing.nftAddress = event.params.nftAddress;
  listing.tokenId = event.params.tokenId;
  listing.price = event.params.price;

  // Save the listing to the nodes, so we can query it later
  listing.save();
}

export function handleListingCanceled(event: ListingCancelled): void {

  const id =
    event.params.nftAddress.toHex() +
    "-" +
    event.params.tokenId.toString() +
    "-" +
    event.params.seller.toHex();

  // Load the listing to see if it exists
  let listing = ListingEntity.load(id);

  // If it does
  if (listing) {
    // Remove it from the store
    store.remove("ListingEntity", id);
  }
}

export function handleListingPurchased(event: ListingPurchased): void {

  const id =
    event.params.nftAddress.toHex() +
    "-" +
    event.params.tokenId.toString() +
    "-" +
    event.params.seller.toHex();

  // Attempt to load a pre-existing entity, instead of creating a new one
  let listing = ListingEntity.load(id);

  // If it exists
  if (listing) {
    // Set the buyer
    listing.buyer = event.params.buyer;

    // Save the changes
    listing.save();
  }
}

export function handleListingUpdated(event: ListingUpdated): void {

  const id =
    event.params.nftAddress.toHex() +
    "-" +
    event.params.tokenId.toString() +
    "-" +
    event.params.seller.toHex();

  // Attempt to load a pre-existing entity, instead of creating a new one
  let listing = ListingEntity.load(id);

  // If it exists
  if (listing) {
    // Update the price
    listing.price = event.params.newPrice;

    // Save the changes
    listing.save();
  }
}
