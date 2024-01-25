

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10; 
import "./IZoraNFTCreator.sol";
import "./PatchMinter.sol";
import './Base64.sol';
import {IERC721Drop} from "zora-drops-contracts/interfaces/IERC721Drop.sol";
import {console} from "forge-std/console.sol";
import {ERC721Drop} from "zora-drops-contracts/ERC721Drop.sol";

contract ZenDropCreator {

    IERC721Drop.SalesConfiguration salesConfig;
    address zenMinterAddress;

    bytes32 public immutable DEFAULT_ADMIN_ROLE = 0x00;
    bytes32 public immutable MINTER_ROLE = keccak256("MINTER");
    
    constructor(address _zenMinterAddress) {
        zenMinterAddress = _zenMinterAddress;
        salesConfig = IERC721Drop.SalesConfiguration({
            publicSalePrice: 0,
            maxSalePurchasePerAddress: 10000000,
            publicSaleStart: 0,
            publicSaleEnd: 500000000000000,
            presaleStart: 0,
            presaleEnd: 0,
            presaleMerkleRoot: 0x0
            });
    }

    function newDrop(address metadataRenderer, address defaultAdmin) public returns (address) {
      
        bytes memory metadataInitializer = abi.encode(
            string(abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(bytes(string(abi.encodePacked(
                    '{"description": "Patches for Zen+", "name": "Zen+"}')))))));

        // ZORA_NFT_CREATOR_PROXY (zora network)
        //address ZORA_DROPS_CREATOR = address(0xA2c2A96A232113Dd4993E8b048EEbc3371AE8d85);

        // ZORA_NFT_CREATOR_PROXY (zora goerli network)
        //address ZORA_DROPS_CREATOR = address(0xeB29A4e5b84fef428c072debA2444e93c080CE87);

        // ZORA_NFT_CREATOR_PROXY (regular goerli network)
        address ZORA_DROPS_CREATOR = address(0xb9583D05Ba9ba8f7F14CCEe3Da10D2bc0A72f519);

        address newDropAddress = IZoraNFTCreator(ZORA_DROPS_CREATOR).setupDropsContract(
          "Zen+", 
          "ZEN+",
          address(this), // admin of contract
          1000000000000,  // number of editions
          800, // BPS (8%?)
          payable(msg.sender), // funds recipient
          salesConfig, // datastructure on pricing etc
          IMetadataRenderer(metadataRenderer), 
          metadataInitializer, // blob w/ description and cover
          address(0)
       );

        // give tokenURIMinter minter role on zora drop
        ERC721Drop(payable(newDropAddress)).grantRole(MINTER_ROLE, zenMinterAddress);
        ERC721Drop(payable(newDropAddress)).grantRole(DEFAULT_ADMIN_ROLE, zenMinterAddress);

        // while this contract is still admin, set the mint price (we will then
        // immediately revoke admin and set it to the passed defaultAdmin address)
        PatchMinter(zenMinterAddress).setMintPrice(newDropAddress, 0);

        // grant admin role to desired admin address
        ERC721Drop(payable(newDropAddress)).grantRole(DEFAULT_ADMIN_ROLE, defaultAdmin);

        // revoke admin role from address(this) as it differed from desired admin address
        ERC721Drop(payable(newDropAddress)).revokeRole(DEFAULT_ADMIN_ROLE, address(this));

        // return the new drop address so that Stems contract can tie the "song" to the

        return newDropAddress;
    }

}
