// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

/**
 * @title Interface for the Functionalities Manager
 * @dev
 */
interface IMVDFunctionalitiesManager {
    /**
     * @dev GET the proxy
     */
    function getProxy() external view returns (address);

    /**
     * @dev SET the proxy
     */
    function setProxy() external;

    /**
     * @dev Initializer logic used during the constructor call
     * @param sourceLocation ROBE location of the source code
     * @param getMinimumBlockNumberSourceLocationId ROBE id
     * @param getMinimumBlockNumberFunctionalityAddress Address of the Functionality that controls
     * the block duration of regular proposals
     * @param getEmergencyMinimumBlockNumberSourceLocationId ROBE id
     * @param getEmergencyMinimumBlockNumberFunctionalityAddress Address for the Functionality that controls
     * the block duration of emergency proposals
     * @param getEmergencySurveyStakingSourceLocationId ROBE id
     * @param getEmergencySurveyStakingFunctionalityAddress Address for the Functionality that controls the
     * minimum amount of vote to be staked in order to start an Emergency Proposal
     * @param checkVoteResultSourceLocationId ROBE id
     * @param checkVoteResultFunctionalityAddress Address for the Functionality that controls the
     * check for determining if a Proposal was successful or it failed
     */
    function init(
        address sourceLocation,
        uint256 getMinimumBlockNumberSourceLocationId,
        address getMinimumBlockNumberFunctionalityAddress,
        uint256 getEmergencyMinimumBlockNumberSourceLocationId,
        address getEmergencyMinimumBlockNumberFunctionalityAddress,
        uint256 getEmergencySurveyStakingSourceLocationId,
        address getEmergencySurveyStakingFunctionalityAddress,
        uint256 checkVoteResultSourceLocationId,
        address checkVoteResultFunctionalityAddress
    ) external;

    // DOCUMENT
    /**
     * @dev Add a functionality to the Functionalities Manager
     * @param codeName
     * @param sourceLocation
     * @param sourceLocationId
     * @param location
     * @param submittable
     * @param methodSignature
     * @param returnAbiParametersArray
     * @param isInternal
     * @param needsSender
     */
    function addFunctionality(
        string calldata codeName,
        address sourceLocation,
        uint256 sourceLocationId,
        address location,
        bool submittable,
        string calldata methodSignature,
        string calldata returnAbiParametersArray,
        bool isInternal,
        bool needsSender
    ) external;

    // DOCUMENT
    /**
     * @dev Replace a Functionality in the Functionalities Manager
     * @param codeName
     * @param sourceLocation
     * @param sourceLocationId
     * @param location
     * @param submittable
     * @param methodSignature
     * @param returnAbiParametersArray
     * @param isInternal
     * @param needsSender
     * @param position Position of the Functionality to replace
     */
    function addFunctionality(
        string calldata codeName,
        address sourceLocation,
        uint256 sourceLocationId,
        address location,
        bool submittable,
        string calldata methodSignature,
        string calldata returnAbiParametersArray,
        bool isInternal,
        bool needsSender,
        uint256 position
    ) external;

    /**
     * @dev Remove a Functionality from the Functionalities Manager
     * @param codeName ID of the Functionality to remove
     * @return removed Boolean flag representing the success status of the operation
     * @return position Position of the removed functionality
     */
    function removeFunctionality(string calldata codeName)
        external
        returns (bool removed, uint256 position);

    /**
     * @dev Check that the Functionality is a valid one
     * @param functionality Functionality to be checked
     * @return valid Boolean flag indicating the validity of the Functionality
     */
    function isValidFunctionality(address functionality)
        external
        view
        returns (bool valid);

    /**
     * @dev Check that the Functionality is an authorized one
     * @param functionality Functionality to be checked
     * @return valid Boolean flag indicating the authorization status of the Functionality
     */
    function isAuthorizedFunctionality(address functionality)
        external
        view
        returns (bool success);

    // DOCUMENT
    function setCallingContext(address location) external returns (bool);

    // DOCUMENT
    function clearCallingContext() external;

    // DOCUMENT
    function getFunctionalityData(string calldata codeName)
        external
        view
        returns (
            address,
            uint256,
            string memory,
            address,
            uint256
        );

    /**
     * @dev Check that the FunctionalitiesManager has a specific Functionality
     * @param codeName ID of the Functionality to be checked
     * @return output Boolean flag indicating wether the Functionalities Manager has the given Functionality.
     */
    function hasFunctionality(string calldata codeName)
        external
        view
        returns (bool output);

    /**
     * @dev GET the amount of functionalities present in the Functionalities Manager
     */
    function getFunctionalitiesAmount() external view returns (uint256);

    // DOCUMENT
    function functionalitiesToJSON() external view returns (string memory);

    // DOCUMENT
    function functionalitiesToJSON(uint256 start, uint256 l)
        external
        view
        returns (string memory functionsJSONArray);

    /**
     * @dev GET all Functionalities Names (IDs)
     */
    function functionalityNames() external view returns (string memory);

    /**
     * @dev GET all Functionalities Names (IDs) in a portion of the array
     */
    function functionalityNames(uint256 start, uint256 l)
        external
        view
        returns (string memory functionsJSONArray);

    /**
     * @dev Given a Functionality ID return its JSON encoded version
     */
    function functionalityToJSON(string calldata codeName)
        external
        view
        returns (string memory);

    // DOCUMENT
    function preConditionCheck(
        string calldata codeName,
        bytes calldata data,
        uint8 submittable,
        address sender,
        uint256 value
    ) external view returns (address location, bytes memory payload);

    // DOCUMENT
    function setupFunctionality(address proposalAddress)
        external
        returns (bool);
}
