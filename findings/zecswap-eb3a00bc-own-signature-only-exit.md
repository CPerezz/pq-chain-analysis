---
id: zecswap-eb3a00bc-own-signature-only-exit
title: "ZecSwap: funds released only by the party's own signature"
status: confirmed
severity: HIGH
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0xeb3a00bcb6c9ff626fe57a5dbbdcf01730e7898f"
  family: "d805e9543efffecc17f8dc897cc3ee17"
  name: "ZecSwap"
  upgradeable: "no"
  rating: HIGH
  value_usd: 138
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 15
  last_active: 2026-11-10
  recoveries_14d: 3
fix:
  layer: new-deployment
  who_acts: "swap users / makers"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-own-signature-only-exit"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "Users' tokens locked with no admin and no update path -> HIGH."
---

## Summary

ZEC<->ERC20 atomic swap escrow: a claimed swap with a payoutNote is paid into Railgun only through payout(), which needs the user's ECDSA signature. Refunded reverse swaps (refundPayout) and rescue need the maker's or user's signature the same way. If that account has code, the tokens stay in the contract.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: ZecSwap: user and maker authorise steps with ECDSA only (ecrecover == signer, no ERC-1271). A swap that pays into a shielded note can be paid only through payout, which needs the user's signature…. Read by hand. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- src/ZecSwap.sol payout L373-385: _checkSignature(terms.user, ...); refundPayout L325-340 checks terms.maker; rescue L410-431 checks user or maker
- _checkSignature L528-536: ecrecover(...) == signer, no ERC-1271 or code check
- claim/refund credit balanceOf only when payoutNote/refundNote == 0; there is no owner, admin or sweep function
- No proxy, no upgrade (row); row value $138, txs_90d=15, last_active 2026-11-10

## Impact and exposure

- Value held at block 26,438,999: $138 (ETH and 49 priced tokens).
- Activity: 15 transactions called it in the 90 days before that block; last on 2026-11-10.
- 3 signature recoveries in the study's two-week trace window.

## Remediation

Users of shielded payouts should keep EOA/7702 keys; a fix needs a new deployment with a direct-call path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
