---
id: b621505e-fixed-signer
title: "0xb621505e: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb621505e8ba38f2505c936be62e3bf02c40dd6a3"
  family: "bf89254c67fc5b7c5fb5b6a6936d703e"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Owner (0xcfa555b048dd969ddf620443862f3a4658b3b30e) uses withdrawEmergency and repays users off-chain or through a new contract"
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
  note: "The material does not show which of the two EOA candidates is cSigner, but both have no code, so the verdict is the same either way."
---

## Summary

The signer is immutable with no setter, no code check and no ERC-1271 fallback. Both address candidates in the bytecode are EOAs today. If the signer account gets real code, claim() stops working. Deposits are not locked for good because the owner's withdrawEmergency can move every token held.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- `address public immutable cSigner;` is set in the constructor from _signer and no function writes to it
- claim(): require(ecrecover(digest, v, r, s) == cSigner, "LaunchPadPool: Invalid signer")
- deposit() has no signature check, so the study note saying deposit needs one is wrong
- withdrawEmergency(tokenaddress,to) is onlyOwner and transfers the contract's full balance of any token

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Keep the signer key an EOA. If claims break, the owner uses withdrawEmergency to return deposits and sale tokens. Any new deployment should have a signer that can be replaced.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
