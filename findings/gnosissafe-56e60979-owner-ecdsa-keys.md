---
id: gnosissafe-56e60979-owner-ecdsa-keys
format: 2
title: Safe multisig accepts ECDSA owner signatures that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Owner ECDSA keys authorize everything; MEDIUM since owners can swap EOAs for post-quantum signer
  contracts.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x56e60979d5934a05d22606b0455d52f59f20a6a0'
  name: GnosisSafe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
value:
  usd: 442609
  basis: held
activity:
  txs_90d: 5
impact: funds-loss
action: Swap EOA owners for post-quantum signer contracts via swapOwner.
evidence_level: source
checks:
- id: c1
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 295
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: eth_sign-flow signatures are verified with ecrecover.
  for:
  - evidence-2
  - what
- id: c2
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Standard owner signatures are verified with ecrecover.
  for:
  - evidence-1
  - justification
  - what
- id: c3
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "GS024");
  line: 285
  says: Contract owners are verified via isValidSignature on the full signature.
  for:
  - action
  - evidence-3
  - justification
- id: c4
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  line: 301
  says: Each recovered signer must be a distinct owner.
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
  who: review (Review04)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (source of 1.3.0 read, two real transactions replayed four ways; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
  pattern: PQ-12
reviews: []
related: []
---

## What happens

This Safe runs a transaction once threshold-many owners approve, and an EOA owner approves with an ECDSA signature checked by ecrecover. A quantum attacker who recovers threshold-many owner keys can sign as those owners and move the Safe's assets.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) recovers the signer with ecrecover(dataHash, v, r, s) for standard signatures.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) also accepts eth_sign-style signatures through ecrecover when v > 30.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) checks contract owners through isValidSignature with the full signature.

## Reviewer notes

### Mechanism

The proxy delegates to the GnosisSafe 1.3.0 singleton. In checkNSignatures, each 65-byte slot is split into v, r and s. v == 0 is a contract signature checked with ISignatureValidator(owner).isValidSignature on the full appended signature (line 285). v == 1 is an approved hash or msg.sender owner (line 291). v > 30 uses ecrecover of the eth_sign-prefixed hash (line 295). Otherwise it uses ecrecover(dataHash, v, r, s) (line 299). Line 301 requires each recovered address to be an owner, in ascending order. An EOA owner's secp256k1 key therefore authorizes execTransaction, and so do owner changes made through swapOwner or changeThreshold. Owner public keys follow from posted signatures. The contract-owner path at line 285 lets owners replace EOAs with post-quantum signer contracts.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No guard is set on this Safe (kev's census).

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
