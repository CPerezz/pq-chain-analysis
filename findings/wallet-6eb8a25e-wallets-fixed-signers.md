---
id: wallet-6eb8a25e-wallets-fixed-signers
title: "Wallet: wallet with signers fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x6eb8a25e9f13f4a3309473d38a646879b7ed1802"
  family: "cd492f0891aa52b833f805f7dea6a116"
  copies: 2417
  name: "Wallet"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 34193
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 3
  last_active: 2026-09-20
fix:
  layer: new-deployment
  who_acts: "the oracle keeps its proof key without code"
evidence:
  level: source-read
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
  note: "oracle path only; owner funds move directly"
---

## Summary

`Wallet` at `0x6eb8a25e9f13f4a3309473d38a646879b7ed1802`, with 2,416 more addresses running its code. The wallet's owner moves funds directly; only the oracle proofs it accepts are tied to a key fixed in the code.

## Mechanism

PQ-17. No function replaces a signer. Once enough signer accounts take real code, the wallet can no longer move anything.

## Evidence

- How it was placed: an oracle proof: the signature must match the public key carried in the proof, which chains to a key fixed in the code / an oracle proof: the signature must match a public key from the proof chain /…. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source read: an oracle proof must match the public key carried in the proof, which chains to a key fixed in the code; the owner's own operations check the owner, who can be changed (transferOwnership).
- Nothing the owner holds is locked by the fixed key; the oracle-driven path stops.
- No proxy, no upgrade. 3 transactions in the 90 days.

## Impact and exposure

- Value held at block 26,438,999: $34,193 (ETH and 49 priced tokens, over 2,417 addresses).
- Activity: 3 transactions called it in the 90 days before that block; last on 2026-09-20.

## Remediation

None needed for funds.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-wallets-fixed-signers` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
