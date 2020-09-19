// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

/**
 * @title Functionality Proposal Manager
 * @dev Microservice for adding new proposals
 */
interface IMVDFunctionalityProposalManager {
    /**
     * @dev Add a new Proposal
     * @param codeName ID of the proposal
     * @param location Address of the functionality/microservice to call
     * @param methodSignature Name of the method of the microservice you want to call
     * @param returnAbiParametersArray Array of return values obtained from the called microservice's method
     * @param replaces // DOCUMENT
     * @return proposal Address of the newly added proposal
     */
    function newProposal(
        string calldata codeName,
        address location,
        string calldata methodSignature,
        string calldata returnAbiParametersArray,
        string calldata replaces
    ) external returns (address proposal);

    // DOCUMENT
    function checkProposal(address proposalAddress) external;

    /**
     * @dev GET the Proxy contract address
     */
    function getProxy() external view returns (address);

    /**
     * @dev SET the Proxy contract address
     */
    function setProxy() external;

    /**
     * @dev Check that a proposal is valid
     * @param proposal Address of the proposal to check
     * @return isValid Boolean indicating the validity of the function
     */
    function isValidProposal(address proposal) external view returns (bool isValid);
}
