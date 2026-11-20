---
id: 08278e7d-signer-upgrade-only
title: "0x08278e7d: signer replaceable only by an upgrade"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x08278e7d05589bc52417c0340c12dcd0e54b200a"
  family: "c226d9b462b2dcb775fc3169aa112638"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 5
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
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
  rating: MEDIUM
  note: "No update path for the signer, but only the operator's own trading funds; signed-order function dies while operator call paths (delegate, transfer, withdraw) still move the money: MEDIUM."
---

## Summary

Same trading-bot family as the template: isValidSignature(0x1626ba7e) accepts only ecrecover == constant 0xad7149152a65e6ec97add7b1b1f917dcafcf9b21; held directly (no proxy slot, no storage), so the key cannot change, but only the operator's own bot funds are involved and the operator moves them by direct call.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: ERC-1271 contract behind a proxy; a signer that is a constant in the code. Same code idiom as template 9f802c7a, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall decompile: 1626ba7e compares ecrecover result with constant 0xad7149152a65e6ec97add7b1b1f917dcafcf9b21; delegate() requires msg.sender == 0xad7149152a65e6ec97add7b1b1f917dcafcf9b21 and delegatecalls arbitrary code (operator can move everything)
- cast at 26438999: EIP-1967 slots zero, slots 0/1 zero, code 5570 bytes, balance 121048 wei
- signer 0xad7149152a65e6ec97add7b1b1f917dcafcf9b21: nonce 16957, EIP-7702 delegated EOA
- value_usd 5, txs_90d 0, last_active null

## Impact and exposure

- Value held at block 26,438,999: $5 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Operator deploys a new bot with a replaceable key or ERC-1271 support and moves funds out via delegate()/transfer paths.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
