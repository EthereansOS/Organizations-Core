// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0;

/**
 * // DOCUMENT Add detailed explanation of what a proxy is
 * @title Proxy Interface
 */
interface IMVDProxy {
    /**
     * @dev Initialization logic used during the constructor call
     * @param votingTokenAddress Address of the Voting Token
     * @param functionalityProposalManagerAddress Address of the Functionality Proposal Manager
     * @param stateHolderAddress Address of the State Holder contract
     * @param functionalityModelsManagerAddress Address of the Functionality Models Manager
     * @param functionalitiesManagerAddress Address of the Functionalities Manager
     * @param walletAddress Address of the wallet
     * @param doubleProxyAddress Address of the double proxy
     */
    function init(
        address votingTokenAddress,
        address functionalityProposalManagerAddress,
        address stateHolderAddress,
        address functionalityModelsManagerAddress,
        address functionalitiesManagerAddress,
        address walletAddress,
        address doubleProxyAddress
    ) external;

    function getDelegates() external view returns (address[] memory);

    /**
     * @dev GET the voting token contract address
     */
    function getToken() external view returns (address);

    /**
     * @dev GET the Functionality Proposal Manager contract address
     */
    function getMVDFunctionalityProposalManagerAddress() external view returns (address);

    /**
     * @dev GET the State Holder contract address
     */
    function getStateHolderAddress() external view returns (address);

    /**
     * @dev GET the Functionality Models Manager contract address
     */
    function getMVDFunctionalityModelsManagerAddress() external view returns (address);

    /**
     * @dev GET the Functionalities Manager contract address
     */
    function getMVDFunctionalitiesManagerAddress() external view returns (address);

    /**
     * @dev GET the Wallet contract address
     */
    function getMVDWalletAddress() external view returns (address);

    /**
     * @dev GET the Double Proxy contract address
     */
    function getDoubleProxyAddress() external view returns (address);

    function setDelegate(uint256 position, address newAddress)
        external
        returns (address oldAddress);

    function changeProxy(address newAddress, bytes calldata initPayload) external;

    function isValidProposal(address proposal) external view returns (bool);

    function isAuthorizedFunctionality(address functionality) external view returns (bool);

    /**
     * @dev Add a new proposal
     * @param codeName ID of the microservice, to be called by the user through Proxy, can be blank.
     * @param emergency Boolean, true -> Emergency Proposal, false -> Standard Proposal
     * @param sourceLocation Location of the source code, saved in concatenated Base64 data chunks
     * @param sourceLocationId Base64 data chunk id of the corresponding Microservice
     * @param location Address of the functionality/microservice to call
     * @param submittable Boolean flag controlling wether the microservice writes data to the chain
     * @param methodSignature Name of the method of the microservice you want to call
     * @param returnParametersJSONArray Array of json encoded return parameters of the proposal
     * @param isInternal Boolean flag controlling wether the microservice can be called from anyone (false) or
     * can be called only by other microservices (true)
     * @param needsSender All microservices calls are made py the Proxy, with this boolean flag you can
     * @param replaces codeName of the microservice that will be replaced by this Proposal, can be blank.
     * @return proposalAddress Address of the newly created proposal
     */
    function newProposal(
        string calldata codeName,
        bool emergency,
        address sourceLocation,
        uint256 sourceLocationId,
        address location,
        bool submittable,
        string calldata methodSignature,
        string calldata returnParametersJSONArray,
        bool isInternal,
        bool needsSender,
        string calldata replaces
    ) external returns (address proposalAddress);

    /**
     * @dev Can be used by external Proposal Managers to delay the Survey Start
     */
    function startProposal(address proposalAddress) external;

    /**
     * @dev Can be used by external Proposal Managers to disable not-yet started Surveys
     */
    function disableProposal(address proposalAddress) external;

    /**
     * @dev Transfer a token to an address
     * @param receiver Address of the receiver
     * @param value Amount of token to transfer
     * @param token Address of the token to transfer
     */
    function transfer(
        address receiver,
        uint256 value,
        address token
    ) external;

    /**
     * @dev Transfer an ERC721 to an address
     * @param receiver Address of the receiver
     * @param tokenId ID of the ERC721 to transfer
     * @param data The optional payload to pass in the safeTransferFrom function
     * @param safe Boolean flag for triggering the SafeTransfer
     * @param token Address of the token to transfer
     */
    function transfer721(
        address receiver,
        uint256 tokenId,
        bytes calldata data,
        bool safe,
        address token
    ) external;

    /**
     * @dev Utility public method callable by everyone to send all ether/tokens/NFT accidentally sent to the Proxy.
     * It flushes all in the DFO Wallet
     * @param tokenAddress the ERC20/ERC721 token to transfer. address(0) means flush ether
     * @param is721 tokenAddress is 721 or ERC20
     * @param tokenId the id of the eventual ERC721 Token to transfer
     */
    function flushToWallet(
        address tokenAddress,
        bool is721,
        uint256 tokenId
    ) external;

    /**
     * @dev Callable by the Proposals only. Starts the Proposal finalization procedure
     */
    function setProposal() external;

    /**
     * @dev Call a non-submitable (readonly function marked as pure or view) Microservice
     * @param codeName the ID of the Microservice to be called
     * @param data ABI encoded data payload to be passed to the Microservice
     */
    function read(string calldata codeName, bytes calldata data)
        external
        view
        returns (bytes memory returnData);

    /**
     * @dev Call a submitable (which writes on the Blockchain State) Microservice
     * @param codeName the ID of the Microservice to be called
     * @param data ABI encoded data payload to be passed to the Microservice
     */
    function submit(string calldata codeName, bytes calldata data)
        external
        payable
        returns (bytes memory returnData);

    /**
     * @dev callable by the MVDFunctionalitiesManager only.
     * Calls a Microservice using the Proxy as msg.sender
     */
    function callFromManager(address location, bytes calldata payload)
        external
        returns (bool, bytes memory);

    /**
     * @dev callable by the MVDFunctionalitiesManager only.
     * Emits the FunctionalitySet event by the Proxy
     */
    function emitFromManager(
        string calldata codeName,
        address proposal,
        string calldata replaced,
        address replacedSourceLocation,
        uint256 replacedSourceLocationId,
        address location,
        bool submittable,
        string calldata methodSignature,
        bool isInternal,
        bool needsSender,
        address proposalAddress
    ) external;

    /**
     * @dev callable by Microservices only.
     * Emits the general purpose "Event" event by the Proxy
     */
    function emitEvent(
        string calldata eventSignature,
        bytes calldata firstIndex,
        bytes calldata secondIndex,
        bytes calldata data
    ) external;

    event ProxyChanged(address indexed newAddress);
    event DelegateChanged(uint256 position, address indexed oldAddress, address indexed newAddress);

    event Proposal(address proposal);
    event ProposalCheck(address indexed proposal);
    event ProposalSet(address indexed proposal, bool success);
    event FunctionalitySet(
        string codeName,
        address indexed proposal,
        string replaced,
        address replacedSourceLocation,
        uint256 replacedSourceLocationId,
        address indexed replacedLocation,
        bool replacedWassubmittable,
        string replacedMethodSignature,
        bool replacedWasInternal,
        bool replacedNeededSender,
        address indexed replacedProposal
    );

    event Event(
        string indexed key,
        bytes32 indexed firstIndex,
        bytes32 indexed secondIndex,
        bytes data
    );
}
