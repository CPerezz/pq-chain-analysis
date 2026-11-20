---
id: simplemultisig-288f0a16-wallets-fixed-signers
title: "SimpleMultiSig: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x288f0a16b4c85f790ce8ca595ba1922f94b7c9fa"
  family: "defc300f3f461b49d98326ae22b7aa70"
  copies: 32
  name: "SimpleMultiSig"
  upgradeable: "no"
  rating: HIGH
  value_usd: 277
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the wallet signers"
evidence:
  level: source-read
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

SimpleMultiSig (solc 0.5, 3 of 4 owners) whose owners are set at deployment. Every execute needs 3 ecrecovered owner signatures, so an owner whose account gets code blocks the wallet for good.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig execute: threshold owners, set at deployment; no function changes them. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source/SimpleMultiSig.sol (dossier defc300f): SimpleMultiSig execute: threshold signatures recovered by ecrecover, strictly increasing, each isOwner; owners set only in the constructor; only nonce changes after deployment
- threshold()=3, ownersArr = 4 owners (latest)
- Signers 0x040976dfb070086fCD1140696768207Fc6C0716B, 0x2D093A9df3613518cd9a17Fa0028c5F63e12b40E, 0x69148ba058E51106De9a3758493C47302674e8B0, 0xFC658Fb33c4bB257b82e222CDa96c2EF39C1f927: all EOAs, no code (latest, block ~26452917); value_usd 277, txs_90d 0, last_active None (row)

## Impact and exposure

- Value held at block 26,438,999: $277 (ETH and 49 priced tokens, over 32 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Signers move the funds to a new wallet (or PQ-ready account) before any signer key gets real code; the contract itself cannot be fixed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
