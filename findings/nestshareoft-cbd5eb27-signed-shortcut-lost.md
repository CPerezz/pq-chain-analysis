---
id: nestshareoft-cbd5eb27-signed-shortcut-lost
title: "NestShareOFT: signed shortcut lost by users with code"
status: confirmed
severity: LOW
patterns: [PQ-19]
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
  layer: offchain
  who_acts: "the affected holder (signer with code)"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signed-shortcut-lost"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Permit has a direct twin. The stored-signer path belongs to a rotate-signer reading if flagged elsewhere. Value $11549, txs_90d 411 (not rating inputs)."
---

## Summary

NestShareOFT: OpenZeppelin 5 / solmate permit (ECDSA must equal owner). A holder with code still calls approve. Its isValidSignature (strategist signer, for whitelisted callers) is a separate stored-key path, not this issue.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: isValidSignature: the recovered address must be the stored strategist signer, for registered callers only / OpenZeppelin 5 permit: ECDSA.recover must equal the owner named in the call / solmate…. Read from source.
- source NestShareOFT.sol: permit via ERC20PermitUpgradeable/solmate; standard approve present
- isValidSignature:337 checks a stored strategistSigner only for signatureChecker[msg.sender]; not the holder's shortcut

## Impact and exposure

- Value held at block 26,438,999: $11,549 (ETH and 49 priced tokens, over 25 addresses).
- Activity: 411 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

Call approve directly.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
