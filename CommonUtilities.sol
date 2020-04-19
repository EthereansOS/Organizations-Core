pragma solidity ^0.6.0;

import "./ICommonUtilities.sol";

contract CommonUtilities is ICommonUtilities {

    function toString(address _addr) public override pure returns(string memory) {
        bytes32 value = bytes32(uint256(_addr));
        bytes memory alphabet = "0123456789abcdef";

        bytes memory str = new bytes(42);
        str[0] = '0';
        str[1] = 'x';
        for (uint i = 0; i < 20; i++) {
            str[2+i*2] = alphabet[uint(uint8(value[i + 12] >> 4))];
            str[3+i*2] = alphabet[uint(uint8(value[i + 12] & 0x0f))];
        }
        return string(str);
    }

    function toString(uint _i) public override pure returns(string memory) {
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
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

    function toUint256(bytes memory bs) public override pure returns(uint256 x) {
        if(bs.length >= 32) {
            assembly {
                x := mload(add(bs, add(0x20, 0)))
            }
        }
    }

    function toAddress(bytes memory b) public override pure returns (address addr) {
        if(b.length > 0) {
            assembly {
                addr := mload(add(b,20))
            }
        }
    }

    function compareStrings(string memory a, string memory b) public override pure returns(bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }

    function getFirstJSONPart(address sourceLocation, uint256 sourceLocationId, address location) public override pure returns(bytes memory) {
        return abi.encodePacked(
            '"sourceLocation":"',
            toString(sourceLocation),
            '","sourceLocationId":',
            toString(sourceLocationId),
            ',"location":"',
            toString(location)
        );
    }

    function formatReturnAbiParametersArray(string memory m) public override pure returns(string memory) {
        bytes memory b = bytes(m);
        if(b.length < 2) {
            return "[]";
        }
        if(b[0] != bytes1("[")) {
            return "[]";
        }
        if(b[b.length - 1] != bytes1("]")) {
            return "[]";
        }
        return m;
    }

    function toLowerCase(string memory str) public override pure returns(string memory) {
        bytes memory bStr = bytes(str);
        for (uint i = 0; i < bStr.length; i++) {
            bStr[i] = bStr[i] >= 0x41 && bStr[i] <= 0x5A ? bytes1(uint8(bStr[i]) + 0x20) : bStr[i];
        }
        return string(bStr);
    }
}