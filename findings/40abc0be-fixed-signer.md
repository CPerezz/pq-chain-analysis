---
id: 40abc0be-fixed-signer
title: "0x40abc0be: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x40abc0be46decb904464c97ce0d804a839c70d60"
  family: "f77e568526a9b6db95731f1fda4b0faf"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 198
  last_active: 2026-11-16
fix:
  layer: new-deployment
  who_acts: "Project owner/deployer"
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
  rating: MEDIUM
  note: "The study_note calls this a presale, but the code is an NFT mint. The signer address is inferred from the bytecode push list, not from a getter. Whichever address it is, every candidate is an EOA today."
---

## Summary

The public mint needs a signature from the immutable _defender key. Nothing in the contract can replace that key, and the contract has no code check or ERC-1271 fallback. If the defender account gets code, signed mints stop. The ETH is still withdrawable through withdrawAll and existing NFTs still transfer, so only a function stops and nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address private immutable _defender;` is set only in the constructor: `_defender = defender`
- mint(): `require(ECDSA.recover(...) == _defender, "Invalid signature")`
- There is no setter for _defender; the only setter listed is transferOwnership (owner)
- withdrawAll() onlyOwner pays out the full balance without a signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 198 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

Deploy a new mint contract with a signer that can be rotated or that accepts ERC-1271, or keep the defender key as a plain EOA. The owner can still mint the reserved supply with mintByOwner and withdraw ETH.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
