---
id: 28a203d7-wallets-fixed-signers
title: "0x28a203d7: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x28a203d71d96b80b48e15d9d6e6e08998d62b180"
  family: "62a1e2cdb87c3c3640415fd4f19be320"
  copies: 4
  upgradeable: "no"
  rating: HIGH
  value_usd: 2
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "the wallet's owners (2 of 3 EOAs)"
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
  note: "Fixed owners (only the nonce is ever written), no other exit: HIGH, rated by mechanism despite the $2 value."
---

## Summary

A custom multisig, not the template's code. execute 0xed516d51 takes packed 65-byte signatures (threshold*65), and each signature must ecrecover (personal_sign prefix) to an address in the isOwner map ('WTF5007'). The runtime has a single SSTORE (the nonce) and no setter, so the owners are fixed and the 0.001 ETH is locked once owner keys take code.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall: only non-view function 0xed516d51(…, bytes sigs); require(threshold,'WTF5005'), require(sigs.length>=threshold*65,'WTF5006'), require(isOwner[ecrecover(...)],'WTF5007'); opcode scan of the runtime: 1 SSTORE, 1 CALL, no DELEGATECALL/SELFDESTRUCT
- at block 26438999: threshold=2, nonce=0, owners [0x5210f72ae9d90138a091c21f4284d209a69847db, 0x6166dafabb70051c794e183b183fe5d64c046daa, 0xb15c804f1765bb85ad02efd98bcb797d93700c46], balance 0.001 ETH; 1967 slots 0
- cast code latest: all owners EOA (nonces 26/27/4)
- batch row: value_usd 2, txs_90d 0, last_active null, copies 4

## Impact and exposure

- Value held at block 26,438,999: $2 (ETH and 49 priced tokens, over 4 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Final 2-of-3 execute moving the funds to a migratable wallet before key migration.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
