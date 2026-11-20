---
id: dcomstaking-38923219-fixed-signer
title: "DCOMStaking: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x38923219e9252b66325386bbf8900f4557b07675"
  family: "a675ee3aa6c7c5354dce6d661b2e4625"
  copies: 11
  name: "DCOMStaking"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner 0x4e2abE3059bfD28A677E3CF976F1E3dEFC7Dc107"
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

DCOMStaking: same owner-signed claim() pattern as PublicSaleClaim (identical except renamed contract: 'StakingRewards'), owner set only in constructor, no transfer. Owner can withdrawETH()/withdrawTokens() directly without a signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: PublicSaleClaim claim: each claim needs the owner's signature (owner set in the constructor, no transfer); the owner withdraws tokens and ETH by direct call, so nothing locks (MEDIUM). Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- StakingRewards.sol:6,11,21,24,30,31: owner set only in constructor; claim() requires ecrecover==owner (dossier source)
- StakingRewards.sol:36,40,46: toggleClaim/withdrawTokens/withdrawETH are onlyOwner, no signature needed
- owner()==0x4e2abE3059bfD28A677E3CF976F1E3dEFC7Dc107 at block 26438999 (cast call)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 11 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owner redeploys a successor claim contract with a fresh key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
