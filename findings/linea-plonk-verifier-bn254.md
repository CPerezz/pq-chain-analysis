---
id: linea-plonk-verifier-bn254
title: "Linea: LineaRollup finalizes L2 state with gnark PLONK proofs on BN254; with the setup trapdoor an operator key can finalize a false state and drain $46M from the rollup and its TokenBridge"
project: linea
status: confirmed
severity: MEDIUM
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x1d930e3fac9fbc7026ec17962d2f57d558d37532"
  implementation: null
  name: PlonkVerifierFull (LineaRollup proofType 1, current)
  upgradeable: "no"
  admin: "none (immutable); LineaRollup.setVerifierAddress by TimeLock 0xd6b95c960779c72b8c6752119849318e5d550574 (Security Council Safe 0x892bb7eed71efb060ab90140e7825d8127991dd3, 5 of 9)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: null
  txs_30d: null
- address: "0x8f8ec9608223c0b8d13238950c03f5d42ceebb9b"
  implementation: null
  name: PlonkVerifierMainnetFull (retired; proofType 4 unset at block 24730601)
  upgradeable: "no"
  admin: none (immutable; no longer set in LineaRollup)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-03-23
  txs_30d: 0
- address: "0x9473c37a9fe76fbbc3fd7d3b59e1b550415bd873"
  implementation: null
  name: PlonkVerifierMainnetFull (retired; proofType 1 replaced at block 23669642)
  upgradeable: "no"
  admin: none (immutable; no longer set in LineaRollup)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-10-22
  txs_30d: 0
- address: "0xed39c0c41a7651006953ab58ecb3039363620995"
  implementation: null
  name: PlonkVerifierMainnetFull (retired; proofType 0 replaced at block 23669642)
  upgradeable: "no"
  admin: none (immutable; no longer set in LineaRollup)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-08-23
  txs_30d: 0
- address: "0xa12e79c375fb0aaddfda597bbe7b4e9a92e9b3de"
  implementation: null
  name: PlonkVerifierMainnetFull (prague; retired, proofType 0 unset at block 23935989)
  upgradeable: "no"
  admin: none (immutable; no longer set in LineaRollup)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-11-17
  txs_30d: 0
- address: "0x814d80782aa8c508ababe9c6956d8f1f90e5177a"
  implementation: null
  name: PlonkVerifierMainnetFull (retired; proofType 3 unset at block 24715470)
  upgradeable: "no"
  admin: none (immutable; no longer set in LineaRollup)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-12-04
  txs_30d: 0
- address: "0xbff4a03a355eef7da720bbc7878f9bdbbe81fe6f"
  implementation: null
  name: PlonkVerifierForMultiTypeDataAggregation (retired; proofType 3 unset at block 22623238)
  upgradeable: "no"
  admin: none (immutable; no longer set in LineaRollup)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-04-29
  txs_30d: 0
- address: "0x41a4d93d09f4718fe899d12a4ad2c8a09104bdc7"
  implementation: null
  name: PlonkVerifierMainnetFull (retired; proofType 4 unset at block 23214311)
  upgradeable: "no"
  admin: none (immutable; no longer set in LineaRollup)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-06-09
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: "Linea Security Council Safe 0x892bb7eed71efb060ab90140e7825d8127991dd3 (5 of 9), through TimeLock 0xd6b95c960779c72b8c6752119849318e5d550574 (holder of VERIFIER_SETTER_ROLE on LineaRollup 0xd19d4b5d358258f05d7b411e21a1460d11b0876f), points proofType 0/1 at a post-quantum verifier"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/linea-plonk-verifier-bn254
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl,out_2.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review12)
  ref: findings review 2026-11-17; Blockscout source of 0x0b3943f4 and 0x1d930e3f, VerifierAddressChanged logs, cast reads at block 26431459
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [linearollup-d19d4b5d-blob-kzg-opening]
---

## Summary

LineaRollup (`0xd19d4b5d…`) finalizes L2 state roots only after a gnark PLONK proof over BN254 verifies (PQ-7). With
the trapdoor of the proof system's KZG setup, a quantum attacker who also holds an operator key (two EOAs, recoverable
with the same computer) can finalize a false state root with false L2→L1 messages and claim them, draining
LineaRollup's 19,599 ETH and the TokenBridge: $46.2M at 2026-11-17. The verifier is a setting: the Security Council
(Safe 5 of 9, through a TimeLock with no delay) has replaced it many times, most recently at block 26,408,786. Rated
MEDIUM, step 4: the fix is a new verifier the consumer points at.

## Mechanism

- `LineaRollup.finalizeBlocks(aggregatedProof, proofType, finalizationData)` (`onlyRole(OPERATOR_ROLE)`) reads
  `verifiers[proofType]`, computes one public input from the shnarf chain, state roots, L2 message roots and rolling
  hashes, and `_verifyProof` calls `IPlonkVerifier(verifier).Verify(proof, [publicInput])`, reverting on failure
  (`LineaRollupBase.sol` lines 359–403, 709 ff.; `source-excerpts.md`).
- The finalized L2 message Merkle roots are what `claimMessageWithProof` checks before LineaRollup sends ETH, and what
  TokenBridge `0x051f1d88…` (whose `messageService()` is LineaRollup) relies on to release tokens.
