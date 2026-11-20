---
id: rewardnew-65011d73-rotate-signer-before-migrating
title: "RewardNew: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x65011d7322dd36dd3c2c38fccaf7503406a740ba"
  family: "9396b71fdeb8fd648f1be1fda664031c"
  copies: 2
  name: "RewardNew"
  upgradeable: "yes"
  rating: LOW
  value_usd: 21835
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner"
evidence:
  level: source-read
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
  note: "There is a setter and a live EOA owner. The proxy is upgradeable as well."
---

## Summary

RewardNew (proxy) checks claim signatures against a stored verifier with OZ ECDSA.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- RewardNew.sol:44 setVerifier onlyOwner; :120 ECDSA.recover compared to verifier
- owner 0xb36b…3c is an EOA, nonce 51; verifier 0x0b20…bb is an EOA, nonce 0 (signs off-chain)

## Impact and exposure

- Value held at block 26,438,999: $21,835 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls setVerifier.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
