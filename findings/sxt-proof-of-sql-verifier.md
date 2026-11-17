---
id: sxt-proof-of-sql-verifier
title: "Space and Time: a recovered BN254 setup trapdoor lets anyone fulfil zkPay SQL queries routed to PoSQLVerifier with false results; the path has been idle since 2025-08 and releases no funds to the fulfiller"
project: space-and-time
status: confirmed
severity: LOW
patterns: [PQ-7]
primitives: [bn254]
trigger: trusted-setup
impact: unknown
alternative: configurable-verifier
role: core
contracts:
- address: "0x99f5bed89c638d8f67f7c132a18da349ac04ed18"
  implementation: null
  name: PoSQLVerifier
  upgradeable: "no"
  admin: none over verification (immutable; OWNER can only withdraw ETH); each zkPay query names its custom-logic verifier, so requesters choose another
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2025-08-19
  txs_30d: 0
families: []
fix:
  layer: onchain-config
  who_acts: Space and Time deploys a hash-based Proof of SQL verifier; zkPay query requesters (client contracts) name it as `customLogicContractAddress` instead of 0x99f5bed89c638d8f67f7c132a18da349ac04ed18
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/sxt-proof-of-sql-verifier/classification.jsonl
  - evidence/sxt-proof-of-sql-verifier/onchain.json
  - evidence/sxt-proof-of-sql-verifier/activity.json
  - evidence/sxt-proof-of-sql-verifier/source-excerpts.md
  - evidence/sxt-proof-of-sql-verifier/consumer.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

`PoSQLVerifier` (`0x99f5bed8…ed18`) is the zkPay "custom logic" that checks a Space and Time Proof of SQL result
with HyperKZG openings on BN254 (pairing precompile) before ZKPay (`0x27d4d2af…d450`) passes the result to the
requesting client's callback (PQ-7). A quantum attacker who recovers the setup trapdoor could fulfil queries with
false results; what that is worth depends on the client contracts, which were not identified. The fulfiller gains no
payment (the query fee goes to Space and Time's fixed payout address), the verifier holds nothing, and the path has
not been used since 2025-08-19. Rated LOW, step 1 (no activity in 12 months, nothing held).

## Mechanism

- `ZKPay.fulfillQuery(queryHash, queryRequest, queryResult)` (`src/ZKPay.sol` 162–200, permissionless) checks the
  stored query, calls `ICustomLogic(queryRequest.customLogicContractAddress).execute(queryRequest, queryResult)`,
  then `zkPayCallback` on the client with the returned result, and settles the escrowed fee to the custom logic's
  payout address.
- `PoSQLVerifier.execute` (`src/PoSQLVerifier.sol` 396–412) → `verify` (383–393) → `Verifier.__verify` from
  `sxt-proof-of-sql` 0.100.10 (`Verifier.post.sol`, HyperKZG with `ec_pairing_x2`, lines 139–146, 709).
- Pattern PQ-7. Excerpts: [`source-excerpts.md`](../evidence/sxt-proof-of-sql-verifier/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify): `PoSQLVerifier` and `ZKPay` implementation `0x8c81a00f…c48b`, lines above.
- CHECKED (on-chain read at block 26,431,655): `getPayoutAddressAndFee()` = (`0xad45b384…5c75`, 0.5e18); no ETH
  held; ZKPay is a TransparentUpgradeableProxy (admin `0xce1e38a8…faa6`, owned by EOA `0x2b1415f2…2c98`) holding 102
  USDC and 100 SXT of pending query payments ([`consumer.json`](../evidence/sxt-proof-of-sql-verifier/consumer.json)).
- CHECKED (precompile trace): 519 transactions with BN254 calls, blocks 22,485,398–23,176,777 (last 2025-08-19);
  8 sampled are `ZKPay.fulfillQuery` sent by `0x5d067e94…ae80`.
- CHECKED (Xatu, any function): no transactions 2026-10-16 to 2026-11-16
  ([`activity.json`](../evidence/sxt-proof-of-sql-verifier/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x99f5bed8…` PoSQLVerifier | no | 0 | 2025-08-19 | 0 |

- No escrow is released to a fulfiller: ZKPay's 102 USDC of pending payments settle to the verifier's payout
  address whatever the result. The exposure is whatever client contracts do in `zkPayCallback` with the result; the
  clients were not identified, so `impact` is unknown.
- `usd_tx_y1` (USD 256) is the year's query payments.

## Remediation

- Post-quantum replacement: a Proof of SQL verifier with a hash-based commitment scheme (FRI/WHIR instead of
  HyperKZG on BN254).
- Who must act: Space and Time (deploys it); zkPay clients name it as `customLogicContractAddress` in new queries. No
  protocol change needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 1 reach: no activity in 12 months (last 2025-08-19) and nothing held).
- 2026-11-17 review (Review05): LOW kept, step 1: last use 2025-08-19 and the verifier holds nothing. Consumer traced
  to ZKPay `0x27d4d2af…`, whose escrowed fees go to Space and Time's payout address, not the fulfiller; `impact`
  funds-loss -> unknown (client callbacks not identified).
