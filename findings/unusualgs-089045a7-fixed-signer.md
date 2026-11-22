---
id: unusualgs-089045a7-fixed-signer
title: "UnusualGs: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x089045a72b70b05ec22ea4be23ebc07768fb3e7f"
  family: "7ce071c87b79cf7a74ff58817bb710af"
  name: "UnusualGs"
  upgradeable: "no"
  rating: LOW
  value_usd: 2743
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "CONTRACT_OWNER (togglePublicSale)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: a setting keeps the same mint open, and the owner's proceeds exit by a direct call."
---

## Summary

UnusualGs (Base_ERC721a): mintAllowList needs a signature from CONTRACT_OWNER, which is set in the constructor and never changed. The owner can open the public mint(); withdraw() is a direct owner call.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: UnusualGs allow list: signed by CONTRACT_OWNER, set in the constructor, never changed. Read by hand.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Base_ERC721a.sol:96-98: ECDSA.recover(...) == CONTRACT_OWNER; :28 CONTRACT_OWNER = msg.sender, with no other assignment
- togglePublicSale() and withdraw() check msg.sender == CONTRACT_OWNER; mint(uint256) is unsigned
- CONTRACT_OWNER 0x798D…f175 has no code; balance 1.52 ETH

## Impact and exposure

- Value held at block 26,438,999: $2,743 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner turns on the public sale. Withdraw stays direct even if the owner account gets code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
