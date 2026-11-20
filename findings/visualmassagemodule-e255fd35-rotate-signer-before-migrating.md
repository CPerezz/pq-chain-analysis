---
id: visualmassagemodule-e255fd35-rotate-signer-before-migrating
title: "VisualMassageModule: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe255fd35cec33a10e46c807423ea318c072de5d2"
  family: "6a628899b3cb310f9b99d02fa7547317"
  name: "VisualMassageModule"
  upgradeable: "no"
  rating: LOW
  value_usd: 49625
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1
  last_active: 2026-09-25
fix:
  layer: onchain-config
  who_acts: "owner 0xe9cbf8c6 (EOA)"
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
  note: "Setter exists and its caller (owner) is a live EOA."
---

## Summary

VisualMassageModule NFT sale: each helix's collect is authorised by a SignedAllowance signature from helix.signer, recovered with ECDSA only. If that signer gets code, signed collects revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- SignedAllowance.sol:86 message.recover(signature)==signer; no ERC-1271 path
- VisualMassageModule.sol:421 setHelixSigner(uint256,address) onlyOwner replaces the signer
- owner() at block 26438999 = 0xe9cbf8c606322e23215b9932d57c3d9115305608, no code, nonce 386

## Impact and exposure

- Value held at block 26,438,999: $49,625 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-25.

## Remediation

Owner calls setHelixSigner with an EOA signer before the old signer takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
