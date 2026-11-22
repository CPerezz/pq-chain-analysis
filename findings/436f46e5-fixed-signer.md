---
id: 436f46e5-fixed-signer
title: "0x436f46e5: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x436f46e5704121bfb0f98e01b30e84eb5969720b"
  family: "88ea0504a7301a2bfd5e1fdafb4d51ed"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 6
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator: recover funds via the existing path and redeploy with a non-fixed-gas verifier"
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
  rating: MEDIUM
  note: "no update path; the funds still leave without the proof via an owner/operator or player path (value $6, txs_90d 0, last_active None) -> MEDIUM per the clarified scale"
---

## Summary

Contract built on the Oraclize random-DS API; __callback accepts the random number only if the Ledger proof verifies, and safer_ecrecover forwards a constant 3000 gas to 0x01, so under EIP-8151 every proof fails from activation (and the fixed Ledger key could never be rotated). The oracle-driven function stops for good, but the funds can still leave without the proof.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a…. Same code idiom as template 0fa7b998, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode at block 26438999 contains the Oraclize LEDGERKEY (7fb95646…96e4) used by oraclize_randomDS_proofVerify, and the safer_ecrecover call to address 0x01 with a constant 3000 gas (PUSH2 0x0bb8; template EtherFlip.sol line 985 call(3000, 1, 0, size, 128, size, 32))
- the fixed signer is the Ledger key hard-coded in the code, address 0xb42e5cc3caa9fecf5d46466cc829b89a551aad6f (keccak of the key): cast code at 26438999 returns 0x (an EOA); no setter, no proxy slot, no upgrade function (row.upgradeable = no)
- destroyContract() (store_a only) refunds each entered player then selfdestructs; withdrawFunds(uint256) owner-only for fees (heimdall decompile, functions named via _selectors.json)

## Impact and exposure

- Value held at block 26,438,999: $6 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Use the existing exit to return the funds, then redeploy on an oracle library that calls ecrecover without a fixed gas stipend.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
