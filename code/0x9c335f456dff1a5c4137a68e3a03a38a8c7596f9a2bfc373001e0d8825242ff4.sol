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
    uint256 public constant ENTRY_POINT_ADDRESS = 547733466371960611141041528242004465362790066057;
    uint256 public constant PAYMASTER = 1414295881182912268815479900574783046082535087300;
    uint256 public constant unresolved_354d2a25 = 104102169274225527910296982925513390792925418392;
    
    address public getVerifyingSigner; // storage slot: 0x04
    bytes32 store_e; // storage slot: 0x04
    address public unresolved_8da5cb5b; // storage slot: 0x9016d09d72d40fdae2fd8ceac6b6234c7706214fd39c1cd1e609a0528c199300
    bytes32 store_m; // storage slot: 0x9016d09d72d40fdae2fd8ceac6b6234c7706214fd39c1cd1e609a0528c199300
    uint256 store_f; // storage slot: 0x9b779b17422d0df92223018b32b4d1fa46e071723d6817e2486d003becc55f00
    bytes32 store_n; // storage slot: 0xa16a46d94261c7517cc8ff89f61c0ce93598e3c849801011dee649a6a557d100
    uint256 store_l; // storage slot: 0xa16a46d94261c7517cc8ff89f61c0ce93598e3c849801011dee649a6a557d102
    bytes32 store_o; // storage slot: 0xa16a46d94261c7517cc8ff89f61c0ce93598e3c849801011dee649a6a557d103
    bytes32 store_d; // storage slot: 0xcd5ed15c6e187e77e9aee88184c21f4f2182ab5827cb3b7e07fbedcd63f03300
    uint8 store_c; // storage slot: 0xcd5ed15c6e187e77e9aee88184c21f4f2182ab5827cb3b7e07fbedcd63f03300
    bytes32 store_j; // storage slot: 0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00
    uint64 store_i; // storage slot: 0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00
    uint8 store_k; // storage slot: 0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00
    
    mapping(bytes32 => bytes32) storage_map_h; // storage slot: 0x00
    mapping(uint256 => uint8) storage_map_p; // storage slot: 0x01
    mapping(uint256 => uint8) storage_map_q; // storage slot: 0x02
    mapping(bytes32 => uint8) storage_map_g; // storage slot: 0x03
    
    error CustomError_00000000();
    event Event_001a143d();
    event Event_268b09da();
    event Event_5db9ee0a();
    event Event_62e78cea();
    event Event_8be0079c();
    
    /// @custom:selector    0x37a66d85
    /// @custom:signature   setPaused() public payable
    function setPaused() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(!store_c, CustomError_d93c0665());
        store_d = store_d & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
        emit Event_62e78cea(msg.sender);
    }
    
    /// @custom:selector    0x3c89edce
    /// @custom:signature   setUnpaused() public payable
    function setUnpaused() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(store_c, CustomError_8dfc202b());
        store_d = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & store_d;
        emit Event_5db9ee0a(msg.sender);
    }
    
    /// @custom:selector    0x05b1737e
    /// @custom:signature   Unresolved_05b1737e(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_05b1737e(address arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg0, "LiquidityBank: invalid verifying signer");
        store_e = store_e & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        emit Event_268b09da(getVerifyingSigner, arg0);
    }
    
    /// @custom:selector    0x101916e0
    /// @custom:signature   Unresolved_101916e0(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_101916e0(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - arg0 + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x80);
        require(store_f != 0x02, CustomError_3ee5aeb5());
        store_f = 0x02;
        require(!store_c, CustomError_d93c0665());
        require(!storage_map_g[msg.data[0x04 + arg0]].field_0, "Order locked");
        require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] << 0x06));
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]], "Order token info required");
        require(!storage_map_h[msg.data[0x04 + arg0]], "Order already processed");
        require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] << 0x06));
        if (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] <= 0xffffffffffffffff && !(var_h + (0x20 + (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_h + (0x20 + (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_h)) {
            uint256 var_h = var_h + (0x20 + (0x08c379a000000000000000000000000000000000000000000000000000000000 << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_a = msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]];
            if (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] <= 0xffffffffffffffff) {
                require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] <= 0xffffffffffffffff);
                require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] << 0x06));
                if (0 < msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]]) {
                    require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                    require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] <= 0xffffffffffffffff);
                    require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] << 0x06));
                    if (0 < msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]]) {
                        require(!(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x20])] - address(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x20])])));
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x485cc955
    /// @custom:signature   Unresolved_485cc955(address arg0, address arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_485cc955(address arg0, address arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        if (store_i && 0x01 == store_i) {
            require(store_i, CustomError_f92ee8a9());
            require(!address(this).code.length, CustomError_f92ee8a9());
            store_j = store_j & 0xffffffffffffffffffffffffffffffffffffffffffffffff0000000000000000 | 0x01;
            require(arg0, "LiquidityBank: invalid owner");
            require(arg1, "LiquidityBank: invalid verifying signer");
            if (!(var_f + 0x40 > 0xffffffffffffffff | var_f + 0x40 < var_f)) {
                uint256 var_f = var_f + 0x40;
                if (!(var_f + 0x40 > 0xffffffffffffffff | var_f + 0x40 < var_f)) {
                    require(store_k, CustomError_d7e6bcf8());
                    require(store_k, CustomError_d7e6bcf8());
                    if (var_m <= 0xffffffffffffffff && (store_l >> 0x01 < 0x20 != (store_l & 0x01) && 0x01 == (var_m > 0x1f))) {
                        store_l = (var_m << 0x01) + 0x01;
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x5c975abb
    /// @custom:signature   Unresolved_5c975abb() public view returns (bool)
    function Unresolved_5c975abb() public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_c;
    }
    
    /// @custom:selector    0x65bd4f0e
    /// @custom:signature   Unresolved_65bd4f0e(uint256 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_65bd4f0e(uint256 arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        var_c = storage_map_g[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public payable
    function Unresolved_715018a6() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        store_m = store_m & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
    }
    
    /// @custom:selector    0x84b0196e
    /// @custom:signature   Unresolved_84b0196e() public view
    function Unresolved_84b0196e() public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!store_n, "EIP712: Uninitialized");
        if (store_l >> 0x01 < 0x20 != (store_l & 0x01) && !(var_g + (0x20 + var_g - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_g + (0x20 + var_g - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_g)) {
            uint256 var_g = var_g + (0x20 + var_g - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            if (store_o >> 0x01 < 0x20 != (store_o & 0x01) && (0x01 == (store_o & 0x01) && !(var_g + (0x20 + var_g - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_g + (0x20 + var_g - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_g))) {
                uint256 var_g = var_g + (0x20 + var_g - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            }
        }
    }
    
    /// @custom:selector    0x863d51c9
    /// @custom:signature   Unresolved_863d51c9(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_863d51c9(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - arg0 + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xc0);
        require(store_f != 0x02, CustomError_3ee5aeb5());
        store_f = 0x02;
        require(!store_c, CustomError_d93c0665());
        if (tx.origin != 0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789) {
            (bool success, bytes memory ret0) = address(0xf7bb387ecdea4b8ffff53e6b1a8cd9f93bfbdcc4).Unresolved_4da29415(tx.origin); // staticcall
            require(success);
        } else {
            require(tx.origin == 0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789, "Origin not whitelisted");
            require(!storage_map_g[msg.data[0x04 + arg0]].field_0, "Order locked");
            require(msg.data[arg0 + 0x24] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[0x04 + arg0 + msg.data[arg0 + 0x24]] <= 0xffffffffffffffff);
            require(0x20 + (0x04 + arg0 + msg.data[arg0 + 0x24]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[arg0 + 0x24]] << 0x06));
            require(msg.data[0x04 + arg0 + msg.data[arg0 + 0x24]], "Order not found in deposit records");
            require(msg.data[arg0 + 0x24] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[0x04 + arg0 + msg.data[arg0 + 0x24]] <= 0xffffffffffffffff);
            require(0x20 + (0x04 + arg0 + msg.data[arg0 + 0x24]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[arg0 + 0x24]] << 0x06));
            if (msg.data[0x04 + arg0 + msg.data[arg0 + 0x24]] <= 0xffffffffffffffff && !(var_i + (0x20 + (msg.data[0x04 + arg0 + msg.data[arg0 + 0x24]] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_i + (0x20 + (msg.data[0x04 + arg0 + msg.data[arg0 + 0x24]] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_i)) {
                uint256 var_i = var_i + (0x20 + (0x08c379a000000000000000000000000000000000000000000000000000000000 << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                uint256 var_a = msg.data[0x04 + arg0 + msg.data[arg0 + 0x24]];
                if (msg.data[0x04 + arg0 + msg.data[arg0 + 0x24]] <= 0xffffffffffffffff) {
                    require(msg.data[arg0 + 0x24] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                    require(msg.data[0x04 + arg0 + msg.data[arg0 + 0x24]] <= 0xffffffffffffffff);
                    require(0x20 + (0x04 + arg0 + msg.data[arg0 + 0x24]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[arg0 + 0x24]] << 0x06));
                    if (0 < msg.data[0x04 + arg0 + msg.data[arg0 + 0x24]]) {
                        require(msg.data[arg0 + 0x24] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                        require(msg.data[0x04 + arg0 + msg.data[arg0 + 0x24]] <= 0xffffffffffffffff);
                        require(0x20 + (0x04 + arg0 + msg.data[arg0 + 0x24]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[arg0 + 0x24]] << 0x06));
                        if (0 < msg.data[0x04 + arg0 + msg.data[arg0 + 0x24]]) {
                            require(!(msg.data[0x20 + (0x04 + arg0 + msg.data[arg0 + 0x24])] - address(msg.data[0x20 + (0x04 + arg0 + msg.data[arg0 + 0x24])])));
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xa0897609
    /// @custom:signature   Unresolved_a0897609(uint256 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_a0897609(uint256 arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        if (storage_map_p[arg0].field_0 < 0x02) {
            var_d = storage_map_p[arg0].field_0;
            return var_d;
        }
    }
    
    /// @custom:selector    0xb460af94
    /// @custom:signature   Unresolved_b460af94(uint256 arg0, address arg1, address arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_b460af94(uint256 arg0, address arg1, address arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(!(arg1 - arg1));
        require(!(arg2 - arg2));
        require(store_f != 0x02, CustomError_3ee5aeb5());
        store_f = 0x02;
        require(!(msg.sender - 0xdf51b03712c9b398de18dfb4c60c9e1bbcaa2e0e), "failed");
        require(arg0, "Withdraw amount must be greater than zero");
        require(arg2, "Withdraw address cannot be zero");
        if (!(var_g + 0x80 > 0xffffffffffffffff | var_g + 0x80 < var_g)) {
            uint256 var_g = var_g + 0x80;
            (bool success, bytes memory ret0) = address(arg1).Unresolved_a9059cbb{ value: 0 }(arg2); // call
            if (!ret0.length) {
                if (success) {
                    require(var_j, CustomError_9996b315());
                    require(var_j, CustomError_9996b315());
                    require(0x60 + var_j + 0x20 - 0x80 >= 0x20);
                    require(!(0x44 - 0x44));
                    require(0x44, CustomError_5274afe7());
                    emit Event_001a143d(arg2, arg0, arg1);
                    store_f = 0x01;
                } else {
                    require(var_j, CustomError_1425ea42());
                }
            } else {
                if (ret0.length <= 0xffffffffffffffff && !(var_g + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_g + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_g)) {
                    if (success) {
                        require(arg1.code.length, CustomError_9996b315());
                        require(!var_p, CustomError_5274afe7());
                        emit Event_001a143d(arg2, arg0, arg1);
                        store_f = 0x01;
                    } else {
                        require(var_p, CustomError_1425ea42());
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xb695c935
    /// @custom:signature   Unresolved_b695c935(uint256 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_b695c935(uint256 arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        if (storage_map_q[arg0].field_0 < 0x02) {
            var_d = storage_map_q[arg0].field_0;
            return var_d;
        }
    }
    
    /// @custom:selector    0xc617b667
    /// @custom:signature   Unresolved_c617b667(uint256 arg0, address arg1, uint256 arg2, uint256 arg3) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_c617b667(uint256 arg0, address arg1, uint256 arg2, uint256 arg3) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length - arg0 + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x80);
        require(store_f != 0x02, CustomError_3ee5aeb5());
        store_f = 0x02;
        require(!store_c, CustomError_d93c0665());
        if (tx.origin != 0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789) {
            (bool success, bytes memory ret0) = address(0xf7bb387ecdea4b8ffff53e6b1a8cd9f93bfbdcc4).Unresolved_4da29415(tx.origin); // staticcall
            require(success);
        } else {
            require(tx.origin == 0x5ff137d4b0fdcd49dca30c7cf57e578a026d2789, "Origin not whitelisted");
            require(!(msg.sender - 0x123c1a4bb9b9fa77fff949555a587043295a9398), "Invalid refund sender");
            require(!storage_map_g[msg.data[0x04 + arg0]].field_0, "Order locked");
            require(!(msg.data[0x04 + arg0 + 0x20] - address(msg.data[0x04 + arg0 + 0x20])));
            if (!(var_k + 0xa0 > 0xffffffffffffffff | var_k + 0xa0 < var_k)) {
                uint256 var_k = var_k + 0xa0;
                if (store_l >> 0x01 < 0x20 != (store_l & 0x01) && !(var_k + (0x20 + var_k - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_k + (0x20 + var_k - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_k)) {
                    uint256 var_k = var_k + (0x20 + var_k - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                    if (var_n && (store_o >> 0x01 < 0x20 != (store_o & 0x01) && (0x01 == (store_o & 0x01) && !(var_k + (0x20 + var_k - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_k + (0x20 + var_k - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_k)))) {
                        uint256 var_k = var_k + (0x20 + var_k - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                        if (var_n && !(var_k + 0xc0 > 0xffffffffffffffff | var_k + 0xc0 < var_k)) {
                            uint256 var_k = var_k + 0xc0;
                            require(msg.data[0x04 + arg0 + 0x60] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                            require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] <= 0xffffffffffffffff);
                            require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]]);
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xf1db4763
    /// @custom:signature   Unresolved_f1db4763(uint256 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_f1db4763(uint256 arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        var_c = storage_map_g[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg0, CustomError_1e4fbdf7());
        store_m = store_m & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
    }
}