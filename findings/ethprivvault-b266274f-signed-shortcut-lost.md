---
id: ethprivvault-b266274f-signed-shortcut-lost
title: "EthPrivVault: signed shortcut lost by users with code"
status: not-affected
severity: NONE
patterns: [PQ-19]
impact: none
contracts:
- address: "0xb266274f55e784689e97b7e363b0666d92e6305b"
  family: "c7c9035ea874e025a3697993ea71016d"
  copies: 8
  name: "EthPrivVault"
  upgradeable: "yes"
  rating: NONE
  value_usd: 39520
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 66
  last_active: 2026-11-17
fix:
  layer: none
  who_acts: "validators manager"
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
  verdict: refuted
  rating: NONE
  note: "A signer with code is handled by ERC-1271 and by the direct call → refuted (LOW at worst). value 39520"
---

## Summary

StakeWise private ETH vault: registerValidators accepts a call from the validators manager or a manager signature checked with OpenZeppelin SignatureChecker.

## Mechanism

PQ-19. A user whose account has real code loses the signed path only; gasless and relayed flows stop for that user.

## Evidence

- How it was placed: StakeWise registerValidators: the validators manager calls itself, or its signature is checked with SignatureChecker (ECDSA, then ERC-1271). Read from source.
- registerValidators: msg.sender == validatorsManager OR SignatureChecker.isValidSignatureNow(validatorsManager, ...) (VaultValidators.sol:69-90)
- SignatureChecker falls back to ERC-1271 when ECDSA fails, so a manager with code that implements ERC-1271 still passes (SignatureChecker.sol:22-30)
- setValidatorsManager is admin-only (VaultValidators.sol:118-121)

## Impact and exposure

- Value held at block 26,438,999: $39,520 (ETH and 49 priced tokens, over 8 addresses).
- Activity: 66 transactions called it in the 90 days before that block; last on 2026-11-17.

## Remediation

None needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signed-shortcut-lost` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
