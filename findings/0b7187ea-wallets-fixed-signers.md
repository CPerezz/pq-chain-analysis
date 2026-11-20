---
id: 0b7187ea-wallets-fixed-signers
title: "0x0b7187ea: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x0b7187ea07d75009f079b1b63b2dec71ccd055bb"
  family: "1247b4675a669dd08ef87f518acfc150"
  copies: 28
  upgradeable: "no"
  rating: HIGH
  value_usd: 1401
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
  note: "No update path; the signer set is fixed and every outflow needs at least one ecrecovered signer: HIGH. Not settled from the decompile: whether msg.sender counts as one confirmation (either way ≥1 signature is needed). Value $1401, txs_90d 0; value does not lower the rating."
---

## Summary

A multisig (confirmations, required, signers mapping; no source): ETH and ERC-20 transfers need a signer caller and ecrecovered signer signatures up to `required` = 2. The signer mapping is written only by the constructor.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: multisig (confirmations, required, signers): each recovered address must be in a signer set that no function writes after deployment (decompiled). Bytecode and names (no source).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall decompile: both transfer functions (0x0e537b8a ETH, 0xed266490 ERC-20) require signers[msg.sender] and loop over ecrecover, requiring signers[recovered]; runtime SSTOREs are only the per-tx used flag (2 sites), so no signer setter; no proxy
- Constructor args from creation tx 0xcd5ac586… (block 8782552; receipt contractAddress = this row): signers 0x079fd0af… (creator, n4), 0x33b80a3b… n0, 0xd83203d5… n0, required 2; all EOAs (code at latest, block ~26452952; the set is unsettable)
- required() = 2 (batch facts at 26438999); holdings ≈0.42 ETH plus DFLY dust (etherscan snapshot 2026-11-19)

## Impact and exposure

- Value held at block 26,438,999: $1,401 (ETH and 49 priced tokens, over 28 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Owners move the funds to a new wallet before any signer account gets real code; long term, a new wallet that accepts code-bearing signers (ERC-1271) or no longer relies on ecrecover.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
