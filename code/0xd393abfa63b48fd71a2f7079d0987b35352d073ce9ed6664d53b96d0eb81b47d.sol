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
    uint256 public constant proxiableUUID = 3963877391197344453575983046348115674221700746820753546331534351508065746944;
    uint256 public constant unresolved_eba7fb77 = 106010823886703059774997850044575110949649033812537137487296372077557186560;
    
    bytes32 store_o; // storage slot: 0x00
    uint8 store_m; // storage slot: 0x00
    uint8 store_n; // storage slot: 0x00
    address store_c; // storage slot: 0x0134
    bytes32 store_p; // storage slot: 0x0134
    address store_g; // storage slot: 0x0135
    bytes32 store_h; // storage slot: 0x0135
    uint8 store_k; // storage slot: 0x4910fdfa16fed3260ed0e7147f7cc6da11a60208b5b9406d12a635614ffd9143
    address store_j; // storage slot: var_f
    address store_q; // storage slot: var_a
    bytes32 store_l; // storage slot: var_f
    bytes32 store_r; // storage slot: var_a
    
    mapping(uint8 => bytes32) storage_map_e; // storage slot: 0x65
    mapping(bytes32 => bytes32) storage_map_d; // storage slot: 0x66
    mapping(address => bytes32) storage_map_a; // storage slot: 0x99
    mapping(uint40 => address) public ownerOfPool; // storage slot: 0x9a
    mapping(uint48 => uint256) storage_map_f; // storage slot: 0x9b
    mapping(bool => bytes32) storage_map_i; // storage slot: 0xce
    mapping(bytes32 => uint80) storage_map_s; // storage slot: 0x0101
    
    event Event_5ce4019f();
    event Event_60a99b51();
    event Event_7f26b83f();
    event Event_bc7cd75a();
    event Event_f6b6b4f7();
    event OwnerTransferred(address, address);
    event PoolAuthorizedAddrAdded(uint40, address);
    event PoolAuthorizedAddrRemoved(uint40, address);
    event PoolDeposited(uint48, uint256);
    event PoolOwnerTransferred(uint40, address, address);
    event PoolRegistered(uint40, address);
    event PoolWithdrawn(uint48, uint256);
    event PremiumManagerTransferred(address, address);
    event SwapExecuted(uint256);
    
    /// @custom:selector    0x6484396e
    /// @custom:signature   _amountFactor(uint8 arg0) public pure returns (uint256)
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    function _amountFactor(uint8 arg0) public pure returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - uint8(arg0)));
        if (uint8(arg0) > 0x20) {
            if (uint8(arg0) == 0xf2) {
                if (!0x01) {
                    if (uint8(arg0) > 0x70) {
                        if (uint8(arg0) > 0x7b) {
                            if (uint8(arg0) > 0x7b) {
                                if (uint8(arg0) <= 0x80) {
                                    return 0x03e8;
                                } else {
                                    return 0xe8d4a51000;
                                }
                            } else {
                                if (uint8(arg0) > 0x7b) {
                                    return 0x03e8;
                                } else {
                                    return 0xe8d4a51000;
                                }
                            }
                        } else {
                            return 0x64;
                        }
                    } else {
                        return 0x64;
                    }
                } else {
                    return 0x64;
                }
            } else {
                return 0x64;
            }
        } else {
            return 0x01;
        }
    }
    
    /// @custom:selector    0xff22f272
    /// @custom:signature   addAuthorizedAddr(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function addAuthorizedAddr(address arg0) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(storage_map_a[msg.sender].field_0, "The signer does not register a pool");
        require(msg.sender == ownerOfPool[storage_map_a[msg.sender].field_0].field_0.field_0, "Need the pool owner as the signer");
        require(!storage_map_a[arg0].field_0.field_0, "Addr is authorized for another pool");
        storage_map_a[0x08c379a000000000000000000000000000000000000000000000000000000000] = storage_map_a[0x08c379a000000000000000000000000000000000000000000000000000000000] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000 | storage_map_a[0x08c379a000000000000000000000000000000000000000000000000000000000].field_0.field_0;
        emit PoolAuthorizedAddrAdded(storage_map_a[arg0].field_0, arg0);
    }
    
    /// @custom:selector    0xc11d9ecb
    /// @custom:signature   addMultipleSupportedTokens(address[] arg0, uint8[] arg1) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function addMultipleSupportedTokens(address[] arg0, uint8[] arg1) public view {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(arg0 <= 0xffffffffffffffff);
        require(arg0 + 0x23 < msg.data.length);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg0] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + (0x20 + (var_d << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x24 <= msg.data.length);
            if (0x24 + arg0 < arg0 + (msg.data[0x04 + arg0] << 0x05) + 0x24) {
                require(msg.data[0x24 + arg0] - address(msg.data[0x24 + arg0]));
            } else {
                require(arg1 <= 0xffffffffffffffff);
                if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_c + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (msg.data[0x04 + arg1] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
                    if (0x20 + (0x04 + arg1) < 0x04 + arg1 + (msg.data[0x04 + arg1] << 0x05) + 0x20) {
                        require(msg.data[0x20 + (0x04 + arg1)] - uint8(msg.data[0x20 + (0x04 + arg1)]));
                    } else {
                        require(msg.sender == store_c, "Caller is not the owner");
                        require(!(var_j - var_j), "Tokens and indexes should have the same length");
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xd4f82322
    /// @custom:signature   addSupportToken(address arg0, uint8 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["bool", "uint8", "bytes1", "int8"]
    function addSupportToken(address arg0, uint8 arg1) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg0 - arg0));
        require(!(arg1 - uint8(arg1)));
        require(msg.sender == store_c, "Caller is not the owner");
        require(uint8(arg1), "Cannot use 0 as token index");
        require(arg0, "Cannot use zero address");
        require(!storage_map_d[arg0].field_0.field_0, "Token has been added before");
        require(!storage_map_e[uint8(arg1)].field_0.field_0, "Index has been used");
        if (uint8(arg1) >= 0x31) {
            if (uint8(arg1) > 0x40) {
                if ((0x03 & arg1) == 0x03) {
                    require(arg0 == 0x01, "Core token requires adddress(0x1)");
                }
                storage_map_d[arg0] = arg0 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_d[arg0];
            } else {
                storage_map_d[arg0] = uint8(arg1) | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_d[arg0];
            }
            uint8 var_e = uint8(arg1);
            storage_map_e[var_e] = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & storage_map_e[var_e];
        }
    }
    
    /// @custom:selector    0xeaf250b5
    /// @custom:signature   adjustToPool(uint8 arg0, uint256 arg1, uint40 arg2) public payable
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint40", "bytes5", "int40"]
    function adjustToPool(uint8 arg0, uint256 arg1, uint40 arg2) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x60);
        require(!(arg0 - uint8(arg0)));
        require(!(arg2 - arg2));
        require(msg.sender == store_c, "Caller is not the owner");
        require(ownerOfPool[arg2].field_0, "Pool index not registered");
        if (storage_map_f[uint48(arg2 | 0xff0000000000 & arg0 << 0x28)] <= storage_map_f[uint48(arg2 | 0xff0000000000 & arg0 << 0x28)] + arg1) {
            storage_map_f[0x4e487b7100000000000000000000000000000000000000000000000000000000] += arg1;
        }
    }
    
    /// @custom:selector    0xd3c7c2c7
    /// @custom:signature   getSupportedTokens() public view
    function getSupportedTokens() public view {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0);
    }
    
    /// @custom:selector    0x7fe0282b
    /// @custom:signature   poolOfAuthorizedAddr(address arg0) public view returns (uint40)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function poolOfAuthorizedAddr(address arg0) public view returns (uint40) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_a[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0xd3e95ea4
    /// @custom:signature   poolTokenBalance(address arg0, address arg1) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function poolTokenBalance(address arg0, address arg1) public view returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        if (!storage_map_a[arg1].field_0) {
            return 0;
        } else {
            uint48 var_a = uint48(storage_map_a[arg1].field_0 << 0x28 & 0xff0000000000 | storage_map_a[arg1].field_0.field_0);
            var_c = storage_map_f[var_a];
            return var_c;
        }
    }
    
    /// @custom:selector    0x051119f5
    /// @custom:signature   removeAuthorizedAddr(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function removeAuthorizedAddr(address arg0) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(storage_map_a[msg.sender].field_0, "The signer does not register a pool");
        require(msg.sender == ownerOfPool[storage_map_a[msg.sender].field_0].field_0.field_0, "Need the pool owner as the signer");
        require(storage_map_a[arg0].field_0.field_0 == storage_map_a[arg0].field_0, "Addr is not authorized for the signer's pool");
        storage_map_a[0x08c379a000000000000000000000000000000000000000000000000000000000] = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000 & storage_map_a[0x08c379a000000000000000000000000000000000000000000000000000000000];
        emit PoolAuthorizedAddrRemoved(storage_map_a[arg0].field_0, arg0);
    }
    
    /// @custom:selector    0xcb4f999b
    /// @custom:signature   removeSupportToken(uint8 arg0) public payable
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    function removeSupportToken(uint8 arg0) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - uint8(arg0)));
        require(msg.sender == store_c, "Caller is not the owner");
        require(uint8(arg0), "Cannot use 0 as token index");
        require(storage_map_e[uint8(arg0)].field_0, "Token for the index does not exist");
        var_e = storage_map_e[uint8(arg0)].field_0.field_0;
        storage_map_d[var_e] = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & storage_map_d[var_e];
        uint8 var_e = uint8(arg0);
        storage_map_e[var_e] = 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & storage_map_e[var_e];
    }
    
    /// @custom:selector    0x8b0a7765
    /// @custom:signature   serviceFeeCollected(uint8 arg0) public view returns (uint256)
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    function serviceFeeCollected(uint8 arg0) public view returns (uint256) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - uint8(arg0)));
        var_c = storage_map_f[uint48(arg0 << 0x28 & 0xff0000000000)];
        return var_c;
    }
    
    /// @custom:selector    0xff378719
    /// @custom:signature   tokenForIndex(uint8 arg0) public view returns (address)
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    function tokenForIndex(uint8 arg0) public view returns (address) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - uint8(arg0)));
        var_c = storage_map_e[uint8(arg0)].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x30f00f3a
    /// @custom:signature   transferPoolOwner(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function transferPoolOwner(address arg0) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(storage_map_a[msg.sender].field_0, "The signer does not register a pool");
        require(msg.sender == ownerOfPool[storage_map_a[msg.sender].field_0].field_0.field_0, "Need the pool owner as the signer");
        require(storage_map_a[arg0].field_0.field_0 == storage_map_a[arg0].field_0, "Addr is not authorized for the signer's pool");
        var_a = storage_map_a[var_h].field_0.field_0;
        ownerOfPool[var_a] = var_h | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & ownerOfPool[var_a];
        emit PoolOwnerTransferred(ownerOfPool[var_a].field_0, msg.sender, arg0);
    }
    
    /// @custom:selector    0xb805f321
    /// @custom:signature   transferPremiumManager(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function transferPremiumManager(address arg0) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(msg.sender == store_g, "Caller is not the premium manager");
        require(arg0, "New premium manager be zero address");
        store_h = arg0 | store_h & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit PremiumManagerTransferred(store_g, arg0);
    }
    
    /// @custom:selector    0x0ffad9c0
    /// @custom:signature   Unresolved_0ffad9c0(uint0 arg0, uint256 arg1, uint248 arg2, address arg3, uint40 arg4) public payable
    /// @param              arg0 ["uint0", "bytes0", "int0"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint248", "bytes31", "int248"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["uint40", "bytes5", "int40"]
    function Unresolved_0ffad9c0(uint0 arg0, uint256 arg1, uint248 arg2, address arg3, uint40 arg4) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0xa0);
        require(!(arg3 - arg3));
        require(!(arg4 - arg4));
        require(arg0 >> 0xf8 == 0x01, "Incorrect encoding version");
        require(uint16(arg0 >> 0x08) == 0x3c, "Swap not for this chain");
        if (uint8(arg0 >> 0x18) < 0xc0) {
            if (uint8(arg0 >> 0x18) > 0x70) {
                require(0x80 >= uint8(arg0 >> 0x18), "Token index not allowed for swapping");
                require(uint8(arg0 >> 0x18) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffb0 > 0xff, "In & out token types do not match");
            }
        } else {
            require(uint8(0x3f & uint8(arg0) >> 0x02) == uint8(0x3f & uint8(arg0 >> 0x18) >> 0x02), "In & out token types do not match");
            require(!storage_map_i[arg0].field_0.field_0, "Swap already exists");
            require(uint40(arg0 >> 0xd0) <= 0x174876e800, "For security reason, amount cannot be greater than 100k");
            if (uint40(arg0 >> 0x30) - block.timestamp <= uint40(arg0 >> 0x30)) {
                require(uint40(arg0 >> 0x30) - block.timestamp > 0x0e10, "Expire ts too early");
                require(uint40(arg0 >> 0x30) - block.timestamp < 0x1c20, "Expire ts too late");
                require(storage_map_a[msg.sender].field_0 == arg4, "Signer should be an authorized address of the given pool");
                require(arg3, "Signer cannot be empty address");
                if (arg2 >> 0xff <= (arg2 >> 0xff) + 0x1b) {
                    require((arg2 & 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "Invalid signature");
                    if (0 != (uint16(arg0 >> 0x08) == 0xc3) && !(var_k + (var_k + 0x20 + 0x39 - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_k + (var_k + 0x20 + 0x39 - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_k)) {
                        uint256 var_k = var_k + (var_k + 0x20 + 0x39 - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                        var_l = keccak256(memory[var_k + 0x20:var_k + 0x20 + var_m]);
                        revert();
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x16f35d23
    /// @custom:signature   Unresolved_16f35d23(bool arg0, address arg1) public payable
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_16f35d23(bool arg0, address arg1) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg1 - arg1));
        require(msg.sender == store_g, "Caller is not the premium manager");
        require(storage_map_i[arg0].field_0 > 0x01, "Swap does not exist");
        require(block.timestamp > uint40(arg0 >> 0x30), "Swap is still locked");
        storage_map_i[arg0] = 0xffffffffffff0000000000000000000000000000000000000000000000000000 & storage_map_i[arg0];
        if (uint8(arg0) >= 0x31 && uint8(arg0) > 0x40) {
            if ((0x03 & uint8(arg0)) != 0x03) {
                require(storage_map_e[uint8(arg0)].field_0.field_0.code.length, "The given token address is not a contract");
                if (uint8(arg0) == 0xf2 && (uint8(arg0) > 0x70 && (uint8(arg0) > 0x7b && uint40(arg0 >> 0xd0) * 0xe8d4a51000 / uint40(arg0 >> 0xd0) == 0xe8d4a51000 | !uint40(arg0 >> 0xd0)))) {
                    uint256 var_a = var_j + 0x64 - var_j + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0;
                    if (!(var_j + (var_j + 0x64 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_j + (var_j + 0x64 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_j)) {
                        (bool success, bytes memory ret0) = address(storage_map_e[uint8(arg0)].field_0).Unresolved_a9059cbb{ value: 0 }(arg1); // call
                        if (!ret0.length) {
                            if (success) {
                                if (!var_k) {
                                    require(0x60 + var_k + 0x20 - 0x80 >= 0x20);
                                    require(var_a - var_a);
                                }
                            } else {
                                require(success, "transfer failed");
                                emit Event_f6b6b4f7(arg0);
                            }
                        }
                    }
                }
            } else {
                if (!uint40(arg0 >> 0xd0) | 0xe8d4a51000 == uint40(arg0 >> 0xd0) * 0xe8d4a51000 / uint40(arg0 >> 0xd0)) {
                    payable(address(arg1)).transfer(uint40(arg0 >> 0xd0) * 0xe8d4a51000);
                    if (!ret0.length) {
                        require(success, "Transfer failed");
                        emit Event_f6b6b4f7(arg0);
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x1e2a6075
    /// @custom:signature   Unresolved_1e2a6075(uint256 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_1e2a6075(uint256 arg0) public view returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        if (storage_map_i[arg0].field_40) {
            return abi.encodePacked(ownerOfPool[storage_map_i[arg0].field_0.field_0].field_40.field_0, ownerOfPool[storage_map_i[arg0].field_0.field_0].field_0.field_0, ownerOfPool[storage_map_i[arg0].field_0.field_0].field_0);
        } else {
            var_c = storage_map_i[arg0].field_40.field_0;
            var_e = storage_map_i[arg0].field_0;
            return abi.encodePacked(var_c, 0, var_e);
        }
    }
    
    /// @custom:selector    0x2335093c
    /// @custom:signature   Unresolved_2335093c(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_2335093c(address arg0) public view returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_d[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x264849e7
    /// @custom:signature   Unresolved_264849e7(bool arg0) public payable
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    function Unresolved_264849e7(bool arg0) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(arg0 >> 0xf8 == 0x01, "Incorrect encoding version");
        require(uint16(arg0 >> 0x08) == 0x3c, "Swap not for this chain");
        if (uint8(arg0 >> 0x18) < 0xc0) {
            if (uint8(arg0 >> 0x18) > 0x70) {
                require(0x80 >= uint8(arg0 >> 0x18), "Token index not allowed for swapping");
                require(uint8(arg0 >> 0x18) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffb0 > 0xff, "In & out token types do not match");
            }
        } else {
            require(uint8(0x3f & uint8(arg0) >> 0x02) == uint8(0x3f & uint8(arg0 >> 0x18) >> 0x02), "In & out token types do not match");
            require(!storage_map_i[arg0].field_0.field_0, "Swap already exists");
            require(uint40(arg0 >> 0xd0) <= 0x174876e800, "For security reason, amount cannot be greater than 100k");
            if (uint40(arg0 >> 0x30) - block.timestamp <= uint40(arg0 >> 0x30)) {
                require(uint40(arg0 >> 0x30) - block.timestamp > 0x0e10, "Expire ts too early");
                require(uint40(arg0 >> 0x30) - block.timestamp < 0x1c20, "Expire ts too late");
                storage_map_i[arg0] = 0x01 | 0xffffffffffff0000000000000000000000000000000000000000000000000000 & storage_map_i[arg0];
                if (storage_map_f[uint48(0x01 | 0xff0000000000 & arg0 << 0x28)] <= storage_map_f[uint48(0x01 | 0xff0000000000 & arg0 << 0x28)] + uint40(arg0 >> 0xd0)) {
                    storage_map_f[0x4e487b7100000000000000000000000000000000000000000000000000000000] += uint40(arg0 >> 0xd0);
                    require(uint40(arg0 >> 0xd0), "Amount must be greater than zero");
                    if (uint8(arg0) >= 0x31 && uint8(arg0) > 0x40) {
                        if ((0x03 & uint8(arg0)) != 0x03) {
                            require(storage_map_e[uint8(arg0)].field_0.field_0, "Token not supported");
                            require(storage_map_e[uint8(arg0)].field_0.field_0.code.length, "The given token address is not a contract");
                            if (uint8(arg0) == 0xf2 && (uint8(arg0) > 0x70 && (uint8(arg0) > 0x7b && uint40(arg0 >> 0xd0) * 0xe8d4a51000 / uint40(arg0 >> 0xd0) == 0xe8d4a51000 | !uint40(arg0 >> 0xd0)))) {
                                uint256 var_a = var_j + 0x84 - var_j + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0;
                                if (!(var_j + (var_j + 0x84 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_j + (var_j + 0x84 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_j)) {
                                    (bool success, bytes memory ret0) = address(storage_map_e[uint8(arg0)].field_0).Unresolved_23b872dd{ value: 0 }(msg.sender); // call
                                    if (!ret0.length) {
                                        if (success) {
                                            if (!var_k) {
                                                require(0x60 + var_k + 0x20 - 0x80 >= 0x20);
                                                require(var_a - var_a);
                                            }
                                        } else {
                                            require(success, "transferFrom failed");
                                            emit SwapExecuted(arg0);
                                        }
                                    }
                                }
                            }
                        } else {
                            if (!uint40(arg0 >> 0xd0) | 0xe8d4a51000 == uint40(arg0 >> 0xd0) * 0xe8d4a51000 / uint40(arg0 >> 0xd0)) {
                                require(msg.value == uint40(arg0 >> 0xd0) * 0xe8d4a51000, "msg.value does not match the amount");
                                emit SwapExecuted(arg0);
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x35eff30f
    /// @custom:signature   Unresolved_35eff30f(uint256 arg0, uint40 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint40", "bytes5", "int40"]
    function Unresolved_35eff30f(uint256 arg0, uint40 arg1) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg1 - arg1));
        require(storage_map_i[arg0].field_0 > 0x01, "Swap does not exist");
        require(!storage_map_i[arg0].field_0, "Swap bonded to another pool");
        require(arg1 == storage_map_a[msg.sender].field_0.field_0, "Signer should be an authorized address of the given pool");
        storage_map_i[arg0] = uint208(storage_map_i[arg0].field_0 | arg1) | 0xffffffffffff0000000000000000000000000000000000000000000000000000 & storage_map_i[arg0];
        emit Event_60a99b51(arg0);
    }
    
    /// @custom:selector    0x3659cfe6
    /// @custom:signature   Unresolved_3659cfe6(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_3659cfe6(address arg0) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(0xf7dace615099950410bd07f52427a0448429518a != address(this), "Function must be called through delegatecall");
        require(store_j == 0xf7dace615099950410bd07f52427a0448429518a, "Function must be called through active proxy");
        require(msg.sender == store_c, "Caller is not the owner");
        if (!(var_g + 0x20 > 0xffffffffffffffff | var_g + 0x20 < var_g)) {
            uint256 var_g = var_g + 0x20;
            if (!store_k) {
                (bool success, bytes memory ret0) = address(arg0).proxiableUUID(); // staticcall
                if (!success) {
                    require(success, "ERC1967Upgrade: new implementation is not UUPS");
                    uint256 var_f = var_f;
                    require(0 == var_f, "ERC1967Upgrade: unsupported proxiableUUID");
                    require(arg0.code.length, "ERC1967: new implementation is not a contract");
                    store_l = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_l;
                    emit Event_bc7cd75a(arg0);
                    if (var_l) {
                        require(arg0.code.length, "Address: delegate call to non-contract");
                        (bool success, bytes memory ret0) = address(arg0).Unresolved_(memory[var_g:var_g + var_l]); // delegatecall
                        if (!ret0.length && !(var_g + 0x60 > 0xffffffffffffffff | var_g + 0x60 < var_g) && !success) {
                            require(var_o, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0");
                        }
                    }
                }
            } else {
                require(arg0.code.length, "ERC1967: new implementation is not a contract");
                store_l = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_l;
            }
        }
    }
    
    /// @custom:selector    0x37b90a4f
    /// @custom:signature   Unresolved_37b90a4f(uint256 arg0, uint48 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint48", "bytes6", "int48"]
    function Unresolved_37b90a4f(uint256 arg0, uint48 arg1) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg1 - arg1));
        require(arg0, "Amount must be positive");
        require(uint40(arg1), "Cannot use 0 as pool index");
        require(!(storage_map_a[msg.sender].field_0.field_0 - uint40(arg1)), "Need an authorized address as the signer");
        if (storage_map_f[arg1] <= storage_map_f[arg1] + arg0) {
            storage_map_f[0x4e487b7100000000000000000000000000000000000000000000000000000000] += arg0;
            require(arg0, "Amount must be greater than zero");
            if (uint8(arg1 >> 0x28) >= 0x31 && uint8(arg1 >> 0x28) > 0x40) {
                if ((0x03 & uint8(arg1 >> 0x28)) != 0x03) {
                    require(storage_map_e[uint8(arg1 >> 0x28)].field_0.field_0, "Token not supported");
                    require(storage_map_e[uint8(arg1 >> 0x28)].field_0.field_0.code.length, "The given token address is not a contract");
                    if (uint8(arg1 >> 0x28) == 0xf2 && (uint8(arg1 >> 0x28) > 0x70 && (uint8(arg1 >> 0x28) > 0x7b && arg0 * 0xe8d4a51000 / arg0 == 0xe8d4a51000 | !arg0))) {
                        uint256 var_a = var_j + 0x84 - var_j + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0;
                        if (!(var_j + (var_j + 0x84 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_j + (var_j + 0x84 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_j)) {
                            (bool success, bytes memory ret0) = address(storage_map_e[uint8(arg1 >> 0x28)].field_0).Unresolved_23b872dd{ value: 0 }(msg.sender); // call
                            if (!ret0.length) {
                                if (success) {
                                    if (!var_k) {
                                        require(0x60 + var_k + 0x20 - 0x80 >= 0x20);
                                        require(var_a - var_a);
                                    }
                                } else {
                                    require(success, "transferFrom failed");
                                    emit PoolDeposited(0x4e487b7100000000000000000000000000000000000000000000000000000000, arg0);
                                }
                            }
                        }
                    }
                } else {
                    if (!arg0 | 0xe8d4a51000 == arg0 * 0xe8d4a51000 / arg0) {
                        require(msg.value == arg0 * 0xe8d4a51000, "msg.value does not match the amount");
                        emit PoolDeposited(0x4e487b7100000000000000000000000000000000000000000000000000000000, arg0);
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
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(store_m, "Initializable: contract is already initialized");
        require(0x01 == store_n, "Initializable: contract is already initialized");
        store_o = store_o & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 | 0x01;
        require(arg0, "New owner cannot be zero address");
        store_p = arg0 | store_p & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit OwnerTransferred(store_c, arg0);
        require(arg1, "New premium manager be zero address");
        store_h = arg1 | store_h & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit PremiumManagerTransferred(store_g, arg1);
        if (!store_m) {
            store_o = store_o & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00ff;
            emit Event_7f26b83f(0x01);
        }
    }
    
    /// @custom:selector    0x4a2377e2
    /// @custom:signature   Unresolved_4a2377e2(uint0 arg0) public pure returns (bool)
    /// @param              arg0 ["uint0", "bytes0", "int0"]
    function Unresolved_4a2377e2(uint0 arg0) public pure returns (bool) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - uint8(arg0)));
        if (uint8(arg0) >= 0x31) {
            if (uint8(arg0) > 0x40) {
                if (0xbe < uint8(arg0)) {
                    return (0x03 & arg0) == 0x03;
                } else {
                    return 0xbe < uint8(arg0);
                }
            } else {
                return uint8(arg0) <= 0x40;
            }
        } else {
            return uint8(arg0) >= 0x31;
        }
    }
    
    /// @custom:selector    0x4f1ef286
    /// @custom:signature   Unresolved_4f1ef286(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_4f1ef286(address arg0, uint256 arg1) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg0 - arg0));
        require(arg1 <= 0xffffffffffffffff);
        require(arg1 + 0x23 < msg.data.length);
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_c)) {
            uint256 var_c = var_c + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + var_d) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_d = msg.data[0x04 + arg1];
            require(arg1 + msg.data[0x04 + arg1] + 0x24 <= msg.data.length);
            require(0xf7dace615099950410bd07f52427a0448429518a != address(this), "Function must be called through delegatecall");
            require(store_q == 0xf7dace615099950410bd07f52427a0448429518a, "Function must be called through active proxy");
            require(msg.sender == store_c, "Caller is not the owner");
            if (!store_k) {
                (bool success, bytes memory ret0) = address(arg0).proxiableUUID(); // staticcall
                if (!success) {
                    require(success, "ERC1967Upgrade: new implementation is not UUPS");
                    uint256 var_a = var_a;
                    require(0 == var_a, "ERC1967Upgrade: unsupported proxiableUUID");
                    require(arg0.code.length, "ERC1967: new implementation is not a contract");
                    store_r = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_r;
                    emit Event_bc7cd75a(arg0);
                    if (var_k && var_k) {
                        require(arg0.code.length, "Address: delegate call to non-contract");
                        (bool success, bytes memory ret0) = address(arg0).Unresolved_(memory[var_c + 0x20:var_c + 0x20 + var_k]); // delegatecall
                        if (!ret0.length && !(var_c + 0x60 > 0xffffffffffffffff | var_c + 0x60 < var_c) && !success) {
                            require(var_n, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0");
                        }
                    }
                }
            } else {
                require(arg0.code.length, "ERC1967: new implementation is not a contract");
                store_r = arg0 | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & store_r;
            }
        }
    }
    
    /// @custom:selector    0x515147ab
    /// @custom:signature   Unresolved_515147ab(bool arg0, address arg1) public view
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_515147ab(bool arg0, address arg1) public view {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x80);
        require(!(arg3 - arg3));
        require(arg0 >> 0xf8 == 0x01, "Incorrect encoding version");
        require(uint16(arg0 >> 0x20) == 0x3c, "Swap not for this chain");
        if (!(var_g + (var_g + 0x54 - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_g + (var_g + 0x54 - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_g)) {
            uint256 var_g = var_g + (var_g + 0x54 - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(!storage_map_s[keccak256(memory[var_g + 0x20:var_g + 0x20 + var_j])].field_0.field_0, "Swap already exists");
            require(storage_map_a[msg.sender].field_0.field_0, "Caller not registered. Call depositAndRegister.");
            if (block.timestamp <= block.timestamp + 0x0960 && uint40(arg0 >> 0x30) + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed4 <= uint40(arg0 >> 0x30)) {
                require(block.timestamp + 0x0960 < uint40(arg0 >> 0x30) + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed4, "Cannot lock because expireTs is soon.");
            }
        }
    }
    
    /// @custom:selector    0x54d6a2b7
    /// @custom:signature   Unresolved_54d6a2b7(bool arg0) public payable
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    function Unresolved_54d6a2b7(bool arg0) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(storage_map_i[arg0].field_0 > 0x01, "Swap does not exist");
        require(block.timestamp > uint40(arg0 >> 0x30), "Swap is still locked");
        require(!storage_map_i[arg0].field_0.field_200, "Swap token not from initiator");
        storage_map_i[arg0] = 0xffffffffffff0000000000000000000000000000000000000000000000000000 & storage_map_i[arg0];
        if (uint8(arg0) >= 0x31 && uint8(arg0) > 0x40) {
            if ((0x03 & uint8(arg0)) != 0x03) {
                require(storage_map_e[uint8(arg0)].field_0.field_0.code.length, "The given token address is not a contract");
                if (uint8(arg0) == 0xf2 && (uint8(arg0) > 0x70 && (uint8(arg0) > 0x7b && uint40(arg0 >> 0xd0) * 0xe8d4a51000 / uint40(arg0 >> 0xd0) == 0xe8d4a51000 | !uint40(arg0 >> 0xd0)))) {
                    var_e = storage_map_e[uint8(arg0)].field_0.field_40.field_0.field_0.field_0;
                    uint256 var_c = var_j + 0x64 - var_j + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0;
                    if (!(var_j + (var_j + 0x64 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_j + (var_j + 0x64 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_j)) {
                        (bool success, bytes memory ret0) = address(storage_map_e[uint8(arg0)].field_0).Unresolved_a9059cbb{ value: 0 }(var_e); // call
                        if (!ret0.length) {
                            if (success) {
                                if (!var_k) {
                                    require(0x60 + var_k + 0x20 - 0x80 >= 0x20);
                                    require(var_c - var_c);
                                }
                            } else {
                                require(success, "transfer failed");
                                emit Event_f6b6b4f7(arg0);
                            }
                        }
                    }
                }
            } else {
                if (!uint40(arg0 >> 0xd0) | 0xe8d4a51000 == uint40(arg0 >> 0xd0) * 0xe8d4a51000 / uint40(arg0 >> 0xd0)) {
                    payable(address(storage_map_i[arg0].field_0.field_40.field_0.field_0)).transfer(uint40(arg0 >> 0xd0) * 0xe8d4a51000);
                    if (!ret0.length) {
                        require(success, "Transfer failed");
                        emit Event_f6b6b4f7(arg0);
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x58d9b4e1
    /// @custom:signature   Unresolved_58d9b4e1(bool arg0, address arg1) public view
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_58d9b4e1(bool arg0, address arg1) public view {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg1 - arg1));
        require(arg0 >> 0xf8 == 0x01, "Incorrect encoding version");
        require(uint16(arg0 >> 0x20) == 0x3c, "Swap not for this chain");
        if (!(var_g + (var_g + 0x54 - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_g + (var_g + 0x54 - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_g)) {
            uint256 var_g = var_g + (var_g + 0x54 - var_g + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(!storage_map_s[keccak256(memory[var_g + 0x20:var_g + 0x20 + var_j])].field_0.field_0, "Swap already exists");
            require(storage_map_a[msg.sender].field_0.field_0, "Caller not registered. Call depositAndRegister.");
            if (block.timestamp <= block.timestamp + 0x0960 && uint40(arg0 >> 0x30) + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed4 <= uint40(arg0 >> 0x30)) {
                require(block.timestamp + 0x0960 < uint40(arg0 >> 0x30) + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffed4, "Cannot lock because expireTs is soon.");
            }
        }
    }
    
    /// @custom:selector    0x60a2da98
    /// @custom:signature   Unresolved_60a2da98(uint256 arg0, address arg1) public view returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_60a2da98(uint256 arg0, address arg1) public view returns (bytes memory) {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg1 - arg1));
        if (!(var_d + (var_d + 0x54 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (var_d + 0x54 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            uint256 var_d = var_d + (var_d + 0x54 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            if (storage_map_s[keccak256(memory[var_d + 0x20:var_d + 0x20 + var_g])].field_0 - 0x01) {
                var_e = storage_map_s[keccak256(memory[var_d + 0x20:var_d + 0x20 + var_g])].field_0;
                return abi.encodePacked(ownerOfPool[storage_map_s[var_e].field_0].field_0.field_0, ownerOfPool[storage_map_s[var_e].field_0].field_0.field_40.field_0.field_0.field_0);
            } else {
                return abi.encodePacked(0x01, 0);
            }
        }
    }
    
    /// @custom:selector    0x6f9b41fd
    /// @custom:signature   Unresolved_6f9b41fd(bool arg0, address arg1, uint40 arg2) public payable
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint40", "bytes5", "int40"]
    function Unresolved_6f9b41fd(bool arg0, address arg1, uint40 arg2) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x60);
        require(!(arg1 - arg1));
        require(!(arg2 - arg2));
        require(arg0 >> 0xf8 == 0x01, "Incorrect encoding version");
        require(uint16(arg0 >> 0x08) == 0x3c, "Swap not for this chain");
        if (uint8(arg0 >> 0x18) < 0xc0) {
            if (uint8(arg0 >> 0x18) > 0x70) {
                require(0x80 >= uint8(arg0 >> 0x18), "Token index not allowed for swapping");
                require(uint8(arg0 >> 0x18) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffb0 > 0xff, "In & out token types do not match");
            }
        } else {
            require(uint8(0x3f & uint8(arg0) >> 0x02) == uint8(0x3f & uint8(arg0 >> 0x18) >> 0x02), "In & out token types do not match");
            require(!storage_map_i[arg0].field_0.field_0, "Swap already exists");
            require(uint40(arg0 >> 0xd0) <= 0x174876e800, "For security reason, amount cannot be greater than 100k");
            if (uint40(arg0 >> 0x30) - block.timestamp <= uint40(arg0 >> 0x30)) {
                require(uint40(arg0 >> 0x30) - block.timestamp > 0x0e10, "Expire ts too early");
                require(uint40(arg0 >> 0x30) - block.timestamp < 0x1c20, "Expire ts too late");
                storage_map_i[arg0] = storage_map_i[arg0] & 0xffffffffffff0000000000000000000000000000000000000000000000000000 | uint208(0x0100000000000000000000000000000000000000000000000000 | arg1 << 0x28 & 0xffffffffffffffffffffffffffffffffffffffffff0000000000 | arg2);
                require(uint40(arg0 >> 0xd0), "Amount must be greater than zero");
                if (uint8(arg0) >= 0x31 && uint8(arg0) > 0x40) {
                    if ((0x03 & uint8(arg0)) != 0x03) {
                        require(storage_map_e[uint8(arg0)].field_0.field_0, "Token not supported");
                        require(storage_map_e[uint8(arg0)].field_0.field_0.code.length, "The given token address is not a contract");
                        if (uint8(arg0) == 0xf2 && (uint8(arg0) > 0x70 && (uint8(arg0) > 0x7b && uint40(arg0 >> 0xd0) * 0xe8d4a51000 / uint40(arg0 >> 0xd0) == 0xe8d4a51000 | !uint40(arg0 >> 0xd0)))) {
                            uint256 var_a = var_j + 0x84 - var_j + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0;
                            if (!(var_j + (var_j + 0x84 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_j + (var_j + 0x84 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_j)) {
                                (bool success, bytes memory ret0) = address(storage_map_e[uint8(arg0)].field_0).Unresolved_23b872dd{ value: 0 }(msg.sender); // call
                                if (!ret0.length) {
                                    if (success) {
                                        if (!var_k) {
                                            require(0x60 + var_k + 0x20 - 0x80 >= 0x20);
                                            require(var_a - var_a);
                                        }
                                    } else {
                                        require(success, "transferFrom failed");
                                        emit Event_5ce4019f(arg0);
                                    }
                                }
                            }
                        }
                    } else {
                        if (!uint40(arg0 >> 0xd0) | 0xe8d4a51000 == uint40(arg0 >> 0xd0) * 0xe8d4a51000 / uint40(arg0 >> 0xd0)) {
                            require(msg.value == uint40(arg0 >> 0xd0) * 0xe8d4a51000, "msg.value does not match the amount");
                            emit Event_5ce4019f(arg0);
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x741c8e2d
    /// @custom:signature   Unresolved_741c8e2d(bool arg0, address arg1, uint256 arg2, uint248 arg3) public payable
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint248", "bytes31", "int248"]
    function Unresolved_741c8e2d(bool arg0, address arg1, uint256 arg2, uint248 arg3) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x80);
        require(!(arg1 - arg1));
        require(arg0 >> 0xf8 == 0x01, "Incorrect encoding version");
        require(uint16(arg0 >> 0x08) == 0x3c, "Swap not for this chain");
        if (uint8(arg0 >> 0x18) < 0xc0) {
            if (uint8(arg0 >> 0x18) > 0x70) {
                require(0x80 >= uint8(arg0 >> 0x18), "Token index not allowed for swapping");
                require(uint8(arg0 >> 0x18) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffb0 > 0xff, "In & out token types do not match");
            }
        } else {
            require(uint8(0x3f & uint8(arg0) >> 0x02) == uint8(0x3f & uint8(arg0 >> 0x18) >> 0x02), "In & out token types do not match");
            require(!storage_map_i[arg0].field_0.field_0, "Swap already exists");
            require(uint40(arg0 >> 0xd0) <= 0x174876e800, "For security reason, amount cannot be greater than 100k");
            if (uint40(arg0 >> 0x30) - block.timestamp <= uint40(arg0 >> 0x30)) {
                require(uint40(arg0 >> 0x30) - block.timestamp > 0x0e10, "Expire ts too early");
                require(uint40(arg0 >> 0x30) - block.timestamp < 0x1c20, "Expire ts too late");
                require(uint16(arg0 >> 0x20) == 0x3c, "Swap not for this chain");
                require(arg1, "Recipient cannot be zero address");
                if (!(var_k + (var_k + 0x54 - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_k + (var_k + 0x54 - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_k)) {
                    uint256 var_k = var_k + (var_k + 0x54 - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                    require(store_g, "Signer cannot be empty address");
                    if (arg3 >> 0xff <= (arg3 >> 0xff) + 0x1b) {
                        require((arg3 & 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "Invalid signature");
                        var_l = keccak256(memory[var_k + 0x20:var_k + 0x20 + var_o]);
                        revert();
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x827c87cc
    /// @custom:signature   Unresolved_827c87cc(uint0 arg0, uint256 arg1, uint248 arg2, address arg3, uint256 arg4) public payable
    /// @param              arg0 ["uint0", "bytes0", "int0"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint248", "bytes31", "int248"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_827c87cc(uint0 arg0, uint256 arg1, uint248 arg2, address arg3, uint256 arg4) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0xa0);
        require(!(arg3 - arg3));
        require(!(arg4 - arg4));
        require(storage_map_i[arg0].field_0 > 0x01, "Swap does not exist");
        if (block.timestamp <= block.timestamp + 0x0e10) {
            storage_map_i[arg0] = 0x01 | 0xffffffffffff0000000000000000000000000000000000000000000000000000 & storage_map_i[arg0];
            require(storage_map_i[arg0].field_0.field_0.field_40.field_0.field_0.field_0, "Signer cannot be empty address");
            if (arg2 >> 0xff <= (arg2 >> 0xff) + 0x1b) {
                require((arg2 & 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "Invalid signature");
                if (0 != (uint16(arg0 >> 0x08) == 0xc3) && !(var_k + (var_k + 0x20 + 0x4d - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_k + (var_k + 0x20 + 0x4d - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_k)) {
                    uint256 var_k = var_k + (var_k + 0x20 + 0x4d - var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                    var_l = keccak256(memory[var_k + 0x20:var_k + 0x20 + var_m]);
                    revert();
                }
            }
        }
    }
    
    /// @custom:selector    0x8f487dc9
    /// @custom:signature   Unresolved_8f487dc9(uint256 arg0, uint48 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint48", "bytes6", "int48"]
    function Unresolved_8f487dc9(uint256 arg0, uint48 arg1) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg1 - arg1));
        require(arg0, "Amount must be positive");
        require(uint40(arg1), "Cannot use 0 as pool index");
        require(!ownerOfPool[uint40(arg1)].field_0.field_0, "Pool index already registered");
        require(!storage_map_a[msg.sender].field_0.field_0, "Signer address already registered");
        uint40 var_e = uint40(arg1);
        ownerOfPool[var_e] = msg.sender | 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 & ownerOfPool[var_e];
        storage_map_a[msg.sender] = storage_map_a[msg.sender] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffff0000000000 | uint40(arg1);
        if (storage_map_f[arg1] <= storage_map_f[arg1] + arg0) {
            storage_map_f[0x4e487b7100000000000000000000000000000000000000000000000000000000] += arg0;
            require(arg0, "Amount must be greater than zero");
            if (uint8(arg1 >> 0x28) >= 0x31 && uint8(arg1 >> 0x28) > 0x40) {
                if ((0x03 & uint8(arg1 >> 0x28)) != 0x03) {
                    require(storage_map_e[uint8(arg1 >> 0x28)].field_0.field_0, "Token not supported");
                    require(storage_map_e[uint8(arg1 >> 0x28)].field_0.field_0.code.length, "The given token address is not a contract");
                    if (uint8(arg1 >> 0x28) == 0xf2 && (uint8(arg1 >> 0x28) > 0x70 && (uint8(arg1 >> 0x28) > 0x7b && arg0 * 0xe8d4a51000 / arg0 == 0xe8d4a51000 | !arg0))) {
                        uint256 var_a = var_j + 0x84 - var_j + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0;
                        if (!(var_j + (var_j + 0x84 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_j + (var_j + 0x84 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_j)) {
                            (bool success, bytes memory ret0) = address(storage_map_e[uint8(arg1 >> 0x28)].field_0).Unresolved_23b872dd{ value: 0 }(msg.sender); // call
                            if (!ret0.length) {
                                if (success) {
                                    if (!var_k) {
                                        require(0x60 + var_k + 0x20 - 0x80 >= 0x20);
                                        require(var_a - var_a);
                                    }
                                } else {
                                    require(success, "transferFrom failed");
                                    emit PoolRegistered(uint40(arg1), msg.sender);
                                    emit PoolDeposited(0x4e487b7100000000000000000000000000000000000000000000000000000000, arg0);
                                }
                            }
                        }
                    }
                } else {
                    if (!arg0 | 0xe8d4a51000 == arg0 * 0xe8d4a51000 / arg0) {
                        require(msg.value == arg0 * 0xe8d4a51000, "msg.value does not match the amount");
                        emit PoolRegistered(uint40(arg1), msg.sender);
                        emit PoolDeposited(0x4e487b7100000000000000000000000000000000000000000000000000000000, arg0);
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xa5c9c66c
    /// @custom:signature   Unresolved_a5c9c66c(uint0 arg0, uint256 arg1, uint248 arg2, address arg3, address arg4) public payable
    /// @param              arg0 ["uint0", "bytes0", "int0"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint248", "bytes31", "int248"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_a5c9c66c(uint0 arg0, uint256 arg1, uint248 arg2, address arg3, address arg4) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0xa0);
        require(!(arg3 - arg3));
        require(!(arg4 - arg4));
        require(msg.sender == store_g, "Caller is not the premium manager");
        require(msg.sender == tx.origin, "Cannot be called through contracts");
        require(block.timestamp < uint40(arg0 >> 0x30), "Cannot release because expired");
        require(arg4, "Recipient cannot be zero address");
        require(msg.sender == store_g, "Caller is not the premium manager");
        if (!(var_h + (var_h + 0x54 - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_h + (var_h + 0x54 - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_h)) {
            uint256 var_h = var_h + (var_h + 0x54 - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(storage_map_s[keccak256(memory[var_h + 0x20:var_h + 0x20 + var_k])].field_0.field_0 > 0x01, "Swap does not exist");
            require(arg3, "Signer cannot be empty address");
            if (arg2 >> 0xff <= (arg2 >> 0xff) + 0x1b) {
                require((arg2 & 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "Invalid signature");
                if (0 != (uint16(arg0 >> 0x08) == 0xc3) && !(var_h + (var_h + 0x20 + 0x4d - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_h + (var_h + 0x20 + 0x4d - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_h)) {
                    uint256 var_h = var_h + (var_h + 0x20 + 0x4d - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                    var_s = keccak256(memory[var_h + 0x20:var_h + 0x20 + var_k]);
                    revert();
                }
            }
        }
    }
    
    /// @custom:selector    0xab115fd8
    /// @custom:signature   Unresolved_ab115fd8(uint0 arg0, uint256 arg1, uint248 arg2, address arg3, address arg4) public payable
    /// @param              arg0 ["uint0", "bytes0", "int0"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint248", "bytes31", "int248"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_ab115fd8(uint0 arg0, uint256 arg1, uint248 arg2, address arg3, address arg4) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0xa0);
        require(!(arg3 - arg3));
        require(!(arg4 - arg4));
        require(arg0 >> 0xf8 == 0x01, "Incorrect encoding version");
        require(uint16(arg0 >> 0x20) == 0x3c, "Swap not for this chain");
        require(msg.sender == tx.origin, "Cannot be called through contracts");
        require(arg4, "Recipient cannot be zero address");
        require(msg.sender == store_g, "Caller is not the premium manager");
        if (!(var_h + (var_h + 0x54 - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_h + (var_h + 0x54 - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_h)) {
            uint256 var_h = var_h + (var_h + 0x54 - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(!storage_map_s[keccak256(memory[var_h + 0x20:var_h + 0x20 + var_k])].field_0.field_0, "Swap already exists");
            require(storage_map_a[msg.sender].field_0.field_0, "Caller not registered. Call depositAndRegister.");
            if (!arg1) {
                require(arg0 & 0x4000000000000000000000000000000000000000000000000000, "Caller is not the premium manager");
                storage_map_s[var_t] = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffff00000000000000000000 & storage_map_s[var_t];
                if (uint40(arg0 >> 0xd0) - uint40(arg0 >> 0x58) <= uint40(arg0 >> 0xd0) && (uint8(arg0 >> 0x18) >= 0xbf && (uint8(arg0 >> 0x18) >= 0xbf && (uint40(arg0 >> 0xd0) - uint40(arg0 >> 0x58) <= uint40(arg0 >> 0xd0) - uint40(arg0 >> 0x58) && storage_map_f[uint48(storage_map_s[keccak256(memory[var_h + 0x20:var_h + 0x20 + var_k])].field_0.field_0 | 0xff0000000000 & arg0 << 0x10)] - (uint40(arg0 >> 0xd0) - uint40(arg0 >> 0x58)) <= storage_map_f[uint48(storage_map_s[keccak256(memory[var_h + 0x20:var_h + 0x20 + var_k])].field_0.field_0 | 0xff0000000000 & arg0 << 0x10)])))) {
                    storage_map_f[0x4e487b7100000000000000000000000000000000000000000000000000000000] -= uint40(arg0 >> 0xd0) - uint40(arg0 >> 0x58);
                }
            } else {
                require(block.timestamp < uint40(arg0 >> 0x30), "Cannot release because expired");
                require(arg3, "Signer cannot be empty address");
                if (arg2 >> 0xff <= (arg2 >> 0xff) + 0x1b) {
                    require((arg2 & 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "Invalid signature");
                    if (0 != (uint16(arg0 >> 0x08) == 0xc3) && !(var_h + (var_h + 0x20 + 0x4d - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_h + (var_h + 0x20 + 0x4d - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_h)) {
                        uint256 var_h = var_h + (var_h + 0x20 + 0x4d - var_h + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                        var_t = keccak256(memory[var_h + 0x20:var_h + 0x20 + var_k]);
                        revert();
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xc8173c44
    /// @custom:signature   Unresolved_c8173c44(uint0 arg0, uint256 arg1, uint248 arg2, address arg3, address arg4) public payable
    /// @param              arg0 ["uint0", "bytes0", "int0"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint248", "bytes31", "int248"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_c8173c44(uint0 arg0, uint256 arg1, uint248 arg2, address arg3, address arg4) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0xa0);
        require(!(arg3 - arg3));
        require(!(arg4 - arg4));
        require(arg0 >> 0xf8 == 0x01, "Incorrect encoding version");
        require(uint16(arg0 >> 0x08) == 0x3c, "Swap not for this chain");
        if (uint8(arg0 >> 0x18) < 0xc0) {
            if (uint8(arg0 >> 0x18) > 0x70) {
                require(0x80 >= uint8(arg0 >> 0x18), "Token index not allowed for swapping");
                require(uint8(arg0 >> 0x18) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffb0 > 0xff, "In & out token types do not match");
            }
        } else {
            require(uint8(0x3f & uint8(arg0) >> 0x02) == uint8(0x3f & uint8(arg0 >> 0x18) >> 0x02), "In & out token types do not match");
            require(!storage_map_i[arg0].field_0.field_0, "Swap already exists");
            require(uint40(arg0 >> 0xd0) <= 0x174876e800, "For security reason, amount cannot be greater than 100k");
            if (uint40(arg0 >> 0x30) - block.timestamp <= uint40(arg0 >> 0x30)) {
                require(uint40(arg0 >> 0x30) - block.timestamp > 0x0e10, "Expire ts too early");
                require(uint40(arg0 >> 0x30) - block.timestamp < 0x1c20, "Expire ts too late");
                require(arg3, "Signer cannot be empty address");
                if (arg2 >> 0xff <= (arg2 >> 0xff) + 0x1b) {
                    require((arg2 & 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff) <= 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0, "Invalid signature");
                    if (0 != (uint16(arg0 >> 0x08) == 0xc3) && !(var_l + (var_l + 0x20 + 0x4d - var_l + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_l + (var_l + 0x20 + 0x4d - var_l + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_l)) {
                        uint256 var_l = var_l + (var_l + 0x20 + 0x4d - var_l + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                        var_m = keccak256(memory[var_l + 0x20:var_l + 0x20 + var_n]);
                        revert();
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xdecf2a48
    /// @custom:signature   Unresolved_decf2a48(bool arg0, uint40 arg1) public payable
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["uint40", "bytes5", "int40"]
    function Unresolved_decf2a48(bool arg0, uint40 arg1) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg1 - uint200(arg1)));
        require(0x01 == arg0 >> 0xf8, "Incorrect encoding version");
        require(uint16(arg0 >> 0x08) == 0x3c, "Swap not for this chain");
        if (uint8(arg0 >> 0x18) < 0xc0) {
            if (uint8(arg0 >> 0x18) > 0x70) {
                require(0x80 >= uint8(arg0 >> 0x18), "Token index not allowed for swapping");
                require(uint8(arg0 >> 0x18) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffb0 > 0xff, "In & out token types do not match");
            }
        } else {
            require(uint8(0x3f & uint8(arg0) >> 0x02) == uint8(0x3f & uint8(arg0 >> 0x18) >> 0x02), "In & out token types do not match");
            require(!storage_map_i[arg0].field_0.field_0, "Swap already exists");
            require(uint40(arg0 >> 0xd0) <= 0x174876e800, "For security reason, amount cannot be greater than 100k");
            if (uint40(arg0 >> 0x30) - block.timestamp <= uint40(arg0 >> 0x30)) {
                require(uint40(arg0 >> 0x30) - block.timestamp > 0x0e10, "Expire ts too early");
                require(uint40(arg0 >> 0x30) - block.timestamp < 0x1c20, "Expire ts too late");
                storage_map_i[arg0] = storage_map_i[arg0] & 0xffffffffffff0000000000000000000000000000000000000000000000000000 | uint208(0x0100000000000000000000000000000000000000000000000000 | address(uint200(arg1) >> 0x28) << 0x28 & 0xffffffffffffffffffffffffffffffffffffffffff0000000000 | arg1);
                require(uint40(arg0 >> 0xd0), "Amount must be greater than zero");
                if (uint8(arg0) >= 0x31 && uint8(arg0) > 0x40) {
                    if ((0x03 & uint8(arg0)) != 0x03) {
                        require(storage_map_e[uint8(arg0)].field_0.field_0, "Token not supported");
                        require(storage_map_e[uint8(arg0)].field_0.field_0.code.length, "The given token address is not a contract");
                        if (uint8(arg0) == 0xf2 && (uint8(arg0) > 0x70 && (uint8(arg0) > 0x7b && uint40(arg0 >> 0xd0) * 0xe8d4a51000 / uint40(arg0 >> 0xd0) == 0xe8d4a51000 | !uint40(arg0 >> 0xd0)))) {
                            uint256 var_a = var_j + 0x84 - var_j + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0;
                            if (!(var_j + (var_j + 0x84 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_j + (var_j + 0x84 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_j)) {
                                (bool success, bytes memory ret0) = address(storage_map_e[uint8(arg0)].field_0).Unresolved_23b872dd{ value: 0 }(msg.sender); // call
                                if (!ret0.length) {
                                    if (success) {
                                        if (!var_k) {
                                            require(0x60 + var_k + 0x20 - 0x80 >= 0x20);
                                            require(var_a - var_a);
                                        }
                                    } else {
                                        require(success, "transferFrom failed");
                                        emit Event_5ce4019f(arg0);
                                    }
                                }
                            }
                        }
                    } else {
                        if (!uint40(arg0 >> 0xd0) | 0xe8d4a51000 == uint40(arg0 >> 0xd0) * 0xe8d4a51000 / uint40(arg0 >> 0xd0)) {
                            require(msg.value == uint40(arg0 >> 0xd0) * 0xe8d4a51000, "msg.value does not match the amount");
                            emit Event_5ce4019f(arg0);
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xf1d2ec1d
    /// @custom:signature   Unresolved_f1d2ec1d(bool arg0, address arg1) public view
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f1d2ec1d(bool arg0, address arg1) public view {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg1 - arg1));
        if (!(var_d + (var_d + 0x54 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (var_d + 0x54 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            uint256 var_d = var_d + (var_d + 0x54 - var_d + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(storage_map_s[keccak256(memory[var_d + 0x20:var_d + 0x20 + var_g])].field_0.field_0 > 0x01, "Swap does not exist");
            require(block.timestamp > storage_map_s[keccak256(memory[var_d + 0x20:var_d + 0x20 + var_g])].field_0.field_40.field_0, "Swap still in lock");
        }
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x20);
        require(!(arg0 - arg0));
        require(msg.sender == store_c, "Caller is not the owner");
        require(arg0, "New owner cannot be zero address");
        store_p = arg0 | store_p & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit OwnerTransferred(store_c, arg0);
    }
    
    /// @custom:selector    0xce7f79b9
    /// @custom:signature   withdraw(uint256 arg0, uint48 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint48", "bytes6", "int48"]
    function withdraw(uint256 arg0, uint48 arg1) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x40);
        require(!(arg1 - arg1));
        require(arg0, "Amount must be positive");
        require(uint40(arg1), "Cannot use 0 as pool index");
        require(msg.sender == ownerOfPool[uint40(arg1)].field_0, "Need the pool owner as the signer");
        if (storage_map_f[arg1] - arg0 <= storage_map_f[arg1]) {
            storage_map_f[0x4e487b7100000000000000000000000000000000000000000000000000000000] -= arg0;
            if (uint8(arg1 >> 0x28) >= 0x31 && uint8(arg1 >> 0x28) > 0x40) {
                if ((0x03 & uint8(arg1 >> 0x28)) != 0x03) {
                    require(storage_map_e[uint8(arg1 >> 0x28)].field_0.field_0.code.length, "The given token address is not a contract");
                    if (uint8(arg1 >> 0x28) == 0xf2 && (uint8(arg1 >> 0x28) > 0x70 && (uint8(arg1 >> 0x28) > 0x7b && arg0 * 0xe8d4a51000 / arg0 == 0xe8d4a51000 | !arg0))) {
                        uint256 var_a = var_j + 0x64 - var_j + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0;
                        if (!(var_j + (var_j + 0x64 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_j + (var_j + 0x64 - var_j + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_j)) {
                            (bool success, bytes memory ret0) = address(storage_map_e[uint8(arg1 >> 0x28)].field_0).Unresolved_a9059cbb{ value: 0 }(msg.sender); // call
                            if (!ret0.length) {
                                if (success) {
                                    if (!var_k) {
                                        require(0x60 + var_k + 0x20 - 0x80 >= 0x20);
                                        require(var_a - var_a);
                                    }
                                } else {
                                    require(success, "transfer failed");
                                    emit PoolWithdrawn(0x4e487b7100000000000000000000000000000000000000000000000000000000, arg0);
                                }
                            }
                        }
                    }
                } else {
                    if (!arg0 | 0xe8d4a51000 == arg0 * 0xe8d4a51000 / arg0) {
                        payable(address(msg.sender)).transfer(arg0 * 0xe8d4a51000);
                        if (!ret0.length) {
                            require(success, "Transfer failed");
                            emit PoolWithdrawn(0x4e487b7100000000000000000000000000000000000000000000000000000000, arg0);
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x7234cd95
    /// @custom:signature   withdrawServiceFee(uint8 arg0, uint256 arg1, uint40 arg2) public payable
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint40", "bytes5", "int40"]
    function withdrawServiceFee(uint8 arg0, uint256 arg1, uint40 arg2) public payable {
        require(0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc + msg.data.length >= 0x60);
        require(!(arg0 - uint8(arg0)));
        require(!(arg2 - arg2));
        require(msg.sender == store_c, "Caller is not the owner");
        require(ownerOfPool[arg2].field_0, "Pool index not registered");
        if (storage_map_f[uint48(0xff0000000000 & arg0 << 0x28)] - arg1 <= storage_map_f[uint48(0xff0000000000 & arg0 << 0x28)]) {
            storage_map_f[0x4e487b7100000000000000000000000000000000000000000000000000000000] -= arg1;
            if (storage_map_f[uint48(arg0 << 0x28 & 0xff0000000000 | arg2)] <= storage_map_f[uint48(arg0 << 0x28 & 0xff0000000000 | arg2)] + arg1) {
                storage_map_f[0x4e487b7100000000000000000000000000000000000000000000000000000000] += arg1;
            }
        }
    }
}