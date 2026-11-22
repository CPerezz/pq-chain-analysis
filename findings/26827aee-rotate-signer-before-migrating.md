---
id: 26827aee-rotate-signer-before-migrating
title: "0x26827aee: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x26827aeef999482a6366d87b602f8e9c0f1d3bad"
  family: "d614be99d4902441fed0758bc4ac9846"
  copies: 3
  upgradeable: "no"
  rating: LOW
  txs_90d: 1212
  last_active: 2026-09-01
fix:
  layer: none
  who_acts: "token holder (direct approve)"
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
  note: "The row's root (the owner is the signer) is misread. The real issue is a signed shortcut (permit) whose direct path, approve, stays open → LOW. It should be re-rooted to eip-8151-signed-shortcut-lost."
---

## Summary

Plain ERC-20 with an EIP-2612 permit and no other signature function. The recovered signer is the permit's holder, not the contract owner, so EIP-8151 only removes permit for holders whose address has code; approve stays available.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one address in storage and the only such address the code names is its owner, which can be handed over (renounceOwnership). Rule: stored-key (the owner).
- Full selector list: permit(address,address,uint256,uint256,uint8,bytes32,bytes32), nonces, eip712Domain, approve, transfer, transferFrom, owner, renounceOwnership; no signer setter or other signed entry (latest, block ~26452925, publicnode; code only).
- The bytecode contains the EIP-2612 Permit typehash 0x6e71edae…6126c9 (latest, block ~26452925, publicnode; code only).
- owner()=0x0 at 26438999 (reth): the owner plays no part in the signature check.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 1,212 transactions called it in the 90 days before that block; last on 2026-09-01.

## Remediation

Holders whose address has code call approve directly instead of permit.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
