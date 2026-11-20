---
id: moonthatcommunitylaunch-cb7b54a8-fixed-signer
title: "MoonThatCommunityLaunch: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xcb7b54a8f20a225e004f1435599853690499ddb1"
  family: "70796f5a11cd285815033be4fef34a70"
  copies: 12
  name: "MoonThatCommunityLaunch"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: none
  who_acts: "owner (renounced, see note) / rescue functions"
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
  note: "No update path; claim dies for good but this is a distribution/claim contract holding no pre-existing user deposits -> MEDIUM."
---

## Summary

ImmutableOracleSigned._isValidSignature uses SignatureChecker.isValidSignatureNow against an immutable oracle address set at deployment, no setter. claim() mints/distributes allocation (not a pre-funded escrow per user); rescueERC20/rescueETH exist as owner-gated sweep functions independent of the signature, though owner() reads as the zero address in facts (getters.owner()=['0']), so that specific rescue path may itself be dead -- the contract still holds no user deposits by design (a claim/launch contract), which is what keeps this at MEDIUM rather than HIGH.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ImmutableOracleSigned _isValidSignature: SignatureChecker on the oracle signer fixed at deployment. Read (function text).
- Update path, read at block 26,438,999: delegates to a fixed address.
- ImmutableOracleSigned.sol:67-77 (SignatureChecker.isValidSignatureNow), constructor-set oracle_, no setter (dossier source)
- facts.json: exits=[claim(bytes32), rescueERC20, rescueETH, transferOwnership], getters.owner()=['0']
- facts.json: setters=[transferOwnership(address)], upgrades=[]

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 12 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy a new launch contract with a fresh oracle signer.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
