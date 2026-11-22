---
id: erc721cmroyalties-1196f8a7-rotate-signer-before-migrating
title: "ERC721CMRoyalties: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1196f8a7406ad953c2024b0e2d08f0511f977955"
  family: "7da81f62521746d6cd2e03badbdc40f4"
  copies: 7
  name: "ERC721CMRoyalties"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1562
  last_active: 2026-11-17
fix:
  layer: onchain-config
  who_acts: "owner EOA 0xB030…e674"
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
  note: "Setter exists and the owner is a live EOA, so LOW holds."
---

## Summary

An ERC721M-style mint contract with a stored cosigner whose signature authorizes cosigned mints. Those mints fail once the cosigner's account holds code.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setCosigner, setToCustomValidatorAndSecurityPolicy, setTransferValidator). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- setCosigner(address) (0x02045138) writes the cosigner into store_l and requires msg.sender == owner, 'Ownable: caller is not the owner' (decompile)
- owner() = 0xB030fE21dddd51cC2A8f036E7508d494dC6De674, an EOA with nonce 11, at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 7 addresses).
- Activity: 1,562 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

The owner calls setCosigner with a new EOA, or with zero to drop cosigning.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