- Current verifiers `0x0b3943f4…` (proofType 0, used by finalization; sample tx `0x9b63dd06…` at block 26,430,204) and
  `0x1d930e3f…` (proofType 1) are `PlonkVerifierFull`: `Verify` (line 194) works over the BN254 scalar field `R_MOD`
  (line 25) and ends in a KZG batch-opening pairing check, `staticcall(gas(), 8, …)` (line 914), with `modexp` (0x05)
  for inversions. The seven verifiers in the original draft are older builds of the same gnark verifier
  (`PlonkVerifierMainnetFull`, `PlonkVerifierForMultiTypeDataAggregation`); none is set any more
  ([`verifier-history.md`](#linearollup-verifier-history)).
- Pattern PQ-7 (SNARK verification over a pairing curve, trigger: trusted setup).

## Evidence

- CHECKED (Blockscout verified source of `0x0b3943f4…` and `0x1d930e3f…`, `src/verifiers/PlonkVerifierFull.sol`,
  solc 0.8.33, read 2026-11-17): BN254 PLONK as above. The two have identical source length (60,595 bytes).
- CHECKED (Sourcify full source of LineaRollup implementation `0x052b73d9…`): `finalizeBlocks`, `_verifyProof`,
  `setVerifierAddress` (`VERIFIER_SETTER_ROLE`), `unsetVerifierAddress` (`VERIFIER_UNSETTER_ROLE`).
- CHECKED (cast at block 26,431,459): `verifiers(0)` = `0x0b3943f4…`, `verifiers(1)` = `0x1d930e3f…`, `verifiers(2..10)`
  = 0; `VERIFIER_SETTER_ROLE` held by TimeLock `0xd6b95c96…` (`getMinDelay()` = 0), whose proposer and executor is
  Safe `0x892bb7ee…` (5 of 9), which also holds `VERIFIER_UNSETTER_ROLE` and `DEFAULT_ADMIN_ROLE`; `OPERATOR_ROLE` held
  by EOAs `0x46d2f319…` and `0x52ff08f3…` ([`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/linea-plonk-verifier-bn254/escrow.json)).
- CHECKED (Blockscout logs, `VerifierAddressChanged`): full history of verifier changes; the seven draft verifiers were
  set and later replaced or unset between blocks 20,332,062 and 24,730,601.
- CHECKED (on-chain read at block 26,431,214): the seven draft verifiers have code, no proxy, no holdings
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/linea-plonk-verifier-bn254/onchain.json)).
- CHECKED (cast + Blockscout, block 26,431,459): escrow LineaRollup 19,599.4 ETH ($35.57M) + TokenBridge $10.61M.
- CHECKED (precompile trace, year to March 2026, `txs_y1`): 0x8f8ec960 1,739; 0x9473c37a 845; 0xed39c0c4 467;
  0xa12e79c3 344; 0x814d8078 335; 0xbff4a03a 325; 0x41a4d93d 323 transactions.
- INFERRED: `0x0b3943f4…` was last used 2026-11-16 (the sample finalization uses proofType 0, which it has held since
  block 26,408,786); its 30-day count and any use of `0x1d930e3f…` were not measured (deployed after the activity scan).

## Impact and exposure

| Contract | Status | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0x0b3943f4…` PlonkVerifierFull | current, proofType 0 | $46.2M (escrow) | 2026-11-16 | — |
| `0x1d930e3f…` PlonkVerifierFull | current, proofType 1 | (same escrow) | — | — |
| `0x8f8ec960…` PlonkVerifierMainnetFull | retired | — | 2026-03-23 | 0 |
| `0x9473c37a…` PlonkVerifierMainnetFull | retired | — | 2025-10-22 | 0 |
| `0xed39c0c4…` PlonkVerifierMainnetFull | retired | — | 2025-08-23 | 0 |
| `0xa12e79c3…` PlonkVerifierMainnetFull (prague) | retired | — | 2025-11-17 | 0 |
| `0x814d8078…` PlonkVerifierMainnetFull | retired | — | 2025-12-04 | 0 |
| `0xbff4a03a…` PlonkVerifierForMultiTypeDataAggregation | retired | — | 2025-04-29 | 0 |
| `0x41a4d93d…` PlonkVerifierMainnetFull | retired | — | 2025-06-09 | 0 |

- Escrow: LineaRollup `0xd19d4b5d…` (19,599 ETH, $35.57M) and TokenBridge `0x051f1d88…` ($10.61M: USDT, WBTC, wstETH,
  …), $46,177,353 at 2026-11-17; counted once, on the proofType-0 verifier.
- The retired verifiers secure nothing now; they are listed because they verified Linea's proofs in the last year.
- Siblings: the Linea-stack rollup at proxy `0x2f3c2056…` (not Linea mainnet) uses its own verifier, covered by
  `rarimo-plonk-verifier`.

## Remediation

- Replacement: a hash-based verifier (STARK/FRI, e.g. Linea's own Vortex/Limitless outer layer without the BN254 PLONK
  wrap, or WHIR) deployed and set with `setVerifierAddress` for each proofType in use, at several times the gas.
- Who acts: Linea Security Council Safe `0x892bb7ee…` (5 of 9) through TimeLock `0xd6b95c96…`, which holds
  `VERIFIER_SETTER_ROLE`; the Safe can `unsetVerifierAddress` a compromised verifier directly. No protocol change needed.
- Moving `OPERATOR_ROLE` from EOAs to post-quantum-authorised accounts would stop an outside attacker from submitting a
  forged proof, but not a malicious operator.
- Users can only reduce exposure by withdrawing from Linea; the data-availability side is in `linea-blob-kzg`.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review12): MEDIUM -> MEDIUM, step 4: new verifier set by the Security Council (TimeLock, 0 delay; Safe 5 of 9). All seven drafted verifiers are retired; added the two current verifiers 0x0b3943f4 and 0x1d930e3f (read from `verifiers(0/1)`); escrow $46.2M (LineaRollup ETH + TokenBridge) on the proofType-0 verifier; related to linea-blob-kzg.

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
