---
id: openseasos-b1a1865b-fixed-signer
title: "OpenSeaSoS: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb1a1865bc831051c557de134d80b7fee28561d2b"
  family: "48c69b10fb106af8feb39adb50bd2749"
  name: "OpenSeaSoS"
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
  note: "Downgraded from the study's HIGH: claim mints new supply rather than releasing deposits, so nothing already held is locked -> MEDIUM."
---

## Summary

OpenSeaSoS airdrop claim: claim() mints new ERC20 supply to msg.sender if ecrecover(digest,v,r,s)==cSigner (immutable, no setter). If cSigner gets code, claim() stops for good -- but claim() _mint()s fresh supply rather than releasing any pre-existing balance, so no already-held funds are locked; the unclaimed allocation simply never gets minted.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: OpenDAO claim: signed by cSigner, fixed in the code. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- OpenSeaSoS.sol:34-50: cSigner immutable set only in constructor, require(ecrecover(...)==cSigner) (dossier source)
- OpenSeaSoS.sol:48: _mint(msg.sender, amount) -- mints new supply, does not transfer an escrowed balance
- no setter, no proxy (facts: setters=[], upgrades=[])

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

n/a (no fix without redeploying the token).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
