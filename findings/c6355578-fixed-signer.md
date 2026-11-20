---
id: c6355578-fixed-signer
title: "0xc6355578: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc6355578905e5954d8f85e44a5b33d18c7fdf775"
  family: "8a30918dd4be45d946e0cdee8d5a46d5"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The project/operator would need to deploy a new distributor. The tokens already held by this contract cannot be recovered."
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
  note: "Only the operator's own stock is at stake: the contract holds items or tokens the operator put there for claimants, and no user deposited anything. Claims die for good with no rescue or update path: MEDIUM (D-024: operator's own money). The verifier 0xF780...b3fD is a 7702-delegated account today (code 0xef0100...), so its signatures still recover until it takes real code."
---

## Summary

The verifier is immutable and there is no setter, no ERC-1271 path and no code check. If the verifier's account gets real code, ecrecover returns nothing, every claim reverts, and all tokens held stay locked forever: there is no owner rescue and no upgrade path.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable verifier;` is assigned only in the constructor
- claim(): `address signer = ECDSA.recover(digest, signature); if (signer != verifier) revert InvalidSignature();`
- token.transfer appears only in claim(). The source has no withdraw/rescue/sweep function
- The owner's only power is Ownable2Step transferOwnership. Upgradeable: no

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new distributor with a verifier that can be rotated and an owner rescue function. The tokens in this contract cannot be moved without a verifier signature.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
