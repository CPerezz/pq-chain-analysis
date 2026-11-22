---
id: verifier-5290e958-lite-plonk-verifier
format: 2
title: zkSync Lite verifier accepts BN254 PLONK proofs a quantum attacker could forge
status: confirmed
severity: LOW
justification: Forgeable BN254 proofs, but rollup is in exodus mode so proofs release nothing; no fix needed while
  that holds.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5290e9582b4fb706eadf87bb1c129e897e04d06d'
  name: Verifier
  project: zksync
  code: verified
  code_url: https://etherscan.io/address/0x57b09100e6160503abdebc76012b6c358ea4e462#code
  proxy_of: '0x57b09100e6160503abdebc76012b6c358ea4e462'
  copies: 1
  upgradeable: 'yes'
  admin: '0x38a43f4330f24fe920f943409709fc9a6084c939'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
evidence_level: source
checks:
- id: c4
  source: '0x57b09100e6160503abdebc76012b6c358ea4e462'
  file: cache/solpp-generated-contracts/PlonkCore.sol
  line: 233
  has: function pairing(G1Point[] memory p1, G2Point[] memory p2) internal view returns (bool) {
  says: pairing helper over BN254
  for:
  - what
- id: c5
  source: '0x57b09100e6160503abdebc76012b6c358ea4e462'
  file: cache/solpp-generated-contracts/PlonkCore.sol
  line: 249
  has: success := staticcall(gas(), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
  says: calls the BN254 pairing precompile
  for:
  - evidence-2
  - justification
  - what
- id: c7
  source: '0x57b09100e6160503abdebc76012b6c358ea4e462'
  file: cache/solpp-generated-contracts/PlonkCore.sol
  line: 268
  has: return pairing(p1, p2);
  says: pairingProd2 delegates to pairing
  for:
  - evidence-2
- id: c8
  source: '0x57b09100e6160503abdebc76012b6c358ea4e462'
  file: cache/solpp-generated-contracts/PlonkCore.sol
  line: 968
  has: valid = PairingsBn254.pairingProd2(
  says: verify decides validity by a pairing check
  for:
  - evidence-2
  - what
- id: v-agg
  source: '0x57b09100e6160503abdebc76012b6c358ea4e462'
  file: cache/solpp-generated-contracts/Verifier.sol
  has: function verifyAggregatedBlockProof(
  line: 22
  says: block proof verification entry point
  for:
  - evidence-1
  - justification
  - what
- id: v-exit
  source: '0x57b09100e6160503abdebc76012b6c358ea4e462'
  file: cache/solpp-generated-contracts/Verifier.sol
  has: return verify_old(proof, vk);
  line: 79
  says: exit proofs verified with the old PLONK verifier
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
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This verifier checks zkSync Lite block proofs and exit proofs as PLONK proofs on BN254, using the pairing precompile. A quantum attacker who recovers the setup trapdoor could forge proofs that this check accepts.

## Evidence

- [verifyAggregatedBlockProof](https://etherscan.io/address/0x57b09100e6160503abdebc76012b6c358ea4e462#code) verifies block proofs with recursion over BN254 commitments.
- [verify](https://etherscan.io/address/0x57b09100e6160503abdebc76012b6c358ea4e462#code) accepts a proof when a two-pair BN254 pairing check passes.

## Reviewer notes

### Mechanism

Verifier.verifyAggregatedBlockProof (Verifier.sol lines 22-46) calls verify_serialized_proof_with_recursion, which reaches verify_recursive (PlonkCore.sol 978-1008); this runs aggregate_for_verification and then PairingsBn254.pairingProd2 (line 1006), which calls pairing (233-253), the precompile at address 8 (line 249). verifyExitProof (48-80) uses verify_old on the same curve. Soundness rests on the BN254 trusted setup and discrete log. Per kev, the only caller, ZkSync.proveBlocks, reverts under requireActive since exodus mode is set, and funds moved to a claim distributor, so a forged proof releases nothing.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier holds no funds itself
- Ruled out: verifyExitProof is no longer called by the current ZkSync implementation (per kev)

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
