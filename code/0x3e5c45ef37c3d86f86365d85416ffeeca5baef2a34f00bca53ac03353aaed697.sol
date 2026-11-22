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
    error PublicInputNotInField();
    
    /// @custom:selector    0x44f63692
    /// @custom:signature   Unresolved_44f63692(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5) public payable
    /// @param              arg0 ["uint256", "bytes32", "int256"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint256", "bytes32", "int256"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    function Unresolved_44f63692(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0100);
        require(0x0104 <= msg.data.length);
        if (!(var_a + 0x80 > 0xffffffffffffffff | var_a + 0x80 < var_a)) {
            uint256 var_d = msg.data[msg.data.length:msg.data.length + 0x80];
            if (arg0 < 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47) {
                (bool success, bytes memory ret0) = address(0x05).Unresolved_00000000(var_k, var_l, var_m, var_n, var_o, var_p); // staticcall
                if (success && (!(var_d * var_d % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 - (arg0 * arg0 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 * arg0 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 + 0x03) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47) && (!(var_d - arg1) && arg3 < 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47))) {
                    (bool success, bytes memory ret0) = address(0x05).Unresolved_00000000(var_k, var_l, var_m, var_n, var_o, var_p); // staticcall
                }
            }
            revert CustomError_7fcdd1f4();
        }
    }
    
    /// @custom:selector    0x47e5cd34
    /// @custom:signature   Unresolved_47e5cd34(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11, uint256 arg12, uint256 arg13, uint256 arg14, uint256 arg15, uint256 arg16, uint256 arg17, uint256 arg18, uint256 arg19, uint256 arg20, uint256 arg21, uint256 arg22, uint256 arg23, uint256 arg24, uint256 arg25, uint256 arg26, uint256 arg27, uint256 arg28) public payable
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    /// @param              arg13 ["uint256", "bytes32", "int256"]
    /// @param              arg14 ["uint256", "bytes32", "int256"]
    /// @param              arg15 ["uint256", "bytes32", "int256"]
    /// @param              arg16 ["uint256", "bytes32", "int256"]
    /// @param              arg17 ["uint256", "bytes32", "int256"]
    /// @param              arg18 ["uint256", "bytes32", "int256"]
    /// @param              arg19 ["uint256", "bytes32", "int256"]
    /// @param              arg20 ["uint256", "bytes32", "int256"]
    /// @param              arg21 ["uint256", "bytes32", "int256"]
    /// @param              arg22 ["uint256", "bytes32", "int256"]
    /// @param              arg23 ["uint256", "bytes32", "int256"]
    /// @param              arg24 ["uint256", "bytes32", "int256"]
    /// @param              arg25 ["uint256", "bytes32", "int256"]
    /// @param              arg26 ["uint256", "bytes32", "int256"]
    /// @param              arg27 ["uint256", "bytes32", "int256"]
    /// @param              arg28 ["uint256", "bytes32", "int256"]
    /// @param              arg29 ["uint256", "bytes32", "int256"]
    /// @param              arg30 ["uint256", "bytes32", "int256"]
    /// @param              arg31 ["uint256", "bytes32", "int256"]
    /// @param              arg32 ["uint256", "bytes32", "int256"]
    /// @param              arg33 ["uint256", "bytes32", "int256"]
    /// @param              arg34 ["uint256", "bytes32", "int256"]
    /// @param              arg35 ["uint256", "bytes32", "int256"]
    /// @param              arg36 ["uint256", "bytes32", "int256"]
    function Unresolved_47e5cd34(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11, uint256 arg12, uint256 arg13, uint256 arg14, uint256 arg15, uint256 arg16, uint256 arg17, uint256 arg18, uint256 arg19, uint256 arg20, uint256 arg21, uint256 arg22, uint256 arg23, uint256 arg24, uint256 arg25, uint256 arg26, uint256 arg27, uint256 arg28) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x04a0);
        require(0x0104 <= msg.data.length);
        require(0x04a4 <= msg.data.length);
        (bool success, bytes memory ret0) = address(0x07).Unresolved_1b5c5775(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_069af6d4(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_07e9b909(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_2557b33d(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_04f4a815(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_0e2a7413(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_100c4832(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_0e440e96(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_2c8c085e(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_0940c2fb(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_1dd001ee(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_1cc749ac(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_28279754(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_2b72b3e2(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_236e0f2e(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_11c8d0c9(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_0b4db2e1(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_2def4e19(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_199dd134(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_0661531f(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_1c9c1067(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_1625da0d(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_089fe0eb(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_2f0f26be(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_0b627cc9(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_21864efb(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_1017eccc(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_055a6d3d(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_2867f537(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_i, var_j, var_f, var_g); // staticcall
        require(success & (arg36 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg35 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg34 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg33 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg32 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg31 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg30 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg29 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg28 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg27 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg26 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg25 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg24 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg23 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg22 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg21 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg20 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg19 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg18 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg17 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg16 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg15 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg14 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg13 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg12 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg11 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg10 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg9 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg8 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & success)) & 0x01 & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success), CustomError_a54f8e27());
        uint256 var_m = msg.data[0x04:0x04 + 0x0100];
        (bool success, bytes memory ret0) = address(0x08).Unresolved_2a140415(var_i, var_j, var_f, var_g, var_h, var_ae, var_af, var_ag, var_ah, var_ai, var_aj, var_ak, var_al, var_am, var_an, var_ao, var_ap, var_aq, var_ar, var_as, var_at); // staticcall
        require(var_m & success, CustomError_7fcdd1f4());
    }
    
    /// @custom:selector    0x7615a1f5
    /// @custom:signature   Unresolved_7615a1f5(uint0 arg0, uint256 arg1, uint0 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11, uint256 arg12, uint256 arg13, uint256 arg14, uint256 arg15, uint256 arg16, uint256 arg17, uint256 arg18, uint256 arg19, uint256 arg20, uint256 arg21, uint256 arg22, uint256 arg23, uint256 arg24, uint256 arg25, uint256 arg26, uint256 arg27, uint256 arg28, uint256 arg29, uint256 arg30, uint256 arg31, uint256 arg32) public payable
    /// @param              arg0 ["uint0", "bytes0", "int0"]
    /// @param              arg1 ["uint256", "bytes32", "int256"]
    /// @param              arg2 ["uint0", "bytes0", "int0"]
    /// @param              arg3 ["uint256", "bytes32", "int256"]
    /// @param              arg4 ["uint256", "bytes32", "int256"]
    /// @param              arg5 ["uint256", "bytes32", "int256"]
    /// @param              arg6 ["uint256", "bytes32", "int256"]
    /// @param              arg7 ["uint256", "bytes32", "int256"]
    /// @param              arg8 ["uint256", "bytes32", "int256"]
    /// @param              arg9 ["uint256", "bytes32", "int256"]
    /// @param              arg10 ["uint256", "bytes32", "int256"]
    /// @param              arg11 ["uint256", "bytes32", "int256"]
    /// @param              arg12 ["uint256", "bytes32", "int256"]
    /// @param              arg13 ["uint256", "bytes32", "int256"]
    /// @param              arg14 ["uint256", "bytes32", "int256"]
    /// @param              arg15 ["uint256", "bytes32", "int256"]
    /// @param              arg16 ["uint256", "bytes32", "int256"]
    /// @param              arg17 ["uint256", "bytes32", "int256"]
    /// @param              arg18 ["uint256", "bytes32", "int256"]
    /// @param              arg19 ["uint256", "bytes32", "int256"]
    /// @param              arg20 ["uint256", "bytes32", "int256"]
    /// @param              arg21 ["uint256", "bytes32", "int256"]
    /// @param              arg22 ["uint256", "bytes32", "int256"]
    /// @param              arg23 ["uint256", "bytes32", "int256"]
    /// @param              arg24 ["uint256", "bytes32", "int256"]
    /// @param              arg25 ["uint256", "bytes32", "int256"]
    /// @param              arg26 ["uint256", "bytes32", "int256"]
    /// @param              arg27 ["uint256", "bytes32", "int256"]
    /// @param              arg28 ["uint256", "bytes32", "int256"]
    /// @param              arg29 ["uint256", "bytes32", "int256"]
    /// @param              arg30 ["uint256", "bytes32", "int256"]
    /// @param              arg31 ["uint256", "bytes32", "int256"]
    /// @param              arg32 ["uint256", "bytes32", "int256"]
    function Unresolved_7615a1f5(uint0 arg0, uint256 arg1, uint0 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11, uint256 arg12, uint256 arg13, uint256 arg14, uint256 arg15, uint256 arg16, uint256 arg17, uint256 arg18, uint256 arg19, uint256 arg20, uint256 arg21, uint256 arg22, uint256 arg23, uint256 arg24, uint256 arg25, uint256 arg26, uint256 arg27, uint256 arg28, uint256 arg29, uint256 arg30, uint256 arg31, uint256 arg32) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0420);
        require(0x84 <= msg.data.length);
        require(0x0424 <= msg.data.length);
        if (!(var_a + 0x0300 > 0xffffffffffffffff | var_a + 0x0300 < var_a)) {
            uint256 var_a = var_a + 0x0300;
            uint256 var_d = msg.data[msg.data.length:msg.data.length + 0x0300];
            if (arg0) {
                require(arg0 >> 0x01 < 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47, CustomError_7fcdd1f4());
                (bool success, bytes memory ret0) = address(0x05).Unresolved_00000000(var_k, var_l, var_m, var_n, var_o, var_p); // staticcall
                require(success, CustomError_7fcdd1f4());
                require(!(var_d * var_d % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 - ((arg0 >> 0x01) * (arg0 >> 0x01) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 * (arg0 >> 0x01) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 + 0x03) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47), CustomError_7fcdd1f4());
                if ((arg0 & 0x01) == 0x01) {
                    if (!arg2) {
                        require(!arg3, CustomError_7fcdd1f4());
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1b5c5775(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_069af6d4(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_07e9b909(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2557b33d(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_04f4a815(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_0e2a7413(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_100c4832(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_0e440e96(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2c8c085e(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_0940c2fb(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1dd001ee(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1cc749ac(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_28279754(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2b72b3e2(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_236e0f2e(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_11c8d0c9(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_0b4db2e1(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2def4e19(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_199dd134(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_0661531f(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1c9c1067(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1625da0d(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_089fe0eb(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2f0f26be(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_0b627cc9(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_21864efb(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1017eccc(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_055a6d3d(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2867f537(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        require(success & (arg32 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg31 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg30 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg29 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg28 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg27 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg26 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg25 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg24 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg23 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg22 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg21 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg20 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg19 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg18 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg17 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg16 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg15 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg14 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg13 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg12 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg11 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg10 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg9 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg8 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg7 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg6 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg5 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg4 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & success)) & 0x01 & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success), CustomError_a54f8e27());
                        if (!(var_a + 0x20 > 0xffffffffffffffff | var_a + 0x20 < var_a)) {
                            uint256 var_d = msg.data[msg.data.length:msg.data.length + 0x20];
                            (bool success, bytes memory ret0) = address(0x08).Unresolved_00000000(var_ap, var_aq, var_ar, var_as, var_at, var_au, var_av, var_aw, var_ax, var_ay, var_az, var_ba, var_bb, var_bc, var_bd, var_be, var_bf, var_bg, var_bh, var_bi, var_bj, var_bk, var_bl, var_bm); // staticcall
                            if (success) {
                                require(var_d == 0x01, CustomError_7fcdd1f4());
                            } else {
                                require(success, CustomError_7fcdd1f4());
                            }
                        }
                    } else {
                        require(arg2 >> 0x02 < 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47, CustomError_7fcdd1f4());
                        (bool success, bytes memory ret0) = address(0x05).Unresolved_00000000(var_k, var_l, var_m, var_n, var_o, var_p); // staticcall
                        require(success, CustomError_7fcdd1f4());
                        require(!(var_d * var_d % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 - ((0x2b149d40ceb8aaae81be18991be06ac3b5b4c5e559dbefa33267e6dc24a138e5 + ((arg2 >> 0x02) * (arg2 >> 0x02) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 * (arg2 >> 0x02) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 + (arg2 >> 0x02) * arg1 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 * 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd44 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 * arg1 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 * ((0x2b149d40ceb8aaae81be18991be06ac3b5b4c5e559dbefa33267e6dc24a138e5 + ((arg2 >> 0x02) * (arg2 >> 0x02) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 * (arg2 >> 0x02) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 + (arg2 >> 0x02) * arg1 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 * 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd44 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 * arg1 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 + (0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 - (0x2fcd3ac2a640a154eb23960892a85a68f031ca0c8344b23a577dcf1052b9e775 + (arg1 * arg1 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 * arg1 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 + (arg2 >> 0x02) * arg1 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 * 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd44 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 * (arg2 >> 0x02) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 * ((0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 - (0x2fcd3ac2a640a154eb23960892a85a68f031ca0c8344b23a577dcf1052b9e775 + (arg1 * arg1 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 * arg1 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 + (arg2 >> 0x02) * arg1 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 * 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd44 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 * (arg2 >> 0x02) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47 % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47) % 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47), CustomError_7fcdd1f4());
                    }
                } else {
                    if (!arg2) {
                        require(!arg3, CustomError_7fcdd1f4());
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1b5c5775(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_069af6d4(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_07e9b909(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2557b33d(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_04f4a815(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_0e2a7413(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_100c4832(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_0e440e96(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2c8c085e(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_0940c2fb(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1dd001ee(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1cc749ac(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_28279754(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2b72b3e2(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_236e0f2e(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_11c8d0c9(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_0b4db2e1(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2def4e19(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_199dd134(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_0661531f(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1c9c1067(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1625da0d(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_089fe0eb(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2f0f26be(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_0b627cc9(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_21864efb(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1017eccc(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_055a6d3d(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2867f537(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_2a140415(var_k, var_l, var_m, var_n); // staticcall
                        revert CustomError_a54f8e27();
                    } else {
                        if (arg2 >> 0x02 < 0x30644e72e131a029b85045b68181585d97816a916871ca8d3c208c16d87cfd47) {
                            (bool success, bytes memory ret0) = address(0x05).Unresolved_00000000(var_k, var_l, var_m, var_n, var_o, var_p); // staticcall
                        }
                        revert CustomError_7fcdd1f4();
                    }
                }
            }
        }
    }
}