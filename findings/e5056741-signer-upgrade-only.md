---
id: e5056741-signer-upgrade-only
title: "0xe5056741: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xe505674159f0c7eba7cb41da8c7921156a2fca1a"
  family: "56c7b81b2b7711a5a906c276269cf2fa"
  copies: 2
  upgradeable: "yes"
  admin: "the wallet owner 0x39CF881a… itself, via a signed execTransaction with operation=1"
  rating: LOW
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "the wallet owner 0x39CF881a… (7702-delegated EOA, nonce 12)"
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
  note: "Not upgrade-only: a signed delegatecall by the live owner rotates the key: LOW."
---

## Summary

Same Safe-lite single-owner wallet as 0xdd250bc0 (same function set and layout), run by proxy 0x148ef17d…. execTransaction allows DELEGATECALL, so the owner can sign a rotation or an upgrade before migrating.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: the signer is one key kept in storage; no function replaces it, the code itself can be replaced (proxy). Rule: stored-key (by upgrade).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Disassembly: operation==1 to DELEGATECALL at pc 0x3ab, else CALL at 0x40f; all 3 STATICCALLs target 0x01; no ERC-1271
- Proxy 0x148ef17d… state: slot_0 = 0xe5056741, slot_1 = owner 0x39cf881a…, getThreshold() = 1, balance 0
- Owner 0x39CF881a5B10519554F35fC2dA6f58D402c4871f: 7702 delegation, nonce 12 (proxyprobe); a delegation indicator does not block recovery under EIP-8151

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner signs a delegatecall execTransaction that sets a new owner or implementation before the key gets real code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
