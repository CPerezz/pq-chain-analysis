---
id: unidentified-5cf33bab-signer-key
title: "Tokenlon PMM market maker (UniversalAsset 0xbad9ada0): a quantum attacker who recovers the SIGNER key of its ERC-1271 validator 0x5cf33bab can sign quotes that sell the maker's inventory (about USD 21 now)"
status: candidate
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x5cf33bab94f5daeabf04a7636856c951ed78ac07"
  implementation: null
  name: unverified ERC-1271 signer contract ("s validation version 1.1.0")
  upgradeable: config-only
  admin: admin() 0x143395428158a57d17bcd8899770460656de98e4 (contract, VERSION() "MultiSign v1.0"; signer set not read) can setSigner and manage operators; read at block 26431552
  value_usd: 21
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-08-12
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: the market maker behind UniversalAsset 0xbad9ada0e9633ed27fa183dbdeceef76712a6ee1 (validator admin 0x143395428158a57d17bcd8899770460656de98e4); a new validator that checks a post-quantum quote signature
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-5cf33bab-signer-key
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

`0x5cf33bab…ac07` is an unverified signature validator for a market maker quoting on Tokenlon's PMM (0x-style
orders). When a quote is settled, the exchange calls its `isValidSignature`, which accepts the quote if `ecrecover`
returns the stored `SIGNER()` key `0x6a32cc04…a247` (PQ-4). A quantum attacker who recovers that key can sign
quotes at any price and drain whatever the maker contract, UniversalAsset `0xbad9ada0…6ee1`, holds and has approved:
about USD 21 at 2026-11-17 (it was used actively until March 2026). The admin can only swap in another ECDSA key, so
the fix is a new validator. Rated LOW: MEDIUM by step 4 (new deployment by one operator), lowered one level by step
5 (under USD 50k measured). Status stays candidate: the code is unverified.

## Mechanism

- Bytecode selectors: `isValidSignature(bytes32,bytes)` (`0x1626ba7e`), `SIGNER()`, `setSigner(address)`,
  `admin()`/`transferAdmin`/`claimAdmin`, `addOperator`/`removeOperator`/`getOperators`, `maxGasPrice`/
  `setMaxGasPrice`, `minNonce`, `withdrawToken`, `withdrawEth`, `VERSION()` and an operator function `0xea5cc585`
  that set `minNonce` to a timestamp (cancelling older quotes).
- Every `ecrecover` in the trace is made by this contract inside a settlement: in tx `0x2f4d94c6…d5ff` (block
  24,683,641) Tokenlon's UserProxy `0x03f34be1…9659` runs `toPMM(bytes)`, the PMM `0x8d90113a…13c6` fills through the
  0x-style `Exchange` `0x080bf510…7712`, the maker `0xbad9ada0…` pays 0.429 WETH and receives 1,000 USDT.
- Rotation via `setSigner` keeps ECDSA (`key-rotation-only`); `operatorAllowed`/`maxGasPrice` gate who may submit,
  not the signature scheme [INFERRED from names].
- Pattern PQ-4. No verified source ([`source-excerpts.md`](#source-excerpts-unidentified-5cf33bab-signer-key)).

## Evidence

- CHECKED (bytecode, `cast code` and 4byte lookups, 2026-11-17): the selectors above.
- CHECKED (on-chain reads at block 26,431,552, latest state): `SIGNER()` = `0x6a32cc04…a247`; `admin()` =
  `0x14339542…98e4`, a contract whose `VERSION()` is "MultiSign v1.0" (its signer set and threshold were not read: no
  standard getter); `pendingAdmin()` = 0; `getOperators()` = `0x21430e25…4fb5`, `0xcf60f9c3…8e58`; `minNonce()` =
  1,760,181,512 (2025-10-11) ([`settlement.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-5cf33bab-signer-key/settlement.json)).
- CHECKED (receipts of 8 random trace transactions): all move tokens from or to UniversalAsset `0xbad9ada0…`, entered
  through Tokenlon's UserProxy, the 1inch v5 router and other aggregators.
- CHECKED (Blockscout token balances, 2026-11-17): UniversalAsset (verified, created by `0x504f151d…8ba7`) holds about
  USD 21 of priced tokens (mostly CHKN and Aave aTokens) and no ETH to speak of; the validator holds nothing.
- CHECKED (precompile trace): 25,316 transactions with `ecrecover`, blocks 23,253,174–24,683,641; `usd_tx_y1` USD
  935M is the settled flow over the year, not funds at rest.
- CHECKED (Xatu, any function): no transactions 2026-10-16 to 2026-11-16; last 2026-08-12
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-5cf33bab-signer-key/activity.json)).
- INFERRED: the exchange reaches `isValidSignature` through a validator/wallet signature type registered for the
  maker; the exact signature type was not decoded.

## Impact and exposure

| Contract | Upgradeable | Escrow (maker inventory) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x5cf33bab…` ERC-1271 signer (unverified) | no (signer settable) | USD 21 (2026-11-17) | 2026-08-12 | 0 |

- Escrow: the maker contract UniversalAsset `0xbad9ada0…6ee1`, whose inventory a forged quote sells. It handled
  USD 935M of fills in the year to March 2026 but holds about USD 21 now; if the maker refunds it, the exposure
  returns to its inventory.
- Takers are not exposed: they sign their own orders and receive what the forged quote states.
- Operator: not identified (validator creator EOA `0x781d8a73…9438`, admin MultiSign `0x14339542…98e4`).

## Remediation

- Post-quantum replacement: a validator that verifies quotes with a post-quantum signature (ERC-7913 verifier), or
  quotes approved on-chain; registered for the maker in place of this one.
- Who must act: the market maker (validator admin `0x14339542…98e4`). No protocol change needed.
- Until then the maker can cap the inventory left in `0xbad9ada0…` and its approvals.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review05): MEDIUM -> LOW, step 5: traced the validator to a Tokenlon PMM maker, UniversalAsset
  `0xbad9ada0…`, whose inventory (USD 21 at 2026-11-17) is what a forged quote releases. Admin read as a custom
  "MultiSign v1.0" contract. Status stays candidate (unverified code).
- 2026-11-19: LOW -> MEDIUM, step 5 removed (value no longer lowers a rating); step 4 gives MEDIUM.

# Source excerpts: unidentified-5cf33bab-signer-key

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x5cf33bab94f5daeabf04a7636856c951ed78ac07`

No verified source on Sourcify or Blockscout.
