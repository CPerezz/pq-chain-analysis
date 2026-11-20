---
id: 6630f778-wallets-fixed-signers
title: "0x6630f778: wallet with signers fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x6630f77801e3d8ee4c624a628d0979ab9e7d111b"
  family: "4fbb2aa85b5ebbaf77fd1f34b59c529c"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "anyone (unguarded init)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "Key is settable (by anyone) -> refuted per scale. Flag: unguarded re-initialisation is a pre-existing takeover bug, not an EIP-8151 issue."
---

## Summary

Verified WalletSimple (solc 0.4.25, initialized via init() in 2019) whose init(address[]) has no initialized guard: anyone can overwrite the 3 signers, so the signer set is settable, not fixed.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: BitGo WalletSimple (2017): the second signer must be one of the wallet's signers, fixed at creation, and not the caller, who must be a signer too / BitGo WalletSimple (2017):…. Same code idiom as template 55e4db93, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- debug_traceCall at block 26438999: init([0x1,0x2,0x3]) from 0x...dEaD succeeds and writes signers slots keccak(0)+0..2 (prestate diff).
- heimdall: init (0xc6044c46) only requires length==3 then stores signers; Etherscan shows Init tx 0xcb242ed1... block 8045184 from 0xa107483c...
- Signers at 26438999: 0x9e38C6ad...FfdE (EOA), 0x024eb380...c9c9 (EOA), 0xA0167bF3...61B2 = contract that always reverts (60806040525f80fd).
- Balance 0 ETH at 26438999; row txs_90d=0, last_active=null.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed for EIP-8151 (signers re-settable via init); separately, the wallet is takeover-able by anyone and should hold nothing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
