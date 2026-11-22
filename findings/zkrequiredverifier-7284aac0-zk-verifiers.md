---
id: zkrequiredverifier-7284aac0-zk-verifiers
format: 2
title: Taiko ZkRequiredVerifier accepts BN254 ZK proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged pairing proofs finalize a false L2 state; MEDIUM because the Taiko DAO can upgrade the inbox's
  verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7284aac05555ae6559bdad8b4221ec9584254eec'
  name: ZkRequiredVerifier
  project: taiko
  code: verified
  code_url: https://etherscan.io/address/0x7284aac05555ae6559bdad8b4221ec9584254eec#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 4061
impact: funds-loss
action: Upgrade the Shasta inbox to a proof verifier built on post-quantum proof systems.
evidence_level: source
checks:
- id: c1
  source: '0x7284aac05555ae6559bdad8b4221ec9584254eec'
  file: contracts/layer1/verifiers/compose/ComposeVerifier.sol
  line: 59
  has: function verifyProof(
  says: ComposeVerifier defines verifyProof, the proof check entry point.
  for:
  - action
  - justification
  - what
- id: c3
  source: '0x7284aac05555ae6559bdad8b4221ec9584254eec'
  file: contracts/layer1/verifiers/compose/ComposeVerifier.sol
  line: 83
  has: IProofVerifier(verifier).verifyProof(_proposalAge, _commitmentHash, subProofs[i].proof);
  says: Each sub-proof is passed to its sub-verifier's verifyProof.
  for:
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x7284aac05555ae6559bdad8b4221ec9584254eec'
  file: contracts/layer1/verifiers/compose/ComposeVerifier.sol
  has: SubProof[] memory subProofs = abi.decode(_proof, (SubProof[]));
  line: 68
  says: the line or bytes the card cites
  for:
  - what
- id: c5
  source: '0x7284aac05555ae6559bdad8b4221ec9584254eec'
  file: contracts/layer1/verifiers/compose/ComposeVerifier.sol
  has: require(areVerifiersSufficient(verifiers), CV_VERIFIERS_INSUFFICIENT());
  line: 89
  says: the line or bytes the card cites
  for:
  - evidence-3
  - what
- id: c6
  source: '0x7284aac05555ae6559bdad8b4221ec9584254eec'
  file: contracts/layer1/verifiers/compose/ComposeVerifier.sol
  has: if (_verifierId == VerifierType.RISC0_RETH) return risc0RethVerifier;
  line: 100
  says: the line or bytes the card cites
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
  who: Review16 (verified source of the Shasta inbox, ZkRequiredVerifier, SP1Verifier and Risc0Verifier wrappers;
    on-chain reads at block 26,431,535)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: top-callers-classification
  who: Review15 (review of the former finding unidentified-fb3ca570-snark-verifier, merged here)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract checks Taiko L2 state proofs by calling a sub-verifier for each sub-proof and requiring a sufficient set. It trusts the RISC Zero and SP1 sub-verifiers, which check BN254 proofs; a quantum attacker who recovers the setup trapdoors passes both.

## Evidence

- [verifyProof](https://etherscan.io/address/0x7284aac05555ae6559bdad8b4221ec9584254eec#code) calls each sub-verifier and reverts unless it accepts.
- [getVerifierAddress](https://etherscan.io/address/0x7284aac05555ae6559bdad8b4221ec9584254eec#code) maps RISC0_RETH and SP1_RETH ids to immutable verifier addresses.
- [verifyProof](https://etherscan.io/address/0x7284aac05555ae6559bdad8b4221ec9584254eec#code) requires the set of verifiers used to pass areVerifiersSufficient.

## Reviewer notes

### Mechanism

ComposeVerifier.verifyProof (lines 59-90) decodes SubProof[] (line 68), resolves each id via getVerifierAddress (lines 95-103; immutables set in the constructor, lines 50-55), and calls IProofVerifier(verifier).verifyProof (line 83), which reverts on a bad proof. Line 89 requires areVerifiersSufficient; per kev the ZkRequiredVerifier override accepts RISC0_RETH + SP1_RETH with no SGX leg. Those wrappers route to RISC Zero Groth16 and SP1 Plonk on BN254, so forged proofs pass and the inbox saves a false checkpoint used by the bridge.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable and has no owner; the fix is replacing it via the inbox owner.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
