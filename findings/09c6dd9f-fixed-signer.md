---
id: 09c6dd9f-fixed-signer
title: "0x09c6dd9f: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x09c6dd9f7edd76685127f321b6bfd3e1401c6028"
  family: "9e5fd0c98b65cda7a7483e6bda8f7416"
  upgradeable: "yes"
  admin: "0xad6c739e5715c01fbbbcb0bbc87739d3c952d998 (EOA, nonce 0) via proxy 0x01713ade c79b1b1a, gated by tx.origin"
  rating: MEDIUM
  txs_90d: 1
  last_active: 2026-10-08
fix:
  layer: contract-upgrade
  who_acts: "proxy admin 0xad6c739e or operator 0x7781779f"
evidence:
  level: bytecode
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
  rating: MEDIUM
  note: "MEDIUM because the operator's sweep and queue paths still move the funds; the money is not locked. It becomes LOW if admin 0xad6c739e is a live key (it has never sent a tx: nonce 0 at the block), since the proxy upgrade is a simple fix. The row's 'no proxy' reflects only the implementation address."
---

## Summary

This is the implementation behind the custom EIP-1967 proxy 0x01713ade (1.44 ETH at the block). Users stake ETH (stake(), at least 0.01). The signed withdrawal 99d1d805 pays msg.sender only if recovered==constant 0x51d4e701. Operator paths move the money without it: b8940d60 sends the whole balance to tx.origin==0x7781779f, and e0f076fe runs queue payouts for 0xd63d4472/0x234f84dc. The proxy can also be upgraded via c79b1b1a when tx.origin==admin.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: a signer that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Bytecode pc 0x0f3b-0x0f59: PUSH20 0x51d4e701 then EQ against the recovered address ('s2'). Trace of tx 0x19054b83 (block 26397655): proxy 0x01713ade delegatecalls 09c6dd9f, 0x01 returns 0x51d4e701, then 0.01 ETH goes to the caller.
- Proxy 0x01713ade at block 26438999: impl slot = 09c6dd9f, admin slot = 0xad6c739e (EOA, nonce 0), balance 1.44 ETH. Decompiled proxy c79b1b1a: if tx.origin==adm, sets a new implementation (with code).
- Implementation bytecode pc 0x0836-0x08a6: msg.sender==tx.origin && tx.origin==0x7781779f → transfer SELFBALANCE to tx.origin. 0x7781779f has no code (latest, block ~26452927). Signer 0x51d4e701: EOA, nonce 11.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 1 transactions called it in the 90 days before that block; last on 2026-10-08.

## Remediation

The admin upgrades the implementation through the proxy, or the operator sweeps and returns stakes.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
