// SPDX-License-Identifier: Unlicense

// MODIFIED VERSION FROM https://github.com/GNSPS/solidity-bytes-utils/blob/master/contracts/BytesLib.sol
pragma solidity >=0.8.0 <0.9.0;

library BytesLib {

    function toUint8(bytes memory _bytes, uint256 _start) internal pure returns (uint8) {
        require(_bytes.length >= _start + 1, "toUint8_outOfBounds");
        uint8 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x1), _start))
        }

        return tempUint;
    }

    function toUint16(bytes memory _bytes, uint256 _start) internal pure returns (uint16) {
        require(_bytes.length >= _start + 2, "toUint16_outOfBounds");
        uint16 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x2), _start))
        }

        return tempUint;
    }

    function toUint24(bytes memory _bytes, uint256 _start) internal pure returns (uint24) {
        require(_bytes.length >= _start + 3, "toUint24_outOfBounds");
        uint24 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x3), _start))
        }

        return tempUint;
    }

    function toUint32(bytes memory _bytes, uint256 _start) internal pure returns (uint32) {
        require(_bytes.length >= _start + 4, "toUint32_outOfBounds");
        uint32 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x4), _start))
        }

        return tempUint;
    }

    function toUint40(bytes memory _bytes, uint256 _start) internal pure returns (uint40) {
        require(_bytes.length >= _start + 5, "toUint40_outOfBounds");
        uint40 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x5), _start))
        }

        return tempUint;
    }

    function toUint48(bytes memory _bytes, uint256 _start) internal pure returns (uint48) {
        require(_bytes.length >= _start + 6, "toUint48_outOfBounds");
        uint48 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x6), _start))
        }

        return tempUint;
    }

    function toUint56(bytes memory _bytes, uint256 _start) internal pure returns (uint56) {
        require(_bytes.length >= _start + 7, "toUint54_outOfBounds");
        uint56 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x7), _start))
        }

        return tempUint;
    }

    function toUint64(bytes memory _bytes, uint256 _start) internal pure returns (uint64) {
        require(_bytes.length >= _start + 8, "toUint64_outOfBounds");
        uint64 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x8), _start))
        }

        return tempUint;
    }

    function toUint72(bytes memory _bytes, uint256 _start) internal pure returns (uint72) {
        require(_bytes.length >= _start + 9, "toUint72_outOfBounds");
        uint72 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x9), _start))
        }

        return tempUint;
    }

    function toUint80(bytes memory _bytes, uint256 _start) internal pure returns (uint80) {
        require(_bytes.length >= _start + 10, "toUint80_outOfBounds");
        uint80 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0xa), _start))
        }

        return tempUint;
    }

    function toUint88(bytes memory _bytes, uint256 _start) internal pure returns (uint88) {
        require(_bytes.length >= _start + 11, "toUint88_outOfBounds");
        uint88 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0xb), _start))
        }

        return tempUint;
    }

    function toUint96(bytes memory _bytes, uint256 _start) internal pure returns (uint96) {
        require(_bytes.length >= _start + 12, "toUint96_outOfBounds");
        uint96 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0xc), _start))
        }

        return tempUint;
    }

    function toUint104(bytes memory _bytes, uint256 _start) internal pure returns (uint104) {
        require(_bytes.length >= _start + 13, "toUint104_outOfBounds");
        uint104 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0xd), _start))
        }

        return tempUint;
    }

    function toUint112(bytes memory _bytes, uint256 _start) internal pure returns (uint112) {
        require(_bytes.length >= _start + 14, "toUint112_outOfBounds");
        uint112 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0xe), _start))
        }

        return tempUint;
    }

    function toUint120(bytes memory _bytes, uint256 _start) internal pure returns (uint120) {
        require(_bytes.length >= _start + 15, "toUint120_outOfBounds");
        uint120 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0xf), _start))
        }

        return tempUint;
    }

    function toUint128(bytes memory _bytes, uint256 _start) internal pure returns (uint128) {
        require(_bytes.length >= _start + 16, "toUint128_outOfBounds");
        uint128 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x10), _start))
        }

        return tempUint;
    }

    function toUint136(bytes memory _bytes, uint256 _start) internal pure returns (uint136) {
        require(_bytes.length >= _start + 17, "toUint136_outOfBounds");
        uint136 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x11), _start))
        }

        return tempUint;
    }

    function toUint144(bytes memory _bytes, uint256 _start) internal pure returns (uint144) {
        require(_bytes.length >= _start + 18, "toUint144_outOfBounds");
        uint144 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x12), _start))
        }

        return tempUint;
    }

    function toUint152(bytes memory _bytes, uint256 _start) internal pure returns (uint152) {
        require(_bytes.length >= _start + 19, "toUint152_outOfBounds");
        uint152 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x13), _start))
        }

        return tempUint;
    }

    function toUint160(bytes memory _bytes, uint256 _start) internal pure returns (uint160) {
        require(_bytes.length >= _start + 20, "toUint160_outOfBounds");
        uint160 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x14), _start))
        }

        return tempUint;
    }
    
    function toUint168(bytes memory _bytes, uint256 _start) internal pure returns (uint168) {
        require(_bytes.length >= _start + 21, "toUint168_outOfBounds");
        uint168 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x15), _start))
        }

        return tempUint;
    }

    function toUint176(bytes memory _bytes, uint256 _start) internal pure returns (uint176) {
        require(_bytes.length >= _start + 22, "toUint176_outOfBounds");
        uint176 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x16), _start))
        }

        return tempUint;
    }

    function toUint184(bytes memory _bytes, uint256 _start) internal pure returns (uint184) {
        require(_bytes.length >= _start + 23, "toUint184_outOfBounds");
        uint184 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x17), _start))
        }

        return tempUint;
    }

    function toUint192(bytes memory _bytes, uint256 _start) internal pure returns (uint192) {
        require(_bytes.length >= _start + 24, "toUint192_outOfBounds");
        uint192 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x18), _start))
        }

        return tempUint;
    }

    function toUint200(bytes memory _bytes, uint256 _start) internal pure returns (uint200) {
        require(_bytes.length >= _start + 25, "toUint200_outOfBounds");
        uint200 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x19), _start))
        }

        return tempUint;
    }

    function toUint208(bytes memory _bytes, uint256 _start) internal pure returns (uint208) {
        require(_bytes.length >= _start + 26, "toUint208_outOfBounds");
        uint208 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x1a), _start))
        }

        return tempUint;
    }

    function toUint216(bytes memory _bytes, uint256 _start) internal pure returns (uint216) {
        require(_bytes.length >= _start + 27, "toUint216_outOfBounds");
        uint216 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x1b), _start))
        }

        return tempUint;
    }

    function toUint224(bytes memory _bytes, uint256 _start) internal pure returns (uint224) {
        require(_bytes.length >= _start + 28, "toUint224_outOfBounds");
        uint224 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x1c), _start))
        }

        return tempUint;
    }

    function toUint232(bytes memory _bytes, uint256 _start) internal pure returns (uint232) {
        require(_bytes.length >= _start + 29, "toUint232_outOfBounds");
        uint232 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x1d), _start))
        }

        return tempUint;
    }


    function toUint240(bytes memory _bytes, uint256 _start) internal pure returns (uint240) {
        require(_bytes.length >= _start + 30, "toUint240_outOfBounds");
        uint240 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x1e), _start))
        }

        return tempUint;
    }

    function toUint248(bytes memory _bytes, uint256 _start) internal pure returns (uint248) {
        require(_bytes.length >= _start + 31, "toUint248_outOfBounds");
        uint248 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x1f), _start))
        }

        return tempUint;
    }

    function toUint256(bytes memory _bytes, uint256 _start) internal pure returns (uint256) {
        require(_bytes.length >= _start + 32, "toUint256_outOfBounds");
        uint256 tempUint;

        assembly {
            tempUint := mload(add(add(_bytes, 0x20), _start))
        }

        return tempUint;
    }

}
