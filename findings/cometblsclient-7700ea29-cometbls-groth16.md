---
id: cometblsclient-7700ea29-cometbls-groth16
format: 2
title: Union light client accepts headers a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: Groth16 on BN254 breaks with a quantum computer; Union's admin can fix it by upgrading the client,
  so MEDIUM.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7700ea295f62989d2c98721389a521c96fe3c4c0'
  name: CometblsClient
  project: union
  code: verified
  code_url: https://etherscan.io/address/0xf2b24b085080cef91f7bffdc6358fe054999e15f#code
  proxy_of: '0xf2b24b085080cef91f7bffdc6358fe054999e15f'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 111
impact: funds-loss
action: Replace the Groth16/BN254 header proof with a hash-based proof over post-quantum validator signatures and
  upgrade the client.
evidence_level: source
checks:
- id: c1
  source: '0xf2b24b085080cef91f7bffdc6358fe054999e15f'
  file: contracts/clients/CometblsClient.sol
  line: 643
  has: return CometblsZKVerifier.verifyProof(
  says: internalVerifyZKP returns the result of the Groth16 verifier.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xf2b24b085080cef91f7bffdc6358fe054999e15f'
  file: contracts/lib/CometblsZKVerifier.sol
  line: 190
  has: function verifyProof(
  says: verifyProof is the Groth16 verifier on BN254.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xf2b24b085080cef91f7bffdc6358fe054999e15f'
  file: libs/@openzeppelin-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol
  line: 92
  has: function upgradeToAndCall(address newImplementation, bytes memory data) public payable virtual onlyProxy
    {
  says: The client is UUPS upgradeable via upgradeToAndCall.
  for:
  - evidence-3
- id: inputs
  source: '0xf2b24b085080cef91f7bffdc6358fe054999e15f'
  file: contracts/clients/CometblsClient.sol
  has: header.appHash,
  line: 631
  says: The header's appHash is part of the proof's public input.
  for:
  - evidence-1
  - what
- id: pair
  source: '0xf2b24b085080cef91f7bffdc6358fe054999e15f'
  file: contracts/lib/CometblsZKVerifier.sol
  has: success := staticcall(gas(), PRECOMPILE_VERIFY, f, 0x300, f, 0x20)
  line: 237
  says: The Groth16 proof is checked with the BN254 pairing precompile.
  for:
  - evidence-2
  - what
- id: upg
  source: '0xf2b24b085080cef91f7bffdc6358fe054999e15f'
  file: contracts/clients/CometblsClient.sol
  has: internal override restricted {}
  line: 650
  says: Upgrades are authorized by the access manager.
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
- study: top-callers-classification
  who: Review11 (Claude), finding review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This client accepts a new Union header when a Groth16 proof on BN254 verifies against a fixed verifying key. A quantum attacker with the setup trapdoor can prove a header with any state root and then prove fake IBC packets against it.

## Evidence

- [internalVerifyZKP](https://etherscan.io/address/0xf2b24b085080cef91f7bffdc6358fe054999e15f#code) hashes the header's appHash into the public input of a Groth16 proof.
- [verifyProof](https://etherscan.io/address/0xf2b24b085080cef91f7bffdc6358fe054999e15f#code) checks the proof with the BN254 pairing precompile.
- [_authorizeUpgrade](https://etherscan.io/address/0xf2b24b085080cef91f7bffdc6358fe054999e15f#code) is restricted by the access manager, so the admin can upgrade the client.

## Reviewer notes

### Mechanism

IBCHandler.updateClient calls CometblsClient.updateClient (onlyIBC), then verifyHeader and internalVerifyZKP (line 608). Lines 623-634 sha256 the chainId, height, time, validatorsHash, nextValidatorsHash, appHash and trusted validators hash into one public input. Line 643 calls CometblsZKVerifier.verifyProof (line 190), which runs publicInputMSM, verifyProofCommitmentPOK (pairing check, line 175) and the Groth16 pairing check on precompile 0x08 (line 237). The accepted appHash becomes the consensus root used by verifyMembership for IBC packets. Upgrades go through _authorizeUpgrade (line 648, restricted).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The client itself holds no escrow; the funds sit in Union's ZKGM app.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
