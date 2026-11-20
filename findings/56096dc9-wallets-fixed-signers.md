---
id: 56096dc9-wallets-fixed-signers
title: "0x56096dc9: wallet with signers fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x56096dc9d92b32dd8fa530240537d3d61dd363bb"
  family: "2798368df6be3272bc3ae308722943fa"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "deployer 0x6dac636f… (redeploy verifier / consumer swaps verifier)"
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
  rating: MEDIUM
  note: "MEDIUM: no update path, but it is a pure verifier holding no money by design; only the verification function dies. Consumer contract not identified (no txs to it); if a consumer cannot swap verifiers and locks user funds, it would rate on its own. Batch row: value_usd null, txs_90d 0, last_active null."
---

## Summary

Verified LatticeSdnPolicyVerifier (deployed 2026-10-18): verifyPolicy(bytes,bytes) accepts an attestation only if ecrecover returns a registered attester; threshold 1; attester registry written only in constructor, no setter. If the attester key takes code, verifyPolicy returns false forever.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: SimpleMultiSig: every signature must recover to an owner, in ascending order; the caller does not count; no function changes the owners. Same code idiom as template 8f5fee6f, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Constructor args (creation tx 0xf25a6126…): threshold 1, rule version 0x3281b6…, maxAttestationAge 7200, attester 0x53cf9ed562f450afbf2ce4e0460049c035e22790
- isRegisteredAttester(0x53cf…2790) = true at 26438999; attester has no code, nonce 0 (reth, latest)
- No setter selectors (only verify/decode/debug views); one STATICCALL to 0x01 with GAS (no fixed gas); holds 0 ETH

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new verifier with a replaceable attester and point the consumer at it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
