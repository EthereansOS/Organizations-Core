pragma solidity >=0.7.0;

/**
 * @title Wallet
 * @dev The wallet is used to store all the assets of a DFO (ethers, ERC20 Tokens, ERC721 NFTs).
 * All the functions to transfer assets can be called by the Proxy only.
 */
interface IMVDWallet {
    /**
     * @dev GET the proxy address
     */
    function getProxy() external view returns (address);

    /**
     * @dev SET the proxy address
     */
    function setProxy() external;

    /**
     * @dev SET new wallet
     * @param newWallet New wallet address
     * @param tokenAddress The voting token, used to flush balance to new wallet
     */
    function setNewWallet(address payable newWallet, address tokenAddress)
        external;

    /**
     * @dev Transfer a token to an address
     * @param receiver Address of the receiver
     * @param value Amount of token to transfer
     * @param tokenAddress Address of the token to transfer
     */
    function transfer(
        address receiver,
        uint256 value,
        address tokenAddress
    ) external;

    /**
     * @dev Transfer an ERC721 to an address
     * @param receiver Address of the receiver
     * @param tokenId ID of the ERC721 to transfer
     * @param data The optional payload to pass in the safeTransferFrom function
     * @param safe Boolean flag for triggering the SafeTransfer
     * @param token Address of the token to transfer
     */
    function transfer(
        address receiver,
        uint256 tokenId,
        bytes calldata data,
        bool safe,
        address token
    ) external;

    /**
     * @dev Send all of the specified tokens to the NewWallet
     * @param token Address of the token to send
     */
    function flushToNewWallet(address token) external;

    /**
     * @dev Transfer an ERC721 to the NewWallet
     * @param tokenId ID of the ERC721 to transfer
     * @param data The optional payload passed in the safeTransferFrom function
     * @param safe Boolean flag for triggering the SafeTransfer
     * @param tokenAddress Address of the token to transfer
     */
    function flush721ToNewWallet(
        uint256 tokenId,
        bytes calldata data,
        bool safe,
        address tokenAddress
    ) external;
}
