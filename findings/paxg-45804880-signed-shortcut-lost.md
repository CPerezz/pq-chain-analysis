---
id: paxg-45804880-signed-shortcut-lost
title: "PAXG: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0x45804880de22913dafe09f4980848ece6ecbaf78"
  family: "9c1bb3eae284208dab791960560236e1"
  copies: 2
  name: "PAXG"
  label: "Paxos Gold: PAXG Token"
  upgradeable: "yes"
  rating: NONE
  value_usd: 115492
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 293584
  last_active: 2026-11-18
  recoveries_14d: 66
fix:
  layer: none
  who_acts: "nobody"
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
  verdict: refuted
  rating: NONE
  note: "The row note quotes the archived V1 source; the live code accepts ERC-1271. Refuted (LOW if the reviewer disagrees). Reviewer: confirm that 0x7da4 is the facet build."
---

## Summary

PAXG (Paxos Gold, upgradeable proxy): the live implementation verifies permit and EIP-3009 authorisations through SignatureChecker (ERC-1271 accepted), and transfer/approve stay direct.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: Paxos v1 permit: the owner named must have signed / Paxos v1 cancelAuthorization: the authorizer named must have signed; an authorisation of an account with code cannot be used either / Paxos v1…. Read from source.
- Proxy slot 0x7050c9e0... -> implementation 0x7da4c5d9eca180a03765a6d27196f2a0380fa543 at block 26438999
- isValidSignature 0x1626ba7e, permit 0xd505accf and transfer 0xa9059cbb all in implementation code
- Dossier source: TokenExtensionsFacet.sol:439,469,510 and EIP2612.sol:93 use SignatureChecker.isValidSignatureNow; the row note cites archive/PaxosTokenV1

## Impact and exposure

- Value held at block 26,438,999: $115,492 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 293,584 transactions called it in the 90 days before that block; last on 2026-11-18.
- 66 signature recoveries in the study's two-week trace window.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
