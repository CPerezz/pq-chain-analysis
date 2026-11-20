---
id: eip-8151-wallets-fixed-signers
title: "Wallets whose signers are fixed in code lock once enough of their signers take code under EIP-8151"
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- {address: "0x8a8e80e0762243f0df39f2847808b7f6d62e2bb1", family: "e76ed8e9ea3a1aed36c1cd4946a7254b", copies: 9, label: "Layer2Finance: Committee", upgradeable: "no", rating: HIGH, note: "SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own. Update path: no proxy slot, no upgrade function."}
- {address: "0x8dfbb7ee1979aa58ec0e56c9ea5f08b826f5e6df", family: "37e42129561d6cd35177098ba16cb09e", upgradeable: "no", rating: HIGH, note: "SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own. Update path: no proxy slot, no upgrade function."}
evidence: {level: executed, block: 26438999}
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, fixed key: owners' wallet"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
related: [bitgo-walletsimple-ecdsa-signers]
reviews: []
---

## Summary

These wallets and multisigs check their owners' signatures against a set fixed in their code. 2 code families, 10 addresses, $0 held, 0 recoveries in the study's two-week window. Rows by rating: HIGH 2. 0 rows were checked on a real transaction; the others were read from source, judged from bytecode or placed by measured rules (each row's note says which).

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- Each row's note says how it was decided: read from verified source, judged from bytecode and function names, placed by a rule measured against hand readings, or executed: a real transaction replayed on the fork's reference implementation with only the precompile changed, state at block 26,438,999.

## Impact and exposure

No row holds value at block 26,438,999.

Every row is in the header; `generated/triage_contracts.csv` lists them for search.

## Remediation

Each owner group moves its funds before its signers migrate.

## History

- 2026-11-19: filed from study `eip-8151-impact`, one entry per root issue (D-022). The per-project entries filed earlier that day are in git history (commit `d9c90af`).
- 2026-11-19: 14 rows added with --add from `verdicts.csv`.
- 2026-11-19: 1 row added with --add from `verdicts.csv`.
- 2026-11-19: rows rated by how hard the fix is, one row per family and update path (D-024).
