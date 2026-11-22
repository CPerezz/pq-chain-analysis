---
id: multisigpoolv5-698192c9-fixed-signer
title: "MultiSigPoolV5: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0x698192c9f0996eea12b492d6806a98d2fa928658"
  family: "c5910a4d243fca514d3e57f110e932ac"
  copies: 3
  name: "MultiSigPoolV5"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 894
  value_basis: held
  value_as_of: 2026-11-18
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "ApeX operator"
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
  note: "No update path; locked money would be the operator's own → MEDIUM."
---

## Summary

MultiSigPoolV5: withdrawETH, withdrawErc20 and factTransferErc20 need 2 of 3 constructor-fixed signers; no setter. User deposits are forwarded to StarkEx on mainnet, so held funds are the operator's liquidity.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ApeX MultiSigPool: withdrawals need 2 of 3 signers fixed in the constructor; on mainnet deposits pass users' USDC straight to StarkEx, so the pool holds only the operator's fast-withdrawal liquidity…. Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- MultiSigPoolV5.sol l.71-79: signers set only in constructor; l.194-196/239-241/285-287 ECDSA.recover + isAllowedSigner
- l.152-160: on chainid 1 deposit calls starkEx.depositERC20
- signers(0..2) = 0x0151…5379, 0x560D…9511, 0x22c8…84Fe, all code 0x today

## Impact and exposure

- Value held at block 26,438,999: $894 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Operator withdraws liquidity while 2 signers are EOAs; redeploy.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
