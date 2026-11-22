---
id: contract-7f1a3e12-plonk-verifier-bn254
format: 2
title: Scroll Halo2 verifier trusts BN254 proofs that a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: Its BN254 KZG proof check is forgeable with the setup trapdoor; Scroll's timelocked owner chooses
  which verifiers count.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7f1a3e1299f44baefe20cb2bcd62a75ca00c20d6'
  project: scroll
  code: decompiled
  code_url: code/0x30af8474d8e13b8ce6a96eae63293310e7c1072b890bde77f96786497a9e5f4b.sol
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
  bytecode: '0x7f1a3e1299f44baefe20cb2bcd62a75ca00c20d6'
  has: 60055afa
  says: The runtime code calls the modexp precompile at offset 7598.
  for:
  - evidence-2
  - what
- id: b2
  bytecode: '0x7f1a3e1299f44baefe20cb2bcd62a75ca00c20d6'
  has: 60055afa
  says: The runtime code calls the modexp precompile at offset 13129.
  for:
  - evidence-2
- id: b3
  bytecode: '0x7f1a3e1299f44baefe20cb2bcd62a75ca00c20d6'
  has: 60055afa
  says: The runtime code calls the modexp precompile at offset 13690.
  for:
  - evidence-2
- id: b4
  bytecode: '0x7f1a3e1299f44baefe20cb2bcd62a75ca00c20d6'
  has: 60075afa
  says: The runtime code calls the BN254 ecmul precompile at offset 15529.
  for:
  - evidence-1
  - justification
  - what
- id: code
  code: '0x7f1a3e1299f44baefe20cb2bcd62a75ca00c20d6'
  is: contract
  bytes: 18498
  says: The address holds 18,498 bytes of contract code.
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

This contract is bytecode-only Scroll proof-verifier code that does BN254 elliptic-curve and modular arithmetic through EVM precompiles. Its proof check rests on BN254 KZG, so a quantum attacker who recovers the setup trapdoor could forge proofs it accepts.

## Evidence

- [Runtime code](https://etherscan.io/address/0x7f1a3e1299f44baefe20cb2bcd62a75ca00c20d6#code) calls the BN254 multiplication precompile (0x07).
- [Runtime code](https://etherscan.io/address/0x7f1a3e1299f44baefe20cb2bcd62a75ca00c20d6#code) calls the modexp precompile at three offsets, used for field inversions in the verifier.

## Reviewer notes

### Mechanism

Bytecode-only contract (18,498 bytes, fallback-only per decompiler). It is snark-verifier style Halo2/PLONK code over BN254. The runtime code has a staticcall to precompile 0x07 (ecmul) at offset 15529 and to precompile 0x05 (modexp) at offsets 7598, 13129 and 13690. According to kev's finding, ScrollChain historically reached this verifier through MultipleVersionRollupVerifier via a ZkEvmVerifier wrapper's plonkVerifier(). Kev's finding states that it is no longer registered for any version. The risk is that KZG on BN254 can be forged with a trapdoor recovered from the SRS. Kev's fix is onchain config: the ScrollOwner, behind a 3-day timelock, can register hash-based verifiers via updateVerifier.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Holds no ETH or tokens itself (per kev's on-chain read).
- Ruled out: Not upgradeable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
