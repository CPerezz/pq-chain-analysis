---
id: lido-wsteth-permit
title: "Lido wstETH: a quantum attacker who recovers a holder's ECDSA key can sign a permit and take that holder's wstETH, even after the holder migrates; post-quantum accounts cannot use permit"
project: lido
status: confirmed
severity: HIGH
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: sole
role: auxiliary
contracts:
- address: "0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0"
  implementation: null
  name: WstETH
  upgradeable: "no"
  admin: none (not a proxy, no owner)
  value_usd: 8504705274
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 71428
families: []
fix:
  layer: account-migration
  who_acts: nobody can change WstETH 0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0; each holder moves wstETH to a fresh post-quantum account, or Lido DAO deploys a new wrapper that holders migrate to
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/lido-wsteth-permit/classification.jsonl
  - evidence/lido-wsteth-permit/onchain.json
  - evidence/lido-wsteth-permit/activity.json
  - evidence/lido-wsteth-permit/source-excerpts.md
  - evidence/lido-wsteth-permit/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review07 (registry review)
  ref: evidence/lido-wsteth-permit/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: HIGH
related: [lido-steth-permit-code-first, lido-predeposit-bls12-381]
---

## Summary

WstETH's EIP-2612 `permit` accepts only an `ecrecover` signature from the holder (PQ-1). A quantum attacker who
recovers a holder's secp256k1 key from its public key can sign a permit for any spender and pull that holder's
wstETH, and this keeps working after the holder moves the same address to post-quantum authorisation; a
post-quantum account cannot use `permit` at all. The contract is immutable. Exposed: holders' balances, at most the
wstETH market cap of $8.50B (2026-11-17). Rated HIGH (step 4): users' own funds stay forgeable in a contract that
cannot change; only every holder moving or a protocol change such as EIP-8151 protects them.

## Mechanism

`WstETH.permit(owner, spender, value, deadline, v, r, s)` (WstETH.sol line 961, OpenZeppelin 3.4 `ERC20Permit`) hashes
the EIP-712 `Permit` struct, calls `ECDSA.recover(hash, v, r, s)` (line 978; `ecrecover` at line 750) and requires the
result to equal `owner`, then `_approve(owner, spender, value)`. There is no account-code check and no ERC-1271 call,
so the signature scheme is fixed to secp256k1 for every holder, contract or not. The spender then moves the tokens
with `transferFrom`. Pattern PQ-1. Excerpt: [`source-excerpts.md`](../evidence/lido-wsteth-permit/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify full match): `permit` → `ECDSA.recover` only, as above.
- CHECKED (`cast` at block 26,431,455): EIP-1967 implementation slot is zero; `onchain.json` (block 26,431,214) shows
  no proxy, no admin, no owner. The contract cannot be upgraded or reconfigured.
- CHECKED (`cast` at block 26,431,455 and Blockscout token data, 2026-11-17): `totalSupply()` 3,754,770.46 wstETH
  × $2,265.04 = $8.50B ([`notes.md`](../evidence/lido-wsteth-permit/notes.md)).
- CHECKED (precompile trace to March 2026; `data/report/curated_contracts.csv`): 32,688 transactions with `ecrecover`
  in the last year, $17.2B transacted in them (a flow, not an exposure).
- CHECKED (Xatu, any function): 71,428 transactions called WstETH in 2026-10-16 to 2026-11-16; last 2026-11-16
  ([`activity.json`](../evidence/lido-wsteth-permit/activity.json)).
- INFERRED: the attacker needs the holder's public key, i.e. a holder address that has signed at least one
  transaction or message; never-used addresses are not recoverable.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x7f39c581…` WstETH | no | $8.50B (market cap, upper bound) | 2026-11-16 | 71,428 |

The exposure is the holders' wstETH, bounded by the market cap; the contract's own 4.69M stETH backing is not taken
through `permit` (only holders' balances are). wstETH bridged to L2s is out of scope. Only mainnet WstETH carries this
check; stETH's `permit` is a separate finding (`lido-steth-permit-code-first`).

## Remediation

- WstETH cannot change. Holders whose addresses have exposed public keys protect themselves by moving wstETH to a
  fresh post-quantum account (smart account or EIP-8141 account) that has never signed with ECDSA.
- Post-quantum accounts can still use wstETH through on-chain `approve`, or through Permit2 (which checks account
  code first), instead of `permit`.
- Lido DAO could deploy a new wrapper whose `permit` checks account code first and passes the full signature to
  ERC-1271; holders would migrate to it.
- Protocol change: helps. EIP-8151 (make `ecrecover` fail for addresses with real code) would protect holders who
  migrate in place.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review07): HIGH unchanged (step 4). Source and immutability re-checked; market cap corrected from
  a stale $10.70B to $8.50B (supply × price on 2026-11-17); related Lido findings linked.
