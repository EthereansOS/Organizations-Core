// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

/**
 * @title Functionality Proposal Manager
 * @dev Microservice for adding new proposals
 */
interface IMVDFunctionalityProposalManager {
    /**
     * @dev Add a new Proposal
     * Work explanation:
     * codeName is set and replaces is blank: the Proposal will add a new Microservice/Functionality
     * codeName is blank and replaces is set: the Proposal will remove an existing Microservice/Functionality
     * codeName and replaces are both set: the Proposal will replace an existing Functionality/Microservice with a new one
     * codeName and replaces are both blank: the Proposal represents a One-Time Functionality, that will be executed just one time, if the Token Holders Pccepts this proposal.
     * @param codeName ID of the microservice, to be called by the user through Proxy, can be blank.
     * @param location Address of the functionality/microservice to call
     * @param methodSignature Name of the method of the microservice you want to call
     * @param returnAbiParametersArray Array of return values obtained from the called microservice's method
     * @param replaces codeName of the microservice that will be replaced by this Proposal, can be blank.
     * @return proposal Address of the newly added proposal
     */
    function newProposal(
        string calldata codeName,
        address location,
        string calldata methodSignature,
        string calldata returnAbiParametersArray,
        string calldata replaces
    ) external returns (address proposal);

    /**
     * @dev Callable by the Proxy only.
     * Contains the logic to check if a proposal is ready to be finalized (e.g. last block reached or hard cap reached).
     */
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
