---
id: verifierv2-c25d093d-halo2-verifier
format: 2
title: Zircuit's retired Halo2 verifier accepts forgeable BN254 proofs
status: confirmed
severity: LOW
justification: 'LOW: a forged proof passes the BN254 checks, but no Zircuit contract calls this verifier, so nothing
  is released.'
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc25d093d3a3f58952252d2e763beaf2559dc9737'
  name: VerifierV2
  project: zircuit
  code: verified
  code_url: https://etherscan.io/address/0x5d4f36e70ab3ccd8ca898a06c2d725b22a1d57f0#code
  proxy_of: '0x5d4f36e70ab3ccd8ca898a06c2d725b22a1d57f0'
  copies: 1
  upgradeable: 'yes'
  admin: '0x5b1ef673d9c316b3ee9ed3b4e3cc84952bfc5257'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
evidence_level: source
checks:
- id: c1
  source: '0x5d4f36e70ab3ccd8ca898a06c2d725b22a1d57f0'
  file: src/L1/VerifierV2.sol
  line: 1772
  has: eq(staticcall(gas(), 0x7, 0x3cc0, 0x60, 0x3cc0, 0x40), 1),
  says: Line 1772 calls the BN254 ecMul precompile (0x07) and requires success.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x5d4f36e70ab3ccd8ca898a06c2d725b22a1d57f0'
  file: src/L1/VerifierV2.sol
  line: 1780
  has: eq(staticcall(gas(), 0x6, 0x3d20, 0x80, 0x3d20, 0x40), 1),
  says: Line 1780 calls the BN254 ecAdd precompile (0x06) and requires success.
  for:
  - evidence-2
  - justification
  - what
- id: c3
  source: '0x5d4f36e70ab3ccd8ca898a06c2d725b22a1d57f0'
  file: src/L1/VerifierV2.sol
  line: 1787
  has: eq(staticcall(gas(), 0x7, 0x3da0, 0x60, 0x3da0, 0x40), 1),
  says: Line 1787 calls ecMul (0x07) on proof data.
  for:
  - evidence-1
  - what
- id: c4
  source: '0x5d4f36e70ab3ccd8ca898a06c2d725b22a1d57f0'
  file: src/L1/VerifierV2.sol
  line: 1795
  has: eq(staticcall(gas(), 0x6, 0x3e00, 0x80, 0x3e00, 0x40), 1),
  says: Line 1795 calls ecAdd (0x06) to accumulate points.
  for:
  - evidence-2
- id: c5
  source: '0x5d4f36e70ab3ccd8ca898a06c2d725b22a1d57f0'
  file: src/L1/VerifierV2.sol
  line: 1802
  has: eq(staticcall(gas(), 0x7, 0x3e80, 0x60, 0x3e80, 0x40), 1),
  says: Line 1802 calls ecMul (0x07) on proof data.
  for:
  - evidence-1
- id: c6
  source: '0x5d4f36e70ab3ccd8ca898a06c2d725b22a1d57f0'
  file: src/L1/VerifierV2.sol
  line: 1810
  has: eq(staticcall(gas(), 0x6, 0x3ee0, 0x80, 0x3ee0, 0x40), 1),
  says: Line 1810 calls ecAdd (0x06) to accumulate points.
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
  who: Review16 (verified source of VerifierV2 and the L2OutputOracle/OptimismPortal implementations, on-chain reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract is Zircuit's Halo2-KZG proof verifier and accepts a proof when its BN254 elliptic-curve checks succeed. With the setup trapdoor, a quantum attacker could make it accept a false proof, but it no longer guards any withdrawals.

## Evidence

- [VerifierV2](https://etherscan.io/address/0x5d4f36e70ab3ccd8ca898a06c2d725b22a1d57f0#code) checks the proof with BN254 ecMul (0x07) precompile calls.
- [VerifierV2](https://etherscan.io/address/0x5d4f36e70ab3ccd8ca898a06c2d725b22a1d57f0#code) combines proof points with BN254 ecAdd (0x06) precompile calls.

## Reviewer notes

### Mechanism

VerifierV2 is a generated snark-verifier contract that has only a fallback. It accumulates proof and verifying-key points with ecMul (0x07, lines 1772, 1787, 1802, 1817) and ecAdd (0x06, lines 1780, 1795, 1810, 1825) staticcalls. Each result is ANDed into `success`, and a final ecPairing (0x08) call, per kev at line 2159, reverts on failure. Its former consumer, L2OutputOracle v3.0.0 `proposeL2OutputV2`, staticcalled it. That consumer was upgraded to v3.1.0 (SP1 only) and then to v1.8.0, which has no verifier. OptimismPortal2 now proves withdrawals against PermissionedDisputeGame outputs, so a forged pairing proof accepted here releases nothing. Only an upgrade by the owning Safe, which controls the ProxyAdmins, could put the verifier back on the withdrawal path.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Bridge escrow: secured by the PermissionedDisputeGame, not by this verifier
- Ruled out: Staking pool: does not depend on VerifierV2

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
