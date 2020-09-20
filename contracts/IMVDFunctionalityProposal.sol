// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

/**
 * @title Interface for Proposal
 * @dev Proposals are the defacto heart of the protocol since they allow voting token holders potentially
 * alter all of the logic of a DFO and even extend it via custom logic.
 */
interface IMVDFunctionalityProposal {
    /**
     * @dev Functionality Initializer
     * @param codeName ID of the microservice, to be called by the user through Proxy, can be blank.
     * @param location Address of the functionality/microservice to call
     * @param methodSignature Name of the method of the microservice you want to call
     * @param returnAbiParametersArray Array of return values obtained from the called microservice's method
     * @param replaces codeName of the microservice that will be replaced by this Proposal, can be blank.
     * @param proxy Address of the proxy
     */
    function init(
        string calldata codeName,
        address location,
        string calldata methodSignature,
        string calldata returnAbiParametersArray,
        string calldata replaces,
        address proxy
    ) external;

    /**
     * @dev set the collateral attributes of the proposal
     * @param emergency Bool flag controlling wether this is a standard or emergency proposal
     * @param sourceLocation Location of the source code, saved in concatenated Base64 data chunks
     * @param sourceLocationId Base64 data chunk id of the corresponding Microservice
     * @param submittable Boolean flag controlling wether the microservice writes data to the chain
     * @param isInternal Boolean flag controlling wether the microservice can be called from anyone (false) or
     * can be called only by other microservices (true)
     * @param needsSender All microservices calls are made py the Proxy, with this boolean flag you can
     * forward the address that called the Proxy in the first place
     * @param proposer Address of the proposer
     * @param votesHardCap Hardcap value
     */
    function setCollateralData(
        bool emergency,
        address sourceLocation,
        uint256 sourceLocationId,
        bool submittable,
        bool isInternal,
        bool needsSender,
        address proposer,
        uint256 votesHardCap
    ) external;

    /**
     * @dev GET the Proxy address
     */
    function getProxy() external view returns (address);

    /**
     * @dev GET the Proposal Functionality string ID
     */
    function getCodeName() external view returns (string memory);

    /**
     * @dev GET the boolean flag indicating wether the Proposal is an Emergency Proposal
     */
    function isEmergency() external view returns (bool);

    /**
     * @dev GET the Location of the source code, saved in concatenated Base64 data chunks
     */
    function getSourceLocation() external view returns (address);

    /**
     * @dev GET the Base64 data chunk id of the corresponding Microservice
     */
    function getSourceLocationId() external view returns (uint256);

    /**
     * @dev GET address of the microservice
     */
    function getLocation() external view returns (address);

    /**
     * @dev GET the boolean flag controlling wether the microservice writes data to the chain
     */
    function issubmittable() external view returns (bool);

    /**
     * @dev GET the name of the microservice method to invoke
     */
    function getMethodSignature() external view returns (string memory);

    /**
     * @dev GET the array of return values obtained from the called microservice's method
     */
    function getReturnAbiParametersArray() external view returns (string memory);

    /**
     * @dev GET the boolean flag controlling wether the microservice can be called from anyone (false) or
     * can be called only by other microservices (true)
     */
    function isInternal() external view returns (bool);

    /**
     * @dev GET the boolean flag controlling wether the original Proxy caller address should be forwarded or not
     */
    function needsSender() external view returns (bool);

    /**
     * @dev codeName of the microservice that will be replaced by this Proposal, can be blank.
     */
    function getReplaces() external view returns (string memory);

    /**
     * @dev GET the address of the proposer
     */
    function getProposer() external view returns (address);

    /**
     * @dev GET The proposal end block
     */
    function getSurveyEndBlock() external view returns (uint256);

    /**
     * @dev GET the duration of the Proposal in number of blocks
     */
    function getSurveyDuration() external view returns (uint256);

    /**
     * @dev Check that the HardCap has been reached
     */
    function isVotesHardCapReached() external view returns (bool);

    /**
     * @dev GET the HardCap value
     */
    function getVotesHardCapToReach() external view returns (uint256);

    /**
     * @dev GET the json representation of the Functionality
     */
    function toJSON() external view returns (string memory);

    /**
     * @dev GET the current status of the voting of the given address
     * @param addr The address of the voter you want to know status
     * @return accept Amount of YES votes
     * @return refuse Amount of NO votes
     */
    function getVote(address addr) external view returns (uint256 accept, uint256 refuse);

    /**
     * @dev Get the current votes status
     * @return accept Amount of YES votes
     * @return refuse Amount of NO votes
     */
    function getVotes() external view returns (uint256, uint256);

    /**
     * @dev Can be used by external Proposal Managers to delay the Survey Start
     */
    function start() external;

    /**
     * @dev Can be used by external Proposal Managers to disable not-yet started Surveys
     */
    function disable() external;

    /**
     * @dev Check if a Proposal was canceled before its start
     */
    function isDisabled() external view returns (bool);

    /**
     * @dev Check if the Proposal reached the natural time termination or the reachement of the Hard Cap.
     */
    function isTerminated() external view returns (bool);

    /**
     * @dev Vote to accept the Proposal, staking your voting tokens. Can be called only if the Proposal is still running.
     */
    function accept(uint256 amount) external;

    /**
     * @dev Retire your votes. Can be called only if the Proposal is still running.
     */
    function retireAccept(uint256 amount) external;

    /**
     * @dev Move some "refuse" votes to "accept". Can be called only if the Proposal is still running.
     */
    function moveToAccept(uint256 amount) external;

    /**
     * @dev Vote to refuse the Proposal, staking your voting tokens. Can be called only if the Proposal is still running.
     */
    function refuse(uint256 amount) external;

    /**
     * @dev Retire your votes. Can be called only if the Proposal is still running.
     */
    function retireRefuse(uint256 amount) external;

    /**
     * @dev Move some "accept" votes to "refuse". Can be called only if the Proposal is still running.
     */
    function moveToRefuse(uint256 amount) external;

    /**
     * @dev Retire all your votes, retreiving back your staked voting tokens. Can be called only if the Proposal is still running.
     */
    function retireAll() external;

    /**
     * @dev Withdraw all the token you staked. Can be called only if the Proposal reaches the Hard Cap or the final Block.
     */
    function withdraw() external;

    /**
     * @dev Force the Proposal to call the Proxy and execute the finalization operations. Can be called only if the Proposal reaches the Hard Cap or the final Block.
     */
    function terminate() external;

    /**
     * @dev Callable by the Proxy only. Marks this Proposal as definitively terminate. User can still call the withdrawAll() function to withdraw the tokens, of course.
     */
    function set() external;

    event Accept(address indexed voter, uint256 amount);
    event RetireAccept(address indexed voter, uint256 amount);
    event MoveToAccept(address indexed voter, uint256 amount);
    event Refuse(address indexed voter, uint256 amount);
    event RetireRefuse(address indexed voter, uint256 amount);
    event MoveToRefuse(address indexed voter, uint256 amount);
    event RetireAll(address indexed voter, uint256 amount);
}
