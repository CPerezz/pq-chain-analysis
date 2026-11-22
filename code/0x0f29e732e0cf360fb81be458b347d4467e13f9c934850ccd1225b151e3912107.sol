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
    uint256 public constant MAX = 115792089237316195423570985008687907853269984665640564039457584007913129639935;
    
    address public unresolved_8da5cb5b; // storage slot: 0x33
    bytes32 store_m; // storage slot: 0x33
    bytes store_e; // storage slot: 0x65
    address public unresolved_3fc8cef3; // storage slot: 0x99
    bytes32 store_f; // storage slot: 0x99
    address public unresolved_61acbdcb; // storage slot: 0x9a
    bytes32 store_l; // storage slot: 0x9a
    bytes store_p; // storage slot: 0x9b
    bytes store_i; // storage slot: 0x9d
    address public executorSigner; // storage slot: 0xa0
    address[] store_h; // storage slot: 0xa1
    
    mapping(address => uint256) storage_map_a; // storage slot: 0x66
    mapping(address => uint256) storage_map_k; // storage slot: 0x9c
    mapping(address => bytes32) storage_map_n; // storage slot: 0x9e
    mapping(address => bytes32) storage_map_o; // storage slot: 0x9f
    mapping(address => bytes32) storage_map_g; // storage slot: 0xa2
    
    event Event_1886ee5e();
    event Event_6df04710();
    event Event_8be0079c();
    event Event_a30b4a30();
    event Event_b0f5cdd7();
    event OperatorsAdded(address[]);
    event OperatorsRemoved(address[]);
    
    /// @custom:selector    0xf00baf3e
    /// @custom:signature   convertETH(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function convertETH(uint256 arg0) public {
        require(storage_map_a[msg.sender], "caller is not operator");
        require(unresolved_3fc8cef3.code.length);
        (bool success, bytes memory ret0) = address(unresolved_3fc8cef3).Unresolved_d0e30db0{ value: arg0 }(var_d); // call
        require(success);
    }
    
    /// @custom:selector    0x95ccea67
    /// @custom:signature   emergencyWithdraw(address arg0, uint256 arg1) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function emergencyWithdraw(address arg0, uint256 arg1) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if (arg0) {
            uint256 var_c = 0x64 + var_d - var_d + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0;
            require(address(this).balance >= 0, "Address: insufficient balance for call");
            require(arg0.code.length, "Address: call to non-contract");
            payable(address(arg0)).transfer(0);
            if (ret0.length == 0) {
                if (!success) {
                    require(!var_j);
                    require(0 < var_n, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0");
                } else {
                    if (var_j) {
                        require(0x80 + var_j - 0x80 >= 0x20);
                        require(var_c, "SafeERC20: ERC20 operation did not succeed");
                    }
                }
            } else {
                require(success);
            }
        } else {
            payable(address(unresolved_8da5cb5b)).transfer(arg1);
            require(success, "transfer failed");
        }
    }
    
    /// @custom:selector    0xd911c632
    /// @custom:signature   getAllOperators() public view returns (bytes memory)
    function getAllOperators() public view returns (bytes memory) {
        if (store_e <= 0xffffffffffffffff) {
            return abi.encodePacked(0x20, var_d);
        }
    }
    
    /// @custom:selector    0x6d70f7ae
    /// @custom:signature   isOperator(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isOperator(address arg0) public view returns (bool) {
        require(true);
        return storage_map_a[arg0];
    }
    
    /// @custom:selector    0xecb9e11a
    /// @custom:signature   numberOperators() public view returns (uint256)
    function numberOperators() public view returns (uint256) {
        return store_e;
    }
    
    /// @custom:selector    0x26142335
    /// @custom:signature   operatorAt(uint256 arg0) public view returns (address)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function operatorAt(uint256 arg0) public view returns (address) {
        if (arg0 < store_e) {
            return store_e[arg0].field_0;
        }
    }
    
    /// @custom:selector    0x34efb1e9
    /// @custom:signature   setAllowance(address[] arg0, address arg1, uint256 arg2) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function setAllowance(address[] arg0, address arg1, uint256 arg2) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
            require(0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20);
            require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
            if (!arg2) {
                require(!arg2, "SafeERC20: approve from non-zero to non-zero allowance");
                if (address(this).balance >= 0) {
                    revert("Address: call to non-contract");
                } else {
                    revert("Address: insufficient balance for call");
                }
            } else {
                (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg0 + 0x20])).Unresolved_dd62ed3e(address(this), arg1); // staticcall
                require(success);
                uint256 var_d = var_d + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                require(var_d + ret0.length - var_d >= 0x20);
                require(!var_o, "SafeERC20: approve from non-zero to non-zero allowance");
                require(address(this).balance >= 0, "Address: insufficient balance for call");
                require(address(msg.data[0x04 + arg0 + 0x20]).code.length, "Address: call to non-contract");
                payable(address(address(msg.data[0x04 + arg0 + 0x20]))).transfer(0);
                if (ret0.length == 0) {
                    if (!success) {
                        require(!var_q);
                        require(0 < var_o, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0");
                    } else {
                        if (0x80 + var_q - 0x80 >= 0x20) {
                            require(0xdd62ed3e00000000000000000000000000000000000000000000000000000000, "SafeERC20: ERC20 operation did not succeed");
                        }
                        revert();
                    }
                } else {
                    require(success);
                }
            }
        }
    }
    
    /// @custom:selector    0xb8d1452f
    /// @custom:signature   setWeth(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setWeth(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        store_f = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_f;
    }
    
    /// @custom:selector    0x0eb9142f
    /// @custom:signature   Unresolved_0eb9142f(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_0eb9142f(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if (storage_map_g[arg0]) {
            if (0) {
                emit Event_1886ee5e(arg0);
            }
        } else {
            store_h += 0x01;
            store_h[store_h] = arg0;
            storage_map_g[arg0] = store_h;
            if (0x01) {
                emit Event_1886ee5e(arg0);
            }
        }
    }
    
    /// @custom:selector    0x14b7c124
    /// @custom:signature   Unresolved_14b7c124() public view returns (bytes memory)
    function Unresolved_14b7c124() public view returns (bytes memory) {
        return abi.encodePacked(0x20, var_f);
    }
    
    /// @custom:selector    0x1626ba7e
    /// @custom:signature   Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public returns (uint256) {
        require(arg1 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f) > 0xffffffffffffffff)) {
            uint256 var_a = var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg1] + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + 0x1f);
            uint256 var_c = msg.data[0x04 + arg1 + 0x20:0x04 + arg1 + 0x20 + msg.data[0x04 + arg1]];
            if (0x41 != var_g) {
                if (0x1b != uint8(0x1b + (var_h >> 0xff))) {
                    uint256 var_a = var_a + 0x20;
                    require(memory[0x20]);
                }
            } else {
                if (var_h <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0) {
                    uint256 var_a = var_a + 0x20;
                    require(memory[0x20]);
                } else {
                    if (0x03 <= 0x04 && 0x03 == 0 && 0 == unresolved_61acbdcb) {
                        if (!0x01) {
                            return 0xffffffff00000000000000000000000000000000000000000000000000000000;
                        } else {
                            return 0x1626ba7e00000000000000000000000000000000000000000000000000000000;
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x4cf3fe9c
    /// @custom:signature   Unresolved_4cf3fe9c(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_4cf3fe9c(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view {
        require(arg0 <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(storage_map_k[msg.sender], "Only forwarder allow");
        require(0x04 + arg0 + 0x40 - (0x04 + arg0 + 0x20) >= 0x20);
        require(msg.data[0x04 + arg0 + 0x20] == uint128(msg.data[0x04 + arg0 + 0x20]));
        require(uint128(msg.data[0x04 + arg0 + 0x20]) >= block.timestamp, "Signature expired");
        require(0x04 + arg0 + 0x20 - (0x04 + arg0) >= 0x20);
        require(msg.data[0x04 + arg0] == address(msg.data[0x04 + arg0]));
        require(address(msg.data[0x04 + arg0]) == msg.sender, "Incorrect sender");
        require(msg.data[0x04 + arg0 + 0x60] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] << 0x05));
        if (0 >= msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]]) {
            uint256 var_f = var_f + (0x20 + (0x1f + msg.data[0x04 + arg1]) / 0x20 * 0x20);
            require(0x04 + arg0 + 0x20 - (0x04 + arg0) >= 0x20);
        } else {
            require(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] < msg.data.length - (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc1);
            require(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])]] == address(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])]]));
            require(msg.data[0x20 + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])])] < msg.data.length - (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])]) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + msg.data[0x20 + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])])]] <= 0xffffffffffffffff);
            require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] <= msg.data.length - msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + msg.data[0x20 + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])])]]);
        }
    }
    
    /// @custom:selector    0x58646799
    /// @custom:signature   Unresolved_58646799(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_58646799(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x61bb41a7
    /// @custom:signature   Unresolved_61bb41a7(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_61bb41a7(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        store_l = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_l;
        emit Event_b0f5cdd7(arg0);
    }
    
    /// @custom:selector    0x69328dec
    /// @custom:signature   Unresolved_69328dec(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_69328dec(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public
    function Unresolved_715018a6() public {
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        store_m = store_m & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
    }
    
    /// @custom:selector    0x7507bd7a
    /// @custom:signature   Unresolved_7507bd7a(uint256 arg0, uint256 arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_7507bd7a(uint256 arg0, uint256 arg1) public view {
        require(arg0 <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(storage_map_k[msg.sender], "Only forwarder allow");
        require(0x04 + arg0 + 0x20 - (0x04 + arg0) >= 0x20);
        require(msg.data[0x04 + arg0] != address(msg.data[0x04 + arg0]), "Incorrect sender");
    }
    
    /// @custom:selector    0x7dadbe8c
    /// @custom:signature   Unresolved_7dadbe8c(uint256 arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_7dadbe8c(uint256 arg0, address arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg0] << 0x05) + 0x20 + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg0] << 0x05) + 0x20 + 0x1f) > 0xffffffffffffffff)) {
            if (0x20 + (0x04 + arg0) >= 0x20 + (0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05))) {
                require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
                if (0 < var_c && (0 < var_c && storage_map_n[address(var_e)] && (storage_map_n[address(var_e)] >= 0x01 && (store_i >= 0x01 && (store_i - 0x01 < store_i && storage_map_n[address(var_e)] - 0x01 < store_i))))) {
                    store_i[storage_map_n[address(var_e)] - 0x01] = store_i[store_i - 0x01];
                    storage_map_n[store_i[store_i - 0x01]] = storage_map_n[store_i[store_i - 0x01]];
                    if (store_i) {
                        store_i[store_i - 0x01] = 0;
                        store_i -= 0x01;
                        storage_map_n[address(var_e)] = 0;
                    }
                }
            } else {
                require(msg.data[0x20 + (0x04 + arg0)] == address(msg.data[0x20 + (0x04 + arg0)]));
            }
        }
    }
    
    /// @custom:selector    0x7ecebe00
    /// @custom:signature   Unresolved_7ecebe00(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_7ecebe00(address arg0) public view returns (uint256) {
        require(true);
        return storage_map_o[arg0];
    }
    
    /// @custom:selector    0x8594ac40
    /// @custom:signature   Unresolved_8594ac40(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_8594ac40(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view {
        require(arg0 <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(storage_map_k[msg.sender], "Only forwarder allow");
        require(0x04 + arg0 + 0x40 - (0x04 + arg0 + 0x20) >= 0x20);
        require(msg.data[0x04 + arg0 + 0x20] == uint128(msg.data[0x04 + arg0 + 0x20]));
        require(uint128(msg.data[0x04 + arg0 + 0x20]) >= block.timestamp, "Signature expired");
        require(0x04 + arg0 + 0x20 - (0x04 + arg0) >= 0x20);
        require(msg.data[0x04 + arg0] == address(msg.data[0x04 + arg0]));
        require(address(msg.data[0x04 + arg0]) == msg.sender, "Incorrect sender");
        require(msg.data[0x04 + arg0 + 0x60] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] << 0x05));
        if (0 >= msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]]) {
            uint256 var_f = var_f + (0x20 + (0x1f + msg.data[0x04 + arg1]) / 0x20 * 0x20);
            require(0x04 + arg0 + 0x20 - (0x04 + arg0) >= 0x20);
        } else {
            require(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] < msg.data.length - (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa1);
            require(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])]] == address(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])]]));
            require(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + 0x40] < msg.data.length - (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])]) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + 0x40]] <= 0xffffffffffffffff);
            require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] <= msg.data.length - msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) + msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + 0x40]]);
        }
    }
    
    /// @custom:selector    0x9e165a78
    /// @custom:signature   Unresolved_9e165a78() public view returns (bytes memory)
    function Unresolved_9e165a78() public view returns (bytes memory) {
        return abi.encodePacked(0x20, var_f);
    }
    
    /// @custom:selector    0x9f273fbc
    /// @custom:signature   Unresolved_9f273fbc(uint256 arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_9f273fbc(uint256 arg0, address arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg0] << 0x05) + 0x20 + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg0] << 0x05) + 0x20 + 0x1f) > 0xffffffffffffffff)) {
            if (0x20 + (0x04 + arg0) >= 0x20 + (0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05))) {
                require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
                if (0 < var_c && 0 < var_c) {
                    if (storage_map_k[address(var_e)]) {
                        if (0 < var_c) {
                            emit Event_6df04710(address(var_e), 0x01);
                        }
                    } else {
                        store_p += 0x01;
                        store_p[store_p] = address(var_e);
                        storage_map_k[address(var_e)] = store_p;
                    }
                }
            } else {
                require(msg.data[0x20 + (0x04 + arg0)] == address(msg.data[0x20 + (0x04 + arg0)]));
            }
        }
    }
    
    /// @custom:selector    0xa07aea1c
    /// @custom:signature   Unresolved_a07aea1c(uint256 arg0, address arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_a07aea1c(uint256 arg0, address arg1) public view {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if (0 >= msg.data[0x04 + arg0]) {
            if (0 >= msg.data[0x04 + arg0]) {
                emit OperatorsAdded(0x20, msg.data[0x04 + arg0]);
            } else {
                require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
            }
        } else {
            if (0 < msg.data[0x04 + arg0]) {
                require(0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20);
                require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
            }
        }
    }
    
    /// @custom:selector    0xa908183d
    /// @custom:signature   Unresolved_a908183d(uint256 arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_a908183d(uint256 arg0, address arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg0] << 0x05) + 0x20 + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg0] << 0x05) + 0x20 + 0x1f) > 0xffffffffffffffff)) {
            if (0x20 + (0x04 + arg0) >= 0x20 + (0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05))) {
                require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
                if (0 < var_c && 0 < var_c) {
                    if (storage_map_n[address(var_e)]) {
                        if (0 < var_c) {
                            emit Event_a30b4a30(address(var_e), 0x01);
                        }
                    } else {
                        store_i += 0x01;
                        store_i[store_i] = address(var_e);
                        storage_map_n[address(var_e)] = store_i;
                    }
                }
            } else {
                require(msg.data[0x20 + (0x04 + arg0)] == address(msg.data[0x20 + (0x04 + arg0)]));
            }
        }
    }
    
    /// @custom:selector    0xab06e403
    /// @custom:signature   Unresolved_ab06e403(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_ab06e403(address arg0, uint256 arg1) public payable {
        require(true);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        payable(address(arg0)).transfer(msg.value);
        require(success);
    }
    
    /// @custom:selector    0xb9f9fc41
    /// @custom:signature   Unresolved_b9f9fc41(uint256 arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_b9f9fc41(uint256 arg0, address arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg0] << 0x05) + 0x20 + 0x1f) < var_a | var_a + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & (msg.data[0x04 + arg0] << 0x05) + 0x20 + 0x1f) > 0xffffffffffffffff)) {
            if (0x20 + (0x04 + arg0) >= 0x20 + (0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05))) {
                require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
                if (0 < var_c && (0 < var_c && storage_map_k[address(var_e)] && (storage_map_k[address(var_e)] >= 0x01 && (store_p >= 0x01 && (store_p - 0x01 < store_p && storage_map_k[address(var_e)] - 0x01 < store_p))))) {
                    store_p[storage_map_k[address(var_e)] - 0x01] = store_p[store_p - 0x01];
                    storage_map_k[store_p[store_p - 0x01]] = storage_map_k[store_p[store_p - 0x01]];
                    if (store_p) {
                        store_p[store_p - 0x01] = 0;
                        store_p -= 0x01;
                        storage_map_k[address(var_e)] = 0;
                    }
                }
            } else {
                require(msg.data[0x20 + (0x04 + arg0)] == address(msg.data[0x20 + (0x04 + arg0)]));
            }
        }
    }
    
    /// @custom:selector    0xd365a377
    /// @custom:signature   Unresolved_d365a377(uint256 arg0, address arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_d365a377(uint256 arg0, address arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if (0 >= msg.data[0x04 + arg0]) {
            if (0 >= msg.data[0x04 + arg0]) {
                emit OperatorsRemoved(0x20, msg.data[0x04 + arg0]);
            } else {
                require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
            }
        } else {
            if (0 < msg.data[0x04 + arg0]) {
                require(0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20);
                require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
                if (storage_map_a[address(msg.data[0x04 + arg0 + 0x20])] >= 0x01 && (store_e >= 0x01 && (store_e - 0x01 < store_e && storage_map_a[address(msg.data[0x04 + arg0 + 0x20])] - 0x01 < store_e))) {
                    store_e[storage_map_a[address(msg.data[0x04 + arg0 + 0x20])] - 0x01] = store_e[store_e - 0x01];
                    storage_map_a[store_e[store_e - 0x01]] = storage_map_a[store_e[store_e - 0x01]];
                    if (store_e) {
                        store_e[store_e - 0x01] = 0;
                        store_e -= 0x01;
                        storage_map_a[address(msg.data[0x04 + arg0 + 0x20])] = 0;
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xe3fa62d6
    /// @custom:signature   Unresolved_e3fa62d6(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_e3fa62d6(address arg0) public view returns (bool) {
        require(true);
        return storage_map_g[arg0];
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        require(arg0, "Ownable: new owner is the zero address");
        store_m = arg0 | store_m & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
    }
}