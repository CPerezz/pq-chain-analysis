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
    uint256 public constant unresolved_3fc8cef3 = 1097077688018008265106216665536940668749033598146;
    
    bytes32 store_i; // storage slot: 0x00
    uint8 store_h; // storage slot: 0x00
    address public unresolved_8da5cb5b; // storage slot: 0x33
    bytes32 store_l; // storage slot: 0x33
    uint256 public numberOperators; // storage slot: 0x65
    address public unresolved_61acbdcb; // storage slot: 0x9a
    bytes32 store_k; // storage slot: 0x9a
    bytes store_o; // storage slot: 0x9b
    bytes store_f; // storage slot: 0x9d
    bytes32[] store_e; // storage slot: 0xa1
    
    mapping(address => bytes32) storage_map_a; // storage slot: 0x66
    mapping(address => bytes32) storage_map_g; // storage slot: 0x9c
    mapping(address => bytes32) storage_map_n; // storage slot: 0x9e
    mapping(bytes32 => address) storage_map_m; // storage slot: 0xa0
    mapping(address => bytes32) storage_map_d; // storage slot: 0xa2
    
    event Event_1886ee5e();
    event Event_8be0079c();
    event Event_b0f5cdd7();
    event OperatorsAdded(address[]);
    event OperatorsRemoved(address[]);
    event WithdrawFunds(address, uint256, address);
    
    /// @custom:selector    0xf00baf3e
    /// @custom:signature   convertETH(uint256 arg0) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function convertETH(uint256 arg0) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(storage_map_a[msg.sender], "caller is not operator");
        require(address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).code.length);
        (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).Unresolved_d0e30db0{ value: arg0 }(0x20); // call
        require(success);
        if (!success) {
            return ;
        }
    }
    
    /// @custom:selector    0x95ccea67
    /// @custom:signature   emergencyWithdraw(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function emergencyWithdraw(address arg0, uint256 arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(unresolved_8da5cb5b == msg.sender, "Ownable: caller is not the owner");
        uint256 var_a = var_f + 0x64 - var_f + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0;
        if (!(var_f + (var_f + 0x64 - var_f + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_f + (var_f + 0x64 - var_f + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_f)) {
            uint256 var_f = var_f + (var_f + 0x64 - var_f + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            if (!(var_f + 0x40 > 0xffffffffffffffff | var_f + 0x40 < var_f)) {
                uint256 var_f = var_f + 0x40;
                require(arg0.code.length, "Address: call to non-contract");
                (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb(unresolved_8da5cb5b); // call
                if (!ret0.length) {
                    if (!success) {
                        require(var_o, "SafeERC20: low-level call failed");
                    } else {
                        if (var_o) {
                            require(0x60 + var_o + 0x20 - 0x80 >= 0x20);
                            require(!(var_a - var_a));
                            require(var_a, "SafeERC20: ERC20 operation did not succeed");
                        }
                    }
                } else {
                    if (ret0.length <= 0xffffffffffffffff && (!(var_f + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_f + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_f) && !success)) {
                        require(var_p, "SafeERC20: low-level call failed");
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xd911c632
    /// @custom:signature   getAllOperators() public view
    function getAllOperators() public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
    }
    
    /// @custom:selector    0x6d70f7ae
    /// @custom:signature   isOperator(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function isOperator(address arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_a[arg0];
        return var_c;
    }
    
    /// @custom:selector    0x26142335
    /// @custom:signature   operatorAt(uint256 arg0) public view returns (address)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function operatorAt(uint256 arg0) public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        if (arg0 < numberOperators) {
            var_c = numberOperators[arg0].field_0;
            return var_c;
        }
    }
    
    /// @custom:selector    0x34efb1e9
    /// @custom:signature   setAllowance(address[] arg0, address arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function setAllowance(address[] arg0, address arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(!(arg1 - arg1));
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
            require(!(address(msg.data[0x04 + arg0 + 0x20]) - msg.data[0x04 + arg0 + 0x20]));
            (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg0 + 0x20])).Unresolved_dd62ed3e(address(this)); // staticcall
            require(success);
            if (!success) {
                uint256 var_a = var_h + 0x64 - var_h + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0;
                if (!(var_h + (var_h + 0x64 - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_h + (var_h + 0x64 - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_h)) {
                    uint256 var_h = var_h + (var_h + 0x64 - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                    if (!(var_h + 0x40 > 0xffffffffffffffff | var_h + 0x40 < var_h)) {
                        uint256 var_h = var_h + 0x40;
                        require(address(msg.data[0x04 + arg0 + 0x20]).code.length, "Address: call to non-contract");
                        (bool success, bytes memory ret0) = address(address(msg.data[0x04 + arg0 + 0x20])).Unresolved_095ea7b3(arg1); // call
                        if (!ret0.length) {
                            if (!success) {
                                require(var_o, "SafeERC20: low-level call failed");
                            } else {
                                require(0x60 + var_o + 0x20 - 0x80 >= 0x20);
                                require(var_a - var_a, "SafeERC20: ERC20 operation did not succeed");
                            }
                        } else {
                            if (ret0.length <= 0xffffffffffffffff && (!(var_h + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_h + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + ret0.length) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_h) && !success)) {
                                require(var_p, "SafeERC20: low-level call failed");
                            }
                        }
                    }
                }
                revert("SafeERC20: approve from non-zero to non-zero allowance");
            }
        }
    }
    
    /// @custom:selector    0x0eb9142f
    /// @custom:signature   Unresolved_0eb9142f(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_0eb9142f(address arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if (!storage_map_d[arg0] && store_e < 0x010000000000000000) {
            store_e += 0x01;
            if (store_e < store_e) {
                store_e[store_e] = 0 & store_e[store_e] | 0x08c379a000000000000000000000000000000000000000000000000000000000;
                storage_map_d[0x08c379a000000000000000000000000000000000000000000000000000000000] = store_e;
                emit Event_1886ee5e(arg0);
            }
        }
    }
    
    /// @custom:selector    0x14b7c124
    /// @custom:signature   Unresolved_14b7c124() public view returns (bytes memory)
    function Unresolved_14b7c124() public view returns (bytes memory) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (!(var_c + (var_c + 0x20 - var_c + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (var_c + 0x20 - var_c + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            return abi.encodePacked(0x20, var_g);
        }
    }
    
    /// @custom:selector    0x1626ba7e
    /// @custom:signature   Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public pure {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg1 <= 0xffffffffffffffff);
        require(arg1 + 0x23 < msg.data.length);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            require(arg1 + 0x24 + msg.data[0x04 + arg1] > msg.data.length);
        }
    }
    
    /// @custom:selector    0x388bb62c
    /// @custom:signature   Unresolved_388bb62c(uint256 arg0, uint32 arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint32", "bytes4", "int32"]
    function Unresolved_388bb62c(uint256 arg0, uint32 arg1) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg0 <= 0xffffffffffffffff);
        require(arg0 + 0x23 < msg.data.length);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + (0x20 + (var_d << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x24 <= msg.data.length);
            if (0x24 + arg0 < arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x24) {
                require((msg.data[0x24 + arg0] & 0xffffffff00000000000000000000000000000000000000000000000000000000) - msg.data[0x24 + arg0]);
            } else {
                require(arg1 <= 0xffffffffffffffff);
                if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
                    if (0x20 + (0x04 + arg1) < 0x04 + arg1 + (msg.data[0x04 + arg1] << 0x05) + 0x20) {
                        require(address(msg.data[0x20 + (0x04 + arg1)]) - msg.data[0x20 + (0x04 + arg1)]);
                    } else {
                        if (msg.sender != unresolved_8da5cb5b) {
                            revert("Ownable: caller is not the owner");
                        } else {
                            revert("Executor: invalid length");
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
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg0 <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(storage_map_g[msg.sender], "Only forwarder allow");
        require(!(msg.data[0x04 + arg0 + 0x20] - uint128(msg.data[0x04 + arg0 + 0x20])));
        require(uint128(msg.data[0x04 + arg0 + 0x20]) >= block.timestamp, "Signature expired");
        require(!(address(msg.data[0x04 + arg0]) - msg.data[0x04 + arg0]));
        require(address(msg.data[0x04 + arg0]) == msg.sender, "Incorrect sender");
        require(msg.data[0x04 + arg0 + 0x60] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] << 0x05));
        uint256 var_h = msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]];
        if (0 < msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]]) {
            require(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] < msg.data.length - (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc1);
            require(!(address(msg.data[msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]))]) - msg.data[msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]))]));
            require(msg.data[msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])) + 0x20] < msg.data.length - (msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]))) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[msg.data[msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])) + 0x20] + (msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])))] <= 0xffffffffffffffff);
            require(msg.data[msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])) + 0x20] + (msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]))) + 0x20 > msg.data.length - msg.data[msg.data[msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])) + 0x20] + (msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])))]);
        }
    }
    
    /// @custom:selector    0x567aa1ba
    /// @custom:signature   Unresolved_567aa1ba(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_567aa1ba(address arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(0 != store_h, "Initializable: contract is already initialized");
        require(!address(this).code.length, "Initializable: contract is already initialized");
        if (!store_h) {
            store_i = store_i & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff | 0x0100;
            store_i = store_i & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
        }
        revert("Initializable: contract is not initializing");
    }
    
    /// @custom:selector    0x61bb41a7
    /// @custom:signature   Unresolved_61bb41a7(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_61bb41a7(address arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        store_k = store_k & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | 0x08c379a000000000000000000000000000000000000000000000000000000000;
        emit Event_b0f5cdd7(arg0);
    }
    
    /// @custom:selector    0x69328dec
    /// @custom:signature   Unresolved_69328dec(address arg0, uint256 arg1, address arg2) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_69328dec(address arg0, uint256 arg1, address arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(!(arg0 - arg0));
        require(!(arg2 - arg2));
        require(storage_map_a[msg.sender], "caller is not operator");
        require(storage_map_d[arg2], "destination is not approved");
        if (0 == (arg0 == 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee)) {
            payable(address(arg2)).transfer(arg1);
            if (!ret0.length) {
                require(success, "transfer failed");
                emit WithdrawFunds(arg0, arg2, arg1);
            }
        } else {
            require(address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).code.length);
            (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).Unresolved_2e1a7d4d(arg1); // call
            require(success);
            payable(address(arg2)).transfer(arg1);
            if (!ret0.length) {
                require(success, "withdraw eth failed");
                emit WithdrawFunds(arg0, arg2, arg1);
            }
        }
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public payable
    function Unresolved_715018a6() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        store_l = store_l & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
    }
    
    /// @custom:selector    0x7d6a4568
    /// @custom:signature   Unresolved_7d6a4568(uint32 arg0) public view returns (address)
    /// @param              arg0 ["uint32", "bytes4", "int32"]
    function Unresolved_7d6a4568(uint32 arg0) public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!((arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000) - arg0));
        var_c = storage_map_m[arg0 & 0xffffffff00000000000000000000000000000000000000000000000000000000].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x7dadbe8c
    /// @custom:signature   Unresolved_7dadbe8c(uint256 arg0, address arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_7dadbe8c(uint256 arg0, address arg1) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            if (0x20 + (0x04 + arg0) < 0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x20) {
                require(address(msg.data[0x20 + (0x04 + arg0)]) - msg.data[0x20 + (0x04 + arg0)]);
            } else {
                require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
            }
        }
    }
    
    /// @custom:selector    0x8594ac40
    /// @custom:signature   Unresolved_8594ac40(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_8594ac40(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg0 <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(storage_map_g[msg.sender], "Only forwarder allow");
        require(!(msg.data[0x04 + arg0 + 0x20] - uint128(msg.data[0x04 + arg0 + 0x20])));
        require(uint128(msg.data[0x04 + arg0 + 0x20]) >= block.timestamp, "Signature expired");
        require(!(address(msg.data[0x04 + arg0]) - msg.data[0x04 + arg0]));
        require(address(msg.data[0x04 + arg0]) == msg.sender, "Incorrect sender");
        require(msg.data[0x04 + arg0 + 0x60] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
        require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] <= 0xffffffffffffffff);
        require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]] << 0x05));
        uint256 var_h = msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]];
        if (0 < msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]]) {
            require(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] < msg.data.length - (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffa1);
            require(!(address(msg.data[msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]))]) - msg.data[msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]))]));
            require(msg.data[msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])) + 0x40] < msg.data.length - (msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]))) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[msg.data[msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])) + 0x40] + (msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])))] <= 0xffffffffffffffff);
            require(msg.data[msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])) + 0x40] + (msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60]))) + 0x20 > msg.data.length - msg.data[msg.data[msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])) + 0x40] + (msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])] + (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x60])))]);
        }
    }
    
    /// @custom:selector    0x9e165a78
    /// @custom:signature   Unresolved_9e165a78() public view returns (bytes memory)
    function Unresolved_9e165a78() public view returns (bytes memory) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        if (!(var_c + (var_c + 0x20 - var_c + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (var_c + 0x20 - var_c + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            return abi.encodePacked(0x20, var_g);
        }
    }
    
    /// @custom:selector    0x9f273fbc
    /// @custom:signature   Unresolved_9f273fbc(uint256 arg0, address arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_9f273fbc(uint256 arg0, address arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            if (0x20 + (0x04 + arg0) < 0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x20) {
                require(address(msg.data[0x20 + (0x04 + arg0)]) - msg.data[0x20 + (0x04 + arg0)]);
            } else {
                require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
                if (0 < var_i && (0 < var_i && (!storage_map_g[address(var_j)] && store_o < 0x010000000000000000))) {
                    store_o += 0x01;
                    if (store_o < store_o) {
                        store_o[store_o] = 0 & store_o[store_o] | address(var_j);
                        storage_map_g[address(var_j)] = store_o;
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xa07aea1c
    /// @custom:signature   Unresolved_a07aea1c(uint256 arg0, address arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_a07aea1c(uint256 arg0, address arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if (0 < msg.data[0x04 + arg0]) {
            if (0 < msg.data[0x04 + arg0]) {
                require(!(address(msg.data[0x04 + arg0 + 0x20]) - msg.data[0x04 + arg0 + 0x20]));
                if (numberOperators < 0x010000000000000000) {
                    numberOperators += 0x01;
                }
            }
        } else {
            uint256 var_h = msg.data[0x04 + arg0];
            if (0 < msg.data[0x04 + arg0]) {
                require(address(msg.data[0x04 + arg0 + 0x20]) - msg.data[0x04 + arg0 + 0x20]);
            } else {
                emit OperatorsAdded(0x20, var_h);
            }
        }
    }
    
    /// @custom:selector    0xa908183d
    /// @custom:signature   Unresolved_a908183d(uint256 arg0, address arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_a908183d(uint256 arg0, address arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            if (0x20 + (0x04 + arg0) < 0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x20) {
                require(address(msg.data[0x20 + (0x04 + arg0)]) - msg.data[0x20 + (0x04 + arg0)]);
            } else {
                require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
                if (0 < var_i && (0 < var_i && (!storage_map_n[address(var_j)] && store_f < 0x010000000000000000))) {
                    store_f += 0x01;
                    if (store_f < store_f) {
                        store_f[store_f] = 0 & store_f[store_f] | address(var_j);
                        storage_map_n[address(var_j)] = store_f;
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xab06e403
    /// @custom:signature   Unresolved_ab06e403(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_ab06e403(address arg0, uint256 arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        payable(address(arg0)).transfer(msg.value);
        require(success);
    }
    
    /// @custom:selector    0xaf38bf11
    /// @custom:signature   Unresolved_af38bf11(uint256 arg0, uint32 arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint32", "bytes4", "int32"]
    function Unresolved_af38bf11(uint256 arg0, uint32 arg1) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg0 <= 0xffffffffffffffff);
        require(arg0 + 0x23 < msg.data.length);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + (0x20 + (var_d << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x24 <= msg.data.length);
            if (0x24 + arg0 < arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x24) {
                require((msg.data[0x24 + arg0] & 0xffffffff00000000000000000000000000000000000000000000000000000000) - msg.data[0x24 + arg0]);
            } else {
                require(arg1 <= 0xffffffffffffffff);
                if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
                    if (0x20 + (0x04 + arg1) < 0x04 + arg1 + (msg.data[0x04 + arg1] << 0x05) + 0x20) {
                        require(address(msg.data[0x20 + (0x04 + arg1)]) - msg.data[0x20 + (0x04 + arg1)]);
                    } else {
                        if (msg.sender != unresolved_8da5cb5b) {
                            revert("Ownable: caller is not the owner");
                        } else {
                            revert("Executor: invalid length");
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xb9f9fc41
    /// @custom:signature   Unresolved_b9f9fc41(uint256 arg0, address arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_b9f9fc41(uint256 arg0, address arg1) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            if (0x20 + (0x04 + arg0) < 0x04 + arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x20) {
                require(address(msg.data[0x20 + (0x04 + arg0)]) - msg.data[0x20 + (0x04 + arg0)]);
            } else {
                require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
            }
        }
    }
    
    /// @custom:selector    0xd365a377
    /// @custom:signature   Unresolved_d365a377(uint256 arg0, address arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_d365a377(uint256 arg0, address arg1) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg0] << 0x05) + (0x04 + arg0) + 0x20 <= msg.data.length);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if (0 < msg.data[0x04 + arg0]) {
            if (0 < msg.data[0x04 + arg0]) {
                require(!(address(msg.data[0x04 + arg0 + 0x20]) - msg.data[0x04 + arg0 + 0x20]));
            }
        } else {
            uint256 var_h = msg.data[0x04 + arg0];
            if (0 < msg.data[0x04 + arg0]) {
                require(address(msg.data[0x04 + arg0 + 0x20]) - msg.data[0x04 + arg0 + 0x20]);
            } else {
                emit OperatorsRemoved(0x20, var_h);
            }
        }
    }
    
    /// @custom:selector    0xe3fa62d6
    /// @custom:signature   Unresolved_e3fa62d6(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_e3fa62d6(address arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_d[arg0];
        return var_c;
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        require(arg0, "Ownable: new owner is the zero address");
        store_l = store_l & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
    }
}