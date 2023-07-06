//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAddressTable} from "@main/interfaces/IAddressTable.sol";

import {BytesLib} from "@main/libraries/BytesLib.sol";

abstract contract DataDecompress {
    using BytesLib for bytes;

    IAddressTable public immutable addressTable;

    bool public autoRegisterAddressMapping;

    event SetAutoRegisterAddressMapping(bool _enable);
    
    constructor(
        IAddressTable _addressTable,
        bool _autoRegisterAddressMapping
    ) {
        addressTable = _addressTable;
        autoRegisterAddressMapping = _autoRegisterAddressMapping;
    }

    function _setAutoRegisterAddressMapping(
        bool _enable
    )
        internal
    {
        autoRegisterAddressMapping = _enable;
        emit SetAutoRegisterAddressMapping(_enable);
    }

    // function toBytes(bytes32 _data) private pure returns (bytes memory) {
    //     return abi.encodePacked(_data);
    // }

    function _lookupAddress_functionName1_24bits(
        bytes memory _data,
        uint256 _cursor
    )
        internal
        returns (
            address _address,
            uint256 _newCursor
        )
    {
        // (bool isIndexExisted,) = address(addressTable).call(abi.encodeWithSignature("lookupIndex(uint)", _data.toUint24(_cursor)));
        (bool isIndexExisted, bytes memory data) = address(addressTable).call(abi.encodeWithSelector(IAddressTable.lookupIndex.selector, _data.toUint24(_cursor)));
        _address = abi.decode(data, (address));
        _cursor += 3;
        // require(isIndexExisted, "DataDecompress: index is not existed ");

        if ( !isIndexExisted) {

            if (autoRegisterAddressMapping) {
                addressTable.register(_address);
            } else {
                revert("DataDecompress: must register first");
            }

        } 

        // registered (24-bit)
        // _address = addressTable.lookupIndex(_data.toUint24(_cursor));
        // _cursor += 3;

        _newCursor = _cursor;

    }

    function _deserializeAmount_functionName1(
        bytes memory _data,
        uint256 _cursor
    )
        internal
        pure
        returns (
            uint256 _amount,
            uint256 _newCursor
        )
    {
        uint8 instruction = _data.toUint8(_cursor);
        _cursor += 1;

        if (instruction == 0) { // 64-bit, 18 (denominated in 1e18)
            _amount = _data.toUint64(_cursor);
            _cursor += 8;
            
        } else if (instruction == 1) { // 80-bit, 1.2m (denominated in 1e18)
            _amount = _data.toUint80(_cursor);
            _cursor += 10;

        } else if (instruction == 2) { // 96-bit, 79.2b (denominated in 1e18)
            _amount = _data.toUint96(_cursor);
            _cursor += 12;

        } else if (instruction == 3) { // 112-bit, 5,192mm (denominated in 1e18)
            _amount = _data.toUint112(_cursor);
            _cursor += 14;
        
        } else if (instruction == 4) { // zero
            _amount = 0;

        } else {
            revert("DataDecompress: bad instruction");
        }

        _newCursor = _cursor;
    }



}