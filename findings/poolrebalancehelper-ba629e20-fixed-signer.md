---
id: poolrebalancehelper-ba629e20-fixed-signer
title: "PoolRebalanceHelper: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xba629e206dfb3c6b1b874e6f44a734eadbe75bef"
  family: "81daa56bd849e904c65c79f6b453ae0f"
  name: "PoolRebalanceHelper"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: none
  who_acts: "no one -- funds are stuck"
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
  note: "No update path and withdrawal is gated solely by a fixed 2-of-3 signer set with no admin override -> HIGH."
---

## Summary

zkLink fast-pool rebalance helper: withdrawETH/withdrawErc20 require 2-of-3 signatures from a fixed `signers` array set only in the constructor (no setter, no proxy). Deposit() is one-way (USDC -> StarkEx L2); any ETH/ERC20 bridged back to this contract on L1 can only leave via the 2-of-3 signed withdraw functions. If 2 of the 3 signer addresses ever get code, nothing can get the held funds out.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: zkLink fast pool withdrawETH: every signature must come from the signer it names, an allowed signer; two distinct ones are needed; no function changes the signers / zkLink fast pool withdrawErc20: as…. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- PoolRebalanceHelper.sol: signers set once in constructor, require(allSigners.length>=2) and 2x ECDSA.recover==allSigners[i] with isAllowedSigner (dossier source)
- no setter for `signers`, no owner(), no proxy slot (facts: setters=[], upgrades=[])
- withdrawETH/withdrawErc20 are the only functions that move funds out of this contract

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none available on-chain.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
