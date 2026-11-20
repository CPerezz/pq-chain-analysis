---
id: 5b93d80d-signer-upgrade-only
title: "0x5b93d80d: signer replaceable only by an upgrade"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5b93d80da1a359340d1f339fb574bdc56763f995"
  family: "9f802c7af84b806513fb9ae69bf0838a"
  copies: 3
  upgradeable: "yes"
  admin: "0xad7149152a65e6ec97add7b1b1f917dcafcf9b21 (via upgradeDelegator on proxy 0xd42b0ecf8a9f8ba9db7b0c989d73cf0bd5f83b66)"
  rating: LOW
  value_usd: 28
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: contract-upgrade
  who_acts: "operator 0xad7149152a65e6ec97add7b1b1f917dcafcf9b21"
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
  note: "Live upgrade path: the proxy in front of this implementation is repointable by its live operator; the batch's 'no admin' missed the non-1967 slot1 admin."
---

## Summary

Implementation of a trading-bot proxy (0xd42b0ecf...) whose isValidSignature(0x1626ba7e) accepts only ecrecover == constant 0xad7149...; the proxy's upgradeDelegator(address) lets that live operator repoint it to new code.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: ERC-1271 contract behind a proxy; a signer that is a constant in the code. Bytecode and names.
- Update path, read at block 26,438,999: proxy to 0x5b93d80da1a359340d1f339fb574bdc56763f995: no admin, no upgrade function in the implementation.
- heimdall decompile of 0x5b93...: 1626ba7e returns magic only if ecrecover(...) == 0xad7149152a65e6ec97add7b1b1f917dcafcf9b21 (constant), no storage, no setter
- proxy 0xd42b0ecf8a9f8ba9db7b0c989d73cf0bd5f83b66 (state.json): slot0 = 0x5b93... (implementation), slot1 = 0xad7149...; decompile: upgradeDelegator(address) requires msg.sender == slot1 and writes slot0
- 0xad7149... nonce 16957 at block 26438999, code 0xef0100... (EIP-7702 delegated EOA, live)
- value_usd 28, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $28 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Operator calls upgradeDelegator on 0xd42b0ecf... with an implementation that accepts a new key or ERC-1271 before 0xad7149... takes real code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
