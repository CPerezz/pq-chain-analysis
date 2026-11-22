---
id: skaleverifier-32f50e2a-bls-bn254
format: 2
title: SKALE verifier trusts BN254 BLS chain signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: BN254 BLS keys fall to a quantum computer; SKALE's Safe can fix it by upgrading the verifier behind
  its proxy.
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x32f50e2a898f14687f2a714d8b2d405317eb4641'
  name: SkaleVerifier
  project: skale
  code: verified
  code_url: https://etherscan.io/address/0x82146bb2b2997ccf5449bc6f162cd446f39a1251#code
  proxy_of: '0x82146bb2b2997ccf5449bc6f162cd446f39a1251'
  copies: 1
  upgradeable: 'yes'
  admin: '0xf3f8b7594bf20a0e9502b3191cd4c2b90a1ab4f7'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 20
impact: funds-loss
action: Upgrade the verifier to a post-quantum threshold or hash-based signature scheme for SKALE chain messages.
evidence_level: source
checks:
- id: c1
  source: '0x82146bb2b2997ccf5449bc6f162cd446f39a1251'
  file: contracts/utils/Precompiled.sol
  line: 108
  has: success := staticcall(not(0), 8, inputToPairing, mul(12, 0x20), out, 0x20)
  says: bn256Pairing calls the BN254 pairing precompile (address 8).
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x82146bb2b2997ccf5449bc6f162cd446f39a1251'
  file: contracts/utils/Precompiled.sol
  line: 70
  has: success := staticcall(not(0), 7, inputToMul, 0x60, output, 0x40)
  says: bn256ScalarMul calls the BN254 multiplication precompile (address 7).
  for:
  - evidence-2
- id: code
  code: '0x32f50e2a898f14687f2a714d8b2d405317eb4641'
  is: contract
  bytes: 2240
  says: The address holds deployed contract code.
  for:
  - action
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

SkaleVerifier checks SKALE chain BLS signatures on BN254 with the pairing precompile. A quantum attacker who recovers a chain's BLS key forges signatures this verifier accepts as valid.

## Evidence

- [bn256Pairing](https://etherscan.io/address/0x82146bb2b2997ccf5449bc6f162cd446f39a1251#code) calls the BN254 pairing precompile at address 8.
- [bn256ScalarMul](https://etherscan.io/address/0x82146bb2b2997ccf5449bc6f162cd446f39a1251#code) uses the BN254 multiplication precompile.

## Reviewer notes

### Mechanism

Kev's finding traces this path: MessageProxyForMainnet.postIncomingMessages requires a node sender (isAgentAuthorized) and _verifyMessages, which calls Schains.verifySchainSignature. That function calls SkaleVerifier.verify with the chain's common BLS public key from KeyStorage. verify (SkaleVerifier.sol 55 ff.) checks the curve points and then calls Precompiled.bn256Pairing, which runs the staticcall to precompile 8 at Precompiled.sol line 108. If the call fails it reverts at line 110, and otherwise it returns out[0] != 0 at line 111. The source shown here backs only the pairing call in Precompiled.sol; verify's own lines and the IMA contracts are not shown. Kev's finding says verified messages release funds from the IMA deposit boxes, and that relaying them also needs one node's ECDSA key.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Key rotation through DKG keeps BLS on BN254, so it does not remove the exposure.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
