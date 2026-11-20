---
id: 43f81668-fixed-signer
title: "0x43f81668: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x43f816682850b1e7ac8b075aa1bd2ba309acf5c9"
  family: "0a5d2425bc17fba3a96614fd828b7ada"
  upgradeable: "no"
  rating: LOW
  value_usd: 11
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "anyone: call the public __timeout() after the oracle deadline"
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
  rating: LOW
  note: "the same act stays open by another path: public __timeout() emits GeneratedStaticSupply without the proof -> LOW"
---

## Summary

Contract built on the Oraclize random-DS API; __callback accepts the random number only if the Ledger proof verifies, and safer_ecrecover forwards a constant 3000 gas to 0x01, so under EIP-8151 every proof fails from activation (and the fixed Ledger key could never be rotated). The proof only gates the random per-day supply generation, and the public __timeout() generates a static supply for that day without the oracle.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a…. Same code idiom as template 0fa7b998, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode at block 26438999 contains the Oraclize LEDGERKEY (7fb95646…96e4) used by oraclize_randomDS_proofVerify, and the safer_ecrecover call to address 0x01 with a constant 3000 gas (PUSH2 0x0bb8; template EtherFlip.sol line 985 call(3000, 1, 0, size, 128, size, 32))
- the fixed signer is the Ledger key hard-coded in the code, address 0xb42e5cc3caa9fecf5d46466cc829b89a551aad6f (keccak of the key): cast code at 26438999 returns 0x (an EOA); no setter, no proxy slot, no upgrade function (row.upgradeable = no)
- __timeout(): public, requires the awaited deadline < block.timestamp and supply not yet generated, then sets storage_map_b[day] = 1e18 * store_d and emits GeneratedStaticSupply (heimdall decompile)

## Impact and exposure

- Value held at block 26,438,999: $11 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Call __timeout() after the deadline for any pending generation day; no redeployment needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
