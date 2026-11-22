---
id: 3307c77f-wallets-fixed-signers
title: "0x3307c77f (tagged Amina Deposit): wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x3307c77fcef08bbac57e324e44ac0d7aa53bb9d3"
  family: "2cc5a26573621c6090693af26117eedd"
  copies: 283
  label: "Amina Deposit"
  upgradeable: "no"
  rating: HIGH
  value_usd: 27
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 4
  last_active: 2026-11-12
  recoveries_14d: 3
fix:
  layer: new-deployment
  who_acts: "the wallet signers"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-wallets-fixed-signers"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "No setter for the signer set, no ERC-1271/code check, not a proxy and no upgrade function; every outflow needs an ecrecovered signer signature, so a fixed signer with code locks the funds. Moving funds out beforehand is a migration step, not a way out."
---

## Summary

Unverified SimpleMultiSig variant (EIP-712 execute, 3 of 7 owners). Owners are fixed, signatures are recovered in increasing order, and no owner setter exists.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: 283 multisig wallets with ordered owner signatures; no function name that changes owners. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Selectors: execute(uint8[],bytes32[],bytes32[],address,uint256,bytes,address,uint256), getOwners, isOwner, threshold, nonce, domain constants; revert strings SIGNERS MUST BE IN INCREASING ORDER / WRONG SIGNATURE / WRONG EXECUTOR; no setter, no 1626ba7e
- getOwners() = 7 owners, threshold 3 (row facts at 26438999, confirmed latest)
- Signers 0x04eee06b3ba32a8761bab9eac6c66feafadfdb33, 0x1fa33f1dff64c18204aa069b08279c493f8decb7, 0x39405231e8961ad671ad985ac7b6c654516c06c3, 0x739e28732768f0a0eadb92e20f684581c8c89b80, 0x95454b0ab530f7a3590f414f3f0429d48835af2f, 0xafb58c125454ef980c110a2cd5979a71684db601, 0xdfbda4e1e357e332880407adf8cd463abfab69b2: all EOAs, no code (latest, block ~26452917); value_usd 27, txs_90d 4, last_active 2026-11-12 (row)

## Impact and exposure

- Value held at block 26,438,999: $27 (ETH and 49 priced tokens, over 283 addresses).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-11-12.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

Signers move the funds to a new wallet (or PQ-ready account) before any signer key gets real code; the contract itself cannot be fixed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
