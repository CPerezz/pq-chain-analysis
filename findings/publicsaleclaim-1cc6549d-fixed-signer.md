---
id: publicsaleclaim-1cc6549d-fixed-signer
title: "PublicSaleClaim: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x1cc6549dff7630ddba563dd394360b3f63556a49"
  family: "0ca1f3bff7ac134553c71015d92c5853"
  copies: 41
  name: "PublicSaleClaim"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0x0d4f2851e0D99b6A1D03aC418a218a7450EBb208"
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
  note: "Claim dies for good but owner withdraw is untouched and nothing is locked -> MEDIUM."
---

## Summary

PublicSaleClaim: claim() requires ecrecover==owner, owner set only in constructor, never reassigned. withdrawETH/withdrawTokens are onlyOwner with no signature required, so collected funds are not locked when the key breaks.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: PublicSaleClaim claim: each claim needs the owner's signature (owner set in the constructor, no transfer); the owner withdraws tokens and ETH by direct call, so nothing locks (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Contract.sol: constructor() { owner = msg.sender; } claim() requires ecrecover(ethSignedMessage,v,r,s)==owner (dossier source)
- Contract.sol: withdrawTokens/withdrawETH onlyOwner, no signature check
- owner()==0x0d4f2851e0D99b6A1D03aC418a218a7450EBb208 at block 26438999 (cast call)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 41 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner redeploys a successor claim contract with a fresh key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
