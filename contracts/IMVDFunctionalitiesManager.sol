// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

/**
 * @title Interface for the Functionalities Manager
 * @dev Functionalities Manager is the one that keeps track of all the Microservices of a DFO.
 * It also contains all the logic to set/unset Microservices after a Proposal.
 */
interface IMVDFunctionalitiesManager {
    /**
     * @dev GET the Proxy
     */
    function getProxy() external view returns (address);

    /**
     * @dev SET the Proxy
     */
    function setProxy() external;

    /**
     * @dev Initializer logic used during the constructor call
     * @param sourceLocation Location of the source code, saved in concatenated Base64 data chunks
     * @param getMinimumBlockNumberSourceLocationId Base64 data chunk id of the corresponding Microservice
     * @param getMinimumBlockNumberFunctionalityAddress Address of the Functionality that controls
     * the block duration of regular proposals
     * @param getEmergencyMinimumBlockNumberSourceLocationId Base64 data chunk id of the corresponding Microservice
     * @param getEmergencyMinimumBlockNumberFunctionalityAddress Address for the Functionality that controls
     * the block duration of emergency proposals
     * @param getEmergencySurveyStakingSourceLocationId Base64 data chunk id of the corresponding Microservice
     * @param getEmergencySurveyStakingFunctionalityAddress Address for the Functionality that controls the
     * minimum amount of vote to be staked in order to start an Emergency Proposal
     * @param checkVoteResultSourceLocationId Base64 data chunk id of the corresponding Microservice
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

    /**
     * @dev Add a functionality to the Functionalities Manager
     * @param codeName ID of the microservice, to be called by the user through Proxy.
     * @param sourceLocation Location of the source code, saved in concatenated Base64 data chunks
     * @param sourceLocationId Base64 data chunk id of the corresponding Microservice
     * @param location Address of the functionality/microservice to call
     * @param submittable Boolean flag controlling wether the microservice writes data to the chain
     * @param methodSignature Name of the method of the microservice you want to call
     * @param returnAbiParametersArray Array of return values obtained from the called microservice's method
     * @param isInternal Boolean flag controlling wether the microservice can be called from anyone (false) or
     * can be called only by other microservices (true)
     * @param needsSender All microservices calls are made by the Proxy, with this boolean flag you can
     * forward the address that called the Proxy in the first place
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

    /**
     * @dev Replace a Functionality in the Functionalities Manager
     * @param codeName ID of the microservice, to be called by the user through Proxy.
     * @param sourceLocation Location of the source code, saved in concatenated Base64 data chunks
     * @param sourceLocationId Base64 data chunk id of the corresponding Microservice
     * @param location Address of the functionality/microservice to call
     * @param submittable Boolean flag controlling wether the microservice writes data to the chain
     * @param methodSignature Name of the method of the microservice you want to call
     * @param returnAbiParametersArray Array of return values obtained from the called microservice's method
     * @param isInternal Boolean flag controlling wether the microservice can be called from anyone (false) or
     * can be called only by other microservices (true)
     * @param needsSender All microservices calls are made py the Proxy, with this boolean flag you can
     * forward the address that called the Proxy in the first place
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
    function isValidFunctionality(address functionality) external view returns (bool valid);

    /**
     * @dev Check that the Functionality is an authorized one
     * @param functionality Functionality to be checked
     * @return success Boolean flag indicating the authorization status of the Functionality
     */
    function isAuthorizedFunctionality(address functionality) external view returns (bool success);

    /**
     * @dev This method can be called only by the Proxy.
     * When a new submitable Microservice is called, this method is used to let other DFO Delegates (e.g. StateHolder) to be fully operative.
     * If you call a Microservice directly, bypassing the Proxy, the context will be blank and Delegates cannot allow you to do any operation.
     * @param location The address of the currently running Microservice
     * @return changed True if the calling context is correctly set, false if the context was already set (this happens, for example, when someone calls a Microservice including a logic to call another Microservice through the Proxy).
     */
    function setCallingContext(address location) external returns (bool changed);

    /**
     * @dev This method can be called only by the Proxy.
     * Clears the context at the end of the Microservice execution
     */
    function clearCallingContext() external;

    /**
     * @dev Utility method to retrieve all important stuff to call a Microservice
     * @param codeName the codeName of the Microservice you need info
     * @return the address of the contract including the logic of the Microservice, the method signature of the Microservice, the position in the Functionalities array, the location of the source code, saved in byte64 concatenated data chunks, the locationId of the source code.
     */
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
    function hasFunctionality(string calldata codeName) external view returns (bool output);

    /**
     * @dev GET the amount of functionalities present in the Functionalities Manager
     */
    function getFunctionalitiesAmount() external view returns (uint256);

    /**
     * @dev For frontend purposes. Gives back the info about functionalities using the JSON Array format
    */
    function functionalitiesToJSON() external view returns (string memory);

    /**
     * @dev For frontend purposes. Gives back the info about functionalities using the JSON Array format
     * @param start the start position of the array
     * @param l the array offset
    */
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
    function functionalityToJSON(string calldata codeName) external view returns (string memory);

    /**
     * @dev Method called by the Proxy when someone calls a Microservice.
     * It has a double function: checks if you are in the correct context (e.g. are you trying to call a non-submitable Microservice through the correct "read" function of the Proxy?)
     * and gives back the address of the Microservice and the correct payload that the proxy will use to execute a .call() method.
     * @param codeName the Microservice to be called
     * @param data the payload to be used within the Microservice (ABI encoded)
     * @param submittable 1 true, 0 false
     * @param sender the original msg.sender of the Proxy read/submit call, to be used if the Microservice has the needsSender flag set to true
     * @param value the original msg.value of the Proxy submit call, to be used if the Microservice is submitable and has the needsSender flag set to true
    */
    function preConditionCheck(
        string calldata codeName,
        bytes calldata data,
        uint8 submittable,
        address sender,
        uint256 value
    ) external view returns (address location, bytes memory payload);

    /**
     * @dev callable by the Proxy only.
     * Sets up the new Microservice add/replace/remove action, grabbing the data from the MVDFunctionalityProposal at the given address
     * @param proposalAddress the address of the Proposal to be set
     */
    function setupFunctionality(address proposalAddress) external returns (bool);
}
