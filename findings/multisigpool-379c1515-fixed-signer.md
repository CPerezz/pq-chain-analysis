---
id: multisigpool-379c1515-fixed-signer
title: "MultiSigPool: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x379c15156b527d6e693bed60d1fbb44ce46046b8"
  family: "760b27348dbc5302300e5e5ba0252ca8"
  copies: 3
  name: "MultiSigPool"
  label: "Apex: USDT prepetual"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 8
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: none
  who_acts: "none"
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
  rating: MEDIUM
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "Only operator liquidity is at stake and there is no update path, so MEDIUM."
---

## Summary

This is an ApeX MultiSigPool (USDT perpetual). Withdrawals need 2 of 3 signers fixed in the constructor. Mainnet deposits are forwarded to StarkEx, so only the operator's fast-withdrawal liquidity sits here.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ApeX MultiSigPool: withdrawals need 2 of 3 signers fixed in the constructor; on mainnet deposits pass users' USDC straight to StarkEx, so the pool holds only the operator's fast-withdrawal liquidity…. Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Same MultiSigPool code: `signers` is set only in the constructor; withdraw* use ECDSA.recover plus isAllowedSigner.
- Signers 0x04b4…9128, 0x467c…76d3, 0x22c8…84Fe have no code.
- Holdings: 0.0044 ETH, 0 USDT.

## Impact and exposure

- Value held at block 26,438,999: $8 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Move the liquidity out and deploy a new pool before two signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
