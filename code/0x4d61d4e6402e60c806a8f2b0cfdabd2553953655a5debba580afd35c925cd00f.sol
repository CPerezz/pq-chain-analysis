// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

/// @title            Decompiled Contract
/// @author           Jonathan Becker <jonathan@jbecker.dev>
/// @custom:version   heimdall-rs v0.9.2
///
/// @notice           This contract was decompiled using the heimdall-rs decompiler.
///                     It was generated directly by tracing the EVM opcodes from this contract.
///                     As a result, it may not compile or even be valid solidity code.
///                     Despite this, it should be obvious what each function does. Overall
///                     logic should have been preserved throughout decompiling.
///
/// @custom:github    You can find the open-source decompiler here:
///                       https://heimdall.rs

contract DecompiledContract {
    bytes store_i; // storage slot: 0x02
    bytes32 store_o; // storage slot: 0x03
    bytes store_j; // storage slot: 0x05
    bytes store_e; // storage slot: 0x62
    bytes store_f; // storage slot: 0x63
    bytes store_g; // storage slot: 0x64
    bytes store_h; // storage slot: 0x65
    bytes store_d; // storage slot: 0x66
    address public whitelist; // storage slot: 0x67
    bytes32 store_k; // storage slot: 0x6a
    bytes32 store_r; // storage slot: 0x46501879b8ca8525e8c2fd519e2fbfcfa2ebea26501294aa02cbfcfb12e94354
    bytes32 store_c; // storage slot: 0x8dea8703c3cf94703383ce38a9c894669dccd4ca8e65ddb43267aa0248711450
    address public unresolved_8da5cb5b; // storage slot: 0x9016d09d72d40fdae2fd8ceac6b6234c7706214fd39c1cd1e609a0528c199300
    bytes32 store_v; // storage slot: 0x9016d09d72d40fdae2fd8ceac6b6234c7706214fd39c1cd1e609a0528c199300
    bytes32 store_t; // storage slot: 0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00
    uint64 store_s; // storage slot: 0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00
    uint8 store_u; // storage slot: 0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00
    bytes32 store_q; // storage slot: keccak256(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]], keccak256(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]], 0x30)) + 0x01 + 0x01
    bytes32 store_x; // storage slot: 0x06 + arg0
    
    mapping(uint256 => mapping(uint256 => uint8)) storage_map_l; // storage slot: 0x00
    mapping(uint256 => mapping(uint256 => uint8)) storage_map_m; // storage slot: 0x01
    mapping(uint256 => mapping(uint256 => bytes32)) storage_map_p; // storage slot: 0x30
    mapping(uint256 => bytes32) storage_map_b; // storage slot: 0x68
    mapping(uint256 => bytes32) storage_map_n; // storage slot: 0x69
    
    error CustomError_00000000();
    event Event_1a2d9eef();
    event Event_8be0079c();
    event VerifyingKeySet(uint256, uint256, (string,(uint256,uint256),(uint256[2],uint256[2]),(uint256[2],uint256[2]),(uint256[2],uint256[2]),(uint256,uint256)[]));
    
    /// @custom:selector    0x6cefafaa
    /// @custom:signature   addVector(uint256 arg0) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function addVector(uint256 arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        storage_map_b[arg0] = storage_map_b[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
        return ;
    }
    
    /// @custom:selector    0x0804a4ee
    /// @custom:signature   checkSafetyVectors() public payable
    function checkSafetyVectors() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        store_c = store_c & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
        require(storage_map_b[msg.sender], "ZkGardenLogic: Unsafe vectors");
    }
    
    /// @custom:selector    0x1e5eb1d0
    /// @custom:signature   feeConfig() public view returns (bytes memory)
    function feeConfig() public view returns (bytes memory) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (store_d >> 0x01 < 0x20 != (store_d & 0x01)) {
            if (0x01 == (store_d & 0x01)) {
                if (!(var_d + (0x20 + var_d - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (0x20 + var_d - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
                    uint256 var_d = var_d + (0x20 + var_d - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                    return abi.encodePacked(store_e, store_f, store_g, store_h, 0xa0, var_k);
                }
            } else {
                if (!(var_d + (0 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (0 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
                    return abi.encodePacked(store_e, store_f, store_g, store_h, 0xa0, var_k, store_f, store_g, store_h, 0xa0, var_k);
                }
            }
        }
    }
    
    /// @custom:selector    0x0c9c0c8d
    /// @custom:signature   getInsertionTreeNumberAndStartingIndex(uint256 arg0) public view returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function getInsertionTreeNumberAndStartingIndex(uint256 arg0) public view returns (bytes memory) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        if (store_i <= store_i + arg0) {
            if (0x010000 < store_i + arg0) {
                if (store_j <= store_j + 0x01) {
                    return abi.encodePacked(store_j + 0x01, 0);
                }
            } else {
                return abi.encodePacked(store_j, store_i);
            }
        }
    }
    
    /// @custom:selector    0x7b12ae83
    /// @custom:signature   getVerificationKey(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function getVerificationKey(uint256 arg0, uint256 arg1) public pure {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
    }
    
    /// @custom:selector    0xcd3efe06
    /// @custom:signature   lastEventBlock() public view returns (uint256)
    function lastEventBlock() public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_k;
    }
    
    /// @custom:selector    0x0be4f422
    /// @custom:signature   nextLeafIndex() public view returns (uint256)
    function nextLeafIndex() public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_i;
    }
    
    /// @custom:selector    0x78d3915c
    /// @custom:signature   nullifiers(uint256 arg0, uint256 arg1) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function nullifiers(uint256 arg0, uint256 arg1) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        var_c = storage_map_l[arg0][arg1].field_0;
        return var_c;
    }
    
    /// @custom:selector    0xdc7c9a1f
    /// @custom:signature   removeVector(uint256 arg0) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function removeVector(uint256 arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        storage_map_b[arg0] = storage_map_b[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        return ;
    }
    
    /// @custom:selector    0x38953305
    /// @custom:signature   rootHistory(uint256 arg0, uint256 arg1) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function rootHistory(uint256 arg0, uint256 arg1) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        var_c = storage_map_m[arg0][arg1].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x129458f4
    /// @custom:signature   snarkSafetyVector(uint256 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function snarkSafetyVector(uint256 arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        var_c = storage_map_b[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0xb8ceaef2
    /// @custom:signature   tokenIDMapping(bytes32 arg0) public view returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function tokenIDMapping(bytes32 arg0) public view returns (bytes memory) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        if (0x03 > storage_map_n[arg0].field_0) {
            var_d = storage_map_n[arg0].field_0;
            var_e = storage_map_n[arg0].field_8;
            var_f = storage_map_n[arg0].field_1;
            return abi.encodePacked(var_d, var_e, var_f);
        }
    }
    
    /// @custom:selector    0x66503315
    /// @custom:signature   treeNumber() public view returns (uint256)
    function treeNumber() public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_j;
    }
    
    /// @custom:selector    0x032e0530
    /// @custom:signature   Unresolved_032e0530(uint256 arg0) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_032e0530(uint256 arg0) public pure {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
    }
    
    /// @custom:selector    0x2832e338
    /// @custom:signature   Unresolved_2832e338(uint256 arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_2832e338(uint256 arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xa0);
        if (!(var_a + 0x60 > 0xffffffffffffffff | var_a + 0x60 < var_a)) {
            uint256 var_a = var_a + 0x60;
            require(msg.data.length - 0x24 >= 0x60);
            if (!(var_a + 0x60 > 0xffffffffffffffff | var_a + 0x60 < var_a)) {
                uint256 var_a = var_a + 0x60;
                require(0x03 > arg1);
                require(!(arg2 - arg2));
                if (!(var_a + 0x60 > 0xffffffffffffffff | var_a + 0x60 < var_a)) {
                    uint256 var_a = var_a + 0x60;
                    if (0x03 > var_m && (0x03 > var_m && (0x03 > var_m && !(var_a + 0x80 > 0xffffffffffffffff | var_a + 0x80 < var_a)))) {
                        uint256 var_a = var_a + 0x80;
                        (bool success, bytes memory ret0) = address(0x4443338ef595f44e0121df4c21102677b142ecf0).Unresolved_20cf0a37(var_x); // delegatecall
                        require(success);
                        if (!success) {
                            return 0;
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x2eb4a7ab
    /// @custom:signature   Unresolved_2eb4a7ab() public view returns (uint256)
    function Unresolved_2eb4a7ab() public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_o;
    }
    
    /// @custom:selector    0x2ebfe12a
    /// @custom:signature   Unresolved_2ebfe12a(uint256 arg0, uint256 arg1, uint256 arg2) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_2ebfe12a(uint256 arg0, uint256 arg1, uint256 arg2) public pure {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0140);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - arg0 + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0200);
        if (!(var_a + 0xc0 > 0xffffffffffffffff | var_a + 0xc0 < var_a)) {
            uint256 var_a = var_a + 0xc0;
            require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
            require(arg0 + msg.data[0x04 + arg0] + 0x04 + 0x1f < msg.data.length);
            if (msg.data[arg0 + msg.data[0x04 + arg0] + 0x04] <= 0xffffffffffffffff && !(var_a + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[arg0 + msg.data[0x04 + arg0] + 0x04]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_a + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[arg0 + msg.data[0x04 + arg0] + 0x04]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_a)) {
                uint256 var_a = var_a + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_d) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                uint256 var_d = msg.data[arg0 + msg.data[0x04 + arg0] + 0x04];
                require(arg0 + msg.data[0x04 + arg0] + 0x04 + 0x20 + msg.data[arg0 + msg.data[0x04 + arg0] + 0x04] <= msg.data.length);
                require(msg.data.length - (arg0 + 0x24) >= 0x40);
                if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                    uint256 var_a = var_a + 0x40;
                    require(msg.data.length - (arg0 + 0x64) >= 0x80);
                    if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                        uint256 var_a = var_a + 0x40;
                        require(arg0 + 0x64 + 0x1f < msg.data.length);
                        if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                            require(arg0 + 0x64 + 0x40 <= msg.data.length);
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x2ec0f359
    /// @custom:signature   Unresolved_2ec0f359(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg15 ["uint256", "bytes32", "int256"]
    function Unresolved_2ec0f359(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data.length - arg2 + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0200);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        var_c = keccak256(arg0, 0x30);
        require(msg.data[0x04 + arg2] < msg.data.length - (0x04 + arg2) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg2 + msg.data[0x04 + arg2]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg2 + msg.data[0x04 + arg2]) <= msg.data.length - msg.data[0x04 + arg2 + msg.data[0x04 + arg2]]);
        if (msg.data[0x04 + arg2 + msg.data[0x04 + arg2]] <= 0xffffffffffffffff && (storage_map_p[arg0][arg1] >> 0x01 < 0x20 != (storage_map_p[arg0][arg1] & 0x01) && 0x01 == (msg.data[0x04 + arg2 + msg.data[0x04 + arg2]] > 0x1f))) {
            storage_map_p[arg0][arg1][0] = msg.data[0x20 + (0x04 + arg2 + msg.data[0x04 + arg2])] & ~(type(uint256).max >> (msg.data[0x04 + arg2 + msg.data[0x04 + arg2]] << 0x03 & 0xf8));
            storage_map_p[arg0][arg1] = (msg.data[0x04 + arg2 + msg.data[0x04 + arg2]] << 0x01) + 0x01;
            storage_map_p[arg0][arg1].field_1 = msg.data[arg2 + 0x24];
            storage_map_p[arg0][arg1].field_2 = msg.data[arg2 + 0x44];
            require(msg.data[arg2 + 0x01e4] < msg.data.length - (0x04 + arg2) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[0x04 + arg2 + msg.data[arg2 + 0x01e4]] <= 0xffffffffffffffff);
            require(0x20 + (0x04 + arg2 + msg.data[arg2 + 0x01e4]) <= msg.data.length - (msg.data[0x04 + arg2 + msg.data[arg2 + 0x01e4]] << 0x06));
            if (msg.data[0x04 + arg2 + msg.data[arg2 + 0x01e4]] <= 0x010000000000000000) {
                storage_map_p[arg0][arg1].field_15 = msg.data[0x04 + arg2 + msg.data[arg2 + 0x01e4]];
                if (!(storage_map_p[arg0][arg1].field_15 - (storage_map_p[arg0][arg1].field_15 & 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)) && !(msg.data[0x04 + arg2 + msg.data[arg2 + 0x01e4]] - (msg.data[0x04 + arg2 + msg.data[arg2 + 0x01e4]] & 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff))) {
                    require(msg.data[0x04 + arg2] < msg.data.length - (0x04 + arg2) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                    require(msg.data[msg.data[0x04 + arg2] + (0x04 + arg2)] <= 0xffffffffffffffff);
                    require(msg.data[0x04 + arg2] + (0x04 + arg2) + 0x20 <= msg.data.length - msg.data[msg.data[0x04 + arg2] + (0x04 + arg2)]);
                    require(msg.data[0x04 + arg2 + 0x01e0] < msg.data.length - (0x04 + arg2) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                    require(msg.data[msg.data[0x04 + arg2 + 0x01e0] + (0x04 + arg2)] <= 0xffffffffffffffff);
                    require(msg.data[0x04 + arg2 + 0x01e0] + (0x04 + arg2) + 0x20 <= msg.data.length - (msg.data[msg.data[0x04 + arg2 + 0x01e0] + (0x04 + arg2)] << 0x06));
                    emit VerifyingKeySet(arg0, arg1, 0x60, 0x0200, msg.data[0x04 + arg2 + 0x20], msg.data[0x04 + arg2 + 0x40], (msg.data[msg.data[0x04 + arg2] + (0x04 + arg2)] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + (var_i + 0x0260) + 0x20 - var_i + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa0, msg.data[msg.data[0x04 + arg2] + (0x04 + arg2)], msg.data[msg.data[0x04 + arg2 + 0x01e0] + (0x04 + arg2)]);
                }
            }
        }
    }
    
    /// @custom:selector    0x3286c781
    /// @custom:signature   Unresolved_3286c781(uint256 arg0, uint256 arg1, uint256 arg2) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    function Unresolved_3286c781(uint256 arg0, uint256 arg1, uint256 arg2) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - arg0 + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0220);
        require(msg.data[0x04 + arg0 + 0x0120] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]] << 0x05));
        require(msg.data[0x04 + arg0 + 0x0140] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]] << 0x05));
        var_b = keccak256(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]], 0x30);
        if (!(var_c + 0xc0 > 0xffffffffffffffff | var_c + 0xc0 < var_c)) {
            uint256 var_c = var_c + 0xc0;
            if (storage_map_p[msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]]][msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]]] >> 0x01 < 0x20 != (storage_map_p[msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]]][msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]]] & 0x01) && !(var_c + (var_c + 0x20 - var_c + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (var_c + 0x20 - var_c + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
                uint256 var_c = var_c + (var_c + 0x20 - var_c + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                if (!(var_c + 0x40 > 0xffffffffffffffff | var_c + 0x40 < var_c)) {
                    uint256 var_c = var_c + 0x40;
                }
            }
        }
    }
    
    /// @custom:selector    0x55481ea3
    /// @custom:signature   Unresolved_55481ea3(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public pure returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    function Unresolved_55481ea3(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public pure returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
        if (0 < msg.data[0x04 + arg0]) {
            if (0 < msg.data[0x04 + arg0]) {
                require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0 + 0x20) + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffde1);
                require(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160] < msg.data.length - (0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]) + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffea1);
                require(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160] + 0x0140] < msg.data.length - (0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160]) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                require(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160] + 0x0140]] <= 0xffffffffffffffff);
                require(0x20 + (0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160] + 0x0140]) <= msg.data.length - (msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160] + 0x0140]] << 0x05));
            }
        } else {
            return 0;
        }
    }
    
    /// @custom:selector    0x5c503781
    /// @custom:signature   Unresolved_5c503781(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_5c503781(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        store_e = msg.data[0x04 + arg0];
        store_f = msg.data[0x04 + arg0 + 0x20];
        store_g = msg.data[0x04 + arg0 + 0x40];
        store_h = msg.data[0x04 + arg0 + 0x60];
        require(msg.data[0x04 + arg0 + 0x80] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x80]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x80]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x80]]);
        if (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x80]] <= 0xffffffffffffffff && (store_d >> 0x01 < 0x20 != (store_d & 0x01) && 0x01 == (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x80]] > 0x1f))) {
            store_r = msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x80])] & ~(type(uint256).max >> (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x80]] << 0x03 & 0xf8));
            store_d = (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x80]] << 0x01) + 0x01;
            require(msg.data[0x04 + arg0 + 0x80] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[msg.data[0x04 + arg0 + 0x80] + (0x04 + arg0)] <= 0xffffffffffffffff);
            require(msg.data[0x04 + arg0 + 0x80] + (0x04 + arg0) + 0x20 <= msg.data.length - msg.data[msg.data[0x04 + arg0 + 0x80] + (0x04 + arg0)]);
            emit Event_1a2d9eef(0x20, store_e, store_f, store_g, store_h, 0xa0, msg.data[msg.data[0x04 + arg0 + 0x80] + (0x04 + arg0)]);
        }
    }
    
    /// @custom:selector    0x6223a887
    /// @custom:signature   Unresolved_6223a887(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10) public pure returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    function Unresolved_6223a887(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10) public pure returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - arg0 + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0160);
        require(0x03 > msg.data[0x04 + arg0 + 0x40]);
        if (0x03 > msg.data[0x04 + arg0 + 0x40]) {
            require(!(address(msg.data[0x04 + arg0 + 0x80]) - msg.data[0x04 + arg0 + 0x80]));
            require(msg.data[0x04 + arg0 + 0x0140] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0)] <= 0xffffffffffffffff);
            require(msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20 <= msg.data.length - (msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0)] << 0x05));
            uint256 var_o = msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0)];
            if (0 < msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0)]) {
                require(msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] < msg.data.length - (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff81);
                require(msg.data[msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20)] < msg.data.length - (msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20)) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc1);
                if (0 >= 0x02) {
                    require(msg.data[msg.data[msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20)] + (msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20))] < msg.data.length - (msg.data[msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20)] + (msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20))) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                    require(msg.data[msg.data[msg.data[msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20)] + (msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20))] + (msg.data[msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20)] + (msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20)))] <= 0xffffffffffffffff);
                    require(msg.data[msg.data[msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20)] + (msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20))] + (msg.data[msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20)] + (msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20))) + 0x20 > msg.data.length - msg.data[msg.data[msg.data[msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20)] + (msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20))] + (msg.data[msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20)] + (msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20] + (msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0) + 0x20)))]);
                }
            } else {
                if (!(var_q + (var_q + 0x01a0 + (msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0)] << 0x05) + 0x20 - var_q + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_q + (var_q + 0x01a0 + (msg.data[msg.data[0x04 + arg0 + 0x0140] + (0x04 + arg0)] << 0x05) + 0x20 - var_q + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_q)) {
                    uint256 var_q = var_q + (var_q + 0x01a0 + (var_o << 0x05) + 0x20 - var_q + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                    uint256 var_p = keccak256(memory[var_q + 0x20:var_q + 0x20 + var_t]) % 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001;
                    return var_p;
                }
            }
        }
    }
    
    /// @custom:selector    0x642e9abb
    /// @custom:signature   Unresolved_642e9abb(address arg0, uint256 arg1, address arg2) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_642e9abb(address arg0, uint256 arg1, address arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(!(arg0 - arg0));
        require(arg1 <= 0xffffffffffffffff);
        require(!(arg2 - arg2));
        if (store_s && 0x01 == store_s) {
            require(store_s, CustomError_f92ee8a9());
            require(!address(this).code.length, CustomError_f92ee8a9());
            store_t = store_t & 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000 | 0x01;
            require(arg0, "Whitelist is zero");
            require(arg2, "Owner is zero");
            require(store_u, CustomError_d7e6bcf8());
            if (!store_u) {
                revert CustomError_d7e6bcf8();
            } else {
                revert CustomError_1e4fbdf7();
            }
        }
    }
    
    /// @custom:selector    0x6c950930
    /// @custom:signature   Unresolved_6c950930(uint256 arg0, uint256 arg1, uint256 arg2) public pure returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_6c950930(uint256 arg0, uint256 arg1, uint256 arg2) public pure returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xa0);
        if (arg0 >= 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001) {
            if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                return abi.encodePacked(0, 0x40, var_i);
            }
        } else {
            require(0x03 > arg1);
        }
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public payable
    function Unresolved_715018a6() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        store_v = store_v & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
    }
    
    /// @custom:selector    0x92d3c7a4
    /// @custom:signature   Unresolved_92d3c7a4(uint256 arg0, address arg1, uint256 arg2) public pure returns (address)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_92d3c7a4(uint256 arg0, address arg1, uint256 arg2) public pure returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        if (!(var_a + 0x60 > 0xffffffffffffffff | var_a + 0x60 < var_a)) {
            uint256 var_a = var_a + 0x60;
            require(0x03 > arg0);
            require(!(arg1 - arg1));
            if (0x03 > var_g && 0x03 > var_g) {
                if (!var_g) {
                    return address(var_i);
                } else {
                    if (0x03 > var_g && !(var_a + 0x80 > 0xffffffffffffffff | var_a + 0x80 < var_a)) {
                        uint256 var_a = var_a + 0x80;
                        uint256 var_o = keccak256(memory[var_a + 0x20:var_a + 0x20 + var_g]) % 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001;
                        return var_o;
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xa495f6a1
    /// @custom:signature   Unresolved_a495f6a1(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    function Unresolved_a495f6a1(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public pure {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
        if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
            require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0 + 0x20) + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffde1);
            require(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160] < msg.data.length - (0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]) + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffea1);
            require(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160] + 0x0140] < msg.data.length - (0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160]) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160] + 0x0140]] <= 0xffffffffffffffff);
            require(0x20 + (0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160] + 0x0140]) <= msg.data.length - (msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x0160] + 0x0140]] << 0x05));
        }
    }
    
    /// @custom:selector    0xda1c693a
    /// @custom:signature   Unresolved_da1c693a(uint256 arg0, uint256 arg1, address arg2, uint256 arg3) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    function Unresolved_da1c693a(uint256 arg0, uint256 arg1, address arg2, uint256 arg3) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - arg0 + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0220);
        require(msg.data[0x04 + arg0 + 0x0160] < msg.data.length - (0x04 + arg0) + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffea1);
        if (tx.gasprice < msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x20]) {
            if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                uint256 var_a = var_a + 0x40;
                return abi.encodePacked(0, 0x40, var_i);
            }
        } else {
            require(msg.data[0x04 + arg0 + 0x0160] < msg.data.length - (0x04 + arg0) + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffea1);
            require(!(address(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x80]) - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x80]));
            if (!(var_a + 0x40 > 0xffffffffffffffff | var_a + 0x40 < var_a)) {
                return abi.encodePacked(0, 0x40, var_i);
            }
        }
    }
    
    /// @custom:selector    0xf0cbdaa1
    /// @custom:signature   Unresolved_f0cbdaa1(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    function Unresolved_f0cbdaa1(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11) public pure {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - arg0 + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0220);
        require(msg.data[0x04 + arg0 + 0x0120] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]] << 0x05));
        require(msg.data[0x04 + arg0 + 0x0140] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]] << 0x05));
        if (0x06 <= 0x06 + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]] && (0x06 + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]] <= 0x06 + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]] + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]] && (0x06 + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]] + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]] <= 0xffffffffffffffff && !(var_c + (0x20 + (0x06 + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]] + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0x06 + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]] + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)))) {
            uint256 var_c = var_c + (0x20 + (var_d << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_d = 0x06 + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]] + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]];
            if (0x06 + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0120]] + msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0140]] <= 0xffffffffffffffff && var_f) {
                require(msg.data[0x04 + arg0 + 0x0160] < msg.data.length - (0x04 + arg0) + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffea1);
                require(0x03 > msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x40]);
                if (0x03 > msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x40]) {
                    require(!(address(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x80]) - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x80]));
                    require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] < msg.data.length - (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160]) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                    require(msg.data[msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160])] <= 0xffffffffffffffff);
                    require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160]) + 0x20 <= msg.data.length - (msg.data[msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160])] << 0x05));
                    uint256 var_t = msg.data[msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160])];
                    if (0 >= msg.data[msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160])]) {
                        require(msg.data[msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160]) + 0x20] < msg.data.length - (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160]) + 0x20) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff81);
                        require(msg.data[msg.data[msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160]) + 0x20] + (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160]) + 0x20)] < msg.data.length - (msg.data[msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160]) + 0x20] + (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160]) + 0x20)) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc1);
                        if (0 >= 0x02) {
                            require(msg.data[msg.data[msg.data[msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160]) + 0x20] + (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160]) + 0x20)] + (msg.data[msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160]) + 0x20] + (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160]) + 0x20))] >= msg.data.length - (msg.data[msg.data[msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160]) + 0x20] + (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160]) + 0x20)] + (msg.data[msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160]) + 0x20] + (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160] + 0x0140] + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x0160]) + 0x20))) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg0, CustomError_1e4fbdf7());
        store_v = store_v & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
    }
    
    /// @custom:selector    0xe8295588
    /// @custom:signature   zeros(uint256 arg0) public view returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function zeros(uint256 arg0) public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 < 0x10);
        return store_x;
    }
}