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
    address store_e; // storage slot: 0x01
    bytes public unresolved_fcb1cbf0; // storage slot: 0x03
    address public unresolved_893d20e8; // storage slot: 0x04
    bytes32 store_d; // storage slot: 0x04
    uint256 public getFee; // storage slot: 0x06
    bytes32 store_j; // storage slot: 0x07
    address store_h; // storage slot: keccak256(memory[var_a:var_a + (0x20 + (var_a + var_g - var_a))])
    bytes32 store_f; // storage slot: keccak256(memory[var_a:var_a + (0x20 + (var_a + var_h - var_a))])
    bytes32 store_g; // storage slot: keccak256(memory[var_a:var_a + (0x20 + (var_a + var_h - var_a))]) + 0x01
    bytes32 store_k; // storage slot: keccak256(memory[var_a:var_a + (0x20 + (var_a + var_f - var_a))])
    bytes32 store_n; // storage slot: keccak256(memory[var_a:var_a + (0x20 + (var_a + var_e - var_a))])
    bytes32[] store_i; // storage slot: keccak256(memory[var_a:var_a + (0x20 + (var_a + var_g - var_a))]) + 0x01
    uint256 store_l; // storage slot: keccak256(memory[var_a:var_a + (0x20 + (var_a + var_f - var_a))]) + 0x01
    uint256 store_o; // storage slot: keccak256(memory[var_a:var_a + (0x20 + (var_a + var_e - var_a))]) + 0x01
    
    mapping(address => bytes32) storage_map_b; // storage slot: 0x00
    
    
    /// @custom:selector    0xe1ae772d
    /// @custom:signature   getFlashToken(address arg0) public view
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function getFlashToken(address arg0) public view {
        require(true);
    }
    
    /// @custom:selector    0x69fe0e2d
    /// @custom:signature   setFee(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function setFee(uint256 arg0) public {
        require(msg.sender == unresolved_893d20e8);
        getFee = arg0;
    }
    
    /// @custom:selector    0xd20c88bd
    /// @custom:signature   sweep(address[] arg0, address arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function sweep(address[] arg0, address arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && (!(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) > 0xffffffffffffffff) && 0x04 + arg0 + 0x20 < 0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x20)) {
            require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
        }
    }
    
    /// @custom:selector    0x7b1a4909
    /// @custom:signature   transferETH(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function transferETH(address arg0, uint256 arg1) public {
        require(true);
        require(msg.sender == unresolved_893d20e8);
        payable(address(arg0)).transfer(arg1);
        require(success);
    }
    
    /// @custom:selector    0x06d7a17c
    /// @custom:signature   Unresolved_06d7a17c(address arg0, uint256 arg1) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_06d7a17c(address arg0, uint256 arg1) public pure {
        require(true);
        require(arg1 <= 0xffffffffffffffff);
        if (!(var_a + 0xa0 < var_a | var_a + 0xa0 > 0xffffffffffffffff)) {
            require(msg.data[0x04 + arg1] == address(msg.data[0x04 + arg1]));
        }
    }
    
    /// @custom:selector    0x07e26e11
    /// @custom:signature   Unresolved_07e26e11(address arg0) public view
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_07e26e11(address arg0) public view {
        require(true);
    }
    
    /// @custom:selector    0x09569da4
    /// @custom:signature   Unresolved_09569da4(uint256 arg0) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_09569da4(uint256 arg0) public pure {
        require(arg0 <= 0xffffffffffffffff);
        if (!(var_a + 0xc0 < var_a | var_a + 0xc0 > 0xffffffffffffffff)) {
            require(msg.data[0x04 + arg0] == address(msg.data[0x04 + arg0]));
        }
    }
    
    /// @custom:selector    0x13af4035
    /// @custom:signature   Unresolved_13af4035(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_13af4035(address arg0) public {
        require(true);
        require(msg.sender == unresolved_893d20e8);
        store_d = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_d;
    }
    
    /// @custom:selector    0x514ef648
    /// @custom:signature   Unresolved_514ef648(address arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function Unresolved_514ef648(address arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5) public pure {
        require(true);
        require(arg1 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f) > 0xffffffffffffffff)) {
            uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f);
            require(msg.data.length >= 0x04 + arg1 + (msg.data[0x04 + arg1] << 0x05) + 0x20);
            if (0x04 + arg1 + 0x20 >= 0x04 + arg1 + (msg.data[0x04 + arg1] << 0x05) + 0x20) {
                require(arg5 <= 0xffffffffffffffff);
            } else {
                require(msg.data[0x04 + arg1 + 0x20] <= 0xffffffffffffffff);
                require(msg.data.length - (0x04 + arg1 + msg.data[0x04 + arg1 + 0x20]) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 >= 0xc0);
                if (!(var_a + 0x40 < var_a | var_a + 0x40 > 0xffffffffffffffff)) {
                    require(msg.data[0x04 + arg1 + msg.data[0x04 + arg1 + 0x20] + 0x20] <= 0xffffffffffffffff);
                }
            }
        }
    }
    
    /// @custom:selector    0x6207d601
    /// @custom:signature   Unresolved_6207d601(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_6207d601(address arg0) public {
        require(true);
        require(msg.sender == unresolved_893d20e8);
        storage_map_b[arg0] = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & storage_map_b[arg0];
        storage_map_b[arg0].field_1 = 0xffffffffffffffffffffff000000000000000000000000000000000000000000 & storage_map_b[arg0].field_1;
        if ((storage_map_b[arg0].field_2 & 0x01) - (storage_map_b[arg0].field_2 >> 0x01 < 0x20)) {
            storage_map_b[arg0].field_2 = 0;
        }
    }
    
    /// @custom:selector    0x7c8a519e
    /// @custom:signature   Unresolved_7c8a519e(address arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function Unresolved_7c8a519e(address arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5) public pure {
        require(true);
        require(arg1 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f) > 0xffffffffffffffff)) {
            uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f);
            require(msg.data.length >= 0x04 + arg1 + (msg.data[0x04 + arg1] << 0x05) + 0x20);
            if (0x04 + arg1 + 0x20 >= 0x04 + arg1 + (msg.data[0x04 + arg1] << 0x05) + 0x20) {
                require(arg5 <= 0xffffffffffffffff);
            } else {
                require(msg.data[0x04 + arg1 + 0x20] <= 0xffffffffffffffff);
                require(msg.data.length - (0x04 + arg1 + msg.data[0x04 + arg1 + 0x20]) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 >= 0xc0);
                if (!(var_a + 0x40 < var_a | var_a + 0x40 > 0xffffffffffffffff)) {
                    require(msg.data[0x04 + arg1 + msg.data[0x04 + arg1 + 0x20] + 0x20] <= 0xffffffffffffffff);
                }
            }
        }
    }
    
    /// @custom:selector    0x85504b8c
    /// @custom:signature   Unresolved_85504b8c(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_85504b8c(uint256 arg0, uint256 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) > 0xffffffffffffffff)) {
            uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f);
            if (0x04 + arg0 + 0x20 >= 0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x20) {
                require(arg1 <= 0xffffffffffffffff);
                require(msg.data.length > 0x04 + arg1 + 0x1f);
            } else {
                require(msg.data[0x04 + arg0 + 0x20] <= 0xffffffffffffffff);
            }
        }
    }
    
    /// @custom:selector    0x93643368
    /// @custom:signature   Unresolved_93643368(address arg0) public returns (bytes memory)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_93643368(address arg0) public returns (bytes memory) {
        require(true);
        if (store_e <= 0xffffffffffffffff) {
            if (0 >= store_e) {
                if (0 <= 0xffffffffffffffff) {
                    return abi.encodePacked(0x20, var_g);
                }
            } else {
                if (0 < store_e) {
                    (bool success, bytes memory ret0) = address(store_e[0].field_0).Unresolved_70a08231(arg0, var_k); // staticcall
                    require(success);
                    uint256 var_b = var_b + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                    require(var_b + ret0.length - var_b >= 0x20);
                }
            }
        }
    }
    
    /// @custom:selector    0x9c371740
    /// @custom:signature   Unresolved_9c371740(uint256 arg0) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_9c371740(uint256 arg0) public pure {
        require(arg0 <= 0xffffffffffffffff);
        if (!(var_a + 0xc0 < var_a | var_a + 0xc0 > 0xffffffffffffffff)) {
            require(msg.data[0x04 + arg0] == address(msg.data[0x04 + arg0]));
        }
    }
    
    /// @custom:selector    0xad281333
    /// @custom:signature   Unresolved_ad281333(uint256 arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_ad281333(uint256 arg0, address arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) > 0xffffffffffffffff)) {
            if (0x04 + arg0 + 0x20 >= 0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x20) {
                require(msg.sender == unresolved_893d20e8);
                if (0 < var_c && 0 < var_c) {
                    require(msg.sender == unresolved_893d20e8);
                    storage_map_b[address(var_e)] = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & storage_map_b[address(var_e)];
                    storage_map_b[address(var_e)].field_1 = 0xffffffffffffffffffffff000000000000000000000000000000000000000000 & storage_map_b[address(var_e)].field_1;
                    if ((storage_map_b[address(var_e)].field_2 & 0x01) - (storage_map_b[address(var_e)].field_2 >> 0x01 < 0x20)) {
                        storage_map_b[address(var_e)].field_2 = 0;
                    }
                }
            } else {
                require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
            }
        }
    }
    
    /// @custom:selector    0xc0adacdd
    /// @custom:signature   Unresolved_c0adacdd(address arg0, uint256 arg1, uint256 arg2, address arg3) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_c0adacdd(address arg0, uint256 arg1, uint256 arg2, address arg3) public pure {
        require(true);
        require(arg1 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg1] + 0x1f) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg1] + 0x1f) + 0x1f) > 0xffffffffffffffff)) {
            uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg1] + 0x1f) + 0x1f);
            require(msg.data.length - 0x44 >= 0xa0);
            if (!(var_a + 0xa0 < var_a | var_a + 0xa0 > 0xffffffffffffffff)) {
                require(true);
            }
        }
    }
    
    /// @custom:selector    0xc1b7383d
    /// @custom:signature   Unresolved_c1b7383d(uint256 arg0, uint256 arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_c1b7383d(uint256 arg0, uint256 arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) + 0x1f) > 0xffffffffffffffff)) {
            uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) + 0x1f);
            require(arg1 <= 0xffffffffffffffff);
            if (!(var_a + 0x40 < var_a | var_a + 0x40 > 0xffffffffffffffff)) {
                uint256 var_a = var_a + 0x40;
                require(msg.data[0x04 + arg1] == address(msg.data[0x04 + arg1]));
                require(msg.data[0x04 + arg1 + 0x20] <= 0xffffffffffffffff);
                if (msg.data[0x04 + arg1 + msg.data[0x04 + arg1 + 0x20]] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg1 + msg.data[0x04 + arg1 + 0x20]] + 0x1f) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg1 + msg.data[0x04 + arg1 + 0x20]] + 0x1f) + 0x1f) > 0xffffffffffffffff)) {
                    uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg1 + msg.data[0x04 + arg1 + 0x20]] + 0x1f) + 0x1f);
                    require(msg.sender == unresolved_893d20e8);
                    store_f = address(var_h) | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_f;
                    if (var_i <= 0xffffffffffffffff && (store_g & 0x01) - (store_g >> 0x01 < 0x20)) {
                        if (var_i > 0x1f == 0x01) {
                            if ((var_i & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_i) {
                                store_g[0] = ~(type(uint256).max >> (0xf8 & var_i << 0x03)) & var_k;
                            }
                            store_g = (var_i << 0x01) + 0x01;
                        } else {
                            if (!var_i) {
                                store_g = var_i << 0x01 | ~(type(uint256).max >> (var_i << 0x03)) & 0;
                            } else {
                                store_g = var_i << 0x01 | ~(type(uint256).max >> (var_i << 0x03)) & var_k;
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xc6288c6b
    /// @custom:signature   Unresolved_c6288c6b(uint256 arg0) public view returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_c6288c6b(uint256 arg0) public view returns (bytes memory) {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && (!(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) + 0x1f) > 0xffffffffffffffff) && (store_i & 0x01) - (store_i >> 0x01 < 0x20))) {
            uint256 var_a = var_a + (0x20 + (0x1f + (store_i >> 0x01)) / 0x20 * 0x20);
            if ((store_i & 0x01) - (store_i >> 0x01 < 0x20)) {
                return abi.encodePacked(0x20, address(var_g), 0x40, var_n);
            }
        }
    }
    
    /// @custom:selector    0xcd004041
    /// @custom:signature   Unresolved_cd004041() public view returns (bytes memory)
    function Unresolved_cd004041() public view returns (bytes memory) {
        return abi.encodePacked(0x20, var_f);
    }
    
    /// @custom:selector    0xd087d288
    /// @custom:signature   Unresolved_d087d288() public view returns (uint256)
    function Unresolved_d087d288() public view returns (uint256) {
        return store_j;
    }
    
    /// @custom:selector    0xdbd72aa3
    /// @custom:signature   Unresolved_dbd72aa3(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_dbd72aa3(uint256 arg0, uint256 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) + 0x1f) > 0xffffffffffffffff)) {
            uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) + 0x1f);
            require(arg1 <= 0xffffffffffffffff);
            if (!(var_a + 0xc0 < var_a | var_a + 0xc0 > 0xffffffffffffffff)) {
                require(msg.data[0x04 + arg1] == address(msg.data[0x04 + arg1]));
            }
        }
    }
    
    /// @custom:selector    0xe3a9b573
    /// @custom:signature   Unresolved_e3a9b573(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_e3a9b573(uint256 arg0, uint256 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) > 0xffffffffffffffff)) {
            if (0x04 + arg0 + 0x20 >= 0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x20) {
                require(arg1 <= 0xffffffffffffffff);
                require(msg.data.length > 0x04 + arg1 + 0x1f);
            } else {
                require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
            }
        }
    }
    
    /// @custom:selector    0xf30946be
    /// @custom:signature   Unresolved_f30946be(uint256 arg0, uint256 arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_f30946be(uint256 arg0, uint256 arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f) > 0xffffffffffffffff)) {
            uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f);
            if (0x04 + arg0 + 0x20 >= 0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x20) {
                require(msg.sender == unresolved_893d20e8);
                if (0 < var_c && 0 < var_c) {
                    require(msg.sender == unresolved_893d20e8);
                    store_k = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_k;
                    if ((store_l & 0x01) - (store_l >> 0x01 < 0x20)) {
                        store_l = 0;
                    }
                }
            } else {
                require(msg.data[0x04 + arg0 + 0x20] <= 0xffffffffffffffff);
            }
        }
    }
    
    /// @custom:selector    0xf435faff
    /// @custom:signature   Unresolved_f435faff(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_f435faff(uint256 arg0) public {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) + 0x1f) > 0xffffffffffffffff)) {
            uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) + 0x1f);
            require(msg.sender == unresolved_893d20e8);
            store_n = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_n;
            if ((store_o & 0x01) - (store_o >> 0x01 < 0x20)) {
                store_o = 0;
            }
        }
    }
    
    /// @custom:selector    0xf5537ede
    /// @custom:signature   Unresolved_f5537ede(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f5537ede(address arg0) public pure {
        require(true);
    }
}