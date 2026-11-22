---
id: contract-9f66505c-plonk-verifier-bn254
format: 2
title: Retired Scroll verifier relies on BN254 proofs a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: BN254 KDF setup trapdoor lets proofs be forged; MEDIUM because Scroll's timelocked owner picks which
  verifier is live.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9f66505cb1626d06b50ef2597f41de6686e8f79a'
  project: scroll
  code: decompiled
  code_url: code/0x91816743ec15118a4ddacb13c830e56e9f8b28f1c875dfc458a27142a88c9fc8.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x9f66505cb1626d06b50ef2597f41de6686e8f79a'
  has: 60055afa
  says: The runtime code calls modexp at offset 7598.
  for:
  - evidence-2
  - justification
  - what
- id: b2
  bytecode: '0x9f66505cb1626d06b50ef2597f41de6686e8f79a'
  has: 60055afa
  says: The runtime code calls modexp at offset 13129.
  for:
  - evidence-2
  - what
- id: b3
  bytecode: '0x9f66505cb1626d06b50ef2597f41de6686e8f79a'
  has: 60055afa
  says: The runtime code calls modexp at offset 13690.
  for:
  - evidence-2
  - what
- id: b4
  bytecode: '0x9f66505cb1626d06b50ef2597f41de6686e8f79a'
  has: 60075afa
  says: The runtime code calls BN254 ecMul at offset 15529.
  for:
  - evidence-1
  - justification
  - what
- id: code
  code: '0x9f66505cb1626d06b50ef2597f41de6686e8f79a'
  is: contract
  bytes: 18498
  says: The address holds contract code.
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
  who: hand classification (Claude Opus agents reading verified source and bytecode), for 0x9f66505c
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review13 (0x9f66505c deployer, wrapper and caller trace; Scroll verifier registry reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
- study: top-callers-classification
  who: Review14 (verified source of the current verifier, verifier registry and bridge reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode), for 0x39854df3
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review01 (0x39854df3 creator, last caller trace, bytecode constants, verifier registry reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract is bytecode-only proof-verifier code that does its checks with BN254 elliptic-curve multiplication and modular exponentiation. A quantum attacker who recovers the BN254 setup trapdoor can build proofs that this code accepts.

## Evidence

- The [runtime code](https://etherscan.io/address/0x9f66505cb1626d06b50ef2597f41de6686e8f79a#code) calls the BN254 multiplication precompile.
- The [runtime code](https://etherscan.io/address/0x9f66505cb1626d06b50ef2597f41de6686e8f79a#code) calls the modexp precompile at three places, used for field arithmetic.

## Reviewer notes

### Mechanism

Fallback-only snark-verifier code (18,498 bytes, no verified source). The runtime code calls modexp (0x05) at offsets 7598, 13129 and 13690, and BN254 ecMul (0x07) at offset 15529. In kev's finding, this address is the plonkVerifier() of the ZkEvmVerifierPostEuclid wrapper 0x33996cc9. That wrapper served ScrollChain finalizeBundlePostEuclidV2 calls. It is no longer the latestVerifier for any version in MultipleVersionRollupVerifier. A forged BN254 KZG proof would pass this code. It only reaches ScrollChain funds if the ScrollOwner timelock registers the wrapper again.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Holds no ETH or tokens itself.
- Ruled out: Not registered as the latest verifier for any version, per kev's finding.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
