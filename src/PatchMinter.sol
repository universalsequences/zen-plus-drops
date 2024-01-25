// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import './Commit.sol';
import {IERC721Drop} from "zora-drops-contracts/interfaces/IERC721Drop.sol";
import {console} from "forge-std/console.sol";
import './ZenMetadataRenderer.sol';
import './ERC721DropMinterInterface.sol';

/**
   mostly taken from public assembly's TokenUriMint.sol
 */
contract PatchMinter {

    ZenMetadataRenderer _metadataRenderer;

    mapping (address=>uint256) mintPricePerToken;

    /// @notice Action is unable to complete because msg.value is incorrect
    error WrongPrice();

    /// @notice Action is unable to complete because minter contract has not recieved minting role
    error MinterNotAuthorized();

    /// @notice Funds transfer not successful to drops contract
    error TransferNotSuccessful();

    /// @notice Caller is not an admin on target zora drop
    error Access_OnlyAdmin();

    // ||||||||||||||||||||||||||||||||
    // ||| EVENTS |||||||||||||||||||||
    // ||||||||||||||||||||||||||||||||

    /// @notice mint notice
    event Mint(address minter, address mintRecipient, uint256 tokenId, string tokenURI);
    
    /// @notice mintPrice updated notice
    event MintPriceUpdated(address sender, address targetZoraDrop, uint256 newMintPrice);

    /// @notice metadataRenderer updated notice
    event MetadataRendererUpdated(address sender, address newRenderer);    

    constructor(address renderer) {
        _metadataRenderer = ZenMetadataRenderer(renderer);
    }
  
    function setMintPrice(address zoraDrop, uint256 newMintPricePerToken) public {
        // only let ZporeDropCreator do this once
         if (!ERC721DropMinterInterface(zoraDrop).isAdmin(msg.sender)) {
            revert Access_OnlyAdmin();
        }

        mintPricePerToken[zoraDrop] = newMintPricePerToken;

        emit MintPriceUpdated(msg.sender, zoraDrop, newMintPricePerToken);
    }

    /**
     * This is the point of entry to minting a remix.
     * Can be used by multiple drop contracts (for example, for different songs)
     */ 
    function purchase(
      address dropsContractAddress, // the contract where NFTs get minted
      address mintRecipient, // allow minting to other person
      string memory name,
      string memory chunk,
      bool isSubPatch,
      uint256 previousTokenId
                      ) public payable returns (uint256)
    {
        // note: the dropsContractAddress is the "Zpores Drop" created for a specific song

        // First mint a blank token
        uint256 tokenId = IERC721Drop(dropsContractAddress)
            .adminMint(mintRecipient, 1);

        // Then pass the metadata to the custom metadata renderer
        // okay so is ZporeMinter admin role? if not it will fail the
        // has admin check
        _metadataRenderer.updateTokenURI(
                                         dropsContractAddress, tokenId, name, chunk, isSubPatch, previousTokenId, msg.sender); 

        // need to add functionality for paying
        return tokenId;
    }

    // Function to return an array of patch names
    function getAllPatches() external view returns (string[] memory) {
        return _metadataRenderer.getAllPatches();
    }

    // Function to return an array of patch names
    function getAllSubPatches() external view returns (string[] memory) {
        return _metadataRenderer.getAllSubPatches();
    }

    function getRevisionNumber(uint256 tokenId) public view returns (uint256) {
        return _metadataRenderer.getRevisionNumber(tokenId);
    }

     // Modified function to retrieve diffs with pagination
    function getAllDiffsPaginated(uint256 tokenId, uint256 pageSize, uint256 page) public view returns (string[] memory) {
        return _metadataRenderer.getAllDiffsPaginated(tokenId, pageSize, page);
    }

     // Modified function to retrieve diffs with pagination
    function getRevisionHistory(uint256 tokenId, uint256 pageSize, uint256 page) public view returns (ZenMetadataRenderer.Revision[] memory) {
        return _metadataRenderer.getRevisionHistory(tokenId, pageSize, page);
    }

    function getPatchHeads(bool isSubPatch) public view returns (Commit.HeadData[] memory) {
        return _metadataRenderer.getPatchHeads(isSubPatch);
    }
}
