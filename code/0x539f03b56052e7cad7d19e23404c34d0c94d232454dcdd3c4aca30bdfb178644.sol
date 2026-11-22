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
    uint256 public constant balancerVault = 1062276670219503018717391839032010498165418226376;
    uint256 public constant uniV3Router = 597733001430176024049334587394716596403930790981;
    uint256 public constant unresolved_0603d94d = 2;
    uint256 public constant unresolved_2be06d02 = 3;
    uint256 public constant unresolved_3fc8cef3 = 1097077688018008265106216665536940668749033598146;
    uint256 public constant unresolved_54fd4d50 = 7;
    uint256 public constant unresolved_86e17f06 = 605154339281116420547311282322497593355161047144;
    uint256 public constant unresolved_950bff9f = 32;
    uint256 public constant unresolved_958c2e52 = 697323163401596485410334513241460920685086001293;
    uint256 public constant unresolved_e8ce1bfa = 1071767867375834718561649552532670117991385333707;
    
    address public unresolved_8da5cb5b; // storage slot: 0x00
    bytes32 store_g; // storage slot: 0x00
    address store_h; // storage slot: 0x01
    bytes32 store_d; // storage slot: 0x01
    uint8 store_c; // storage slot: 0x01
    bytes32 tstore_d; // storage slot: unknown
    bytes32 tstore_e; // storage slot: unknown
    bytes32 tstore_f; // storage slot: unknown
    bytes32 tstore_h; // storage slot: unknown
    bytes32 tstore_j; // storage slot: unknown
    uint256 tstore_a; // storage slot: unknown
    uint256 tunresolved_8da5cb5b; // storage slot: unknown
    uint256 tstore_c; // storage slot: unknown
    uint256 tstore_g; // storage slot: unknown
    uint256 tstore_i; // storage slot: unknown
    
    mapping(uint8 => address) storage_map_e; // storage slot: 0x02
    mapping(address => bytes32) storage_map_i; // storage slot: 0x03
    mapping(address => bytes32) storage_map_f; // storage slot: 0x04
    mapping(address => bytes32) storage_map_a; // storage slot: 0x05
    
    error CoinbasePaymentFailed();
    event AllowedTargetUpdated(address, bool);
    event BatchExecuted(uint256, uint256, uint256, uint256, uint256);
    event Event_4b600d6b();
    event Event_5db9ee0a();
    event Event_62e78cea();
    event Event_8be0079c();
    event Event_9875cb71();
    event OperatorUpdated(address, bool);
    event OwnershipTransferStarted(address, address);
    event Withdraw(address, address, uint256);
    
    /// @custom:selector    0x13e7c9d8
    /// @custom:signature   operators(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function operators(address arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_a[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x7ae26773
    /// @custom:signature   revokeAllowance(address arg0, address arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    function revokeAllowance(address arg0, address arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg1, CustomError_d92e233d());
        (bool success, bytes memory ret0) = address(msg.sender).Unresolved_095ea7b3(arg1); // call
        if (success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01 && !success) {
            (bool success, bytes memory ret0) = address(msg.sender).Unresolved_095ea7b3(arg1, 0); // call
            require(!(success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01), CustomError_5274afe7());
            require(!success & 0x01, CustomError_5274afe7());
        }
    }
    
    /// @custom:selector    0x09c5eabe
    /// @custom:signature   Unresolved_09c5eabe(uint256 arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    function Unresolved_09c5eabe(uint256 arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(storage_map_a[msg.sender].field_0, CustomError_4d739bfe());
        require(!store_c, CustomError_d93c0665());
        require(!tstore_a, CustomError_3ee5aeb5());
        tstore_a = 0x01;
        require(0x04 + arg0 + 0x20 + msg.data[0x04 + arg0] - (0x04 + arg0 + 0x20) >= 0x20);
        require(msg.data[0x04 + arg0 + 0x20] <= 0xffffffffffffffff);
        require(0x04 + arg0 + 0x20 + msg.data[0x04 + arg0] - (0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]) >= 0xc0);
        if (!(var_d + 0xc0 > 0xffffffffffffffff | var_d + 0xc0 < var_d)) {
            uint256 var_d = var_d + 0xc0;
            require(!(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]] - uint8(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]])));
            require(!(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x20] - address(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x20])));
            require(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80] <= 0xffffffffffffffff);
            require(0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80] + 0x1f < 0x04 + arg0 + 0x20 + msg.data[0x04 + arg0]);
            if (msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80]] <= 0xffffffffffffffff && !(var_d + (0x20 + (msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80]] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (0x20 + (msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80]] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
                uint256 var_d = var_d + (0x20 + (var_i << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                require(0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80] + (msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80]] << 0x05) + 0x20 <= 0x04 + arg0 + 0x20 + msg.data[0x04 + arg0]);
                if (0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80] + 0x20 < 0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80] + (msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80]] << 0x05) + 0x20) {
                    require(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80] + 0x20] <= 0xffffffffffffffff);
                    require(0x04 + arg0 + 0x20 + msg.data[0x04 + arg0] - (0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80] + 0x20]) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 >= 0x0120);
                    if (!(var_d + 0x0120 > 0xffffffffffffffff | var_d + 0x0120 < var_d)) {
                        uint256 var_d = var_d + 0x0120;
                        require(!(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80] + 0x20] + 0x20] - address(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80] + 0x20] + 0x20])));
                        require(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80] + 0x20] + 0x80] - uint16(msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x80] + 0x20] + 0x80]));
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x10d1e85c
    /// @custom:signature   Unresolved_10d1e85c(address arg0, uint256 arg1, uint256 arg2) public view
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_10d1e85c(address arg0, uint256 arg1, uint256 arg2) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x80);
        require(!(arg0 - arg0));
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        require(!(address(this) - arg0), CustomError_ced0f98c());
        tunresolved_8da5cb5b = 0;
        tstore_c = 0;
        require(address(tunresolved_8da5cb5b), CustomError_c0d73a51());
        require(msg.sender == address(tunresolved_8da5cb5b), CustomError_c0d73a51());
        if (msg.data[0x04 + arg3] <= 0xffffffffffffffff && !(var_d + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg3]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg3]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            uint256 var_d = var_d + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg3]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(!(keccak256(memory[var_d + 0x20:var_d + 0x20 + var_g]) - tstore_c), CustomError_a717ed2a());
            require(0x04 + arg3 + 0x20 + msg.data[0x04 + arg3] - (0x04 + arg3 + 0x20) >= 0xc0);
            require(msg.data[0x04 + arg3 + 0x20] <= 0xffffffffffffffff);
            require(0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x1f < 0x04 + arg3 + 0x20 + msg.data[0x04 + arg3]);
        }
    }
    
    /// @custom:selector    0x23a69e75
    /// @custom:signature   Unresolved_23a69e75(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_23a69e75(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        if (!msg.data[0x04 + arg2]) {
            tunresolved_8da5cb5b = 0;
            require(address(tunresolved_8da5cb5b), CustomError_c0d73a51());
            require(msg.sender == address(tunresolved_8da5cb5b), CustomError_c0d73a51());
            if (arg0 > 0) {
                require(arg1 <= 0, CustomError_71fec290());
                require(arg0, CustomError_71fec290());
                require(arg0 <= tstore_d, CustomError_0d86d6e1());
                (bool success, bytes memory ret0) = address(address(tstore_e)).Unresolved_a9059cbb(address(tunresolved_8da5cb5b)); // call
                if (!(success & 0xa9059cbb00000000000000000000000000000000000000000000000000000000 == 0x01)) {
                    require(!(!success & 0x01));
                    require(!ret0.length & address(tstore_e).code.length & success, CustomError_5274afe7());
                } else {
                    var_g = var_g;
                    require(success, CustomError_5274afe7());
                }
            }
        } else {
            tunresolved_8da5cb5b = 0;
            tstore_c = 0;
            require(address(tunresolved_8da5cb5b), CustomError_c0d73a51());
            require(msg.sender == address(tunresolved_8da5cb5b), CustomError_c0d73a51());
            if (msg.data[0x04 + arg2] <= 0xffffffffffffffff && !(var_g + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg2]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_g + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg2]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_g)) {
                uint256 var_g = var_g + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg2]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                require(!(keccak256(memory[var_g + 0x20:var_g + 0x20 + var_j]) - tstore_c), CustomError_a717ed2a());
                require(0x04 + arg2 + 0x20 + msg.data[0x04 + arg2] - (0x04 + arg2 + 0x20) >= 0xc0);
                require(msg.data[0x04 + arg2 + 0x20] <= 0xffffffffffffffff);
                require(0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20] + 0x1f < 0x04 + arg2 + 0x20 + msg.data[0x04 + arg2]);
            }
        }
    }
    
    /// @custom:selector    0x28580b87
    /// @custom:signature   Unresolved_28580b87(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_28580b87(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(block.number <= arg0, CustomError_83f2ba20());
        require(storage_map_a[msg.sender].field_0, CustomError_4d739bfe());
        require(!store_c, CustomError_d93c0665());
        require(!tstore_a, CustomError_3ee5aeb5());
        tstore_a = 0x01;
        if (!(var_f + 0xc0 > 0xffffffffffffffff | var_f + 0xc0 < var_f)) {
            uint256 var_f = var_f + 0xc0;
            if (msg.data[0x04 + arg1]) {
                require(msg.data[0x04 + arg1 + 0x20] >> 0xf8 == 0x01, CustomError_7a3dba7d());
                if (0x01 < msg.data[0x04 + arg1]) {
                    require(0x16 <= msg.data[0x04 + arg1]);
                    require(0x26 <= msg.data[0x04 + arg1]);
                    require(0x36 <= msg.data[0x04 + arg1]);
                    require(0x46 <= msg.data[0x04 + arg1]);
                    if (0x46 < msg.data[0x04 + arg1] && (msg.data[0x04 + arg1 + 0x20 + 0x46] >> 0xf8 <= 0xffffffffffffffff && !(var_f + (0x20 + (msg.data[0x04 + arg1 + 0x20 + 0x46] >> 0xf8 << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_f + (0x20 + (msg.data[0x04 + arg1 + 0x20 + 0x46] >> 0xf8 << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_f))) {
                        uint256 var_f = var_f + (0x20 + (0x7a3dba7d00000000000000000000000000000000000000000000000000000000 << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                        if (msg.data[0x04 + arg1 + 0x20 + 0x46] >> 0xf8 <= 0xffffffffffffffff && 0 >= 0x20 + (msg.data[0x04 + arg1 + 0x20 + 0x46] >> 0xf8 << 0x05) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) {
                            if (0 >= msg.data[0x04 + arg1 + 0x20 + 0x46] >> 0xf8) {
                                require(!(0x47 - msg.data[0x04 + arg1]), CustomError_7a3dba7d());
                            } else {
                                if (0x47 <= 0x99) {
                                    require(msg.data[0x04 + arg1] >= 0x99, CustomError_7a3dba7d());
                                    if (0 < var_aa && 0x47 <= 0x5b) {
                                        require(0x47 <= 0x5b);
                                        require(0x5b <= msg.data[0x04 + arg1]);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x31f57072
    /// @custom:signature   Unresolved_31f57072(uint256 arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    function Unresolved_31f57072(uint256 arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(tstore_f, CustomError_62ac0f37());
        require(tstore_g, CustomError_a562fe00());
        require(!(msg.sender - 0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb), CustomError_ced0f98c());
        if (msg.data[0x04 + arg1] <= 0xffffffffffffffff && !(var_d + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg1]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            uint256 var_d = var_d + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + 0xced0f98c00000000000000000000000000000000000000000000000000000000) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_a = msg.data[0x04 + arg1];
            uint256 var_e = msg.data[0x04 + arg1 + 0x20:0x04 + arg1 + 0x20 + var_a];
            require(!(keccak256(memory[var_d + 0x20:var_d + 0x20 + var_g]) - tstore_g), CustomError_21f24259());
            tstore_g = 0;
            require(0x04 + arg1 + 0x20 + msg.data[0x04 + arg1] - (0x04 + arg1 + 0x20) >= 0x20);
            require(msg.data[0x04 + arg1 + 0x20] <= 0xffffffffffffffff);
            require(0x04 + arg1 + 0x20 + msg.data[0x04 + arg1] - (0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20]) >= 0xc0);
            if (!(var_d + 0xc0 > 0xffffffffffffffff | var_d + 0xc0 < var_d)) {
                uint256 var_d = var_d + 0xc0;
                require(!(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20]] - uint8(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20]])));
                require(!(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x20] - address(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x20])));
                require(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] <= 0xffffffffffffffff);
                require(0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + 0x1f < 0x04 + arg1 + 0x20 + msg.data[0x04 + arg1]);
                if (msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80]] <= 0xffffffffffffffff && !(var_d + (0x20 + (msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80]] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (0x20 + (msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80]] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
                    uint256 var_d = var_d + (0x20 + (var_k << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                    require(0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + (msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80]] << 0x05) + 0x20 <= 0x04 + arg1 + 0x20 + msg.data[0x04 + arg1]);
                    if (0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + 0x20 < 0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + (msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80]] << 0x05) + 0x20) {
                        require(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + 0x20] <= 0xffffffffffffffff);
                        require(0x04 + arg1 + 0x20 + msg.data[0x04 + arg1] - (0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + 0x20]) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 >= 0x0120);
                        if (!(var_d + 0x0120 > 0xffffffffffffffff | var_d + 0x0120 < var_d)) {
                            uint256 var_d = var_d + 0x0120;
                            require(!(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + 0x20] + 0x20] - address(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + 0x20] + 0x20])));
                            require(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + 0x20] + 0x80] - uint16(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + 0x20] + 0x80]));
                        }
                    } else {
                        require(!(arg0 - var_q), CustomError_dafc5d75());
                        (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_70a08231(address(this), var_s); // staticcall
                        require(success);
                        if (!success) {
                            require(var_q <= 0, CustomError_bafe1c53());
                            (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_70a08231(address(this), var_s); // staticcall
                            require(success);
                            if (!success) {
                                if (address(var_e) != 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2) {
                                    if (var_u + type(uint256).max <= var_u && var_u + type(uint256).max < var_u) {
                                        (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).Unresolved_70a08231(address(this), var_s); // staticcall
                                        require(success);
                                        if (!success) {
                                            require(!address(0xf70e6dd9b28f55e158f13821f36994b17552d2b9).code.length);
                                        }
                                    }
                                } else {
                                    if (address(var_e) == 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2) {
                                        if (address(this)) {
                                            require(address(0xf70e6dd9b28f55e158f13821f36994b17552d2b9).code.length);
                                            if (0 >= var_u) {
                                                (bool success, bytes memory ret0) = address(0xf70e6dd9b28f55e158f13821f36994b17552d2b9).Unresolved_71aa4415(0xa0, address(var_e), arg0); // delegatecall
                                                require(success);
                                                address var_s = address(var_e);
                                                (bool success, bytes memory ret0) = address(0xa8b5a60b91cf4cc3673823939f3579c1a8a3eed6).Unresolved_f704a85e(address(var_e), var_s, 0); // delegatecall
                                                require(success);
                                                if (!success) {
                                                    if (!address(this)) {
                                                        (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_70a08231(address(this), var_s); // staticcall
                                                        require(success);
                                                        require(success, CustomError_1a3b8ce6());
                                                        if (!(var_d + 0x20 > 0xffffffffffffffff | var_d + 0x20 < var_d)) {
                                                            uint256 var_d = var_d + 0x20;
                                                            require(var_d + 0x20 - var_d < 0x20);
                                                        }
                                                    } else {
                                                        if (address(var_e) != 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2) {
                                                            (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).Unresolved_70a08231(address(this), 0); // staticcall
                                                            require(success);
                                                        } else {
                                                            if (tstore_h) {
                                                                if (0 * tstore_h / 0 == tstore_h | !0) {
                                                                    require(address(0xa8b5a60b91cf4cc3673823939f3579c1a8a3eed6).code.length);
                                                                    (bool success, bytes memory ret0) = address(0xa8b5a60b91cf4cc3673823939f3579c1a8a3eed6).Unresolved_dbf4e91f(0 * tstore_h / 0x2710, 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2, 0); // delegatecall
                                                                    require(success);
                                                                    if (success) {
                                                                        if (var_d <= 0xffffffffffffffff) {
                                                                            uint256 var_d = var_d;
                                                                            revert();
                                                                        }
                                                                    } else {
                                                                        (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_70a08231(address(this), 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2); // staticcall
                                                                        require(success);
                                                                        if (success) {
                                                                            if (!(var_d + 0x20 > 0xffffffffffffffff | var_d + 0x20 < var_d)) {
                                                                                uint256 var_d = var_d + 0x20;
                                                                                require(var_d + 0x20 - var_d < 0x20);
                                                                            }
                                                                        } else {
                                                                            require(0 >= arg0, CustomError_1a3b8ce6());
                                                                            (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_095ea7b3(msg.sender, arg0); // call
                                                                            if (success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01) {
                                                                                (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_095ea7b3(msg.sender, 0); // call
                                                                                if (!(success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01)) {
                                                                                    require(!success & 0x01, CustomError_5274afe7());
                                                                                } else {
                                                                                    require(success, CustomError_5274afe7());
                                                                                    (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_095ea7b3(msg.sender, arg0); // call
                                                                                    if (!(success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01)) {
                                                                                        require(!success & 0x01, CustomError_5274afe7());
                                                                                    } else {
                                                                                        uint256 var_d = var_d;
                                                                                        require(success, CustomError_5274afe7());
                                                                                        require(address(0xa8b5a60b91cf4cc3673823939f3579c1a8a3eed6).code.length);
                                                                                        uint256 var_s = 0 * tstore_h / 0x2710;
                                                                                        (bool success, bytes memory ret0) = address(0xa8b5a60b91cf4cc3673823939f3579c1a8a3eed6).Unresolved_30ff8fc6(0, var_s, var_av); // delegatecall
                                                                                        require(success);
                                                                                        if (success) {
                                                                                            require(var_d > 0xffffffffffffffff);
                                                                                        } else {
                                                                                            if (0 == (address(var_e) != 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2)) {
                                                                                                emit Event_9875cb71(tstore_g, address(var_e), 0, var_s);
                                                                                            } else {
                                                                                                emit Event_9875cb71(tstore_g, 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2, 0, var_s);
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            } else {
                                                                (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_70a08231(address(this), var_s); // staticcall
                                                                require(success);
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            require(!address(0xf70e6dd9b28f55e158f13821f36994b17552d2b9).code.length);
                                        }
                                    } else {
                                        (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).Unresolved_70a08231(address(this), var_s); // staticcall
                                        require(success);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x3f4ba83a
    /// @custom:signature   Unresolved_3f4ba83a() public payable
    function Unresolved_3f4ba83a() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(store_c, CustomError_8dfc202b());
        store_d = 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff & store_d;
        emit Event_5db9ee0a(msg.sender);
    }
    
    /// @custom:selector    0x558a7297
    /// @custom:signature   Unresolved_558a7297(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_558a7297(address arg0, uint256 arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg0, CustomError_d92e233d());
        storage_map_a[arg0] = uint8(arg1) | storage_map_a[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        emit OperatorUpdated(arg0, arg1);
    }
    
    /// @custom:selector    0x5a908609
    /// @custom:signature   Unresolved_5a908609(bool arg0) public view returns (address)
    /// @param              arg0 ["bool", "uint8", "bytes1", "int8"]
    function Unresolved_5a908609(bool arg0) public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - uint8(arg0)));
        var_c = storage_map_e[uint8(arg0)].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x5c975abb
    /// @custom:signature   Unresolved_5c975abb() public view returns (bool)
    function Unresolved_5c975abb() public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_c;
    }
    
    /// @custom:selector    0x6a8ac355
    /// @custom:signature   Unresolved_6a8ac355(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_6a8ac355(address arg0, uint256 arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg0, CustomError_d92e233d());
        storage_map_f[arg0] = uint8(arg1) | storage_map_f[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        emit Event_4b600d6b(arg0, arg1);
    }
    
    /// @custom:selector    0x715018a6
    /// @custom:signature   Unresolved_715018a6() public payable
    function Unresolved_715018a6() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        store_d = store_d & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        store_g = store_g & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        emit Event_8be0079c(unresolved_8da5cb5b, 0);
    }
    
    /// @custom:selector    0x76f34995
    /// @custom:signature   Unresolved_76f34995(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_76f34995(address arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_f[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0x79ba5097
    /// @custom:signature   Unresolved_79ba5097() public payable
    function Unresolved_79ba5097() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(store_h - msg.sender), CustomError_118cdaa7());
        store_d = store_d & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000;
        store_g = store_g & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | msg.sender;
        emit Event_8be0079c(unresolved_8da5cb5b, msg.sender);
    }
    
    /// @custom:selector    0x813d363d
    /// @custom:signature   Unresolved_813d363d(uint256 arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    function Unresolved_813d363d(uint256 arg0, uint256 arg1, address arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(arg1 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg1] <= 0xffffffffffffffff);
        require(block.number <= arg0, CustomError_83f2ba20());
        require(storage_map_a[msg.sender].field_0, CustomError_4d739bfe());
        require(!store_c, CustomError_d93c0665());
        require(!tstore_a, CustomError_3ee5aeb5());
        tstore_a = 0x01;
        require(0x04 + arg1 + 0x20 + msg.data[0x04 + arg1] - (0x04 + arg1 + 0x20) >= 0x20);
        require(msg.data[0x04 + arg1 + 0x20] <= 0xffffffffffffffff);
        require(0x04 + arg1 + 0x20 + msg.data[0x04 + arg1] - (0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20]) >= 0xc0);
        if (!(var_f + 0xc0 > 0xffffffffffffffff | var_f + 0xc0 < var_f)) {
            uint256 var_f = var_f + 0xc0;
            require(!(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20]] - uint8(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20]])));
            require(!(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x20] - address(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x20])));
            require(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] <= 0xffffffffffffffff);
            require(0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + 0x1f < 0x04 + arg1 + 0x20 + msg.data[0x04 + arg1]);
            if (msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80]] <= 0xffffffffffffffff && !(var_f + (0x20 + (msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80]] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_f + (0x20 + (msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80]] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_f)) {
                uint256 var_f = var_f + (0x20 + (var_k << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                require(0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + (msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80]] << 0x05) + 0x20 <= 0x04 + arg1 + 0x20 + msg.data[0x04 + arg1]);
                if (0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + 0x20 < 0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + (msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80]] << 0x05) + 0x20) {
                    require(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + 0x20] <= 0xffffffffffffffff);
                    require(0x04 + arg1 + 0x20 + msg.data[0x04 + arg1] - (0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + 0x20]) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 >= 0x0120);
                    if (!(var_f + 0x0120 > 0xffffffffffffffff | var_f + 0x0120 < var_f)) {
                        uint256 var_f = var_f + 0x0120;
                        require(!(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + 0x20] + 0x20] - address(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + 0x20] + 0x20])));
                        require(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + 0x20] + 0x80] - uint16(msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg1 + 0x20 + msg.data[0x04 + arg1 + 0x20] + 0x80] + 0x20] + 0x80]));
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x8456cb59
    /// @custom:signature   Unresolved_8456cb59() public payable
    function Unresolved_8456cb59() public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(!store_c, CustomError_d93c0665());
        store_d = store_d & 0xffffffffffffffffffffff00ffffffffffffffffffffffffffffffffffffffff | 0x010000000000000000000000000000000000000000;
        emit Event_62e78cea(msg.sender);
    }
    
    /// @custom:selector    0x84800812
    /// @custom:signature   Unresolved_84800812(address arg0, uint256 arg1, uint256 arg2) public view
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_84800812(address arg0, uint256 arg1, uint256 arg2) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x80);
        require(!(arg0 - arg0));
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        require(!(address(this) - arg0), CustomError_ced0f98c());
        tunresolved_8da5cb5b = 0;
        tstore_c = 0;
        require(address(tunresolved_8da5cb5b), CustomError_c0d73a51());
        require(msg.sender == address(tunresolved_8da5cb5b), CustomError_c0d73a51());
        if (msg.data[0x04 + arg3] <= 0xffffffffffffffff && !(var_d + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg3]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg3]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            uint256 var_d = var_d + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg3]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(!(keccak256(memory[var_d + 0x20:var_d + 0x20 + var_g]) - tstore_c), CustomError_a717ed2a());
            require(0x04 + arg3 + 0x20 + msg.data[0x04 + arg3] - (0x04 + arg3 + 0x20) >= 0xc0);
            require(msg.data[0x04 + arg3 + 0x20] <= 0xffffffffffffffff);
            require(0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x1f < 0x04 + arg3 + 0x20 + msg.data[0x04 + arg3]);
        }
    }
    
    /// @custom:selector    0x8a994829
    /// @custom:signature   Unresolved_8a994829(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, address arg6, uint24 arg7, uint256 arg8, address arg9, address arg10) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg8 ["uint24", "bytes3", "int24"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg11 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_8a994829(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, address arg6, uint24 arg7, uint256 arg8, address arg9, address arg10) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x80);
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg2] << 0x05) + (0x04 + arg2) + 0x20 <= msg.data.length);
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        require((msg.data[0x04 + arg3] << 0x05) + (0x04 + arg3) + 0x20 <= msg.data.length);
        require(block.number <= arg0, CustomError_83f2ba20());
        require(storage_map_a[msg.sender].field_0, CustomError_4d739bfe());
        require(!store_c, CustomError_d93c0665());
        require(!tstore_a, CustomError_3ee5aeb5());
        tstore_a = 0x01;
        require(msg.data[0x04 + arg2], CustomError_21f24259());
        require(msg.data[0x04 + arg2] <= 0x20, CustomError_21f24259());
        require(msg.data[0x04 + arg3] == msg.data[0x04 + arg2], CustomError_21f24259());
        require(msg.value <= 0x2710, CustomError_21f24259());
        (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).Unresolved_70a08231(address(this)); // staticcall
        require(success);
        if (!success) {
            if (0 < msg.data[0x04 + arg2]) {
                if (0 < msg.data[0x04 + arg2]) {
                    require(msg.data[0x04 + arg2 + 0x20] < msg.data.length - (0x04 + arg2 + 0x20) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                    require(msg.data[0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]] <= 0xffffffffffffffff);
                    require(0x20 + (0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]) <= msg.data.length - msg.data[0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]]);
                    if (msg.data[0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]]) {
                        require(0x16 <= msg.data[0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]]);
                        if (0 < msg.data[0x04 + arg3]) {
                            require(msg.data[0x04 + arg3 + 0x20] < msg.data.length - (0x04 + arg3 + 0x20) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff21);
                            require(!(msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20]] - address(msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20]])));
                            if (0 < msg.data[0x04 + arg2]) {
                                require(msg.data[0x04 + arg2 + 0x20] < msg.data.length - (0x04 + arg2 + 0x20) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe1);
                                require(msg.data[0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]] <= 0xffffffffffffffff);
                                require(0x20 + (0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]) <= msg.data.length - msg.data[0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]]);
                                if (msg.data[0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]]) {
                                    require(0x16 <= msg.data[0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]]);
                                    require(0x5b <= msg.data[0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]]);
                                    require(0x5d <= msg.data[0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]]);
                                    if (!(msg.data[0x20 + (0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]) + 0x5b] >> 0xf0 & 0x0140)) {
                                        require(0x9b <= msg.data[0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]]);
                                        require(0x015b <= msg.data[0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]]);
                                        require(!(msg.data[0x20 + (0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]) + 0x9b] - address(msg.data[0x20 + (0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]) + 0x9b])));
                                        require(!(msg.data[0x20 + (0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]) + 0xbb] - address(msg.data[0x20 + (0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]) + 0xbb])));
                                        require(!(msg.data[0x20 + (0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]) + 0xdb] - uint24(msg.data[0x20 + (0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]) + 0xdb])));
                                        require(!(msg.data[0x20 + (0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]) + 0xfb] - 11));
                                        require(!(msg.data[0x20 + (0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]) + 0x011b] - address(msg.data[0x20 + (0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]) + 0x011b])));
                                        require(!(msg.data[0x20 + (0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]) + 0x013b] - address(msg.data[0x20 + (0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]) + 0x013b])));
                                        var_j = 11;
                                        if (!(var_l + 0xc0 > 0xffffffffffffffff | var_l + 0xc0 < var_l)) {
                                            uint256 var_l = var_l + 0xc0;
                                        }
                                    } else {
                                        if (0x99 < msg.data[0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]]) {
                                            require(0xae <= msg.data[0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]]);
                                            if (!(var_l + 0x40 > 0xffffffffffffffff | var_l + 0x40 < var_l)) {
                                                uint256 var_l = var_l + 0x40;
                                                (bool success, bytes memory ret0) = address(msg.data[0x20 + (0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20]) + 0x47] >> 0x60).slot0(); // staticcall
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } else {
                (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).Unresolved_70a08231(address(this), block.number); // staticcall
                require(success);
                if (!success && 0 <= 0) {
                    require(0, CustomError_03da0de8());
                    if (0 * msg.value / 0 == msg.value | !0) {
                        require(address(0xa8b5a60b91cf4cc3673823939f3579c1a8a3eed6).code.length);
                        (bool success, bytes memory ret0) = address(0xa8b5a60b91cf4cc3673823939f3579c1a8a3eed6).Unresolved_dbf4e91f(var_j, 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2, var_r); // delegatecall
                        require(success);
                        if (!success && 0 - 0 * msg.value / 0x2710 <= 0) {
                            if (0 - 0 * msg.value / 0x2710 < arg1) {
                                require(0 - 0 * msg.value / 0x2710 > 0, CustomError_4e88422a());
                            } else {
                                uint256 var_a = msg.data[0x04 + arg2];
                                emit BatchExecuted(var_a, 0, 0, 0, 0 * msg.value / 0x2710);
                                tstore_a = 0;
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0x91dd7346
    /// @custom:signature   Unresolved_91dd7346(uint256 arg0, uint256 arg1, uint256 arg2) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_91dd7346(uint256 arg0, uint256 arg1, uint256 arg2) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(tstore_f, CustomError_62ac0f37());
        tstore_i = 0;
        require(tstore_i & 0x010000000000000000000000000000000000000000, CustomError_ced0f98c());
        require(msg.sender == address(tstore_j), CustomError_ced0f98c());
        require(0x04 + arg0 + 0x20 + msg.data[0x04 + arg0] - (0x04 + arg0 + 0x20) >= 0x40);
        require(msg.data[0x04 + arg0 + 0x20] <= 0xffffffffffffffff);
        require(0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x1f < 0x04 + arg0 + 0x20 + msg.data[0x04 + arg0]);
        if (msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]] <= 0xffffffffffffffff && !(var_d + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            uint256 var_d = var_d + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            require(0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x20 + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]] <= 0x04 + arg0 + 0x20 + msg.data[0x04 + arg0]);
            uint256 var_e = msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x20:0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20] + 0x20 + msg.data[0x04 + arg0 + 0x20 + msg.data[0x04 + arg0 + 0x20]]];
            if (0 == (var_g == 0xa0)) {
                if (var_g - 0xc0) {
                    require(var_d + var_g - var_d >= 0x20);
                    require(var_e <= 0xffffffffffffffff);
                    require(var_d + var_e + 0x3f < var_d + var_g + 0x20);
                } else {
                    require(var_d + var_g - var_d < 0xc0);
                }
            } else {
                require(var_d + var_g - var_d >= 0xa0);
                require(var_e - address(var_e));
            }
        }
    }
    
    /// @custom:selector    0x952a2970
    /// @custom:signature   Unresolved_952a2970(uint256 arg0, uint16 arg1, uint64 arg2, uint256 arg3) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint16", "bytes2", "int16"]
    /// @param              arg2 ["uint64", "bytes8", "int64"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_952a2970(uint256 arg0, uint16 arg1, uint64 arg2, uint256 arg3) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x80);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(!(arg1 - arg1));
        require(!(arg2 - arg2));
        require(arg3 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg3] <= 0xffffffffffffffff);
        require(block.number <= arg2, CustomError_83f2ba20());
        require(!store_c, CustomError_d93c0665());
        require(!tstore_a, CustomError_3ee5aeb5());
        tstore_a = 0x01;
        if (msg.data[0x04 + arg0] <= 0xffffffffffffffff && !(var_f + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg0]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_f + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg0]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_f)) {
            uint256 var_f = var_f + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + 0x3ee5aeb500000000000000000000000000000000000000000000000000000000) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_a = msg.data[0x04 + arg0];
            require(!(msg.sender - 0xa18fd8b6ff7091b15f9bc1c3876e6529a0f8e7aa), CustomError_27d92fad());
            var_k = keccak256(memory[var_f + 0x20:var_f + 0x20 + var_l]);
            var_h = keccak256(memory[var_f:var_f + 0x3c]);
            uint256 var_i = msg.data[0x04 + arg3 + 0x20 + 0x40];
            address var_d = address(var_d);
            require(storage_map_a[address(var_d)].field_0, CustomError_6acaf8b3());
            if (!(var_f + 0xc0 > 0xffffffffffffffff | var_f + 0xc0 < var_f) && msg.data[0x04 + arg0]) {
                require(msg.data[0x04 + arg0 + 0x20] >> 0xf8 == 0x01, CustomError_7a3dba7d());
                if (0x01 < msg.data[0x04 + arg0]) {
                    require(0x16 <= msg.data[0x04 + arg0]);
                    require(0x26 <= msg.data[0x04 + arg0]);
                    require(0x36 <= msg.data[0x04 + arg0]);
                    require(0x46 <= msg.data[0x04 + arg0]);
                }
            }
        }
    }
    
    /// @custom:selector    0xb8fe8d5f
    /// @custom:signature   Unresolved_b8fe8d5f(address arg0) public view returns (bool)
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    function Unresolved_b8fe8d5f(address arg0) public view returns (bool) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(!(arg0 - arg0));
        var_c = storage_map_i[arg0].field_0;
        return var_c;
    }
    
    /// @custom:selector    0xca1dd22e
    /// @custom:signature   Unresolved_ca1dd22e(address arg0, uint256 arg1) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    function Unresolved_ca1dd22e(address arg0, uint256 arg1) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x40);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg0, CustomError_d92e233d());
        storage_map_i[arg0] = uint8(arg1) | storage_map_i[arg0] & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00;
        emit AllowedTargetUpdated(arg0, arg1);
    }
    
    /// @custom:selector    0xcd601439
    /// @custom:signature   Unresolved_cd601439(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_cd601439(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(storage_map_a[msg.sender].field_0, CustomError_4d739bfe());
        require(!store_c, CustomError_d93c0665());
        require(!tstore_a, CustomError_3ee5aeb5());
        tstore_a = 0x01;
        if (!(var_d + 0xc0 > 0xffffffffffffffff | var_d + 0xc0 < var_d)) {
            uint256 var_d = var_d + 0xc0;
            if (msg.data[0x04 + arg0]) {
                require(msg.data[0x04 + arg0 + 0x20] >> 0xf8 == 0x01, CustomError_7a3dba7d());
                if (0x01 < msg.data[0x04 + arg0]) {
                    require(0x16 <= msg.data[0x04 + arg0]);
                    require(0x26 <= msg.data[0x04 + arg0]);
                    require(0x36 <= msg.data[0x04 + arg0]);
                    require(0x46 <= msg.data[0x04 + arg0]);
                    if (0x46 < msg.data[0x04 + arg0] && (msg.data[0x04 + arg0 + 0x20 + 0x46] >> 0xf8 <= 0xffffffffffffffff && !(var_d + (0x20 + (msg.data[0x04 + arg0 + 0x20 + 0x46] >> 0xf8 << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (0x20 + (msg.data[0x04 + arg0 + 0x20 + 0x46] >> 0xf8 << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d))) {
                        uint256 var_d = var_d + (0x20 + (0x7a3dba7d00000000000000000000000000000000000000000000000000000000 << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                        if (msg.data[0x04 + arg0 + 0x20 + 0x46] >> 0xf8 <= 0xffffffffffffffff && 0 >= 0x20 + (msg.data[0x04 + arg0 + 0x20 + 0x46] >> 0xf8 << 0x05) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) {
                            if (0 >= msg.data[0x04 + arg0 + 0x20 + 0x46] >> 0xf8) {
                                require(!(0x47 - msg.data[0x04 + arg0]), CustomError_7a3dba7d());
                            } else {
                                if (0x47 <= 0x99) {
                                    require(msg.data[0x04 + arg0] >= 0x99, CustomError_7a3dba7d());
                                    if (0 < var_y && 0x47 <= 0x5b) {
                                        require(0x47 <= 0x5b);
                                        require(0x5b <= msg.data[0x04 + arg0]);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xd9caed12
    /// @custom:signature   Unresolved_d9caed12(address arg0, address arg1, uint256 arg2) public payable
    /// @param              arg0 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg1 ["address", "uint160", "bytes20", "int160"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_d9caed12(address arg0, address arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(!(arg0 - arg0));
        require(!(arg1 - arg1));
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        require(arg1, CustomError_d92e233d());
        if (arg0) {
            (bool success, bytes memory ret0) = address(arg0).Unresolved_a9059cbb(arg1); // call
            if (!(success & 0xa9059cbb00000000000000000000000000000000000000000000000000000000 == 0x01)) {
                require(!(!success & 0x01));
                require(!ret0.length & arg0.code.length & success, CustomError_5274afe7());
            } else {
                require(success, CustomError_5274afe7());
            }
            emit Withdraw(arg0, arg1, arg2);
        } else {
            payable(address(arg1)).transfer(arg2);
            if (!ret0.length) {
                require(success, CustomError_e364cfb0());
                emit Withdraw(arg0, arg1, arg2);
            }
        }
    }
    
    /// @custom:selector    0xe30c3978
    /// @custom:signature   Unresolved_e30c3978() public view returns (address)
    function Unresolved_e30c3978() public view returns (address) {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0);
        return store_h;
    }
    
    /// @custom:selector    0xf04f2707
    /// @custom:signature   Unresolved_f04f2707(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    function Unresolved_f04f2707(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x80);
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
        require(tstore_f, CustomError_62ac0f37());
        require(tstore_g, CustomError_a562fe00());
        require(!(msg.sender - 0xba12222222228d8ba445958a75a0704d566bf2c8), CustomError_ced0f98c());
        if (msg.data[0x04 + arg3] <= 0xffffffffffffffff && !(var_d + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg3]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg3]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
            uint256 var_d = var_d + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + 0xced0f98c00000000000000000000000000000000000000000000000000000000) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
            uint256 var_a = msg.data[0x04 + arg3];
            uint256 var_e = msg.data[0x04 + arg3 + 0x20:0x04 + arg3 + 0x20 + var_a];
            require(!(keccak256(memory[var_d + 0x20:var_d + 0x20 + var_g]) - tstore_g), CustomError_21f24259());
            tstore_g = 0;
            require(!(msg.data[0x04 + arg0] - 0x01), CustomError_cf95e0e1());
            require(0x04 + arg3 + 0x20 + msg.data[0x04 + arg3] - (0x04 + arg3 + 0x20) >= 0x20);
            require(msg.data[0x04 + arg3 + 0x20] <= 0xffffffffffffffff);
            require(0x04 + arg3 + 0x20 + msg.data[0x04 + arg3] - (0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20]) >= 0xc0);
            if (!(var_d + 0xc0 > 0xffffffffffffffff | var_d + 0xc0 < var_d)) {
                uint256 var_d = var_d + 0xc0;
                require(!(msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20]] - uint8(msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20]])));
                require(!(msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x20] - address(msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x20])));
                require(msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80] <= 0xffffffffffffffff);
                require(0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80] + 0x1f < 0x04 + arg3 + 0x20 + msg.data[0x04 + arg3]);
                if (msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80]] <= 0xffffffffffffffff && !(var_d + (0x20 + (msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80]] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_d + (0x20 + (msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80]] << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_d)) {
                    uint256 var_d = var_d + (0x20 + (var_k << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                    require(0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80] + (msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80]] << 0x05) + 0x20 <= 0x04 + arg3 + 0x20 + msg.data[0x04 + arg3]);
                    if (0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80] + 0x20 < 0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80] + (msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80]] << 0x05) + 0x20) {
                        require(msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80] + 0x20] <= 0xffffffffffffffff);
                        require(0x04 + arg3 + 0x20 + msg.data[0x04 + arg3] - (0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80] + 0x20]) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 >= 0x0120);
                        if (!(var_d + 0x0120 > 0xffffffffffffffff | var_d + 0x0120 < var_d)) {
                            uint256 var_d = var_d + 0x0120;
                            require(!(msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80] + 0x20] + 0x20] - address(msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80] + 0x20] + 0x20])));
                            require(msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80] + 0x20] + 0x80] - uint16(msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + msg.data[0x04 + arg3 + 0x20 + msg.data[0x04 + arg3 + 0x20] + 0x80] + 0x20] + 0x80]));
                        }
                    } else {
                        if (msg.data[0x04 + arg0]) {
                            require(!(msg.data[0x04 + arg0 + 0x20] - address(msg.data[0x04 + arg0 + 0x20])));
                            require(!(address(var_e) - address(msg.data[0x04 + arg0 + 0x20])), CustomError_5aada19f());
                            if (msg.data[0x04 + arg1]) {
                                require(!(msg.data[0x04 + arg1 + 0x20] - var_q), CustomError_dafc5d75());
                                if (msg.data[0x04 + arg2]) {
                                    require(msg.data[0x04 + arg2 + 0x20] <= var_r, CustomError_3868125d());
                                    if (msg.data[0x04 + arg1 + 0x20] <= msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg2 + 0x20]) {
                                        (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_70a08231(address(this), var_r); // staticcall
                                        require(success);
                                        if (!success) {
                                            require(var_q <= 0, CustomError_bafe1c53());
                                            (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_70a08231(address(this), var_r); // staticcall
                                            require(success);
                                            if (!success) {
                                                if (address(var_e) != 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2) {
                                                    if (var_v + type(uint256).max <= var_v && var_v + type(uint256).max < var_v) {
                                                        (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).Unresolved_70a08231(address(this), var_r); // staticcall
                                                        require(success);
                                                        if (!success) {
                                                            require(!address(0xf70e6dd9b28f55e158f13821f36994b17552d2b9).code.length);
                                                        }
                                                    }
                                                } else {
                                                    if (address(var_e) == 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2) {
                                                        if (address(this) - msg.sender) {
                                                            require(address(0xf70e6dd9b28f55e158f13821f36994b17552d2b9).code.length);
                                                            if (0 >= var_v) {
                                                                (bool success, bytes memory ret0) = address(0xf70e6dd9b28f55e158f13821f36994b17552d2b9).Unresolved_71aa4415(0xa0, address(var_e), var_av); // delegatecall
                                                                require(success);
                                                                address var_t = address(var_e);
                                                                (bool success, bytes memory ret0) = address(0xa8b5a60b91cf4cc3673823939f3579c1a8a3eed6).Unresolved_f704a85e(address(var_e), var_t, 0); // delegatecall
                                                                require(success);
                                                                if (!success) {
                                                                    if (msg.sender == address(this)) {
                                                                        (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_70a08231(address(this), var_t); // staticcall
                                                                        require(success);
                                                                        require(success, CustomError_1a3b8ce6());
                                                                    } else {
                                                                        if (address(var_e) != 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2) {
                                                                            (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).Unresolved_70a08231(address(this), 0); // staticcall
                                                                            require(success);
                                                                        } else {
                                                                            if (tstore_h) {
                                                                                if (0 * tstore_h / 0 == tstore_h | !0) {
                                                                                    require(address(0xa8b5a60b91cf4cc3673823939f3579c1a8a3eed6).code.length);
                                                                                    (bool success, bytes memory ret0) = address(0xa8b5a60b91cf4cc3673823939f3579c1a8a3eed6).Unresolved_dbf4e91f(0 * tstore_h / 0x2710, 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2, 0); // delegatecall
                                                                                    require(success);
                                                                                    if (success) {
                                                                                        require(var_d > 0xffffffffffffffff);
                                                                                    } else {
                                                                                        (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_70a08231(address(this), 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2); // staticcall
                                                                                        require(success);
                                                                                        if (!success) {
                                                                                            require(0 >= msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg2 + 0x20], CustomError_1a3b8ce6());
                                                                                            if (msg.sender) {
                                                                                                uint256 var_av = msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg2 + 0x20];
                                                                                                (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_a9059cbb(msg.sender, var_av); // call
                                                                                                if (!(success & 0xa9059cbb00000000000000000000000000000000000000000000000000000000 == 0x01)) {
                                                                                                    require(!success & 0x01, CustomError_5274afe7());
                                                                                                } else {
                                                                                                    uint256 var_d = var_d;
                                                                                                    require(success, CustomError_5274afe7());
                                                                                                    require(address(0xa8b5a60b91cf4cc3673823939f3579c1a8a3eed6).code.length);
                                                                                                    uint256 var_t = 0 * tstore_h / 0x2710;
                                                                                                    (bool success, bytes memory ret0) = address(0xa8b5a60b91cf4cc3673823939f3579c1a8a3eed6).Unresolved_30ff8fc6(0, var_t, var_aw); // delegatecall
                                                                                                    require(success);
                                                                                                    if (success) {
                                                                                                        require(var_d > 0xffffffffffffffff);
                                                                                                    } else {
                                                                                                        if (0 == (address(var_e) != 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2)) {
                                                                                                            emit Event_9875cb71(tstore_g, address(var_e), 0, var_t);
                                                                                                        } else {
                                                                                                            emit Event_9875cb71(tstore_g, 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2, 0, var_t);
                                                                                                        }
                                                                                                    }
                                                                                                }
                                                                                            } else {
                                                                                                uint256 var_av = msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg2 + 0x20];
                                                                                                (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_095ea7b3(msg.sender, var_av); // call
                                                                                                if (success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01) {
                                                                                                    (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_095ea7b3(msg.sender, 0); // call
                                                                                                    if (success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01) {
                                                                                                        require(success, CustomError_5274afe7());
                                                                                                        uint256 var_av = msg.data[0x04 + arg1 + 0x20] + msg.data[0x04 + arg2 + 0x20];
                                                                                                        (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_095ea7b3(msg.sender, var_av); // call
                                                                                                        require(!(success & 0x095ea7b300000000000000000000000000000000000000000000000000000000 == 0x01), CustomError_5274afe7());
                                                                                                    }
                                                                                                    require(!success & 0x01, CustomError_5274afe7());
                                                                                                }
                                                                                            }
                                                                                        }
                                                                                    }
                                                                                }
                                                                            } else {
                                                                                (bool success, bytes memory ret0) = address(address(var_e)).Unresolved_70a08231(address(this), var_t); // staticcall
                                                                                require(success);
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        } else {
                                                            require(!address(0xf70e6dd9b28f55e158f13821f36994b17552d2b9).code.length);
                                                        }
                                                    } else {
                                                        (bool success, bytes memory ret0) = address(0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2).Unresolved_70a08231(address(this), var_t); // staticcall
                                                        require(success);
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
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
        require(!(msg.sender - unresolved_8da5cb5b), CustomError_118cdaa7());
        store_d = store_d & 0xffffffffffffffffffffffff0000000000000000000000000000000000000000 | arg0;
        emit OwnershipTransferStarted(unresolved_8da5cb5b, arg0);
    }
    
    /// @custom:selector    0xf7ec7c28
    /// @custom:signature   Unresolved_f7ec7c28(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    function Unresolved_f7ec7c28(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3) public view {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x20);
        require(arg0 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg0] <= 0xffffffffffffffff);
        require(!(msg.sender - address(this)), CustomError_14d4a4e8());
        if (!(var_b + 0xc0 > 0xffffffffffffffff | var_b + 0xc0 < var_b)) {
            uint256 var_b = var_b + 0xc0;
            if (msg.data[0x04 + arg0]) {
                require(msg.data[0x04 + arg0 + 0x20] >> 0xf8 == 0x01, CustomError_7a3dba7d());
                if (0x01 < msg.data[0x04 + arg0]) {
                    require(0x16 <= msg.data[0x04 + arg0]);
                    require(0x26 <= msg.data[0x04 + arg0]);
                    require(0x36 <= msg.data[0x04 + arg0]);
                    require(0x46 <= msg.data[0x04 + arg0]);
                    if (0x46 < msg.data[0x04 + arg0] && (msg.data[0x04 + arg0 + 0x20 + 0x46] >> 0xf8 <= 0xffffffffffffffff && !(var_b + (0x20 + (msg.data[0x04 + arg0 + 0x20 + 0x46] >> 0xf8 << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_b + (0x20 + (msg.data[0x04 + arg0 + 0x20 + 0x46] >> 0xf8 << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_b))) {
                        uint256 var_b = var_b + (0x20 + (0x7a3dba7d00000000000000000000000000000000000000000000000000000000 << 0x05) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                        if (msg.data[0x04 + arg0 + 0x20 + 0x46] >> 0xf8 <= 0xffffffffffffffff && 0 >= 0x20 + (msg.data[0x04 + arg0 + 0x20 + 0x46] >> 0xf8 << 0x05) + 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) {
                            if (0 >= msg.data[0x04 + arg0 + 0x20 + 0x46] >> 0xf8) {
                                require(!(0x47 - msg.data[0x04 + arg0]), CustomError_7a3dba7d());
                            } else {
                                if (0x47 <= 0x99) {
                                    require(msg.data[0x04 + arg0] >= 0x99, CustomError_7a3dba7d());
                                    if (0 < var_x && 0x47 <= 0x5b) {
                                        require(0x47 <= 0x5b);
                                        require(0x5b <= msg.data[0x04 + arg0]);
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    /// @custom:selector    0xfa461e33
    /// @custom:signature   Unresolved_fa461e33(uint256 arg0, uint256 arg1, uint256 arg2) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    function Unresolved_fa461e33(uint256 arg0, uint256 arg1, uint256 arg2) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x60);
        require(arg2 <= 0xffffffffffffffff);
        require(msg.data[0x04 + arg2] <= 0xffffffffffffffff);
        if (!msg.data[0x04 + arg2]) {
            tunresolved_8da5cb5b = 0;
            require(address(tunresolved_8da5cb5b), CustomError_c0d73a51());
            require(msg.sender == address(tunresolved_8da5cb5b), CustomError_c0d73a51());
            if (arg0 > 0) {
                require(arg1 <= 0, CustomError_71fec290());
                require(arg0, CustomError_71fec290());
                require(arg0 <= tstore_d, CustomError_0d86d6e1());
                (bool success, bytes memory ret0) = address(address(tstore_e)).Unresolved_a9059cbb(address(tunresolved_8da5cb5b)); // call
                if (!(success & 0xa9059cbb00000000000000000000000000000000000000000000000000000000 == 0x01)) {
                    require(!(!success & 0x01));
                    require(!ret0.length & address(tstore_e).code.length & success, CustomError_5274afe7());
                } else {
                    var_g = var_g;
                    require(success, CustomError_5274afe7());
                }
            }
        } else {
            tunresolved_8da5cb5b = 0;
            tstore_c = 0;
            require(address(tunresolved_8da5cb5b), CustomError_c0d73a51());
            require(msg.sender == address(tunresolved_8da5cb5b), CustomError_c0d73a51());
            if (msg.data[0x04 + arg2] <= 0xffffffffffffffff && !(var_g + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg2]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) > 0xffffffffffffffff | var_g + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg2]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0) < var_g)) {
                uint256 var_g = var_g + (0x20 + (0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0 & 0x1f + msg.data[0x04 + arg2]) + 0x1f & 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe0);
                require(!(keccak256(memory[var_g + 0x20:var_g + 0x20 + var_j]) - tstore_c), CustomError_a717ed2a());
                require(0x04 + arg2 + 0x20 + msg.data[0x04 + arg2] - (0x04 + arg2 + 0x20) >= 0xc0);
                require(msg.data[0x04 + arg2 + 0x20] <= 0xffffffffffffffff);
                require(0x04 + arg2 + 0x20 + msg.data[0x04 + arg2 + 0x20] + 0x1f < 0x04 + arg2 + 0x20 + msg.data[0x04 + arg2]);
            }
        }
    }
}