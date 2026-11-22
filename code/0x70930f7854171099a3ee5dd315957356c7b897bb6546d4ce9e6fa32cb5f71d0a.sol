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
    uint256 public constant ETHEREUM_CHAIN_ID = 1;
    uint256 public constant GONKA_CHAIN_ID = 17992519436200627010809135312310072803285983112183974522052519070033807827963;
    uint256 public constant MAX_STORED_EPOCHS = 365;
    uint256 public constant TIMEOUT_DURATION = 2592000;
    uint256 public constant unresolved_313ce567 = 9;
    
    uint256 public unresolved_18160ddd; // storage slot: 0x02
    string public unresolved_06fdde03; // storage slot: 0x03
    string public unresolved_95d89b41; // storage slot: 0x04
    address public unresolved_8da5cb5b; // storage slot: 0x05
    bytes32 store_j; // storage slot: 0x05
    uint256 store_i; // storage slot: 0x06
    bytes store_a; // storage slot: 0x09
    
    mapping(address => uint256) public unresolved_70a08231; // storage slot: 0x00
    mapping(address => mapping(address => uint256)) storage_map_f; // storage slot: 0x01
    mapping(uint64 => bytes32) storage_map_b; // storage slot: 0x07
    mapping(uint64 => mapping(uint256 => uint8)) storage_map_d; // storage slot: 0x08
    
    error InvalidEpoch();
    event AdminControlActivated(uint256, string);
    event EpochCleaned(uint64);
    event Event_8be0079c();
    event Event_8c5be1e5();
    event GroupKeySubmitted(uint64, bytes, uint256);
    event NormalOperationRestored(uint64, uint256);
    event Transfer(address, address, uint256);
    event WGNKBurned(address, uint256, uint256);
    
    /// @custom:selector    0xbafe519e
    /// @custom:signature   checkAndHandleTimeout() public
    function checkAndHandleTimeout() public {
        if (uint8(store_a / 0x0100000000000000000000000000000000) <= 0x01 && (uint8(store_a / 0x0100000000000000000000000000000000) == 0x01 && block.timestamp - uint64(store_a / 0x010000000000000000) <= block.timestamp)) {
            require(block.timestamp - uint64(store_a / 0x010000000000000000) > 0x278d00, CustomError_9b0056ac());
            store_a = 0xffffffffffffffffffffffffffffff00ffffffffffffffffffffffffffffffff & store_a;
            emit AdminControlActivated(block.timestamp, 0x40, var_g);
        }
    }
    
    /// @custom:selector    0xdce67dfb
    /// @custom:signature   epochGroupKeys(uint64 arg0) public view returns (bytes memory)
    /// @param              arg0 ["uint64", "bytes8", "int64"]
    function epochGroupKeys(uint64 arg0) public view returns (bytes memory) {
        require(true);
        return abi.encodePacked(storage_map_b[arg0], storage_map_b[arg0].field_1, storage_map_b[arg0].field_2, storage_map_b[arg0].field_3, storage_map_b[arg0].field_4, storage_map_b[arg0].field_5, storage_map_b[arg0].field_6, storage_map_b[arg0].field_7);
    }
    
    /// @custom:selector    0xdc9d737c
    /// @custom:signature   epochMeta() public view returns (bytes memory)
    function epochMeta() public view returns (bytes memory) {
        if (uint8(store_a / 0x0100000000000000000000000000000000) < 0x02) {
            return abi.encodePacked(store_a, uint64(store_a / 0x010000000000000000), uint8(store_a / 0x0100000000000000000000000000000000), uint120(store_a / 0x010000000000000000000000000000000000));
        }
    }
    
    /// @custom:selector    0x43ab265f
    /// @custom:signature   getContractBalance(address arg0) public returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function getContractBalance(address arg0) public returns (uint256) {
        require(true);
        if (arg0 - address(this)) {
            (bool success, bytes memory ret0) = address(arg0).Unresolved_70a08231(address(this)); // staticcall
            require(success);
            uint256 var_c = var_c + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(var_c + ret0.length - var_c >= 0x20);
            return var_e;
        } else {
            return address(this).balance;
        }
    }
    
    /// @custom:selector    0x378aa701
    /// @custom:signature   getCurrentState() public view returns (bool)
    function getCurrentState() public view returns (bool) {
        if (uint8(store_a / 0x0100000000000000000000000000000000) < 0x02) {
            return uint8(store_a / 0x0100000000000000000000000000000000);
        }
    }
    
    /// @custom:selector    0x569b7446
    /// @custom:signature   getLatestEpochInfo() public view returns (bytes memory)
    function getLatestEpochInfo() public view returns (bytes memory) {
        uint256 var_m = msg.data[msg.data.length:msg.data.length + 0x0100];
        return abi.encodePacked(store_a, uint64(store_a / 0x010000000000000000), 0x60, var_o);
    }
    
    /// @custom:selector    0x75a28444
    /// @custom:signature   getWGNKInfo() public view
    function getWGNKInfo() public view {
    }
    
    /// @custom:selector    0xc633094e
    /// @custom:signature   isRequestProcessed(uint64 arg0, bytes32 arg1) public view returns (bool)
    /// @param              arg0 ["uint64", "bytes8", "int64"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function isRequestProcessed(uint64 arg0, bytes32 arg1) public view returns (bool) {
        require(true);
        return storage_map_d[arg0][arg1].field_0;
    }
    
    /// @custom:selector    0xe908154e
    /// @custom:signature   isTimeoutReached() public view returns (bool)
    function isTimeoutReached() public view returns (bool) {
        if (block.timestamp - uint64(store_a / 0x010000000000000000) <= block.timestamp) {
            return block.timestamp - uint64(store_a / 0x010000000000000000) > 0x278d00;
        }
    }
    
    /// @custom:selector    0x1a5dbca2
    /// @custom:signature   isValidEpoch(uint64 arg0) public view returns (bool)
    /// @param              arg0 ["uint64", "bytes8", "int64"]
    function isValidEpoch(uint64 arg0) public view returns (bool) {
        require(true);
        if (var_l) {
            return var_l;
        } else {
            return var_n;
        }
    }
    
    /// @custom:selector    0x8e7991aa
    /// @custom:signature   processedRequests(uint64 arg0, bytes32 arg1) public view returns (bool)
    /// @param              arg0 ["uint64", "bytes8", "int64"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function processedRequests(uint64 arg0, bytes32 arg1) public view returns (bool) {
        require(true);
        return storage_map_d[arg0][arg1].field_0;
    }
    
    /// @custom:selector    0xa90f5cc5
    /// @custom:signature   resetToNormalOperation() public
    function resetToNormalOperation() public {
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if (uint8(store_a / 0x0100000000000000000000000000000000) <= 0x01) {
            require(uint8(store_a / 0x0100000000000000000000000000000000) == 0, CustomError_9d2a9928());
            require(0 - store_a, CustomError_89555472());
            store_a = store_a & 0xffffffffffffffffffffffffffffff00ffffffffffffffffffffffffffffffff | 0x0100000000000000000000000000000000;
            emit NormalOperationRestored(store_a, block.timestamp);
        }
    }
    
    /// @custom:selector    0x095ea7b3
    /// @custom:signature   Unresolved_095ea7b3(address arg0, uint256 arg1) public returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_095ea7b3(address arg0, uint256 arg1) public returns (bool) {
        require(true);
        require(msg.sender, "ERC20: approve from the zero address");
        require(arg0, "ERC20: approve to the zero address");
        storage_map_f[msg.sender][arg0] = arg1;
        emit Event_8c5be1e5(msg.sender, arg0, arg1);
        return true;
    }
    
    /// @custom:selector    0x0d239595
    /// @custom:signature   Unresolved_0d239595(uint64 arg0, uint256 arg1) public
    /// @param              arg0 ["uint64", "bytes8", "int64"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_0d239595(uint64 arg0, uint256 arg1) public {
        require(true);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        if (uint8(store_a / 0x0100000000000000000000000000000000) <= 0x01) {
            require(uint8(store_a / 0x0100000000000000000000000000000000) == 0, CustomError_9d2a9928());
            if (store_a + 0x01 <= 0xffffffffffffffff) {
                require(arg0 >= uint64(store_a + 0x01), CustomError_4ee7e029());
                require(msg.data[0x04 + arg1] == 0x0100, "Invalid group key length");
                require(0x0100 == var_l, "Invalid group key length");
                storage_map_b[arg0] = var_l;
                storage_map_b[arg0].field_1 = var_n;
                storage_map_b[arg0].field_2 = var_p;
                storage_map_b[arg0].field_3 = var_r;
                storage_map_b[arg0].field_4 = var_t;
                storage_map_b[arg0].field_5 = var_v;
                storage_map_b[arg0].field_6 = var_x;
                storage_map_b[arg0].field_7 = var_z;
                if (uint8(store_a / 0x0100000000000000000000000000000000) <= 0x01) {
                    store_a = uint64(var_l) | store_a & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 | 0x010000000000000000 * uint64(var_n);
                    if (var_p <= 0x01) {
                        store_a = var_p * 0x0100000000000000000000000000000000 | 0xffffffffffffffffffffffffffffff00ffffffffffffffffffffffffffffffff & (uint64(var_l) | store_a & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000 | 0x010000000000000000 * uint64(var_n));
                        store_a = store_a | 0x010000000000000000000000000000000000 * uint120(var_ai);
                        if (arg0 > 0x016d) {
                            if (arg0 - 0x016d <= 0xffffffffffffffff) {
                                storage_map_b[uint64(arg0 - 0x016d)] = 0;
                                storage_map_b[uint64(arg0 - 0x016d)].field_1 = 0;
                                storage_map_b[uint64(arg0 - 0x016d)].field_2 = 0;
                                storage_map_b[uint64(arg0 - 0x016d)].field_3 = 0;
                                storage_map_b[uint64(arg0 - 0x016d)].field_4 = 0;
                                storage_map_b[uint64(arg0 - 0x016d)].field_5 = 0;
                                storage_map_b[uint64(arg0 - 0x016d)].field_6 = 0;
                                storage_map_b[uint64(arg0 - 0x016d)].field_7 = 0;
                                emit EpochCleaned(uint64(arg0 - 0x016d));
                                emit GroupKeySubmitted(arg0, 0x40, block.timestamp, msg.data[0x04 + arg1]);
                            }
                        } else {
                            emit GroupKeySubmitted(arg0, 0x40, block.timestamp, msg.data[0x04 + arg1]);
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x23b872dd
    /// @custom:signature   Unresolved_23b872dd(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_23b872dd(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0x39509351
    /// @custom:signature   Unresolved_39509351(address arg0, uint256 arg1) public returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_39509351(address arg0, uint256 arg1) public returns (bool) {
        require(true);
        if (storage_map_f[msg.sender][arg0] <= arg1 + storage_map_f[msg.sender][arg0]) {
            require(msg.sender, "ERC20: approve from the zero address");
            require(arg0, "ERC20: approve to the zero address");
            storage_map_f[msg.sender][arg0] += arg1;
            emit Event_8c5be1e5(msg.sender, arg0, arg1 + storage_map_f[msg.sender][arg0]);
            return true;
        }
    }
    
    /// @custom:selector    0x70a1f3e9
    /// @custom:signature   Unresolved_70a1f3e9(uint256 arg0, uint256 arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_70a1f3e9(uint256 arg0, uint256 arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        require(store_i - 0x02, "ReentrancyGuard: reentrant call");
        store_i = 0x02;
        if (uint8(store_a / 0x0100000000000000000000000000000000) <= 0x01) {
            require(uint8(store_a / 0x0100000000000000000000000000000000) == 0x01, CustomError_2745ed2e());
            require(0x04 + arg0 + 0x20 - (0x04 + arg0) >= 0x20);
            require(msg.data[0x04 + arg0] == uint64(msg.data[0x04 + arg0]));
            require(var_l, CustomError_d5b25b63());
            uint256 var_n = msg.data[msg.data.length:msg.data.length + 0x0100];
            require(0x04 + arg0 + 0x20 - (0x04 + arg0) >= 0x20);
            require(msg.data[0x04 + arg0] != uint64(msg.data[0x04 + arg0]), CustomError_a6bc74c4());
        }
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public
    function Unresolved_715018a6() public {
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        store_j = store_j & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
    }
    
    /// @custom:selector    0x969731f6
    /// @custom:signature   Unresolved_969731f6(uint64 arg0, uint256 arg1, uint256 arg2) public pure
    /// @param              arg0 ["uint64", "bytes8", "int64"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_969731f6(uint64 arg0, uint256 arg1, uint256 arg2) public pure {
        require(true);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(arg2 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0xa457c2d7
    /// @custom:signature   Unresolved_a457c2d7(address arg0, uint256 arg1) public returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_a457c2d7(address arg0, uint256 arg1) public returns (bool) {
        require(true);
        require(storage_map_f[msg.sender][arg0] >= arg1, "ERC20: decreased allowance below zero");
        require(msg.sender, "ERC20: approve from the zero address");
        require(arg0, "ERC20: approve to the zero address");
        storage_map_f[msg.sender][arg0] -= arg1;
        emit Event_8c5be1e5(msg.sender, arg0, storage_map_f[msg.sender][arg0] - arg1);
        return true;
    }
    
    /// @custom:selector    0xa9059cbb
    /// @custom:signature   Unresolved_a9059cbb(address arg0, uint256 arg1) public returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_a9059cbb(address arg0, uint256 arg1) public returns (bool) {
        require(true);
        if (arg0 - address(this)) {
            require(msg.sender, "ERC20: transfer from the zero address");
            require(arg0, "ERC20: transfer to the zero address");
            require(unresolved_70a08231[msg.sender] >= arg1, "ERC20: transfer amount exceeds balance");
            unresolved_70a08231[msg.sender] -= arg1;
            unresolved_70a08231[arg0] += arg1;
            emit Transfer(msg.sender, arg0, arg1);
        } else {
            require(msg.sender, "ERC20: burn from the zero address");
            require(unresolved_70a08231[msg.sender] >= arg1, "ERC20: burn amount exceeds balance");
            unresolved_70a08231[msg.sender] -= arg1;
            unresolved_18160ddd -= arg1;
            emit Transfer(msg.sender, 0, arg1);
            emit WGNKBurned(msg.sender, arg1, block.timestamp);
        }
        return true;
    }
    
    /// @custom:selector    0xb7c9e84a
    /// @custom:signature   Unresolved_b7c9e84a(uint256 arg0, uint256 arg1) public
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_b7c9e84a(uint256 arg0, uint256 arg1) public {
        require(arg0 <= 0xffffffffffffffff);
        require(store_i - 0x02, "ReentrancyGuard: reentrant call");
        store_i = 0x02;
        if (uint8(store_a / 0x0100000000000000000000000000000000) <= 0x01) {
            require(uint8(store_a / 0x0100000000000000000000000000000000) == 0x01, CustomError_2745ed2e());
            require(0x04 + arg0 + 0x20 - (0x04 + arg0) >= 0x20);
            require(msg.data[0x04 + arg0] == uint64(msg.data[0x04 + arg0]));
            require(var_l, CustomError_d5b25b63());
            uint256 var_n = msg.data[msg.data.length:msg.data.length + 0x0100];
            require(0x04 + arg0 + 0x20 - (0x04 + arg0) >= 0x20);
            require(msg.data[0x04 + arg0] != uint64(msg.data[0x04 + arg0]), CustomError_a6bc74c4());
        }
    }
    
    /// @custom:selector    0xdd62ed3e
    /// @custom:signature   Unresolved_dd62ed3e(address arg0) public pure
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_dd62ed3e(address arg0) public pure {
        require(true);
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, "Ownable: caller is not the owner");
        require(arg0, "Ownable: new owner is the zero address");
        store_j = arg0 | store_j & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
    }
}