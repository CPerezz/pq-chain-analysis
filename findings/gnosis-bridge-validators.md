---
id: gnosis-bridge-validators
title: "Gnosis Chain bridges: a quantum attacker who recovers 4 of 7 validator ECDSA keys can forge withdrawals from the xDAI bridge (USD 47.7M) and AMB messages that drain the Omnibridge (USD 209.9M)"
project: gnosis
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x4aa42145aa6ebf72e164c9bbc74fbd3788045016"
  implementation: "0x257bdd093cab1bd39ebf837dcb60f33d031d7d49"
  name: XDaiForeignBridge (EternalStorageProxy; Ethereum side of the xDAI/USDS bridge)
  upgradeable: "yes"
  admin: "upgradeabilityOwner and owner = Safe 0x42f38ec5a75accec50054671233dfac9c0e7a3f6 (8 of 15, read at block 26431214); validator set 0xe1579debdd2df16ebdb9db8694391fa74eea201e owned by the same Safe (read at block 26431561)"
  value_usd: 47728330
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 381
- address: "0x4c36d2919e407f0cc2ee3c993ccf8ac26d9ce64e"
  implementation: "0x098f51bdfb5d6d319dd4fdf06b64773d25bd1316"
  name: ForeignAMB (EternalStorageProxy; Ethereum side of the Ethereum-Gnosis arbitrary message bridge)
  upgradeable: "yes"
  admin: "upgradeabilityOwner and owner = Safe 0x42f38ec5a75accec50054671233dfac9c0e7a3f6 (8 of 15); validator set 0xed84a648b3c51432ad0fd1c2cd2c45677e9d4064 owned by the same Safe (read at block 26431561)"
  value_usd: 209946410
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: null
families: []
fix:
  layer: contract-upgrade
  who_acts: "Gnosis bridge governance Safe 0x42f38ec5a75accec50054671233dfac9c0e7a3f6 (8 of 15): upgrade both EternalStorageProxy implementations to a post-quantum check (for example making the existing Hashi path mandatory with post-quantum or ZK light-client adapters)"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gnosis-bridge-validators
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl,out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: [pulsechain-bridge-validators]
---

## Summary

Gnosis Chain's two Ethereum bridge contracts release funds on ECDSA signatures from 4 of 7 bridge validators (PQ-5):
the xDAI bridge pays out USDS/sUSDS it holds (USD 47.7M), and the arbitrary message bridge (AMB) executes messages
that let the Omnibridge `0x88ad0951…` release bridged tokens (at least USD 209.9M). A quantum attacker who recovers
four validator keys from their on-chain signatures can forge both. A Hashi multi-oracle check is wired in but not
mandatory. Both proxies are upgradeable by one 8-of-15 Safe. Rated MEDIUM: step 4 (fix by a contract upgrade).

## Mechanism

- xDAI bridge, implementation `XDaiForeignBridge` `0x257bdd09…`: `executeSignatures(message, signatures)`
  (`BasicForeignBridge.sol` lines 22-44) calls `Message.hasEnoughValidSignatures(message, signatures,
  validatorContract(), false)` (`Message.sol` lines 109-142): `requiredSignatures()` rounds of `ecrecover(hash, v, r,
  s)` against `isValidator`, no duplicates; then, within `executionMaxPerTx`/`executionDailyLimit`,
  `onExecuteMessage` pays `recipient` the amount. Line 37 requires Hashi approval only if `HASHI_IS_ENABLED &&
  HASHI_IS_MANDATORY`, and `BasicBridge.sol` line 29 sets `HASHI_IS_MANDATORY = false` as a constant.
- AMB, implementation `ForeignAMB` `0x098f51bd…`: `executeSignatures` (`BasicForeignAMB.sol` line 15) →
  `_allowMessageExecution` (lines 87-95) → the same `Message.hasEnoughValidSignatures` (`Message.sol` line 123
  `ecrecover`); `_executeMessage` (lines 108-124) has the same non-mandatory Hashi check and then calls the executor.
  The Omnibridge `0x88ad0951…` (`bridgeContract()` = this AMB) mints or releases tokens on such messages.
- Pattern PQ-5. The draft's excerpt file has no lines because only the proxies' source was excerpted; the lines above
  are from the implementations on Sourcify.

## Evidence

- CHECKED (verified source on Sourcify, read 2026-11-17): the implementation lines above for `0x257bdd09…` and
  `0x098f51bd…`.
