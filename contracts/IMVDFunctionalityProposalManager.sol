// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

interface IMVDFunctionalityProposalManager {
    /**
     * @dev Add a new Proposal
     * @param codeName ID of the proposal
     * @param location // DOCUMENT
     * @param methodSignature // DOCUMENT
     * @param returnAbiParametersArray // DOCUMENT
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
    function isValidProposal(address proposal)
        external
        view
        returns (bool isValid);
}
