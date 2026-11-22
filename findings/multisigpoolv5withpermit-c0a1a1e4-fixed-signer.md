---
id: multisigpoolv5withpermit-c0a1a1e4-fixed-signer
title: "MultiSigPoolV5WithPermit: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xc0a1a1e4af873e9a37a0cac37f3ab81152432cc5"
  family: "dea94a65eb326ceb4dd5df4fd17e7509"
  copies: 2
  name: "MultiSigPoolV5WithPermit"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 932
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
  note: "No update path; if 2 signers take code the pool's funds lock, but they are the operator's own fast-withdrawal liquidity → MEDIUM."
---

## Summary

MultiSigPoolV5WithPermit: every token/ETH exit (withdrawETH, withdrawErc20, withdrawErc20ForMPC, factTransferErc20) needs 2 signatures from the 3 constructor-set signers; no setter. On mainnet, deposits go straight to StarkEx, so the pool holds only operator liquidity.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ApeX MultiSigPool: withdrawals need 2 of 3 signers fixed in the constructor; on mainnet deposits pass users' USDC straight to StarkEx, so the pool holds only the operator's fast-withdrawal liquidity…. Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- MultiSigPoolV5WithPermit.sol: signers = allowedSigners only in constructor; exits check ECDSA.recover == allSigners[i] && isAllowedSigner
- deposit/depositWithPermit call starkEx.depositERC20 on chainid 1
- signers(0..2) = 0x38AC…69F8, 0x811a…cFe2, 0x5C37…0323, all code 0x today

## Impact and exposure

- Value held at block 26,438,999: $932 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Operator withdraws its liquidity while 2 signers are EOAs; redeploy the pool.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
