---
id: 4517c311-fixed-signer
title: "0x4517c311: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x4517c311add78330680e73895bb10b56ec4d3cf5"
  family: "c7064e96e25032e2e7db63b3de65249a"
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

Gemini-style ERC20Impl (token R314). It holds no Custodian code, so completeUnlock and a fixed signer set do not exist here. Its only ecrecover is enableSweep, which recovers whichever deposit addresses signed sweepMsg, not a fixed key.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Gemini custodian completeUnlock: the caller must be a signer and two more signers of the custodian's fixed set must have signed / Gemini enableSweep: marks for sweeping the…. Same code idiom as template 59db0469, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- completeUnlock selector 0x3b3d5b88 absent from bytecode at block 26438999; enableSweep 0xb7279ca6 and custodian() present
- 59db0469 source: completeUnlock belongs to contract Custodian (l.104-430), a separate deployment; ERC20Impl.enableSweep (onlySweeper) does ecrecover(sweepMsg) and sweeps the recovered address's balance, with no fixed-set check
- custodian()=0x3A935942843d355bbB63cf2e94Dc8e19ef28ca4c (contract, 4859 B, no completeUnlock selector); sweeper()=0x4a1192F0a89D00a3E11778ca94AaF649E2B53FB2; erc20Proxy=0xa50D578361824012Dec8412A6D1a3347c1f68e6e R314; custodian code also lacks completeUnlock

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None needed. A deposit address that takes real code can no longer be swept by signature but still moves its tokens with a direct transfer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
