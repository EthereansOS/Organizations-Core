pragma solidity ^0.6.0;

import "./IMVDFunctionalityModelsManager.sol";
import "./Functionality.sol";

contract MVDFunctionalityModelsManager is IMVDFunctionalityModelsManager {

    mapping(string => Functionality) private _wellKnownFunctionalityModels;

    constructor() public override {
        init();
    }

    function init() public override {

        require(compareStrings("", _wellKnownFunctionalityModels["getMinimumBlockNumberForSurvey"].codeName), "Init already called!");

        _wellKnownFunctionalityModels["getMinimumBlockNumberForSurvey"] = Functionality("getMinimumBlockNumberForSurvey", address(0), 0, address(0), false, "getMinimumBlockNumberForSurvey()", '["uint256"]', false, false, address(0), true, 0);

        _wellKnownFunctionalityModels["getMinimumBlockNumberForEmergencySurvey"] = Functionality("getMinimumBlockNumberForEmergencySurvey", address(0), 0, address(0), false, "getMinimumBlockNumberForEmergencySurvey()", '["uint256"]', false, false, address(0), true, 0);

        _wellKnownFunctionalityModels["getEmergencySurveyStaking"] = Functionality("getEmergencySurveyStaking", address(0), 0, address(0), false, "getEmergencySurveyStaking()", '["uint256"]', false, false, address(0), true, 0);

        _wellKnownFunctionalityModels["checkSurveyResult"] = Functionality("checkSurveyResult", address(0), 0, address(0), false, "checkSurveyResult(address)", '["bool"]', false, false, address(0), true, 0);

        _wellKnownFunctionalityModels["onNewProposal"] = Functionality("onNewProposal", address(0), 0, address(0), true, "onNewProposal(address)", '[]', false, false, address(0), false, 0);

        _wellKnownFunctionalityModels["startProposal"] = Functionality("startProposal", address(0), 0, address(0), true, "startProposal(address,uint256,address)", '[]', false, true, address(0), false, 0);

        _wellKnownFunctionalityModels["disableProposal"] = Functionality("disableProposal", address(0), 0, address(0), true, "disableProposal(address,uint256,address)", '[]', false, true, address(0), false, 0);

        _wellKnownFunctionalityModels["proposalEnd"] = Functionality("proposalEnd", address(0), 0, address(0), true, "proposalEnd(address,bool)", "[]", false, false, address(0), false, 0);
    }

    function checkWellKnownFunctionalities(string memory codeName, bool submitable, string memory methodSignature, string memory returnAbiParametersArray,
        bool isInternal, bool needsSender, string memory replaces) public override view {

        if(compareStrings(codeName, "") && compareStrings(replaces, "")) {
            return;
        }

        bool codeNameIsWellKnown = compareStrings(codeName, _wellKnownFunctionalityModels[string(codeName)].codeName);
        Functionality memory wellKnownFunctionality = _wellKnownFunctionalityModels[string(codeName)];

        require(codeNameIsWellKnown ? wellKnownFunctionality.submitable == submitable : true, "Wrong submitable flag for this submission");
        require(codeNameIsWellKnown ? wellKnownFunctionality.needsSender == needsSender : true, "Wrong needsSender flag for this submission");
        require(codeNameIsWellKnown ? wellKnownFunctionality.isInternal == isInternal : true, "Wrong isInternal flag for this submission");
        require(codeNameIsWellKnown ? compareStrings(wellKnownFunctionality.methodSignature, methodSignature) : true, "Wrong method signature for this submission");
        require(codeNameIsWellKnown ? compareStrings(wellKnownFunctionality.returnAbiParametersArray, returnAbiParametersArray) : true, "Wrong return abi parameters array for this submission");

        require(codeNameIsWellKnown ? wellKnownFunctionality.active ? compareStrings(wellKnownFunctionality.codeName, replaces) : true : true, "Active well known functionality cannot be disabled");

        require(compareStrings(replaces, _wellKnownFunctionalityModels[replaces].codeName) ? compareStrings(codeName, "") ? !_wellKnownFunctionalityModels[replaces].active : true : true, "Active well known functionality cannot be disabled");
    }

    function compareStrings(string memory a, string memory b) internal pure returns(bool) {
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
}