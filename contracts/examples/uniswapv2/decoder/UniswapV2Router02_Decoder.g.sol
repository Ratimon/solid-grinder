//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {IAddressTable} from "@solid-grinder/interfaces/IAddressTable.sol";
import {BytesLib} from "@solid-grinder/libraries/BytesLib.sol";

/**
  * @title Solid Grinder's generated contract to decode the encoded parameters
  * @author generated from the decoder template of Solid Grinder at https://github.com/Ratimon/solid-grinder/blob/main/cli/templates/Decoder.g.sol.hbs  
  * @notice use with caution!! this contract is generated automatically by Solid Grinder
  */

contract UniswapV2Router02_Decoder {


    using BytesLib for bytes;
    IAddressTable public immutable addressTable;

    constructor(IAddressTable _addressTable) {
        addressTable = _addressTable;
    }

    struct addLiquidityData {
        address tokenA;
        address tokenB;
        uint256 amountADesired;
        uint256 amountBDesired;
        uint256 amountAMin;
        uint256 amountBMin;
        address to;
        uint256 deadline;
        
    }

    function _decode_addLiquidityData(bytes memory _data, uint256 _cursor)
        internal
        view
        returns (addLiquidityData memory _addLiquidityData, uint256 _newCursor)
    {
        (_addLiquidityData.tokenA, _cursor) = _lookupAddress_addLiquidity_24bits(_data, _cursor);
        (_addLiquidityData.tokenB, _cursor) = _lookupAddress_addLiquidity_24bits(_data, _cursor);
        (_addLiquidityData.amountADesired, _cursor) = _deserializeAmount_addLiquidity_96bits(_data, _cursor);
        (_addLiquidityData.amountBDesired, _cursor) = _deserializeAmount_addLiquidity_96bits(_data, _cursor);
        (_addLiquidityData.amountAMin, _cursor) = _deserializeAmount_addLiquidity_96bits(_data, _cursor);
        (_addLiquidityData.amountBMin, _cursor) = _deserializeAmount_addLiquidity_96bits(_data, _cursor);
        (_addLiquidityData.to, _cursor) = _lookupAddress_addLiquidity_24bits(_data, _cursor);
        (_addLiquidityData.deadline, _cursor) = _deserializeAmount_addLiquidity_40bits(_data, _cursor);
        
        _newCursor = _cursor;
    }

    function _lookupAddress_addLiquidity_24bits(bytes memory _data, uint256 _cursor)
        internal
        view
        
        returns ( address _decoded, uint256 _newCursor)
    {
        _decoded = addressTable.lookupIndex(_data.toUint24(_cursor));
        
        _cursor += 3;
        _newCursor = _cursor;
    }
    function _deserializeAmount_addLiquidity_96bits(bytes memory _data, uint256 _cursor)
        internal
        
        pure
        returns ( uint256 _decoded, uint256 _newCursor)
    {
        
        _decoded = _data.toUint96(_cursor);
        _cursor += 12;
        _newCursor = _cursor;
    }
    function _deserializeAmount_addLiquidity_40bits(bytes memory _data, uint256 _cursor)
        internal
        
        pure
        returns ( uint256 _decoded, uint256 _newCursor)
    {
        
        _decoded = _data.toUint40(_cursor);
        _cursor += 5;
        _newCursor = _cursor;
    }
    

}