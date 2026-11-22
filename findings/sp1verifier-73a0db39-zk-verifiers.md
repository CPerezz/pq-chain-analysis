---
id: sp1verifier-73a0db39-zk-verifiers
format: 2
title: Taiko SP1Verifier accepts BN254 Plonk proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: SP1 Plonk on BN254 has a trusted setup a quantum attacker can break; the Taiko DAO can fix it by
  upgrade, so MEDIUM.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x73a0db393ef87ce781ac7957be10d6628432100f'
  name: SP1Verifier
  project: taiko
  code: verified
  code_url: https://etherscan.io/address/0x73a0db393ef87ce781ac7957be10d6628432100f#code
  copies: 1
  upgradeable: 'no'
  admin: '0x75ba76403b13b26ad1bec70d6ee937314eeacd0a'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1917
impact: funds-loss
action: Replace the SP1 Plonk remote verifier with a post-quantum proof verifier through a DAO-approved upgrade.
evidence_level: source
checks:
- id: s-call
  source: '0x73a0db393ef87ce781ac7957be10d6628432100f'
  file: contracts/layer1/verifiers/SP1Verifier.sol
  has: (bool success,) = sp1RemoteVerifier.staticcall(
  line: 76
  says: The proof is checked by a staticcall to the remote SP1 verifier.
  for:
  - evidence-1
  - justification
  - what
- id: s-succ
  source: '0x73a0db393ef87ce781ac7957be10d6628432100f'
  file: contracts/layer1/verifiers/SP1Verifier.sol
  has: require(success, SP1_INVALID_PROOF());
  line: 83
  says: Acceptance depends on the remote call succeeding.
  for:
  - evidence-2
  - what
- id: s-remote
  source: '0x73a0db393ef87ce781ac7957be10d6628432100f'
  file: contracts/layer1/verifiers/SP1Verifier.sol
  has: address public immutable sp1RemoteVerifier;
  line: 13
  says: The remote verifier address is immutable.
  for:
  - action
  - evidence-1
  - justification
- id: s-agg
  source: '0x73a0db393ef87ce781ac7957be10d6628432100f'
  file: contracts/layer1/verifiers/SP1Verifier.sol
  has: require(isProgramTrusted[aggregationProgram], SP1_INVALID_AGGREGATION_VKEY());
  line: 64
  says: The aggregation program vkey must be trusted.
  for:
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

This contract checks Taiko's SP1 leg of a state proof: it requires trusted program keys, then accepts the proof when Succinct's remote verifier call succeeds. That remote verifier checks BN254 Plonk proofs, so a quantum attacker who recovers the setup trapdoor forges proofs this contract accepts.

## Evidence

- [verifyProof](https://etherscan.io/address/0x73a0db393ef87ce781ac7957be10d6628432100f#code) passes the proof to the immutable sp1RemoteVerifier by staticcall.
- [verifyProof](https://etherscan.io/address/0x73a0db393ef87ce781ac7957be10d6628432100f#code) reverts only if that remote call fails.

## Reviewer notes

### Mechanism

SP1Verifier.verifyProof (lines 50-84) reads the aggregation and block program vkeys from _proof[0:64] and requires isProgramTrusted for both (lines 64, 66). It builds the public input from the commitment hash and taikoChainId (lines 68-73), then staticcalls the immutable sp1RemoteVerifier (line 13, set in the constructor) with _proof[64:] (lines 76-81) and requires success (line 83). Per kev, the remote is Succinct's SP1VerifierGateway, which routes the live selector to SP1VerifierPlonk v6.1.0, a BN254 Plonk verifier. With the trapdoor recovered, a forged proof makes the call succeed; ZkRequiredVerifier then accepts it (paired with a forged RISC Zero proof) and the Shasta inbox finalizes a false state root that releases Bridge and vault funds.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: This contract holds no funds itself.
- Ruled out: Program vkeys are not attacker-chosen; only the owner sets them.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
