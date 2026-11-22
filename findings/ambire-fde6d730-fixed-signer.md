---
id: ambire-fde6d730-fixed-signer
title: "AmbireAccount: signer fixed in code"
project: ambire
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xfde6d7303868fd2046c15263c9268618092664d1"
  family: "8ec52cac940e80d135861a45ae4824b4"
  copies: 405
  name: "AmbireAccount"
  label: "deployed by Ambire Wallet: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 1135597
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 1156
  last_active: 2026-11-17
  recoveries_14d: 165
fix:
  layer: new-deployment
  who_acts: "Ambire keeps its relayer key without code"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "Ambire's relayer key; users' own keys replaceable"
---

## Summary

`AmbireAccount` at `0xfde6d7303868fd2046c15263c9268618092664d1` (Etherscan tag: deployed by Ambire Wallet: Deployer), with 404 more addresses running its code. It accepts signatures only from a key fixed in its code; once that key's account has code, every signed function stops.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Ambire account execute: the signer must hold a privilege in the account; the library also takes contract signers and a Schnorr mode / Ambire account ERC-1271 (variant): the recovered key must hold a…. Read from source. Executed: a real transaction reverts with code at the signer. Rated by hand: the fixed key is Ambire's paymaster relayer; the accounts' own keys can be replaced.
- Update path, read at block 26,438,999: delegates to a fixed address.
- Source read: the account's own keys are privileges the owner can change; the fixed key is Ambire's paymaster relayer, used for sponsored operations.
- Each of the 405 addresses is a fixed delegate to AmbireAccount (no upgrade).
- Executed: a real relayed operation reverts once the relayer key has code. 1,156 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $1.1M (ETH and 49 priced tokens, over 405 addresses).
- Activity: 1,156 transactions called it in the 90 days before that block; last on 2026-11-17.
- 165 signature recoveries in the study's two-week trace window.

## Remediation

The operator keeps the signing key without code, or moves users to a new deployment.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
