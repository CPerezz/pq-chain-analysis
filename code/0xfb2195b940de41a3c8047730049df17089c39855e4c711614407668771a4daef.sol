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
    
    /// @custom:selector    0x8dce00a8
    /// @custom:signature   Unresolved_8dce00a8(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11, uint256 arg12, uint256 arg13) public payable
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
    function Unresolved_8dce00a8(uint256 arg0, uint256 arg1, uint256 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11, uint256 arg12, uint256 arg13) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x02c0);
        require(0x0104 <= msg.data.length);
        require(0x02c4 <= msg.data.length);
        (bool success, bytes memory ret0) = address(0x07).Unresolved_13fb0ce2(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_13148c9a(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_288d22d4(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_1f70bb56(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_2d65be49(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_01d36233(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_2e6a9369(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_0a57cdd1(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_1d74ba7f(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_0e60cd94(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_29259c54(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_2fc0704f(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_2735b42d(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_i, var_j, var_f, var_g); // staticcall
        (bool success, bytes memory ret0) = address(0x07).Unresolved_1d9e0604(var_f, var_g, var_h); // staticcall
        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_i, var_j, var_f, var_g); // staticcall
        require(success & (arg21 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg20 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg19 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg18 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg17 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg16 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg15 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg14 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg13 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg12 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg11 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg10 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg9 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg8 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & success)) & 0x01 & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success), CustomError_a54f8e27());
        uint256 var_m = msg.data[0x04:0x04 + 0x0100];
        (bool success, bytes memory ret0) = address(0x08).Unresolved_28e00982(var_i, var_j, var_f, var_g, var_h, var_ae, var_af, var_ag, var_ah, var_ai, var_aj, var_ak, var_al, var_am, var_an, var_ao, var_ap, var_aq, var_ar, var_as, var_at); // staticcall
        require(var_m & success, CustomError_7fcdd1f4());
    }
    
    /// @custom:selector    0xf9edd048
    /// @custom:signature   Unresolved_f9edd048(uint0 arg0, uint256 arg1, uint0 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11, uint256 arg12, uint256 arg13, uint256 arg14, uint256 arg15, uint256 arg16, uint256 arg17) public payable
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
    function Unresolved_f9edd048(uint0 arg0, uint256 arg1, uint0 arg2, uint256 arg3, uint256 arg4, uint256 arg5, uint256 arg6, uint256 arg7, uint256 arg8, uint256 arg9, uint256 arg10, uint256 arg11, uint256 arg12, uint256 arg13, uint256 arg14, uint256 arg15, uint256 arg16, uint256 arg17) public payable {
        require(msg.data.length + 0xfffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffc >= 0x0240);
        require(0x84 <= msg.data.length);
        require(0x0244 <= msg.data.length);
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
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_13fb0ce2(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_13148c9a(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_288d22d4(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1f70bb56(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2d65be49(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_01d36233(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2e6a9369(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_0a57cdd1(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1d74ba7f(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_0e60cd94(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_29259c54(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2fc0704f(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2735b42d(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1d9e0604(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        require(success & (arg17 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg16 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg15 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg14 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg13 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg12 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg11 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg10 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg9 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg8 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg7 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg6 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg5 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & (success & (arg4 < 0x30644e72e131a029b85045b68181585d2833e84879b9709143e1f593f0000001 & success)) & 0x01 & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success)) & success), CustomError_a54f8e27());
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
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_13fb0ce2(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_13148c9a(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_288d22d4(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1f70bb56(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2d65be49(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_01d36233(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2e6a9369(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_0a57cdd1(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1d74ba7f(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_0e60cd94(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_29259c54(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2fc0704f(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_2735b42d(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
                        (bool success, bytes memory ret0) = address(0x07).Unresolved_1d9e0604(var_m, var_n, var_o); // staticcall
                        (bool success, bytes memory ret0) = address(0x06).Unresolved_28e00982(var_k, var_l, var_m, var_n); // staticcall
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