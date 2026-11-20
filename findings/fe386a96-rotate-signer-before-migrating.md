---
id: fe386a96-rotate-signer-before-migrating
title: "0xfe386a96: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfe386a9645f7d50c78bb0a8d609de3afae4f75d4"
  family: "988311af0f002a24d3554a2a7cee06e1"
  upgradeable: "no"
  rating: LOW
  value_usd: 12
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner (EOA)"
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
  note: "Setter exists, owner is a live EOA."
---

## Summary

NFT lending contract: ecrecover must equal admin() (slot 1, "Bad call"); under EIP-8151 the signed path fails if the stored signer gets code, until the owner replaces it.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (registeredOperators, setOperator). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- setAdmin(address) 0x704b6c02 (require msg.sender == owner, "Not Owner") is onlyOwner (heimdall decompile)
- owner() at 26438999 = 0x9b7b05F27419A8ADD8094B68038179a3218eF598, no code, nonce 569 (node)
- Row note names setOperator/registeredOperators; decompile shows the compared key is admin(), set by setAdmin

## Impact and exposure

- Value held at block 26,438,999: $12 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner calls the setter to replace the signer with an EOA key before the current signer account takes code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
