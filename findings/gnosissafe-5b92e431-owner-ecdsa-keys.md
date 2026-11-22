---
id: gnosissafe-5b92e431-owner-ecdsa-keys
format: 2
title: This Safe accepts owner ECDSA signatures that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Owners approve with ECDSA; owners can swap EOAs for post-quantum signer contracts, which the Safe
  accepts.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5b92e431f93024ea3ec20b311d83ac6035bd50e1'
  name: GnosisSafe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
value:
  usd: 2634591
  basis: held
activity:
  txs_90d: 24
impact: funds-loss
action: Replace EOA owners with post-quantum signer contracts via swapOwner, approved by the current owner threshold.
evidence_level: source
checks:
- id: c1
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 295
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: eth_sign path recovers the signer with ecrecover.
  for:
  - evidence-1
  - what
- id: c2
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Default path recovers the signer with ecrecover over dataHash.
  for:
  - evidence-1
  - justification
  - what
- id: c-owner
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0)
  line: 301
  says: Recovered signer must be an owner, ascending.
  for:
  - evidence-2
  - what
- id: c-1271
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature)
  line: 285
  says: Contract owners are validated via ERC-1271 with the full signature.
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

This Safe runs any transaction once threshold-many owners approve, and an EOA owner approves with an ECDSA signature checked by ecrecover. A quantum attacker who recovers threshold-many owner keys can sign as those owners and move the Safe's funds.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) recovers the signer with ecrecover(dataHash, v, r, s) and the eth_sign variant.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) requires the recovered address to be an owner, in ascending order.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) also accepts contract owners through isValidSignature on the full signature.

## Reviewer notes

### Mechanism

The proxy delegates to the GnosisSafe 1.3.0 singleton. checkNSignatures splits each 65-byte slot: v==0 calls ISignatureValidator(owner).isValidSignature(data, contractSignature) (line 285); v==1 needs msg.sender or approvedHashes (line 291); v>30 ecrecovers the eth_sign-prefixed hash (line 295); otherwise ecrecover(dataHash, v, r, s) (line 299). Line 301 requires each recovered address to be an owner, strictly ascending. An EOA owner is satisfied by ecrecover, so recovering threshold-many owner private keys from public keys exposed in prior signatures lets an attacker pass execTransaction and transfer assets or change owners. Contract owners are checked through ERC-1271 with the full signature, so swapping EOAs for post-quantum signer contracts removes the ECDSA path.

### Checks

- Header facts: this address alone, at block 26,438,999.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
