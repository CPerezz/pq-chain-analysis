---
id: solver-ae68b711-bungee-auction-signers
format: 2
title: Bungee Solver runs arbitrary calls for any holder of its ECDSA signer key
status: confirmed
severity: MEDIUM
justification: Solver authorises every action by one ECDSA key; only Bungee can fix it by deploying a new Solver,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xae68b7117be0026cbd4366303f74eecbb19e4042'
  name: Solver
  project: socket
  code: verified
  code_url: https://etherscan.io/address/0xae68b7117be0026cbd4366303f74eecbb19e4042#code
  copies: 1
  upgradeable: 'no'
  admin: '0xf76e73720ec93df7e823b755e10c38a877c34bd5'
value:
  usd: 3
  basis: held
activity:
  txs_90d: 28
impact: funds-loss
action: Deploy a Solver authorised by a post-quantum signature or post-quantum caller, and move inventory there.
evidence_level: source
checks:
- id: c1
  source: '0xae68b7117be0026cbd4366303f74eecbb19e4042'
  file: src/lib/AuthenticationLib.sol
  line: 23
  has: function recoverSigner(bytes32 _ethSignedMessageHash, bytes memory _signature) public pure returns (address)
    {
  says: recoverSigner is the signature recovery function.
  for:
  - evidence-2
- id: c2
  source: '0xae68b7117be0026cbd4366303f74eecbb19e4042'
  file: src/lib/AuthenticationLib.sol
  line: 25
  has: return ecrecover(_ethSignedMessageHash, v, r, s);
  says: Recovery uses ecrecover (secp256k1 ECDSA).
  for:
  - evidence-2
  - justification
  - what
- id: c5
  source: '0xae68b7117be0026cbd4366303f74eecbb19e4042'
  file: src/lib/AuthenticationLib.sol
  line: 12
  has: return recoverSigner(ethSignedMessageHash, signature);
  says: authenticate returns the recovered signer.
  for:
  - what
- id: c6
  source: '0xae68b7117be0026cbd4366303f74eecbb19e4042'
  file: src/solver/Solver.sol
  line: 63
  has: verifySignature(keccak256(abi.encode(block.chainid, address(this), nonce, action)), signature);
  says: performExtraction requires a signer signature.
  for:
  - justification
- id: c8
  source: '0xae68b7117be0026cbd4366303f74eecbb19e4042'
  file: src/solver/Solver.sol
  line: 351
  has: verifySignature(keccak256(abi.encode(block.chainid, address(this), nonce, approvals, actions)), signature);
  says: performActions requires a signer signature over its actions.
  for:
  - evidence-1
  - justification
  - what
- id: approve
  source: '0xae68b7117be0026cbd4366303f74eecbb19e4042'
  file: src/solver/Solver.sol
  has: SafeTransferLib.safeApprove(token, spender, amount);
  line: 378
  says: Solver approves signed token/spender/amount from its own holdings.
  for:
  - evidence-3
  - what
- id: perform
  source: '0xae68b7117be0026cbd4366303f74eecbb19e4042'
  file: src/solver/Solver.sol
  has: bool success = _performAction(actions[i]);
  line: 383
  says: Solver executes each signed action itself.
  for:
  - what
- id: setsigner
  source: '0xae68b7117be0026cbd4366303f74eecbb19e4042'
  file: src/solver/Solver.sol
  has: function setSolverSigner(address _solverSigner) external onlyOwner {
  line: 55
  says: Only the owner can change the signer, still an ECDSA address.
  for:
  - action
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review15 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

Bungee's Solver executes calls and token approvals from its own balance once a signature recovers to its stored signer key. A quantum attacker who derives that key from its public key can sign any action and take what the Solver holds.

## Evidence

- [performActions](https://etherscan.io/address/0xae68b7117be0026cbd4366303f74eecbb19e4042#code) checks a signature over the nonce, approvals and actions before running them.
- [recoverSigner](https://etherscan.io/address/0xae68b7117be0026cbd4366303f74eecbb19e4042#code) returns the ecrecover result for the eth-signed hash.
- [performActions](https://etherscan.io/address/0xae68b7117be0026cbd4366303f74eecbb19e4042#code) approves any token to any spender named in the signed approvals.

## Reviewer notes

### Mechanism

performExtraction (line 63), performSettlement (96), performFulfilment (142), performBatchFulfilment (240) and performActions (351) call verifySignature over keccak256(abi.encode(block.chainid, this, nonce, ...)). verifySignature compares SOLVER_SIGNER to AuthenticationLib.authenticate, which applies the eth_sign prefix (line 20) and ecrecover (line 25) on a 65-byte signature. After a fresh nonce, performActions sets SafeTransferLib.safeApprove for each signed approval (line 378) and runs _performAction on each Action (line 383), calling arbitrary targets with value from the Solver's balance. setSolverSigner (line 55) is onlyOwner, so rotating the key keeps the ECDSA check; the fix is a new deployment.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Users do not approve tokens to the Solver; exposure is the Solver's own balance.
- Ruled out: The MOFA key and Entrypoint are a separate contract, outside this card.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
