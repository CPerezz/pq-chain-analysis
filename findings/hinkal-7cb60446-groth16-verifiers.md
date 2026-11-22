---
id: hinkal-7cb60446-groth16-verifiers
format: 2
title: Hinkal pool releases user deposits on proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged Groth16 proofs release pool deposits; MEDIUM as the owner can register new verifiers once
  new circuits exist.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7cb60446d7635c68edf1c568cac74a1f98c1cfa4'
  name: Hinkal
  project: hinkal
  code: verified
  code_url: https://etherscan.io/address/0x7cb60446d7635c68edf1c568cac74a1f98c1cfa4#code
  copies: 1
  upgradeable: 'no'
  admin: '0xf04310839973454155d9886a4023451f8d3db7d0'
value:
  usd: 64412
  basis: held
activity:
  txs_90d: 2171
impact: funds-loss
action: Build post-quantum circuits and verifiers, then registerVerifiers for every circuit id and removeVerifier
  the BN254 ones.
evidence_level: source
checks:
- id: c1
  source: '0x7cb60446d7635c68edf1c568cac74a1f98c1cfa4'
  file: contracts/Hinkal.sol
  line: 45
  has: verifyProof(
  says: transact calls verifyProof
  for:
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x7cb60446d7635c68edf1c568cac74a1f98c1cfa4'
  file: contracts/VerifierFacade.sol
  line: 57
  has: return verifier.verifyProof(a, b, c, input, verifierId);
  says: facade forwards the proof to the registered verifier
  for:
  - evidence-2
  - what
- id: reg
  source: '0x7cb60446d7635c68edf1c568cac74a1f98c1cfa4'
  file: contracts/VerifierFacade.sol
  has: ) external onlyOwner {
  line: 16
  says: registerVerifiers is restricted to the owner
  for:
  - action
  - evidence-3
  - justification
- id: rm
  source: '0x7cb60446d7635c68edf1c568cac74a1f98c1cfa4'
  file: contracts/VerifierFacade.sol
  has: function removeVerifier(uint256 verifierId) external onlyOwner {
  line: 23
  says: owner can remove a verifier
  for:
  - action
- id: map
  source: '0x7cb60446d7635c68edf1c568cac74a1f98c1cfa4'
  file: contracts/VerifierFacade.sol
  has: IVerifier verifier = verifierMap[verifierId];
  line: 52
  says: verifier is looked up from the configurable map
  for:
  - evidence-2
- id: invalid
  source: '0x7cb60446d7635c68edf1c568cac74a1f98c1cfa4'
  file: contracts/Hinkal.sol
  has: '"Invalid Proof"'
  line: 55
  says: transact reverts if the proof fails
  for:
  - evidence-1
- id: transfer
  source: '0x7cb60446d7635c68edf1c568cac74a1f98c1cfa4'
  file: contracts/Hinkal.sol
  has: transferERC20TokenOrETH(
  line: 218
  says: pool pays out tokens or ETH after the proof check
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
  who: Review23 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This Hinkal pool holds shielded deposits and pays out on transact only if the registered verifier accepts a Groth16 proof. A quantum attacker who recovers a circuit's setup trapdoor can forge a proof of a false spend and withdraw the pool's tokens.

## Evidence

- [transact](https://etherscan.io/address/0x7cb60446d7635c68edf1c568cac74a1f98c1cfa4#code) reverts with "Invalid Proof" unless verifyProof returns true.
- [verifyProof](https://etherscan.io/address/0x7cb60446d7635c68edf1c568cac74a1f98c1cfa4#code) forwards the proof to the verifier stored in verifierMap.
- [registerVerifiers](https://etherscan.io/address/0x7cb60446d7635c68edf1c568cac74a1f98c1cfa4#code) is onlyOwner and sets the verifier for each circuit id.

## Reviewer notes

### Mechanism

Hinkal.transact (line 30) builds circuit inputs via hinkalHelper.performHinkalChecks, then requires verifyProof(a,b,c,input,buildVerifierId(dimensions, externalActionId)) at lines 44-56. VerifierFacade.verifyProof (lines 45-58) loads verifierMap[verifierId] and returns verifier.verifyProof(...). The registered verifiers are wrappers around snarkjs-style BN254 Groth16 verifiers (by bytecode and trace). After a passing proof, _internalTransact pays out via transferERC20TokenOrETH to circomData.externalActionData.externalAddress (lines 217-223), or _externalTransact sends tokens to an external action. A forged proof from a recovered trapdoor therefore withdraws pool funds. registerVerifiers/removeVerifier (lines 13-26) are onlyOwner; owner is a timelock controlled by a 2-of-3 Safe, so verifiers can be swapped without an upgrade.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The six retired census verifiers are no longer reachable from any registry entry; live verifiers are still BN254 Groth16.
- Ruled out: No proxy: fix is configuration, not upgrade.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
