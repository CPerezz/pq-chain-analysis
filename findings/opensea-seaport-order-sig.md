---
id: opensea-seaport-order-sig
title: "OpenSea Seaport 1.6 and 1.5: a quantum attacker who recovers a user's old ECDSA key can sign Seaport orders that sell the user's approved NFTs and tokens, even after the user moves to a post-quantum smart account at the same address"
project: opensea
status: confirmed
severity: HIGH
patterns: [PQ-2]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x0000000000000068f116a894984e2db1123eb395"
  implementation: null
  name: Seaport
  upgradeable: "no"
  admin: none (no proxy, no owner; EIP-1967 implementation slot empty at block 26,431,457)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 192074
- address: "0x00000000000000adc04c56bf30ac9d3c0aaf14dc"
  implementation: null
  name: Seaport
  upgradeable: "no"
  admin: none (no proxy, no owner)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-13
  txs_30d: null
families: []
fix:
  layer: account-migration
  who_acts: "users: revoke approvals given to Seaport 1.6/1.5 directly and move assets to a fresh post-quantum account; OpenSea (ConduitCaptain 0x0000000000d132a69d773c838080dc4fa478388f, owned by 5-of-7 Safe 0xc669b5f25f03be2ac0323037cb57f49eb543657a) can close the Seaport channels on the OpenSea conduit after deploying a Seaport that checks account code first; the contracts themselves cannot change"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/opensea-seaport-order-sig
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review13 (re-read verified source on Sourcify; on-chain reads of the OpenSea conduit)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/opensea-seaport-order-sig/conduit.json
  date: 2026-11-17
  verdict: confirmed
  rating: HIGH
related: [opensea-zone-and-drop-signers]
---

## Summary

Seaport verifies an order's signature with `ecrecover` first and falls back to ERC-1271 only when the recovered address
does not match the offerer (PQ-2). A user who moves to a post-quantum smart account at the same address (EIP-7702 or
an EIP-8141 account) therefore stays forgeable here: a quantum attacker who recovers the old secp256k1 key signs an
order that sells the user's NFTs and tokens at any price, pulled through the approvals the user gave to Seaport or to
the OpenSea conduit. The exposure is what users have approved to Seaport 1.6, Seaport 1.5 and the conduits that serve
them; it is not measured (Seaport itself holds nothing). Rated HIGH (step 4): both Seaport versions are immutable with
no owner, and for approvals given to Seaport directly only every user revoking or moving, or a protocol change such as
EIP-8151, protects them.

## Mechanism

- `Verifiers._verifySignature(offerer, orderHash, signature)` (`src/lib/Verifiers.sol` 90-137) returns early only if
  the offerer is the caller; otherwise it derives the EIP-712 digest (or the bulk-order digest) and calls
  `_assertValidSignature`. It is reached from `OrderValidator._validateBasicOrder` (line 117), `_validateOrder`
  (line 271) and `_validate` (line 857) whenever the order was not pre-validated on-chain (`orderStatus.isValidated`).
- `SignatureVerification._assertValidSignature` (`src/lib/SignatureVerification.sol` 61-…): if the signature is 64 or
  65 bytes it calls the `ecrecover` precompile (lines 146-155) and sets
  `success := and(eq(signer, recoveredSigner), gt(signer, 0))` (line 177); only `if iszero(success)` does it call
  `isValidSignature` on the offerer (lines 181-233). The account's code is not consulted before `ecrecover`.
- A matching ECDSA signature lets anyone fulfil the order: Seaport transfers the offer items from the offerer, either
  directly (approval to Seaport) or through a conduit named by the order's `conduitKey` (approval to the conduit).
- Seaport 1.5 (`0x00000000000000adc04c56bf30ac9d3c0aaf14dc`) has the same `_assertValidSignature` (same line
  `success := and(eq(signer, recoveredSigner), gt(signer, 0))` followed by the ERC-1271 fallback).
- Pattern PQ-2. Excerpts: [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/opensea-seaport-order-sig/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify, re-read 2026-11-17): `Verifiers._verifySignature` and
  `SignatureVerification._assertValidSignature` for Seaport 1.6, lines as above; the same check in Seaport 1.5's
  verified source (`data/sourcify/0x00000000000000adc04c56bf30ac9d3c0aaf14dc.json`).
