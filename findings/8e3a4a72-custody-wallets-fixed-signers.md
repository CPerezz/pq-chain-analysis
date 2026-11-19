---
id: 8e3a4a72-custody-wallets-fixed-signers
title: "0x8e3a4a72: custody wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x8e3a4a7208aa489cc0a1c7290070811b07e60c87"
  family: "6e908382fcad6bef9b51edcc38f32eae"
  copies: 83
  upgradeable: "no"
  rating: HIGH
  value_usd: 13172210
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
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
  note: "signers read; all EOAs today; no setter, no upgrade path; locks only when every signer has code"
---

## Summary

Contract `0x8e3a4a7208aa489cc0a1c7290070811b07e60c87`, with 82 more addresses running its code. A custody wallet whose signers are fixed in code; once enough signers take code, the money it holds for others is locked.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, no signature set reaches the threshold and nothing moves; deposits sent afterwards are locked too.

## Evidence

- How it was placed: 83 wallets holding 7,299 ETH in the BitGo pattern: a stored signer other than the caller; no function name that changes signers. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Code (3,647 bytes, no verified source) exposes isSigner, signers(uint256), safeMode, getNextSequenceId: the BitGo WalletSimple pattern (a signer sends, a second signer's ECDSA signature approves). No function changes signers; no proxy slot, no upgrade function.
- State at block 26,438,999: 3 signers, all EOAs today. One signer able to sign is enough while another signer can send, so it locks once all three signers have code.
- The other 82 addresses run the same code.

## Impact and exposure

- Value held at block 26,438,999: $13.2M (ETH and 49 priced tokens, over 83 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The custodian moves funds to wallets it can change and retires these deposit addresses before its signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-custody-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
