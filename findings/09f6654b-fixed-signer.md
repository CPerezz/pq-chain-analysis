---
id: 09f6654b-fixed-signer
title: "0x09f6654b: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x09f6654bf4637f5db935a5963fb4a107f9e8be7f"
  family: "2aae52c974aa675386a13b8f3f67be8c"
  copies: 2
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator or owner would redeploy with a new signer, and anyone reading the feed would switch to the new contract."
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
  note: "The study note's description ('Presale: deposit and claim need a signature') does not match this bytecode: it is an oracle proof store, not a presale. The signer also happens to be the current owner."
---

## Summary

The only authorised oracle signer is the constant 0xad00…f1ef, an EOA today. It cannot be replaced: the contract has no proxy and no signer setter. If that key's account gets real code under EIP-8151, signed oracle payloads stop verifying and new proofs can't be submitted. No funds are held, so the impact is liveness only.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- getAuthorisedSignerIndex: require(0xad00eb5dc02e56d628d68abd144b8c223a6cf1ef == arg0, "Signer not authorized")
- QXMP_ORACLE_SIGNER constant 987675906641430707098460857026663299511063736815 is the same address as 0xad00…f1ef
- getUniqueSignersThreshold = 1; getDataServiceId = 'redstone-main-demo'
- The only state-changing setters are transferOwnership and updateRegistry; neither touches the signer

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 2 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new version whose authorised signer can be updated (or that accepts ERC-1271 signatures), then point consumers at it. Alternatively, keep the signer key a plain EOA or a 7702-delegated account.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
