---
id: contract-fe5fc40c-tokentable-distributor-signer
format: 2
title: TokenTable YALA distributor accepts claims a quantum attacker could forge
status: confirmed
severity: LOW
justification: Claims rest on one EOA signer key; LOW because the owner can switch to a post-quantum ERC-1271 signer
  by config.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xfe5fc40c15c67983694642f9a8711241157fdb0a'
  project: sign-protocol
  code: bytecode
  code_url: https://etherscan.io/address/0xfe5fc40c15c67983694642f9a8711241157fdb0a#code
  copies: 1
  admin: '0xfc9c1ec0a4fc4ae45d581c5dd636386ef6b13680'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Set authorizedSigner to a contract that verifies a post-quantum signature via ERC-1271, or withdraw remaining
  tokens.
evidence_level: source
checks:
- id: c1
  source: '0x85a530f3c0be16e895cfc935350480afb7215b4b'
  file: dependencies/solady-0.1.19/src/utils/SignatureCheckerLib.sol
  line: 32
  has: function isValidSignatureNow(address signer, bytes32 hash, bytes memory signature)
  says: isValidSignatureNow uses ecrecover for code-less signers, ERC-1271 otherwise.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c5
  source: '0x85a530f3c0be16e895cfc935350480afb7215b4b'
  file: src/ecdsa/core/BaseECDSADistributor.sol
  line: 183
  has: SignatureCheckerLib.isValidSignatureNow(signer, SignatureCheckerLib.toEthSignedMessageHash(hash), signature),
  says: verify checks the signature against the signer via SignatureCheckerLib.
  for:
  - evidence-1
  - justification
  - what
- id: ecr
  source: '0x85a530f3c0be16e895cfc935350480afb7215b4b'
  file: dependencies/solady-0.1.19/src/utils/SignatureCheckerLib.sol
  has: let recovered := mload(staticcall(gas(), 1, 0x00, 0x80, 0x01, 0x20))
  line: 56
  says: Code-less signers are checked with the ecrecover precompile.
  for:
  - evidence-2
  - what
- id: sbp
  source: '0x85a530f3c0be16e895cfc935350480afb7215b4b'
  file: src/ecdsa/core/BaseECDSADistributor.sol
  has: _getBaseECDSADistributorStorage().authorizedSigner = authorizedSigner;
  line: 87
  says: setBaseParams (onlyOwner) replaces the authorized signer.
  for:
  - action
  - evidence-3
  - justification
- id: act
  source: '0x85a530f3c0be16e895cfc935350480afb7215b4b'
  file: src/ecdsa/core/BaseECDSADistributor.sol
  has: onlyActive
  line: 104
  says: claim only runs inside the claim window.
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
  who: Review03 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
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

This distributor pays out tokens to recipients whose claim is signed by the authorizedSigner, checked with ecrecover when the signer has no code. A quantum attacker who recovers that signer key could sign claims and drain tokens the contract holds while the claim window is open.

## Evidence

- [verify](https://etherscan.io/address/0x85a530f3c0be16e895cfc935350480afb7215b4b#code) checks claims through SignatureCheckerLib.isValidSignatureNow against the signer.
- [isValidSignatureNow](https://etherscan.io/address/0x85a530f3c0be16e895cfc935350480afb7215b4b#code) uses ecrecover when the signer has no code, else ERC-1271.
- [setBaseParams](https://etherscan.io/address/0x85a530f3c0be16e895cfc935350480afb7215b4b#code) lets the owner replace authorizedSigner.

## Reviewer notes

### Mechanism

claim() (onlyActive, whenNotPaused) calls _verifyAndClaim per recipient, which hashes encodeHashToBeSigned(chainid, this, recipient, userClaimId, data) and calls verify($.authorizedSigner, hash, signature) (line 183). verify uses Solady SignatureCheckerLib.isValidSignatureNow (line 32): if extcodesize(signer)==0 it calls ecrecover (precompile 1, line 56) and compares to the signer; otherwise it calls isValidSignature(bytes32,bytes) on the signer with the full signature. The signer here is an EOA, so a recovered key forges claims. onlyActive (line 51-55) reverts outside [startTime,endTime]; the owner can change window and signer via setBaseParams (line 73-88) or withdraw.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Claim window is closed, so claims revert until the owner reopens it.
- Ruled out: Contract holds about $0 now.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
