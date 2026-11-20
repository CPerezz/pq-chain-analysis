---
id: stakingvault-1dd7a3c1-signer-upgrade-only
title: "StakingVault: signer replaceable only by an upgrade"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x1dd7a3c16dd40b468da6aca95878869ce964c10b"
  family: "fe3599da3ff25dd04c16809e66e74fb7"
  copies: 1131
  name: "StakingVault"
  label: "deployed by Asterixlabs: Deployer"
  upgradeable: "no"
  rating: NONE
  txs_90d: 4
  last_active: 2026-10-03
fix:
  layer: none
  who_acts: "none"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signer-upgrade-only"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "accepts ERC-1271 for the expected signer"
---

## Summary

Solady ERC6551/ERC1271 account clone (StakingVault family); its signer is owner() = the NFT holder: the signer is checked with SignatureChecker or Solady SignatureCheckerLib, which falls back to that same signer's ERC-1271 once it has code.

## Mechanism

PQ-17. Once that key's account has real code, the signed functions stop until the admin upgrades.

## Evidence

- How it was placed: Solady ERC1271 account: SignatureCheckerLib on the account's signer / Solady ERC1271 nested EIP-712 (variant): SignatureCheckerLib on the account's signer / Solady ERC1271 RPC path (variant). Read from source.
- Update path, read at block 26,438,999: delegates to a fixed address. 1 with an upgrade function whose caller was not read.
- The signature check goes through SignatureChecker(Lib).isValidSignatureNow(signer, …), with an ERC-1271 fallback on the signer (dossier source)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 1,131 addresses).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-10-03.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signer-upgrade-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
