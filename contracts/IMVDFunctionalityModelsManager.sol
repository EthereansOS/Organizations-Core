// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

/**
 * @title Functionalities Models Manager
 * @dev Well Known Functionalities are "special" Fnctionalities must be implemented according to
 * a specific pattern. Well Known Functionalities can be found in the implementation of this Interface.
 */
interface IMVDFunctionalityModelsManager {
    function init() external;

    /**
     * @dev Check Well Known Functionalities. If the check fails it will raise its own errors.
     * @param codeNameID of the Functionality
     * @param location
     * @param submittable
     * @param methodSignature
     * @param returnAbiParametersArray
     * @param isInternal
     * @param needsSender
     * @replaces
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
