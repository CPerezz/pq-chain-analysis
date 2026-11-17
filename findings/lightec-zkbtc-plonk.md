---
id: lightec-zkbtc-plonk
title: "Lightec zkBTC bridge: deposit and redeem proofs are gnark PLONK on BN254; a recovered setup trapdoor lets an attacker mint unbacked zkBTC and redeem the bridge's BTC reserve ($773)"
project: lightec
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254, sw_bn254]
trigger: trusted-setup
impact: funds-loss
alternative: configurable-verifier
role: core
contracts:
- address: "0x42d75517041801406dc5374f849bd766945b4d15"
  implementation: null
  name: gnark PLONK verifier, deposit (unverified; BtcTxVerifier.depositVerifier)
  upgradeable: "no"
  admin: none; consumer BtcTxVerifier 0x1f0f891fb88287091dfc6225038336207374ec79 has no DEFAULT_ADMIN_ROLE holder, so it cannot repoint; zkBTCBridge 0xf90966fd006a5b18cb0e3a0568226010ced426fd TEMPORARY_ROLE EOA 0x23761b22d3677d374713069340b30aa9e3861c32 can replace the whole BtcTxVerifier (updateBtcTxVerifier)
  value_usd: 773
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-04-30
  txs_30d: 0
- address: "0xf3c2d0d821ec7343160adeddd5559b745bb12be2"
  implementation: null
  name: gnark PLONK verifier, redeem (unverified; BtcTxVerifier.redeemVerifier)
  upgradeable: "no"
  admin: as for the deposit verifier (zkBTCBridge TEMPORARY_ROLE EOA 0x23761b22d3677d374713069340b30aa9e3861c32)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-05-29
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: Lightec, through the zkBTCBridge TEMPORARY_ROLE holder, EOA 0x23761b22d3677d374713069340b30aa9e3861c32 (deploys a BtcTxVerifier with hash-based verifiers and calls updateBtcTxVerifier)
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/lightec-zkbtc-plonk
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review10 (bytecode, consumer source and on-chain review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/lightec-zkbtc-plonk/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Lightec's zkBTC bridge accepts Bitcoin deposits and redemption completions on proof alone: `BtcTxVerifier` checks a gnark PLONK proof over BN254 from the deposit or redeem verifier (PQ-7). With the trusted-setup trapdoor, a quantum attacker can prove a Bitcoin deposit that never happened, mint zkBTC, and redeem it against the BTC the bridge's operator address holds. That reserve is 0.01197 BTC ($773) and zkBTC supply is 0.0123 BTC on 2026-11-17. Rated LOW: step 4 gives MEDIUM (one known EOA can repoint the bridge at a new BtcTxVerifier), lowered by step 5 (under USD 50k exposed).

## Mechanism

- `zkBTCBridge.deposit(rawBtcTx, params, proofData)` (verified, `0xf90966fd…`): decodes the Bitcoin transaction, then `txVerifier.verifyDepositTx(...)`, which calls `depositVerifier.Verify(proofData, publicWitness)` (`0x42d75517…`); on success it records the UTXO and `feeAccount.splitDepositReward` mints zkBTC to the recipient.
- `zkBTCBridge.updateRedeem(params, txid, minerReward, proofData)`: `txVerifier.verifyRedeemTx(...)` calls `redeemVerifier.Verify` (`0xf3c2d0d8…`) to confirm a redemption was broadcast on Bitcoin and update the change UTXO.
- Both verifiers are unverified 7,045-byte contracts with the gnark PLONK export's `Verify(bytes,uint256[])` (`0x7e4f7a8a`), the BN254 base and scalar field constants, and the transcript labels `zeta`/`beta`; every call uses ecadd, ecmul, ecpairing and modexp.
- `BtcTxVerifier.updateDepositVerifier`/`updateRedeemVerifier` are `onlyRole(DEFAULT_ADMIN_ROLE)`, and that role has no member. `zkBTCBridge.updateBtcTxVerifier` (`onlyRole(TEMPORARY_ROLE)`) can replace the whole BtcTxVerifier; the source says that role will be renounced once operation is stable.

## Evidence

- CHECKED (bytecode, 2026-11-17): selector, BN254 constants and gnark transcript labels in both verifiers; no proxy, no admin functions.
- CHECKED (verified consumer source, Sourcify): `zkBTCBridge.sol` and `BtcTxVerifier.sol` as above.
- CHECKED (on-chain, block 26,431,702): BtcTxVerifier `depositVerifier()` = `0x42d75517…`, `redeemVerifier()` = `0xf3c2d0d8…`, previous verifiers zero, DEFAULT_ADMIN_ROLE member count 0, BRIDGE_ROLE = zkBTCBridge; zkBTCBridge `txVerifier()` = `0x1f0f891f…`, DEFAULT_ADMIN_ROLE EOA `0x52d6e268…`, TEMPORARY_ROLE EOA `0x23761b22…` (also the verifiers' deployer); zkBTC `totalSupply()` 1,231,898 sat ([`review.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/lightec-zkbtc-plonk/review.json)).
- CHECKED (Bitcoin, mempool.space, 2026-11-17): the bridge's operator change script is P2WSH `bc1qcwc0…v9uq`, balance 1,196,712 sat.
- CHECKED (precompile trace, last year): deposit verifier 201, redeem verifier 82 transactions; sample transactions sent to zkBTCBridge. Xatu: no calls 2026-10-16 to 2026-11-16; last 2026-04-30 and 2026-05-29 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/lightec-zkbtc-plonk/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Escrow | Last active | 30-day txs |
|---|---|---|---|---|
| `0x42d75517…` PLONK verifier (deposit) | no | $773 (BTC reserve) | 2026-04-30 | 0 |
| `0xf3c2d0d8…` PLONK verifier (redeem) | no | (same reserve) | 2026-05-29 | 0 |

- Escrow: the BTC at the operator's multisig address on Bitcoin, 0.01196712 BTC at $64,633 (Blockscout WBTC price) = $773, 2026-11-17. zkBTC supply on Ethereum is 0.01231898 BTC ($796). FeePool records 5.389 BTC bridged in total, so the reserve was larger before.
- A forged deposit proof mints unbacked zkBTC; a forged redeem proof could mark redemptions as done. The bridge holds no ETH or tokens of its own on Ethereum.

## Remediation

- Lightec deploys a BtcTxVerifier whose deposit and redeem checks use a hash-based proof (STARK/FRI or WHIR) and has the TEMPORARY_ROLE holder (EOA `0x23761b22…`) call `zkBTCBridge.updateBtcTxVerifier`. If that role is renounced first, nothing in the deployed contracts can change the verifiers and the rating would rise.
- The EOA itself is an ECDSA key (PQ-12) and must move to post-quantum control.
- No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review10): MEDIUM -> LOW, step 5: escrow measured at $773 (BTC reserve; zkBTC supply 0.0123 BTC). Who can repoint established on-chain (BtcTxVerifier has no admin; zkBTCBridge TEMPORARY_ROLE EOA can replace it). Status candidate -> confirmed: bytecode fingerprint plus verified consumer source and on-chain reads.

# Source excerpts: lightec-zkbtc-plonk

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x42d75517041801406dc5374f849bd766945b4d15`

No verified source on Sourcify or Blockscout.


## Contract `0xf3c2d0d821ec7343160adeddd5559b745bb12be2`

No verified source on Sourcify or Blockscout.
