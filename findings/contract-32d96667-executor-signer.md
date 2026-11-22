---
id: contract-32d96667-executor-signer
format: 2
title: gamma.satoris.eth arbitrage executor trusts ECDSA-signed trade instructions
status: candidate
severity: MEDIUM
justification: An ECDSA signer key could be forged; only the operator can fix it, by a new deployment, so MEDIUM.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x32d96667be9986bea89dcef0aab29b3d1959f5a5'
  project: gamma-satoris
  code: decompiled
  code_url: code/0x237d4b6a15f61b5e5d3eb4e389f66c31bcaec911a45129f7ede462a02f50ed0a.sol
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Retire this executor or redeploy it with msg.sender or post-quantum signature authorisation.
evidence_level: bytecode
checks:
- id: code
  code: '0x32d96667be9986bea89dcef0aab29b3d1959f5a5'
  is: contract
  bytes: 16764
  says: The address holds contract code.
  for:
  - action
  - justification
  - what
- id: sel-setfee
  selector: '0x32d96667be9986bea89dcef0aab29b3d1959f5a5'
  fn: setFee(uint256)
  says: Owner-only fee setter is in the bytecode.
  for:
  - justification
  - what
- id: sel-transfereth
  selector: '0x32d96667be9986bea89dcef0aab29b3d1959f5a5'
  fn: transferETH(address,uint256)
  says: Owner-only ETH transfer is in the bytecode.
  for:
  - evidence-1
  - what
- id: sel-sweep
  selector: '0x32d96667be9986bea89dcef0aab29b3d1959f5a5'
  fn: sweep(address[],address)
  says: Token sweep function is in the bytecode.
  for:
  - evidence-2
  - what
- id: sel-flashtoken
  selector: '0x32d96667be9986bea89dcef0aab29b3d1959f5a5'
  fn: getFlashToken(address)
  says: Flash-loan token getter is in the bytecode.
  for:
  - evidence-2
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review08 (bytecode selectors, sampled trace, on-chain reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This unverified contract is a flash-loan arbitrage executor run by one owner, with owner-only fee and ETH-transfer controls. It runs signed trade instructions, so a quantum attacker who recovers the signing key could direct its trades and the tokens it holds.

## Evidence

- [Contract code](https://etherscan.io/address/0x32d96667be9986bea89dcef0aab29b3d1959f5a5#code) has an owner-gated transferETH(address,uint256).
- [Contract code](https://etherscan.io/address/0x32d96667be9986bea89dcef0aab29b3d1959f5a5#code) exposes sweep(address[],address) and getFlashToken(address).

## Reviewer notes

### Mechanism

Bytecode-only contract (no verified source). The selectors show an owner-administered executor: setFee(uint256) and transferETH(address,uint256) require msg.sender to equal the stored owner, and sweep(address[],address) and getFlashToken(address) are present. Kev's finding records that the precompile trace attributes ecrecover calls to this executor. It also records that sibling executors start Morpho flash loans whose callback recovers an ECDSA signature on the trade struct's trailing bytes field, with a per-address nonce. Who must sign (the owner or whitelisted bots) is not established. A forged signature would let an attacker direct trades. Kev records that the contract holds about nothing between transactions and that flash-loaned funds are repaid within the same transaction.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not a proxy (kev: getOwner read, none is a proxy)
- Ruled out: Flash-loan volume is pass-through flow, not holdings

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
