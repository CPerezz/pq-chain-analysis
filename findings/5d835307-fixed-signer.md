---
id: 5d835307-fixed-signer
title: "0x5d835307 (tagged deployed by Triall: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x5d8353072bc0f62dacb7e3937d4c58a808db4d0e"
  family: "7f7744811f4bafa8585a480a0c52dba6"
  copies: 3
  label: "deployed by Triall: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator or owner: deploy a new sale, or credit buyers with addDepositeAmount."
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
  note: "The study note says claim needs a signature. That is wrong: harvest() is signature-free, and only deposite() is gated."
---

## Summary

The signer is an immutable EOA (0xf730…7ef5) with no setter and no ERC-1271 path. If that key's account gets code, only new signed deposits stop. Claims (harvest) and the owner's withdrawal need no signature, so nothing already held is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable signer` is assigned only in the constructor
- _isValidSigner: `messageSigner == signer` uses ECDSA.recover, with no 1271 or code check
- The signer address 0xf7309682d9b72551720db3b15de12f08cccd7ef5 has no code at block 26438999
- harvest() has no signature check

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a signer that can be changed or that is verified through ERC-1271. Meanwhile, the owner can record deposits with addDepositeAmount.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
