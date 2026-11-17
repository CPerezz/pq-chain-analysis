# LineaRollup verifier history

`VerifierAddressChanged(address verifierAddress, uint256 proofType, address verifierSetBy, address oldVerifierAddress)`
logs of LineaRollup `0xd19d4b5d358258f05d7b411e21a1460d11b0876f`, read 2026-11-17 from the Blockscout logs API
(`module=logs&action=getLogs&topic0=0x4a29db3f…`). Then `verifiers(i)` read with `cast` at block 26,431,459.

| Block | proofType | New verifier | Old verifier | Set by |
|---|---|---|---|---|
| 20,332,062 | 3 | 0xbff4a03a355eef7da720bbc7878f9bdbbe81fe6f | 0x1111…1111 | TimeLock 0xd6b95c96 |
| 22,367,530 | 4 | 0x41a4d93d09f4718fe899d12a4ad2c8a09104bdc7 | 0x1111…1111 | TimeLock |
| 22,623,238 | 3 | 0x0 | 0xbff4a03a… | Safe 0x892bb7ee (unset) |
| 22,666,060 | 0 | 0xed39c0c41a7651006953ab58ecb3039363620995 | 0x1111…1111 | TimeLock |
| 23,214,311 | 1 | 0x9473c37a9fe76fbbc3fd7d3b59e1b550415bd873 | 0x0 | TimeLock |
| 23,214,311 | 4 | 0x0 | 0x41a4d93d… | Safe (unset) |
| 23,669,642 | 1 | 0x8421d1e3… | 0x9473c37a… | TimeLock |
| 23,669,642 | 0 | 0xa12e79c375fb0aaddfda597bbe7b4e9a92e9b3de | 0xed39c0c4… | TimeLock |
| 23,818,015 | 3 | 0x814d80782aa8c508ababe9c6956d8f1f90e5177a | 0x0 | TimeLock |
| 23,935,989 | 4 | 0x8f8ec9608223c0b8d13238950c03f5d42ceebb9b | 0x0 | TimeLock |
| 23,935,989 | 0 | 0x0 | 0xa12e79c3… | Safe (unset) |
| 24,715,470 | 3 | 0x0 | 0x814d8078… | Safe (unset) |
| 24,730,601 | 4 | 0x0 | 0x8f8ec960… | Safe (unset) |
| 26,146,672 | 1 | 0x1d930e3fac9fbc7026ec17962d2f57d558d37532 | 0x09ac9f7e… | TimeLock |
| 26,408,786 | 0 | 0x0b3943f4b1397c7a9f268d8b84f127a78c66414c | 0xaff26999… | TimeLock |

Intermediate verifiers not in this finding (0x8421d1e3, 0x8cae7ff1, 0xa3437f9c, 0xc83ed08e, 0x66355689, 0x14428331,
0x0d0f0703, 0x218c3339, 0x09ac9f7e, 0xaff26999, 0x8ab45503, 0xfb0c26a8) were also set and later replaced; none is set now.

State at block 26,431,459: `verifiers(0)` = 0x0b3943f4…, `verifiers(1)` = 0x1d930e3f…, `verifiers(2..10)` = 0x0.
None of the seven verifiers originally listed in this finding is set. Sample `finalizeBlocks` transaction
0x9b63dd06…6ca6 (block 26,430,204) uses proofType 0.

Both current verifiers are `PlonkVerifierFull` (`src/verifiers/PlonkVerifierFull.sol`, solc 0.8.33, Blockscout-verified,
deployer 0x89f1668d215bb5839a0a7a1a4619b1541258388c): `Verify(bytes proof, uint256[] public_inputs)` (line 194),
`R_MOD` = BN254 scalar field (line 25), KZG batch-opening pairing `staticcall(gas(), 8, …)` (line 914), G2 SRS point
"canonical G2 point on BN254" (line 894).