- CHECKED (on-chain, block 26,431,214): Seaport 1.6 has no proxy, admin, owner or Safe; holds about USD 0.06
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/opensea-seaport-order-sig/onchain.json)). EIP-1967 implementation slot is zero at
  block 26,431,457.
- CHECKED (on-chain, block 26,431,457): the OpenSea conduit `0x1e0049783f008a0085193e00003d00cd54003c71` is owned in
  the ConduitController by ConduitCaptain `0x0000000000d132a69d773c838080dc4fa478388f`, whose owner is the 5-of-7 Safe
  `0xc669b5f25f03be2ac0323037cb57f49eb543657a` and whose revoker is `0x21b8846849061a470b5177806896616cc1562abc`;
  open channels: Seaport 1.5, TransferHelper `0x0000000000c2d145a2526bd8c716263bfebe1a72`, Seaport 1.6
  ([`conduit.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/opensea-seaport-order-sig/conduit.json)).
- CHECKED (precompile trace, 12 months to March 2026, `data/agg/y1_caller.parquet`): `ecrecover` in 2,002,784
  transactions through Seaport 1.6 (`txs_y1` in `curated_contracts.csv`, with USD 1.51B of transfers in those
  transactions) and 7,735 through Seaport 1.5; Seaport 1.4 and 1.1 had 3 and 8.
- CHECKED (Xatu, any function): Seaport 1.6 called in 192,074 transactions 2026-10-16 to 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/opensea-seaport-order-sig/activity.json)). Seaport 1.5 last direct transaction
  2026-11-13 (Blockscout, block 26,404,850); its 30-day count was not measured.
- INFERRED: approvals to the OpenSea conduit are the main route for OpenSea listings (default `conduitKey`
  `0x0000007b…250f0000`); the share of value approved to Seaport directly or to other marketplaces' conduits is not
  known.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x00000000…68f116a8` Seaport 1.6 | no | — (USD 0.06) | 2026-11-16 | 192,074 |
| `0x00000000…adc04c56` Seaport 1.5 | no | — | 2026-11-13 | not measured |

The funds at risk are users' own NFTs and tokens approved to Seaport or to a conduit with an open Seaport channel
(OpenSea conduit `0x1e0049783f008a0085193e00003d00cd54003c71`, and any third-party conduit). That total is not
measurable from contract balances; `value_usd` is left `null`. Only users who migrate to post-quantum authorisation
at the same address are newly exposed; for an unmigrated EOA the old key already controls everything.

Siblings: Seaport 1.5 is added here (same code path, open channel on the OpenSea conduit, still used). Seaport 1.4
(`0x00000000000001ad428e4906ae43d8f9852d0dd6`) and 1.1 (`0x00000000006c3852cbef3e08e8df289169ede581`) show 3 and 8
`ecrecover` transactions in the year and were not added.

## Remediation

- Post-quantum replacement: a Seaport version that checks the offerer's code first and, if it has code, verifies only
  through ERC-1271 with the full signature (PQ-13 order, as in current OpenZeppelin `SignatureChecker`). Seaport 1.6
  and 1.5 cannot be changed; OpenSea must deploy a new version.
- OpenSea can then cut the old versions off the OpenSea conduit: ConduitCaptain `updateChannel`/`closeChannel` (owner
  Safe `0xc669b5f25f03be2ac0323037cb57f49eb543657a`, 5 of 7, or the revoker) closes the Seaport 1.6 and 1.5 channels,
  which protects everything approved to that conduit. Approvals given to Seaport 1.6/1.5 directly, and other
  marketplaces' conduits, are not covered.
- Users: revoke `setApprovalForAll`/ERC-20 approvals to Seaport 1.6 and 1.5 and move assets to a fresh post-quantum
  account; cancelling or `incrementCounter` does not help, since a forged key signs new orders.
- Protocol change: EIP-8151 (`ecrecover` fails for accounts with real code) would protect migrated accounts without
  OpenSea or the users acting.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review13): HIGH unchanged, step 4: Seaport 1.6 and 1.5 are immutable; OpenSea can close their channels on its own conduit, but approvals to Seaport directly and to other conduits stay forgeable until every user acts or EIP-8151. Added Seaport 1.5 (same check, open channel on the OpenSea conduit); added the conduit admin reads.
