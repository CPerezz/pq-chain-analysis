---
id: gasdao-b7621435-fixed-signer
title: "GasDAO: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb7621435c7dce99a529132fd59f61ab9981a899c"
  family: "f7c7c8574f455c1edc4765928960fbef"
  name: "GasDAO"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-09-10
fix:
  layer: new-deployment
  who_acts: "nobody can (no owner role)"
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
  note: "Airdrop stock the operator created; nothing held, existing balances unaffected: MEDIUM."
---

## Summary

GasDAO (OpenDAO claim): claim() mints the airdrop share on demand, only with a signature from cSigner 0x9a5da01D… (storage, set in the constructor, no setter). The claim stock is unminted supply (about 59.9% of MAX_SUPPLY), held by nobody and movable by nobody; there is no owner. If the key takes code, unclaimed airdrop never mints.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: OpenDAO claim: signed by cSigner, fixed in the code. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source GasDAO.sol + ModifiedERC20.sol: cSigner written only in the constructor; no owner, no setter; claim() is the only post-deploy mint
- totalSupply 4.01e31 of MAX_SUPPLY 1e32 at block 26438999 (claims still open)
- cSigner 0x9a5da01d… no code, nonce 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-09-10.

## Remediation

None on-chain; a new token/claim contract would be needed.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
