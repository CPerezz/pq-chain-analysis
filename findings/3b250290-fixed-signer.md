---
id: 3b250290-fixed-signer
title: "0x3b250290: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3b250290626f152a892812abf51f156198e6a359"
  family: "29352590df92151390ce5198e7e6976b"
  copies: 5
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 2415
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "deployer operator"
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
  note: "MEDIUM: no update path; the deploy function dies, but the contract is a helper that holds no money by design. If deployContract forwards ETH that only signed deployments can spend, the stray balance would stay locked (not established)."
---

## Summary

A minimal-proxy clone (impl 0x3beb7d7d…) of a signed deployer: deployContract(bytes,bytes,address,bytes) needs a signature from the signer set once by init(address) ('Signer is already set'). No function replaces it, so deployments die if the signer takes code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signed deployer (5 addresses, 1.3 ETH): the owner set at init signs deployments; no owner setter by name. Bytecode and names.
- Update path, read at block 26,438,999: delegates to a fixed address.
- heimdall: init(address) writes the signer only if it is unset; selectors are init, deployContract, verifySig, nonceStore, chainid
- Storage slot 1 at 26438999: signer 0x46b6b618…8911, no code
- Holds 0.0101 ETH; the family holds 0.18 ETH across 5 addresses

## Impact and exposure

- Value held at block 26,438,999: $2,415 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy through a new deployer instance initialised with a new signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
