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
    uint256 public constant MAX_CLAIM_AMOUNT = 1000000000000000000000000;
    uint256 public constant SIGNATURE_VALIDITY_PERIOD = 3600;
    uint256 public constant unresolved_0c16d3a0 = 1352225374288513897346627580573316169085029939119;
    uint256 public constant unresolved_5c424008 = 24;
    
    address public unresolved_8da5cb5b; // storage slot: 0x00
    bytes32 store_h; // storage slot: 0x00
    bytes32[] store_k; // storage slot: 0x02
    bytes32 store_e; // storage slot: 0x04
    uint8 store_f; // storage slot: 0x04
    address public withdrawAddress; // storage slot: 0x09
    bytes32 store_m; // storage slot: 0x09
    bytes32 store_j; // storage slot: keccak256(memory[var_a:var_a + (0x20 + (msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]] + var_a - var_a))])
    bytes32 store_l; // storage slot: keccak256(memory[var_a:var_a + (0x20 + (msg.data[0x04 + arg0] + var_a - var_a))])
    uint8 store_i; // storage slot: keccak256(memory[var_a + 0x20:var_a + 0x20 + (0x20 + var_e)])
    
    mapping(address => bytes32) storage_map_c; // storage slot: 0x06
    mapping(address => mapping(uint256 => bytes32)) storage_map_a; // storage slot: 0x07
    mapping(address => bytes32) storage_map_d; // storage slot: 0x08
    
    error CustomError_00000000();
    event Event_5db9ee0a();
    event Event_62e78cea();
    event Event_8be0079c();
    event Event_ae3402d6();
    event SignerUpdated(address, address);
    event TokensDeposited(address, uint256);
    event TokensWithdrawn(address, uint256);
    event WithdrawAddressUpdated(address, address);
    
    /// @custom:selector    0x181957b6
    /// @custom:signature   dailyWithdrawn(address arg0, uint256 arg1) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function dailyWithdrawn(address arg0, uint256 arg1) public view returns (uint256) {
        require(true);
        return storage_map_a[arg0][arg1];
    }
    
    /// @custom:selector    0xdd49756e
    /// @custom:signature   depositTokens(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function depositTokens(uint256 arg0) public payable {
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(0 - arg0, CustomError_1f2a2005());
        (bool success, bytes memory ret0) = address(0xecdbe2054968acf76039c4c28c41e8acc27f77af).Unresolved_23b872dd(msg.sender); // call
        require(success);
        if (!ret0.length) {
            require(address(0xecdbe2054968acf76039c4c28c41e8acc27f77af).code.length, CustomError_5274afe7());
        } else {
            require(0x01 == var_j, CustomError_5274afe7());
        }
        emit TokensDeposited(msg.sender, arg0);
    }
    
    /// @custom:selector    0x6f9fb98a
    /// @custom:signature   getContractBalance() public payable returns (uint256)
    function getContractBalance() public payable returns (uint256) {
        (bool success, bytes memory ret0) = address(0xecdbe2054968acf76039c4c28c41e8acc27f77af).Unresolved_70a08231(address(this)); // staticcall
        require(success);
        uint256 var_c = var_c + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
        require(var_c + ret0.length - var_c >= 0x20);
        return var_e;
    }
    
    /// @custom:selector    0x6c9230db
    /// @custom:signature   getCurrentTimestamp() public view returns (uint256)
    function getCurrentTimestamp() public view returns (uint256) {
        return block.timestamp;
    }
    
    /// @custom:selector    0xed24911d
    /// @custom:signature   getDomainSeparator() public view returns (uint256)
    function getDomainSeparator() public view returns (uint256) {
        if (0x9f954ca511ea6c453fc743d0d9b8fbf17e7d86c0 != address(this)) {
            if (0x9f954ca511ea6c453fc743d0d9b8fbf17e7d86c0 != address(this)) {
                uint256 var_g = 0xc0 + var_g;
                return keccak256(memory[0x20 + var_g:0x20 + var_g + var_i]);
            } else {
                return 0x779c19f4f264c4c118a0e5c9a082216f58a794915b1f3a6e6544be62e9d8676e;
            }
        } else {
            if (block.chainid != 0x01) {
                uint256 var_g = 0xc0 + var_g;
                return keccak256(memory[0x20 + var_g:0x20 + var_g + var_i]);
            } else {
                return 0x779c19f4f264c4c118a0e5c9a082216f58a794915b1f3a6e6544be62e9d8676e;
            }
        }
    }
    
    /// @custom:selector    0x6834e3a8
    /// @custom:signature   getUserNonce(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function getUserNonce(address arg0) public view returns (uint256) {
        require(true);
        return storage_map_c[arg0];
    }
    
    /// @custom:selector    0x2e46fed8
    /// @custom:signature   getUserTotalClaimed(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function getUserTotalClaimed(address arg0) public view returns (uint256) {
        require(true);
        return storage_map_d[arg0];
    }
    
    /// @custom:selector    0x128a3457
    /// @custom:signature   totalClaimedAmount(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function totalClaimedAmount(address arg0) public view returns (uint256) {
        require(true);
        return storage_map_d[arg0];
    }
    
    /// @custom:selector    0x238ac933
    /// @custom:signature   Unresolved_238ac933() public view returns (address)
    function Unresolved_238ac933() public view returns (address) {
        return address(store_e / 0x0100);
    }
    
    /// @custom:selector    0x3f4ba83a
    /// @custom:signature   Unresolved_3f4ba83a() public payable
    function Unresolved_3f4ba83a() public payable {
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(store_f, CustomError_8dfc202b());
        store_e = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & store_e;
        emit Event_5db9ee0a(msg.sender);
    }
    
    /// @custom:selector    0x401d4482
    /// @custom:signature   Unresolved_401d4482(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_401d4482(address arg0, uint256 arg1) public payable {
        require(true);
        require(msg.sender == withdrawAddress, CustomError_399a1623());
        require(0 - arg1, CustomError_1f2a2005());
        require(arg0, "Invalid recipient");
        (bool success, bytes memory ret0) = address(0xecdbe2054968acf76039c4c28c41e8acc27f77af).Unresolved_70a08231(address(this)); // staticcall
        require(success);
        uint256 var_c = var_c + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
        require(var_c + ret0.length - var_c >= 0x20);
        require(var_d >= arg1, CustomError_f4d678b8());
        (bool success, bytes memory ret0) = address(0xecdbe2054968acf76039c4c28c41e8acc27f77af).Unresolved_a9059cbb(arg0); // call
        require(success);
        if (!ret0.length) {
            require(address(0xecdbe2054968acf76039c4c28c41e8acc27f77af).code.length, CustomError_5274afe7());
        } else {
            require(0x01 == var_l, CustomError_5274afe7());
        }
        emit TokensWithdrawn(arg0, arg1);
    }
    
    /// @custom:selector    0x574782b5
    /// @custom:signature   Unresolved_574782b5(uint256 arg0, uint256 arg1, uint256 arg2, address arg3, uint256 arg4, uint256 arg5) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function Unresolved_574782b5(uint256 arg0, uint256 arg1, uint256 arg2, address arg3, uint256 arg4, uint256 arg5) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(true);
        require(arg5 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0x5c975abb
    /// @custom:signature   Unresolved_5c975abb() public view returns (bool)
    function Unresolved_5c975abb() public view returns (bool) {
        return store_f;
    }
    
    /// @custom:selector    0x6b3a4851
    /// @custom:signature   Unresolved_6b3a4851(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_6b3a4851(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(arg4 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public payable
    function Unresolved_715018a6() public payable {
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        store_h = store_h & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
    }
    
    /// @custom:selector    0x717f3d76
    /// @custom:signature   Unresolved_717f3d76(uint256 arg0) public view returns (bool)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_717f3d76(uint256 arg0) public view returns (bool) {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data.length > 0x04 + arg0 + 0x1f);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_a + (0x3f + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_a | var_a + (0x3f + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & msg.data[0x04 + arg0] + 0x1f) & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff)) {
            require(msg.data.length >= 0x20 + (msg.data[0x04 + arg0] + (0x04 + arg0)));
            return store_i;
        }
    }
    
    /// @custom:selector    0x832efbc6
    /// @custom:signature   Unresolved_832efbc6(uint256 arg0, uint256 arg1) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_832efbc6(uint256 arg0, uint256 arg1) public payable {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        if (0 < msg.data[0x04 + arg0] && 0 < msg.data[0x04 + arg0]) {
            require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0 + 0x20) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
            require(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]] <= 0xffffffffffffffff);
            require(0x20 + (0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]) <= msg.data.length - msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]]);
            store_j = store_j & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        }
    }
    
    /// @custom:selector    0x8456cb59
    /// @custom:signature   Unresolved_8456cb59() public payable
    function Unresolved_8456cb59() public payable {
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(!store_f, CustomError_d93c0665());
        store_e = 0x01 | 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00 & store_e;
        emit Event_62e78cea(msg.sender);
    }
    
    /// @custom:selector    0x84b0196e
    /// @custom:signature   Unresolved_84b0196e() public view returns (uint256)
    function Unresolved_84b0196e() public view returns (uint256) {
        if ((store_k & 0x01) - (store_k >> 0x01 < 0x20) && (store_k & 0x01) - (store_k >> 0x01 < 0x20)) {
            require(0x01 <= 0x1f, CustomError_b3512b0c());
            uint256 var_a = var_a + 0x20;
            return abi.encodePacked(0x0f00000000000000000000000000000000000000000000000000000000000000, 0xe0, var_a + 0xe0 + (var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 - var_a, block.chainid, address(this), 0, var_a + 0xe0 + (var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 + (var_k + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) + 0x20 - var_a, var_k, var_k, var_k);
        }
    }
    
    /// @custom:selector    0x9fd3f3a4
    /// @custom:signature   Unresolved_9fd3f3a4(uint256 arg0, uint256 arg1) public view returns (bytes memory)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_9fd3f3a4(uint256 arg0, uint256 arg1) public view returns (bytes memory) {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff) {
            if (0 >= msg.data[0x04 + arg0]) {
                return abi.encodePacked(0x20, var_f);
            } else {
                if (0 < msg.data[0x04 + arg0]) {
                    require(msg.data[0x04 + arg0 + 0x20] < msg.data.length - (0x04 + arg0 + 0x20) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                    require(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]] <= 0xffffffffffffffff);
                    require(0x20 + (0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]) <= msg.data.length - msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]]);
                }
            }
        }
    }
    
    /// @custom:selector    0xa7ecd37e
    /// @custom:signature   Unresolved_a7ecd37e(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_a7ecd37e(address arg0) public payable {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(arg0, CustomError_815e1d64());
        store_e = store_e & 0xffffffffffffffffffffff0000000000000000000000000000000000000000ff | 0x0100 * arg0;
        emit SignerUpdated(address(store_e / 0x0100), arg0);
    }
    
    /// @custom:selector    0xaa24c20d
    /// @custom:signature   Unresolved_aa24c20d(uint256 arg0, uint256 arg1, uint256 arg2, address arg3, uint256 arg4) public pure returns (uint256)
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    function Unresolved_aa24c20d(uint256 arg0, uint256 arg1, uint256 arg2, address arg3, uint256 arg4) public pure returns (uint256) {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(true);
        uint256 var_a = var_a;
        uint256 var_c = msg.data[0x04 + arg0 + 0x20:0x04 + arg0 + 0x20 + msg.data[0x04 + arg0]];
        uint256 var_b = 0xc0 + (0x20 + var_b);
        return keccak256(memory[0x20 + var_b:0x20 + var_b + var_c]);
    }
    
    /// @custom:selector    0xac109d20
    /// @custom:signature   Unresolved_ac109d20(uint256 arg0) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    function Unresolved_ac109d20(uint256 arg0) public payable {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        store_l = store_l & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        emit Event_ae3402d6(keccak256(memory[var_a:var_a + (msg.data[0x04 + arg0] + var_a - var_a)]), msg.sender);
    }
    
    /// @custom:selector    0xbc1133de
    /// @custom:signature   Unresolved_bc1133de(uint256 arg0, uint256 arg1) public pure
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_bc1133de(uint256 arg0, uint256 arg1) public pure {
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(arg1 <= 0xffffffffffffffff);
    }
    
    /// @custom:selector    0xf2fde38b
    /// @custom:signature   Unresolved_f2fde38b(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_f2fde38b(address arg0) public payable {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(arg0, CustomError_1e4fbdf7());
        store_h = arg0 | store_h & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, arg0);
    }
    
    /// @custom:selector    0xa3f4b573
    /// @custom:signature   updateWithdrawAddress(address arg0) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function updateWithdrawAddress(address arg0) public payable {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(arg0, "Invalid address");
        store_m = arg0 | store_m & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit WithdrawAddressUpdated(withdrawAddress, arg0);
    }
    
    /// @custom:selector    0x2f7801f4
    /// @custom:signature   userNonces(address arg0) public view returns (uint256)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function userNonces(address arg0) public view returns (uint256) {
        require(true);
        return storage_map_c[arg0];
    }
    
    /// @custom:selector    0x06b091f9
    /// @custom:signature   withdrawTokens(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function withdrawTokens(address arg0, uint256 arg1) public payable {
        require(true);
        require(msg.sender == unresolved_8da5cb5b, CustomError_118cdaa7());
        require(0 - arg1, CustomError_1f2a2005());
        require(arg0, "Invalid recipient");
        (bool success, bytes memory ret0) = address(0xecdbe2054968acf76039c4c28c41e8acc27f77af).Unresolved_70a08231(address(this)); // staticcall
        require(success);
        uint256 var_c = var_c + (ret0.length + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
        require(var_c + ret0.length - var_c >= 0x20);
        require(var_d >= arg1, CustomError_f4d678b8());
        (bool success, bytes memory ret0) = address(0xecdbe2054968acf76039c4c28c41e8acc27f77af).Unresolved_a9059cbb(arg0); // call
        require(success);
        if (!ret0.length) {
            require(address(0xecdbe2054968acf76039c4c28c41e8acc27f77af).code.length, CustomError_5274afe7());
        } else {
            require(0x01 == var_l, CustomError_5274afe7());
        }
        emit TokensWithdrawn(arg0, arg1);
    }
}