---
id: teavaultv2-49811020-rotate-signer-before-migrating
title: "TeaVaultV2: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x49811020c8f25de1d8d03ef2c9cdbe5be8fb07a1"
  family: "34f84caf0cb0f54809cde04f08abb611"
  copies: 17
  name: "TeaVaultV2"
  label: "deployed by Teahouse HighTable: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 40783
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 36
  last_active: 2026-11-16
fix:
  layer: onchain-config
  who_acts: "owner 0x0392…6Ac0"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "The only missing fact was whether the controlling party is live: its owner 0x0392feaa5ace1e5ef5446857b2ccdfc03a626ac0 is a Safe 1.3.0 with 5 owners and threshold 2, read at the latest block (26,455,6xx; the node was down). Live by Anon's rule of 2026-11-20 (a key is presumed live unless shown lost), so it can rotate the signer or upgrade the code: LOW. Earlier doubt: setters exist (owner-gated); RPC (reth.dappnode) timed out on all nonce/codesize reads late in the run; liveness of the controlling party not verified (owner nonce/code). Missing read: cast nonce/codesize --block 26438999 0x0392FeAA5ACE1e5EF5446857b2CcdFc03a626Ac0 (owner)."
---

## Summary

TeaVaultV2: its ERC-1271 isValidSignature accepts an ECDSA signature by owner() or by config.manager; if either account takes code, the vault's 1271 rejects it.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source.
- TeaVaultV2.sol:273-285 tryRecover, signer == owner()
- (allowManagerSignature && signer == config.manager)
- assignManager onlyOwner (line 81); owner replaceable via Ownable transferOwnership
- owner() at block = 0x0392FeAA5ACE1e5EF5446857b2CcdFc03a626Ac0

## Impact and exposure

- Value held at block 26,438,999: $40,783 (ETH and 49 priced tokens, over 17 addresses).
- Activity: 36 transactions called it in the 90 days before that block; last on 2026-11-16.

## Remediation

replace the checked key via the setter before the key account takes code

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
