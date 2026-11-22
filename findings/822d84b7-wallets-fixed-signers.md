---
id: 822d84b7-wallets-fixed-signers
title: "0x822d84b7: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x822d84b71e8de35e968cfd77ba9bbdbb570d6a21"
  family: "94bd484f5fe4cd94dc14a3ce66c8af3d"
  copies: 23
  upgradeable: "no"
  rating: HIGH
  value_usd: 2400
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "wallet owners (move funds to a new wallet before their keys gain code)"
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
  note: "No update path, and the fixed signers' signatures are the only way to move the wallet's own funds (moving funds out before migrating is a migration step, not a way out): HIGH. Value $2400, txs_90d 0; value does not lower the rating."
---

## Summary

A SimpleMultiSig-style ETH wallet (execute(uint8[],bytes32[],bytes32[],address,uint256,bytes)): `threshold` strictly ordered ecrecovered owner signatures, owners fixed at deployment.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: 23 multisig wallets with ordered owner signatures and no way to change owners. Bytecode and names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall decompile: 'only threhold number of sigs required', 'only owners can sign', 'strictly ordered signatures required'; the transfer happens only after the signature loop
- SSTORE scan: only the nonce (slot 0) is written at runtime; no owner setter, no proxy, no DELEGATECALL/SELFDESTRUCT
- At 26438999: threshold 3, nonce 11, ownersArr 0x17399e47…, 0x5D5Ed85f…, 0xc2EABA45…, all EOAs n0

## Impact and exposure

- Value held at block 26,438,999: $2,400 (ETH and 49 priced tokens, over 23 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move the funds to a new wallet before any signer account gets real code; long term, a new wallet that accepts code-bearing signers (ERC-1271) or no longer relies on ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
