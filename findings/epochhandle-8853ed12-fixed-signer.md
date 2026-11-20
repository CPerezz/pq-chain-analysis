---
id: epochhandle-8853ed12-fixed-signer
title: "EpochHandle: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8853ed1252b249bc54a0beeabff5a039234e9cbd"
  family: "c67abe65053ff20b25691c5ed04dd5d1"
  copies: 13
  name: "EpochHandle"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0x37A0ba6A4d9bC57c5423988FE75EC6B3ceDc22e0"
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "Claim dies for good but owner withdraw is untouched -> MEDIUM."
---

## Summary

EpochHandle: byte-identical to the PublicSaleClaim/DCOMStaking pattern (only the contract name differs): claim() requires ecrecover==owner, owner set only in constructor, no transfer. withdrawETH/withdrawTokens are onlyOwner with no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: PublicSaleClaim claim: each claim needs the owner's signature (owner set in the constructor, no transfer); the owner withdraws tokens and ETH by direct call, so nothing locks (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Contract.sol (this dossier, diffed against the PublicSaleClaim copy): only `contract PublicSaleClaim` vs `contract EpochHandle` differs
- claim() requires ecrecover==owner; owner set in constructor, never reassigned
- owner()==0x37A0ba6A4d9bC57c5423988FE75EC6B3ceDc22e0 at block 26438999 (cast call)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 13 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner redeploys a successor claim contract with a fresh key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
