import { useEffect, useState } from "react";
import { useAccount, useContract, useProvider, erc721ABI } from "wagmi";
import styles from "../styles/Listing.module.css";
import { formatEther } from "ethers/lib/utils";

export default function Listing(props){
    const [imageURI, setImageURI] = useState("");
    const [name, setName ] = useState("");

    const [loading, setLoading] = useState(true);
    
    const provider = useProvider();
    const { address } = useAccount();
    const ERC721Contract = useContract({
        address: props.nftAddress,
        abi: erc721ABI,
        signerOrProvider: provider,
    });
    
    //check if the NFT seller is the connected user
    const isOwner = address.toLowerCase() === props.seller.toLowerCase();
}