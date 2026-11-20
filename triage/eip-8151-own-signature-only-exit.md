---
id: eip-8151-own-signature-only-exit
title: "Funds or rights released only by the party's own ECDSA signature lock once that party has code under EIP-8151"
status: candidate
severity: LOW
patterns: [PQ-16]
impact: funds-locked
contracts:
- {address: "0xb40078c3871dcf6757e92f5369019fa20bf2bc15", family: "777e08a9ce4ae5874141449c0abf0ade", name: "SAClientERC20", upgradeable: "yes", rating: LOW, value_usd: 258, value_basis: "held", value_as_of: 2026-11-18, note: "SAClientERC20: tokens credited to a key address (saDest) move only by a relayed request signed by that key; no direct call. Read. Update path: proxy to 0x3ea5eaaa2727a38f2a16151e8b85017f966e4656, admin 0x0e46e654dc33f86bd9ee9b103a1bd3afdcc8d7de."}
- {address: "0xccad95719d3e26caf3b87dc73ea4a140a67c9510", family: "d54dd91dc42dc30c395222a07c676a7a", copies: 32, name: "MerchantConsolidator", upgradeable: "yes", rating: LOW, value_usd: 1, value_basis: "held", value_as_of: 2026-11-18, note: "the stored registrar signs every assignment; a change of the authorised recipient also needs a 65-byte ECDSA signature of the merchant (read): a merchant whose address has code cannot give it. Read by hand. Executed: a real transaction reverts with code at the signer. Update path: 7702 account: re-delegates."}
evidence: {level: executed, block: 26438999}
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, own funds only by one's own signature"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: [localcoinswap-relayer-signer]
reviews: []
---

## Summary

These contracts let a party act on its own funds or rights only with an ECDSA signature of its own address: no direct call, no ERC-1271. 2 code families, 33 addresses, $259 held, 0 recoveries in the study's two-week window. Rows by rating: LOW 2. 1 rows were checked on a real transaction; the others were read from source, judged from bytecode or placed by measured rules (each row's note says which).

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- Each row's note says how it was decided: read from verified source, judged from bytecode and function names, placed by a rule measured against hand readings, or executed: a real transaction replayed on the fork's reference implementation with only the precompile changed, state at block 26,438,999.
- ETHEscrowV2 `0x3a362a1966ff5aab35298e1565bda2c9fb124e41` and ERC20EscrowV2 `0xccb2718d633ed28bdf0639134380e2f5b05162b5`: `resolveDispute` requires `signer == buyer || signer == seller`. Executed: resolutions `0x34e6fa77b3850be07f6a71491781750c6a792c81c1ef5a51e29e02a91aa1b117` (ETH) and `0x47b43aced505820e8d2224d965b3bdf2c6c8b079b64f7ff0ef7228f210482ea0` (USDT) revert with code at the signing party; the escrow then waits 180 days for the operator's sweep.

## Impact and exposure

Largest rows by value held at block 26,438,999:
- `0xb40078c3871dcf6757e92f5369019fa20bf2bc15` (SAClientERC20): $258, LOW
- `0xccad95719d3e26caf3b87dc73ea4a140a67c9510` (MerchantConsolidator): $1, LOW, 32 addresses

Every row is in the header; `generated/triage_contracts.csv` lists them for search.

## Remediation

Act before migrating the address; new deployments accept ERC-1271 or a direct call.

## History

- 2026-11-19: filed from study `eip-8151-impact`, one entry per root issue (D-022). The per-project entries filed earlier that day are in git history (commit `d9c90af`).
- Full write-ups of the executed rows before the merge: [unidentified-3a362a19-escrow-dispute-party-code](https://github.com/kevaundray/pq-chain-analysis/blob/d9c90afac8137e134d5e884865dfc37bbcb0d397/triage/unidentified-3a362a19-escrow-dispute-party-code.md).
- 2026-11-19: 5 rows added with --add from `verdicts.csv`.
- 2026-11-19: 2 rows added with --add from `verdicts.csv`.
- 2026-11-19: rows rated by how hard the fix is, one row per family and update path (D-024).
