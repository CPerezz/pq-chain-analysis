---
id: helmets2117-c708eae3-fixed-signer
title: "Helmets2117: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc708eae3292173aa57c78d7d5ee123aed9b6dc1a"
  family: "f453c892094f1b0f069fcbe50e6d002a"
  name: "Helmets2117"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 4187
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner 0x841542bd… (EOA)"
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
  note: "No update path; the claim function dies, and the money leaves through the owner's withdraw."
---

## Summary

Helmets2117 NFT: claimHelmets and applyHelmetCustomization need a signature from the constant SIGNER_ADDRESS. If it takes code, claims and customizations stop; ETH paid for customizations leaves through the owner's withdraw.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Helmets2117: signed by SIGNER_ADDRESS, fixed in the code. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Helmets2117.sol:42 SIGNER_ADDRESS = 0x254E79799F35077072B60AD2e47fb5c499D5e95a (constant), cast code 0x; _isTrustedSigner compares ECDSA.recover with it
- withdraw(address payable) onlyOwner (Helmets2117.sol:140); owner 0x841542bd5ac25939a67c3da6cc3d1cd5d9471f26 (EOA)
- No signer setter; no EIP-1967 slot

## Impact and exposure

- Value held at block 26,438,999: $4,187 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner withdraws; a new contract is needed for further claims.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
