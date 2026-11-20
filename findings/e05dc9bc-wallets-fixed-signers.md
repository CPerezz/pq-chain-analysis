---
id: e05dc9bc-wallets-fixed-signers
title: "0xe05dc9bc: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xe05dc9bc8ec0705328046e3756141261b8f574e2"
  family: "9733b8d82b4a3d2c786481ea9cc25594"
  copies: 31
  upgradeable: "no"
  rating: HIGH
  value_usd: 1604
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
  note: "No update path, and the fixed signers' signatures are the only way to move the wallet's own funds (moving funds out before migrating is a migration step, not a way out): HIGH. Value $1604, txs_90d 0; value does not lower the rating."
---

## Summary

An EIP-1167 clone of 0xe5176064…, a WalletSimple-like wallet: init(address[]) is one-shot (guarded by `initialized`), and sends need a signer caller plus an ecrecovered signer ≠ caller.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: WalletSimple-like wallet (sendMultiSig, isSigner, safeMode, init): the recovered address must be in the signer set written at init; no function writes it later. Bytecode and names (no source).
- Update path, read at block 26,438,999: delegates to a fixed address.
- EIP-1167 code (45 bytes) → 0xe5176064c995adad5ac00e2a592260c434861717; no proxy slots. Implementation (heimdall): only init (selector 0xc6044c46) writes the signer mapping, and it reverts with 'Contract already initialized'; the two send functions need 'Non-signer in onlySigner method' + an ecrecovered 'Invalid signer' ≠ msg.sender; no SELFDESTRUCT
- initialized() = true at 26438999; init was called in creation tx 0xb4a7c4e9… (block 14665406, CREATE2 by factory 0x1c6d6e49…) with 5 signers
- Signers 0x655eb8da… n7, 0x0d6a4901… n9, 0xc83554f9…, 0x342e8b32…, 0x184f218d… (n0): all EOAs, isSigner true at 26438999; balance 0.2 ETH

## Impact and exposure

- Value held at block 26,438,999: $1,604 (ETH and 49 priced tokens, over 31 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move the funds to a new wallet before any signer account gets real code; long term, a new wallet that accepts code-bearing signers (ERC-1271) or no longer relies on ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
