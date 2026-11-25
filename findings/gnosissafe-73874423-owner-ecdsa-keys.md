---
id: gnosissafe-73874423-owner-ecdsa-keys
format: 2
title: Safe multisig accepts ECDSA owner signatures that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Owner ECDSA keys authorize everything; MEDIUM because owners can swap EOAs for post-quantum signer
  contracts now.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x738744237b7fd97af670d9ddf54390c24263cea8'
  name: GnosisSafe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
value:
  usd: 776
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace EOA owners with post-quantum signer contracts via swapOwner, approved by the current threshold.
evidence_level: source
checks:
- id: c1
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 295
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: eth_sign-style signatures are verified with ecrecover.
  for:
  - evidence-2
  - what
- id: c2
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Default owner signatures are verified with ecrecover over the transaction hash.
  for:
  - evidence-1
  - justification
  - what
- id: c-1271
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  line: 285
  says: Contract owners are verified via EIP-1271 with the full signature.
  for:
  - action
  - evidence-3
  - justification
- id: c-owner
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0)
  line: 301
  says: Each recovered signer must be a current owner.
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

This Safe executes a transaction once threshold-many owners approve it, and an EOA owner approves with an ECDSA signature checked by ecrecover. A quantum attacker who recovers threshold-many owner keys could move the Safe's assets or change its owners.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) recovers the signer with ecrecover over the transaction hash.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) also recovers eth_sign-style signatures with ecrecover.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) checks contract owners through isValidSignature.

## Reviewer notes

### Mechanism

The proxy delegates to the GnosisSafe 1.3.0 singleton. checkNSignatures loops over threshold-many 65-byte slots. v==0 treats r as a contract owner and requires isValidSignature(data, contractSignature) to return the EIP-1271 magic value (line 285). v==1 accepts an approveHash or msg.sender (line 291). v>30 runs ecrecover on the eth_sign-prefixed hash (line 295); otherwise ecrecover(dataHash, v, r, s) (line 299). Line 301 requires each recovered address to be an owner, in ascending order. An EOA owner is satisfied only through ecrecover or a transaction it sends itself, so forging threshold-many ECDSA signatures passes this check. Owner changes need the same threshold, so a contract owner using a post-quantum scheme removes that owner's ECDSA path.

### Checks

- Header facts: this address alone, at block 26,438,999.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
