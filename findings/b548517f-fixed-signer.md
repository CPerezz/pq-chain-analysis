---
id: b548517f-fixed-signer
title: "0xb548517f: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0xb548517fa60347973ce5cd9be62fa4f9b18afaeb"
  family: "6b2dc3675733a65dc3a5d8e07a8894d2"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "The operator: redeploy with a new signer, or pay recipients directly from the wallet"
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
  rating: MEDIUM
  note: "The study note says 'presale deposit/claim', but the verified source with a signer() getter matches LevxStreaming. There, only start() is signature-gated, and claim() needs no signature. Possible mismatch: the row's function count is 12, while LevxStreaming as written has 11 public functions. This review assumes the deployed contract is LevxStreaming."
---

## Summary

The signer is an immutable that cannot be changed, and it is an EOA today. If its account gets code, start() stops working, so no new streams can be created. Existing streams can still be claimed without any signature, and the operator's tokens stay in the operator's wallet. Only a function stops; nothing is locked.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- LevxStreaming: `address public immutable signer`, set only in the constructor; no setter exists
- start(): `require(ECDSA.recover(...) == signer, "LEVX: UNAUTHORIZED")`, then safeTransferFrom(wallet, this, amount)
- claim(): checks only `stream.recipient == msg.sender`, with no signature
- signer() getter = 0xe9d4afb6f8c9196972c6d9a74d5e54bbb7721f5b, an EOA with no code at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

Deploy a new streaming contract with a replaceable signer or ERC-1271 support. Alternatively, keep the signer key as an EOA or 7702-delegated account.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
