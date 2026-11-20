---
id: semimodularaccountbytecode-836e1a84-7702-own-key-only
title: "SemiModularAccountBytecode: 7702 logic that accepts only the account's own key"
status: not-affected
severity: NONE
patterns: [PQ-20]
impact: none
contracts:
- address: "0x836e1a843e6240211cf1a7b75511dd44543aff7f"
  family: "e51591bf69e315d65e34b21cafa00c64"
  copies: 3924
  name: "SemiModularAccountBytecode"
  label: "created by Alchemy: Account Factory"
  upgradeable: "yes"
  rating: NONE
  value_usd: 1416399
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 14207
  last_active: 2026-11-18
  recoveries_14d: 2064
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
  ref: "triage entry eip-8151-7702-own-key-only"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "This is not a 7702 own-key account: it runs behind ERC-1967 proxies with an external owner, and a signer that holds code is already handled by the ERC-1271 signature type (and updateFallbackSignerData can rotate it). Refuted by the rule"
---

## Summary

SemiModularAccountBytecode: an Alchemy modular account behind ERC-1967 proxies whose owner is an external address; an owner with code can use the CONTRACT_OWNER (ERC-1271) signature type.

## Mechanism

PQ-20. As a 7702 delegation they keep working: EIP-8151 exempts delegation indicators. An account that takes this logic as real code can no longer authorise anything, and with code it cannot send transactions (EIP-3607), so what it holds is locked.

## Evidence

- How it was placed: Alchemy SemiModularAccount: the fallback signer (the account itself until it is changed) signs with ECDSA, or, flagged as a contract owner, is asked through ERC-1271. Read from source. Executed: a real transaction reverts with code at the signer.
- SemiModularAccountBytecode _checkSignature (SemiModularAccountBase.sol 168-184): EOA type requires tryRecover == owner; CONTRACT_OWNER type calls SignatureChecker.isValidERC1271SignatureNow(owner,...); the owner is an external address appended to the proxy bytecode, not address(this)/source (dossier e51591bf69e315d65e34b21cafa00c64)
- Study note: Alchemy SemiModularAccount: the fallback signer (the account itself until it is changed) signs with ECDSA, or, flagged as a contract owner, is asked through ERC-1271. Read from source. Executed: a real transaction revert
- Activity (measured): txs_90d 14,207, last_active 2026-11-18, value_usd 1416399

## Impact and exposure

- Value held at block 26,438,999: $1.4M (ETH and 49 priced tokens, over 3,924 addresses).
- Activity: 14,207 transactions called it in the 90 days before that block; last on 2026-11-18.
- 2,064 signature recoveries in the study's two-week trace window.

## Remediation

Delegates must not be offered as real-code migration targets; accounts keep the delegation or move to logic with another key.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-7702-own-key-only` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
