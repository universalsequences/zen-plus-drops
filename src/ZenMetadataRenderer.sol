

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {IMetadataRenderer} from "zora-drops-contracts/interfaces/IMetadataRenderer.sol";
import './Base64.sol';
import './Commit.sol';
import './Conversion.sol';
import {MetadataRenderAdminCheck} from "zora-drops-contracts/metadata/MetadataRenderAdminCheck.sol";
import {IERC721Drop} from "zora-drops-contracts/interfaces/IERC721Drop.sol";
import {IERC721AUpgradeable} from "ERC721A-Upgradeable/IERC721AUpgradeable.sol";

contract ZenMetadataRenderer is IMetadataRenderer, MetadataRenderAdminCheck {

    constructor() {
        counter=0;
    }

    error No_MetadataAccess();
    error No_WildcardAccess();
    error Cannot_SetBlank();
    error Token_DoesntExist();
    error Address_NotInitialized();
    
     modifier adminCheck(address target ) {
        if ( 
             !IERC721Drop(target).isAdmin(msg.sender) 
        ) {
            revert No_MetadataAccess();
        }    
        _;
    }         


    struct MetadataURIInfo {
        string contractURI;
    }

    /// @notice NFT metadata by contract
    mapping(address => MetadataURIInfo) public metadataBaseByContract;

    mapping(uint256 => Patch) public tokenToPatch;

    event NewPatch(string name, address author, bool isSubPatch, uint256 tokenId, uint256 previousTokenId, uint256 revisionNumber);

    uint256 private counter;

    struct Patch {
        address author;
        string name;
        string diff;
        bool isSubPatch;
        uint256 previousTokenId;
        bool isHead;
    }

    struct Revision {
        address author;
        string name;
        string diff;
        uint256 previousTokenId;
        uint256 revisions;
    }

   function tokenURI(uint256 tokenId) external view returns (string memory) {
        Patch memory patch = tokenToPatch[tokenId];
        return string(abi.encodePacked(
          'data:application/json;base64,',
          Base64.encode(bytes(
            abi.encodePacked(
              "{",
              "\"diff\": \"", patch.diff , "\",",
              "\"previous_token_id\": ", Conversion.uint2str(patch.previousTokenId), ",",
              "\"name\": \"", patch.name, "\",",
              "\"revision_number\": ", Conversion.uint2str(getRevisionNumber(tokenId)), ",",
              "\"description\": \"Patch for zen+\"", 
              "}")))));
    }

    function updateTokenURI(address target, uint256 tokenId, string memory name, string memory chunk, bool isSubPatch, uint256 prevTokenId, address author)
        public adminCheck(target) {
        tokenToPatch[tokenId].name = name;
        tokenToPatch[tokenId].author = author;
        tokenToPatch[tokenId].isSubPatch = isSubPatch;
        tokenToPatch[tokenId].diff =  chunk;
        tokenToPatch[tokenId].previousTokenId =  prevTokenId;
        tokenToPatch[tokenId].isHead =  true;

        if (prevTokenId != 0) {
            tokenToPatch[prevTokenId].isHead = false;
        }

        counter++;

        emit NewPatch(name, author, isSubPatch, tokenId, prevTokenId, getRevisionNumber(tokenId));
    }

    // Function to return an array of patch names
    function getAllPatches() external view returns (string[] memory) {
        string[] memory names = new string[](counter);
        for (uint256 i = 0; i < counter; i++) {
            Patch storage patch = tokenToPatch[i+1];
            names[i] = patch.name;
        }
        return names;
    }


    // Function to return an array of patch names
    function getAllSubPatches() external view returns (string[] memory) {
        uint256 subpatches = 0;
        for (uint256 i = 0; i < counter; i++) {
            Patch storage patch = tokenToPatch[i+1];
            if (patch.isSubPatch) {
                subpatches++;
            }
        }
 
        string[] memory names = new string[](subpatches);
        uint256 c = 0;
        for (uint256 i = 0; i < counter; i++) {
            Patch storage patch = tokenToPatch[i+1];
            if (patch.isSubPatch) {
                names[c] = patch.name;
                c++;
            }
        }
        return names;
    }

    function contractURI(
) external view returns (string memory) {
        string memory uri = metadataBaseByContract[msg.sender].contractURI;
        if (bytes(uri).length == 0) revert();
        return uri;
    }

    function initializeWithData(bytes memory data) external {
        // data format: string baseURI, string newContractURI
        (string memory initialContractURI) = abi
            .decode(data, (string));

        metadataBaseByContract[msg.sender] = MetadataURIInfo({
            contractURI: initialContractURI}
        );
    }

     // Modified function to retrieve diffs with pagination
    function getRevisionHistory(uint256 tokenId, uint256 pageSize, uint256 page) public view returns (Revision[] memory) {
        uint256 totalDiffs = 0;
        uint256 currentTokenId = tokenId;

        // First, count the total number of diffs
        while (currentTokenId != 0) {
            totalDiffs++;
            currentTokenId = tokenToPatch[currentTokenId].previousTokenId;
        }

        // Calculate pagination details
        uint256 startDiff = page * pageSize;
        uint256 endDiff = startDiff + pageSize;
        endDiff = (endDiff > totalDiffs) ? totalDiffs : endDiff;
        uint256 diffCount = endDiff - startDiff;

        // Allocate memory for the result array
        Revision[] memory diffs = new Revision[](diffCount);
        currentTokenId = tokenId;

        // Skip diffs until the start of the requested page
        for (uint256 i = 0; i < startDiff; i++) {
            currentTokenId = tokenToPatch[currentTokenId].previousTokenId;
        }

        // Collect diffs for the requested page
        for (uint256 i = 0; i < diffCount; i++) {
            diffs[i] = Revision({
                diff: tokenToPatch[currentTokenId].diff,
                name: tokenToPatch[currentTokenId].name,
                author: tokenToPatch[currentTokenId].author,
                previousTokenId: tokenToPatch[currentTokenId].previousTokenId,
                revisions: getRevisionNumber(currentTokenId)
                });
            currentTokenId = tokenToPatch[currentTokenId].previousTokenId;
        }

        return diffs;
    }

     // Modified function to retrieve diffs with pagination
    function getAllDiffsPaginated(uint256 tokenId, uint256 pageSize, uint256 page) public view returns (string[] memory) {
        uint256 totalDiffs = 0;
        uint256 currentTokenId = tokenId;

        // First, count the total number of diffs
        while (currentTokenId != 0) {
            totalDiffs++;
            currentTokenId = tokenToPatch[currentTokenId].previousTokenId;
        }

        // Calculate pagination details
        uint256 startDiff = page * pageSize;
        uint256 endDiff = startDiff + pageSize;
        endDiff = (endDiff > totalDiffs) ? totalDiffs : endDiff;
        uint256 diffCount = endDiff - startDiff;

        // Allocate memory for the result array
        string[] memory diffs = new string[](diffCount);
        currentTokenId = tokenId;

        // Skip diffs until the start of the requested page
        for (uint256 i = 0; i < startDiff; i++) {
            currentTokenId = tokenToPatch[currentTokenId].previousTokenId;
        }

        // Collect diffs for the requested page
        for (uint256 i = 0; i < diffCount; i++) {
            diffs[i] = tokenToPatch[currentTokenId].diff;
            currentTokenId = tokenToPatch[currentTokenId].previousTokenId;
        }

        return diffs;
    }

     // Modified function to retrieve diffs with pagination
    function getAllDiffsPaginated2(uint256 tokenId, uint256 pageSize, uint256 page) public view returns (uint256) {
        uint256 totalDiffs = 0;
        uint256 currentTokenId = tokenId;

        // First, count the total number of diffs
        while (currentTokenId != 0) {
            totalDiffs++;
            currentTokenId = tokenToPatch[currentTokenId].previousTokenId;
        }

        // Calculate pagination details
        uint256 startDiff = page * pageSize;
        uint256 endDiff = startDiff + pageSize;
        endDiff = (endDiff > totalDiffs) ? totalDiffs : endDiff;
        uint256 diffCount = endDiff - startDiff;

        return diffCount;
    }

    function getRevisionNumber(uint256 tokenId) public view returns (uint256) {
        uint256 totalDiffs = 0;
        uint256 currentTokenId = tokenId;

        // First, count the total number of diffs
        while (currentTokenId != 0) {
            totalDiffs++;
            currentTokenId = tokenToPatch[currentTokenId].previousTokenId;
        }

        return totalDiffs;
    }

    function getPatchHeads(bool isSubPatch) public view returns (Commit.HeadData[] memory) {
        uint256 projectCount = 0; 
        for (uint256 i=1; i <= counter; i++) {
            if (tokenToPatch[i].isHead && tokenToPatch[i].isSubPatch == isSubPatch) {
                projectCount++;
            }
        }
        Commit.HeadData[] memory heads = new Commit.HeadData[](projectCount);
        
        uint256 c=0;
        for (uint256 i = 1; i <= counter; i++) {
            if (tokenToPatch[i].isHead && tokenToPatch[i].isSubPatch == isSubPatch) {
                heads[c].name = tokenToPatch[i].name;
                heads[c].revisionNumber = getRevisionNumber(i);
                heads[c].author = tokenToPatch[i].author;
                heads[c].tokenId = i;
                c++;
            }
        }
        
        return heads;
    }
}
