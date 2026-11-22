---
id: e8528c31-fixed-signer
title: "0xe8528c31: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xe8528c3139b571c8a306c08c4a6861d47622b968"
  family: "0d13ed0f8ca762dddd7525aee9d351f2"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 4
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "operator: redeploy the helper and repoint its consumers"
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
  note: "no update path; only a helper function stops by design, any ETH is the operator's own prepaid oracle fee (value $4, txs_90d 0, last_active None) -> MEDIUM"
---

## Summary

Contract built on the Oraclize random-DS API; __callback accepts the random number only if the Ledger proof verifies, and safer_ecrecover forwards a constant 3000 gas to 0x01, so under EIP-8151 every proof fails from activation (and the fixed Ledger key could never be rotated). This is a randomness/oracle helper: only its request/answer function stops; it holds no users' funds.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Oraclize verifySig: the recovered address must be the address of the public key carried in the proof; the result flag of the precompile is ignored / Oraclize safer_ecrecover: a…. Same code idiom as template 0fa7b998, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- bytecode at block 26438999 contains the Oraclize LEDGERKEY (7fb95646…96e4) used by oraclize_randomDS_proofVerify, and the safer_ecrecover call to address 0x01 with a constant 3000 gas (PUSH2 0x0bb8; template EtherFlip.sol line 985 call(3000, 1, 0, size, 128, size, 32))
- the fixed signer is the Ledger key hard-coded in the code, address 0xb42e5cc3caa9fecf5d46466cc829b89a551aad6f (keccak of the key): cast code at 26438999 returns 0x (an EOA); no setter, no proxy slot, no upgrade function (row.upgradeable = no)
- random-number helper (public functions only update/generate/getRandomNumber/doCall/test-style requests); no user deposits, any ETH held is the deployer's prepaid oracle fee with no withdraw (heimdall decompile, functions named via _selectors.json)

## Impact and exposure

- Value held at block 26,438,999: $4 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Redeploy the helper with a verifier that does not forward a fixed 3000 gas to 0x01.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
