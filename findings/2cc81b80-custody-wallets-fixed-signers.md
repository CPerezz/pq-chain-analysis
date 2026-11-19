---
id: 2cc81b80-custody-wallets-fixed-signers
title: "0x2cc81b80: custody wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x2cc81b80a293408a89084c77a0983de0730f731a"
  family: "daae40664b3ee8373c01a402cdc2362c"
  copies: 31
  upgradeable: "no"
  rating: HIGH
  value_usd: 47981982
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 14
  last_active: 2026-11-18
fix:
  layer: new-deployment
  who_acts: "the custodian moves funds to wallets it can change before its signers take code"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-custody-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "signers and senders read; all EOAs today; no setter, no upgrade path"
---

## Summary

Contract `0x2cc81b80a293408a89084c77a0983de0730f731a`, with 30 more addresses running its code. A custody wallet whose signers are fixed in code; once enough signers take code, the money it holds for others is locked.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, no signature set reaches the threshold and nothing moves; deposits sent afterwards are locked too.

## Evidence

- How it was placed: 31 wallets holding 26,589 ETH: signers in storage (isSigner, signers), a loop of recoveries; no function name that changes them. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Code (4,635 bytes, no verified source) exposes isSigner, signers(uint256), isSender, senders(uint256), safeMode, getNextSequenceId: a BitGo-style wallet with a separate list of senders. No function changes signers or senders; no proxy slot, no upgrade function.
- State at block 26,438,999: 5 signers, all EOAs today; the senders are the same accounts. Every transfer needs an ECDSA signature by a signer, so once the signers' accounts have code nothing moves.
- The other 30 addresses run the same code.

## Impact and exposure

- Value held at block 26,438,999: $48.0M (ETH and 49 priced tokens, over 31 addresses).
- Activity: 14 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

The custodian moves funds to wallets it can change and retires these deposit addresses before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-custody-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
