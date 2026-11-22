---
id: c3131b0e-fixed-signer
title: "0xc3131b0e: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc3131b0e357b50d54d6ceed17981f3f161d90499"
  family: "40ac8b91514a1db1bd72b7f46b960c5c"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 2
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: onchain-config
  who_acts: "The owner calls openPublic() to switch to public minting."
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
  note: "The study note calls this a presale with deposit and claim. The source shows an NFT whitelist mint, and no deposit or claim function exists. Only a function stops and nothing is locked, so the rating is MEDIUM."
---

## Summary

The whitelist mint only accepts signatures from the hard-coded key 0x951a…066f, which nothing in the contract can replace. That address has no code today. If it gets real code, mintWL stops working. No funds get locked: users can still mint through mint/mintSH once the owner opens the public sale, and withdraw keeps paying out to the fixed payees.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- mintWL requires recover(signature) == 0x951a4bC1675863C395754Faa2F8c8Ff1594F066F, a literal in the code
- Row facts: constant 0x951a4bc1675863c395754faa2f8c8ff1594f066f has code_bytes 0 and delegated false
- The only setter is transferOwnership; there is no function that changes the signer; upgradeable is 'no'
- mint() and mintSH() need no signature once openedPublic is true; openPublic() is onlyOwner

## Impact and exposure

- Value held at block 26,438,999: $2 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

If the signer key gets code, the owner calls openPublic() so users mint through the public path. Bringing back the signed whitelist would need a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
