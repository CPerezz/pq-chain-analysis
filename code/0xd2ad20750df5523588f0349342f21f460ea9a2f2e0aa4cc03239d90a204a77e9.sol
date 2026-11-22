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
    address public unresolved_8da5cb5b; // storage slot: 0x00
    bytes32 store_p; // storage slot: 0x00
    address public unresolved_e73c35eb; // storage slot: 0x01
    bytes32 store_q; // storage slot: 0x01
    address public unresolved_cfc22f21; // storage slot: 0x02
    bytes32 store_s; // storage slot: 0x02
    address public unresolved_37177b6d; // storage slot: 0x03
    bytes32 store_t; // storage slot: 0x03
    address public unresolved_0f974f90; // storage slot: 0x04
    bytes32 store_u; // storage slot: 0x04
    address public unresolved_9bcc983d; // storage slot: 0x05
    bytes32 store_v; // storage slot: 0x05
    address store_x; // storage slot: 0x06
    bytes32 store_w; // storage slot: 0x06
    address public executor0; // storage slot: 0x07
    bytes32 store_k; // storage slot: 0x07
    address public executor1; // storage slot: 0x08
    bytes32 store_l; // storage slot: 0x08
    address public executor2; // storage slot: 0x09
    bytes32 store_m; // storage slot: 0x09
    address store_r; // storage slot: 0x0a
    bytes32 store_n; // storage slot: 0x0a
    address public unresolved_761f3757; // storage slot: 0x0b
    bytes32 store_o; // storage slot: 0x0b
    
    error CustomError_00000000();
    
    /// @custom:selector    0xbc157ac1
    /// @custom:signature   deposit(uint256 arg0, address arg1, uint256 arg2) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function deposit(uint256 arg0, address arg1, uint256 arg2) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x60);
        require(!(arg1 - arg1));
        require(!(msg.sender - unresolved_761f3757), CustomError_1f6078af());
        if (!arg0) {
            (bool success, bytes memory ret0) = address(arg1).Unresolved_a9059cbb{ value: 0 }(unresolved_cfc22f21); // call
            revert CustomError_fb7f5079();
        } else {
            (bool success, bytes memory ret0) = address(arg1).Unresolved_a9059cbb{ value: 0 }(unresolved_37177b6d); // call
            require(!success, CustomError_fb7f5079());
            require(success, CustomError_fb7f5079());
            (bool success, bytes memory ret0) = address(arg1).Unresolved_a9059cbb{ value: 0 }(unresolved_0f974f90); // call
            require(!success, CustomError_fb7f5079());
            require(success, CustomError_fb7f5079());
            (bool success, bytes memory ret0) = address(arg1).Unresolved_a9059cbb{ value: 0 }(unresolved_9bcc983d); // call
            require(!success, CustomError_fb7f5079());
            require(success, CustomError_fb7f5079());
            return ;
        }
    }
    
    /// @custom:selector    0x66dd0f24
    /// @custom:signature   depositWETH(uint256 arg0) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function depositWETH(uint256 arg0) public payable returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(msg.sender - unresolved_761f3757), CustomError_1f6078af());
        require(address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).code.length);
        (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).Unresolved_d0e30db0{ value: arg0 }(var_b); // call
        require(success);
        if (success) {
            if (var_c <= 0xffffffffffffffff) {
                return ;
            }
        } else {
            return ;
        }
    }
    
    /// @custom:selector    0xc37874cb
    /// @custom:signature   setExecutor(uint256 arg0, address arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function setExecutor(uint256 arg0, address arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg1 - arg1));
        if (msg.sender - unresolved_8da5cb5b) {
            require(!(msg.sender - unresolved_e73c35eb), CustomError_1f6078af());
        }
        if (!arg0) {
            store_k = store_k & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg1;
        } else {
            if (arg0 == 0x01) {
                store_l = store_l & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg1;
            } else {
                if (arg0 == 0x02) {
                    store_m = store_m & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg1;
                } else {
                    if (arg0 == 0x03) {
                        store_n = store_n & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg1;
                    } else {
                        if (0x04 == arg0) {
                            store_o = store_o & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg1;
                        }
                    }
                }
            }
        }
        return ;
    }
    
    /// @custom:selector    0x299a7bcc
    /// @custom:signature   setOwner(address arg0, address arg1) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function setOwner(address arg0, address arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        if (msg.sender - unresolved_8da5cb5b) {
            require(!(msg.sender - unresolved_e73c35eb), CustomError_1f6078af());
        }
        store_p = store_p & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        store_q = store_q & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg1;
        return ;
    }
    
    /// @custom:selector    0x1626ba7e
    /// @custom:signature   Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_1626ba7e(uint256 arg0, uint256 arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg1 <= 0xffffffffffffffff);
        require(arg1 + 0x23 < msg.data.length);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg1] + 0x1f) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg1] + 0x1f) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_d = msg.data[0x04 + arg1];
            require(arg1 + msg.data[0x04 + arg1] + 0x24 <= msg.data.length);
            uint256 var_e = msg.data[arg1 + 0x24:arg1 + 0x24 + var_d];
            if (var_g > 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0) {
                require(0x03 >= 0x04, CustomError_d78bce0c());
            } else {
                require(memory[0x20]);
            }
        }
    }
    
    /// @custom:selector    0x480fbe3b
    /// @custom:signature   Unresolved_480fbe3b() public view returns (address)
    function Unresolved_480fbe3b() public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_r;
    }
    
    /// @custom:selector    0x5ecb16cd
    /// @custom:signature   Unresolved_5ecb16cd(uint256 arg0, address arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_5ecb16cd(uint256 arg0, address arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(arg0 + 0x23 < msg.data.length);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_c + ((msg.data[0x04 + arg0] << 0x05) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + ((msg.data[0x04 + arg0] << 0x05) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + ((var_d << 0x05) + 0x20 + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x24 <= msg.data.length);
            if (0x24 + arg0 < arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x24) {
                require(msg.data[0x24 + arg0] - address(msg.data[0x24 + arg0]));
            } else {
                require(!(msg.sender - unresolved_e73c35eb), CustomError_1f6078af());
                if (0 >= var_e) {
                    return ;
                } else {
                    (bool success, bytes memory ret0) = address(address(var_h)).Unresolved_70a08231(address(this)); // staticcall
                    require(success);
                    if (success) {
                        if (!(var_c + 0x20 > 0xffffffffffffffff | var_c + 0x20 < var_c)) {
                            uint256 var_c = var_c + 0x20;
                            require(var_c + 0x20 - var_c < 0x20);
                        }
                    } else {
                        (bool success, bytes memory ret0) = address(address(var_h)).Unresolved_a9059cbb{ value: 0 }(msg.sender); // call
                        revert CustomError_fb7f5079();
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x7e5465ba
    /// @custom:signature   Unresolved_7e5465ba(address arg0, address arg1) public payable returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_7e5465ba(address arg0, address arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(!(msg.sender - unresolved_e73c35eb), CustomError_1f6078af());
        (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3{ value: 0 }(arg1); // call
        if (!success && !success) {
            (bool success, bytes memory ret0) = address(arg0).Unresolved_095ea7b3{ value: 0 }(arg1); // call
            if (success) {
                require(ret0.length > 0x1f & var_d == 0x01, CustomError_19be9a90());
            } else {
                require(success, CustomError_19be9a90());
            }
        }
        return ;
    }
    
    /// @custom:selector    0xb5c654e3
    /// @custom:signature   Unresolved_b5c654e3(uint256 arg0, address arg1) public payable returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_b5c654e3(uint256 arg0, address arg1) public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg1 - arg1));
        if (msg.sender - unresolved_8da5cb5b) {
            require(!(msg.sender - unresolved_e73c35eb), CustomError_1f6078af());
        }
        if (!arg0) {
            store_s = store_s & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg1;
        } else {
            if (arg0 == 0x01) {
                store_t = store_t & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg1;
            } else {
                if (arg0 == 0x02) {
                    store_u = store_u & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg1;
                } else {
                    if (arg0 == 0x03) {
                        store_v = store_v & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg1;
                    } else {
                        if (0x04 == arg0) {
                            store_w = store_w & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg1;
                        }
                    }
                }
            }
        }
        return ;
    }
    
    /// @custom:selector    0xd137a070
    /// @custom:signature   Unresolved_d137a070() public view returns (address)
    function Unresolved_d137a070() public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_x;
    }
    
    /// @custom:selector    0xe086e5ec
    /// @custom:signature   withdrawETH() public payable returns (uint256)
    function withdrawETH() public payable returns (uint256) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_e73c35eb), CustomError_1f6078af());
        payable(address(msg.sender)).transfer(address(this).balance);
        require(success);
        return ;
    }
}