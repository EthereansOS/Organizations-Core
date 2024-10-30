// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

/**
 * @title Double Proxy Interface
 * @dev Double Proxy is the easiest way for side/external Contracts to locate and query the DFO.
 * As the main Core Contract of a DFO is the Proxy, it also can be updated by Proposals.
 * So, directly link the Proxy to external Contracts can be really a problem.
 * To avoid this, it is better to link external contracts with the DoubleProxy.
 * DoubleProxy is the Proxy of the Proxy, and is a Delegate that keeps track of the most recent Proxy address and all the other previous Proxies.
 * Because it has a very lightweight and simple structure and logic, it does not need of changes, so it can be used as a secure anchor.
 */
interface IDoubleProxy {
    /**
     * @dev Initializer logic used during the constructor call
     * @param proxies Array of address of the old proxies, only used in legacy scenarios. Can be left empty.
     * @param currentProxy Address of the current Proxy
     */
    function init(address[] calldata proxies, address currentProxy) external;

    /**
     * @dev GET the current Proxy
     */
    function proxy() external view returns (address);

    /**
     * @dev Method callable by the current Proxy only. It is used when the Proxy or this delegate changes.
     */
    function setProxy() external;

    /**
     * @dev Check if the address is or has been a Proxy
     */
    function isProxy(address) external view returns (bool);

    /**
     * @dev GET the number of proxies
     */
    function proxiesLength() external view returns (uint256);

    /**
     * @dev Retrieve a portion of the proxies
     * @param start Start Position
     * @param offset End Position
     */
    function proxies(uint256 start, uint256 offset)
        external
        view
        returns (address[] memory);

    /**
     * @dev Retrieve all the proxies
     */
    function proxies() external view returns (address[] memory);
}
