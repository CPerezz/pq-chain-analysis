---
id: gnosissafe-4e8a4894-owner-ecdsa-keys
format: 2
title: Safe owners approve with ECDSA keys a quantum attacker could forge
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
  address: '0x4e8a4894275780f571aad53122e641d9f50ff04f'
  name: GnosisSafe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
value:
  usd: 145
  basis: held
activity:
  txs_90d: 156
impact: funds-loss
action: Replace EOA owners with post-quantum signer contracts via swapOwner, which then sign through isValidSignature.
evidence_level: source
checks:
- id: c1
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 295
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: eth_sign-flow signatures are recovered with ecrecover.
  for:
  - evidence-2
  - what
- id: c2
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Standard owner signatures are recovered with ecrecover over the transaction hash.
  for:
  - evidence-1
  - justification
  - what
- id: c-1271
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "GS024");
  line: 285
  says: Contract owners are verified through their own isValidSignature with the full signature.
  for:
  - action
  - evidence-3
  - justification
- id: c-owner
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  line: 301
  says: Each recovered signer must be an owner of the Safe.
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
reviews: []
related: []
---

## What happens

This Safe executes a transaction once threshold-many owners approve, and an EOA owner approves with an ECDSA signature checked by ecrecover. A quantum attacker who recovers threshold-many owner keys can sign transactions that move the Safe's assets or change its owners.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) recovers the signer with ecrecover(dataHash, v, r, s) for standard signatures.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) also recovers eth_sign-prefixed signatures with ecrecover when v > 30.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) accepts contract owners through isValidSignature on the full signature.

## Reviewer notes

### Mechanism

The proxy delegates to the GnosisSafe 1.3.0 singleton. execTransaction calls checkSignatures/checkNSignatures, which loops over threshold-many 65-byte slots. v == 0 (lines 257-285): contract owner, verified by ISignatureValidator(owner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE. v == 1 (lines 286-291): owner is msg.sender or pre-approved the hash via approveHash. v > 30 (line 295): ecrecover over the eth_sign-prefixed hash. Otherwise (line 299): ecrecover(dataHash, v, r, s). Line 301 requires the recovered address to be an owner in ascending order. An EOA owner is satisfied only via ecrecover or its own transaction, so forging its secp256k1 key from a published public key yields a valid approval. With threshold-many forged keys the attacker can execute any call, including swapOwner, changeThreshold or asset transfers. Replacing EOA owners with contract owners routes their approval through isValidSignature instead.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No guard is set on this Safe.
- Ruled out: No modules are enabled on this Safe.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
