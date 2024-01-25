// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library Commit {
    struct HeadData  {
        string name;
        uint256 revisionNumber;
        address author;
        uint256 tokenId;
    }
}
