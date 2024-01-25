// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
   Conversion library from unsigned integer to string
 */
library Conversion {

    function stringToInt(string memory s) public pure returns (int) {
        bytes memory b = bytes(s);
        bool negative = false;
        uint startIndex = 0;

        if (b.length == 0) {
            revert("Empty string provided.");
        }

        if (b[0] == '-') {
            negative = true;
            startIndex = 1;
        }

        uint result = 0;
        for (uint i = startIndex; i < b.length; i++) {
            if (uint8(b[i]) >= 48 && uint8(b[i]) <= 57) {
                result = result * 10 + (uint8(b[i]) - 48);

                // Overflow check for positive numbers
                if (!negative && result > (2**255 - 1)) {
                    revert("Value out of range for int type.");
                }

                // Underflow check for negative numbers
                if (negative && result > 2**255) {
                    revert("Value out of range for int type.");
                }
            } else {
                revert("Invalid character found. Only digits 0-9 and optionally '-' at the beginning allowed.");
            }
        }

        return negative ? -int(result) : int(result);
    }

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
   }

    function int2float(int i) internal pure returns (string memory) {
        //     3 -> 0.003 
        //    30 -> 0.03
        //   300 -> 0.30
        //  3000 -> 3.0
        // 30000 -> 30
        //uint decimalSize = 3;
        if (i == 0) {
            return "0.0";
        }
        string memory str = uint2str(abs(i));
        uint256 len = strlen(str);
        if (len <= 3) {
            return string(abi.encodePacked(
                i < 0 ? "-" : "", "0.", repeat("0", 3 - len), str));
        } else {
            return string(abi.encodePacked(
                i < 0 ? "-" : "",
                substring(str, 0, len - 3), ".",
                substring(str, len - 3, len)
            ));
        }
    }

    function substring(string memory str, uint startIndex, uint endIndex) public pure returns (string memory ) {
        bytes memory strBytes = bytes(str);
        bytes memory result = new bytes(endIndex-startIndex);
        for(uint i = startIndex; i < endIndex; i++) {
            result[i-startIndex] = strBytes[i];
        }
        return string(result);
    }

    function repeat(string memory a, uint256 repeats) public pure returns (string memory) {
        string memory b = "";
        for (uint256 i=0; i < repeats; i++) {
            b = string(
                abi.encodePacked(
                    b, a
                ));
        }
        return b;
    }

    function strlen(string memory s) internal pure returns (uint256) {
        uint256 len;
        uint256 i = 0;
        uint256 bytelength = bytes(s).length;
        for (len = 0; i < bytelength; len++) {
            bytes1 b = bytes(s)[i];
            if (b < 0x80) {
                i += 1;
            } else if (b < 0xE0) {
                i += 2;
            } else if (b < 0xF0) {
                i += 3;
            } else if (b < 0xF8) {
                i += 4;
            } else if (b < 0xFC) {
                i += 5;
            } else {
                i += 6;
            }
        }
        return len;
    } 


    function abs(int x) private pure returns (uint) {
        return x >= 0 ? uint(x) : uint(-x);
    }       
}
