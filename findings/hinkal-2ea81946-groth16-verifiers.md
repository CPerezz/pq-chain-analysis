---
id: hinkal-2ea81946-groth16-verifiers
format: 2
title: Hinkal pool releases deposits on Groth16 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Live verifiers are BN254 Groth16; the owner can register post-quantum ones, but new circuits must
  be built first.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2ea81946ff675d5eb88192144ffc1418fa442e28'
  name: Hinkal
  project: hinkal
  code: verified
  code_url: https://etherscan.io/address/0x2ea81946ff675d5eb88192144ffc1418fa442e28#code
  copies: 1
  upgradeable: 'no'
  admin: '0xbdc77a0c69f13207acb70a6981cad60b4c1d1942'
value:
  usd: 13362
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Build post-quantum circuits, deploy their verifiers, call registerVerifiers for every id and removeVerifier
  for BN254 ones.
evidence_level: source
checks:
- id: c1
  source: '0x2ea81946ff675d5eb88192144ffc1418fa442e28'
  file: contracts/Hinkal.sol
  line: 113
  has: verifyProof(
  says: _transact calls verifyProof inside a require.
  for:
  - evidence-1
  - what
- id: c3
  source: '0x2ea81946ff675d5eb88192144ffc1418fa442e28'
  file: contracts/VerifierFacade.sol
  line: 57
  has: return verifier.verifyProof(a, b, c, input, verifierId);
  says: Facade forwards the proof to the registered verifier.
  for:
  - evidence-2
  - justification
  - what
- id: inv
  source: '0x2ea81946ff675d5eb88192144ffc1418fa442e28'
  file: contracts/Hinkal.sol
  has: '"Invalid Proof"'
  line: 120
  says: A failed proof reverts the transaction.
  for:
  - evidence-1
- id: map
  source: '0x2ea81946ff675d5eb88192144ffc1418fa442e28'
  file: contracts/VerifierFacade.sol
  has: IVerifier verifier = verifierMap[verifierId];
  line: 52
  says: Verifier is looked up from the registry by id.
  for:
  - evidence-2
- id: reg
  source: '0x2ea81946ff675d5eb88192144ffc1418fa442e28'
  file: contracts/VerifierFacade.sol
  has: ) external onlyOwner {
  line: 16
  says: registerVerifiers is restricted to the owner.
  for:
  - action
  - evidence-3
  - justification
- id: rm
  source: '0x2ea81946ff675d5eb88192144ffc1418fa442e28'
  file: contracts/VerifierFacade.sol
  has: function removeVerifier(uint256 verifierId) external onlyOwner {
  line: 23
  says: Owner can remove a verifier.
  for:
  - action
- id: xfer
  source: '0x2ea81946ff675d5eb88192144ffc1418fa442e28'
  file: contracts/Hinkal.sol
  has: transferToken(
  line: 275
  says: Withdrawals transfer pool tokens out after the proof check.
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

This Hinkal pool holds shielded deposits and moves tokens in transact only after a Groth16 proof passes the verifier registered for the circuit. A quantum attacker who recovers a circuit's setup trapdoor can forge a spend proof and withdraw the pool's tokens.

## Evidence

- [_transact](https://etherscan.io/address/0x2ea81946ff675d5eb88192144ffc1418fa442e28#code) requires verifyProof to pass, else reverts with "Invalid Proof".
- [verifyProof](https://etherscan.io/address/0x2ea81946ff675d5eb88192144ffc1418fa442e28#code) calls the verifier stored in verifierMap for the circuit id.
- [registerVerifiers](https://etherscan.io/address/0x2ea81946ff675d5eb88192144ffc1418fa442e28#code) is onlyOwner and replaces the verifier per id.

## Reviewer notes

### Mechanism

transact (Hinkal.sol l.47) calls _transact, which at l.112-121 requires verifyProof(a,b,c,inputForCircom,buildVerifierId(dimensions, externalActionId)). VerifierFacade.verifyProof (l.45-58) loads verifierMap[verifierId] and returns verifier.verifyProof(...). Per kev's traces, the current registered verifier is a BN254 Groth16 verifier. On success _internalTransact (l.241-283) calls transferToken to circomData.externalAddress for negative amountChanges, paying out pool funds. registerVerifiers (VerifierFacade l.13-21) and removeVerifier (l.23-26) are onlyOwner; the owner is an EOA per kev, so swapping in post-quantum verifiers needs no upgrade.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The retired census verifiers are no longer reachable from any registry entry.
- Ruled out: No proxy: the fix is configuration, not an upgrade.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
