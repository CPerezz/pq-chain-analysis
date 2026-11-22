---
id: proxy-f338cad0-blob-kzg
format: 2
title: Paradex core accepts KZG blob openings a quantum attacker could forge
status: confirmed
severity: LOW
justification: 'Forged openings only withhold data; operators can switch to calldata DA and governors can upgrade
  the core: LOW.'
category: quantum-exposure
pattern: PQ-8
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf338cad020d506e8e3d9b4854986e0ece6c23640'
  name: Proxy
  project: paradex
  code: verified
  code_url: https://etherscan.io/address/0xf338cad020d506e8e3d9b4854986e0ece6c23640#code
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 16104
impact: funds-locked
action: Post state updates with updateState (calldata DA) instead of updateStateKzgDA; later upgrade the core to
  remove the KZG path.
evidence_level: source
checks:
- id: c2
  source: '0xf338cad020d506e8e3d9b4854986e0ece6c23640'
  file: Proxy.sol
  line: 291
  has: function upgradeTo(
  says: The proxy has an upgradeTo function to replace the implementation.
  for:
  - action
  - evidence-2
  - justification
- id: c3
  source: '0xf338cad020d506e8e3d9b4854986e0ece6c23640'
  file: Proxy.sol
  has: external payable onlyGovernance notFinalized notFrozen
  line: 295
  says: upgradeTo is restricted to governance.
  for:
  - action
  - evidence-2
  - justification
- id: c4
  source: '0xf338cad020d506e8e3d9b4854986e0ece6c23640'
  file: Proxy.sol
  has: let result := delegatecall(gas(), _implementation, 0, calldatasize(), 0, 0)
  line: 185
  says: Calls are forwarded by delegatecall to the implementation.
  for:
  - evidence-1
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review01)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This proxy is Paradex's L1 core and delegates every call to its Starknet implementation, which accepts state updates whose data sits in blobs checked by KZG openings. With the KZG trapdoor, an operator could post proven updates without publishing their data, freezing bridged user funds.

## Evidence

- The [fallback](https://etherscan.io/address/0xf338cad020d506e8e3d9b4854986e0ece6c23640#code) delegatecalls the implementation, which holds the KZG and calldata update paths.
- Governance can replace the implementation via [upgradeTo](https://etherscan.io/address/0xf338cad020d506e8e3d9b4854986e0ece6c23640#code) to drop the KZG path.

## Reviewer notes

### Mechanism

Proxy.fallback (line 173) delegatecalls the implementation (line 185). In the implementation, Starknet.updateStateKzgDA (onlyOperator) requires USE_KZG_DA=1, calls verifyKzgProofs (blobhash plus point-evaluation precompile 0x0A with commitment and y from the STARK output), then updateStateInternal checks the SHARP fact. A trapdoor-forged opening lets a blob differing from the proven state diff pass, so state advances without published data and funds freeze; the transition stays STARK-proven. updateState binds data via keccak calldata DA. Proxy.upgradeTo (line 291, onlyGovernance) sets a new implementation (setImplementation line 207).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Theft: state transitions remain STARK-proven, so withheld data freezes rather than steals funds.
- Ruled out: Operator ECDSA key forgery is a separate exposure, not rated here.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
