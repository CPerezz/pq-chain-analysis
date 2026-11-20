---
id: 37c60c64-fixed-signer
title: "0x37c60c64: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x37c60c642934d82c36f8d94f893c2acee90a6e5e"
  family: "a2acc34d75b56cef5da2bbb3e97da545"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 485
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3
  last_active: 2026-11-12
fix:
  layer: new-deployment
  who_acts: "The project team (owner 0x10f5…5acf) would have to deploy a new contract."
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
  note: "The decompiled mint bodies are cut short, so the ecrecover comparison against 0x1f89… cannot be seen directly. Calling it the signer rests on it being the only non-owner address constant in the code, plus the study note. Referral claims do not depend on the signature."
---

## Summary

The signer is a fixed address constant in the bytecode, 0x1f89…9d57, and it has no code today. No function can replace it. If that account gets code, only the signed minting of new soulbound tokens stops. Referral rewards already earned can still be claimed without a signature through 0x97b09aba, so no held funds are locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- constant unresolved_ee98c6b9 = 0x1f89047445b44708bdbb4fa1620edb4db9249d57 (code_bytes 0, not delegated)
- TEAM_WALLET constant = 0x10f55205…5acf = owner(), an EOA
- transferOwnership/renounceOwnership write only store_b (owner); no address setter for the signer
- 0x97b09aba: requires balanceOf==1 and unresolved_b7570a75[msg.sender]>0, pays msg.sender with no signature

## Impact and exposure

- Value held at block 26,438,999: $485 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-11-12.

## Remediation

Deploy a new mint contract whose signer can be rotated or that accepts ERC-1271 signatures, and keep the signer key as a plain EOA.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
