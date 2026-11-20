---
id: multisigpoolv5-96866592-fixed-signer
title: "MultiSigPoolV5: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x96866592ccc2c5950cee1ca83685879db0726150"
  family: "a0905f6c15512b2007e90872aafde9b3"
  copies: 2
  name: "MultiSigPoolV5"
  upgradeable: "no"
  rating: MEDIUM
  value_usd: 32
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
  note: "No update path, and only the operator's fast-withdraw liquidity is at stake, so MEDIUM. 2-of-3 means one migrated signer alone does not break it."
---

## Summary

Withdrawals need 2 of the 3 signers set in the constructor, and there is no setter. On mainnet, deposit() forwards users' USDT straight to StarkEx, so the pool holds only operator liquidity. The function dies once two signers have code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: ApeX MultiSigPool: withdrawals need 2 of 3 signers fixed in the constructor; on mainnet deposits pass users' USDC straight to StarkEx, so the pool holds only the operator's fast-withdrawal liquidity…. Read.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- MultiSigPoolV5.sol: `signers` is assigned only in the constructor; withdrawETH/withdrawErc20/factTransferErc20 use ECDSA.recover plus isAllowedSigner.
- deposit(): on chainid 1 it calls starkEx.depositERC20 with the returnAmount in the same call.
- Signers 0x04b4…9128, 0xc467…0e7B, 0x22c8…84Fe have no code. Holdings: 0.0175 ETH, 0 USDT.

## Impact and exposure

- Value held at block 26,438,999: $32 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Move the liquidity out and deploy a new pool before two signers migrate.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
