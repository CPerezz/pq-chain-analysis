---
id: 3459608d-fixed-signer
title: "0x3459608d (tagged deployed by DeBox Guardians Eagle: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x3459608da9ae247690e78e8562d9064a0e00418b"
  family: "dc151f427c99a66336526db040e09ff3"
  label: "deployed by DeBox Guardians Eagle: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 7002
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "owner 0xdf49493b… (EOA)"
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
  note: "No update path; sale proceeds are the operator's own and leave through the owner's withdraw()."
---

## Summary

DeBox Guardians mint: mint requires a signature from the immutable signer. If it takes code, minting stops; the owner still withdraws the sale proceeds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: mint behind a signer that is a constant in the code. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Selectors: mint, signer, PRICE, WHITE_PRICE, setPaused, withdraw, transferOwnership; no setSigner; no EIP-1967 slot
- signer() at 26438999 = 0xa87412c89b0d25e72e977caa1d00cc0f1141e552, a PUSH32 immutable in the code, cast code 0x (EOA)
- withdraw() is onlyOwner; owner() = 0xdf49493bfc9f6038556057f86dfba5ca83ee233e (EOA)

## Impact and exposure

- Value held at block 26,438,999: $7,002 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner withdraws and deploys a new mint contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
