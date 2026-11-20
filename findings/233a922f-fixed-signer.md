---
id: 233a922f-fixed-signer
title: "0x233a922f (tagged deployed by SharkBee: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x233a922f203b2eb705b833cf147979556eae7a45"
  family: "63c1c71a31fd6ef20ef9c895f7fe346f"
  label: "deployed by SharkBee: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "deployer/owner (liveness only)"
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
  note: "Owner-reachable withdrawToken(uint256) is a way out for the contract's own balance even though claims stop, so impact is liveness/operator-recoverable rather than a hard lock."
---

## Summary

An options/claim contract (`claimActive`, `hasClaimed`, `isClaimed`, `options`) gated by a fixed signer; EIP-8151 stops new claims once that address gets code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Same code idiom as template 09e5c621, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- facts.functions include claimActive/hasClaimed/isClaimed/options/withdrawToken(uint256), consistent with a signature-gated claim idiom
- heimdall's reconstruction of the gating function is garbled; exact signer constant not isolated
- facts.setters = [transferOwnership] only; facts.upgrades = []
- facts.exits = ['isClaimed(address)', 'transfer(address,uint256)', 'transferOwnership(address)', 'withdrawToken(uint256)']: withdrawToken(uint256) gives the owner a way to pull the token balance out regardless of claim state

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a replaceable signer (storage + setter) or move signature checks off-chain before EIP-8151 activates; no on-chain fix is available for the deployed contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
