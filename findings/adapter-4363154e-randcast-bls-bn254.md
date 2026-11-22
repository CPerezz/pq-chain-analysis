---
id: adapter-4363154e-randcast-bls-bn254
format: 2
title: ARPA Randcast outputs can be predicted by a quantum attacker
status: confirmed
severity: MEDIUM
justification: BN254 BLS keys fall to a quantum attacker; ARPA's owner can fix it only by a UUPS upgrade, so MEDIUM.
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4363154e1ec107f81239a4f0b1cb3ab5161129ca'
  name: Adapter
  project: arpa
  code: verified
  code_url: https://etherscan.io/address/0x2b4045c4ad431cefeb93518ed2a87fecc03aeac3#code
  proxy_of: '0x2b4045c4ad431cefeb93518ed2a87fecc03aeac3'
  copies: 1
  upgradeable: 'yes'
  admin: '0xfdeede3aa92583a46a419190c3e58d035b1fe060'
value:
  usd: 181
  basis: held
activity:
  txs_90d: 37
impact: funds-loss
action: Upgrade the Adapter to a post-quantum randomness scheme and move ownership to a post-quantum account.
evidence_level: source
checks:
- id: c1
  source: '0x2b4045c4ad431cefeb93518ed2a87fecc03aeac3'
  file: src/libraries/BLS.sol
  line: 58
  has: success := staticcall(sub(gas(), 2000), 8, input, 384, out, 0x20)
  says: verifySingle runs the BN254 pairing precompile (address 8).
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x2b4045c4ad431cefeb93518ed2a87fecc03aeac3'
  file: src/libraries/BLS.sol
  line: 96
  has: success := staticcall(sub(gas(), 2000), 8, input, 384, out, 0x20)
  says: verifyPartials runs the BN254 pairing precompile on aggregated partials.
  for:
  - evidence-2
  - what
- id: c4
  source: '0x2b4045c4ad431cefeb93518ed2a87fecc03aeac3'
  file: lib/openzeppelin-contracts-upgradeable/contracts/access/OwnableUpgradeable.sol
  line: 74
  has: function transferOwnership(address newOwner) public virtual onlyOwner {
  says: The owner can transfer ownership to a new account.
  for:
  - action
- id: c5
  source: '0x2b4045c4ad431cefeb93518ed2a87fecc03aeac3'
  file: lib/openzeppelin-contracts-upgradeable/contracts/proxy/utils/UUPSUpgradeable.sol
  line: 74
  has: function upgradeTo(address newImplementation) public virtual onlyProxy {
  says: UUPS upgradeTo lets the Adapter's code be replaced.
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
  who: Review07 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

The Adapter accepts a randomness fulfilment when a BN254 pairing check verifies the node group's BLS signature. A quantum attacker who recovers a group key from its public key learns every randomness output early and can fulfil requests itself.

## Evidence

- [verifySingle](https://etherscan.io/address/0x2b4045c4ad431cefeb93518ed2a87fecc03aeac3#code) checks the group signature with the BN254 pairing precompile.
- [verifyPartials](https://etherscan.io/address/0x2b4045c4ad431cefeb93518ed2a87fecc03aeac3#code) checks the members' aggregated partial signatures with the same pairing.
- [upgradeTo](https://etherscan.io/address/0x2b4045c4ad431cefeb93518ed2a87fecc03aeac3#code) lets the owner replace the Adapter's code.

## Reviewer notes

### Mechanism

Adapter.fulfillRandomness (Adapter.sol line 530) calls _verifySignature, which hashes seed and block number to a G1 point (line 995). It then checks the group signature with BLS.verifySingle(BLS.decompress(signature), g.publicKey, message) (line 998) and the members' partials with BLS.verifyPartials (line 1014). Both functions call the BN254 pairing precompile at address 8 (BLS.sol lines 58 and 96). The output is keccak256 of the signature (line 587) and is passed to the consumer callback (line 593). A BLS signature is unique per key and message, so the group secret key reveals each output once the request is made. Members' keys also let an attacker produce the partials and fulfil. _authorizeUpgrade is onlyOwner (line 187), and upgradeTo/upgradeToAndCall are inherited from UUPSUpgradeable.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: A forger cannot choose the output, because the BLS signature is unique for a key and message.
- Ruled out: Subscription payments go to the members whose partials verify, so a forged fulfilment cannot redirect them.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
