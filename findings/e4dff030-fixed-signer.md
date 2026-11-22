---
id: e4dff030-fixed-signer
title: "0xe4dff030: signer fixed in code"
status: confirmed
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xe4dff030976cb5e8606e4138a1cd57b4131f9e8b"
  family: "31d2bf462edc902cdbb43802dbf7f824"
  upgradeable: "no"
  rating: HIGH
  value_usd: 36
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody can act: no admin path releases the stakes"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "no update path and no way out for users' funds (value $36, txs_90d 0, last_active None) -> HIGH; value and activity do not lower it"
---

## Summary

Contract built on the Oraclize random-DS API; __callback accepts the random number only if the Ledger proof verifies, and safer_ecrecover forwards a constant 3000 gas to 0x01, so under EIP-8151 every proof fails from activation (and the fixed Ledger key could never be rotated). Players' stakes or pools are paid only through the oracle callback and no other function moves them, so they lock.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a…. Same code idiom as template 0fa7b998, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode at block 26438999 contains the Oraclize LEDGERKEY (7fb95646…96e4) used by oraclize_randomDS_proofVerify, and the safer_ecrecover call to address 0x01 with a constant 3000 gas (PUSH2 0x0bb8; template EtherFlip.sol line 985 call(3000, 1, 0, size, 128, size, 32))
- the fixed signer is the Ledger key hard-coded in the code, address 0xb42e5cc3caa9fecf5d46466cc829b89a551aad6f (keccak of the key): cast code at 26438999 returns 0x (an EOA); no setter, no proxy slot, no upgrade function (row.upgradeable = no)
- LuckyStrike: only partial exits (owner withdrawFromMarketingFund for the marketing share, getReward for credited rewards, payDividends to the token contract); jackpot pools are paid only through the oracle draw (heimdall decompile, functions named via _selectors.json)

## Impact and exposure

- Value held at block 26,438,999: $36 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None on-chain; funds already in the contract stay locked, and users should stop depositing.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
