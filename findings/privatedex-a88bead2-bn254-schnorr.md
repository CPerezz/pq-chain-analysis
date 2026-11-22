---
id: privatedex-a88bead2-bn254-schnorr
format: 2
title: PrivateDEX deposits fall to quantum-forged BN254 Schnorr proofs
status: confirmed
severity: HIGH
justification: Deposit proofs rest on BN254 discrete logs; the owner fixes it only with a new deployment.
category: quantum-exposure
pattern: PQ-11
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa88bead2811b26b5d01c8dc8ba0db1b26516735a'
  name: PrivateDEX
  project: houdini-swap
  code: verified
  code_url: https://etherscan.io/address/0xa88bead2811b26b5d01c8dc8ba0db1b26516735a#code
  copies: 1
  admin: '0x8a462a861e34939157c61d478e959dc18152fc2e'
value:
  usd: 1
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Redeploy with a post-quantum ownership proof (hash commitments with a STARK, or post-quantum signatures);
  depositors withdraw.
evidence_level: source
checks:
- id: c2
  source: '0xa88bead2811b26b5d01c8dc8ba0db1b26516735a'
  file: solidity/libs/BN254.sol
  line: 134
  has: success := staticcall(sub(gas(), 2000), 6, input, 0xc0, r, 0x60)
  says: pointAdd calls the BN254 ecAdd precompile (address 6).
  for:
  - evidence-1
  - justification
  - what
- id: c3
  source: '0xa88bead2811b26b5d01c8dc8ba0db1b26516735a'
  file: solidity/libs/BN254.sol
  line: 153
  has: success := staticcall(sub(gas(), 2000), 7, input, 0x80, r, 0x60)
  says: mul calls the BN254 ecMul precompile (address 7).
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xa88bead2811b26b5d01c8dc8ba0db1b26516735a'
  file: '@openzeppelin/contracts/access/Ownable.sol'
  line: 84
  has: function transferOwnership(address newOwner) public virtual onlyOwner {
  says: The contract has an owner who can transfer ownership.
  for:
  - action
  - evidence-3
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

PrivateDEX holds token deposits as BN254 G1 points and releases them on Schnorr-style proofs verified with the curve add and multiply precompiles. A quantum attacker who solves a deposit's discrete log can forge such a proof and withdraw that deposit.

## Evidence

- [pointAdd](https://etherscan.io/address/0xa88bead2811b26b5d01c8dc8ba0db1b26516735a#code) calls the BN254 ecAdd precompile used to check proofs.
- [mul](https://etherscan.io/address/0xa88bead2811b26b5d01c8dc8ba0db1b26516735a#code) calls the BN254 ecMul precompile used to check proofs.
- [transferOwnership](https://etherscan.io/address/0xa88bead2811b26b5d01c8dc8ba0db1b26516735a#code) is the owner's control; it changes the owner, not the proof check.

## Reviewer notes

### Mechanism

WithdrawERC20 (PrivateDEX.sol lines 458-495) looks up the deposit by D.A.X, hashes the operation with sha256 and calls CryptoCore.VerifyProof(D, p, messageHashed), then transfers nTokens to any addr. VerifyProof (CryptoCore.sol lines 75-90) checks R + e*D.B == z*D.A on BN254 G1 using BN254.mul (ecMul precompile 7, line 153) and BN254.pointAdd (ecAdd precompile 6, line 134). This is a Schnorr proof of knowledge of x with D.B = x*D.A; VerifyPoK and VerifyProofPrivate (OR-composition with a nullifier) cover the other paths. Solving the discrete log of D.B over D.A yields x and valid proofs. BN254.pairing (line 76) is not used on these paths. Ownable functions only manage the whitelist; no proxy.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not a SNARK or trusted-setup verifier: pairing is not used on the withdraw paths.
- Ruled out: Owner functions do not change the proof check.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
