---
id: 4cea4d98-wallets-fixed-signers
title: "0x4cea4d98: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x4cea4d98de087d4b8444bdbf5921cfe59d021de7"
  family: "b143c5b355e985a44796d8293659a6e5"
  copies: 56
  upgradeable: "no"
  rating: HIGH
  value_usd: 121
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
  note: "Init already done (requiredSignatures=2, owners set), so this is not an uninitialized implementation. Fixed signers, no other exit: HIGH. This is a different contract from the claimed template, but it has the same fixed-signer property."
---

## Summary

LiteSig (verified, solc 0.5.8), not the SimpleMultiSig template. It has a one-time init (already run) that fixes the owners and requiredSignatures. submit 0x16636745 needs requiredSignatures personal_sign signatures that recover to unique owners. There is no setter and no other exit, so the token holdings (ETH balance 0) are locked once owner keys take code.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Etherscan cache: Verified, Contract Name LiteSig; heimdall: init 0xce7e8fcf 'Init function can only be run once', submit 0x16636745 'Initialization must be complete', 'Signature must be from an owner', 'Signature must be unique', 'Ethereum Signed Message' prefix; only these 2 non-view functions
- at block 26438999: requiredSignatures=2, nonce=7, owners [0x0ed52e8b7d5d02fba03c478dbbadf68e29c61c85, 0xa1928477e339e985d3ec66fee94de7bdd2ac5650, 0xf945a4caa0b206296609b87341166e4d9a9efc3b], ETH balance 0 (value is in tokens); 1967 slots 0
- cast code latest: all owners EOA, nonce 0
- batch row: value_usd 121 (held), txs_90d 0, last_active null, copies 56

## Impact and exposure

- Value held at block 26,438,999: $121 (ETH and 49 priced tokens, over 56 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

2 owners sign a final submit that transfers the tokens to a migratable wallet before key migration.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry (D-025).
