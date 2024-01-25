

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import {AddressUtils} from './AddressUtils.sol';
import {IMetadataRenderer} from "zora-drops-contracts/interfaces/IMetadataRenderer.sol";
import './ZenModule.sol';
import './Parameters.sol';
import './IData.sol';
import './Base64.sol';
import './ISoundMetadata.sol';
import './Conversion.sol';
import {MetadataRenderAdminCheck} from "zora-drops-contracts/metadata/MetadataRenderAdminCheck.sol";
import {IERC721Drop} from "zora-drops-contracts/interfaces/IERC721Drop.sol";
import {IERC721AUpgradeable} from "ERC721A-Upgradeable/IERC721AUpgradeable.sol";

contract SoundMetadataRenderer is IMetadataRenderer, MetadataRenderAdminCheck, ISoundMetadata {

    uint256 private counter;

    // Zen Library is broken up into 3 pieces stored at 3 different contracts all 
    IData public libraryChunk1;
    IData public libraryChunk2;
    IData public libraryChunk3;
    IData public glLibrary;

    ZenModule public zenModule;

    /// @notice NFT metadata by contract
    mapping(address => Work) public workByContract;

    event ZenModuleInitialized (address);
    constructor(address lib1, address lib2, address lib3, address glLib) {
        counter=0;
        libraryChunk1 = IData(lib1);
        libraryChunk2 = IData(lib2);
        libraryChunk3 = IData(lib3);
        glLibrary = IData(glLib);

        zenModule = new ZenModule(address(this));
        emit ZenModuleInitialized(address(zenModule));
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


    function getDSP(address contractAddress) external view returns (string memory) {
        return workByContract[contractAddress].dsp;
    }

    function getParameters(address contractAddress) external view returns (Parameters.Parameter[] memory) {
        return workByContract[contractAddress].parameters;
    }
    
   /**
    * fully onchain representationj
    * zora's frontend is afraid of calling this from their site, due to security.
    * We will point the true tokenURI to an endpoint that simply renders this as an HTML
    */
   function onchainTokenURI(address dropAddress, uint256 tokenId) public view returns (string memory) {
        return string(abi.encodePacked(
          'data:application/json;base64,',
          Base64.encode(bytes(
            abi.encodePacked(
              "{",
              "\"animation_url\": \"",
            string(abi.encodePacked(
                "data:text/html;base64,",
                Base64.encode(abi.encodePacked(generateHTML(tokenId, dropAddress))))),
              "\",",
              "\"image\": \"", workByContract[dropAddress].image, "\",",
              "\"name\": \"", workByContract[dropAddress].name,"\",",
              "\"description\": \"", workByContract[dropAddress].description,"\"",
              "}")))));
    }

   function tokenURI(uint256 tokenId) external view returns (string memory) {
       uint256 timeElapsed = block.timestamp - workByContract[msg.sender].createdAt;

       // after a year since creation of the particular work, we lock permanently to using
       // the fully onchain token representation. 
       if (workByContract[msg.sender].useExternalRenderer && timeElapsed < 60 * 24 * 365) {
           return string(abi.encodePacked(
               'data:application/json;base64,',
               Base64.encode(bytes(
               abi.encodePacked(
              "{",
              "\"image\": \"", workByContract[msg.sender].image, "\",",
              "\"animation_url\": \"https://zen-plus.vercel.app/api/getHTML?contractAddress=", AddressUtils.toAsciiString(msg.sender),
              "&tokenId=", Conversion.uint2str(tokenId),
              "\",",
              "\"name\": \"", workByContract[msg.sender].name, Conversion.uint2str(tokenId) ,"\",",
              "\"description\": \"", workByContract[msg.sender].description,"\"",
              "}")))));
       } else {
           return onchainTokenURI(msg.sender, tokenId);
       }
    }


    function generateHTML(uint256 tokenId, address target) public view returns (string memory) {
        string memory dsp = workByContract[target].dsp;
        uint256 seed = tokenId;
        bytes memory audioLibraries;
        {
            
            audioLibraries = abi.encodePacked(
            libraryChunk1.getData(),
            libraryChunk2.getData(),
            libraryChunk3.getData());
        }

        bytes memory part1;
        {
            part1 = abi.encodePacked(
            '<!DOCTYPE html><html lang="en"><head>',
            '<meta charset="UTF-8">',
            '<meta name="viewport" content="width=device-width, initial-scale=1.0">',
            '<style>#aw { z-index: 31; display: none; position: fixed; top: 50%; left: 50%; transform: translate(-50%, -50%); padding: 5px; width: 400px; height: 200px; background: white; text-align: center; }</style>'
            '<title>Music Generator</title>'
            '</head>'
            '<body style="overflow-wrap:break-word;font-family:monospace;background-color: black; display: flex; margin: 0"><canvas id="canvas" style="display:flex;flex-direction:column;position:absolute;top:0;left:0;min-width:100vw;min-height:100vh"></canvas>'
            '<div id="aw">This marketplace does not support AudioWorklet yet. Visit <a target="_blank" href="https://bleep.fun">bleep.fun</a> or <a href="https://opensea.io">Opensea</a> for the full experience.</div>',
            '<div id="playButton" style="position: absolute; z-index: 30; width: 0; height: 0; border-top: 30px solid transparent; border-bottom: 30px solid transparent; border-left: 60px solid #E2E5DE; margin: auto; position: absolute; top: 0; right: 0; bottom: 0; left: 0;"></div>'
            '<script>',
            audioLibraries,
            glLibrary.getData(),
            ';let isPlaying = false; let initialized=false;'
            ';let workletNode, gainNode;',
            'function dsp(', Parameters.generateParameterNames(workByContract[target].parameters), ') {\n'
                    'let history = window.ZEN_LIB.history;\n',
                                                              dsp,
            '\n}\n'
            );
        }

        bytes memory part2;
            
        {
            part2 = abi.encodePacked(
            'let useC = false;\n',
            'window.addEventListener("message", (e) => { if (e.data === "useC") { useC = true; }});\n',
'const m = {};\n'
'let uniforms = {};'
'const update = (t, v) => {\n'
'if (v === true) v = 1; else if (v === false) v = 0;\n'
'    m[t] = v;\n'
'if (t in uniforms) { uniforms[t].set(v); }\n' // this updates the uniform
'}\n'
'const visuals = () => {\n',
workByContract[target].visuals,
'}\n'
'const render = () => {\n'
'};\n'
'requestAnimationFrame(render);\n'
'\nfunction generateMusic() {'
            'const button = document.getElementById("playButton");'
            'if (isPlaying) {'
                'button.style.borderTop = "30px solid transparent";'
                'button.style.borderBottom = "30px solid transparent";'
                'button.style.borderLeft = "60px solid #E2E5DE";'
                'button.style.width= "0";'
                'button.style.height= "0";'
                'button.style.borderRight = "0";'
            '} else {'
                'button.style.width= "30px";'
                'button.style.height= "80px";'
                'button.style.borderTop = "0";'
                'button.style.borderBottom = "0";'
                'button.style.borderLeft = "30px solid #E2E5DE";'
                'button.style.borderRight = "30px solid #E2E5DE";'
            '}'
            'isPlaying = !isPlaying;\n'
            'if (!initialized) {\n'
                'initialized=true;\n',
                zenModule.generateAll(target, tokenId),
                'gainNode = gain;\n'                     
            '}\n'
            'gainNode.gain.value = isPlaying ? 1 : 0',
            '}\n' // end of generate music func
                  );
            }

            bytes memory part3;
            {
                part3 = abi.encodePacked(
                    '      window.onload =()=> {\n '
'setTimeout(() => {\n'
'const canvas =document.getElementById("canvas");\n'
'let vis = visuals();\n'
'uniforms = vis.uniforms;\n'
'let glGraph = gl.zen(vis.code);\n'
'let render = gl.mount([glGraph], canvas);\n'
'let work = () => {\n'
'    render(window.innerWidth, window.innerHeight)\n' 
'    requestAnimationFrame(work);\n'
'}\n'
'work();\n'
'}, 250);\n'
'if(window.parent && document.referrer){\n'
' var sourceURL=document.referrer;\n'
' window.parent.postMessage("ready", sourceURL);\n'
'}\n'
'const button=document.getElementById("playButton");\n'
'let id=0;\n'
'window.addEventListener("click",()=> {\n'
'generateMusic();\n'
'});\n'
'window.addEventListener("touchstart",()=> {\n'
'generateMusic();\n'
'});'
'window.addEventListener("mousemove",()=> {\n'
'if(!isPlaying){\n'
'button.style.opacity=1;\n'
'return;\n'
'}\n'
'let _id=++id;\n'
'button.style.opacity=1;\n'
'setTimeout(()=> {\n'
'if(_id !== id){\n'
'return;\n'
'}\n'
'button.style.opacity=0;\n'
'}, 1000);\n'
'});\n'
'button.style.display="block";\n'
'}'
                    '</script>',
                    '</body>',
                    '</html>'
            );
            }

        return string(abi.encodePacked(part1, part2, part3));
    }


    function contractURI() external view returns (string memory) {
        string memory uri = workByContract[msg.sender].contractURI;
        if (bytes(uri).length == 0) revert();
        return uri;
    }

    function initializeWithData(bytes memory data) external {
         // Decode the data
        (string memory initialContractURI,
         string memory name,
         string memory description,
         string memory dsp,
         string memory visuals,
         string[] memory parametersArray,
         int64[] memory minValues,
         int64[] memory maxValues,
         string[] memory inputs,
         string[] memory outputs,
         string memory image
         ) = abi
            .decode(data, (string,string,string,string, string, string[], int64[], int64[], string[], string[], string));

        // Ensure arrays are of the same length
        require(parametersArray.length == minValues.length && minValues.length == maxValues.length, "Array lengths mismatch");


        // by default we use external renderer (for zora)
        workByContract[msg.sender].createdAt = block.timestamp;
        workByContract[msg.sender].image = image;
        workByContract[msg.sender].useExternalRenderer = true;
        workByContract[msg.sender].contractURI = initialContractURI;
        workByContract[msg.sender].dsp = dsp;
        workByContract[msg.sender].visuals = visuals;
        workByContract[msg.sender].name = name;
        workByContract[msg.sender].description = description;

        for(uint i = 0; i < parametersArray.length; i++) {
            // Fill the local array with ParameterInfo
            workByContract[msg.sender].parameters.push(Parameters.Parameter({
                name: parametersArray[i],
                min: minValues[i],
                max: maxValues[i]
                    }));
        }

        for(uint i = 0; i < inputs.length; i++) {
            workByContract[msg.sender].inputs.push(inputs[i]);
        }
        
        for(uint i = 0; i < outputs.length; i++) {
            workByContract[msg.sender].outputs.push(outputs[i]);
        }
    }
}
