---
id: smartaccountrelayer-8090a9db-fixed-signer
title: "SmartAccountRelayer: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x8090a9db6aca56ffa186c75ca0787b18af1058a0"
  family: "c39929235d707649d6fc0e41ae925ee4"
  copies: 3
  name: "SmartAccountRelayer"
  upgradeable: "no"
  rating: LOW
  txs_90d: 13743
  last_active: 2026-11-18
  recoveries_14d: 1924
fix:
  layer: new-deployment
  who_acts: "relayer operator (Fluidkey; signer 0xe782…eD7a): deploy a new relayer with a new authorizedCaller, or submit the same calls directly; Safe owners can always submit execTransaction themselves"
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
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "No setter or upgrade exists on the relayer itself, but it holds no value, and every forwarded act stays open to the affected parties by a direct path (permissionless Safe execTransaction with owner signatures). Only the relaying convenience dies, and a redeploy restores it. LOW, not HIGH."
---

## Summary

SmartAccountRelayer is a gas-paying forwarder: relayOperation checks that a signature recovers to the immutable authorizedCaller, then calls `to` with `data`. If the signer held non-7702 code, the relayer would stop, but every call it forwards (Safe execTransaction with owner signatures, CREATE2 deploys, a signature-gated module call) is permissionless and can be sent directly or through a new relayer.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: SmartAccountRelayer: the signer must be authorizedCaller, fixed in the code / SmartAccountRelayer.recoverSigner: returns the signer. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source: 'address public immutable authorizedCaller', relayOperation is the only state-changing function, and it calls to.call{value:0}(data). authorizedCaller() at 26438999 = 0xe78288221aaE3A0D3ddf8Fa08D3602C3014eeD7a (EOA, no code). The relayer balance is 0, so it holds nothing
- 64 OperationRelayed logs in blocks 26436000-26438999, all txs sent by 0x7997e874…82da. Decoded targets: 33× Safe MultiSendCallOnly 0x40A2…130D multiSend, whose inner calls are 57× Safe execTransaction, 3× FluidkeyEarnModule 0x3bdb857a autoEarn(address,uint256,address,uint256,bytes) and the rest CREATE2 through the deterministic deployer 0x4e59b448; plus 31× direct execTransaction (0x6a761202) on 36 distinct Safes
- 5 sampled target Safes (0xddd5…8d80, 0x0824…7523, 0x5dd7…55cb, 0x0151…afde, 0x2a98…892b): singleton 0xd9db270c (Safe 1.3.0), threshold 1, a single EOA owner each (no code), no guard (guard slot 0). Some have only the Fluidkey Earn module enabled. Safe 1.3.0 execTransaction accepts any msg.sender that presents valid owner signatures, so owners (or anyone holding their signatures) can submit directly
- FluidkeyEarnModule (Sourcify exact match): the 5-arg autoEarn checks an ECDSA signature from authorizedRelayers, which onlyAuthorizedRelayer can extend with addAuthorizedRelayer. It does not depend on msg.sender being this relayer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 13,743 transactions called it in the 90 days before that block; last on 2026-11-18.
- 1,924 signature recoveries in the study's two-week trace window.

## Remediation

The operator deploys a new SmartAccountRelayer with a new authorizedCaller (CREATE2, one line of config), or sends the same Safe/module calls directly. Safe owners keep direct execTransaction access.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry (D-025).
