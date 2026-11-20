---
id: verifyingpaymaster-99f17945-fixed-signer
title: "VerifyingPaymaster: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x99f17945cb2c88d894864c777132fa746e5d26f9"
  family: "db54cf5f6fe11667d4112826557b7622"
  name: "VerifyingPaymaster"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "Paymaster owner 0x5c97458bc2f8e6ef2336c8b34a713993f78d7d63"
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
  note: "This is the rubric's own MEDIUM example: no update path, but only the operator's own paymaster deposit is at stake and it is owner-withdrawable -> MEDIUM, not the study's HIGH."
---

## Summary

ERC-4337 VerifyingPaymaster: verifyingSigner is immutable, no setter. If it gets code, new UserOperations can no longer get sponsorship (every _validatePaymasterUserOp fails). The paymaster's own EntryPoint deposit/stake is not gated by this signature: owner (a live EOA, nonce>0) can withdrawStake/withdrawTo/unlockStake directly.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: VerifyingPaymaster: the signer must be verifyingSigner, fixed in the code. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- VerifyingPaymaster.sol:25,31,83: verifyingSigner immutable set only in constructor, compared via ECDSA.recover (dossier source)
- facts: exits=[transferOwnership, unlockStake, withdrawStake, withdrawTo]; setters=[transferOwnership]; getters.owner()=[0x5c97458bc2f8e6ef2336c8b34a713993f78d7d63]
- owner()==0x5c97458bc2f8e6ef2336c8b34a713993f78d7d63 at block 26438999 (cast call, before RPC degraded)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new paymaster with a fresh verifyingSigner; owner migrates its deposit to it via withdrawTo.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
