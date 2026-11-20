---
id: splsplgatewayv3-49f743c2-rotate-signer-before-migrating
title: "SPLSPLGatewayV3: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x49f743c2d3ba45fadf2768ba30844d0ecd548bc6"
  family: "2abb07726de3d8f83951e175fe281e4a"
  copies: 2
  name: "SPLSPLGatewayV3"
  upgradeable: "no"
  rating: LOW
  value_usd: 13715
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "owner EOA 0x0df49ec6f01db7f287df8312d2fd05fe1f0a6c2e"
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
  note: "LOW: setter callable by a live EOA owner."
---

## Summary

SPLSPLGatewayV3: buy needs ECDSA.recover == validater. If the validater takes code, buys revert.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers / returns the recovered address, or compares it with an address its caller passes in. Read from source.
- SPLSPLGatewayV3.sol:282-285: validateSig requires signer == validater
- SPLSPLGatewayV3.sol:102: setValidater is onlyOwner (OZ Ownable)
- owner 0x0df49e… is an EOA with nonce 30 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $13,715 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner calls setValidater with a new key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
