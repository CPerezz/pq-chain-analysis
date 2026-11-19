---
id: chainlink-ocr-don-ecdsa-signers
title: "Chainlink CCIP, Automation and CRE: a quantum attacker who recovers a quorum of DON or CCIP committee signer keys can execute forged cross-chain messages that release up to $1.19B from CCIP token pools, drain Automation upkeep balances, and push forged reports to CRE receivers"
project: chainlink
status: confirmed
severity: MEDIUM
patterns: [PQ-5, PQ-17]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x26d3681dfc9e4c8c79cfbf461adec8a21d5d73c5"
  implementation: null
  name: OffRamp 1.6.0 (CCIP)
  upgradeable: config-only
  admin: "owner RBACTimelock 0x44835bbba9d40deda9b64858095ecfb2693c9449 (min delay 3 h): setOCR3Configs, applySourceChainConfigUpdates; read at block 26,431,454"
  value_usd: 1189948228
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 35981
- address: "0xa68a99c6a80e2acf65d38f64ffac744ae51c8d96"
  implementation: null
  name: KeystoneForwarder 1.0.0
  upgradeable: config-only
  admin: "owner EOA 0xf99aa0a78d1eeb619f0e548465f6d67debcecc98 (setDONConfig); read at block 26,431,454"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-04-20
  txs_30d: 0
- address: "0x6593c7de001fc8542bb1703532ee1e5aa0d458fd"
  implementation: null
  name: KeeperRegistry 2.1.0 (Automation)
  upgradeable: config-only
  admin: "owner Safe 0xcc4b5b07316be81ed6edb44ca61e4cab28a1950d (4 of 12): setConfig signers and transmitters; read at block 26,431,454"
  value_usd: 171311
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-14
  txs_30d: 6
- address: "0x0b93082d9b3c7c97facd250082899bacf3af3885"
  implementation: null
  name: KeystoneForwarder 1.0.0 (CRE)
  upgradeable: config-only
  admin: "owner RBACTimelock 0x4044a864754760c37200e3a76d1953512ee18da8 (min delay 1 h): setConfig per DON; read at block 26,431,454"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 18670
- address: "0xe41677500b425999cb4133950ca3ab79ea7470a6"
  implementation: null
  name: CommitStore 1.5.0 (CCIP, one lane)
  upgradeable: config-only
  admin: "owner RBACTimelock 0x44835bbba9d40deda9b64858095ecfb2693c9449 (min delay 3 h): setOCR2Config; read at block 26,431,454"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-09-25
  txs_30d: 0
- address: "0x408428bca0e24a25ac8baac1b70f64af257717c3"
  implementation: null
  name: OffRamp 2.0.0 (CCIP; default verifier CommitteeVerifier 2.0.0 0x7bce1a32 via resolver 0x2caafd3b)
  upgradeable: config-only
  admin: "owner RBACTimelock 0x44835bbba9d40deda9b64858095ecfb2693c9449 (min delay 3 h) of the OffRamp (applySourceChainConfigUpdates), of VersionedVerifierResolver 0x2caafd3b4cf606220580c885bd2b448fb93dc03b (applyInboundImplementationUpdates) and of CommitteeVerifier 0x7bce1a3297604cafa601f05799b6ed98e8c01b7f (applySignatureConfigs); read at block 26,431,750"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-17
  txs_30d: 9354
families: []
fix:
  layer: new-deployment
  who_acts: "Chainlink: CCIP owner RBACTimelock 0x44835bbba9d40deda9b64858095ecfb2693c9449 (new OffRamp 1.6 replacement and Router update; for OffRamp 2.0.0 a post-quantum CommitteeVerifier registered in resolver 0x2caafd3b4cf606220580c885bd2b448fb93dc03b), Automation owner Safe 0xcc4b5b07316be81ed6edb44ca61e4cab28a1950d, CRE forwarder owners 0x4044a864754760c37200e3a76d1953512ee18da8 and 0xf99aa0a78d1eeb619f0e548465f6d67debcecc98; CRE receivers and upkeep owners then trust the new contracts"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/chainlink-ocr-don-ecdsa-signers
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl,out_2.jsonl,out_3.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review11 (Claude), finding review
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/chainlink-ocr-don-ecdsa-signers/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c6f0bfd6, 5aef6abf, 9040d70c, 449f23ae"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: [chainlink-vrf-secp256k1]
---

## Summary

