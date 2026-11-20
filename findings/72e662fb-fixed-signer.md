---
id: 72e662fb-fixed-signer
title: "0x72e662fb: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x72e662fb393dcb9c6d96b6d63d13eb84370fd583"
  family: "2ddc7a8ad64927f571391840055ef40b"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "a claimant owed a payout they already qualify for"
evidence:
  level: bytecode
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
  rating: MEDIUM
  note: "Claim stock the operator put there for claimants: claims die for good once the fixed signer has code and nothing rescues the rest, but only the operator's own money is at stake (D-024): MEDIUM."
---

## Summary

A one-time claim/payout contract: `claim(amount, digest, signature)` pays out ETH (or a routed token) only if ecrecover(digest, sig) equals a hardcoded address; EIP-8151 permanently breaks every future claim once that address gets code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall decompile shows the literal check `address(var_u) == 0x00099ab840377529a4ea337414b1600a207f1388` right after `ecrecover(...)` inside the claim function
- Signer address 0x00099ab840377529a4ea337414b1600a207f1388 has no code today (`cast code` -> 0x), latent risk
- facts.exits for this address = ['claim(uint256,bytes32,bytes)', 'claimed(address)', 'transferOwnership(address)']: claim()/claimed()/transferOwnership() only, no owner withdraw/rescue function exists
- facts.setters only transferOwnership; facts.upgrades = [] -> no proxy, no way to rotate the signer or recover the balance another way

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

No on-chain fix: redeploy with a replaceable signer/oracle, or migrate remaining balances to a new claim contract before EIP-8151 activates.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
