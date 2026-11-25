---
id: gnosissafe-fa771871-owner-ecdsa-keys
format: 2
title: Safe multisig accepts ECDSA owner signatures that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Recovered owner keys let an attacker move funds; MEDIUM as owners can swap EOAs for post-quantum
  signer contracts.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xfa771871d3d5c85e156d3d379e2ff7699c4d6a66'
  name: GnosisSafe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
value:
  usd: 1
  basis: held
activity:
  txs_90d: 45
impact: funds-loss
action: Replace EOA owners with post-quantum signer contracts via swapOwner, validated through isValidSignature.
evidence_level: source
checks:
- id: c1
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 295
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: eth_sign flow recovers the owner with ecrecover.
  for:
  - what
- id: c2
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Default flow recovers the owner with ecrecover over the data hash.
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
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0)
  line: 301
  says: Each recovered signer must be a current owner, in ascending order.
  for:
  - evidence-2
  - what
- id: c5
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: require(owners[msg.sender] != address(0), "GS030");
  line: 334
  says: Owners can approve hashes on-chain as an alternative to signatures.
  for:
  - justification
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

This Safe runs any transaction once threshold-many owners approve, and an EOA owner approves with an ECDSA signature. A quantum attacker who recovers threshold-many owner keys can sign as those owners and move the Safe's assets or change its owners.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) uses ecrecover on the transaction hash to identify the signing owner.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) accepts the recovered address if it is a current owner, in ascending order.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) also accepts contract owners through isValidSignature on the full signature.

## Reviewer notes

### Mechanism

execTransaction calls checkNSignatures, which loops over threshold-many 65-byte slots. v == 0 treats r as a contract owner and requires isValidSignature(data, contractSignature) to return the EIP-1271 magic value (line 285). v == 1 requires msg.sender or an approveHash entry (line 291). v > 30 runs ecrecover over the eth_sign-prefixed hash (line 295); otherwise ecrecover(dataHash, v, r, s) (line 299). Line 301 requires each recovered address to be an owner, strictly ascending. An EOA owner is satisfied through ecrecover, so its secp256k1 key is the exposure; a contract owner is checked only through its own isValidSignature, so swapping EOAs for post-quantum signer contracts removes the ECDSA path.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract owners are not exposed through ecrecover; they are validated via isValidSignature or approveHash.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