Six Chainlink contracts accept a report or message once a quorum of secp256k1 signatures from a decentralised oracle
network (DON) or CCIP committee verifies with `ecrecover` (PQ-5). Signer keys are public from their signatures, so a
quantum attacker can forge a quorum. On CCIP, OffRamp 1.6.0 (6 of 16 commit signers, RMN blessing disabled on all 37
source lanes) and OffRamp 2.0.0 (9 of 14–16 committee signers on each of 69 lanes) let the attacker execute invented
cross-chain messages that release tokens from CCIP pools, which held $1.19B on 2026-11-17 (upper bound). On Automation the
registry's $171k of LINK can be paid out as forged gas reimbursement; CRE forwarders pass forged reports to receivers
such as `DataFeedsCache`. Rated MEDIUM (step 4): Chainlink can deploy post-quantum verification and repoint the Router,
resolver, registries and forwarders, but CRE receivers and upkeeps must move with it.

## Mechanism

- OffRamp 1.6.0 `0x26d3681d…`: `commit` → `MultiOCR3Base._transmit` recovers each signature (line 318) and requires a
  `Signer` role and uniqueness; F = 5, 16 signers for the commit plugin. `RMNRemote.verify` runs only for
  `blessedMerkleRoots` (OffRamp.sol line 818); every source chain has `isRMNVerificationDisabled = true`. Committed roots
  let `execute` release or mint tokens through the token pools registered in TokenAdminRegistry `0xb22764f9…`.
- CommitStore 1.5.0 `0xe4167750…`: `report` (OCR2Base) checks f+1 `ecrecover` signatures; EVM2EVMOffRamp 1.5.0
  `0x9a3ed700…`, still on the Router for source chain 6916147374840168594, executes against its roots.
- OffRamp 2.0.0 `0x408428bc…`: `execute` (OffRamp.sol line 188) is permissionless and checks only the RMN curse, the
  lane and the onRamp; `executeSingleMessage` (line 308) asks each required cross-chain verifier (CCV) to
  `verifyMessage` (lines 342–352), then releases or mints through the pool. All 69 lanes have one default CCV,
  VersionedVerifierResolver `0x2caafd3b…`, whose only inbound implementation is CommitteeVerifier 2.0.0 `0x7bce1a32…`:
  `SignatureQuorumValidator._validateSignatures` (line 62) `ecrecover`s each signature (line 88) and needs 9 distinct
  configured signers (14–16 per lane, 33 signer addresses overall, none shared with OffRamp 1.6.0).
- KeeperRegistry 2.1 `0x6593c7de…`: `transmit` (lines 67–185) requires an active transmitter and f+1 signatures, runs
  each upkeep with the report's `performData`, and reimburses `msg.sender` from upkeep balances at the report's gas
  price (line 177).
- KeystoneForwarder 1.0.0 `0x0b93082d…` and `0xa68a99c6…`: `report` recovers each signature (line 287ff), requires f+1
  distinct DON signers from the owner's config, and calls `receiver.onReport`.
- Rotating signers (`setOCR3Configs`, `setConfig`) keeps the scheme; the verification code is fixed in each contract.

## Evidence

- CHECKED (verified source, Sourcify): the signature loops above
  ([`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/chainlink-ocr-don-ecdsa-signers/source-excerpts.md)).
- CHECKED (on-chain read, block 26,431,454): owners and owner types, OffRamp source-chain configs and commit OCR config,
  Router off-ramp list, CommitStore lane and paused state ([`notes.md`](#review-notes-chainlink-ocr-don-ecdsa-signers-2026-11-17)).
- CHECKED (on-chain read, block 26,431,750): OffRamp 2.0.0 owner, static config and 69 lane configs; resolver inbound
  implementations; CommitteeVerifier signature configs for every lane ([`notes.md`](#review-notes-chainlink-ocr-don-ecdsa-signers-2026-11-17)).
- CHECKED (`trace_filter`, blocks 23,803,750–26,431,750): OffRamp 2.0.0 called by 18,234 transactions, 9,354 in the
  last 216,000 blocks (about 30 days; trace count, not Xatu), last block 26,431,750
  ([`offramp-2.0.0-trace.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/chainlink-ocr-don-ecdsa-signers/offramp-2.0.0-trace.json)).
