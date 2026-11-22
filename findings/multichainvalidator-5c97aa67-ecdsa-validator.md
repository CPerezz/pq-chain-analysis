---
id: multichainvalidator-5c97aa67-ecdsa-validator
format: 2
title: ZeroDev MultiChainValidator lets a quantum attacker take over Kernel accounts
status: confirmed
severity: MEDIUM
justification: One ECDSA owner key controls each account; owners can switch validators in place once a post-quantum
  module exists.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5c97aa67ba578e3c54ec5942a7563ea9130e4f5f'
  name: MultiChainValidator
  project: zerodev
  code: verified
  code_url: https://etherscan.io/address/0x5c97aa67ba578e3c54ec5942a7563ea9130e4f5f#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 860
impact: funds-loss
action: Ship a post-quantum ERC-7579 validator so account owners can change their root validator and uninstall this
  one.
evidence_level: source
checks:
- id: c1
  source: '0x5c97aa67ba578e3c54ec5942a7563ea9130e4f5f'
  file: src/validator/MultiChainValidator.sol
  line: 63
  has: if (owner == ECDSA.recover(userOpHash, sig)) {
  says: validateUserOp accepts a 65-byte signature if ECDSA recovers the owner from the raw hash.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x5c97aa67ba578e3c54ec5942a7563ea9130e4f5f'
  file: src/validator/MultiChainValidator.sol
  line: 67
  has: address recovered = ECDSA.recover(ethHash, sig);
  says: validateUserOp also accepts the owner recovered from the eth-signed hash.
  for:
  - evidence-1
- id: c3
  source: '0x5c97aa67ba578e3c54ec5942a7563ea9130e4f5f'
  file: src/validator/MultiChainValidator.sol
  line: 85
  has: if (owner == ECDSA.recover(merkleRoot, ecdsaSig)) {
  says: validateUserOp accepts an ECDSA signature by the owner over the Merkle root.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x5c97aa67ba578e3c54ec5942a7563ea9130e4f5f'
  file: src/validator/MultiChainValidator.sol
  line: 89
  has: address merkleRecovered = ECDSA.recover(ethRoot, ecdsaSig);
  says: validateUserOp accepts the owner's signature over the eth-signed Merkle root.
  for:
  - evidence-2
- id: c5
  source: '0x5c97aa67ba578e3c54ec5942a7563ea9130e4f5f'
  file: src/validator/MultiChainValidator.sol
  line: 105
  has: if (owner == ECDSA.recover(hash, sig)) {
  says: isValidSignatureWithSender accepts the owner recovered from the raw hash.
  for:
  - evidence-3
  - what
- id: c6
  source: '0x5c97aa67ba578e3c54ec5942a7563ea9130e4f5f'
  file: src/validator/MultiChainValidator.sol
  line: 109
  has: address recovered = ECDSA.recover(ethHash, sig);
  says: isValidSignatureWithSender accepts the owner recovered from the eth-signed hash.
  for:
  - evidence-3
- id: c7
  source: '0x5c97aa67ba578e3c54ec5942a7563ea9130e4f5f'
  file: src/validator/MultiChainValidator.sol
  line: 120
  has: if (owner == ECDSA.recover(merkleRoot, ecdsaSig)) {
  says: isValidSignatureWithSender accepts the owner's signature over a Merkle root.
  for:
  - evidence-3
- id: c8
  source: '0x5c97aa67ba578e3c54ec5942a7563ea9130e4f5f'
  file: src/validator/MultiChainValidator.sol
  line: 124
  has: address merkleRecovered = ECDSA.recover(ethRoot, ecdsaSig);
  says: isValidSignatureWithSender accepts the owner's signature over the eth-signed Merkle root.
  for:
  - evidence-3
- id: oninstall
  source: '0x5c97aa67ba578e3c54ec5942a7563ea9130e4f5f'
  file: src/validator/MultiChainValidator.sol
  has: ecdsaValidatorStorage[msg.sender].owner = owner;
  line: 32
  says: onInstall stores one owner address per installing account.
  for:
  - action
  - justification
  - what
- id: merkle
  source: '0x5c97aa67ba578e3c54ec5942a7563ea9130e4f5f'
  file: src/validator/MultiChainValidator.sol
  has: require(MerkleProofLib.verify(proof, merkleRoot, userOpHash), "hash is not in proof");
  line: 82
  says: A user op is accepted when its hash is proven inside a signed Merkle root.
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
- study: top-callers-classification
  who: Review08 (verified validator and Kernel sources)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This module validates user operations and ERC-1271 signatures for ZeroDev Kernel accounts against one secp256k1 owner set at install. A quantum attacker who recovers that owner key signs user operations and takes what the account holds; one Merkle-root signature also covers other chains.

## Evidence

- [validateUserOp](https://etherscan.io/address/0x5c97aa67ba578e3c54ec5942a7563ea9130e4f5f#code) succeeds when ECDSA recovers the stored owner from the user-op hash.
- [validateUserOp](https://etherscan.io/address/0x5c97aa67ba578e3c54ec5942a7563ea9130e4f5f#code) accepts one ECDSA signature over a Merkle root of user-op hashes.
- [isValidSignatureWithSender](https://etherscan.io/address/0x5c97aa67ba578e3c54ec5942a7563ea9130e4f5f#code) returns the ERC-1271 magic value when ECDSA recovers the owner.

## Reviewer notes

### Mechanism

onInstall (lines 29-34) stores the 20-byte owner for msg.sender (the Kernel account). validateUserOp (53-94): for a 65-byte signature it returns success if ECDSA.recover of userOpHash or its eth-signed hash equals the owner (lines 63, 67). For longer signatures it verifies a Merkle proof that userOpHash is in merkleRoot (line 82), then checks ECDSA.recover of merkleRoot or its eth-signed form against the owner (85, 89), so one signature authorises user ops on several chains. isValidSignatureWithSender (96-129) applies the same checks for ERC-1271 (105, 109, 120, 124). A quantum attacker who derives the owner's secp256k1 key from a public signature forges all of these. The module is not upgradeable and holds no funds. The exposure is the balances of the Kernel accounts that installed it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The module itself holds no funds.
- Ruled out: The module is not a proxy and has no admin.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
