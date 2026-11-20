---
id: multisigpool-2fd7d4a4-fixed-signer
title: "MultiSigPool: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x2fd7d4a45f80b1d22d1ebb7b3b2961d131eb0a22"
  family: "4e9190c9520518435d6b4f22817f2bcc"
  copies: 5
  name: "MultiSigPool"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "none possible on this contract"
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
  rating: HIGH
  note: "Users' deposits leave only through signatures from a fixed set: HIGH (rated by mechanism; it holds 0 today)."
---

## Summary

ApeX MultiSigPool: deposit() keeps users' USDC in the contract. withdrawETH, withdrawErc20 and factTransferErc20 each need 2 of the 3 signers fixed in the constructor. There is no setter, no upgrade path and no other exit.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ApeX MultiSigPool (oldest): deposit() keeps users' USDC in the pool, with no StarkEx forward; it leaves only by 2 of 3 signers fixed in the constructor. Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source: signers set in the constructor only; all three exits ECDSA.recover against isAllowedSigner
- signers 0x0151…5379, 0x5320…277c, 0xfA85…5d81 have no code (latest, block ~26453066)
- state.json at block 26438999: no proxy slots; USDC balance 0 (latest, block ~26453066)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Withdraw everything before the signers migrate; deploy a new pool.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
