---
id: 04cafaf5-wallets-fixed-signers
title: "0x04cafaf5: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x04cafaf5e1c318f1f229deea3ed5039a87f1a209"
  family: "999a1c55a1e8f693bdfcaaf3b1fe4311"
  copies: 2
  upgradeable: "no"
  rating: HIGH
  value_usd: 200
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "wallet owners"
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
  note: "No setter, no upgrade, a signed spend is the only exit: HIGH. Also missing a nonce (signed spends can be replayed until their deadline), which is not an EIP-8151 issue."
---

## Summary

A 'FintochInvestmentAgent' Ownbit-style multisig (2-of-3) whose two spend functions (0x736a2684 ETH, 0xef6ddaaf ERC-20) carry a deadline and ecrecover the owners. The runtime has no SSTORE at all, so owners can never change.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig: `required` distinct owners must have signed with ECDSA; the caller does not count; no function changes the owners. Same code idiom as template 66d724c3, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Runtime bytecode has zero SSTORE opcodes: owners and required are set in the constructor only (nonce never increments; replay is limited only by the deadline)
- Fork simulation: both spend selectors reach ecrecover 2 times with 2 signatures; with a past deadline they revert 'FintochInvestmentAgent: EXPIRED'
- getOwners at block 26438999: 0x3aad..5a3f, 0x9148..064c, 0xc732..10b6; all EOAs (cast code latest)
- No proxy slots; value $200, 0 txs in 90d

## Impact and exposure

- Value held at block 26,438,999: $200 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners sign spends to a new wallet with replaceable signers before their keys gain code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
