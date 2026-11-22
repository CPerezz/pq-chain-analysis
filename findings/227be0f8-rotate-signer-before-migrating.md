---
id: 227be0f8-rotate-signer-before-migrating
title: "0x227be0f8: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x227be0f88ecb7899a0e6e0347888b909d622c8e1"
  family: "1cf869a4143eb214b70dbd724eed7c57"
  copies: 2
  upgradeable: "no"
  rating: LOW
  txs_90d: 98206
  last_active: 2026-10-17
fix:
  layer: onchain-config
  who_acts: "contract owner EOA 0x0bc6e9f2… (calls 0xfffac7ed)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "A setter replaces the signer and its caller, the owner EOA, was live at the block (nonce 192). LOW holds, but the row's Legion/syncLegionAddresses reasoning is wrong."
---

## Summary

An unverified trading/swap bot contract (not a Legion sale) whose signed swap path checks ecrecover against a signer stored in slot 2. If that signer key takes code, the signed path stops working.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: as its template 8e7d5287: Legion sale: the signer must be legionSigner of the sale's address configuration, refreshed from Legion's registry by syncLegionAddresses (seen by name). Template.
- Bytecode at 0x227be0f88ecb7899a0e6e0347888b909d622c8e1: no syncLegionAddresses selector (0x0a636d5b absent). This is not a LegionSale: its functions are disableTrading, updateProtocolFeeWallet, withdrawToken, unlockCallback and swap entry points. The row's template link to 8e7d5287 is wrong.
- Signature check: an internal helper calls ecrecover (STATICCALL to 0x01, pc ~12.2-12.5k) and returns the recovered address. Nothing checks for code and there is no ERC-1271 call. The swap path loads the signer from slot 2 (pc 6621 in the f928 copy).
- Setter 0xfffac7ed (unnamed) writes slot 2 behind require(msg.sender == slot0 owner). The dispatcher and guard were read from bytecode.
- State at block 26438999: slot0 owner 0x0bc6e9f2714ef2f3d586e5167dc282119a0edcd8 is an EOA with nonce 192 (live). Slot2 signer is 0x57ed531a9da5b77c504cfd9b1c76b49e8dd76d05 (EOA, nonce 0). Slot1 fee wallet is 0x7e7df6f6...; all three copies share these slots.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 98,206 transactions called it in the 90 days before that block; last on 2026-10-17.

## Remediation

Owner calls 0xfffac7ed with a new codeless signer before the current signer migrates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
