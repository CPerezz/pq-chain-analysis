---
id: hinkal-25e5e82f-groth16-verifiers
format: 2
title: Hinkal pool releases user deposits on proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Pool funds move on a forgeable BN254 proof; the owner can register post-quantum verifiers once new
  circuits exist.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x25e5e82f5702a27c3466fe68f14abdbbadfca826'
  name: Hinkal
  project: hinkal
  code: verified
  code_url: https://etherscan.io/address/0x25e5e82f5702a27c3466fe68f14abdbbadfca826#code
  copies: 1
  admin: '0xbdc77a0c69f13207acb70a6981cad60b4c1d1942'
value:
  usd: 5278
  basis: held
activity:
  txs_90d: 7
impact: funds-loss
action: Build post-quantum circuits, deploy their verifiers and have the owner register them in place of the BN254
  ones.
evidence_level: source
checks:
- id: c1
  source: '0x25e5e82f5702a27c3466fe68f14abdbbadfca826'
  file: contracts/Hinkal.sol
  line: 55
  has: verifyProof(
  says: transact calls verifyProof
  for:
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x25e5e82f5702a27c3466fe68f14abdbbadfca826'
  file: contracts/VerifierFacade.sol
  line: 45
  has: function verifyProof(
  says: facade verifyProof entry
  for:
  - evidence-2
- id: c4
  source: '0x25e5e82f5702a27c3466fe68f14abdbbadfca826'
  file: contracts/VerifierFacade.sol
  line: 57
  has: return verifier.verifyProof(a, b, c, input, verifierId);
  says: facade returns the registered verifier's result
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c6
  source: '0x25e5e82f5702a27c3466fe68f14abdbbadfca826'
  file: '@openzeppelin/contracts/access/Ownable2Step.sol'
  line: 35
  has: function transferOwnership(address newOwner) public virtual override onlyOwner {
  says: ownership is Ownable2Step, owner-gated
  for:
  - action
  - justification
- id: w1
  source: '0x25e5e82f5702a27c3466fe68f14abdbbadfca826'
  file: contracts/Hinkal.sol
  has: '"Invalid Proof"'
  line: 62
  says: transact reverts unless the proof verifies
  for:
  - evidence-1
  - what
- id: w2
  source: '0x25e5e82f5702a27c3466fe68f14abdbbadfca826'
  file: contracts/Hinkal.sol
  has: circomData.externalAddress,
  line: 314
  says: withdrawals pay the address given in proof data
  for:
  - evidence-3
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

This Hinkal pool moves shielded deposits in transact only after a registered Groth16 verifier accepts the proof. A quantum attacker who recovers a circuit's BN254 setup trapdoor can forge a spend proof and withdraw the pool's tokens.

## Evidence

- [transact](https://etherscan.io/address/0x25e5e82f5702a27c3466fe68f14abdbbadfca826#code) requires verifyProof to return true, else reverts with "Invalid Proof".
- [VerifierFacade.verifyProof](https://etherscan.io/address/0x25e5e82f5702a27c3466fe68f14abdbbadfca826#code) forwards the proof to the registered verifier and returns its answer.
- [transact](https://etherscan.io/address/0x25e5e82f5702a27c3466fe68f14abdbbadfca826#code) then sends tokens to the external address named in the proof data.

## Reviewer notes

### Mechanism

Hinkal.transact (line 40) gets the circuit inputs from hinkalHelper.performHinkalChecks. It then requires verifyProof(a, b, c, inputForCircom, buildVerifierId(dimensions, externalActionId)) at lines 54-63. VerifierFacade.verifyProof (line 45) looks up the verifier for that id and returns verifier.verifyProof(...) (line 57). Per kev's traces, the registered verifiers are snarkjs-style Groth16 verifiers on BN254 precompiles. After the proof passes, _internalTransact pays withdrawals with transferToken to circomData.externalAddress (line 312). A forged proof from a recovered trapdoor therefore drains the pool. Per kev, registerVerifiers and removeVerifier are owner-only under Ownable2Step, so the owner EOA can swap in post-quantum verifiers without an upgrade.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The six census verifiers are retired; no registry entry reaches them since the re-registration.
- Ruled out: No EIP-1967 proxy slots on the pool.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
