---
id: contract-25ab3efd-swap-sig-ecdsa-only
format: 2
title: Meson swap accepts ECDSA-only user signatures a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: User swap signatures are checked by ecrecover alone; the owner can fix it by upgrading the proxy,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x25ab3efd52e6470681ce037cd546dc60726948d3'
  project: meson
  code: decompiled
  code_url: code/0xd393abfa63b48fd71a2f7079d0987b35352d073ce9ed6664d53b96d0eb81b47d.sol
  proxy_of: '0xf7dace615099950410bd07f52427a0448429518a'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 110527
  basis: held
activity:
  txs_90d: 10481
impact: funds-loss
action: Upgrade to verify requests and releases via ERC-1271 for accounts with code, and ecrecover only for code-less
  ones.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0xf7dace615099950410bd07f52427a0448429518a'
  has: 60015afa
  says: the implementation calls ecrecover (offset 11096)
  for:
  - evidence-3
  - justification
  - what
- id: b2
  bytecode: '0xf7dace615099950410bd07f52427a0448429518a'
  has: 600160a01b0387165afa
  says: the implementation calls ecrecover (offset 12571)
  for:
  - evidence-3
  - what
- id: b3
  bytecode: '0xf7dace615099950410bd07f52427a0448429518a'
  has: 600160a01b0387165afa
  says: the implementation calls ecrecover (offset 16480)
  for:
  - evidence-3
  - what
- id: b4
  bytecode: '0xf7dace615099950410bd07f52427a0448429518a'
  has: 60015afa
  says: the implementation calls ecrecover (offset 17248)
  for:
  - evidence-3
  - what
- id: sel-postswap
  selector: '0xf7dace615099950410bd07f52427a0448429518a'
  fn: postSwapWithSignature(uint256,bytes32,bytes32,address,uint40)
  says: the code has postSwapWithSignature, a signed swap request
  for:
  - evidence-1
  - justification
  - what
- id: sel-release
  selector: '0xf7dace615099950410bd07f52427a0448429518a'
  fn: release(uint256,bytes32,bytes32,address,address)
  says: the code has release, a signed release to a recipient
  for:
  - evidence-2
  - what
- id: sel-upgrade
  selector: '0xf7dace615099950410bd07f52427a0448429518a'
  fn: upgradeTo(address)
  says: the code has upgradeTo, so the implementation can be replaced
  for:
  - action
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review15 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read or judged, the registry text read; not executed; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
  pattern: PQ-1
reviews: []
related: []
---

## What happens

Meson runs cross-chain swaps that a user authorises by signing the swap request and the release to a recipient. Both signatures are checked with ecrecover, so a quantum attacker with a user's key can post swaps pulling that user's approved tokens and release them to itself.

## Evidence

- [postSwapWithSignature](https://etherscan.io/address/0xf7dace615099950410bd07f52427a0448429518a#code) takes a compact r/vs signature from the swap initiator.
- [release](https://etherscan.io/address/0xf7dace615099950410bd07f52427a0448429518a#code) takes the initiator's compact signature and pays a recipient.
- The [implementation code](https://etherscan.io/address/0xf7dace615099950410bd07f52427a0448429518a#code) calls the ecrecover precompile at four places.

## Reviewer notes

### Mechanism

Proxy 0x25ab…48d3 delegates to unverified implementation 0xf7da…518a. Its dispatcher exposes postSwapWithSignature(uint256,bytes32,bytes32,address,uint40), which recovers the initiator from the encoded swap's signature and pulls the swap amount from the initiator's allowance, and release(uint256,bytes32,bytes32,address,address), which checks the initiator's release signature and pays the recipient. The runtime code calls the ecrecover precompile at offsets 11096, 12571, 16480 and 17248. The verified predecessor in Flattened.sol does the same with require(signer == ecrecover(digest, v, r, s)) at lines 1981 and 2021, with no ERC-1271 path. upgradeTo is available to the owner.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: LP pool liquidity held by the contract is not released by a forged user signature beyond swaps LPs lock themselves.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
