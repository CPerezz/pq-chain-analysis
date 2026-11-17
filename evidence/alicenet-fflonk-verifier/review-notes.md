# Review reads: alicenet-fflonk-verifier (2026-11-17, Review17)

Verifier `0x0c1668452b5e83863f7f0727b65b72cbf0bd8d26`: Sourcify-verified `contracts/verifiers/FflonkVerifier.sol`
(snarkJS fflonk on BN254; `verifyProof(bytes32[24], uint256[1])` ends in `checkPairing`). Blockscout: created
2024-08-02 by EOA `0x3dfb4aea2f723a5ee8d8c2a74ff38d8813063f3c`; no other direct transactions.

Consumer, read at latest blocks 26,431,551-26,431,725 (2026-11-17):

- Rollup manager `0x8da537b4806962951de147880f15d87e9a761a7d`: EIP-1967 proxy, implementation `0xe47c3eff…`
  (Sourcify name `PolygonRollupManagerNotUpgraded`), EIP-1967 admin = ProxyAdmin `0xa5050ef49e8a3d6adb0bd55c37b8efb05ff619a9`.
  `rollupTypeCount()` = 2, `rollupCount()` = 1.
  - `rollupTypeMap(1)` = consensus `0x5f360ad3…`, verifier `0x0c166845…` (this finding), forkID 9.
  - `rollupTypeMap(2)` = consensus `0x524cf915…` (PolygonValidiumEtrog), verifier `0xf2f73b87e97730dca6558dd71c0b1c945ca38096`
    (Blockscout name `FflonkVerifier_12`, same deployer), forkID 12.
  - `rollupIDToRollupData(1)`: rollup contract `0x3072b4227656d5e9770d35713d10549d202b9749`, chain id 1042, verifier
    `0xf2f73b87…`, forkID 12. No rollup uses `0x0c166845…` any more.
  - The timelock (below) holds DEFAULT_ADMIN_ROLE, ADD_ROLLUP_TYPE_ROLE and UPDATE_ROLLUP_ROLE.
    TRUSTED_AGGREGATOR_ROLE is held by `0x13b3eb34ff65e7f612e195023c8f68dfee610c57`, which calls
    `verifyBatchesTrustedAggregator` (latest 2026-11-16, Blockscout).
- ProxyAdmin `0xa5050ef4…` `owner()` = `0xec607225abc934ba2c1f887ae6b5805003a207df` (Sourcify:
  `PolygonZkEVMTimelock`, `getMinDelay()` = 3600 s). The deployer EOA is not a proposer or executor; proposers were
  not enumerated.
- Rollup `0x3072b422…`: `networkName()` = "Alicenet", `admin()` = `0x3dfb4aea…`, `trustedSequencer()` =
  `0x48d51a36…`, `dataAvailabilityProtocol()` = `0xbbef2b8f…`, `gasTokenAddress()` = `0xf6299720f0482c8ff96968a667035a5dbfd571cb` (ALCB).
- Bridge `0xf2ac62e8ec641c327eabf02a2bbc5bd820c18bd4` (EIP-1967 proxy, admin = same ProxyAdmin): ETH balance 0;
  Blockscout ERC-20 list empty (remote box, 2026-11-17); ALCB `balanceOf(bridge)` = 0.

## Follow-up: live verifier `0xf2f73b87e97730dca6558dd71c0b1c945ca38096` (2026-11-17)

- Sourcify exact match `contracts/verifiers/FflonkVerifier_12.sol:FflonkVerifier_12`: `verifyProof(bytes32[24],
  uint256[1])` at line 186, `checkPairing` at 2065, `isValid := checkPairing(pMem)` at 2152. Runtime code differs from
  `0x0c166845…` (22,983 vs 13,967 bytes); no constructor admin or setter.
- Blockscout `/addresses/0x8da537b4…/transactions` (remote box): 23 transactions 2026-10-16 to 2026-11-16, last
  `verifyBatchesTrustedAggregator` at block 26,427,564 (2026-11-16) from `0x13b3eb34…` (holds TRUSTED_AGGREGATOR_ROLE).
