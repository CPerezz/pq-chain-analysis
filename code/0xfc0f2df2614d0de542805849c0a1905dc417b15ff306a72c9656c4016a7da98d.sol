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
    uint256 public constant SIGNER_ROLE = 102655434171155357625921223596128619834448582336474538707449181985608080842608;
    uint256 public constant unresolved_022d63fb = 432000;
    uint256 public constant unresolved_a217fddf = 0;
    uint256 public constant unresolved_ad5c4648 = 1097077688018008265106216665536940668749033598146;
    address public constant unresolved_d737d0c7 = 0xAddress(0x0000000000000000000000000000000000000000);
    
    address store_i; // storage slot: 0x01
    uint208 store_h; // storage slot: 0x01
    uint48 public unresolved_cc8463c8; // storage slot: 0x01
    uint48 store_j; // storage slot: 0x01
    uint48 store_k; // storage slot: 0x01
    uint48 store_n; // storage slot: 0x01
    address store_f; // storage slot: 0x02
    bytes store_e; // storage slot: 0x02
    address public refundCollector; // storage slot: 0x03
    bytes32 store_m; // storage slot: 0x03
    bytes32 tstore_a; // storage slot: unknown
    
    mapping(uint256 => mapping(address => bytes32)) storage_map_a; // storage slot: 0x00
    mapping(bytes32 => bytes32) storage_map_l; // storage slot: 0x04
    mapping(uint256 => uint8) storage_map_o; // storage slot: 0x059f08e7d7ba1c82eddc57afae67f80df851baf38a099607a779825038c3ce5b
    mapping(address => uint8) storage_map_c; // storage slot: 0x35be12757faf39521ceabc5bcd76ad643125bff13e41131da81a236ed69872a8
    mapping(address => uint8) storage_map_d; // storage slot: 0xad3228b676f7d3cd4284a5443f17f1962b36e491b30a40b2405849e597ba5fb5
    
    error CustomError_00000000();
    event Event_2b1fa2ed();
    event Event_2f878811();
    event Event_3377dc44();
    event Event_8886ebfc();
    event Event_ef851a0d();
    event Event_f1038c18();
    event Event_f6391f5c();
    event ExtraData(bytes);
    event RescueERC20s(address[], uint256[], address);
    event RescueERC721s(address[], uint256[], address);
    
    /// @custom:selector    0x6f39feec
    /// @custom:signature   batchRevokeRole(bytes32 arg0, address[] arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function batchRevokeRole(bytes32 arg0, address[] arg1) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg1 <= 0xffffffffffffffff);
        require(arg1 + 0x23 < msg.data.length);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            require(arg1 + (msg.data[0x04 + arg1] << 0x05) + 0x24 <= msg.data.length);
            if (0x24 + arg1 < arg1 + (msg.data[0x04 + arg1] << 0x05) + 0x24) {
                require(msg.data[0x24 + arg1] - address(msg.data[0x24 + arg1]));
            } else {
                require(storage_map_a[storage_map_a[arg0].field_1][msg.sender].field_0, CustomError_e2517d3f());
            }
        }
    }
    
    /// @custom:selector    0xeaf1b14b
    /// @custom:signature   rescueERC20s(address[] arg0, uint256[] arg1, address arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    function rescueERC20s(address[] arg0, uint256[] arg1, address arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(arg1 <= 0xffffffffffffffff);
        require(arg1 + 0x23 < msg.data.length);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + (0x20 + (var_d << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(arg1 + (msg.data[0x04 + arg1] << 0x05) + 0x24 <= msg.data.length);
            require(!(arg2 - arg2));
            require(storage_map_c[msg.sender].field_0, CustomError_e2517d3f());
            require(arg2, CustomError_e6c4247b());
            require(!(msg.data[0x04 + arg0] - var_g), CustomError_568efce2());
            if (0 < msg.data[0x04 + arg0]) {
                if (0 < msg.data[0x04 + arg0]) {
                    require(!(msg.data[0x04 + arg0 + 0x20] - address(msg.data[0x04 + arg0 + 0x20])));
                    if (0 < var_g) {
                        if (!var_h) {
                            if (address(msg.data[0x04 + arg0 + 0x20]) - 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee) {
                                (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg0 + 0x20])).Unresolved_70a08231(address(this)); // staticcall
                                require(success);
                                if (!(var_c + 0x20 > 0xffffffffffffffff | var_c + 0x20 < var_c)) {
                                    uint256 var_c = var_c + 0x20;
                                    require(var_c + 0x20 - var_c >= 0x20);
                                }
                            } else {
                                if (0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee - address(msg.data[0x04 + arg0 + 0x20])) {
                                    address var_j = var_m;
                                    (bool success, bytes memory ret0) = address(msg.data[0x04 + arg0 + 0x20]).Unresolved_a9059cbb(var_j); // call
                                } else {
                                    payable(address(arg2)).transfer(address(this).balance);
                                }
                                revert CustomError_90bfb865();
                            }
                        } else {
                            if (0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee - address(msg.data[0x04 + arg0 + 0x20])) {
                                (bool success, bytes memory ret0) = address(msg.data[0x04 + arg0 + 0x20]).Unresolved_a9059cbb(0, var_h, 0x80); // call
                            } else {
                                payable(address(arg2)).transfer(var_h);
                            }
                            revert CustomError_90bfb865();
                        }
                    }
                }
            } else {
                uint256 var_s = msg.data[0x04 + arg0];
                if (0 < msg.data[0x04 + arg0]) {
                    require(msg.data[0x04 + arg0 + 0x20] - address(msg.data[0x04 + arg0 + 0x20]));
                } else {
                    emit RescueERC20s(0x60, var_c + 0x80 - var_c, arg2, var_s, var_g);
                }
            }
        }
    }
    
    /// @custom:selector    0x01ffc9a7
    /// @custom:signature   Unresolved_01ffc9a7(uint32 arg0) public pure returns (bool)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function Unresolved_01ffc9a7(uint32 arg0) public pure returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - (arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000)));
        if ((arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) != 0x3149878600000000000000000000000000000000000000000000000000000000) {
            if ((arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) != 0x7965db0b00000000000000000000000000000000000000000000000000000000) {
                return (arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) == 0x01ffc9a700000000000000000000000000000000000000000000000000000000;
            } else {
                return (arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) == 0x7965db0b00000000000000000000000000000000000000000000000000000000;
            }
        } else {
            return (arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) == 0x3149878600000000000000000000000000000000000000000000000000000000;
        }
    }
    
    /// @custom:selector    0x0aa6220b
    /// @custom:signature   Unresolved_0aa6220b() public payable
    function Unresolved_0aa6220b() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(storage_map_d[msg.sender].field_0, CustomError_e2517d3f());
        if (store_e >> 0xd0) {
            if (block.timestamp <= store_e >> 0xd0) {
                emit Event_2b1fa2ed();
            } else {
                unresolved_cc8463c8 = store_h | store_e << 0x30 & 0xffffffffffff0000000000000000000000000000000000000000000000000000;
            }
        }
        store_e = store_f;
    }
    
    /// @custom:selector    0x248a9ca3
    /// @custom:signature   Unresolved_248a9ca3(uint256 arg0) public view returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_248a9ca3(uint256 arg0) public view returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        var_c = storage_map_a[arg0].field_1;
        return var_c;
    }
    
    /// @custom:selector    0x2f2ff15d
    /// @custom:signature   Unresolved_2f2ff15d(uint256 arg0, address arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_2f2ff15d(uint256 arg0, address arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg1 - arg1));
        require(arg0, CustomError_3fc3c27a());
        require(storage_map_a[storage_map_a[arg0].field_1][msg.sender].field_0, CustomError_e2517d3f());
        require(arg0, CustomError_3fc3c27a());
        if (0 != !storage_map_a[arg0][arg1].field_0) {
            storage_map_a[arg0][arg1] = storage_map_a[arg0][arg1] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
            emit Event_2f878811(arg0, arg1, msg.sender);
        }
    }
    
    /// @custom:selector    0x36035eba
    /// @custom:signature   Unresolved_36035eba(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_36035eba(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, address arg4) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0xa0);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg1] << 0x05) + (0x04 + arg1) + 0x20 <= msg.data.length);
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg2] << 0x05) + (0x04 + arg2) + 0x20 <= msg.data.length);
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg3] << 0x05) + (0x04 + arg3) + 0x20 <= msg.data.length);
        require(!(arg4 - arg4));
        require(storage_map_c[msg.sender].field_0, CustomError_e2517d3f());
        require(arg4, CustomError_e6c4247b());
        require(!(msg.data[0x04 + arg0] - msg.data[0x04 + arg1]), CustomError_568efce2());
        require(!(msg.data[0x04 + arg0] - msg.data[0x04 + arg2]), CustomError_568efce2());
        require(!(msg.data[0x04 + arg0] - msg.data[0x04 + arg3]), CustomError_568efce2());
        if (0 < msg.data[0x04 + arg0]) {
            if (0 < msg.data[0x04 + arg0]) {
                require(!(msg.data[0x04 + arg0 + 0x20] - address(msg.data[0x04 + arg0 + 0x20])));
                if (0 < msg.data[0x04 + arg1] && (0 < msg.data[0x04 + arg2] && 0 < msg.data[0x04 + arg3])) {
                    require(msg.data[0x04 + arg3 + 0x20] < msg.data.length - (0x04 + arg3 + 0x20) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                    require(msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20]] <= 0xffffffffffffffff);
                    require(0x20 + (0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20]) <= msg.data.length - msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20]]);
                    if (msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20]] <= 0xffffffffffffffff && !(var_e + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20]]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_e + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20]]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_e)) {
                        uint256 var_e = var_e + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20]]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                        if (!msg.data[0x04 + arg2 + 0x20]) {
                            (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg0 + 0x20])).Unresolved_00fdd58e(address(this)); // staticcall
                        } else {
                            require(address(msg.data[0x04 + arg0 + 0x20]).code.length);
                            (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg0 + 0x20])).Unresolved_f242432a(address(this)); // call
                        }
                        require(success);
                    }
                }
            }
        } else {
            if (0 < msg.data[0x04 + arg0]) {
                require(msg.data[0x04 + arg0 + 0x20] - address(msg.data[0x04 + arg0 + 0x20]));
            } else {
                require(msg.data[0x04 + arg1] > 0x07ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
            }
        }
    }
    
    /// @custom:selector    0x36568abe
    /// @custom:signature   Unresolved_36568abe(uint256 arg0, address arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_36568abe(uint256 arg0, address arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg1 - arg1));
        require(arg0, CustomError_19ca5ebb());
        require(!(arg1 - msg.sender), CustomError_6697b232());
        if (0 != storage_map_a[arg0][arg1].field_0) {
            storage_map_a[arg0][arg1] = storage_map_a[arg0][arg1] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
            emit Event_f6391f5c(arg0, arg1, msg.sender);
        }
    }
    
    /// @custom:selector    0x3b0f3289
    /// @custom:signature   Unresolved_3b0f3289(uint256 arg0, uint256 arg1, address arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_3b0f3289(uint256 arg0, uint256 arg1, address arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg1] << 0x05) + (0x04 + arg1) + 0x20 <= msg.data.length);
        require(!(arg2 - arg2));
        require(storage_map_c[msg.sender].field_0, CustomError_e2517d3f());
        require(arg2, CustomError_e6c4247b());
        require(!(msg.data[0x04 + arg0] - msg.data[0x04 + arg1]), CustomError_568efce2());
        if (0 < msg.data[0x04 + arg0]) {
            if (0 < msg.data[0x04 + arg0]) {
                require(!(msg.data[0x04 + arg0 + 0x20] - address(msg.data[0x04 + arg0 + 0x20])));
                if (0 < msg.data[0x04 + arg1]) {
                    require(address(msg.data[0x04 + arg0 + 0x20]).code.length);
                    (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg0 + 0x20])).Unresolved_42842e0e(address(this)); // call
                    require(success);
                }
            }
        } else {
            uint256 var_i = msg.data[0x04 + arg0];
            if (0 < msg.data[0x04 + arg0]) {
                require(msg.data[0x04 + arg0 + 0x20] - address(msg.data[0x04 + arg0 + 0x20]));
            } else {
                uint256 var_l = msg.data[0x04 + arg1];
                require(msg.data[0x04 + arg1] <= 0x07ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
                emit RescueERC721s(0x60, var_k + 0x80 - var_k, arg2, var_i, var_l);
            }
        }
    }
    
    /// @custom:selector    0x46b5cb59
    /// @custom:signature   Unresolved_46b5cb59(uint256 arg0, uint256 arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_46b5cb59(uint256 arg0, uint256 arg1) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg1 <= 0xffffffffffffffff);
        require(arg1 + 0x23 < msg.data.length);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            require(arg1 + (msg.data[0x04 + arg1] << 0x05) + 0x24 <= msg.data.length);
            if (0x24 + arg1 < arg1 + (msg.data[0x04 + arg1] << 0x05) + 0x24) {
                require(msg.data[0x24 + arg1] - address(msg.data[0x24 + arg1]));
            } else {
                require(storage_map_a[storage_map_a[arg0].field_1][msg.sender].field_0, CustomError_e2517d3f());
                if (0 < var_g && 0 < var_g) {
                    require(arg0, CustomError_3fc3c27a());
                }
            }
        }
    }
    
    /// @custom:selector    0x634e93da
    /// @custom:signature   Unresolved_634e93da(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_634e93da(address arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(storage_map_d[msg.sender].field_0, CustomError_e2517d3f());
        require(block.timestamp <= 0xffffffffffff, CustomError_6dfcc650());
        if (store_e >> 0xd0 && uint48(block.timestamp) + store_k <= 0xffffffffffff) {
            unresolved_cc8463c8 = unresolved_cc8463c8 & 0xffffffffffff0000000000000000000000000000000000000000000000000000 | arg0 | uint48(block.timestamp) + store_k << 0xa0 & 0xffffffffffff0000000000000000000000000000000000000000;
            if (store_j) {
                emit Event_8886ebfc();
            }
            emit Event_3377dc44(arg0, uint48(uint48(block.timestamp) + store_k));
        }
    }
    
    /// @custom:selector    0x649a5ec7
    /// @custom:signature   Unresolved_649a5ec7(uint48 arg0) public payable
    /// @param              arg0 ["uint48", "bytes6", "int48"]
    function Unresolved_649a5ec7(uint48 arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(storage_map_d[msg.sender].field_0, CustomError_e2517d3f());
        require(block.timestamp <= 0xffffffffffff, CustomError_6dfcc650());
        if (store_e >> 0xd0 && arg0 > store_k && uint48(block.timestamp) + uint48(0x069780 ^ (arg0 ^ 0x069780) * (arg0 < 0x069780)) <= 0xffffffffffff) {
            if (store_e >> 0xd0) {
                if (block.timestamp <= store_e >> 0xd0) {
                    emit Event_2b1fa2ed();
                    store_e = 0xffffffffffff0000000000000000000000000000000000000000000000000000 & uint48(block.timestamp) + uint48(0x069780 ^ (var_e ^ 0x069780) * (var_e < 0x069780)) << 0xd0 | (0xffffffffffff0000000000000000000000000000000000000000 & arg0 << 0xa0 | store_f);
                } else {
                    unresolved_cc8463c8 = store_h | store_e << 0x30 & 0xffffffffffff0000000000000000000000000000000000000000000000000000;
                    store_e = 0xffffffffffff0000000000000000000000000000000000000000000000000000 & uint48(block.timestamp) + uint48(0x069780 ^ (arg0 ^ 0x069780) * (arg0 < 0x069780)) << 0xd0 | (0xffffffffffff0000000000000000000000000000000000000000 & arg0 << 0xa0 | store_f);
                }
            } else {
                store_e = 0xffffffffffff0000000000000000000000000000000000000000000000000000 & uint48(block.timestamp) + uint48(0x069780 ^ (arg0 ^ 0x069780) * (arg0 < 0x069780)) << 0xd0 | (0xffffffffffff0000000000000000000000000000000000000000 & arg0 << 0xa0 | store_f);
            }
            emit Event_f1038c18(arg0, uint48(uint48(block.timestamp) + uint48(0x069780 ^ (arg0 ^ 0x069780) * (arg0 < 0x069780))));
        }
    }
    
    /// @custom:selector    0x68569be7
    /// @custom:signature   Unresolved_68569be7(uint256 arg0, uint256 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_68569be7(uint256 arg0, uint256 arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg1] << 0x05) + (0x04 + arg1) + 0x20 <= msg.data.length);
        require(!(msg.data[0x04 + arg0] - msg.data[0x04 + arg1]), CustomError_568efce2());
        require(storage_map_d[msg.sender].field_0, CustomError_e2517d3f());
        if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg1]) {
            require(!(msg.data[0x04 + arg1 + 0x20] - address(msg.data[0x04 + arg1 + 0x20])));
            if (0 < msg.data[0x04 + arg0]) {
                require(!(msg.data[0x04 + arg0 + 0x20] - (msg.data[0x04 + arg0 + 0x20] & 0xffffffff00000000000000000000000000000000000000000000000000000000)));
                storage_map_l[msg.data[0x04 + arg0 + 0x20] & 0xffffffff00000000000000000000000000000000000000000000000000000000] = storage_map_l[msg.data[0x04 + arg0 + 0x20] & 0xffffffff00000000000000000000000000000000000000000000000000000000] & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | address(msg.data[0x04 + arg1 + 0x20]);
                if (0 < msg.data[0x04 + arg0]) {
                    require(!(msg.data[0x04 + arg0 + 0x20] - (msg.data[0x04 + arg0 + 0x20] & 0xffffffff00000000000000000000000000000000000000000000000000000000)));
                    if (0 < msg.data[0x04 + arg1]) {
                        require(msg.data[0x04 + arg1 + 0x20] - address(msg.data[0x04 + arg1 + 0x20]));
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x6b54f8b1
    /// @custom:signature   Unresolved_6b54f8b1(uint32 arg0) public view returns (address)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function Unresolved_6b54f8b1(uint32 arg0) public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - (arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000)));
        var_c = storage_map_l[arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x7d726b0d
    /// @custom:signature   Unresolved_7d726b0d(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_7d726b0d(address arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(storage_map_d[msg.sender].field_0, CustomError_e2517d3f());
        require(arg0, CustomError_e6c4247b());
        store_m = store_m & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | var_e;
        emit Event_ef851a0d(arg0);
    }
    
    /// @custom:selector    0x84ef8ffc
    /// @custom:signature   Unresolved_84ef8ffc() public view returns (address)
    function Unresolved_84ef8ffc() public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_f;
    }
    
    /// @custom:selector    0x8da5cb5b
    /// @custom:signature   Unresolved_8da5cb5b() public view returns (address)
    function Unresolved_8da5cb5b() public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_f;
    }
    
    /// @custom:selector    0x91d14854
    /// @custom:signature   Unresolved_91d14854(uint256 arg0, address arg1) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_91d14854(uint256 arg0, address arg1) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg1 - arg1));
        var_c = storage_map_a[arg0][arg1].field_0;
        return var_c;
    }
    
    /// @custom:selector    0xa1eda53c
    /// @custom:signature   Unresolved_a1eda53c() public view returns (bytes memory)
    function Unresolved_a1eda53c() public view returns (bytes memory) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (store_e >> 0xd0 < block.timestamp) {
            return abi.encodePacked(0, 0);
        } else {
            return abi.encodePacked(store_e, store_e);
        }
    }
    
    /// @custom:selector    0xcefc1429
    /// @custom:signature   Unresolved_cefc1429() public payable
    function Unresolved_cefc1429() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - store_i), CustomError_c22c8022());
        require(store_n, CustomError_19ca5ebb());
        require(store_n < block.timestamp, CustomError_19ca5ebb());
        storage_map_a[0][store_e] = storage_map_a[0][store_e] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        emit Event_f6391f5c(0, store_e, msg.sender);
        require(!store_e, CustomError_3fc3c27a());
        store_e = store_e & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | store_i;
        if (0 != !storage_map_a[0][store_i].field_0) {
            storage_map_a[0][store_i] = storage_map_a[0][store_i] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
            emit Event_2f878811(0, store_i, msg.sender);
        }
        unresolved_cc8463c8 = 0xffffffffffff0000000000000000000000000000000000000000000000000000 & unresolved_cc8463c8;
    }
    
    /// @custom:selector    0xcf6eefb7
    /// @custom:signature   Unresolved_cf6eefb7() public view returns (bytes memory)
    function Unresolved_cf6eefb7() public view returns (bytes memory) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return abi.encodePacked(unresolved_cc8463c8, unresolved_cc8463c8);
    }
    
    /// @custom:selector    0xd547741f
    /// @custom:signature   Unresolved_d547741f(uint256 arg0, address arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_d547741f(uint256 arg0, address arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg1 - arg1));
        require(arg0, CustomError_3fc3c27a());
        require(storage_map_a[storage_map_a[arg0].field_1][msg.sender].field_0, CustomError_e2517d3f());
        if (0 != storage_map_a[arg0][arg1].field_0) {
            storage_map_a[arg0][arg1] = storage_map_a[arg0][arg1] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
            emit Event_f6391f5c(arg0, arg1, msg.sender);
        }
    }
    
    /// @custom:selector    0xd602b9fd
    /// @custom:signature   Unresolved_d602b9fd() public payable
    function Unresolved_d602b9fd() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(storage_map_d[msg.sender].field_0, CustomError_e2517d3f());
        unresolved_cc8463c8 = unresolved_cc8463c8 & 0xffffffffffff0000000000000000000000000000000000000000000000000000;
        if (unresolved_cc8463c8) {
            emit Event_8886ebfc();
        }
    }
    
    /// @custom:selector    0xd9c45357
    /// @custom:signature   Unresolved_d9c45357(uint256 arg0, address arg1, uint256 arg2, uint256 arg3, uint256 arg4, address arg5, uint256 arg6, uint256 arg7) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint128", "bytes16", "int128"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["address", "uint128", "bytes16", "int128"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    function Unresolved_d9c45357(uint256 arg0, address arg1, uint256 arg2, uint256 arg3, uint256 arg4, address arg5, uint256 arg6, uint256 arg7) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(arg0 + 0x23 < msg.data.length);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(arg0 + msg.data[0x04 + arg0] + 0x24 <= msg.data.length);
        require(!address(tstore_a), CustomError_6f5ffb7e());
        tstore_a = msg.sender;
        require(msg.data[0x04 + arg0] + (arg0 + 0x24) >= msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x20]] + (arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x20]) + 0x20, CustomError_3b99b53d());
        require(msg.data[0x04 + arg0] + (arg0 + 0x24) >= msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40]] + (arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40]) + 0x20, CustomError_3b99b53d());
        require(msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40]] + (arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20) >= msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + 0x20]] + (arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + 0x20]) + 0x20, CustomError_3b99b53d());
        require(msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40]] + (arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20) >= msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + 0x40]] + (arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + 0x40]) + 0x20, CustomError_3b99b53d());
        require(msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40]] + (arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20) >= msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + 0x0120]] + (arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + 0x0120]) + 0x20, CustomError_3b99b53d());
        uint256 var_d = msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + 0x0120]];
        emit ExtraData(0x20, var_d);
        if (0 >= msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + 0x20]] && address(msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20])) {
            require(msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + 0x0100] >= block.timestamp, CustomError_8727a7f9());
            require(msg.data[arg0 + 0x24] >> 0x80 >= msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + 0x60] >> 0x80, CustomError_cae33fc2());
            require(msg.data[arg0 + 0x24] >> 0x80 <= uint128(msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x40] + 0x20 + 0x60]), CustomError_cae33fc2());
            require(0x0100 <= msg.data[0x04 + arg0]);
            uint256 var_j = msg.data[0x04 + arg0] + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
            if (!(var_e + ((msg.data[0x04 + arg0] + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + (var_e + 0x80) + 0x20 - var_e + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_e + ((msg.data[0x04 + arg0] + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + (var_e + 0x80) + 0x20 - var_e + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_e)) {
                uint256 var_e = var_e + ((var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + (var_e + 0x80) + 0x20 - var_e + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                if (msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x20]] <= 0xffffffffffffffff && !(var_e + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x20]]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_e + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x20]]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_e)) {
                    uint256 var_e = var_e + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x20]]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                    uint256 var_l = msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x20]];
                    require(arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x20] + 0x20 + msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x20]] <= msg.data.length);
                    uint256 var_m = msg.data[arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x20] + 0x20:arg0 + 0x24 + msg.data[arg0 + 0x24 + 0x20] + 0x20 + var_l];
                    if (var_o > 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0) {
                        require(0x03 >= 0x04, CustomError_d78bce0c());
                    } else {
                        var_n = keccak256(memory[var_e + 0x20:var_e + 0x20 + var_q]);
                        require(memory[0x20]);
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xe4310066
    /// @custom:signature   Unresolved_e4310066(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4) public payable returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_e4310066(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4) public payable returns (bytes memory) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(storage_map_d[msg.sender].field_0, CustomError_e2517d3f());
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_e + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_e + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_e)) {
            uint256 var_e = var_e + (0x20 + (var_f << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && 0 >= 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) {
                if (0 >= msg.data[0x04 + arg0]) {
                    return abi.encodePacked(0x20, var_i);
                } else {
                    require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0 + 0x20) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff61);
                    if (0 < var_i) {
                        require(!(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x60] - msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x60]));
                        if (!msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x60]) {
                            require(!(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]] - address(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]])));
                            require(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x40] < msg.data.length - (0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                            require(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x40]] <= 0xffffffffffffffff);
                            require(0x20 + (0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x40]) <= msg.data.length - msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x40]]);
                            payable(address(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]])).transfer(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x20]);
                        } else {
                            require(!(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]] - address(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]])));
                            require(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x40] < msg.data.length - (0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                            require(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x40]] <= 0xffffffffffffffff);
                            require(0x20 + (0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x40]) <= msg.data.length - msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x40]]);
                            (bool success, bytes memory ret0) = address(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]]).Unresolved_(memory[var_e:var_e + (var_e + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x40]] - var_e)]); // delegatecall
                            require(ret0.length, CustomError_f2c2ec84());
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
        require(storage_map_d[msg.sender].field_0, CustomError_e2517d3f());
        storage_map_a[0][msg.sender] = storage_map_a[0][msg.sender] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        emit Event_f6391f5c(0, msg.sender, msg.sender);
        require(!store_e, CustomError_3fc3c27a());
        store_e = store_e & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        if (0 != !storage_map_a[0][arg0].field_0) {
            storage_map_a[0][arg0] = storage_map_a[0][arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
            emit Event_2f878811(0, arg0, msg.sender);
        }
    }
}