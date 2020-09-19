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
     * @param codeName ID of the Proposal
     * @param emergency Boolean, true -> Emergency Proposal, false -> Standard Proposal
     * @param sourceLocation ROBE location of the source code
     * @param sourceLocationId ROBE id
     * @param location Address of the functionality/microservice to call
     * @param submittable Boolean flag controlling wether the microservice writes data to the chain
     * @param methodSignature Name of the method of the microservice you want to call
     * @param returnParametersJSONArray Array of json encoded return parameters of the proposal
     * @param isInternal Boolean flag controlling wether the microservice can be called from anyone (false) or
     * can be called only by other microservices (true)
     * @param needsSender All microservices calls are made py the Proxy, with this boolean flag you can
     * @param replaces // DOCUMENT
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

    // DOCUMENTATION
    function startProposal(address proposalAddress) external;

    // DOCUMENTATION
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
     * @param data // DOCUMENTATION
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

    // DOCUMENT
    function flushToWallet(
        address tokenAddress,
        bool is721,
        uint256 tokenId
    ) external;

    // DOCUMENT
    function setProposal() external;

    // DOCUMENT
    function read(string calldata codeName, bytes calldata data)
        external
        view
        returns (bytes memory returnData);

    // DOCUMENT
    function submit(string calldata codeName, bytes calldata data)
        external
        payable
        returns (bytes memory returnData);

    // DOCUMENT
    function callFromManager(address location, bytes calldata payload)
        external
        returns (bool, bytes memory);

    // DOCUMENT
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

    // DOCUMENT
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
