---
id: coordinationpaymentchannels-2f06f0df-rotate-signer-before-migrating
title: "CoordinationPaymentChannels: signer key to rotate before its account takes code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6"
  family: "0d0deff0f3a759cfc98bad3d4001f3df"
  copies: 2
  name: "CoordinationPaymentChannels"
  upgradeable: "no"
  rating: LOW
  value_usd: 15700
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "each staker (withdraw or keep a 7702 delegation before migrating); operator for the coordinator key"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-rotate-signer-before-migrating"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "Nothing to rotate for the staker. LOW only because the staker controls its own migration (withdraw first or keep the 7702 delegation); a staker who migrates with stake inside is locked, which arguably makes it HIGH. Reviewer call."
---

## Summary

CoordinationPaymentChannels: a staker withdraws only with its own ECDSA signature plus the coordinator's. A staker whose account takes real code cannot withdraw its WETH.

## Mechanism

PQ-17. Once that key's account has real code its signatures stop counting; its holder rotates first, or the owner afterwards.

## Evidence

- How it was placed: CoordinationPaymentChannels: a staker withdraws only with its own ECDSA signature on a commitment next to the coordinator's; a staker whose account takes code cannot withdraw. Read by hand.
- CoordinationPaymentChannels.sol:305-328,383-402: recover(stakeAddressSignature) must == stakeAddress; no way to re-point a stake to another address
- initiateTimelockedWithdrawal also requires msg.sender == stakeAddress for the first call
- coordinator key is rotatable: updateCoordinatorAddress onlyOperator; coordinator 0x3a8f4dFF…: EOA, nonce 312

## Impact and exposure

- Value held at block 26,438,999: $15,700 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Stakers withdraw before migrating, or stay EIP-7702-delegated (still accepted). The operator rotates the coordinator via updateCoordinatorAddress.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-rotate-signer-before-migrating` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
