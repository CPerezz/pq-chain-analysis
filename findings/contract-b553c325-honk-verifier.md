---
id: contract-b553c325-honk-verifier
format: 2
title: Payy's BN254 Honk verifier accepts proofs a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: BN254 proofs fall to a quantum attacker with the setup trapdoor; Payy's owner can swap the verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb553c325959c8615d9018f00906aec3799b94200'
  project: payy
  code: decompiled
  code_url: code/0xb79b5793bc9d298e53695f69f39c8b36e375cd455f283d88361b179035f79093.sol
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0xb553c325959c8615d9018f00906aec3799b94200'
  has: 60055afa
  says: the code calls the modexp precompile
  for:
  - evidence-3
- id: b2
  bytecode: '0xb553c325959c8615d9018f00906aec3799b94200'
  has: 60075afa
  says: the code calls the BN254 multiplication precompile
  for:
  - evidence-2
  - justification
  - what
- id: b3
  bytecode: '0xb553c325959c8615d9018f00906aec3799b94200'
  has: 60065afa
  says: the code calls the BN254 addition precompile
  for:
  - evidence-2
  - justification
  - what
- id: b4
  bytecode: '0xb553c325959c8615d9018f00906aec3799b94200'
  has: 60055afa
  says: the code calls modexp at a second site
  for:
  - evidence-3
- id: sel
  selector: '0xb553c325959c8615d9018f00906aec3799b94200'
  fn: verify(bytes,bytes32[])
  says: the Honk verify(bytes,bytes32[]) selector is in the code
  for:
  - evidence-1
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
  who: review (Review22)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract checks BN254 Honk proofs through verify(bytes,bytes32[]), using the BN254 addition and multiplication precompiles. A quantum attacker who recovers the setup trapdoor can build proofs that it accepts for false statements.

## Evidence

- [The runtime code](https://etherscan.io/address/0xb553c325959c8615d9018f00906aec3799b94200#code) exposes the Honk verify function as its entry point.
- [The runtime code](https://etherscan.io/address/0xb553c325959c8615d9018f00906aec3799b94200#code) calls the BN254 multiplication and addition precompiles.
- [The runtime code](https://etherscan.io/address/0xb553c325959c8615d9018f00906aec3799b94200#code) calls the modexp precompile for field arithmetic.

## Reviewer notes

### Mechanism

Unverified 23,661-byte contract that exposes selector 0xea50d0e4 = verify(bytes,bytes32[]), the Barretenberg HonkVerifier interface. Its runtime code calls modexp (offsets 10597, 20090) and the BN254 ecMul/ecAdd precompiles (offsets 12038, 12052), which fits a KZG-based UltraHonk check over BN254. Per kev, Payy RollupV1.verifyRollup calls zkVerifiers[key].verifier.verify(aggrProof, publicInputs) after the onlyProver and validator ECDSA checks, then sets rootHash. Burns in that root pay USDC out through executeBurn. Kev reports that this verifier is no longer enabled: zkVerifierKeys points only to HonkVerifier 0x14dacd53. The RollupV1 owner Safe can add or remove verifiers with addZkVerifier and removeZkVerifier.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not currently enabled in RollupV1 per kev's state read; the active verifier is 0x14dacd53.
- Ruled out: A forged root also needs the prover and validator ECDSA keys.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
