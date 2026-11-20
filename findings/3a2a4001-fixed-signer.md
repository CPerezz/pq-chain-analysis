---
id: 3a2a4001-fixed-signer
title: "0x3a2a4001: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3a2a400114a509fe96b817a10c0e376c9dc80155"
  family: "233f1b0b767aac24e448f17c8638d7df"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 9
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: offchain
  who_acts: "The owner (0x864c4afd1dce0f36eef5c6d0272e3dabd8033ef1) uses withdrawEmergency and handles refunds/distribution off-chain. Alternatively the signer key is kept free of non-7702 code."
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
  note: "The study note says deposit needs a signature. That is wrong: only claim needs it. I matched cSigner to 0x9f90…e680 by elimination from the bytecode pushes rather than by reading a getter. I rated MEDIUM rather than HIGH because the owner can rescue the funds, but users depend on the owner because they have no way out of their own."
---

## Summary

claim() only accepts a signature from the immutable cSigner, which has no setter and no ERC-1271 or code check. The only 20-byte address in the bytecode that is not the all-ones mask is 0x9f90…e680, and it is an EOA, so it is very likely cSigner. If that key's account gets real code, claims and vesting stop. Users' deposits stay in the contract but the owner can take them out with withdrawEmergency, so nothing is permanently stuck.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable cSigner;` is set in the constructor and has no setter
- claim(): require(ecrecover(digest, v, r, s) == cSigner, "LaunchPadPool: Invalid signer")
- deposit() needs no signature and there is no user withdraw or refund function
- claimReward pays only if user.lockedAmount > user.pickedAmount; lockedAmount is set only in claim()

## Impact and exposure

- Value held at block 26,438,999: $9 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the signer key as a plain EOA or a 7702-delegated account, never one with real code. If signing breaks, the owner pulls the funds with withdrawEmergency and refunds or distributes them off-chain. For new pools, deploy a contract whose signer can be changed and that also accepts ERC-1271.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
