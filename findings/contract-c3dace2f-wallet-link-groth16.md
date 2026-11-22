---
id: contract-c3dace2f-wallet-link-groth16
format: 2
title: OKX CEX wallet-link Groth16 verifier lets a quantum attacker forge proofs
status: candidate
severity: LOW
justification: Setup trapdoor forgeable by a quantum attacker; LOW because one OKX pauser can disable the path by
  pausing the registry.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc3dace2faf78f7bd7eb4c837f73ed81ed5135b88'
  project: okx
  code: decompiled
  code_url: code/0xd40fa1b6b61a9066689423308e927b53801f2721bea2b4218104b7b5fce21d26.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 12112
impact: funds-loss
action: Pause the key-hash registry now; deploy a validator with a hash-based proof and post-quantum cosigner.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0xc3dace2faf78f7bd7eb4c837f73ed81ed5135b88'
  has: 60076107d05a03fa
  says: The code calls the BN254 multiplication precompile.
  for:
  - evidence-2
  - what
- id: b2
  bytecode: '0xc3dace2faf78f7bd7eb4c837f73ed81ed5135b88'
  has: 60066107d05a03fa
  says: The code calls the BN254 addition precompile.
  for:
  - evidence-2
  - what
- id: b3
  bytecode: '0xc3dace2faf78f7bd7eb4c837f73ed81ed5135b88'
  has: 60086107d05a03fa
  says: The code calls the BN254 pairing precompile.
  for:
  - evidence-3
  - justification
  - what
- id: sel
  selector: '0xc3dace2faf78f7bd7eb4c837f73ed81ed5135b88'
  fn: verifyProof(uint256[2],uint256[2][2],uint256[2],uint256[37])
  says: the line or bytes the card cites
  for:
  - action
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
reviews: []
related: []
---

## What happens

This contract checks Groth16 proofs over the BN254 curve for OKX's CEX wallet link, using elliptic-curve multiplication, addition and a pairing check. A quantum attacker who recovers the setup trapdoor can produce proofs that this verifier accepts.

## Evidence

- [verifyProof](https://etherscan.io/address/0xc3dace2faf78f7bd7eb4c837f73ed81ed5135b88#code) takes 37 public inputs and is exposed by the code.
- [The code](https://etherscan.io/address/0xc3dace2faf78f7bd7eb4c837f73ed81ed5135b88#code) calls the BN254 multiplication and addition precompiles.
- [The code](https://etherscan.io/address/0xc3dace2faf78f7bd7eb4c837f73ed81ed5135b88#code) ends its check with a BN254 pairing precompile call.

## Reviewer notes

### Mechanism

The unverified verifier exposes verifyProof(uint256[2],uint256[2][2],uint256[2],uint256[37]) (selector 0x76852571). Its runtime staticcalls precompile 0x07 (ecMul, offset 166) and 0x06 (ecAdd, offset 212) to fold the 37 public inputs, then 0x08 (ecPairing, offset 4018): a BN254 Groth16 check. Per kev, the OKX CEX Wallet ZK validator calls it after registry.isKeyHashValid; together with an ECDSA cosigner signature, a per-user clone can then execute calls (e.g. addOwner) on users' OKX smart wallets. The verifier is not upgradeable; the registry's pauser can pause, making the ZK validator fail.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Verifier holds no funds and has no owner or proxy.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
