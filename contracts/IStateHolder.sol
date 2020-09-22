pragma solidity >=0.7.0;

/**
 * @title State Holder
 * StateHolder is the Database of a DFO. It stores all data the DFO needs to run its business logic.
 * It works like a Key/Value storage and can save the main Solidity data types (address, bool, uint256, string, bytes).
 * The read capabilities are of course public. While se write capabilities (set/clear) can be called by DFO Microservices only.
 * The set methods also return the previous value of the set variable
 */
interface IStateHolder {
    /**
     * @dev Initialization logic using during the constructor Call
     */
    function init() external;

    /**
     * @dev GET the Proxy
     */
    function getProxy() external view returns (address);

    /**
     * @dev SET the Proxy
     */
    function setProxy() external;

    /**
     * @dev For frontend purposes. Returns the StateHolder's keys and values in JSON Format
     */
    function toJSON() external view returns (string memory);

    /**
     * @dev For frontend purposes. Returns the StateHolder's keys and values in JSON Format
     * @param start the values array start
     * @param l the values array offset
     */
    function toJSON(uint256 start, uint256 l) external view returns (string memory);

    /**
     * @dev returns the number of values set in the StateHolder
     */
    function getStateSize() external view returns (uint256);

    /**
     * @param varName the name of the variable to check
     * @return true if varName is set, false otherwise
     */
    function exists(string calldata varName) external view returns (bool);

    /**
     * @param varName the name of the variable to check
     * @return dataType the data type of this var, if any.
     */
    function getDataType(string calldata varName) external view returns (string memory dataType);

    /**
     * @dev delete the variable from the StateHolder
     * @param varName the name of the variable to delete
     * @return oldDataType the data type of the deleted variable
     * @return oldVal the old value of the deleted variable
     */
    function clear(string calldata varName)
        external
        returns (string memory oldDataType, bytes memory oldVal);

    function setBytes(string calldata varName, bytes calldata val) external returns (bytes memory);

    function getBytes(string calldata varName) external view returns (bytes memory);

    function setString(string calldata varName, string calldata val)
        external
        returns (string memory);

    function getString(string calldata varName) external view returns (string memory);

    function setBool(string calldata varName, bool val) external returns (bool);

    function getBool(string calldata varName) external view returns (bool);

    function getUint256(string calldata varName) external view returns (uint256);

    function setUint256(string calldata varName, uint256 val) external returns (uint256);

    function getAddress(string calldata varName) external view returns (address);

    function setAddress(string calldata varName, address val) external returns (address);
}
