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
    uint256 public constant endpoint = 149950853274462145569822531066857990848566424204;
    uint256 public constant ENDPOINT_ID = 30101;
    uint256 public constant MAX_FILLS_PER_SETTLE = 100;
    bytes public constant oAppVersion = 00000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000002;
    bytes public constant unresolved_84b0196e = 0f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000e0000000000000000000000000000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001600000000000000000000000000000000000000000000000000000000000000004416f7269000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005302e332e300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000;
    
    address public unresolved_8da5cb5b; // storage slot: 0x00
    address store_n; // storage slot: 0x00
    uint256 store_k; // storage slot: 0x02
    bytes32 store_m; // storage slot: 0x03
    uint8 store_j; // storage slot: 0x03
    uint256 store_l; // storage slot: keccak256(keccak256(address(arg1), keccak256(uint32(arg0), 0x0a))) + storage_map_i[uint32(arg0)][address(arg1)] + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
    
    mapping(uint32 => uint256) public peers; // storage slot: 0x01
    mapping(address => mapping(address => bytes32)) storage_map_g; // storage slot: 0x04
    mapping(uint256 => bytes32) storage_map_f; // storage slot: 0x05
    mapping(uint32 => bytes) storage_map_d; // storage slot: 0x06
    mapping(uint256 => bytes32) storage_map_e; // storage slot: 0x07
    mapping(address => bytes32) storage_map_b; // storage slot: 0x08
    mapping(address => bytes32) storage_map_c; // storage slot: 0x09
    mapping(uint32 => mapping(address => bytes32)) storage_map_i; // storage slot: 0x0a
    
    error NoPeer(uint32);
    event ChainRemoved(uint32);
    event ChainSupported(uint32);
    event Event_5db9ee0a();
    event Event_62e78cea();
    event Event_8be0079c();
    event PeerSet(uint32, bytes32);
    event Withdraw(address, address, uint256);
    
    /// @custom:selector    0xedb25d81
    /// @custom:signature   addAllowedHook(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function addAllowedHook(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        storage_map_b[arg0] = storage_map_b[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
        return ;
    }
    
    /// @custom:selector    0x595490c8
    /// @custom:signature   addAllowedSolver(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function addAllowedSolver(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        storage_map_c[arg0] = storage_map_c[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
        return ;
    }
    
    /// @custom:selector    0x50964586
    /// @custom:signature   addSupportedChain(uint32 arg0) public payable
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function addSupportedChain(uint32 arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        storage_map_d[arg0] = storage_map_d[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
        emit ChainSupported(arg0);
    }
    
    /// @custom:selector    0x45ef118f
    /// @custom:signature   emergencyCancel(bytes32 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function emergencyCancel(bytes32 arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        if (0x05 > storage_map_e[arg0].field_0) {
            require(storage_map_e[arg0].field_0 == 0x01, "Can only cancel active orders");
            if (!(var_h + 0x0140 > 0xffffffffffffffff | var_h + 0x0140 < var_h)) {
                uint256 var_h = var_h + 0x0140;
                (bool success, bytes memory ret0) = address(address(var_t)).Unresolved_70a08231(address(this)); // staticcall
                require(success);
                if (success) {
                    if (!(var_h + 0x20 > 0xffffffffffffffff | var_h + 0x20 < var_h)) {
                        uint256 var_h = var_h + 0x20;
                        require(var_h + 0x20 - var_h < 0x20);
                    }
                } else {
                    require(0 >= uint128(var_u), "Insufficient contract balance");
                    storage_map_e[arg0] = storage_map_e[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x03;
                    address var_a = address(var_t);
                    if (uint128(storage_map_g[address(var_x)][address(var_t)].field_0 - uint128(var_u)) <= storage_map_g[address(var_x)][address(var_t)].field_0) {
                        storage_map_g[address(var_x)][var_a] = storage_map_g[address(var_x)][var_a] & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 | uint128(storage_map_g[address(var_x)][var_a].field_0 - uint128(var_u));
                    }
                    revert("Failed to decrease locked balance");
                }
            }
        }
    }
    
    /// @custom:selector    0x95ccea67
    /// @custom:signature   emergencyWithdraw(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function emergencyWithdraw(address arg0, uint256 arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        if (address(this).balance) {
            payable(address(unresolved_8da5cb5b)).transfer(address(this).balance);
            require(ret0.length, "Ether withdrawal failed");
        } else {
            if (arg1 && !(var_h + 0x80 > 0xffffffffffffffff | var_h + 0x80 < var_h)) {
                (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb{ value: 0 }(unresolved_8da5cb5b); // call
                require(success);
                if (ret0.length) {
                    require(0x01 == 0x4e487b7100000000000000000000000000000000000000000000000000000000, CustomError_5274afe7());
                } else {
                    require(arg0.code.length, CustomError_5274afe7());
                }
            }
        }
    }
    
    /// @custom:selector    0x05ef94ba
    /// @custom:signature   getLockedBalances(address arg0, address arg1) public view returns (address)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function getLockedBalances(address arg0, address arg1) public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        var_c = storage_map_g[arg0][arg1].field_0;
        return var_c;
    }
    
    /// @custom:selector    0xe86dfbbf
    /// @custom:signature   getUnlockedBalances(address arg0, address arg1) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function getUnlockedBalances(address arg0, address arg1) public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        bytes32 var_c = storage_map_g[arg0][arg1] >> 0x80;
        return var_c;
    }
    
    /// @custom:selector    0x344ba6fd
    /// @custom:signature   isAllowedHook(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isAllowedHook(address arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_b[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x7de63734
    /// @custom:signature   isAllowedSolver(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isAllowedSolver(address arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_c[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x59f429a4
    /// @custom:signature   isSupportedChain(uint32 arg0) public view returns (bool)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function isSupportedChain(uint32 arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_d[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x9c3f1e90
    /// @custom:signature   orders(bytes32 arg0) public view returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function orders(bytes32 arg0) public view returns (bytes memory) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        var_c = storage_map_f[arg0].field_0.field_0;
        var_d = storage_map_f[arg0].field_128;
        var_e = storage_map_f[arg0].field_1.field_0.field_0;
        var_f = storage_map_f[arg0].field_2.field_0.field_0;
        var_g = storage_map_f[arg0].field_2.field_160.field_0;
        var_h = storage_map_f[arg0].field_2.field_192.field_0;
        var_i = storage_map_f[arg0].field_2.field_224;
        var_j = storage_map_f[arg0].field_3.field_0.field_0;
        var_k = storage_map_f[arg0].field_3.field_32.field_0;
        var_l = storage_map_f[arg0].field_4.field_0.field_0;
        return abi.encodePacked(var_c, var_d, var_e, var_f, var_g, var_h, var_i, var_j, var_k, var_l);
    }
    
    /// @custom:selector    0x2dff692d
    /// @custom:signature   orderStatus(bytes32 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function orderStatus(bytes32 arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        if (storage_map_e[arg0].field_0 < 0x05) {
            var_d = storage_map_e[arg0].field_0;
            return var_d;
        }
    }
    
    /// @custom:selector    0x6b624fdb
    /// @custom:signature   removeAllowedHook(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function removeAllowedHook(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        storage_map_b[arg0] = storage_map_b[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        return ;
    }
    
    /// @custom:selector    0x1e2c273e
    /// @custom:signature   removeAllowedSolver(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function removeAllowedSolver(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        storage_map_c[arg0] = storage_map_c[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        return ;
    }
    
    /// @custom:selector    0xc15c4b37
    /// @custom:signature   removeSupportedChain(uint32 arg0) public payable
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function removeSupportedChain(uint32 arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        storage_map_d[arg0] = storage_map_d[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        emit ChainRemoved(arg0);
    }
    
    /// @custom:selector    0xca5eb5e1
    /// @custom:signature   setDelegate(address arg0) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setDelegate(address arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(address(0x1a44076050125825900e736c501f859c50fe728c).code.length);
        (bool success, bytes memory ret0) = address(0x1a44076050125825900e736c501f859c50fe728c).Unresolved_ca5eb5e1{ value: 0 }(arg0); // call
        require(success);
        if (success) {
            if (!(var_e > 0xffffffffffffffff | var_e < var_e)) {
                return ;
            }
        } else {
            return ;
        }
    }
    
    /// @custom:selector    0x3400288b
    /// @custom:signature   setPeer(uint32 arg0, bytes32 arg1) public payable
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function setPeer(uint32 arg0, bytes32 arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        peers[var_d] = arg1;
        emit PeerSet(arg0, arg1);
    }
    
    /// @custom:selector    0x0c89a13d
    /// @custom:signature   srcEidToFillerFills(uint32 arg0, address arg1, uint256 arg2) public view returns (uint256)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function srcEidToFillerFills(uint32 arg0, address arg1, uint256 arg2) public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        var_b = keccak256(arg0, 0x0a);
        require(arg2 < storage_map_i[arg0][arg1]);
        if (arg2 < storage_map_i[arg0][arg1]) {
            var_d = storage_map_i[arg0][arg1][arg2];
            return var_d;
        }
    }
    
    /// @custom:selector    0x13137d65
    /// @custom:signature   Unresolved_13137d65(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    function Unresolved_13137d65(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4, uint256 arg5) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xe0);
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(arg4 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg4] <= 0xffffffffffffffff);
        require(!(arg5 - arg5));
        require(arg6 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg6] <= 0xffffffffffffffff);
        require(!(0x1a44076050125825900e736c501f859c50fe728c - msg.sender), CustomError_91ac5e4f());
        require(!(uint32(arg0) - arg0));
        require(peers[uint32(arg0)], CustomError_f6ff4fb7());
        if (peers[uint32(arg0)] - arg1) {
            require(uint32(arg0) - arg0, CustomError_c26bebcc());
        } else {
            if (store_j) {
                revert CustomError_d93c0665();
            } else {
                revert("Empty payload");
            }
        }
    }
    
    /// @custom:selector    0x2c85455b
    /// @custom:signature   Unresolved_2c85455b(uint32 arg0, address arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_2c85455b(uint32 arg0, address arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        require(store_k != 0x02, CustomError_3ee5aeb5());
        store_k = 0x02;
        require(!store_j, CustomError_d93c0665());
        require(storage_map_c[msg.sender].field_0, "Invalid solver");
        var_b = keccak256(arg0, 0x0a);
        require(storage_map_i[arg0][arg1], "No orders provided");
        if (0x0c97 <= 0xffffffff && (0x0c97 <= 0xffffffffffffffff && (!(var_h + 0x0cc0 > 0xffffffffffffffff | var_h + 0x0cc0 < var_h) && 0x0c97 <= 0xffffffffffffffff))) {
            store_l = 0;
        }
    }
    
    /// @custom:selector    0x2d7c615a
    /// @custom:signature   Unresolved_2d7c615a(address arg0, address arg1, address arg2, uint256 arg3, address arg4) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint128", "bytes16", "int128"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_2d7c615a(address arg0, address arg1, address arg2, uint256 arg3, address arg4) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xa0);
        require(!(arg0 - arg0));
        require(!(arg2 - arg2));
        require(!(arg3 - arg3));
        require(!(arg4 - arg4));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg1, "Amount must be greater than zero");
        require(arg2, "Invalid user address");
        require(arg4, "Invalid recipient address");
        if (!arg3) {
            require(storage_map_g[arg2][arg0].field_128 >= arg1, "Insufficient unlocked balance");
        } else {
            require(storage_map_g[arg2][arg0].field_0.field_0 >= arg1, "Insufficient locked balance");
            if (uint128(storage_map_g[arg2][arg0].field_0 - uint128(arg1)) > storage_map_g[arg2][arg0].field_0) {
                require(0, "Failed to decrease locked balance");
                if (!(var_j + 0x80 > 0xffffffffffffffff | var_j + 0x80 < var_j)) {
                    (bool success, bytes memory ret0) = address(0x4e487b7100000000000000000000000000000000000000000000000000000000).Unresolved_a9059cbb{ value: 0 }(arg4); // call
                    require(success);
                    if (ret0.length) {
                        require(0x01 == 0x4e487b7100000000000000000000000000000000000000000000000000000000, CustomError_5274afe7());
                    } else {
                        require(arg0.code.length, CustomError_5274afe7());
                    }
                    emit Withdraw(arg2, 0x5274afe700000000000000000000000000000000000000000000000000000000, arg1);
                }
            } else {
                storage_map_g[arg2][0x5274afe700000000000000000000000000000000000000000000000000000000] = storage_map_g[arg2][0x5274afe700000000000000000000000000000000000000000000000000000000] & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 | uint128(storage_map_g[arg2][0x5274afe700000000000000000000000000000000000000000000000000000000].field_0 - uint128(arg1));
                revert("Failed to decrease locked balance");
            }
        }
    }
    
    /// @custom:selector    0x3f4ba83a
    /// @custom:signature   Unresolved_3f4ba83a() public payable
    function Unresolved_3f4ba83a() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(store_j, CustomError_8dfc202b());
        store_m = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & store_m;
        emit Event_5db9ee0a(msg.sender);
    }
    
    /// @custom:selector    0x555c3898
    /// @custom:signature   Unresolved_555c3898(uint256 arg0, address arg1, address arg2, address arg3, uint32 arg4, uint32 arg5, uint32 arg6, uint32 arg7, address arg8, uint256 arg9, uint256 arg10) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint128", "bytes16", "int128"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["uint32", "bytes4", "int32"]
    /// @param              arg5 ["uint32", "bytes4", "int32"]
    /// @param              arg6 ["uint32", "bytes4", "int32"]
    /// @param              arg7 ["uint32", "bytes4", "int32"]
    /// @param              arg8 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    function Unresolved_555c3898(uint256 arg0, address arg1, address arg2, address arg3, uint32 arg4, uint32 arg5, uint32 arg6, uint32 arg7, address arg8, uint256 arg9, uint256 arg10) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0180);
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0140);
        require(arg10 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg10] <= 0xffffffffffffffff);
        require(arg11 <= 0xffffffffffffffff);
        require(store_k != 0x02, CustomError_3ee5aeb5());
        store_k = 0x02;
        require(!store_j, CustomError_d93c0665());
        require(storage_map_c[msg.sender].field_0, "Invalid solver");
        require(!(address(msg.data[0x04 + arg11]) - msg.data[0x04 + arg11]));
        require(address(msg.data[0x04 + arg11]), "Missing hook");
        require(!(uint128(arg0) - arg0));
        require(!(uint128(arg1) - arg1));
        require(!(arg2 - arg2));
        require(!(arg3 - arg3));
        require(!(arg4 - arg4));
        require(!(arg5 - arg5));
        require(!(arg6 - arg6));
        require(!(arg7 - arg7));
        require(arg8 - arg8);
    }
    
    /// @custom:selector    0x5c975abb
    /// @custom:signature   Unresolved_5c975abb() public view returns (bool)
    function Unresolved_5c975abb() public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_j;
    }
    
    /// @custom:selector    0x6d551032
    /// @custom:signature   Unresolved_6d551032(uint256 arg0, uint32 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint32", "bytes4", "int32"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    function Unresolved_6d551032(uint256 arg0, uint32 arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0160);
        require(0x0140 <= msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc);
        require(arg10 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg10] <= 0xffffffffffffffff);
        require(store_k != 0x02, CustomError_3ee5aeb5());
        store_k = 0x02;
        require(!store_j, CustomError_d93c0665());
        require(storage_map_c[msg.sender].field_0, "Invalid solver");
        require(arg6 - arg6);
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public payable
    function Unresolved_715018a6() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        store_n = store_n & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
    }
    
    /// @custom:selector    0x7ce5e33e
    /// @custom:signature   Unresolved_7ce5e33e(address arg0) public payable
    /// @param              arg8 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_7ce5e33e(address arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0140);
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0140);
        require(store_k != 0x02, CustomError_3ee5aeb5());
        store_k = 0x02;
        require(!store_j, CustomError_d93c0665());
        require(storage_map_c[msg.sender].field_0, "Invalid solver");
        require(arg8 - arg8, "Invalid offerer");
    }
    
    /// @custom:selector    0x7d25a05e
    /// @custom:signature   Unresolved_7d25a05e(uint32 arg0) public pure returns (uint256)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function Unresolved_7d25a05e(uint32 arg0) public pure returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        return 0;
    }
    
    /// @custom:selector    0x82413eac
    /// @custom:signature   Unresolved_82413eac(uint256 arg0, uint256 arg1, address arg2) public pure returns (address)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_82413eac(uint256 arg0, uint256 arg1, address arg2) public pure returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xa0);
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        require(!(arg4 - arg4));
        return arg4 == address(this);
    }
    
    /// @custom:selector    0x8456cb59
    /// @custom:signature   Unresolved_8456cb59() public payable
    function Unresolved_8456cb59() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(!store_j, CustomError_d93c0665());
        store_m = store_m & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
        emit Event_62e78cea(msg.sender);
    }
    
    /// @custom:selector    0x983f7fd1
    /// @custom:signature   Unresolved_983f7fd1(uint256 arg0, address arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint128", "bytes16", "int128"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    function Unresolved_983f7fd1(uint256 arg0, address arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0180);
        require(msg.data.length + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffdc >= 0x0140);
        require(arg11 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg11] <= 0xffffffffffffffff);
        require(store_k != 0x02, CustomError_3ee5aeb5());
        store_k = 0x02;
        require(!store_j, CustomError_d93c0665());
        require(uint128(arg1) - arg1);
    }
    
    /// @custom:selector    0x996628a0
    /// @custom:signature   Unresolved_996628a0(uint256 arg0, address arg1, address arg2, address arg3, uint32 arg4, uint32 arg5, uint32 arg6, uint32 arg7, address arg8, uint256 arg9) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint128", "bytes16", "int128"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["uint32", "bytes4", "int32"]
    /// @param              arg5 ["uint32", "bytes4", "int32"]
    /// @param              arg6 ["uint32", "bytes4", "int32"]
    /// @param              arg7 ["uint32", "bytes4", "int32"]
    /// @param              arg8 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    function Unresolved_996628a0(uint256 arg0, address arg1, address arg2, address arg3, uint32 arg4, uint32 arg5, uint32 arg6, uint32 arg7, address arg8, uint256 arg9) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0160);
        require(0x0140 <= msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc);
        require(arg10 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg10] <= 0xffffffffffffffff);
        require(store_k != 0x02, CustomError_3ee5aeb5());
        store_k = 0x02;
        require(!store_j, CustomError_d93c0665());
        require(storage_map_c[msg.sender].field_0, "Invalid solver");
        require(!(uint128(arg0) - arg0));
        require(!(uint128(arg1) - arg1));
        require(!(arg2 - arg2));
        require(!(arg3 - arg3));
        require(!(arg4 - arg4));
        require(!(arg5 - arg5));
        require(!(arg6 - arg6));
        require(!(arg7 - arg7));
        require(arg8 - arg8);
    }
    
    /// @custom:selector    0xa9a683ba
    /// @custom:signature   Unresolved_a9a683ba(uint32 arg0, uint256 arg1) public payable
    /// @param              arg6 ["uint32", "bytes4", "int32"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    function Unresolved_a9a683ba(uint32 arg0, uint256 arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0160);
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0140);
        require(arg10 <= 0xffffffffffffffff);
        require(store_k != 0x02, CustomError_3ee5aeb5());
        store_k = 0x02;
        require(!store_j, CustomError_d93c0665());
        require(storage_map_c[msg.sender].field_0, "Invalid solver");
        require(arg6 - arg6);
    }
    
    /// @custom:selector    0xb410f122
    /// @custom:signature   Unresolved_b410f122(address arg0) public pure
    /// @param              arg0 ["address", "uint128", "bytes16", "int128"]
    function Unresolved_b410f122(address arg0) public pure {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0140);
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0140);
        require(uint128(arg0) - arg0);
    }
    
    /// @custom:selector    0xb8f480c6
    /// @custom:signature   Unresolved_b8f480c6(uint256 arg0, uint32 arg1) public payable returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint32", "bytes4", "int32"]
    function Unresolved_b8f480c6(uint256 arg0, uint32 arg1) public payable returns (bytes memory) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(arg0 + 0x23 < msg.data.length);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x24 <= msg.data.length);
        require(!(msg.sender - store_n), CustomError_118cdaa7());
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_d = msg.data[0x04 + arg0];
            if (msg.data[0x04 + arg0] <= 0xffffffffffffffff) {
                if (0 < msg.data[0x04 + arg0]) {
                    if (0 < msg.data[0x04 + arg0]) {
                        require(!(uint32(msg.data[arg0 + 0x24]) - msg.data[arg0 + 0x24]));
                        storage_map_d[uint32(msg.data[arg0 + 0x24])] = storage_map_d[uint32(msg.data[arg0 + 0x24])] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
                        if (0 < msg.data[0x04 + arg0]) {
                            require(!(uint32(msg.data[arg0 + 0x24]) - msg.data[arg0 + 0x24]));
                            emit ChainSupported(uint32(msg.data[arg0 + 0x24]));
                        }
                    }
                } else {
                    return abi.encodePacked(0x20, var_i);
                }
            }
        }
    }
    
    /// @custom:selector    0xc4d252f5
    /// @custom:signature   Unresolved_c4d252f5(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_c4d252f5(uint256 arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!store_j, CustomError_d93c0665());
        if (!(var_c + 0x0140 > 0xffffffffffffffff | var_c + 0x0140 < var_c)) {
            uint256 var_c = var_c + 0x0140;
            require(uint32(var_o) == 0x7595, "Not on source chain");
            (bool success, bytes memory ret0) = address(address(this)).Unresolved_2dff692d(arg0); // staticcall
            require(success);
            if (success) {
                if (!(var_c + 0x20 > 0xffffffffffffffff | var_c + 0x20 < var_c)) {
                    uint256 var_c = var_c + 0x20;
                    require(var_c + 0x20 - var_c >= 0x20);
                    require(var_t < 0x05);
                }
            } else {
                if (0x05 > 0) {
                    require(0 == 0x01, "Order not active");
                    if (uint32(var_o) == uint32(var_u)) {
                        (bool success, bytes memory ret0) = address(address(this)).Unresolved_7de63734(msg.sender); // staticcall
                        require(success);
                        require(success, "Only solver or offerer (after expiry) can cancel");
                    } else {
                        (bool success, bytes memory ret0) = address(address(this)).Unresolved_7de63734(msg.sender); // staticcall
                        require(success);
                        require(success, "Cross-chain orders can only be cancelled by solver after expiry");
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xcd774887
    /// @custom:signature   Unresolved_cd774887(uint32 arg0, bool arg1, uint256 arg2, uint256 arg3, uint32 arg4, address arg5) public view
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    /// @param              arg1 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint32", "bytes4", "int32"]
    /// @param              arg5 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_cd774887(uint32 arg0, bool arg1, uint256 arg2, uint256 arg3, uint32 arg4, address arg5) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xc0);
        require(!(arg0 - arg0));
        require(!(arg1 - uint8(arg1)));
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        require(!(arg3 - arg3));
        require(!(arg4 - arg4));
        require(!(arg5 - arg5));
        if (uint8(arg1) - 0x01) {
            require(!uint8(arg1), "Invalid message type");
        }
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(!(msg.sender - store_n), CustomError_118cdaa7());
        require(arg0, CustomError_1e4fbdf7());
        store_n = store_n & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        emit Event_8be0079c(store_n, arg0);
    }
    
    /// @custom:selector    0xf3fef3a3
    /// @custom:signature   Unresolved_f3fef3a3(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_f3fef3a3(address arg0, uint256 arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(store_k != 0x02, CustomError_3ee5aeb5());
        store_k = 0x02;
        require(!store_j, CustomError_d93c0665());
        require(arg1, "Amount must be greater than zero");
        require(storage_map_g[msg.sender][arg0] >> 0x80 >= arg1, "Insufficient unlocked balance");
        if (!(var_h + 0x80 > 0xffffffffffffffff | var_h + 0x80 < var_h)) {
            (bool success, bytes memory ret0) = address(0x4e487b7100000000000000000000000000000000000000000000000000000000).Unresolved_a9059cbb{ value: 0 }(msg.sender); // call
            require(success);
            require(!ret0.length, CustomError_5274afe7());
            require(arg0.code.length, CustomError_5274afe7());
            if ((storage_map_g[msg.sender][arg0] >> 0x80) - arg1 <= storage_map_g[msg.sender][arg0] >> 0x80) {
                storage_map_g[msg.sender][arg0] = storage_map_g[msg.sender][arg0].field_0 | uint128((storage_map_g[msg.sender][arg0] >> 0x80) - arg1) << 0x80 & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000;
                emit Withdraw(msg.sender, arg0, arg1);
                store_k = 0x01;
            }
        }
    }
    
    /// @custom:selector    0xff7bd03d
    /// @custom:signature   Unresolved_ff7bd03d(uint32 arg0, uint256 arg1) public view returns (uint256)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_ff7bd03d(uint32 arg0, uint256 arg1) public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(!(arg0 - arg0));
        uint256 var_c = peers[arg0] == arg1;
        return var_c;
    }
    
    /// @custom:selector    0x51cff8d9
    /// @custom:signature   withdraw(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function withdraw(address arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(store_k != 0x02, CustomError_3ee5aeb5());
        store_k = 0x02;
        require(!store_j, CustomError_d93c0665());
        require(storage_map_g[msg.sender][arg0] >> 0x80, "Non-zero balance required");
        bytes32 var_f = storage_map_g[msg.sender][arg0] >> 0x80;
        if (!(var_h + 0x80 > 0xffffffffffffffff | var_h + 0x80 < var_h)) {
            (bool success, bytes memory ret0) = address(0x4e487b7100000000000000000000000000000000000000000000000000000000).Unresolved_a9059cbb{ value: 0 }(msg.sender); // call
            require(success);
            if (ret0.length) {
                require(0x01 == 0x4e487b7100000000000000000000000000000000000000000000000000000000, CustomError_5274afe7());
            } else {
                require(arg0.code.length, CustomError_5274afe7());
            }
            storage_map_g[msg.sender][arg0] = storage_map_g[msg.sender][arg0].field_0;
            emit Withdraw(msg.sender, arg0, var_f);
            store_k = 0x01;
        }
    }
}