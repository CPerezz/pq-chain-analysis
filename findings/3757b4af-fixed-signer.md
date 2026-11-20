---
id: 3757b4af-fixed-signer
title: "0x3757b4af (tagged deployed by Triall: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3757b4aff7c3504cc4d6509938ec6c9ccde4cf0d"
  family: "6abe07881b622b9945ddaaf67cffbb54"
  label: "deployed by Triall: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator or owner. They can redeploy, or record allocations through addDepositeAmount."
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
  note: "The study note says claims also need the signature. The source shows they don't: harvest() has no signature check, so only deposite() is affected."
---

## Summary

The signer is immutable and is an EOA today. Only new presale deposits need the signature. Harvest and the owner's withdrawal do not, so if the signer's account got code, new deposits would stop but no funds would be locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Signer declaration: `address public immutable signer`, set once in the constructor. No setter exists.
- _isValidSigner returns `messageSigner == signer` using ECDSA.recover, with no code check and no ERC-1271 path.
- Signer 0xf7309682d9b72551720db3b15de12f08cccd7ef5 is an EOA (no code) at block 26438999.
- deposite() requires `_isValidSigner(...)`.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new sale contract whose signer can be replaced, or that accepts ERC-1271 signatures. Until then, the owner can record allocations with addDepositeAmount.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
