---
id: nameregistry-c295c2cf-rotate-signer-before-migrating
title: "NameRegistry: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xc295c2cf67c2f9811f9815db5cf0f99e0312dcf6"
  family: "301e717e3ead24a0657f5f64bc8ebfc4"
  copies: 5
  name: "NameRegistry"
  upgradeable: "no"
  rating: LOW
  txs_90d: 1212
  last_active: 2026-11-17
  recoveries_14d: 60
fix:
  layer: onchain-config
  who_acts: "owner 0x8c5EE3f9 (EOA, nonce 673)"
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
  note: "The setter is callable by a live EOA owner."
---

## Summary

Oxide NameRegistry. claimName/changeName need an EIP-712 authorization recovered to the stored domainOwner. Under EIP-8151 a domainOwner with code blocks name claims.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: the recovered address must be the stored signer, or be in a stored set or role of signers. Read from source. Executed: a real transaction reverts with code at the signer.
- NameRegistry.sol:103 ECDSA.recover(...) != domainOwner reverts
- updateDomainOwner onlyOwner (OZ Ownable, line 39)
- probed owner 0x8c5EE3f9 EOA nonce 673 at 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 5 addresses).
- Activity: 1,212 transactions called it in the 90 days before that block; last on 2026-11-17.
- 60 signature recoveries in the study's two-week trace window.

## Remediation

The owner calls updateDomainOwner with a fresh EOA key (address(0) also disables the check).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
