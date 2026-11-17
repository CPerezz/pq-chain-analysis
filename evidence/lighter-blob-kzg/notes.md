# Review notes: lighter-blob-kzg (2026-11-17)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,454 unless stated.

## ZkLighter implementation bytecode (unverified)

- Proxy `0x3b4d794a66304f130a4db8f2551b0070dfcf5ca7`: `getTarget()` = `0x9b4a5f3cf3bc80494fb02dd2eb5f20f86b27ec4f`,
  `getMaster()` = UpgradeGatekeeper `0x94da8a995d0d82ef0fe7e509c6d76c22603b6f67`. `desertMode()` = false.
- Implementation not verified on Sourcify or Blockscout. `cast disassemble` of its runtime code (22,249 bytes):
  - two `BLOBHASH` opcodes (offsets 0x52ab, 0x5311);
  - `PUSH1 0x0a; GAS; STATICCALL` at offset 0x5542 (call to the point-evaluation precompile), result checked with
    `ISZERO`/`JUMPI` right after.
- `cast selectors --resolve` on the implementation: `commitBatch((uint64,uint32,uint64,uint64,uint32,bytes32,bytes32,bytes32,bytes32,bytes),(…))`,
  `verifyBatch(…,bytes)`, `executeBatches`, `revertBatches`, `activateDesertMode()`, `performDesert(uint48,address,uint16,uint128,bytes)`,
  `updateStateRoot`, `validiumRoot()`, `deposit`, `withdrawPendingBalance`. The selector of Governance
  `isActiveValidator(address)` (`0x40550a1c`) occurs once in the bytecode.
- Storage of the proxy: slot 4 = verifier proxy `0xac3ce44b6ff4e402858c99d5699ff63131572baa`, slot 5 = DesertVerifier
  `0x975210588389526a3a1def1628e7a4d7abdfd121`, slot 6 = Governance proxy `0xa464da0b43f80ee3ffc4795cbbfc78472b5c81a1`.

## Who can change it

- UpgradeGatekeeper `0x94da8a99…` (verified, Matter Labs zkSync gatekeeper adapted by Lighter):
  `getMaster()` = Safe `0x97a90ec950b6bcd9b190b566525b2bb92a2c03a2` (Safe 1.4.1, threshold 3 of 5 owners:
  `0x2994d343b6b17ec23e9e4a08082184fd43f763a3`, `0x67d6c2569ab98a1f535e36b3bab1fbd825fa536e`,
  `0xa0b3781b830df57b1f018c434c58551c2fc6b3af`, `0x6fee6cdd595d12ec6cd1803474b3615f1d2fb9ed`,
  `0xf65f409d8f3fa3635287783256394d7eb7ad7835`).
- `securityCouncilAddress()` = Safe `0x92b12c9d85bf7bd2ef5d2f53f4cd4ce0be432045` (Safe 1.4.1, 4 of 7); it can cut the
  notice period to zero (`cutUpgradeNoticePeriod`).
- `approvedUpgradeNoticePeriod()` = 1,814,400 s (3 weeks); `upgradeStatus()` = 0 (Idle); `versionId()` = 81.
- `managedContracts(0..2)` = Governance `0xa464da0b…`, verifier `0xac3ce44b…`, ZkLighter `0x3b4d794a…`.
- Governance `networkGovernor()` = the same 3-of-5 Safe `0x97a90ec9…`.
- Upgrades are refused while `desertMode()` is true (`isReadyForUpgrade`).

## Holdings

From `onchain.json` (block 26,431,214): 11,171.69 ETH and $887.5M in tokens (USDC $471.2M, LIT $411.4M, XAUT $4.1M,
…), $907.8M total at ETH = $1,811.62.
