---
id: 2d3f75ce-wallets-fixed-signers
title: "0x2d3f75ce: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x2d3f75cedea57c1bc223af77807fdbdfd5b7ce40"
  family: "39bc549f215c550d64c7be753d3c2d79"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 11
  last_active: 2026-11-09
  recoveries_14d: 6
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
  note: "No setter for the signer set, no ERC-1271/code check, not a proxy and no upgrade function; every outflow needs an ecrecovered signer signature, so a fixed signer with code locks the funds. Moving funds out beforehand is a migration step, not a way out. Holds no value today (value_usd null); rated by mechanism."
---

## Summary

Unverified SimpleMultiSig-style wallet (EIP-712 execute, 3 of 5 owners) with owners fixed in storage and no setter.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: multisig with ordered owner signatures; no function name that changes owners. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Only 6 selectors: execute(uint8[],bytes32[],bytes32[],address,uint256,bytes,address,uint256), permitMessage (view digest), threshold, ownersArr, nonce, getDomainSeparator; no setter, no 1626ba7e, no delegatecall
- threshold()=3, ownersArr = 5 owners (latest)
- Signers 0x3C7812f87709f2aED7b9A09332a3aC1b4b81e00c, 0x4cEa53726B72e55236aE57E40A7eDD697c1746e5, 0x6D597cdbFce6ab1B4344CEDdc67e220F821045a7, 0x6e8891A315D1dbdB76828D0E2230B8108a53FA4D, 0x96caA90104aF85dD5b9cB6B6D28d68cD6D53A2FB: all EOAs, no code (latest, block ~26452917); value_usd None, txs_90d 11, last_active 2026-11-09 (row)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 11 transactions called it in the 90 days before that block; last on 2026-11-09.
- 6 signature recoveries in the study's two-week trace window.

## Remediation

Signers move the funds to a new wallet (or PQ-ready account) before any signer key gets real code; the contract itself cannot be fixed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
