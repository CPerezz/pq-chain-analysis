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
    bytes32 store_o; // storage slot: 0x00
    uint8 store_p; // storage slot: 0x00
    address public unresolved_8da5cb5b; // storage slot: 0x33
    bytes32 store_n; // storage slot: 0x33
    uint256 store_i; // storage slot: 0x65
    address public unresolved_3fc8cef3; // storage slot: 0x97
    bytes32 store_q; // storage slot: 0x97
    uint256 public feeRate; // storage slot: 0x98
    address store_l; // storage slot: 0x99
    bytes32 store_d; // storage slot: 0x99
    address store_m; // storage slot: 0x9a
    bytes32 store_h; // storage slot: 0x9a
    address public approveProxy; // storage slot: 0x9d
    bytes32 store_g; // storage slot: 0x9d
    address public payer; // storage slot: 0x9e
    bytes32 store_j; // storage slot: 0x9e
    
    mapping(address => uint8) storage_map_f; // storage slot: 0x9b
    mapping(address => uint8) storage_map_r; // storage slot: 0x9c
    
    event Event_6ca211be();
    event Event_73791a45();
    event Event_7f26b83f();
    event Event_8be0079c();
    event FeeCollect(address, uint256);
    event SetFeeRate(uint256);
    event SetFeeReceiver(address);
    event SetOperator(address);
    event TokenTransfer(address, address, uint256);
    
    /// @custom:selector    0xaffca932
    /// @custom:signature   changeFeeRate(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function changeFeeRate(uint256 arg0) public {
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if (arg0 <= 0x64) {
            feeRate = arg0;
            emit SetFeeRate(arg0);
        } else {
            if (0 >= var_g) {
                revert("\0\0");
            } else {
                revert("OL");
            }
        }
    }
    
    /// @custom:selector    0x7c08b964
    /// @custom:signature   changeFeeReceiver(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function changeFeeReceiver(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if (arg0) {
            store_d = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_d;
            emit SetFeeReceiver(arg0);
        } else {
            if (0 >= var_g) {
                revert("\0\0\0");
            } else {
                revert("ZAD");
            }
        }
    }
    
    /// @custom:selector    0xc9dc160c
    /// @custom:signature   registeredAdapters(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function registeredAdapters(address arg0) public view returns (bool) {
        require(true);
        return storage_map_f[arg0].field_0;
    }
    
    /// @custom:selector    0xaad0ae5b
    /// @custom:signature   setApproveProxy(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setApproveProxy(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if (arg0) {
            store_g = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_g;
            emit Event_73791a45(arg0);
        } else {
            if (0 >= var_g) {
                revert("\0\0\0");
            } else {
                revert("ZAD");
            }
        }
    }
    
    /// @custom:selector    0xb3ab15fb
    /// @custom:signature   setOperator(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function setOperator(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if (arg0) {
            store_h = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_h;
            emit SetOperator(arg0);
        } else {
            if (0 >= var_g) {
                revert("\0\0\0");
            } else {
                revert("ZAD");
            }
        }
    }
    
    /// @custom:selector    0x016cba5f
    /// @custom:signature   Unresolved_016cba5f(uint256 arg0, uint256 arg1, uint256 arg2, address arg3) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_016cba5f(uint256 arg0, uint256 arg1, uint256 arg2, address arg3) public payable {
        require(arg0 <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(store_i != 0x02, "ReentrancyGuard: reentrant call");
        store_i = 0x02;
        store_j = msg.sender | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_j;
        if (!uint8(store_j / 0x010000000000000000000000000000000000000000)) {
            require(msg.data[0x04 + arg0] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0]] <= 0xffffffffffffffff);
            require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) <= msg.data.length - msg.data[0x04 + arg0 + msg.data[0x04 + arg0]] * 0x60);
            if (0 >= msg.data[0x04 + arg0 + msg.data[0x04 + arg0]]) {
                require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] <= 0xffffffffffffffff);
                require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] << 0x06));
                if (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] <= 0xffffffffffffffff) {
                    uint256 var_a = 0x40 + var_a;
                    if (0 >= msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]]) {
                        if (0 >= msg.data[0x04 + arg1]) {
                            require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                            require(msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] <= 0xffffffffffffffff);
                            require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]) <= msg.data.length - (msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]] << 0x06));
                            if (0 >= msg.data[0x04 + arg0 + msg.data[0x04 + arg0 + 0x20]]) {
                                store_j = 0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_j;
                                store_i = 0x01;
                            }
                        } else {
                            if (0 < msg.data[0x04 + arg1]) {
                                require(msg.data[0x04 + arg1 + 0x20] < msg.data.length - (0x04 + arg1 + 0x20) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc1);
                            }
                        }
                    }
                }
            } else {
                if (0 < msg.data[0x04 + arg0 + msg.data[0x04 + arg0]]) {
                    require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) + 0x20 - (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0])) >= 0x20);
                    require(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0])] == address(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0])]));
                    require(0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) + 0x60 - (0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) + 0x40) >= 0x20);
                    require(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) + 0x40] == address(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) + 0x40]));
                    emit TokenTransfer(msg.sender, address(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0])]), msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) + 0x20]);
                    if (0xeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee != address(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0])])) {
                        address var_l = var_m;
                        require(address(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0])]).code.length);
                        (bool success, bytes memory ret0) = address(address(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0])])).Unresolved_70a08231(var_l, var_m); // staticcall
                        require(success);
                        uint256 var_a = var_a + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                        require(var_a + ret0.length - var_a >= 0x20);
                    } else {
                        if (!(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) + 0x20] & feeRate > type(uint256).max / msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) + 0x20])) {
                            if (!(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) + 0x20] * feeRate / 0x2710)) {
                                require(unresolved_3fc8cef3.code.length);
                            } else {
                                payable(address(store_l)).transfer(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) + 0x20] * feeRate / 0x2710);
                                if (ret0.length != 0) {
                                    uint256 var_a = 0x40 + var_a;
                                }
                                uint256 var_a = 0x40 + var_a;
                                if (address(this).balance >= 0) {
                                    revert("Address: call to non-contract");
                                } else {
                                    revert("Address: insufficient balance for call");
                                }
                                uint256 var_q = msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) + 0x20] * feeRate / 0x2710;
                                require(approveProxy.code.length);
                                (bool success, bytes memory ret0) = address(approveProxy).Unresolved_0a5ea466{ value: 0 }(0, msg.sender, store_l, var_q); // call
                                require(success);
                                if (msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) + 0x20] >= msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) + 0x20] * feeRate / 0x2710) {
                                    emit FeeCollect(0, var_q);
                                    require(unresolved_3fc8cef3.code.length);
                                    (bool success, bytes memory ret0) = address(unresolved_3fc8cef3).Unresolved_d0e30db0{ value: msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) + 0x20] - var_q }(0); // call
                                    require(success);
                                    if (unresolved_3fc8cef3) {
                                        require(address(this).balance >= 0, "Address: insufficient balance for call");
                                        require(unresolved_3fc8cef3.code.length, "Address: call to non-contract");
                                        (bool success, bytes memory ret0) = address(unresolved_3fc8cef3).Unresolved_08c379a0{ value: 0 }(0x20); // call
                                        if (ret0.length == 0) {
                                            if (!success) {
                                                require(!var_x);
                                                require(0 < var_i, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0");
                                            } else {
                                                if (0x80 + var_x - 0x80 >= 0x20) {
                                                    require(0x03, "SafeERC20: ERC20 operation did not succeed");
                                                }
                                                revert();
                                            }
                                        } else {
                                            require(success);
                                        }
                                    } else {
                                        payable(address(address(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) + 0x40]))).transfer(msg.data[0x20 + (0x04 + arg0 + msg.data[0x04 + arg0]) + 0x20] - 0x20);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        } else {
            if (0 >= var_i) {
                revert("\0\0\0");
            } else {
                revert("VCL");
            }
        }
    }
    
    /// @custom:selector    0x0a9aa6a9
    /// @custom:signature   Unresolved_0a9aa6a9() public view returns (bool)
    function Unresolved_0a9aa6a9() public view returns (bool) {
        return uint8(store_j / 0x010000000000000000000000000000000000000000);
    }
    
    /// @custom:selector    0x18fbae63
    /// @custom:signature   Unresolved_18fbae63(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_18fbae63(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x21afdeee
    /// @custom:signature   Unresolved_21afdeee(uint256 arg0) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_21afdeee(uint256 arg0) public {
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        store_j = store_j & 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff | 0x010000000000000000000000000000000000000000 * arg0;
        emit Event_6ca211be(arg0);
    }
    
    /// @custom:selector    0x41259ad0
    /// @custom:signature   Unresolved_41259ad0(uint256 arg0, uint256 arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_41259ad0(uint256 arg0, uint256 arg1) public view {
        if (!msg.value && (arg0 <= 0xffffffffffffffff && msg.data[0x04 + arg0] <= 0xffffffffffffffff)) {
            require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
            if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
                require(0x04 + arg0 + 0x20 + 0x20 - (0x04 + arg0 + 0x20) >= 0x20);
                require(msg.data[0x04 + arg0 + 0x20] == address(msg.data[0x04 + arg0 + 0x20]));
            }
        }
        revert();
    }
    
    /// @custom:selector    0x570ca735
    /// @custom:signature   Unresolved_570ca735() public view returns (address)
    function Unresolved_570ca735() public view returns (address) {
        return store_m;
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public
    function Unresolved_715018a6() public {
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        store_n = store_n & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
    }
    
    /// @custom:selector    0xb3f00674
    /// @custom:signature   Unresolved_b3f00674() public view returns (address)
    function Unresolved_b3f00674() public view returns (address) {
        return store_l;
    }
    
    /// @custom:selector    0xc4d66de8
    /// @custom:signature   Unresolved_c4d66de8(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_c4d66de8(address arg0) public {
        require(true);
        require(uint8(store_o / 0x0100), "Initializable: contract is already initialized");
        require(0x01 == store_p, "Initializable: contract is already initialized");
        store_o = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & store_o;
        if (uint8(store_o / 0x0100)) {
            require(uint8(store_o / 0x0100), "Initializable: contract is not initializing");
            require(uint8(store_o / 0x0100), "Initializable: contract is not initializing");
            store_n = msg.sender | store_n & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
            emit Event_8be0079c(unresolved_8da5cb5b, msg.sender);
            require(uint8(store_o / 0x0100), "Initializable: contract is not initializing");
            require(uint8(store_o / 0x0100), "Initializable: contract is not initializing");
            store_i = 0x01;
            store_q = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_q;
            if (!uint8(store_o / 0x0100)) {
                store_o = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff & store_o;
                emit Event_7f26b83f(0x01);
            }
        } else {
            store_o = 0x0100 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff & store_o;
            if (uint8(store_o / 0x0100) && uint8(store_o / 0x0100)) {
                store_n = msg.sender | store_n & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
                emit Event_8be0079c(unresolved_8da5cb5b, msg.sender);
            }
            revert("Initializable: contract is not initializing");
        }
    }
    
    /// @custom:selector    0xec5b999d
    /// @custom:signature   Unresolved_ec5b999d(uint256 arg0, uint256 arg1, uint256 arg2) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_ec5b999d(uint256 arg0, uint256 arg1, uint256 arg2) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(arg2 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        require(arg0, "Ownable: new owner is the zero address");
        store_n = arg0 | store_n & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
    }
    
    /// @custom:selector    0xf4c63566
    /// @custom:signature   Unresolved_f4c63566(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f4c63566(address arg0) public view returns (bool) {
        require(true);
        return storage_map_r[arg0].field_0;
    }
}