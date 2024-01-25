


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10; 
import "./IZoraNFTCreator.sol";
import "./PatchMinter.sol";
import "./Parameters.sol";
import './Base64.sol';
import {IERC721Drop} from "zora-drops-contracts/interfaces/IERC721Drop.sol";
import {console} from "forge-std/console.sol";
import {ERC721Drop} from "zora-drops-contracts/ERC721Drop.sol";

contract SoundDropCreator {

    address metadataRenderer;

    bytes32 public immutable DEFAULT_ADMIN_ROLE = 0x00;
    bytes32 public immutable MINTER_ROLE = keccak256("MINTER");
    
    constructor(address _metadataRenderer) {
        metadataRenderer = _metadataRenderer;
    }

    struct DropInfo {
        string name;
        string description;
        string collectionImage;
        string dsp;
        string visuals;
        string[] parameterNames;
        int64[] minValues;
        int64[] maxValues;
        string[] inputs;
        string[] outputs;
    }

    function createMetadataInitializer(
        DropInfo memory i) private returns (bytes memory) {
        return abi.encode(
            string(abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(bytes(string(abi.encodePacked(
                      '{"image": "', i.collectionImage, '", "description": "', i.description  ,'", "name": "', i.name,'"}')))))),
            i.name,
            i.description,
            i.dsp,
            i.visuals,
            i.parameterNames,
            i.minValues,
            i.maxValues,
            i.inputs,
            i.outputs,
            i.collectionImage
        );

    }
 
    function newDrop(
       DropInfo memory data,
       uint104 price,
       uint64 editionSize) public returns (address) {
        bytes memory metadataInitializer = createMetadataInitializer(data);

        // ZORA_NFT_CREATOR_PROXY (zora network)
        //address ZORA_DROPS_CREATOR = address(0xA2c2A96A232113Dd4993E8b048EEbc3371AE8d85);

        // ZORA_NFT_CREATOR_PROXY (zora goerli network)
        //address ZORA_DROPS_CREATOR = address(0xeB29A4e5b84fef428c072debA2444e93c080CE87);

        // ZORA_NFT_CREATOR_PROXY (regular goerli network)
        //address ZORA_DROPS_CREATOR = address(0xb9583D05Ba9ba8f7F14CCEe3Da10D2bc0A72f519);

        IERC721Drop.SalesConfiguration memory config;
        {
            config = IERC721Drop.SalesConfiguration({
                publicSalePrice: price,
                maxSalePurchasePerAddress: 10000000,
                publicSaleStart: 0,
                publicSaleEnd: 500000000000000,
                presaleStart: 0,
                presaleEnd: 0,
                presaleMerkleRoot: 0x0
                });
        }
 

        return setup(data.name, msg.sender, editionSize, config, metadataInitializer);
    }

    function setup(string memory name, address sender, uint64 editionSize, IERC721Drop.SalesConfiguration memory config, bytes memory metadataInitializer) private returns (address) {
        return IZoraNFTCreator(0xb9583D05Ba9ba8f7F14CCEe3Da10D2bc0A72f519).setupDropsContract(
                name,
                name,
                sender, // the creator (default admin)
                editionSize,  // number of editions
                800, // BPS (8%?)
                payable(sender), // funds recipient
                config,
                IMetadataRenderer(metadataRenderer), 
                metadataInitializer, // blob w/ description & DSP data
                address(0)
            );

    }

}
