---
id: whitelist-1e6d3ec2-entry-by-own-signature-only
title: "Whitelist: entry only by one's own signature"
status: not-affected
severity: NONE
patterns: [PQ-21]
impact: none
contracts:
- address: "0x1e6d3ec2a3cd38819a43ec7b6abce5998d1169ad"
  family: "1784ff6f4297d44cc8b207b15c6a178b"
  copies: 4
  name: "Whitelist"
  upgradeable: "yes"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "Directory admin (re-grant ADMIN_SERVER_ROLE) if the server key ever moved to code"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-entry-by-own-signature-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "The claim (operator signs) is wrong. The real dependency is a rotatable server key: reclassify as rotate-signer (LOW, after checking the role admin is live). Missing reads (node timed out): ADMIN_SERVER_ROLE holders and the role admin in the Directory at 26438999 (needed only for the reclassified rotate-signer rating)."
---

## Summary

NodeSet Constellation Whitelist implementation: _addOperator recovers a signature over the operator address, but the signer must hold ADMIN_SERVER_ROLE in the Directory; the operator does not sign.

## Mechanism

PQ-21. An account with real code can no longer enter. Nothing it already holds is affected.

## Evidence

- How it was placed: Whitelist _addOperator: the operator must sign to be added; an operator with code cannot. Read (function text).
- Whitelist.sol L191-205: require(_directory.hasRole(ADMIN_SERVER_ROLE, recovered)), so an operator with code is still added when the server signs
- The server signer is a Directory AccessControl role, replaceable by the role admin (rotate-signer pattern); admin can also invalidate signatures (L207-213)
- facts: implementation behind 3 EIP-1967 proxies (e.g. 0xd5e6e25bcac30ce1f8dd41685b34e1dc84a02ecb); upgrades via onlyLongTimelock (UpgradeableBase L85)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for operators. If the server key were ever given code, grant ADMIN_SERVER_ROLE to an EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-entry-by-own-signature-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
