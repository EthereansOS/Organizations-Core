pragma solidity ^0.6.0;

import "./IMVDFunctionalityProposalManager.sol";
import "./IMVDProxy.sol";
import "./MVDFunctionalityProposal.sol";

contract MVDFunctionalityProposalManager is IMVDFunctionalityProposalManager {

    address private _proxy;

    mapping(address => bool) private _proposals;

    mapping(string => address) private _pendingProposals;

    modifier onlyProxy() {
        require(msg.sender == address(_proxy), "Only Proxy can call this functionality");
        _;
    }

    function newProposal(string memory codeName, address location, string memory methodSignature, string memory returnAbiParametersArray, string memory replaces) public override onlyProxy returns(address) {
        return setProposal(codeName, location, methodSignature, replaces, address(new MVDFunctionalityProposal(codeName, location, methodSignature, returnAbiParametersArray, replaces, _proxy)));
    }

    function preconditionCheck(string memory codeName, address location, string memory methodSignature, string memory replaces) private view returns(bool hasCodeName, bool hasReplaces) {

        require(_pendingProposals[codeName] == address(0), "There actually is a pending proposal for this code name");

        require(_pendingProposals[replaces] == address(0), "There actually is a pending proposal for this replacing name");

        hasCodeName = !compareStrings(codeName, "");
        hasReplaces = !compareStrings(replaces, "");

        require((hasCodeName || !hasCodeName && !hasReplaces) ? location != address(0) : true, "Cannot have zero address for functionality to set or one time functionality to call");

        require(hasCodeName ? !compareStrings(methodSignature, "") : true, "Cannot have empty string for methodSignature");

        require(hasCodeName || hasReplaces || location != address(0), "codeName and replaces cannot be both empty");

        IMVDProxy proxy = IMVDProxy(_proxy);

        require(hasCodeName && proxy.hasFunctionality(codeName) ? compareStrings(codeName, replaces) : true, "codeName is already used by another functionality");

        require(hasReplaces ? proxy.hasFunctionality(replaces) : true, "Cannot replace unexisting or inactive functionality");
    }

    function setProposal(string memory codeName, address location, string memory methodSignature, string memory replaces, address proposalAddress) private returns(address) {

        (bool hasCodeName, bool hasReplaces) = preconditionCheck(codeName, location, methodSignature, replaces);

        _proposals[proposalAddress] = true;

        _pendingProposals[codeName] = (hasCodeName || !hasReplaces) ? proposalAddress : address(0);

        _pendingProposals[replaces] = (hasReplaces || !hasCodeName) ? proposalAddress : address(0);

        return proposalAddress;
    }

    function checkProposal(address proposalAddress) public override onlyProxy {
        require(_proposals[proposalAddress], "Unauthorized Access!");

        IMVDFunctionalityProposal proposal = IMVDFunctionalityProposal(proposalAddress);

        uint256 surveyEndBlock = proposal.getSurveyEndBlock();

        require(surveyEndBlock > 0, "Survey was not started!");

        require(!proposal.isDisabled(), "Proposal is disabled!");

        require(block.number >= surveyEndBlock, "Survey is still running!");

        require(!proposal.isTerminated(), "Survey already terminated!");

        _pendingProposals[proposal.getCodeName()] = address(0);

        _pendingProposals[proposal.getReplaces()] = address(0);
    }

    function isValidProposal(address proposal) public override view returns (bool) {
        return _proposals[proposal];
    }

    function disableProposal(address proposalAddress) public override onlyProxy {
        require(_proposals[proposalAddress], "Not a valid proposal");
        IMVDFunctionalityProposal proposal = IMVDFunctionalityProposal(proposalAddress);
        _pendingProposals[proposal.getCodeName()] = address(0);
        _pendingProposals[proposal.getReplaces()] = address(0);
    }

    function getPendingProposal(string memory codeName) public override view returns(address proposalAddress, bool isReallyPending) {
        IMVDFunctionalityProposal proposal = IMVDFunctionalityProposal(proposalAddress = _pendingProposals[codeName]);
        isReallyPending = proposal.getProxy() == address(this) && block.number < proposal.getSurveyEndBlock() || !proposal.isTerminated();
    }

    function getProxy() public override view returns (address) {
        return _proxy;
    }

    function setProxy() public override {
        require(_proxy == address(0) || _proxy == msg.sender, _proxy != address(0) ? "Proxy already set!" : "Only Proxy can toggle itself!");
        _proxy = _proxy == address(0) ?  msg.sender : address(0);
    }

    function compareStrings(string memory a, string memory b) private pure returns(bool) {
        return keccak256(bytes(a)) == keccak256(bytes(b));
    }
}