---
id: gnosissafe-7ce3ec68-owner-ecdsa-keys
format: 2
title: Safe multisig 0x7ce3 lets a quantum attacker with two owner keys move all funds
status: confirmed
severity: MEDIUM
justification: Owner ECDSA keys authorize everything; MEDIUM since owners can swap EOAs for post-quantum ERC-1271
  signer contracts.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7ce3ec6845780e8f69b1a19edf8148d7cbb77a7d'
  name: GnosisSafe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code
  proxy_of: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  copies: 1
value:
  usd: 24721066
  basis: held
activity:
  txs_90d: 16
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
  says: eth_sign signatures are verified with ecrecover.
  for:
  - evidence-2
  - what
- id: c2
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Default signatures are verified with ecrecover over the Safe tx hash.
  for:
  - evidence-1
  - justification
  - what
- id: own
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  line: 301
  says: Recovered signer must be a registered owner.
  for:
  - evidence-1
  - what
- id: v0
  source: '0xd9db270c1b5e3bd161e8c8503c55ceabee709552'
  file: contracts/GnosisSafe.sol
  has: ISignatureValidator(currentOwner).isValidSignature(data, contractSignature)
  line: 285
  says: Contract owners are verified via ERC-1271 isValidSignature.
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
  pattern: PQ-12
reviews: []
related: []
---

## What happens

This Safe executes a transaction once enough owner signatures pass checkNSignatures, and an EOA owner signs with ECDSA. A quantum attacker who recovers threshold-many owner keys from posted signatures can approve any transaction and drain or take over the Safe.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) recovers the signer with ecrecover and accepts it if it is an owner.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) also accepts eth_sign signatures through ecrecover.
- [checkNSignatures](https://etherscan.io/address/0xd9db270c1b5e3bd161e8c8503c55ceabee709552#code) validates contract owners through isValidSignature.

## Reviewer notes

### Mechanism

Proxy runs GnosisSafe 1.3.0 singleton 0xd9db270c. execTransaction calls checkNSignatures, which loops over threshold-many 65-byte slots (line 256). v==0: contract owner checked via ISignatureValidator.isValidSignature (line 285); v==1: approveHash or msg.sender (line 291); v>30: ecrecover of eth_sign hash (line 295); else ecrecover(dataHash,v,r,s) (line 299). Line 301 requires the recovered address to be an owner, ascending. Kev's census reads this Safe as 2 of 4. Recovering two owner keys therefore authorizes any call, including swapOwner or changeMasterCopy.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No guard set on this Safe
- Ruled out: No modules enabled on this Safe

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
