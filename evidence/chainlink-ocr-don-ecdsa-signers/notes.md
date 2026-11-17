# Review notes: chainlink-ocr-don-ecdsa-signers (2026-11-17)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,454; source from Sourcify.

## Owners

| Contract | `typeAndVersion()` | `owner()` | Owner type |
|---|---|---|---|
| `0x26d3681d…` OffRamp | OffRamp 1.6.0 | `0x44835bbba9d40deda9b64858095ecfb2693c9449` | RBACTimelock (verified), `getMinDelay()` = 10,800 s |
| `0xe4167750…` CommitStore | CommitStore 1.5.0 | `0x44835bbba9d40deda9b64858095ecfb2693c9449` | same RBACTimelock |
| `0x6593c7de…` KeeperRegistry2_1 | KeeperRegistry 2.1.0 | `0xcc4b5b07316be81ed6edb44ca61e4cab28a1950d` | Safe 1.3.0, 4 of 12 |
| `0x0b93082d…` KeystoneForwarder | KeystoneForwarder 1.0.0 | `0x4044a864754760c37200e3a76d1953512ee18da8` | RBACTimelock (verified), `getMinDelay()` = 3,600 s |
| `0xa68a99c6…` KeystoneForwarder | KeystoneForwarder 1.0.0 | `0xf99aa0a78d1eeb619f0e548465f6d67debcecc98` | EOA (no code) |

None is a proxy.

## CCIP OffRamp 1.6.0 `0x26d3681d…`

- `getStaticConfig()`: chain selector 5009297550715157269 (Ethereum), RMNRemote `0x411de17f12d1a34ecc7f45f49844626267c75e81`,
  TokenAdminRegistry `0xb22764f98dd05c789929716d677382df22c05cb6`, NonceManager `0x1f128f883bb9f8facfeee04674a35fa96fa3af52`.
- `getAllSourceChainConfigs()`: 37 source chains, all `isEnabled = true` and all `isRMNVerificationDisabled = true`
  (36 with router `0x80226fc0ee2b096224eeac085bb9a8cba1146f7d`, 1 with router `0x3237c0d7b58bec8dc17f00103b784bd6678f789e`).
  With RMN disabled, `commit` accepts the roots on the OCR signatures alone (OffRamp.sol line 818 calls
  `RMNRemote.verify` only for `blessedMerkleRoots`).
- `latestConfigDetails(0)` (commit plugin): F = 5, 16 signers, signature verification enabled: 6 signer keys (plus one
  transmitter key, also ECDSA) forge a commit report. `MultiOCR3Base._transmit` line 318: `ecrecover` per signature.
- Router `0x80226fc0…` `getOffRamps()`: 180 (source chain, offRamp) entries; 36 point to this OffRamp, 69 to
  `0x408428bca0e24a25ac8baac1b70f64af257717c3` ("OffRamp 2.0.0", verified; verifies through external cross-chain
  verifier contracts, not in this finding or the census), the rest to older 1.5 EVM2EVMOffRamps.

## CommitStore 1.5.0 `0xe4167750…`

- `getStaticConfig()`: source chain 6916147374840168594, onRamp `0x02b60267bceeafdc45005e0fa0dd783efebc9f1b`, RMN proxy
  `0x411de17f…`. `isUnpausedAndNotCursed()` = true, `paused()` = false.
- Router lists EVM2EVMOffRamp 1.5.0 `0x9a3ed7007809cfd666999e439076b4ce4120528d` for that source chain; its
  `getStaticConfig()` names this CommitStore. The lane can still release tokens from pools on a forged commit.

## Escrow: CCIP token pools

`ccip-pools.json`: TokenAdminRegistry `getAllConfiguredTokens` → 590 tokens, `getPools` → 564 pools; each pool's balance
of its own token from Blockscout `token-balances` with Blockscout prices, block 26,431,528. Sum $1,189,948,228; largest:
syrupUSDG pool $238.2M, syrupUSDC $204.8M, USDf $164.6M, syrupUSDT $67.5M, WLFI $64.3M, GHO $61.4M, AXS $61.0M.
This is an upper bound for one OffRamp: a pool releases only for remote chains it supports. Burn/mint pools hold nothing
but mint on a forged message (not measurable).

## KeeperRegistry 2.1 `0x6593c7de…`

- `transmit` (KeeperRegistry2_1.sol lines 67–185): requires `s_transmitters[msg.sender].active`, f+1 signatures
  (`_verifyReportSignature`), then calls each upkeep's forwarder with the report's `performData` and charges the
  upkeep's LINK balance using the report's `fastGasWei` and `linkNative`; reimbursement goes to `msg.sender`'s
  transmitter balance (line 177).
- LINK `balanceOf` = 18,825.37 LINK; held $171,311 at block 26,431,214 (`onchain.json`).

## Follow-up: CCIP OffRamp 2.0.0 `0x408428bca0e24a25ac8baac1b70f64af257717c3` (block 26,431,750)

- Verified on Sourcify (`contracts/offRamp/OffRamp.sol`). `typeAndVersion` "OffRamp 2.0.0"; `owner()` = RBACTimelock
  `0x44835bbb…`; no proxy. `getStaticConfig()`: Ethereum selector, RMNRemote `0x411de17f…`, TokenAdminRegistry
  `0xb22764f9…` (same pools as OffRamp 1.6.0).
- `execute(encodedMessage, ccvs, verifierResults, gasLimitOverride)` (line 188) is permissionless; it checks the RMN
  curse (`isCursed`, line 199; no blessing step), the lane config and the onRamp, then `executeSingleMessage` (line 308)
  gathers the required cross-chain verifiers (receiver, pool, lane-mandated, default; `_ensureCCVQuorumIsReached`) and
  for each calls `ICrossChainVerifierResolver.getInboundImplementation(verifierResults)` and
  `ICrossChainVerifierV1.verifyMessage` (lines 342–352); then releases or mints the token through the pool and calls the
  receiver through the Router.
- `getAllSourceChainConfigs()`: 69 source chains, all enabled, router `0x80226fc0…`; every lane has the same
  `defaultCCVs` = [`0x2caafd3b4cf606220580c885bd2b448fb93dc03b`] and no lane-mandated CCVs.
- `0x2caafd3b…` VersionedVerifierResolver 2.0.0 (verified), `owner()` = RBACTimelock `0x44835bbb…`;
  `getAllInboundImplementations()` = [(`0xe9a05a20`, CommitteeVerifier 2.0.0 `0x7bce1a3297604cafa601f05799b6ed98e8c01b7f`)];
  the owner can change it with `applyInboundImplementationUpdates`.
- CommitteeVerifier `0x7bce1a32…` (verified, owner RBACTimelock `0x44835bbb…`): `verifyMessage` (CommitteeVerifier.sol
  line 85) → `SignatureQuorumValidator._validateSignatures` (line 62): `ecrecover` per signature (line 88), at least
  `threshold` distinct configured signers. `getSignatureConfig` for the 69 lanes: threshold 9 with 15 signers (55 lanes),
  16 signers (11) or 14 signers (3); 33 distinct signer addresses, none shared with OffRamp 1.6.0's commit signers.
- Pools can require their own CCVs for token-only transfers (`requiredPoolCCVs`); pools' CCV settings were not read
  (INFERRED: most use the default committee).
- `trace_filter` blocks 23,803,750–26,431,750 (`offramp-2.0.0-trace.json`): 18,234 transactions, 9,354 in the last
  216,000 blocks (about 30 days), last block 26,431,750; callers are executor EOAs.
