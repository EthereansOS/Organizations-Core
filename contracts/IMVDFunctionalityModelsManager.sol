// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

/**
 * @title Functionalities Models Manager
 * @dev Well Known Functionalities are "special" Functionalities/Microservices must be implemented according to
 * a specific pattern. Well Known Functionalities can be found in the implementation of this Interface.
 */
interface IMVDFunctionalityModelsManager {
    function init() external;

    /**
     * @dev Check Well Known Functionalities. If the check fails it will raise its own errors.
     * @param codeName ID of the microservice, to be called by the user through Proxy.
     * @param submittable Boolean flag controlling wether the microservice writes data to the chain
     * @param methodSignature Name of the method of the microservice you want to call
     * @param returnAbiParametersArray Array of return values obtained from the called microservice's method
     * @param isInternal Boolean flag controlling wether the microservice can be called from anyone (false) or
     * can be called only by other microservices (true)
     * @param needsSender All microservices calls are made py the Proxy, with this boolean flag you can
     * forward the address that called the Proxy in the first place
     * @param replaces codeName of the microservice that will be replaced by the Proposal to be created, can be blank.
     */
    function checkWellKnownFunctionalities(
        string calldata codeName,
        bool submittable,
        string calldata methodSignature,
        string calldata returnAbiParametersArray,
        bool isInternal,
        bool needsSender,
        string calldata replaces
    ) external view;
}
