---
id: 39a8bd17-fixed-signer
title: "0x39a8bd17 (tagged deployed by The Everyones: Deployer): signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x39a8bd1729439e11d7cdb78872c2a058abc28cf1"
  family: "2b3eecbbf233e075958bb3bb18b7ee11"
  label: "deployed by The Everyones: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator deploys a new sale contract with a new signer."
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
  note: "Rated MEDIUM because only new sales stop. No user funds are held behind the signature."
---

## Summary

The signer is a hardcoded constant that is an EOA today (0 code bytes) and has no setter. If it gets real code, allowlist sales stop. Nothing is locked: ETH can be withdrawn by the owner and the NFTs stay in the vault.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- ALLOWLIST_SIGNER is declared constant 0x303B...67e9
- isAllowlisted compares the plain ecrecover result to ALLOWLIST_SIGNER, with no code check and no ERC-1271
- Row facts: the signer has code_bytes 0 and is not delegated
- withdraw() onlyOwner sends address(this).balance to the owner

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new sale contract with a replaceable signer or ERC-1271 support, and point the vault's approval at it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
