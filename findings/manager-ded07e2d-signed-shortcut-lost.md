---
id: manager-ded07e2d-signed-shortcut-lost
title: "Manager: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0xded07e2da859714f69d93f9794344606ed67907e"
  family: "41b4aed711420eb25b4497017384fbd4"
  copies: 2
  name: "Manager"
  upgradeable: "no"
  rating: NONE
  txs_90d: 1138
  last_active: 2026-11-18
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
  note: "Code checks for code first and accepts ERC-1271: refuted per the scale. A 7702-delegated owner also takes the 1271 path; that behaviour is unchanged by EIP-8151."
---

## Summary

Manager (NFT position manager, ERC721Extended): permit checks Address.isContract(owner) first and then uses ERC-1271 isValidSignature, so an owner with code never reaches ecrecover; EIP-8151 does not take the route from it.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: ERC721Extended permit: the token's owner; approve is the direct call. Read (function text).
- ERC721Extended.permit: `if (Address.isContract(owner)) require(IERC1271(owner).isValidSignature(...) == 0x1626ba7e)` else ecrecover (contracts/periphery/base/ERC721Extended.sol ~l.74-82).
- ERC721 approve (0x095ea7b3) also remains as the direct call for the token owner (bytecode at 26438999).

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 1,138 transactions called it in the 90 days before that block; last on 2026-11-18.

## Remediation

None needed; owners with code sign via ERC-1271 or call approve.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
