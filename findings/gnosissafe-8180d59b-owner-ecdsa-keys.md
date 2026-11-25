---
id: gnosissafe-8180d59b-owner-ecdsa-keys
format: 2
title: Safe multisig accepts ECDSA owner signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Owner ECDSA keys authorize everything; owners can fix it themselves by swapping EOAs for post-quantum
  signer contracts.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8180d59b7175d4064bdfa8138a58e9babffda44a'
  name: GnosisSafe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
value:
  usd: 4900291
  basis: held
activity:
  txs_90d: 39
impact: funds-loss
action: Swap EOA owners for post-quantum signer contracts via swapOwner, approved by the current threshold.
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
  says: Default owner signatures are verified with ecrecover over the data hash.
  for:
  - evidence-1
  - justification
  - what
- id: c-1271
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE
  line: 285
  says: Contract owners are verified by their own isValidSignature.
  for:
  - action
  - evidence-3
  - justification
- id: c-owner
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: owners[currentOwner] != address(0)
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

This Safe executes transactions once threshold-many owners approve, and an EOA owner approves with a signature checked by ecrecover. A quantum attacker who recovers threshold-many owner keys can sign any transaction and move the Safe's holdings.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) recovers the signer with ecrecover over the transaction hash.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) also accepts eth_sign signatures through ecrecover.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) lets contract owners approve through isValidSignature.

## Reviewer notes

### Mechanism

The proxy delegates to the GnosisSafe 1.3.0 singleton. In checkNSignatures (lines 256-302), each 65-byte slot's v selects the scheme: v==0 calls ISignatureValidator(owner).isValidSignature on the full contract signature (line 285); v==1 requires msg.sender or approvedHashes (line 291); v>30 ecrecovers the eth_sign-prefixed hash (line 295); otherwise ecrecover(dataHash, v, r, s) (line 299). Line 301 requires each recovered address to be an owner, in ascending order. An EOA owner is satisfied by ecrecover, so recovering threshold-many owner private keys from their public keys lets an attacker authorize execTransaction, including swapOwner or a singleton change. Contract owners go through isValidSignature instead, so replacing EOA owners with post-quantum signer contracts removes the ECDSA path.

### Checks

- Header facts: this address alone, at block 26,438,999.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
