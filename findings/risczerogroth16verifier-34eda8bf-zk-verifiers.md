---
id: risczerogroth16verifier-34eda8bf-zk-verifiers
format: 2
title: Taiko RISC Zero Groth16 verifier accepts proofs a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: BN254 Groth16 rests on a setup trapdoor a quantum computer recovers; the Taiko DAO can swap in post-quantum
  verifiers.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x34eda8bffb539aec33078819847b36d221c6641c'
  name: RiscZeroGroth16Verifier
  project: taiko
  code: verified
  code_url: https://etherscan.io/address/0x34eda8bffb539aec33078819847b36d221c6641c#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Keep this verifier out of Taiko's proof path and move to post-quantum verifiers through a DAO upgrade.
evidence_level: source
checks:
- id: c1
  source: '0x34eda8bffb539aec33078819847b36d221c6641c'
  file: node_modules/risc0-ethereum/contracts/src/groth16/RiscZeroGroth16Verifier.sol
  line: 166
  has: bool verified = this.verifyProof(
  says: _verifyIntegrity accepts the seal based on the Groth16 verifyProof result.
  for:
  - evidence-1
  - what
- id: c2
  source: '0x34eda8bffb539aec33078819847b36d221c6641c'
  file: node_modules/risc0-ethereum/contracts/src/groth16/Groth16Verifier.sol
  line: 69
  has: function verifyProof(
  says: Groth16Verifier.verifyProof is the proof check.
  for:
  - evidence-2
  - justification
  - what
- id: c3
  source: '0x34eda8bffb539aec33078819847b36d221c6641c'
  file: node_modules/risc0-ethereum/contracts/src/groth16/Groth16Verifier.sol
  line: 168
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: verifyProof calls the BN254 pairing precompile (address 8).
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x34eda8bffb539aec33078819847b36d221c6641c'
  file: node_modules/risc0-ethereum/contracts/src/groth16/Groth16Verifier.sol
  line: 91
  has: success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)
  says: The public-input combination uses the BN254 ecMul precompile (address 7).
  for:
  - evidence-3
- id: c5
  source: '0x34eda8bffb539aec33078819847b36d221c6641c'
  file: node_modules/risc0-ethereum/contracts/src/groth16/Groth16Verifier.sol
  line: 101
  has: success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: The public-input combination uses the BN254 ecAdd precompile (address 6).
  for:
  - evidence-3
- id: ver
  source: '0x34eda8bffb539aec33078819847b36d221c6641c'
  file: node_modules/risc0-ethereum/contracts/src/groth16/RiscZeroGroth16Verifier.sol
  has: string public constant VERSION = "2.2.0";
  line: 59
  says: This verifier is RISC Zero version 2.2.0.
  for:
  - evidence-3
- id: sel
  source: '0x34eda8bffb539aec33078819847b36d221c6641c'
  file: node_modules/risc0-ethereum/contracts/src/groth16/RiscZeroGroth16Verifier.sol
  has: if (SELECTOR != bytes4(seal[:4])) {
  line: 159
  says: The seal must carry this verifier's selector before the proof is checked.
  for:
  - evidence-1
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

This contract verifies RISC Zero receipts by checking a Groth16 proof with BN254 pairings against fixed public inputs. A quantum attacker who recovers the setup trapdoor can build a proof that this check accepts for any claim.

## Evidence

- [_verifyIntegrity](https://etherscan.io/address/0x34eda8bffb539aec33078819847b36d221c6641c#code) accepts a seal when the Groth16 verifyProof call returns true.
- [verifyProof](https://etherscan.io/address/0x34eda8bffb539aec33078819847b36d221c6641c#code) decides validity with the BN254 pairing precompile at address 8.
- [The verifier](https://etherscan.io/address/0x34eda8bffb539aec33078819847b36d221c6641c#code) is RISC Zero version 2.2.0 and builds its public input with BN254 ecMul and ecAdd.

## Reviewer notes

### Mechanism

verify/verifyIntegrity call _verifyIntegrity (lines 145-183). It checks that the seal's first 4 bytes equal SELECTOR (line 159), decodes the seal into points a, b and c, and calls this.verifyProof (line 166) with CONTROL_ROOT halves, the claim digest halves and BN254_CONTROL_ID as public inputs. Groth16Verifier.verifyProof (line 69) range-checks the inputs. It then computes vk_x with ecMul and ecAdd (lines 91 and 101) and runs the ecPairing precompile (line 168) against the hard-coded alpha, beta, gamma and delta keys. Anyone holding the trusted-setup trapdoor, which a quantum computer can derive from these BN254 points, can produce a, b and c that satisfy the pairing for any claim digest. Per kev's finding, in Taiko this RISC Zero 2.2.0 copy is not referenced by any live wrapper. Its last call was in 2025, and the live RISC Zero leg routes to a different 3.0.0 verifier.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not referenced by any live Taiko wrapper per kev's finding; the live path uses RiscZeroGroth16Verifier 3.0.0 behind the RISC Zero router.
- Ruled out: Holds no funds itself; not upgradeable, no admin.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
