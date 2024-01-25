// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console2} from "forge-std/Test.sol";
import "../src/ISoundMetadata.sol";
import "../src/ZenModule.sol";
import {Counter} from "../src/Counter.sol";

contract MockERC721 {
    address owner;
    constructor() {
        owner = msg.sender;
    }

    function ownerOf(uint256 tokenId) public returns (address) {
        return owner;
    }
}

contract MockMetadata is ISoundMetadata {

    constructor() {
    }

    /// @notice NFT metadata by contract
    mapping(address => Work) public workByContract;

    function getDSP(address contractAddress) external view returns (string memory) {
        return workByContract[contractAddress].dsp;
    }

    function getParameters(address contractAddress) external view returns (Parameters.Parameter[] memory) {
        return workByContract[contractAddress].parameters;
    }
 
}


contract CounterTest is Test {
    ZenModule public zen;

    MockERC721 contract1;
    MockERC721 contract2;
    MockERC721 contract3;
    MockERC721 contract4;
    MockERC721 contract5;

    function setUp() public {
        zen = new ZenModule(address(new MockMetadata()));

        contract1 = new MockERC721();
        contract2 = new MockERC721();
        contract3 = new MockERC721();
        contract4 = new MockERC721();
        contract5 = new MockERC721();

        zen.configureToken(address(contract1), 1, 0, address(contract2), 1, 0);
        zen.configureToken(address(contract2), 1, 0, address(contract3), 1, 0);
        zen.configureToken(address(contract3), 1, 0, address(contract4), 1, 0);
        zen.configureToken(address(contract2), 1, 1, address(contract5), 1, 0);
    }

    function test_Increment() public {

        console2.log(string(zen.generateAll(address(contract1), 1)));
    }

    function testFuzz_SetNumber(uint256 x) public {
    }
}
