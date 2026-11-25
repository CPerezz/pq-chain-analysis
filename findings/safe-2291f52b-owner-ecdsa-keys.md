---
id: safe-2291f52b-owner-ecdsa-keys
format: 2
title: One-owner Safe's ECDSA key lets a quantum attacker move all its funds
status: confirmed
severity: MEDIUM
justification: Owner ECDSA keys guard all funds; MEDIUM since owners can swap EOAs for post-quantum signer contracts
  via ERC-1271.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2291f52bddc937b5b840d15e551e1da8c80c2b3c'
  name: Safe
  project: safe
  code: verified
  code_url: https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code
  proxy_of: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  copies: 1
value:
  usd: 20105977
  basis: held
activity:
  txs_90d: 7
impact: funds-loss
action: Replace the EOA owner with a post-quantum signer contract via swapOwner, validated through isValidSignature.
evidence_level: source
checks:
- id: c1
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 325
  has: currentOwner = ecrecover(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", dataHash)), v - 4,
    r, s);
  says: eth_sign-style signatures are recovered with ecrecover.
  for:
  - evidence-2
- id: c2
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  line: 329
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: Standard owner signatures are recovered with ecrecover.
  for:
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: require(ISignatureValidator(currentOwner).isValidSignature(data, contractSignature) == EIP1271_MAGIC_VALUE,
    "GS024");
  line: 315
  says: Contract owners are checked through their own isValidSignature on the full signature.
  for:
  - action
  - evidence-3
  - justification
- id: c4
  source: '0x41675c099f32341bf84bfc5382af534df5c7461a'
  file: contracts/Safe.sol
  has: require(currentOwner > lastOwner && owners[currentOwner] != address(0) && currentOwner != SENTINEL_OWNERS,
    "GS026");
  line: 331
  says: The recovered address must be a registered owner.
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

This Safe runs a transaction once checkNSignatures accepts enough owner approvals, and an EOA owner approves with an ECDSA signature checked by ecrecover. A quantum attacker who recovers the owner key can sign transfers, owner changes or singleton swaps.

## Evidence

- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) takes the owner from ecrecover(dataHash, v, r, s) for standard signatures.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) also recovers eth_sign signatures with ecrecover when v > 30.
- [checkNSignatures](https://etherscan.io/address/0x41675c099f32341bf84bfc5382af534df5c7461a#code) accepts contract owners through isValidSignature, so a post-quantum signer contract can be an owner.

## Reviewer notes

### Mechanism

Proxy 0x2291f52b… delegates to Safe 1.4.1 singleton 0x41675c09…. execTransaction calls checkNSignatures, which loops over threshold-many 65-byte slots. v == 0 (line 286) reads the owner from r and calls ISignatureValidator(owner).isValidSignature on the full contract signature (line 315). v == 1 (line 316) requires msg.sender == owner or a prior approveHash (line 321). v > 30 recovers via ecrecover over the eth_sign prefixed hash (line 325). Otherwise it uses ecrecover(dataHash, v, r, s) (line 329). Line 331 requires the recovered address to be an owner in ascending order. Per kev's census this Safe is 1 of 1 with an EOA owner. One recovered key (its public key follows from any posted signature) therefore satisfies the check and authorizes any call, including swapOwner and changeMasterCopy on itself.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No guard is set on this Safe (kev's census).
- Ruled out: No modules are enabled on this Safe (kev's census).

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
