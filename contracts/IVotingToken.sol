// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

/**
 * @title Voting Token interface
 */
interface IVotingToken {
    /**
     * @dev Initialization logic using during the constructor Call
     * @param name Name of the token used
     * @param symbol Ticker symbol of the token used
     * @param decimals Amount of decimals supported by the token
     * @param totalSupply Total Supply of the token
     */
    function init(
        string calldata name,
        string calldata symbol,
        uint256 decimals,
        uint256 totalSupply
    ) external;

    /**
     * @dev GET the Proxy
     */
    function getProxy() external view returns (address);

    /**
     * @dev SET the Proxy
     */
    function setProxy() external;

    /**
     * @dev GET the token name
     */
    function name() external view returns (string memory);

    /**
     * @dev GET the token ticker symbol
     */
    function symbol() external view returns (string memory);

    /**
     * @dev GET amount of decimals supported by the token
     */
    function decimals() external view returns (uint256);

    /**
     * @dev Mint functionality of the voting token
     */
    function mint(uint256 amount) external;

    /**
     * @dev Burn functionality of the voting token
     */
    function burn(uint256 amount) external;

    /**
     * @dev see the OpenZeppelin's documentation
     */
    function increaseAllowance(address spender, uint256 addedValue) external returns (bool);

    /**
     * @dev see the OpenZeppelin's documentation
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
}
