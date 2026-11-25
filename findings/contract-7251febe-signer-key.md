---
id: contract-7251febe-signer-key
format: 2
title: DEX router trusts one ECDSA operator key a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: Route approval rests on one ECDSA operator key; only the owner can fix it by upgrading the proxy.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7251febeabb01ec9de53ece7a96f1c951f886dd2'
  code: decompiled
  code_url: code/0xbc87c9cf36e7f0fbfc10cd4f3a16df4997f46aa3ab8310bbe48b7f0d7aad46c1.sol
  proxy_of: '0x85461e163c64f99a8709dff3bab0db808c358bd6'
  copies: 1
  upgradeable: 'yes'
  admin: '0xbfd7909f709abdb12999fd541beba56e299c817d'
value:
  usd: 1
  basis: held
activity:
  txs_90d: 3462
impact: funds-loss
action: Upgrade the router to verify operator approvals with a post-quantum scheme, or drop the operator signature.
evidence_level: bytecode
checks:
- id: sel-operator
  selector: '0x85461e163c64f99a8709dff3bab0db808c358bd6'
  fn: operator()
  says: operator() selector is in the code.
  for:
  - evidence-1
  - justification
  - what
- id: sel-setoperator
  selector: '0x85461e163c64f99a8709dff3bab0db808c358bd6'
  fn: setOperator(address)
  says: setOperator(address) selector is in the code.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: sel-approveproxy
  selector: '0x85461e163c64f99a8709dff3bab0db808c358bd6'
  fn: approveProxy()
  says: approveProxy() selector is in the code.
  for:
  - evidence-3
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review10 (bytecode and on-chain review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This router runs swap routes that carry a signature from its operator key and lets the owner replace that key. A quantum attacker who recovers the operator key signs routes the operator never approved.

## Evidence

- [operator()](https://etherscan.io/address/0x85461e163c64f99a8709dff3bab0db808c358bd6#code) exposes the key that route signatures are checked against.
- [setOperator](https://etherscan.io/address/0x85461e163c64f99a8709dff3bab0db808c358bd6#code) lets the owner replace the operator key.
- [approveProxy()](https://etherscan.io/address/0x85461e163c64f99a8709dff3bab0db808c358bd6#code) names the contract the router pulls tokens through.

## Reviewer notes

### Mechanism

In the unverified implementation 0x85461e16, the user entry 0xec5b999d takes the input tokens, amounts, adapter calls, a deadline and a 65-byte signature. Per kev's bytecode reading at offsets 0x123f-0x126f, it hashes the encoded route with keccak256, recovers a signer with OpenZeppelin-style ECDSA (the s <= n/2 check) and compares it with storage slot 0x9a, which operator() returns. setOperator(address), which only the owner can call, changes slot 0x9a. Tokens are pulled through approveProxy with claimTokens(token, CALLER, ...) at offsets 0x14ad, 0x15bf and 0x19dc, so a forged route spends the caller's funds and the router's own balance. The proxy admin and the router owner are one ECDSA EOA.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Other users' approvals are not reachable through a forged route: claimTokens takes tokens from the caller at every call site (kev's bytecode reading).

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
