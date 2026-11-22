---
id: sp1verifier-c3c6ddda-sp1-verifier
format: 2
title: SP1 Plonk verifier accepts BN254 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged BN254 proofs pass; MEDIUM because gateway admins can add a hash-based route and freeze this
  one.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc3c6dddac8829b233dc6536ec024775a57b0af2a'
  name: SP1Verifier
  project: succinct
  code: verified
  code_url: https://etherscan.io/address/0xc3c6dddac8829b233dc6536ec024775a57b0af2a#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 19098
impact: funds-loss
action: Add a hash-based SP1 verifier route in the gateways and freeze the routes that point to this BN254 verifier.
evidence_level: source
checks:
- id: c1
  source: '0xc3c6dddac8829b233dc6536ec024775a57b0af2a'
  file: src/v6.1.0/SP1VerifierPlonk.sol
  line: 51
  has: function verifyProof(
  says: verifyProof is the external entry point of this verifier.
  for:
  - justification
  - what
- id: c4
  source: '0xc3c6dddac8829b233dc6536ec024775a57b0af2a'
  file: src/v6.1.0/PlonkVerifier.sol
  line: 901
  has: let l_success := staticcall(gas(), 8, mPtr, 0x180, 0x00, 0x20)
  says: Pairing check calls BN254 pairing precompile 8.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c81
  source: '0xc3c6dddac8829b233dc6536ec024775a57b0af2a'
  file: src/v6.1.0/SP1VerifierPlonk.sol
  has: bool success = this.Verify(proofBytes[100:], inputs);
  line: 81
  says: verifyProof delegates acceptance to the Plonk Verify routine.
  for:
  - evidence-1
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review11 (Claude), finding review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This immutable SP1 verifier accepts a program's public values when a Plonk proof on BN254 checks out through the pairing precompile. A quantum attacker with the setup trapdoor forges a proof for any output, which consumers routed here accept.

## Evidence

- [verifyProof](https://etherscan.io/address/0xc3c6dddac8829b233dc6536ec024775a57b0af2a#code) passes the proof to the Plonk Verify routine and reverts if it fails.
- [check_pairing_kzg](https://etherscan.io/address/0xc3c6dddac8829b233dc6536ec024775a57b0af2a#code) ends in the BN254 pairing precompile at address 8.

## Reviewer notes

### Mechanism

SP1Verifier.verifyProof (SP1VerifierPlonk.sol line 51) checks three things: the proof's first four bytes match VERIFIER_HASH, exitCode is 0, and vkRoot equals VK_ROOT. At line 81 it calls this.Verify(proofBytes[100:], inputs). The inputs are programVKey, the sha256 digest of the public values, exitCode, vkRoot and nonce. PlonkVerifier uses the ecMul precompile (7) at lines 852, 1286 and 1304. check_pairing_kzg at line 901 makes the final BN254 pairing call through precompile 8. Plonk soundness rests on the discrete-log hardness of the KZG setup. A quantum attacker who recovers the trapdoor produces a proof for arbitrary public values. Consumers reach this verifier through the Plonk gateway and AgglayerGateway route 0x0000000e. The contract is immutable, so the fix is in the gateway routes.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no funds itself.
- Ruled out: Not upgradeable; no admin on the verifier.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
