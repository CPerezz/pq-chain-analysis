---
id: 9ca26947-wallets-fixed-signers
title: "0x9ca26947: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x9ca26947b71f9eeae8133d3a7560bfb4d77009b7"
  family: "b2943b9c8d8f85675c1e683ad49e7269"
  upgradeable: "no"
  rating: HIGH
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "wallet owners (move funds to a new wallet before their keys gain code)"
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
  note: "No update path and the fixed owners' signatures are the only way to move the wallet's funds, so this is HIGH. Value $None, txs_90d 0; value does not lower the rating."
---

## Summary

Older Ownbit multisig (Compound variant (mint/redeem actions gated by the same owner-signature check)): every spend needs 2-of-3 distinct owners' ECDSA signatures; owners are set in the constructor and nothing can change them, so if those owner accounts take code, the funds are stuck.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: Ownbit multisig (older): `required` distinct owners by ECDSA; no function changes the owners. Same code idiom as template bd7bb1ad, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- getOwners() at block 26438999: 3 owners, all EOAs today (cast code = 0x); getRequired = 2
- Own runtime bytecode (distinct from the other copies) has no owner setter, and no DELEGATECALL/SELFDESTRUCT outside the metadata; heimdall decompiles of representatives (0x8a1cdd6e, 0x60465097, 0xf8c52a01, 0xa7e0da1f, 0xce2c9338) show every fund-moving selector gated by count>=required and the distinct-owner mapping check over ecrecover results
- EIP-1967 implementation slot is zero; no upgrade function
- Template source readings/bd7bb1ad…/source/OwnbitMultiSig.sol (and cd492812… for the inactivity variant): no addOwner/removeOwner, no ERC-1271

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners sign a spend that empties the wallet to a new PQ-ready wallet before their accounts take code.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
