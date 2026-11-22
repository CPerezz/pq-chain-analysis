---
id: posqlverifier-99f5bed8-sxt-proof-of-sql-verifier
format: 2
title: Space and Time PoSQLVerifier accepts SQL proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: 'Fix needs Space and Time to deploy a hash-based verifier and clients to point new queries at it:
  MEDIUM.'
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x99f5bed89c638d8f67f7c132a18da349ac04ed18'
  name: PoSQLVerifier
  project: space-and-time
  code: verified
  code_url: https://etherscan.io/address/0x99f5bed89c638d8f67f7c132a18da349ac04ed18#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Deploy a Proof of SQL verifier with a hash-based commitment scheme and have zkPay clients name it as custom
  logic.
evidence_level: source
checks:
- id: is-custom-logic
  source: '0x99f5bed89c638d8f67f7c132a18da349ac04ed18'
  file: src/PoSQLVerifier.sol
  has: contract PoSQLVerifier is ICustomLogic {
  line: 9
  says: PoSQLVerifier implements ICustomLogic for zkPay
  for:
  - action
  - evidence-1
  - justification
  - what
- id: imports-verifier
  source: '0x99f5bed89c638d8f67f7c132a18da349ac04ed18'
  file: src/PoSQLVerifier.sol
  has: import {Verifier} from "sxt-proof-of-sql-0.100.10/solidity/src/verifier/Verifier.post.sol";
  line: 7
  says: Imports the sxt Proof of SQL verifier
  for:
  - evidence-2
  - justification
  - what
- id: pairing-call
  source: '0x99f5bed89c638d8f67f7c132a18da349ac04ed18'
  file: dependencies/sxt-proof-of-sql-0.100.10/solidity/src/verifier/Verifier.post.sol
  has: staticcall(ECPAIRINGX2_GAS, ECPAIRING_ADDRESS
  line: 141
  says: Proof check uses the BN254 pairing precompile
  for:
  - evidence-2
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

PoSQLVerifier is the zkPay custom logic that checks Space and Time Proof of SQL results. It trusts HyperKZG openings checked with the BN254 pairing precompile. A quantum attacker who recovers the setup trapdoor could pass false query results to client contracts.

## Evidence

- [PoSQLVerifier](https://etherscan.io/address/0x99f5bed89c638d8f67f7c132a18da349ac04ed18#code) implements the zkPay ICustomLogic interface.
- [PoSQLVerifier](https://etherscan.io/address/0x99f5bed89c638d8f67f7c132a18da349ac04ed18#code) imports the Proof of SQL Verifier, which checks proofs with a BN254 pairing.

## Reviewer notes

### Mechanism

ZKPay.fulfillQuery is permissionless. It calls ICustomLogic(customLogicContractAddress).execute(queryRequest, queryResult), passes the result to the client's zkPayCallback, and settles the escrowed fee to the custom logic's PAYOUT_ADDRESS. PoSQLVerifier.execute (lines 396-412) calls verify (383-393), which calls Verifier.__verify from sxt-proof-of-sql 0.100.10. That function checks HyperKZG with ec_pairing_x2 (Verifier.post.sol lines 140-145, a staticcall to the ECPAIRING precompile) against the VK_TAU_H constants. Anyone who knows the trusted-setup trapdoor tau, which a quantum computer could recover from the verifying key, can forge openings for any result. The fee goes to PAYOUT_ADDRESS, not to the fulfiller.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Fulfiller does not receive the query fee; it goes to PAYOUT_ADDRESS
- Ruled out: Verifier holds no funds
- Ruled out: Not upgradeable

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
