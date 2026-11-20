---
id: ba48bcc6-fixed-signer
title: "0xba48bcc6 (tagged deployed by SuperFarm: Deployer 1): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xba48bcc66b6665495ec643ece7811db5723aaf91"
  family: "fa03cf9ba3d875f904358ef517710d59"
  label: "deployed by SuperFarm: Deployer 1"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner deploys a new RewardStaker with a new signer and uses sweep to move the reward stock to it"
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
  note: "The row facts give no code size for the signer 0xaaaa…06a5 (constants[] is empty). The verdict assumes it is an EOA today. If it already has non-delegation code, the verdict becomes refuted."
---

## Summary

The signer is immutable and has no setter or ERC-1271 path. If the signer account gets real code, claims stop working, but the reward stock can be swept by the owner, so nothing gets locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable signer;` assigned in constructor
- _validClaim: `return ecrecover(digest,_v,_r,_s) == signer;`
- No function writes signer; no proxy slot or upgrade function (row facts upgradeable: no)
- sweep(...) onlyOwner can move any token or ETH

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new contract with a new signer, or with an updatable signer that also accepts ERC-1271, then sweep the reward funds into it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
