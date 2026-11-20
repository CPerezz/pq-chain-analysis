---
id: etherscandao-57515772-fixed-signer
title: "EtherScanDAO: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x575157729e5e9d6383be5278238be6161c44d2d9"
  family: "4d8065677b89c8ac4c75116ba7c53261"
  name: "EtherScanDAO"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 4
  last_active: 2026-11-01
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
  note: "Airdrop stock the operator created (unminted supply); existing balances and transfers are untouched, nothing is locked: MEDIUM."
---

## Summary

EtherScanDAO (OpenDAO claim): claim() mints the airdrop share on demand, only with a signature from the immutable cSigner 0x6B781478…. The claim stock is not held by anyone: it is unminted supply (about 49.9% of MAX_SUPPLY), so there is nothing for an owner to move, and the contract has no owner. If the key takes code, unclaimed airdrop simply never mints.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: OpenDAO claim: signed by cSigner, fixed in the code. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- source EtherScanDAO.sol: cSigner immutable, set in constructor; claim() is the only post-deploy mint and the only ecrecover user; no owner, no setter
- totalSupply 5.013e31 of MAX_SUPPLY 1e32 at block 26438999, so claims are still open
- cSigner 0x6b781478… no code, nonce 5

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 4 transactions called it in the 90 days before that block; last on 2026-11-01.

## Remediation

None on-chain; the project would have to deploy a new token/claim contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
