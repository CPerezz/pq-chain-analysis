---
id: sp1verifier-3794de28-sp1-verifier
format: 2
title: Hyperbridge SP1 Groth16 verifier accepts proofs a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: Groth16 soundness falls to a quantum-recovered trapdoor; Hyperbridge's host manager Safe can move
  to a PQ client.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3794de2808420ba5fc5bb07d0643379b85bbb53d'
  name: SP1Verifier
  project: hyperbridge
  code: verified
  code_url: https://etherscan.io/address/0x3794de2808420ba5fc5bb07d0643379b85bbb53d#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a consensus client that verifies a post-quantum proof and point EvmHost at it through updateHostParams.
evidence_level: source
checks:
- id: c1
  source: '0x3794de2808420ba5fc5bb07d0643379b85bbb53d'
  file: lib/sp1-contracts/contracts/src/v6.0.0/SP1VerifierGroth16.sol
  line: 51
  has: function verifyProof(
  says: SP1 verifyProof entry point that checks a proof for a program key and public values.
  for:
  - what
- id: c2
  source: '0x3794de2808420ba5fc5bb07d0643379b85bbb53d'
  file: lib/sp1-contracts/contracts/src/v6.0.0/SP1VerifierGroth16.sol
  line: 81
  has: this.verifyProof(proof, inputs);
  says: The proof is checked by the Groth16 verifyProof call.
  for:
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x3794de2808420ba5fc5bb07d0643379b85bbb53d'
  file: lib/sp1-contracts/contracts/src/v6.0.0/Groth16Verifier.sol
  line: 517
  has: function verifyProof(uint256[8] calldata proof, uint256[5] calldata input) public view {
  says: Groth16 verifier taking an 8-word proof and 5 inputs (BN254 pairing).
  for:
  - action
  - evidence-2
  - justification
  - what
- id: ver
  source: '0x3794de2808420ba5fc5bb07d0643379b85bbb53d'
  file: lib/sp1-contracts/contracts/src/v6.0.0/SP1VerifierGroth16.sol
  has: return "v6.0.0";
  line: 28
  says: The verifier reports version v6.0.0.
  for:
  - what
- id: digest
  source: '0x3794de2808420ba5fc5bb07d0643379b85bbb53d'
  file: lib/sp1-contracts/contracts/src/v6.0.0/SP1VerifierGroth16.sol
  has: bytes32 publicValuesDigest = hashPublicValues(publicValues);
  line: 63
  says: The public values are hashed into a proof input.
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
  who: Review07 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract verifies SP1 zkVM proofs (version v6.0.0) by checking a Groth16 proof over BN254. A quantum attacker who recovers the Groth16 setup trapdoor can make it accept a proof for any public values, such as a false consensus update.

## Evidence

- [verifyProof](https://etherscan.io/address/0x3794de2808420ba5fc5bb07d0643379b85bbb53d#code) hashes the public values and passes them with the proof to the Groth16 check.
- The [Groth16 verifyProof](https://etherscan.io/address/0x3794de2808420ba5fc5bb07d0643379b85bbb53d#code) takes an 8-word proof and 5 public inputs.

## Reviewer notes

### Mechanism

SP1Verifier.verifyProof (SP1VerifierGroth16.sol lines 51-82) checks the 4-byte verifier selector (lines 56-60), decodes exitCode, vkRoot, nonce and the 8-word Groth16 proof (line 64-65), requires exitCode 0 and the fixed VK_ROOT, builds 5 inputs from programVKey, the SHA-256 digest of the public values (line 63, hashPublicValues line 44), exitCode, vkRoot and nonce, then calls this.verifyProof(proof, inputs) (line 81), the Groth16 BN254 pairing verifier (Groth16Verifier.sol line 517). In Hyperbridge, SP1Beefy.verifyConsensus called an SP1 verifier to accept Polkadot BEEFY consensus updates; a forged update lets forged ISMP messages mint or release bridged tokens. Per the census, this v6.0.0 instance is no longer referenced by the current ConsensusRouter (which uses v6.1.0 at 0x70303aa3…).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: This verifier holds no funds.
- Ruled out: No calls to this verifier in the 30-day window; the current router uses the v6.1.0 verifier.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
