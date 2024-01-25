// SPDX-License-Identifier: MIT
pragma solidity >=0.6.2 <0.9.0;

import {IERC721Drop} from "zora-drops-contracts/interfaces/IERC721Drop.sol";
import {IMetadataRenderer} from "zora-drops-contracts/interfaces/IMetadataRenderer.sol";

/// @notice Interface for ZORA Drops contract
interface IZoraNFTCreator {
    function setupDropsContract(
        string memory name,
        string memory symbol,
        address defaultAdmin,
        uint64 editionSize,
        uint16 royaltyBPS,
        address payable fundsRecipient,
        IERC721Drop.SalesConfiguration memory saleConfig,
        IMetadataRenderer metadataRenderer,
        bytes memory metadataInitializer,
        address createReferral
    ) external returns (address);
}
 
