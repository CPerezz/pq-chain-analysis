---
id: a8840cf5-fixed-signer
title: "0xa8840cf5: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0xa8840cf5015a1ec773f91b4d13fa94633c9e4349"
  family: "dda72a2f868c8b01d26fa7271691280d"
  copies: 3
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
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
  verdict: refuted
  rating: NONE
  note: "The study wrongly transferred the source file's Custodian reading to the ERC20Impl; no fixed signer."
---

## Summary

Gemini-style ERC20Impl (token D99). It holds no Custodian code, so completeUnlock and a fixed signer set do not exist here. Its only ecrecover is enableSweep, which recovers whichever deposit addresses signed sweepMsg, not a fixed key.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Gemini custodian completeUnlock: the caller must be a signer and two more signers of the custodian's fixed set must have signed / Gemini enableSweep: marks for sweeping the…. Same code idiom as template 59db0469, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- completeUnlock selector 0x3b3d5b88 absent from bytecode at block 26438999; enableSweep 0xb7279ca6 and custodian() present
- 59db0469 source: completeUnlock belongs to contract Custodian (l.104-430), a separate deployment; ERC20Impl.enableSweep (onlySweeper) does ecrecover(sweepMsg) and sweeps the recovered address's balance, with no fixed-set check
- custodian()=0x7e97dBBf5Ea2AaF956f46dFe94AcF23588fd0f81 (EOA); sweeper()=0x7e97…0f81; erc20Proxy=0x1efB690E9316E565637DA560A2f157150a35294D D99; custodian code also lacks completeUnlock

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed. A deposit address that takes real code can no longer be swept by signature but still moves its tokens with a direct transfer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
