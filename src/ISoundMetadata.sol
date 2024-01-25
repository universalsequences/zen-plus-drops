pragma solidity ^0.8.0;
import './Parameters.sol';

interface ISoundMetadata {
    // A Work represents a blueprint for modules. As they get minted, tokens
    // represent a "Module". Modules have inputs/outputs and set parameters.
    // They represent a module in a modular synthesizer.
    struct Work {
        string contractURI;
        string name;
        string description;
        string dsp;
        string visuals;
        Parameters.Parameter[] parameters;
        string[] inputs; // module input names
        string[] outputs; // module output names
        bool useExternalRenderer; // whether we need to use the hacky renderer to enable zora pages
        uint256 createdAt;
        string image;
    }

    function getDSP(address contractAddress) external view returns (string memory);
    function getParameters(address contractAddress) external view returns (Parameters.Parameter[] memory);
}
