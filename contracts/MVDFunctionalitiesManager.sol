pragma solidity ^0.6.0;

import "./IMVDFunctionalitiesManager.sol";
import "./CommonUtilities.sol";
import "./IMVDProxy.sol";
import "./IMVDFunctionalityProposal.sol";
import "./Functionality.sol";

contract MVDFunctionalitiesManager is IMVDFunctionalitiesManager, CommonUtilities {

    address private _proxy;

    Functionality[] private _functionalities;

    uint256 private _functionalitiesAmount;

    mapping(string => uint256) private _indexes;

    mapping(address => uint256) private _functionalityCount;

    address private _callingContext;

    constructor(address sourceLocation,
        uint256 getMinimumBlockNumberSourceLocationId, address getMinimumBlockNumberFunctionalityAddress,
        uint256 getEmergencyMinimumBlockNumberSourceLocationId, address getEmergencyMinimumBlockNumberFunctionalityAddress,
        uint256 getEmergencySurveyStakingSourceLocationId, address getEmergencySurveyStakingFunctionalityAddress,
        uint256 checkVoteResultSourceLocationId, address checkVoteResultFunctionalityAddress) public {
        if(getMinimumBlockNumberFunctionalityAddress == address(0)) {
            return;
        }
        init(sourceLocation,
        getMinimumBlockNumberSourceLocationId, getMinimumBlockNumberFunctionalityAddress,
        getEmergencyMinimumBlockNumberSourceLocationId, getEmergencyMinimumBlockNumberFunctionalityAddress,
        getEmergencySurveyStakingSourceLocationId, getEmergencySurveyStakingFunctionalityAddress,
        checkVoteResultSourceLocationId, checkVoteResultFunctionalityAddress);
    }

    function init(address sourceLocation,
        uint256 getMinimumBlockNumberSourceLocationId, address getMinimumBlockNumberFunctionalityAddress,
        uint256 getEmergencyMinimumBlockNumberSourceLocationId, address getEmergencyMinimumBlockNumberFunctionalityAddress,
        uint256 getEmergencySurveyStakingSourceLocationId, address getEmergencySurveyStakingFunctionalityAddress,
        uint256 checkVoteResultSourceLocationId, address checkVoteResultFunctionalityAddress) public override {

        require(_functionalitiesAmount == 0, "Init already called!");

        addFunctionality(
            "getMinimumBlockNumberForSurvey",
            sourceLocation,
            getMinimumBlockNumberSourceLocationId,
            getMinimumBlockNumberFunctionalityAddress,
            false,
            "getMinimumBlockNumberForSurvey()",
            '["uint256"]',
            false,
            false
        );

        addFunctionality(
            "getMinimumBlockNumberForEmergencySurvey",
            sourceLocation,
            getEmergencyMinimumBlockNumberSourceLocationId,
            getEmergencyMinimumBlockNumberFunctionalityAddress,
            false,
            "getMinimumBlockNumberForEmergencySurvey()",
            '["uint256"]',
            false,
            false
        );

        addFunctionality(
            "getEmergencySurveyStaking",
            sourceLocation,
            getEmergencySurveyStakingSourceLocationId,
            getEmergencySurveyStakingFunctionalityAddress,
            false,
            "getEmergencySurveyStaking()",
            '["uint256"]',
            false,
            false
        );

        addFunctionality(
            "checkSurveyResult",
            sourceLocation,
            checkVoteResultSourceLocationId,
            checkVoteResultFunctionalityAddress,
            false,
            "checkSurveyResult(address)",
            '["bool"]',
            false,
            false
        );
    }

    function addFunctionality(string memory codeName, address sourceLocation, uint256 sourceLocationId, address location, bool submitable, string memory methodSignature, string memory returnAbiParametersArray, bool isInternal, bool needsSender) public override {
        addFunctionality(codeName, sourceLocation, sourceLocationId, location, submitable, methodSignature, returnAbiParametersArray, isInternal, needsSender, _functionalities.length);
    }

    function addFunctionality(string memory codeName, address sourceLocation, uint256 sourceLocationId, address location, bool submitable, string memory methodSignature, string memory returnAbiParametersArray, bool isInternal, bool needsSender, uint256 position) public override {
        require(_proxy == address(0) || _callingContext == msg.sender, "Unauthorized call!");
        Functionality memory functionality = Functionality(
            codeName,
            sourceLocation,
            sourceLocationId,
            location,
            submitable,
            methodSignature,
            returnAbiParametersArray,
            isInternal,
            needsSender,
            address(0),
            true,
            position
        );
        if(position >= _functionalities.length) {
            _functionalities.push(functionality);
        } else {
            removeFunctionality(_functionalities[position].codeName);
            _functionalities[position] = functionality;
        }
        _functionalityCount[location] = _functionalityCount[location] + 1;
        _functionalitiesAmount++;
        _indexes[codeName] = position;
    }

    function removeFunctionality(string memory codeName) public override returns(bool removed, uint256 position) {
        require(_proxy == address(0) || _callingContext == msg.sender, "Unauthorized call!");
        Functionality storage functionality = _functionalities[_indexes[codeName]];
        position = functionality.position;
        if(compareStrings(codeName, functionality.codeName) && functionality.active) {
            functionality.active = false;
            _functionalityCount[functionality.location] = _functionalityCount[functionality.location] - 1;
            _functionalitiesAmount--;
            removed = true;
        }
    }

    function preConditionCheck(string memory codeName, bytes memory data, uint8 submitable, address sender, uint256 value) public override view returns(address location, bytes memory payload) {
        Functionality memory functionality = _functionalities[_indexes[codeName]];

        require(compareStrings(codeName, functionality.codeName) && functionality.active, "Unauthorized functionality");

        require(submitable == (functionality.submitable ? 1 : 0), "Functionality called in the wrong context!");

        require(functionality.isInternal ? _functionalityCount[sender] > 0 || _callingContext == sender : true, "Internal functionalities can be called from other functionalities only!");

        location = functionality.location;

        if(functionality.needsSender) {
            require(data.length >= (submitable == 1 ? 64 : 32), "Insufficient space in data payload");
            assembly {
                mstore(add(data, 0x20), sender)
                switch iszero(submitable) case 0 {
                    mstore(add(data, 0x40), value)
                }
            }
        }

        payload = abi.encodePacked(bytes4(keccak256(bytes(functionality.methodSignature))), data);
    }

    function getFunctionalitiesAmount() public override view returns(uint256) {
        return _functionalitiesAmount;
    }

    function isValidFunctionality(address functionality) public override view returns(bool) {
        return _functionalityCount[functionality] > 0;
    }

    function isAuthorizedFunctionality(address functionality) public override view returns(bool) {
        return _callingContext != address(0) && (_functionalityCount[functionality] > 0 || _callingContext == functionality);
    }

    function getFunctionalityData(string memory codeName) public override view returns(address, uint256, string memory, address, uint256) {
        Functionality memory functionality = _functionalities[_indexes[codeName]];
        return (compareStrings(codeName, functionality.codeName) && functionality.active ? functionality.location : address(0), functionality.position, functionality.methodSignature, functionality.sourceLocation, functionality.sourceLocationId);
    }

    function hasFunctionality(string memory codeName) public override view returns(bool) {
        Functionality memory functionality = _functionalities[_indexes[codeName]];
        return compareStrings(codeName, functionality.codeName) && functionality.active;
    }

    function functionalitiesToJSON() public override view returns(string memory) {
        return functionalitiesToJSON(0, _functionalities.length);
    }

    function functionalitiesToJSON(uint256 start, uint256 l) public override view returns(string memory functionsJSONArray) {
        uint256 length = start + l;
        functionsJSONArray = "[";
        for(uint256 i = start; i < length; i++) {
            functionsJSONArray = !_functionalities[i].active ? functionsJSONArray : string(abi.encodePacked(functionsJSONArray, toJSON(_functionalities[i]), i == length - (_functionalities[i].active ? 1 : 0) ? "" : ","));
            length += _functionalities[i].active ? 0 : 1;
            length = length > _functionalities.length ? _functionalities.length : length;
        }
        functionsJSONArray = string(abi.encodePacked(functionsJSONArray, "]"));
    }

    function functionalityNames() public override view returns(string memory) {
        return functionalityNames(0, _functionalities.length);
    }

    function functionalityNames(uint256 start, uint256 l) public override view returns(string memory functionsJSONArray) {
        uint256 length = start + l;
        functionsJSONArray = "[";
        for(uint256 i = start; i < length; i++) {
            functionsJSONArray = !_functionalities[i].active ? functionsJSONArray : string(abi.encodePacked(functionsJSONArray, '"', _functionalities[i].codeName, '"', i == length - (_functionalities[i].active ? 1 : 0) ? "" : ","));
            length += _functionalities[i].active ? 0 : 1;
            length = length > _functionalities.length ? _functionalities.length : length;
        }
        functionsJSONArray = string(abi.encodePacked(functionsJSONArray, "]"));
    }

    function functionalityToJSON(string memory codeName) public override view returns(string memory) {
        return string(toJSON(_functionalities[_indexes[codeName]]));
    }

    function toJSON(Functionality memory func) private pure returns(bytes memory) {
        return abi.encodePacked(
            '{',
            getFirstJSONPart(func.sourceLocation, func.sourceLocationId, func.location),
            '","submitable":',
            func.submitable ? "true" : "false",
            ',"isInternal":',
            func.isInternal ? "true" : "false",
            ',"needsSender":',
            func.needsSender ? "true" : "false",
            ',"proposalAddress":"',
            toString(func.proposalAddress),
            '","codeName":"',
            func.codeName,
            '","methodSignature":"',
            func.methodSignature,
            '","returnAbiParametersArray":',
            formatReturnAbiParametersArray(func.returnAbiParametersArray),
            ',"position":',
            toString(func.position),
            '}'
        );
    }

    function getProxy() public override view returns(address) {
        return _proxy;
    }

    function setProxy() public override {
        require(_functionalitiesAmount != 0, "Init not called!");
        require(_proxy == address(0) || _proxy == msg.sender, _proxy != address(0) ? "Proxy already set!" : "Only Proxy can toggle itself!");
        _proxy = _proxy == address(0) ?  msg.sender : address(0);
    }

    function setupFunctionality(address proposalAddress) public override returns(bool result) {

        require(_proxy == msg.sender, "Only Proxy can call This!");

        IMVDFunctionalityProposal proposal = IMVDFunctionalityProposal(proposalAddress);

        string memory codeName = proposal.getCodeName();
        bool hasCodeName = !compareStrings(codeName, "");
        string memory replaces = proposal.getReplaces();
        bool hasReplaces = !compareStrings(replaces, "");

        if(!hasCodeName && !hasReplaces) {
            (result,) = IMVDProxy(_proxy).callFromManager(_callingContext = proposal.getLocation(), abi.encodeWithSignature("callOneTime(address)", proposalAddress));
            _callingContext = address(0);
            return result;
        }

        Functionality memory replacedFunctionality = _functionalities[_indexes[replaces]];
        uint256 position = hasReplaces ? replacedFunctionality.position : _functionalities.length;

        if(hasReplaces) {
            (result,) = IMVDProxy(_proxy).callFromManager(_callingContext = replacedFunctionality.location, abi.encodeWithSignature("onStop(address)", proposalAddress));
            _callingContext = address(0);
            if(!result) {
                revert("onStop failed!");
            }
        }

        replacedFunctionality.active = hasReplaces ? false : replacedFunctionality.active;

        _functionalitiesAmount -= hasReplaces ? 1 : 0;

        _functionalityCount[replacedFunctionality.location] = _functionalityCount[replacedFunctionality.location] - (hasReplaces ? 1 : 0);

        if(hasReplaces) {
            _functionalities[position] = replacedFunctionality;
        }

        Functionality memory newFunctionality = Functionality(
            codeName,
            proposal.getSourceLocation(),
            proposal.getSourceLocationId(),
            proposal.getLocation(),
            proposal.isSubmitable(),
            proposal.getMethodSignature(),
            proposal.getReturnAbiParametersArray(),
            proposal.isInternal(),
            proposal.needsSender(),
            proposalAddress,
            true,
            position
        );

        _functionalitiesAmount += hasCodeName ? 1 : 0;

        if(hasCodeName && position == _functionalities.length) {
            _functionalities.push(newFunctionality);
        } else if(hasCodeName) {
            _functionalities[position] = newFunctionality;
        }

        _indexes[codeName] = hasCodeName ? position : 0;
        _functionalityCount[newFunctionality.location] = _functionalityCount[newFunctionality.location] + (hasCodeName ? 1 : 0);

        if(hasCodeName) {
            (result,) = IMVDProxy(_proxy).callFromManager(_callingContext = newFunctionality.location, abi.encodeWithSignature("onStart(address,address)", proposalAddress, hasReplaces ? replacedFunctionality.location : address(0)));
            _callingContext = address(0);
            if(!result) {
                revert("onStart failed!");
            }
        }

        if(hasCodeName || hasReplaces) {
            IMVDProxy(_proxy).emitFromManager(hasCodeName ? codeName : "", proposalAddress, hasReplaces ? replacedFunctionality.codeName : "", hasReplaces ? replacedFunctionality.sourceLocation : address(0), hasReplaces ? replacedFunctionality.sourceLocationId : 0, hasReplaces ? replacedFunctionality.location : address(0), hasReplaces ? replacedFunctionality.submitable : false, hasReplaces ? replacedFunctionality.methodSignature : "", hasReplaces ? replacedFunctionality.isInternal : false, hasReplaces ? replacedFunctionality.needsSender : false, hasReplaces ? replacedFunctionality.proposalAddress : address(0));
        }
        _callingContext = address(0);
        return true;
    }

    function setCallingContext(address location) public override returns(bool changed) {
        require(msg.sender == _proxy, "Unauthorized Access");
        _callingContext = (changed = _callingContext == address(0)) ? location : _callingContext;
    }

    function clearCallingContext() public override {
        require(msg.sender == _proxy, "Unauthorized Access");
        _callingContext = address(0);
    }
}