---
id: debridge-oracle-signers
title: "deBridge: forging 8 of 12 oracle ECDSA keys lets a quantum attacker release tokens from DeBridgeGate and unlock DLN order funds on Ethereum"
project: debridge
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x949b3b3c098348b879c9e4f15cecc8046d9c8a8c"
  implementation: "0xfe7de3c1e1bd252c67667b56347cabfc6df08df4"
  name: SignatureVerifier
  upgradeable: "yes"
  admin: ProxyAdmin 0xe4427af3555cd9303d728c491364fadfdd7494fe, owner Safe 0x6bec1faf33183e1bc316984202ecc09d46ac92d5 (5 of 8); the same Safe holds DEFAULT_ADMIN_ROLE (oracle set, thresholds)
  value_usd: 2711686
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 1383
families: []
fix:
  layer: contract-upgrade
  who_acts: "deBridge admin Safe 0x6bec1faf33183e1bc316984202ecc09d46ac92d5 (5 of 8): owner of ProxyAdmin 0xe4427af3555cd9303d728c491364fadfdd7494fe and DEFAULT_ADMIN_ROLE on SignatureVerifier and DeBridgeGate; the 12 oracle operators must run post-quantum keys"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/debridge-oracle-signers/classification.jsonl
  - evidence/debridge-oracle-signers/onchain.json
  - evidence/debridge-oracle-signers/activity.json
  - evidence/debridge-oracle-signers/source-excerpts.md
  - evidence/debridge-oracle-signers/escrow.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review06 (Claude), 2026-11-17 review
  ref: Sourcify source of 0xfe7de3c1…; cast reads at block 26,431,607; Blockscout holdings
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

deBridge's Ethereum `SignatureVerifier` accepts a cross-chain submission when at least 8 of its 12 registered oracle
addresses have signed it with ECDSA. A quantum attacker who derives 8 oracle keys from their public keys can approve
any submission: claim tokens locked in `DeBridgeGate`, mint deAssets, and deliver forged DLN messages that unlock the
order funds held by `DlnSource`. Measured escrow on Ethereum: USD 2.71M (DeBridgeGate USD 1.03M, DlnSource USD 1.68M,
2026-11-17). Rated MEDIUM: step 4: one 5-of-8 admin Safe can upgrade the verifier to a post-quantum scheme.

## Mechanism

- `DeBridgeGate.claim` (and the DLN path through it) calls `SignatureVerifier.submit(_submissionId, _signatures,
  _excessConfirmations)` (`onlyDeBridgeGate`). `submit` splits the signatures into 65-byte chunks, runs
  `ecrecover(_submissionId.getUnsignedMsg(), v, r, s)` on each (`SignatureVerifier.sol` lines 71-79), counts the ones
  with `getOracleInfo[oracle].isValid`, and reverts unless the count reaches `max(minConfirmations,
  _excessConfirmations)` and every `required` oracle signed. `isValidSignature` (lines 136-144) is the same
  single-signature check.
- On-chain configuration (block 26,431,607): 12 `oracleAddresses`, `minConfirmations` = 8, `requiredOraclesCount` =
  0, so 8 forged oracle keys suffice.
- What an approved submission releases on Ethereum: tokens locked in `DeBridgeGate` 0x43de2d77… for assets native to
  Ethereum; newly minted deAssets for assets native elsewhere; and, through `CallProxy` 0x8a0c79f5…, calls to
  `DlnSource.claimUnlock` / `claimCancel` (`DlnSource.sol` lines 456, 505; sender checked with
  `callProxy.submissionNativeSender()` at line 791), which pay out the give-side funds of open DLN orders.
- Pattern PQ-5: a fixed m-of-n set of secp256k1 keys attests cross-chain facts; key rotation alone does not help.

## Evidence

- CHECKED (verified source on Sourcify, implementation 0xfe7de3c1…, `SignatureVerifier` 2.0.1 / `OraclesManager`): the
  check above.
- CHECKED (cast, block 26,431,607): `DeBridgeGate.signatureVerifier()` = 0x949b3b3c…; `debridgeAddress()` = the gate;
  `DlnSource.deBridgeGate()` and `DlnDestination.deBridgeGate()` = the gate; oracle list and thresholds as above; Safe
  0x6bec1faf… has `DEFAULT_ADMIN_ROLE` on SignatureVerifier and DeBridgeGate and owns the ProxyAdmins of
  SignatureVerifier (0xe4427af3…) and DlnSource (0xa7b88a74…) ([`escrow.json`](../evidence/debridge-oracle-signers/escrow.json)).
- CHECKED (on-chain read at block 26,431,214): implementation, ProxyAdmin, Safe 0x6bec1faf… threshold 5 of 8
  ([`onchain.json`](../evidence/debridge-oracle-signers/onchain.json)).
- CHECKED (Blockscout, 2026-11-17): DeBridgeGate holds 1.33 ETH and 289 tokens worth USD 1,033,966 in total; DlnSource
  26.58 ETH and tokens, USD 1,677,720 in total (largest: uniBTC USD 1.17M, USDC USD 0.46M); DlnDestination USD 14.
- CHECKED (Xatu, any function): 1,383 transactions in 2026-10-16 to 2026-11-16, last on 2026-11-15
  ([`activity.json`](../evidence/debridge-oracle-signers/activity.json)); `curated_contracts.csv`: 58,996 ecrecover
  calls in the last year.
- INFERRED: deAssets minted by a forged submission are not counted in the escrow; their damage depends on market
  liquidity and is not measured.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x949b3b3c…` SignatureVerifier | yes (ProxyAdmin, Safe 5/8) | $0 itself; escrow $2.71M | 2026-11-15 | 1,383 |

Escrow (Blockscout, 2026-11-17, ETH at USD 1,811.62):

| Escrow | Address | Value |
|---|---|---|
| DeBridgeGate (locked tokens) | `0x43de2d77bf8027e25dbd179b491e8d64f38398aa` | $1,033,966 |
| DlnSource (open DLN orders) | `0xef4fb24ad0916217251f553c0596f8edc630eb66` | $1,677,720 |
| Total on the verifier entry | | $2,711,686 |

- The draft listed a family of 63 contracts with code key `0x1995bb51…`. That family groups contracts by the generic
  OpenZeppelin `TransparentUpgradeableProxy` runtime code (it also contains Symbiosis 0x55239859…); it says nothing
  about deBridge and was removed.
- deBridge's verifiers on other chains are outside this registry (Ethereum mainnet only).

## Remediation

- Replace ECDSA oracle signatures with a post-quantum scheme (ML-DSA or hash-based signatures per oracle, or one
  STARK proof aggregating the oracle approvals) by upgrading `SignatureVerifier`; the gate does not need to change if
  the `submit` interface is kept.
- Who acts: Safe 0x6bec1faf… (5 of 8) upgrades through ProxyAdmin 0xe4427af3… and manages the oracle set; the 12
  oracle operators must generate and register post-quantum keys. The Safe's owners are themselves ECDSA keys (PQ-12)
  and must move to post-quantum signers first.
- No Ethereum protocol change is needed or would help (EIP-8151 does not cover oracle EOAs signing off-chain).
- Users: avoid leaving DLN orders open; nothing else is in their hands.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review06): MEDIUM confirmed (step 4: upgrade by one 5-of-8 Safe; escrow USD 2.71M in DeBridgeGate and DlnSource). Spurious proxy-bytecode family removed.
