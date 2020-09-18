// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

// DOCUMENT
struct Functionality {
    string codeName;
    address sourceLocation;
    uint256 sourceLocationId;
    address location;
    bool submittable;
    string methodSignature;
    string returnAbiParametersArray;
    bool isInternal;
    bool needsSender;
    address proposalAddress;
    bool active;
    uint256 position;
}
