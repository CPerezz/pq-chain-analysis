---
id: upstreamcollectivetoken-c5a6349a-signed-shortcut-lost
title: "UpstreamCollectiveToken: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: none
contracts:
- address: "0xc5a6349aedf573ee01c7bdf3d713496b5a45d056"
  family: "fa2a7e01221b6af2ea7ca0e0db289efb"
  copies: 11
  name: "UpstreamCollectiveToken"
  upgradeable: "yes"
  rating: LOW
  value_usd: 25264
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 8
  last_active: 2026-11-13
fix:
  layer: offchain
  who_acts: "holders; any member; owner Safe"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Signed shortcut whose act stays open by a direct call for the same party → LOW. value $25264, txs_90d 8."
---

## Summary

Upstream collective vault token: OZ4 permit, plus the vault's isValidSignature reports a hash as vault-signed when any member's ECDSA signature recovers.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 4 upgradeable permit / the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- isValidSignature: Utils.recoverSigner(...) must be in members (UpstreamCollectiveToken.sol:364-374); approve exists for permit
- addMember/removeMember (UpstreamCollectiveToken.sol:156-170), owner-gated per the contract
- owner() at block 26438999 = 0x68A90b88C092d6601894D8D9beBe6547119d54e9, a Safe with 6 owners, threshold 3

## Impact and exposure

- Value held at block 26,438,999: $25,264 (ETH and 49 priced tokens, over 11 addresses).
- Activity: 8 transactions called it in the 90 days before that block; last on 2026-11-13.

## Remediation

Holders approve directly; the vault signs through any member EOA, and the owner Safe can add members.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
