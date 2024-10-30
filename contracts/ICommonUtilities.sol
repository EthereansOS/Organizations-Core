// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

/**
 * @title Common Utilities
 * @dev Collection of simple utilities
 */
interface ICommonUtilities {
    /**
     * @dev Convert address to string
     */
    function toString(address _addr) external pure returns (string memory);

    /**
     * @dev Convert uint to string
     */
    function toString(uint256 _i) external pure returns (string memory);

    /**
     * @dev Convert bytes address to uint
     */
    function toUint256(bytes calldata bs) external pure returns (uint256 x);

    /**
     * @dev Convert bytes address to address
     */
    function toAddress(bytes calldata b) external pure returns (address addr);

    /**
     * @dev Compare to strings
     */
    function compareStrings(string calldata a, string calldata b)
        external
        pure
        returns (bool);

    // DOCUMENT
    function getFirstJSONPart(
        address sourceLocation,
        uint256 sourceLocationId,
        address location
    ) external pure returns (bytes memory);

    // DOCUMENT
    function formatReturnAbiParametersArray(string calldata m)
        external
        pure
        returns (string memory);

    /**
     * @dev Convert a string to lowercase
     */
    function toLowerCase(string calldata str)
        external
        pure
        returns (string memory);
}
