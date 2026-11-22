---
id: curvestableswapng-1d08e7ad-stableswap-ng-permit
format: 2
title: Curve USD0/USD0++ pool LP permit locks out post-quantum smart accounts
status: confirmed
severity: LOW
justification: Only 65-byte signatures reach ERC-1271; approve() still works, nothing is forgeable; Curve fixes
  in new pools
category: quantum-exposure
pattern: PQ-3
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1d08e7adc263cfc70b1babe6dc5bb339c16eec52'
  name: CurveStableSwapNG
  project: curve
  code: verified
  code_url: https://etherscan.io/address/0x1d08e7adc263cfc70b1babe6dc5bb339c16eec52#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 39692
  basis: held
activity:
  txs_90d: 552
impact: liveness
action: Ship a pool implementation whose permit forwards a bytes signature unchanged to ERC-1271.
evidence_level: source
checks:
- id: c1
  source: '0x1d08e7adc263cfc70b1babe6dc5bb339c16eec52'
  file: CurveStableSwapNG.vy
  line: 1664
  has: assert ecrecover(digest, convert(_v, uint256), convert(_r, uint256), convert(_s, uint256)) == _owner
  says: code-less owners are verified with ecrecover
  for:
  - evidence-3
  - what
- id: c-68
  source: '0x1d08e7adc263cfc70b1babe6dc5bb339c16eec52'
  file: CurveStableSwapNG.vy
  has: 'def isValidSignature(_hash: bytes32, _signature: Bytes[65]) -> bytes32: view'
  line: 68
  says: ERC-1271 interface limits the signature to 65 bytes
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c-1659
  source: '0x1d08e7adc263cfc70b1babe6dc5bb339c16eec52'
  file: CurveStableSwapNG.vy
  has: 'if _owner.is_contract:'
  line: 1659
  says: permit branches on whether the owner has code
  for:
  - evidence-3
  - what
- id: c-1660
  source: '0x1d08e7adc263cfc70b1babe6dc5bb339c16eec52'
  file: CurveStableSwapNG.vy
  has: 'sig: Bytes[65] = concat(_abi_encode(_r, _s), slice(convert(_v, bytes32), 31, 1))'
  line: 1660
  says: contract-owner signature is built as 65 bytes from r, s, v
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c-1662
  source: '0x1d08e7adc263cfc70b1babe6dc5bb339c16eec52'
  file: CurveStableSwapNG.vy
  has: assert ERC1271(_owner).isValidSignature(digest, sig) == ERC1271_MAGIC_VAL
  line: 1662
  says: contract owners are verified through ERC-1271
  for:
  - justification
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review17 (Sourcify Vyper source and on-chain reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This Curve pool's LP token permit sends contract owners to ERC-1271 and code-less owners to ecrecover. The ERC-1271 call carries a 65-byte signature, so a post-quantum account cannot sign an LP permit and must use approve().

## Evidence

- [permit](https://etherscan.io/address/0x1d08e7adc263cfc70b1babe6dc5bb339c16eec52#code) packs r, s, v into a Bytes[65] signature for contract owners.
- [The ERC1271 interface](https://etherscan.io/address/0x1d08e7adc263cfc70b1babe6dc5bb339c16eec52#code) declares isValidSignature with a Bytes[65] signature.
- [permit](https://etherscan.io/address/0x1d08e7adc263cfc70b1babe6dc5bb339c16eec52#code) uses ecrecover only when the owner has no code.

## Reviewer notes

### Mechanism

permit(_owner,_spender,_value,_deadline,_v,_r,_s) (lines 1622-1670) builds the EIP-712 digest (1651-1657). If _owner.is_contract (1659), it builds sig: Bytes[65] from r, s, v (1660) and requires ERC1271(_owner).isValidSignature(digest, sig) == ERC1271_MAGIC_VAL (1662). The interface fixes _signature to Bytes[65] (line 68), and the external signature takes uint8, bytes32, bytes32, so larger post-quantum signatures cannot be passed. Otherwise ecrecover(digest, v, r, s) == _owner (1664). Then allowance is set (1666). A migrated account with code never reaches ecrecover, so its old key cannot forge a permit here.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Forgery against contract accounts: owners with code never reach ecrecover
- Ruled out: Pool reserves are not exposed through permit

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
