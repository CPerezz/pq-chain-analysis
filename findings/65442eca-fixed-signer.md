---
id: 65442eca-fixed-signer
title: "0x65442eca (tagged deployed by Triall: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x65442eca46c6dda71831337ab4eecf6ba4b465c9"
  family: "9eb2582bce4c04018a353202048f9f0f"
  label: "deployed by Triall: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator. It can credit buyers with addDepositeAmount, or deploy a new sale contract."
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
  note: "The row facts do not give the signer address's code size. The verdict assumes it is an EOA today, based on the template idiom. If it already has code that is not a 7702 delegation, the row is refuted."
---

## Summary

The signer is immutable and has no setter. Only new signed deposits would stop. Existing deposits are still harvested with no signature, and the owner can still call withdrawFunds and addDepositeAmount, so nothing gets locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable signer;` with `signer = signer_` in the constructor
- _isValidSigner: `ECDSA.recover(hash,_v,_r,_s)` and `return messageSigner == signer`
- Only deposite calls _isValidSigner. harvest() has no signature check
- addDepositeAmount (onlyOwner) credits deposits without a signature

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the signer key as an EOA or 7702-delegated account. If it gets real code, the owner can record deposits with addDepositeAmount or deploy a new sale contract with a new signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
