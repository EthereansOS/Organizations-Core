// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

/**
 * @title Double Proxy Interface
 * @dev
 *
 */
interface IDoubleProxy {
    /**
     * @dev Initializer logic used during the constructor call
     * @param proxies Array of address of the old proxies, only used in legacy scenarios. Can be left empty.
     * @param currentProxy Address of the current proxy
     */
    function init(address[] calldata proxies, address currentProxy) external;

    /**
     * @dev GET the proxy
     */
    function proxy() external view returns (address);

    /**
     * @dev SET the proxy
     */
    function setProxy() external;

    /**
     * @dev Check if the address is or has been a proxy
     */
    function isProxy(address) external view returns (bool);

    /**
     * @dev GET the number of proxies
     */
    function proxiesLength() external view returns (uint256);

    /**
     * @dev Retrieve a portion of the proxies
     */
    function proxies(uint256 start, uint256 offset)
        external
        view
        returns (address[] memory);

    function proxies() external view returns (address[] memory);
}
