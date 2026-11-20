---
id: naffitilaunchpadsign721-0f282e67-fixed-signer
title: "NaffitiLaunchPadSign721: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0f282e67eeefaf7b5c860a74dc1734cdf5e31b02"
  family: "09e5c6212da42884b135135f82b1086d"
  name: "NaffitiLaunchPadSign721"
  label: "Asia Crypto Girls: ACG Token"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 3158
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "deployer/owner (mint liveness only)"
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
  note: "No proxy/setter for the signer (facts: setters only transferOwnership, upgrades: none); mint failing collects no funds (revert, nothing escrowed) and any ETH already collected is owner-withdrawable, so impact is liveness/operator-only, not user funds locked."
---

## Summary

NFT/token launchpad mint gated by an EIP-712 voucher: the contract recovers the signer with ecrecover and reverts the mint unless it equals a hardcoded address; EIP-8151 makes every such mint revert once that address ever gets code (7702 or a contract).

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: launchpad mint: the signer must be SIGNER, fixed in the code. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Signer recovered: verified source `NaffitiLaunchPadSign721.sol`: `mint()` line 112 `if (recoverAddress != SIGNER) revert InvalidSignature();`, SIGNER is `address public immutable` (line 32)
- Signer address 0x9869dA58362A75F215b500e1698B1E29AF275f67 has no code today (`cast code` -> 0x): defect latent, will trigger if that key is ever 7702-delegated or deployed to
- facts.setters = [transferOwnership(address)] only; facts.upgrades = [] (no proxy slot) -> no way to rotate the signer
- facts.exits includes withdraw() gated onlyOwner -> any ETH already collected stays withdrawable by the owner

## Impact and exposure

- Value held at block 26,438,999: $3,158 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy with a replaceable signer (storage + setter) or move signature checks off-chain before EIP-8151 activates; no on-chain fix is available for the deployed contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
