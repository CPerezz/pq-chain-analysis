---
id: 343eadbd-fixed-gas-recovery
title: "0x343eadbd (tagged deployed by Methuselah Foundation 2): fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: CRITICAL
patterns: [PQ-14]
impact: funds-loss
contracts:
- address: "0x343eadbdff2eee8fea52e8204d6e58491a9e931a"
  family: "7bba566f43f5c40f9c585af6f6d2d289"
  label: "deployed by Methuselah Foundation 2"
  upgradeable: "no"
  rating: CRITICAL
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "nobody today (never set up); anyone who wanted to run this chain must deploy a fixed contract instead of calling setup()"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-gas-recovery"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: "Rated by mechanism as if set up and holding deposits, since dormancy and $0 never lower a rating. There is no update path. Alice deposits, pays Bob on the plasma chain, then exits from her deposit, answering any inclusion challenge with respondDepositInclusion, which needs no signature. Bob's only defences, challengeSpentCoin and challengeInvalidHistoryWithTransaction, need the signature check, so Bob, who did nothing, loses: CRITICAL. Reviewer attention: the chain was never set up and holds nothing, so nobody is exposed unless someone calls setup() (open to anyone) and uses it after activation. If a never-initialised contract counts as closed by state, refute it instead."
---

## Summary

A Plasma Group PlasmaChain (Vyper, Feb 2019) that was never set up. checkTransactionProofAndGetTypedTransfer (53f3c871) requires that ecrecover, called with 3,000 gas, return transfer.sender; challengeSpentCoin, challengeInvalidHistoryWithTransaction, respondTransactionInclusion and respondInvalidHistoryTransaction all depend on it. After EIP-8151 a depositor who already paid coins to someone on the plasma chain can exit them from the deposit, and the recipient cannot challenge. setup() was never called (operator, isSetup and serializer are all 0; no funds), but anyone can still call it.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- The dispatch matches Plasma Group PlasmaChain.vy selector for selector (checked with cast sig): setup f00e5686, submitBlock baa47694, listToken 0717d7c3, beginExit 1b8680da, finalizeExit 8903446e, challengeInclusion dd47b502, checkTransactionProofAndGetTypedTransfer 53f3c871, challengeSpentCoin c3022d2b, respondTransactionInclusion 8e654618, challengeInvalidHistoryWithTransaction 6dc4d745, respondInvalidHistoryTransaction 8ccbe05d, challengeBeforeDeposit 8467716b; also depositETH and depositERC20.
- pc 0x108f: CALL(gas 0x0bb8, to 0x01, out 0xc0), success flag ignored, then mload(0xc0) == mload(0x4580) (the decoded transfer.sender) or revert. The four exit-game functions reach it through self-CALLs at pc 0x2ece, 0x3560, 0x27b9 and 0x3eb4. The deposit-based paths (respondDepositInclusion 197efd2b, challengeInvalidHistoryWithDeposit 97c740df, respondInvalidHistoryDeposit 93e5ea17) do not use it.
- State at 26438999: storage slots 0-25 are all zero (operator in slot 0, isSetup in 0x10, serializer in 0x11). setup() only requires slot 0x10 == 0 (pc 0x11f0) and has no caller check. While serializer is 0, every path to pc 0x108f reverts first at the extcodesize(serializer) check (pc 0x93b).
- 0 ETH, and a full Transfer-log scan from creation (block 7146192, tx 0x4ba3425a...) to 26438999 finds no ERC-20 sent to it. EIP-1967 slots are zero; slots 0 and 0x11 are written only by setup; the dossier lists no code holding its address, so no forwarder uses it as a template. txs_90d 0.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Nothing to migrate today. The chain must never be set up after activation; anyone running this design needs a new deployment that gives ecrecover enough gas (as newer compilers' builtin does).

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: CRITICAL. Anon assigned the review to Claude, which also filed the triage entry (D-025).