- CHECKED (TokenAdminRegistry + Blockscout, block 26,431,528): 564 pools hold $1,189,948,228 of their own tokens
  ([`ccip-pools.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/chainlink-ocr-don-ecdsa-signers/ccip-pools.json)).
- CHECKED (on-chain read, block 26,431,214): KeeperRegistry 2.1 holds $171k of LINK
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/chainlink-ocr-don-ecdsa-signers/onchain.json)).
- CHECKED (Blockscout logs, latest 50): `0x0b93082d…` delivered reports to `CREReceiver` `0xc2e34e3d…`,
  `DataFeedsCache` `0x402641d8…`, `MyWriterTrigger` `0x218283ec…` and two `Machine` beacon proxies.
- CHECKED (Xatu, any function): activity per contract in the table
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/chainlink-ocr-don-ecdsa-signers/activity.json)).
- INFERRED: which pools a forged message on a given lane can reach (pools release only for remote chains they support),
  so the pool total is an upper bound for the OffRamp.

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0x26d3681d…` OffRamp 1.6.0 | config-only | $1.19B in CCIP pools (escrow, upper bound) | 2026-11-16 | 35,981 |
| `0xa68a99c6…` KeystoneForwarder | config-only | not measured (receivers) | 2026-04-20 | 0 |
| `0x6593c7de…` KeeperRegistry 2.1 | config-only | $171k LINK held | 2026-11-14 | 6 |
| `0x0b93082d…` KeystoneForwarder | config-only | not measured (receivers) | 2026-11-16 | 18,670 |
| `0xe4167750…` CommitStore 1.5.0 | config-only | same pools as the OffRamp (not added again) | 2026-09-25 | 0 |
| `0x408428bc…` OffRamp 2.0.0 | config-only | same pools as OffRamp 1.6.0 (not added again) | 2026-11-17 | 9,354 |

- The CCIP pool total counts each pool's own-token balance once; burn/mint pools hold nothing but would mint on a forged
  message, which is not counted. The CommitStore's lane reaches a subset of the same pools; OffRamp 2.0.0 reaches them
  through the same TokenAdminRegistry. Pools can require their own CCVs for token-only transfers; those settings were
  not read.
- CRE and Automation: what forged `onReport` and `performUpkeep` calls can do depends on each receiver and upkeep (price
  caches feed lending markets); not measured.
- Yearly pre-quantum counts from the census (`txs_y1`): OffRamp 1.6.0 170,994; KeeperRegistry 63,134; KeystoneForwarders
  35,556 and 86,132; CommitStore 23,878. OffRamp 2.0.0 and CommitteeVerifier are not in the census (created at blocks
  25,225,111 and 25,225,129, after the March 2026 precompile trace).

## Remediation

- CCIP: deploy an OffRamp (and CommitStore replacement) that verifies a post-quantum attestation (hash-based signatures,
  or a STARK proving the DON quorum signed), and switch the Router's off-ramps; owner RBACTimelock `0x44835bbb…` (3 h
  delay). For OffRamp 2.0.0 no new OffRamp is needed: the same timelock registers a post-quantum CommitteeVerifier in
  resolver `0x2caafd3b…` (`applyInboundImplementationUpdates`). Re-enabling RMN blessing on 1.6.0 adds a second
  committee but RMN also signs with ECDSA.
- Automation: migrate upkeeps from registry 2.1 to a registry with post-quantum report verification; owner Safe
  `0xcc4b5b07…` (4 of 12) and each upkeep owner.
- CRE: deploy a post-quantum forwarder (owners `0x4044a864…` timelock and EOA `0xf99aa0a7…`); every receiver that checks
  `msg.sender == forwarder` must accept the new one.
- No protocol change is needed. Token issuers can cap CCIP pool rate limits to bound a forged release.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review11): MEDIUM unchanged (step 4: Chainlink deploys new verification and repoints; receivers and upkeeps move). Escrow measured: CCIP pools $1.19B (upper bound) on the OffRamp; RMN blessing found disabled on all 37 OffRamp lanes; owners resolved (two RBACTimelocks, a 4-of-12 Safe, one EOA); CommitStore lane still live on the Router. OffRamp 2.0.0 0x408428bc… noted as unreviewed.
- 2026-11-17 follow-up (Review11): added CCIP OffRamp 2.0.0 `0x408428bc…` (69 lanes, default CCV resolver `0x2caafd3b…` -> CommitteeVerifier 2.0.0 `0x7bce1a32…`, 9 of 14–16 `ecrecover` signers per lane, owner RBACTimelock `0x44835bbb…`; 9,354 transactions in about 30 days by trace). MEDIUM re-checked and unchanged (step 4: the timelock swaps in a new verifier implementation; same pools, value not added again).
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer key can be replaced; it must be rotated before its account takes code. Executed: a real transaction reverts when its signer has code.

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
