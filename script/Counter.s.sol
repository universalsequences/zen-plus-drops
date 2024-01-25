// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "../src/ZenMetadataRenderer.sol";
import "../src/ZenLibrary0.sol";
import "../src/ZenLibrary1.sol";
import "../src/ZenLibrary2.sol";
import "../src/ZenGLLibrary.sol";
import "../src/SoundMetadataRenderer.sol";
import "../src/SoundDropCreator.sol";
import "../src/PatchMinter.sol";
import "../src/ZenDropCreator.sol";

import {Script, console2} from "forge-std/Script.sol";

contract CounterScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        /*
        ZenMetadataRenderer renderer = new ZenMetadataRenderer();
        PatchMinter minter = new PatchMinter(address(renderer));
        ZenDropCreator creator = new ZenDropCreator(address(minter));
        creator.newDrop(address(renderer), msg.sender);


        //ZenLibrary0 lib1 = ZenLibrary0(address(0x66AEc44BD477904EbD927a0126E47cb0cB6148eB));
        //ZenLibrary1 lib2 = ZenLibrary1(address(0x461F5d186BAEC11A3BcF7c0f84bfcb8D159d1745));
        //ZenLibrary2 lib3 = ZenLibrary2(address(0xC8450EE2d34FBFF454EFDd2De15e0c4feE103030));

        */

        
        // audio libraries (uncompressed - note: on non-L2s can use compressed version)
        ZenLibrary0 lib1 = new ZenLibrary0(); 
        ZenLibrary1 lib2 = new ZenLibrary1(); 
        ZenLibrary2 lib3 = new ZenLibrary2(); 

        // fragment shader library (uncompressed/again could compress on non-L2)
        ZenGLLibrary glLibrary = new ZenGLLibrary();

        SoundMetadataRenderer renderer = new SoundMetadataRenderer(
            address(lib1),
            address(lib2),
            address(lib3),
            address(glLibrary));
        SoundDropCreator creator = new SoundDropCreator(address(renderer));

        vm.stopBroadcast();
    }
}
