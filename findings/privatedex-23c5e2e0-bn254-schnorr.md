---
id: privatedex-23c5e2e0-bn254-schnorr
format: 2
title: PrivateDEX deposits rest on BN254 proofs a quantum attacker could forge
status: confirmed
severity: HIGH
justification: Deposit proofs rest on BN254 discrete logs a quantum computer breaks; the code is immutable, so a
  redeploy fixes it.
category: quantum-exposure
pattern: PQ-11
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x23c5e2e0128f0bf3a8d92cda02c9d3068887b13a'
  name: PrivateDEX
  project: houdini-swap
  code: verified
  code_url: https://etherscan.io/address/0x23c5e2e0128f0bf3a8d92cda02c9d3068887b13a#code
  copies: 1
  admin: '0x8a462a861e34939157c61d478e959dc18152fc2e'
value:
  usd: 13
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Redeploy with a post-quantum ownership proof, such as hash-based commitments with a STARK, and have depositors
  withdraw.
evidence_level: source
checks:
- id: c2
  source: '0x23c5e2e0128f0bf3a8d92cda02c9d3068887b13a'
  file: solidity/libs/BN254.sol
  line: 134
  has: success := staticcall(sub(gas(), 2000), 6, input, 0xc0, r, 0x60)
  says: BN254 point addition uses the ecAdd precompile.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x23c5e2e0128f0bf3a8d92cda02c9d3068887b13a'
  file: solidity/libs/BN254.sol
  line: 153
  has: success := staticcall(sub(gas(), 2000), 7, input, 0x80, r, 0x60)
  says: BN254 scalar multiplication uses the ecMul precompile.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: code
  code: '0x23c5e2e0128f0bf3a8d92cda02c9d3068887b13a'
  is: contract
  bytes: 14983
  says: The address holds deployed contract code.
  for:
  - justification
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

PrivateDEX holds token deposits and releases them on Schnorr-style proofs checked with BN254 curve addition and multiplication. A quantum attacker who solves the BN254 discrete log of a deposit's points forges a valid proof and withdraws that deposit.

## Evidence

- [pointAdd](https://etherscan.io/address/0x23c5e2e0128f0bf3a8d92cda02c9d3068887b13a#code) calls the BN254 ecAdd precompile (address 6).
- [mul](https://etherscan.io/address/0x23c5e2e0128f0bf3a8d92cda02c9d3068887b13a#code) calls the BN254 ecMul precompile (address 7) used to check the proof equation.

## Reviewer notes

### Mechanism

WithdrawERC20 in PrivateDEX.sol (lines 458-495) looks up the deposit by D.A.X and hashes the operation with sha256. It calls CryptoCore.VerifyProof (CryptoCore.sol lines 75-90), which checks R + e·D.B == z·D.A on BN254 G1 using BN254.mul (ecMul precompile 7, line 153) and BN254.pointAdd (ecAdd precompile 6, line 134). This is a Schnorr proof of knowledge of x with D.B = x·D.A. VerifyPoK and VerifyProofPrivate (an OR-composition with a nullifier) follow the same pattern for the private withdraw, transfer and aggregate paths. Recovering x by a quantum discrete-log attack lets anyone produce a valid proof, and the function then transfers nTokens to any address. Ownable only controls the whitelist, and the contract has no proxy, so the verifier cannot be replaced.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The pairing helper in BN254.sol is not on the withdrawal paths, so there is no trusted-setup SNARK.
- Ruled out: There is no proxy, and the owner functions only manage the whitelist.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
