---
id: 003227f9-fixed-signer
title: "0x003227f9: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x003227f9ae0460385f929b1f6e87292c6c0d16f3"
  family: "3840892fd5efdddd384eb1d9b2d37384"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "deployer/owner (mint liveness only)"
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
  note: "No proxy/setter for the signer (facts: setters only transferOwnership, upgrades: none); mint failing collects no funds (revert, nothing escrowed) and any ETH already collected is owner-withdrawable, so impact is liveness/operator-only, not user funds locked."
---

## Summary

NFT/token launchpad mint gated by an EIP-712 voucher: the contract recovers the signer with ecrecover and reverts the mint unless it equals a hardcoded address; EIP-8151 makes every such mint revert once that address ever gets code (7702 or a contract).

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Function surface matches the template idiom: a payable mint-style function plus an owner-only withdraw-type exit, ERC721/1155 transfer surface, and renounce/transferOwnership only (facts.functions, facts.exits)
- heimdall's Solidity reconstruction of the signature-checking function is garbled (wrong arg count/mutability), the same failure mode seen on the independently-verified template's own mint() — the exact signer constant could not be isolated for this copy
- facts.setters = [transferOwnership(address)] only; facts.upgrades = [] -> no proxy slot, no setter for a signer
- facts.exits = ['transferOwnership(address)', 'withdraw(address)']: owner-withdraw exit present, so any ETH already collected stays recoverable

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a replaceable signer (storage + setter) or move signature checks off-chain before EIP-8151 activates; no on-chain fix is available for the deployed contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
