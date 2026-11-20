---
id: lpfstore-86595e49-fixed-signer
title: "LPFStore: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x86595e4950634c7f2a94a67d112cc11c3c1a2309"
  family: "79765b818fd5b393f502d0968a37b16d"
  name: "LPFStore"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-09-06
fix:
  layer: new-deployment
  who_acts: "operator (owner 0xb7cf8fd3…, live EOA)"
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
  note: "Signed NFT mint, nothing held by the contract: the function dies for good but nothing is locked. Buyers pay off-chain, so an unfilled paid order is the operator's to refund, not a locked on-chain fund."
---

## Summary

LPFStore (ERC-1155 store, Helmets2117 idiom): claim(Order) mints a token bought off-chain only with a signature from the constant _signerAddress 0xC783A70A…; there is no other mint. If that key takes real code, claims die; the contract takes no ETH (claim is not payable) and holds nothing.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Helmets2117: signed by SIGNER_ADDRESS, fixed in the code. Rule: same text up to names.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source LPFStore.sol: _signerAddress constant; claim is the only mint path and the only ecrecover user; no payable function, no withdraw
- owner can add token IDs via setTokenData, so claim stays reachable (not closed by time or supply)
- signer 0xc783a70a… has no code, nonce 0; owner 0xb7cf8fd3… EOA nonce 31; contract ETH balance 0 at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-06.

## Remediation

Rotate before migrating is impossible (no setter); the operator must redeploy the store with a new signer before the signing key takes code, and serve outstanding orders there.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
