---
id: nestshareoft-cbd5eb27-rotate-signer-before-migrating
title: "NestShareOFT: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: none
contracts:
- address: "0xcbd5eb27176db6b261196ed3431a612e0b5a82f6"
  family: "563a3bfc4ae404ab77614901519baeba"
  copies: 25
  name: "NestShareOFT"
  label: "deployed by Nest: Deployer"
  upgradeable: "no"
  rating: LOW
  value_usd: 11549
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 411
  last_active: 2026-11-17
fix:
  layer: none
  who_acts: "token holders (use approve)"
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
  note: "LOW rests on the direct approve path (signed shortcut lost), not on rotation: the rotation setter is uncallable, but the signer is unset, so nothing depends on it. txs_90d 411, totalSupply 0 at this copy."
---

## Summary

NestShareOFT has an OpenZeppelin 5 permit (signer must be the named owner), plus an ERC-1271 isValidSignature that recovers against a stored strategistSigner. EIP-8151 kills permit for owners with code, but approve stays open; the strategist path is already off.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: isValidSignature: the recovered address must be the stored strategist signer, for registered callers only / OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call / solmate…. Read from source.
- NestShareOFT.sol:343-344 isValidSignature returns 0xffffffff when strategistSigner==0; strategistSigner()=0x0 at the block
- setStrategistSigner (:303) is requiresAuth; owner()=0x0 and authority()=0x0 at the block, so nobody can call it
- Standard OZ5 ERC20Permit: approve is the direct path for the same owner

## Impact and exposure

- Value held at block 26,438,999: $11,549 (ETH and 49 priced tokens, over 25 addresses).
- Activity: 411 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Owners with code call approve directly instead of permit.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
