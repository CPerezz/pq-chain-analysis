---
id: dd250bc0-signer-upgrade-only
title: "0xdd250bc0: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xdd250bc02d055539620986e72568bf43e789d3cf"
  family: "6bdf0ea43e4743fc29150add6fc4ff69"
  copies: 3
  upgradeable: "yes"
  admin: "the wallet owner 0xD33aAEc8… itself, via a signed execTransaction with operation=1"
  rating: LOW
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "the wallet owner 0xD33aAEc8… (EOA, nonce 207)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Not upgrade-only: a signed delegatecall by the live owner rotates the key or the code. LOW like the other rotate-before-migrating wallets."
---

## Summary

Single-owner Safe-lite wallet implementation ('1.3.0-lab'), run by proxy 0x093637e3… (slot-0 delegate). There is no addOwner or upgrade function, but execTransaction supports operation=1 (DELEGATECALL), so a signature from the owner can rewrite the owner or slot 0 before the key gets code.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: proxy to 0xdd250bc02d055539620986e72568bf43e789d3cf: no admin, no upgrade function in the implementation.
- Disassembly: execTransaction branches on operation&0xff == 1 to DELEGATECALL at pc 0x3aa, else CALL; the 3 STATICCALLs go to 0x01 (no ERC-1271); the only CALLER is in setup()
- Proxy 0x093637e3… state: slot_0 = 0xdd250bc0, slot_1 = owner 0xd33aaec8…, getThreshold() = 1, nonce() = 0, balance 0
- Owner 0xD33aAEc801EC5550f6a6227881ED27b36bBA87b4: EOA, nonce 207 (proxyprobe)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Before giving the owner key code, the owner signs an execTransaction delegatecall that sets a new owner or a new implementation.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
