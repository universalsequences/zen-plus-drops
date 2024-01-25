// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import './Parameters.sol';
import './Conversion.sol';
import './IERC721.sol';
import './ISoundMetadata.sol';

/**
 * A zen module defines its INPUTS and OUTPUTS
 *
 * They can connect with one another this way.
 */

contract ZenModule {

    // by default they are not set
    struct WorkToken {
        ConfiguredInput[8] inputs;
    }

    struct ConfiguredInput {
        address contractAddress;
        uint256 tokenId;
        uint8 outputNumber;
        bool isConfigured;
    }

    struct Output {
        string name;
    }


    mapping(address => mapping(uint256 => WorkToken)) private workTokens;

    address metadataRenderer;
    constructor(address metadataRendererAddress) {
        metadataRenderer = metadataRendererAddress;
    }

    function getWorkToken(address contractAddress, uint256 tokenId) public returns (WorkToken memory) {
        return workTokens[contractAddress][tokenId];
    }
                                                                                                       
    event ModuleConfigured(address user, address contractAddress, uint256 tokenId, uint256 inputNumber, address source, uint256 sourceToken, uint8 outputNumber);

    function configureToken(address contractAddress, uint256 tokenId, uint256 inputNumber, address source, uint256 sourceToken, uint8 outputNumber  ) public {
        /**
         * TODO: ensure that a you never use the same dest node i.e.
         * you can only use one output from a node as an input for another node
         * ensure loops not created
         * todo: ensure owned by snder
         */
        require(IERC721(contractAddress).ownerOf(tokenId) == msg.sender);

        // todo: check each Work definition to ensure the input/output exists...
        require(inputNumber < 8);
        require(outputNumber < 8);

        workTokens[contractAddress][tokenId].inputs[inputNumber].contractAddress = source;
        workTokens[contractAddress][tokenId].inputs[inputNumber].tokenId = sourceToken;
        workTokens[contractAddress][tokenId].inputs[inputNumber].outputNumber = outputNumber;
        workTokens[contractAddress][tokenId].inputs[inputNumber].isConfigured = true;

        emit ModuleConfigured(msg.sender, contractAddress, tokenId, inputNumber, source, sourceToken, outputNumber);
    }

    // if you own the NFT you can set the contract

    // by default they get set to the phasor module so that they may run
    // but can be edited

    function countWorks(address contractAddress, uint256 tokenId) public view returns (uint8) {
        // go thru the inputs and generate them
        // first we need to know how many works will be loaded
        uint8 numberOfWorks = 1;
        WorkToken memory token = workTokens[contractAddress][tokenId];
        for (uint8 i=0; i < token.inputs.length; i++) {
            if (token.inputs[i].isConfigured) {
                numberOfWorks += countWorks(
                    token.inputs[i].contractAddress,
                    token.inputs[i].tokenId);
            }
        }
        return numberOfWorks;
    }

    // so if we know how many we have we can wait for all the registers to complete
    // and then we need to connect them. how do we connect them

    function generateConnections(address contractAddress, uint256 tokenId, uint8 index) public view returns (bytes memory) {
        bytes memory connections = abi.encodePacked();

        uint8 count = 0;
        WorkToken memory token = workTokens[contractAddress][tokenId];
        for (uint8 i=0; i < token.inputs.length; i++) {
            // determine what index in the workletsRegistered list refers to the node that goes INTO
            // this one
            // this is simply index + i
            // connect(source, dest, sourceOutputNumber, destInputNumber
            if (token.inputs[i].isConfigured) {
            connections = abi.encodePacked(
                connections,
                'connect(workletsRegistered[', Conversion.uint2str(index+count+i+1), '], workletsRegistered[', Conversion.uint2str(index), '],' ,
                         Conversion.uint2str(token.inputs[i].outputNumber), ',',
                         Conversion.uint2str(i), ');\n',
                generateConnections(token.inputs[i].contractAddress, token.inputs[i].tokenId, index + count + 1)

        );

            // since we generate everything via Depth First, we need to count how many works were added so we can
            // correctly match the right one
            count += countWorks(token.inputs[i].contractAddress, token.inputs[i].tokenId) - 1;
            }
        }
        return connections;
    }

    function generateAll(address contractAddress, uint256 tokenId) public view returns (bytes memory) {
        return abi.encodePacked(
            'let ctxt = new (window.AudioContext || window.webkitAudioContext)({sampleRate:44100});\n',
            'if (ctxt.state === "suspended") {\n ctxt.resume();\n}\n'
            'let gain = ctxt.createGain(0);\n'
            'gain.connect(ctxt.destination);\n',
            generateConnectFunction(),
            generateRegister(contractAddress, tokenId),
            generateAudioWorklets(contractAddress, tokenId, 0)
       );
    }

    function generateConnectFunction() public view returns (bytes memory) {
       return abi.encodePacked(
           'function connect(source, dest, sourceOut, destIn) {\n'
           'let merger = ctxt.createChannelMerger(destIn+1)\n'
           'let splitter = ctxt.createChannelSplitter(sourceOut+1);\n'
           'source.connect(splitter);\n'                                                            
           'splitter.connect(merger, sourceOut, destIn);\n'                                                            
           'merger.connect(dest);\n'                                                            
           '}\n'
           );
    }

    function generateAudioWorklets(address contractAddress, uint256 tokenId, uint8 index) public view returns (bytes memory) {
        bytes memory ret = generateAudioWorklet(ISoundMetadata(metadataRenderer).getDSP(contractAddress),
                                                ISoundMetadata(metadataRenderer).getParameters(contractAddress),
                                                index, tokenId);

        uint8 count = 0;
        WorkToken memory token = workTokens[contractAddress][tokenId];
        for (uint8 i=0; i < token.inputs.length; i++) {
            if (token.inputs[i].isConfigured) {
                ret = abi.encodePacked(
                ret,
                generateAudioWorklets(token.inputs[i].contractAddress, token.inputs[i].tokenId, index + count + 1));
                // since we generate everything depth first, we need to count how many works were added so we can
                // correctly match the right one
                count += countWorks(token.inputs[i].contractAddress, token.inputs[i].tokenId);
            }
        }
        return ret;
    }

    function generateRegister(address contractAddress, uint256 tokenId) public view returns (bytes memory) {
        uint8 numberOfWorks = countWorks(contractAddress, tokenId);
        bytes memory b;
        {
            b = abi.encodePacked(
                'let workletsRegistered = [];\n'
                'let workletCount = 0;\n'
                'function registerWorklet(worklet, index) {\n'
                     'workletCount++;\n'
                     'workletsRegistered[index] = worklet;\n',
                     'if (workletCount === ', Conversion.uint2str(numberOfWorks), ') {\n',
                         generateConnections(contractAddress, tokenId, 0),
                         '\nworkletsRegistered[0].connect(gain)\n'
                     '}\n'          
                '}');
        }
        return b;
    }

    function generateAudioWorklet(string memory dsp, Parameters.Parameter[] memory parameters, uint8 index, uint256 seed) public view returns (bytes memory) {
        bytes memory moduleName;
        bytes memory graphVar;
        bytes memory moduleVar;
        {
            moduleName = abi.encodePacked('module_', Conversion.uint2str(index));
            moduleVar = abi.encodePacked('eval_', Conversion.uint2str(index));
            graphVar = abi.encodePacked('graph_', Conversion.uint2str(index));
        }


        bytes memory functionDef;
        {
            functionDef = abi.encodePacked(
            'function ', moduleName, '(', Parameters.generateParameterNames(parameters), ') {\n'
                'let history = window.ZEN_LIB.history;\n',
                dsp,
                '\n}\n');
        }

        bytes memory worklet;
        {
            worklet = abi.encodePacked(
                'createWorklet(ctxt, ', graphVar, ', "', graphVar,'").then(z => {\n'
                // register the worklet. once all have loaded we will connect them together and to the speakers
                'let workletNode =  z.workletNode;\n'
                'let zenGraph = ', graphVar, ';\n'
                'registerWorklet(z.workletNode, ', Conversion.uint2str(index), ');\n'
                'workletNode.port.onmessage = (e) => {\n'
                  'let {type, body} = e.data\n'
                  'if (type && type !== "ack" && type !== "wasm-ready") {'
                    'update(type, body);' // updates visuals w messages from worklet
                  '}\n'
                  'if (type === "wasm-ready" && useC) {\n'
                    'initMemory(zenGraph.context, workletNode);\n' // for C version we need to manually call initMemory
                    'workletNode.port.postMessage({ type: "ready" });\n'
                  '}\n'
                '}\n'
              '}\n'
            '\n);'
            );
        }

        return abi.encodePacked(
            functionDef,
            'let ', moduleVar, ' = ', moduleName, '(', Parameters.generateParameters(parameters, seed), ');\n'
            'let ', graphVar, ' = useC ? zenC(', moduleVar, ') : zen(', moduleVar, ');\n',
            worklet,
            '\n'
        );
   }
}
 
