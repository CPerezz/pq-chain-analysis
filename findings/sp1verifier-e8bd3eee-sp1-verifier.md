---
id: sp1verifier-e8bd3eee-sp1-verifier
format: 2
title: Hyperbridge SP1 verifier accepts Groth16 proofs a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: Groth16 on BN254 falls to quantum trapdoor recovery; MEDIUM as Hyperbridge's host manager Safe can
  swap the verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe8bd3eee668089b8d29fcd65b8217733cb60b098'
  name: SP1Verifier
  project: hyperbridge
  code: verified
  code_url: https://etherscan.io/address/0xe8bd3eee668089b8d29fcd65b8217733cb60b098#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Deploy a consensus client that verifies a post-quantum proof and point the host at it via updateHostParams.
evidence_level: source
checks:
- id: c1
  source: '0xe8bd3eee668089b8d29fcd65b8217733cb60b098'
  file: lib/sp1-contracts/contracts/src/v4.0.0-rc.3/SP1VerifierGroth16.sol
  line: 39
  has: function verifyProof(
  says: verifyProof is the SP1 proof entry point
  for:
  - justification
  - what
- id: c2
  source: '0xe8bd3eee668089b8d29fcd65b8217733cb60b098'
  file: lib/sp1-contracts/contracts/src/ISP1Verifier.sol
  line: 14
  has: function verifyProof(
  says: the ISP1Verifier interface that consensus clients call
  for:
  - action
- id: verify
  source: '0xe8bd3eee668089b8d29fcd65b8217733cb60b098'
  file: lib/sp1-contracts/contracts/src/v4.0.0-rc.3/SP1VerifierGroth16.sol
  has: this.Verify(proof, inputs);
  line: 55
  says: verifyProof delegates to the Groth16 pairing check
  for:
  - evidence-1
  - what
- id: groth
  source: '0xe8bd3eee668089b8d29fcd65b8217733cb60b098'
  file: lib/sp1-contracts/contracts/src/v4.0.0-rc.3/SP1VerifierGroth16.sol
  has: contract SP1Verifier is Groth16Verifier
  line: 10
  says: the verifier is a Groth16 verifier
  for:
  - evidence-2
  - justification
  - what
- id: vers
  source: '0xe8bd3eee668089b8d29fcd65b8217733cb60b098'
  file: lib/sp1-contracts/contracts/src/v4.0.0-rc.3/SP1VerifierGroth16.sol
  has: return "v4.0.0-rc.3";
  line: 21
  says: version is v4.0.0-rc.3
  for:
  - evidence-2
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review07 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This SP1 verifier checks Groth16 proofs on BN254 for Hyperbridge's Polkadot consensus path. A quantum attacker who recovers the setup trapdoor can make it accept a proof of a false statement.

## Evidence

- [verifyProof](https://etherscan.io/address/0xe8bd3eee668089b8d29fcd65b8217733cb60b098#code) passes the proof and inputs to the BN254 Groth16 Verify.
- [The contract](https://etherscan.io/address/0xe8bd3eee668089b8d29fcd65b8217733cb60b098#code) inherits Groth16Verifier and reports version v4.0.0-rc.3.

## Reviewer notes

### Mechanism

SP1Verifier.verifyProof (line 39) checks the 4-byte selector against VERIFIER_HASH, hashes the public values with sha256 masked to a BN254 field element (line 32), decodes eight uint256 proof words and calls this.Verify(proof, inputs) (line 55), the Groth16 pairing check inherited from Groth16Verifier. Soundness rests on the BN254 trusted setup, whose trapdoor a quantum computer could recover. In Hyperbridge, SP1Beefy.verifyConsensus calls verifyProof to accept BEEFY consensus updates. Per the census, the current ConsensusRouter references the v6.1.0 verifier instead, so this v4.0.0-rc.3 deployment is retired and unreferenced. The fix is a new consensus client set through EvmHost.updateHostParams by the host manager Safe.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not referenced by the current consensus router; no calls in the 30-day window.
- Ruled out: Holds no funds; not upgradeable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
