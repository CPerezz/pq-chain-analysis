---
id: erc721cmroyalties-7de2d74f-rotate-signer-before-migrating
title: "ERC721CMRoyalties: signer key to rotate before its account takes code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x7de2d74fec610ff68294dd185b190726bd680451"
  family: "88ca62087f0bbdec26bb382e6e42dd90"
  copies: 4
  name: "ERC721CMRoyalties"
  upgradeable: "no"
  rating: NONE
  txs_90d: 1939
  last_active: 2026-11-15
fix:
  layer: none
  who_acts: "owner EOA (only if cosigner code lacks ERC-1271)"
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
  verdict: refuted
  rating: NONE
  note: "Refuted: a cosigner with code is handled through ERC-1271. Even without that, the owner-only setCosigner and live EOA owner would make it LOW. The ERC-1271 target was read from the decompile only."
---

## Summary

Magic Eden ERC721CMRoyalties with an owner-set cosigner for cosigned mints; the cosign check falls back to ERC-1271 isValidSignature.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the signer is one key kept in storage; functions replace it (setCosigner, setToCustomValidatorAndSecurityPolicy, setTransferValidator). Whoever holds it must replace it before that account takes code. Rule: stored-key.
- heimdall decompile: the cosigned mint 0x3d6375b2 makes a staticcall to isValidSignature (0x1626ba7e) on the stored signer address after the ecrecover attempt (SignatureCheckerLib pattern)
- setCosigner(address) requires msg.sender==owner; eth_call from owner 0x490A…2eDB succeeds, from 0xdead reverts 0x118cdaa7
- owner 0x490AE2D470445e16cFa91c9c3920eDfd04E32eDB is an EOA, nonce 27 (probe)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 1,939 transactions called it in the 90 days before that block; last on 2026-11-15.

## Remediation

None needed if the cosigner's code implements ERC-1271; otherwise the owner calls setCosigner.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
