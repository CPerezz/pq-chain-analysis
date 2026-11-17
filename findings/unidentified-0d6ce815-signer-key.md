---
id: unidentified-0d6ce815-signer-key
title: "Unidentified trading-bot operator (deployer 0x3bf77324): a quantum attacker who recovers the bot's ECDSA verifier key can make its treasury contracts swap their funds ($28k in USD1) on the attacker's terms"
project: unidentified-0d6ce815
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x0d6ce8158640cc02f405dee694d8aeda56ed3271"
  implementation: null
  name: unverified signed-swap treasury (verifier()/setVerifier/swapEnabled)
  upgradeable: config-only
  admin: "owner 0x3bf77324ec75c24107077d90275ddaa14efc866f (EOA, also the deployer) can setVerifier; verifier 0x091eee8044a02ea2c5ce64ce1501d5e2fb7970cd (read at block 26431457)"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-03-29
  txs_30d: 0
- address: "0xff68a48e8f7b9cfcf2fb5f418ec9bbfc2203dff7"
  implementation: null
  name: unverified signed-swap treasury (verifier()/setVerifier/swapEnabled)
  upgradeable: config-only
  admin: "owner 0x3bf77324ec75c24107077d90275ddaa14efc866f (EOA, also the deployer) can setVerifier; verifier 0xf606400ae814677c9685be3d60bba070374c8cec (read at block 26431457)"
  value_usd: 28147
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-12
  txs_30d: 527
- address: "0x951a1ca3ad7ad2e055226783d32c9e8a69188485"
  implementation: null
  name: unverified signed-swap treasury (same runtime code as 0xff68a48e)
  upgradeable: config-only
  admin: "owner 0x3bf77324ec75c24107077d90275ddaa14efc866f (EOA, also the deployer) can setVerifier; verifier 0xf1d96dc924eccfef9967a6b90dd6f5cc40ab6663 (read at block 26431457)"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-08-17
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "the unidentified operator, owner EOA 0x3bf77324ec75c24107077d90275ddaa14efc866f: redeploy with a post-quantum verifier or withdraw the funds"
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/unidentified-0d6ce815-signer-key/classification.jsonl
  - evidence/unidentified-0d6ce815-signer-key/onchain.json
  - evidence/unidentified-0d6ce815-signer-key/activity.json
  - evidence/unidentified-0d6ce815-signer-key/source-excerpts.md
  - evidence/unidentified-0d6ce815-signer-key/review-reads.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review09 (finding review)
  ref: evidence/unidentified-0d6ce815-signer-key/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Three unverified contracts deployed and owned by EOA `0x3bf77324…` hold tokens and swap them on Uniswap when anyone
submits swap parameters signed by the contract's `verifier()` key (one ECDSA key, PQ-4); many single-use EOAs submit
these, and the owner periodically withdraws. A quantum attacker who recovers a verifier key can order swaps of the
contract's funds on the attacker's terms (at minimum with unbounded slippage into a pool the attacker manipulates). Only
`0xff68a48e…` holds anything priced: $28.1k of USD1. Rated LOW: the owner would have to redeploy (MEDIUM, step 4),
lowered by step 5 (under $50k measured). The operator was not identified.

## Mechanism

- Entry `0xa28c0efa(router, amountOut, amountInMax, path[], to, deadline, bytes signature)`: the contract first calls
  `ecrecover` (precompile `0x01`) on a digest of the parameters and compares the result with `verifier()`, then calls
  `UniswapV2Router02.swapTokensForExactTokens` spending its own token balance (CHECKED by trace). The other user entry,
  `0xfb3a6007`, is called the same way by single-use EOAs (not traced).
- `setVerifier(address)` (owner) rotates the key; it cannot change the scheme. The classifier found no ERC-1271
  selector in the bytecode.
- Owner functions seen on-chain: `setWithdrawEnabled`, `setWithdrawRecipient`, `0x0c9708cb` (INFERRED: withdrawal), all from
  `0x3bf77324…`.

Pattern PQ-4. The source is not verified; [`source-excerpts.md`](../evidence/unidentified-0d6ce815-signer-key/source-excerpts.md)
has no excerpt.

## Evidence

- CHECKED (trace of tx `0xaf66f0c1…`, 2026-11-12, `debug_traceTransaction` callTracer): `0xff68a48e…` recovers
  `0xf606400a…` (= its `verifier()`), reads its own USD1 balance and allowance, and swaps USD1 for token `0x203240c1…`
  through UniswapV2Router02 with `to` = itself
  ([`review-reads.json`](../evidence/unidentified-0d6ce815-signer-key/review-reads.json)).
- CHECKED (on-chain at block 26,431,457): `owner()` = `0x3bf77324…` for all three; `verifier()` values above
  (`0xf606400a…` and `0x091eee80…` have no code; `0xf1d96dc9…` not checked);
  `swapEnabled()` and `withdrawEnabled()` true on `0x0d6ce815…` and `0xff68a48e…`; `0x951a1ca3…` has byte-identical
  runtime code to `0xff68a48e…`.
- CHECKED (Blockscout, 2026-11-17): all three created by `0x3bf77324…` (no tag, no ENS); holdings 28,184.77 USD1
  (`0xff68a48e…`), dust or unpriced tokens elsewhere.
- CHECKED (precompile trace to March 2026): 37,092 (`0x0d6ce815…`) and 28,546 (`0xff68a48e…`) pre-quantum calls in the
  year (`data/report/curated_contracts.csv`, `txs_y1`); `0x951a1ca3…` was not in the census.
- CHECKED (Xatu, 2026-10-16 to 2026-11-16; Blockscout direct transactions for `0x951a1ca3…`): activity in the table.
- INFERRED: whether the signed payload fixes `to` to the contract itself; if it does not, a forged signature sends the
  output straight to the attacker.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x0d6ce815…` signed-swap treasury | config-only | $0 | 2026-03-29 | 0 |
| `0xff68a48e…` signed-swap treasury | config-only | $28k (USD1) | 2026-11-12 | 527 |
| `0x951a1ca3…` signed-swap treasury | config-only | $0 | 2026-08-17 | 0 |

The exposure is the contracts' own balances, which the operator tops up and withdraws; $28.1k on 2026-11-17.
Identification attempted: the deployer EOA has no label, and its recent transactions (2026-03 to 2026-08) only
administer these contracts; the code is unverified on Sourcify and Blockscout; callers are throwaway EOAs.

## Remediation

- Operator (owner `0x3bf77324…`): redeploy with a post-quantum verifier (ERC-7913 verifier for an ML-DSA or
  hash-based key), or keep balances near zero. `setVerifier` alone does not help.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review09): MEDIUM -> LOW, step 5: measured exposure $28.1k (USD1 held by 0xff68a48e…), under $50k. Mechanism confirmed by trace (ecrecover against `verifier()` before swapping the contract's own funds); status candidate -> confirmed (bytecode plus trace); third contract 0x951a1ca3… (same owner, identical code, not in the census) added; operator still unidentified, "memecoin" dropped from the title as unestablished.
