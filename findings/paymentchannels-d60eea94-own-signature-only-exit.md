---
id: paymentchannels-d60eea94-own-signature-only-exit
title: "PaymentChannels: funds released only by the party's own signature"
status: confirmed
severity: HIGH
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0xd60eea947aae39e507430b30ce11f142304d9cb1"
  family: "9299c0f31b2483e035bc87f424d5a94f"
  name: "PaymentChannels"
  upgradeable: "no"
  rating: HIGH
  value_usd: 6594
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 5589
  last_active: 2026-11-18
  recoveries_14d: 138
fix:
  layer: new-deployment
  who_acts: "stakers"
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
  note: "Users' stakes locked with no operator rescue and no update path -> HIGH."
---

## Summary

ETH staking payment channel: a staker exits through unstake, or through the first startTimelockedUnstake call, and both require ECDSA.recover(commitment) == stakerAddress plus a notary signature. A staker whose account takes code can never exit; its staked ETH stays in the contract.

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- How it was placed: PaymentChannels (newer, 138 recoveries in the window): as the older one: a staker starts or finishes an unstake only with its own ECDSA signature on a commitment; a staker whose account takes code…. Read by hand. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- src/PaymentChannels.sol startTimelockedUnstake (L837-863): the first call requires msg.sender == staker AND recover(stakerSignature) == staker; unstake (L949-973) same
- executeTimelockedUnstake (L897) works only after startTimelockedUnstake; settleStakeCommitments (L750) also needs the staker signature and moves no ETH
- Only other ETH outflow: claim (L1017, notary-signed, to claimers); OperatorRecoverable.recoverToken is ERC20-only
- No proxy, no upgrade (row); row value $6,594, txs_90d=5,589, last_active 2026-11-18

## Impact and exposure

- Value held at block 26,438,999: $6,594 (ETH and 49 priced tokens).
- Activity: 5,589 transactions called it in the 90 days before that block; last on 2026-11-18.
- 138 signature recoveries in the study's two-week trace window.

## Remediation

Stakers should exit before giving their account non-7702 code; a fix needs a new deployment with a direct-call or ERC-1271 path.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-own-signature-only-exit` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: HIGH. Anon assigned the review to Claude, which also filed the triage entry.
