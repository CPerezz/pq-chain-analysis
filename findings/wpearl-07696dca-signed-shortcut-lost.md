---
id: wpearl-07696dca-signed-shortcut-lost
title: "WPearl: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
impact: liveness
contracts:
- address: "0x07696dcab55e62cfef953666b29fe1970518cb00"
  family: "7652d82cc32952d17ecc59fea243d1e9"
  copies: 3
  name: "WPearl"
  label: "PearlBridge Bridged WPRL (Ethereum): WPRL Token"
  upgradeable: "yes"
  rating: LOW
  txs_90d: 70551
  last_active: 2026-11-18
  recoveries_14d: 138
fix:
  layer: offchain
  who_acts: "token holder (calls approve)"
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
  note: "signed shortcut lost, same act open by a direct call to the same party → LOW. Main reviewer: the RELAYER_ROLE attester quorum is a role-settable signer set, outside this row."
---

## Summary

WPearl (OZ 5 permit, upgradeable): a holder with code loses permit; approve stays. The bridge attester quorum (RELAYER_ROLE signers) is a separate signer issue, not this row.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call / attester quorum: each recovered signer must hold RELAYER_ROLE, ascending order. Read from source. Executed: a real transaction reverts with code at the signer.
- permit(v,r,s) called at block 26438999 with an owner whose code answers ERC-1271 (state override) reverts: ECDSA only
- approve 0x095ea7b3 in implementation bytecode
- BridgeController: each recovered attester must hold RELAYER_ROLE (dossier source line 1492)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 70,551 transactions called it in the 90 days before that block; last on 2026-11-18.
- 138 signature recoveries in the study's two-week trace window.

## Remediation

the affected party uses the direct call instead of the signed path

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
