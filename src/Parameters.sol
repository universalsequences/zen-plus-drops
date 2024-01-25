
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library Parameters {
    struct Parameter {
        // we achieve floating points by assuming min = 10 -> 10 / 10000 = 0.01
        string name;
        int64 min;  // divide by 10,000
        int64 max; // divide by 10,000
    }

    // Function to generate a comma-separated string of random values
    function generateParameterNames(Parameter[] memory parameters) public view returns (string memory) {
         string memory result;

        for (uint i = 0; i < parameters.length; i++) {
            // Concatenate the parameter names
            result = string(abi.encodePacked(result, parameters[i].name));

            // Add comma if not the last element
            if (i < parameters.length - 1) {
                result = string(abi.encodePacked(result, ","));
            }
        }

        return result;
    }


    function generateParameters(Parameter[] memory parameters, uint256 seed) public view returns (string memory) {
        bytes memory result;

        for (uint i = 0; i < parameters.length; i++) {
            // Generate a random value within the range
            int64 randomValue = randomInRange(parameters[i].min, parameters[i].max, seed, i);

            // Convert int64 to string and concatenate
            result = abi.encodePacked(result, intToString(randomValue));

            // Add comma if not the last element
            if (i < parameters.length - 1) {
                result = abi.encodePacked(result, ",");
            }
        }

        return string(result);
    }


       // Helper function to generate a random number in a range
    function randomInRange(int64 min, int64 max, uint256 seed, uint i) private view returns (int64) {
        uint256 minUnsigned = min < 0 ? uint256(uint64(-min)) : uint256(uint64(min));
        uint256 maxUnsigned = max < 0 ? uint256(uint64(-max)) : uint256(uint64(max));

        if(min < 0 && max >= 0) {
            maxUnsigned += minUnsigned;
        }

        uint256 range = maxUnsigned - minUnsigned + 1;
        uint256 random = uint256(keccak256(abi.encodePacked(seed, i, seed*minUnsigned, seed*maxUnsigned, max*min, seed*i))) % range;

        if(min < 0 && max >= 0) {
            return int64(int256(random) - int256(minUnsigned));
        } else if(min < 0) {
            return -int64(int256(random));
        }

        return int64(int256(random)) + min;
    }

    // Helper function to convert int64 to string
    function intToString(int64 _i) private pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        bool negative = _i < 0;
        uint64 absI = negative ? uint64(-_i) : uint64(_i);
        bytes memory reverse = new bytes(64);
        uint len = 0;
        do {
            len++;
            reverse[len - 1] = bytes1(uint8(48 + absI % 10));
            absI /= 10;
        } while (absI != 0);
        bytes memory bstr = new bytes(negative ? len + 1 : len);
        if (negative) {
            bstr[0] = '-';
        }
        for(uint i = 0; i < len; i++) {
            bstr[negative ? i + 1 : i] = reverse[len - 1 - i];
        }
        return string(bstr);
    }
}
