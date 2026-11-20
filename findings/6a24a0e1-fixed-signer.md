---
id: 6a24a0e1-fixed-signer
title: "0x6a24a0e1 (tagged deployed by The Everyones: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6a24a0e1b8ad337827b1339efad627dba6926d21"
  family: "a60dcbd52b503856254fed04a337f791"
  label: "deployed by The Everyones: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator or owner deploys a new sale contract with a new signer and approves it from the vault."
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
  note: "Rated MEDIUM because only the signed sale of new tokens stops. No user funds would be locked."
---

## Summary

The signer is a hardcoded constant with 0 bytes of code today, so it is a plain EOA. If that key's account ever gets real code, allowlist mints stop working. Nothing gets locked: ETH from completed sales can be withdrawn by the owner, and the NFTs stay in the vault.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- The signer is `address public constant ALLOWLIST_SIGNER = 0x4BBF...E6aF`, a constant.
- isAllowlisted compares the raw ecrecover result to ALLOWLIST_SIGNER. There is no code-size check and no ERC-1271 path.
- The constant's address has code_bytes=0 and is not delegated, so it is a plain EOA.
- The contract is not upgradeable, and none of the setters touch the signer.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new sale contract with a signer that can be replaced, or one that accepts ERC-1271 signatures. Then approve the new contract from the vault.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