- CHECKED (`cast call` at block 26,431,561): xDAI bridge `implementation()` `0x257bdd09…`, `upgradeabilityOwner()` and
  `owner()` Safe `0x42f38ec5…`, `validatorContract()` `0xe1579deb…` (7 validators, `requiredSignatures()` 4, owner the
  Safe), `HASHI_IS_MANDATORY()` false, `executionDailyLimit()` 15M and `executionMaxPerTx()` 10M USDS; AMB
  `implementation()` `0x098f51bd…`, `destinationChainId()` 100, owner/upgradeabilityOwner the Safe, `validatorContract()`
  `0xed84a648…` (7 validators, 4 required), `HASHI_IS_MANDATORY()` false; Omnibridge `bridgeContract()` = the AMB, owner
  the Safe ([`review-reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gnosis-bridge-validators/review-reads.json)).
- CHECKED (on-chain read at block 26,431,214): Safe `0x42f38ec5…` threshold 8 of 15 owners; xDAI bridge holdings
  $47.7M (sUSDS $46.9M, USDS $0.83M) ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gnosis-bridge-validators/onchain.json)).
- CHECKED (Blockscout, 2026-11-17): Omnibridge ERC-20 holdings (first page, by value) $209.9M; AMB 96,210 transactions
  in total, last 2026-11-16 (`executeSignatures`).
- CHECKED (precompile trace): xDAI bridge 4,274 `ecrecover` calls in the year to March 2026 (`curated_contracts.csv`);
  the AMB `0x4c36d291…` is not in the census, so it has no trace count and no Xatu 30-day count (`txs_30d` null).
- CHECKED (Xatu, any function): xDAI bridge 381 transactions in 2026-10-16 to 2026-11-16, last 2026-11-15
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/gnosis-bridge-validators/activity.json)).
- INFERRED: the xDAI bridge's daily limit (15M USDS) slows but does not stop a drain; Omnibridge per-token limits were
  not read.

## Impact and exposure

| Contract | Upgradeable | Exposed | Last active | 30-day txs |
|---|---|---|---|---|
| `0x4aa42145…` XDaiForeignBridge | yes | $47.7M (held) | 2026-11-15 | 381 |
| `0x4c36d291…` ForeignAMB (Ethereum-Gnosis) | yes | $209.9M (escrow: Omnibridge `0x88ad0951…`) | 2026-11-16 | not measured |

Omnibridge escrow (first page of holdings): GNO $134.4M, wstETH $29.8M, TRAC $20.3M, USDC $12.9M, WETH $4.7M, COW
$1.6M, WBTC $1.4M, HOPR $1.1M, USDT $0.9M, …; no ETH. Other AMB consumers were not measured.

Grouping change: the draft's `0xd0764fae…` ForeignAMB is the Ethereum-PulseChain bridge (destinationChainId 369,
PulseChain deployer) and was moved to `pulsechain-bridge-validators`; Gnosis's own AMB `0x4c36d291…`, which was in no
finding, was added here.

## Remediation

- Post-quantum replacement: replace validator ECDSA attestations with a post-quantum signature scheme or a ZK/STARK
  proof of Gnosis consensus; the code already has a Hashi hook, so an implementation that makes Hashi mandatory with
  post-quantum adapters (and drops the ECDSA threshold) would work.
- Who acts: Safe `0x42f38ec5…` (8 of 15) upgrades both EternalStorageProxy implementations; `HASHI_IS_MANDATORY` is a
  constant, so this is an implementation upgrade, not a setting. Rotating validators does not help.
- Protocol change: not needed. Users can bridge back and hold assets on Ethereum directly.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review20): MEDIUM kept, step 4: both proxies upgradeable by Safe `0x42f38ec5…` (8 of 15); Hashi
  present but not mandatory (constant). Moved `0xd0764fae…` (PulseChain AMB, chain 369) to
  `pulsechain-bridge-validators`; added Gnosis's AMB `0x4c36d291…` with Omnibridge escrow $209.9M (Blockscout, first
  page); validator sets and thresholds read at block 26,431,561.

# Source excerpts: gnosis-bridge-validators

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xd0764fae29e0a6a96ff685f71cfc685456d5636c` — EternalStorageProxy (verified source via sourcify)


## Contract `0x4aa42145aa6ebf72e164c9bbc74fbd3788045016` — EternalStorageProxy (verified source via sourcify)
