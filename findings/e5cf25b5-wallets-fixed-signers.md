---
id: e5cf25b5-wallets-fixed-signers
title: "0xe5cf25b5: wallet with signers fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xe5cf25b503ca5cf7779ad7af9f320b1db1354eb2"
  family: "d688310792885db893bfaabe001f819a"
  copies: 30
  upgradeable: "no"
  rating: HIGH
  value_usd: 343
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
  note: "Template check, fixed owners, no other exit: HIGH."
---

## Summary

SimpleMultiSig (verified on Etherscan as SimpleMultiSig, solc 0.5.10, similar match to 0xf3ba64eb…). execute 0xa0ab9653 needs exactly `threshold` signatures recovering to owners in ascending order ('order' revert), and the owners are fixed. 0.168 ETH is locked once owner keys take code.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Etherscan cache: Verified, Contract Name SimpleMultiSig; selectors threshold/execute/ownersArr/nonce; heimdall: require(sigs==threshold,'threshold'), executor check, require(...,'order') on the ecrecover result; no setter
- at block 26438999: threshold=2, nonce=2, owners [0x88a622666aff6986e5a802f3f116e7e1bf883edb, 0xaea5858af39c183cea15cde06aa12b8bea8ddb43, 0xcb1470bd0e7122692d7e605ae986403defb25a2e], balance 0.1682 ETH; 1967 slots 0
- cast code latest: all owners EOA, nonce 0
- batch row: value_usd 343, txs_90d 0, last_active null, copies 30

## Impact and exposure

- Value held at block 26,438,999: $343 (ETH and 49 priced tokens, over 30 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Final 2-of-3 execute moving the funds to a migratable wallet before key migration.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
