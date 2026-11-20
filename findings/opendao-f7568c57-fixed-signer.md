---
id: opendao-f7568c57-fixed-signer
title: "OpenDAO: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xf7568c57bc6392f5c7685d1060b86770c9caa6d6"
  family: "e5beecdcd0f4b90acbac8a6627b92532"
  name: "OpenDAO"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "no owner action available"
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
  note: "Downgraded from the study's HIGH to match the identical OpenSeaSoS mechanism: mint, not escrow release -> MEDIUM."
---

## Summary

OpenDAO airdrop claim: claim() mints new ERC20 supply to msg.sender if ecrecover(digest,v,r,s)==cSigner (immutable, no setter) -- identical mechanism to the OpenSeaSoS row in this project (same source, only renamed). claim() mints fresh supply rather than releasing any pre-existing balance, so nothing already held is locked when cSigner gets code; the unclaimed allocation simply never gets minted.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: OpenDAO claim: signed by cSigner, fixed in the code. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- OpenDao.sol: cSigner immutable set only in constructor, require(ecrecover(...)==cSigner) (dossier source, identical structure to OpenSeaSoS.sol)
- OpenDao.sol: _mint(msg.sender, amount) -- mints new supply, not an escrowed transfer
- no setter, no proxy (facts: setters=[], upgrades=[])

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

n/a (no fix without redeploying the token).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
