---
id: 01107c2d-fixed-signer
title: "0x01107c2d: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x01107c2d5d147f02ee90746fbad4f5061696b5f2"
  family: "d867637e20122143bf5645ace13418bb"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 24
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 15
  last_active: 2026-11-17
  recoveries_14d: 2
fix:
  layer: none
  who_acts: "none"
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
  note: "The signed sale function dies, and the only money (platform fees) still leaves without a signature, so MEDIUM. The row's HIGH is not supported."
---

## Summary

This is an NFT marketplace for collection 0x405f…116e. Buying a listing (0x468f5f1d) needs an authorization signature from the constant authorizationSigner, recovered by ecrecover with no ERC-1271. Once that signer has code, sales stop. The contract's whole balance is accrued treasury fees, which withdrawTreasuryFees pays to the treasury with no signature.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: listings co-signed by an authorisation signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: authorizationSigner() is a code constant = 0x2866…A4e3 (no code). The bytecode has no 1626ba7e selector.
- accruedTreasuryFees() = 0.01331 ETH = the contract balance, so no buyer or seller escrow is held.
- withdrawTreasuryFees() has no caller check and pays the treasury 0x1da6…80c8; owner functions are pause/treasury/ownership only.

## Impact and exposure

- Value held at block 26,438,999: $24 (ETH and 49 priced tokens).
- Activity: 15 transactions called it in the 90 days before that block; last on 2026-11-17.
- 2 signature recoveries in the study's two-week trace window.

## Remediation

Deploy a new marketplace.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
