---
id: mscontrol-bace265d-rotate-signer-before-migrating
title: "MsControl: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xbace265d7b07e8bba150b689501cd1143d7d8549"
  family: "11e8064046f3c890df2ad3a270927566"
  copies: 5
  name: "MsControl"
  upgradeable: "no"
  rating: LOW
  txs_90d: 17509
  last_active: 2026-11-17
  recoveries_14d: 828
fix:
  layer: onchain-config
  who_acts: "MsControl admins (2 of 3)"
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
  note: "A live 2-of-3 EOA admin set can replace signers."
---

## Summary

MsControl multisig control. validateSignatures requires ECDSA.recover to equal each stored signer. A signer with code fails until it is replaced by an admin proposal.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: MsControl: signers are added and removed by voted proposals. Read by hand. Executed: a real transaction loses its effect with code at the signer.
- proposeAddSigner/proposeRemoveSigner are onlyAdmin and voted (MsConfig.sol:194-199)
- admins() at 26438999: 0x6215…336E nonce 2, 0x9710…02AF nonce 40, 0x6cD7…046b nonce 27, all EOAs; requiredApprovals=2
- signers(): 3 addresses; requiredSignatures=2

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 17,509 transactions called it in the 90 days before that block; last on 2026-11-17.
- 828 signature recoveries in the study's two-week trace window.

## Remediation

The admins propose and approve removal of the migrating signer and addition of a new EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
