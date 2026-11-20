---
id: 2f4249bf-fixed-signer
title: "0x2f4249bf (tagged deployed by PUNK: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x2f4249bf32f28416891bc43e88b1df37c35faf4b"
  family: "e58d743c39025dc0552cf87e835c0f39"
  copies: 2
  label: "deployed by PUNK: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "deployer/owner (drop-reservation liveness only)"
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

A license/drop-reservation contract (`currentDrop`, `drops`, `getLicenseName/URI`, `publishDrop`, `reservedMint`) that gates an action on an EIP-712-style digest (`actionDigest`); EIP-8151 breaks that signature gate once the signer's address gets code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- decompile shows `actionDigest(bytes32,bytes32,uint256,uint256)` building a domain-separated digest (checks `address(this) == 0x2f4249bf...` then returns `keccak256(...)`), the standard EIP-712 digest-building idiom feeding into a downstream ecrecover check
- heimdall's reconstruction of the caller that recovers and compares the signer is garbled (same failure mode as the verified template); exact signer constant not isolated
- facts.setters = [transferOwnership] only; facts.upgrades = []
- facts.exits = ['transferOwnership(address)', 'withdraw(address)']: withdraw(address) is onlyOwner -> any ETH already collected stays recoverable

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a replaceable signer (storage + setter) or move signature checks off-chain before EIP-8151 activates; no on-chain fix is available for the deployed contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
