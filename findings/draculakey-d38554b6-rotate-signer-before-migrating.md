---
id: draculakey-d38554b6-rotate-signer-before-migrating
title: "DraculaKEY: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xd38554b676f8c03dd8a1d3bab3f1eab448e5f3d3"
  family: "3f8f13abb4167099a2ccf68db0c37848"
  name: "DraculaKEY"
  upgradeable: "no"
  rating: LOW
  value_usd: 11008
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner 0xe5293f28149dda06de646fdfc7c38ac1061a181a"
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
  note: "The setter is callable by a live EOA owner: LOW. txs_90d 0."
---

## Summary

DraculaKEY NFT mint checks recover(sig) == signer. Signed mints die if the signer gets code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- DraculaKEY.sol:1645 setSigner(address) onlyOwner; :1673 recover == signer
- owner()=0xe529…181a: EOA, nonce 21 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $11,008 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner calls setSigner with a new EOA key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
