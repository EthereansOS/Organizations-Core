pragma solidity ^0.6.0;

import "./IMVDProxy.sol";
import "./CommonUtilities.sol";
import "./IStateHolder.sol";
import "./IMVDFunctionalitiesManager.sol";

contract StateHolder is IStateHolder, CommonUtilities {

    enum DataType {
        ADDRESS,
        BOOL,
        BYTES,
        STRING,
        UINT256
    }

    struct Var {
        string name;
        DataType dataType;
        bytes value;
        uint256 position;
        bool active;
    }

    Var[] private _state;
    mapping(string => uint256) private _index;
    address private _proxy;
    uint256 private _stateSize;

    constructor() public {
        init();
    }

    function init() public override {
        require(_state.length == 0, "Init already called!");
        _state.push(Var("", DataType.BYTES, "", 0, false));
    }

    modifier canSet {
        require(_state.length > 0, "Not Initialized!");
        if(_proxy != address(0)) {
            require(IMVDFunctionalitiesManager(IMVDProxy(_proxy).getMVDFunctionalitiesManagerAddress()).isAuthorizedFunctionality(msg.sender), "UnauthorizedAccess");
        }
        _;
    }

    function toJSON() public override view returns(string memory) {
        return toJSON(0, _state.length - 1);
    }

    function toJSON(uint256 start, uint256 l) public override view returns(string memory json) {
        uint256 length = start + 1 + l;
        json = "[";
        for(uint256 i = start; i < length; i++) {
            json = !_state[i].active ? json : string(abi.encodePacked(json, '{"name":"', _state[i].name, '","type":"', toString(_state[i].dataType), '"}', i == length - (_state[i].active ? 1 : 0) ? "" : ","));
            length += _state[i].active ? 0 : 1;
            length = length > _state.length ? _state.length : length;
        }
        json = string(abi.encodePacked(json, ']'));
    }

    function getStateSize() public override view returns (uint256) {
        return _stateSize;
    }

    function exists(string memory varName) public override view returns(bool) {
        return _state[_index[varName]].active;
    }

    function getDataType(string memory varName) public override view returns(string memory dataType) {
        Var memory v = _state[_index[varName]];
        if(v.active) {
            dataType = toString(v.dataType);
        }
    }

    function setVal(string memory varName, DataType dataType, bytes memory val) private canSet returns(bytes memory oldVal) {
        if(compareStrings(varName, "")) {
            return "";
        }
        Var memory v = _state[_index[varName]];
        oldVal = v.value;
        v.name = varName;
        v.value = val;
        if(v.position == 0) {
            for(uint256 i = 1; i < _state.length; i++) {
                if(!_state[i].active) {
                    v.position = i;
                    break;
                }
            }
        } else {
            require(!v.active || v.dataType == dataType, "Invalid dataType");
        }
        v.dataType = dataType;
        if(!v.active) {
            _stateSize++;
        }
        v.active = true;
        if(v.position == 0) {
            v.position = _state.length;
            _state.push(v);
        } else {
            _state[v.position] = v;
        }
        _index[varName] = v.position;
    }

    function clear(string memory varName) public canSet override returns(string memory oldDataType, bytes memory oldVal) {
        Var storage v = _state[_index[varName]];
        if(v.position > 0 && v.active) {
            oldDataType = toString(v.dataType);
            oldVal = v.value;
            v.value = "";
            v.position = 0;
            _index[v.name] = 0;
            v.active = false;
            _stateSize--;
        }
    }

    function setBytes(string memory varName, bytes memory val) public override returns(bytes memory) {
        return setVal(varName, DataType.BYTES, val);
    }

    function getBytes(string memory varName) public override view returns(bytes memory) {
        return _state[_index[varName]].value;
    }

    function setString(string memory varName, string memory val) public override returns(string memory) {
        return string(setVal(varName, DataType.STRING, bytes(val)));
    }

    function getString(string memory varName) public override view returns (string memory) {
        return string(_state[_index[varName]].value);
    }

    function setBool(string memory varName, bool val) public override returns(bool) {
        return toUint256(setVal(varName, DataType.BOOL, abi.encode(val ? 1 : 0))) == 1;
    }

    function getBool(string memory varName) public override view returns (bool) {
        return toUint256(_state[_index[varName]].value) == 1;
    }

    function getUint256(string memory varName) public override view returns (uint256) {
        return toUint256(_state[_index[varName]].value);
    }

    function setUint256(string memory varName, uint256 val) public override returns(uint256) {
        return toUint256(setVal(varName, DataType.UINT256, abi.encode(val)));
    }

    function getAddress(string memory varName) public override view returns (address) {
        return toAddress(_state[_index[varName]].value);
    }

    function setAddress(string memory varName, address val) public override returns (address) {
        return toAddress(setVal(varName, DataType.ADDRESS, abi.encodePacked(val)));
    }

    function getProxy() public override view returns (address) {
        return _proxy;
    }

    function setProxy() public override {
        require(_state.length != 0, "Init not called!");
        require(_proxy == address(0) || _proxy == msg.sender, _proxy != address(0) ? "Proxy already set!" : "Only Proxy can toggle itself!");
        _proxy = _proxy == address(0) ?  msg.sender : address(0);
    }

    function toString(DataType dataType) private pure returns (string memory) {
        return
            dataType == DataType.ADDRESS ? "address" :
            dataType == DataType.BOOL ? "bool" :
            dataType == DataType.BYTES ? "bytes" :
            dataType == DataType.STRING ? "string" :
            dataType == DataType.UINT256 ? "uint256" :
            "";
    }

    function toDataType(string memory dataType) private pure returns (DataType) {
        return
            compareStrings(dataType, "address") ? DataType.ADDRESS :
            compareStrings(dataType, "bool") ? DataType.BOOL :
            compareStrings(dataType, "string") ? DataType.STRING :
            compareStrings(dataType, "uint256") ? DataType.UINT256 :
            DataType.BYTES;
    }
}