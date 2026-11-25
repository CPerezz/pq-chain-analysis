---
id: contract-ccbd0874-tokentable-distributor-signer
format: 2
title: TokenTable BOS distributor accepts ECDSA claims a quantum attacker could forge
status: confirmed
severity: LOW
justification: Claims rest on one ECDSA signer key; the owner can switch the signer to an ERC-1271 contract with
  one call, so LOW.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xccbd08746816de921ca91611d277a90ab083bc7a'
  project: sign-protocol
  code: bytecode
  code_url: https://etherscan.io/address/0xccbd08746816de921ca91611d277a90ab083bc7a#code
  copies: 1
  admin: '0xeab88fa6a3723749035b2579f8dcb924c9948b75'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Set authorizedSigner to a contract that verifies a post-quantum signature via ERC-1271, or withdraw the
  remaining tokens.
evidence_level: source
checks:
- id: c5
  source: '0x85a530f3c0be16e895cfc935350480afb7215b4b'
  file: src/ecdsa/core/BaseECDSADistributor.sol
  line: 183
  has: SignatureCheckerLib.isValidSignatureNow(signer, SignatureCheckerLib.toEthSignedMessageHash(hash), signature),
  says: verify checks the signature against the signer via SignatureCheckerLib
  for:
  - evidence-1
  - justification
  - what
- id: claim-verify
  source: '0x85a530f3c0be16e895cfc935350480afb7215b4b'
  file: src/ecdsa/core/BaseECDSADistributor.sol
  has: uint256 claimedAmount = _verifyAndClaim(recipients[i], userClaimIds[i], datas[i], signatures[i]);
  line: 112
  says: claim verifies and pays each recipient
  for:
  - what
- id: c1-code
  source: '0x85a530f3c0be16e895cfc935350480afb7215b4b'
  file: dependencies/solady-0.1.19/src/utils/SignatureCheckerLib.sol
  has: if iszero(extcodesize(signer)) {
  line: 42
  says: the library takes the ecrecover path only when the signer has no code
  for:
  - evidence-2
  - justification
  - what
- id: ecrecover
  source: '0x85a530f3c0be16e895cfc935350480afb7215b4b'
  file: dependencies/solady-0.1.19/src/utils/SignatureCheckerLib.sol
  has: let recovered := mload(staticcall(gas(), 1, 0x00, 0x80, 0x01, 0x20))
  line: 56
  says: calls the ecrecover precompile
  for:
  - what
- id: erc1271
  source: '0x85a530f3c0be16e895cfc935350480afb7215b4b'
  file: dependencies/solady-0.1.19/src/utils/SignatureCheckerLib.sol
  has: isValid := staticcall(gas(), signer, m, add(returndatasize(), 0x44), d, 0x20)
  line: 70
  says: a contract signer is asked through ERC-1271
  for:
  - action
  - evidence-2
- id: only-active
  source: '0x85a530f3c0be16e895cfc935350480afb7215b4b'
  file: src/ecdsa/core/BaseECDSADistributor.sol
  has: ) revert TimeInactive();
  line: 55
  says: claims revert outside the claim window
  for:
  - what
- id: set-params
  source: '0x85a530f3c0be16e895cfc935350480afb7215b4b'
  file: src/ecdsa/core/BaseECDSADistributor.sol
  has: _getBaseECDSADistributorStorage().authorizedSigner = authorizedSigner;
  line: 87
  says: the owner's setBaseParams replaces the signer
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
  who: Review03 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This TokenTable airdrop distributor pays tokens to any claim signed by its authorizedSigner. When the signer has no code the signature is checked with ecrecover, so a quantum attacker who recovers that key could sign claims for the remaining tokens while a claim window is open.

## Evidence

- [verify](https://etherscan.io/address/0x85a530f3c0be16e895cfc935350480afb7215b4b#code) checks each claim signature against the authorizedSigner through SignatureCheckerLib.
- [SignatureCheckerLib](https://etherscan.io/address/0x85a530f3c0be16e895cfc935350480afb7215b4b#code) uses ecrecover when the signer has no code and calls ERC-1271 isValidSignature otherwise.
- [setBaseParams](https://etherscan.io/address/0x85a530f3c0be16e895cfc935350480afb7215b4b#code) lets the owner replace the authorizedSigner.

## Reviewer notes

### Mechanism

BaseECDSADistributor.claim (line 94, modifiers onlyActive and whenNotPaused) calls _verifyAndClaim for each recipient (line 112). The implementation builds encodeHashToBeSigned (line 178: chain id, contract, recipient, claim id, data) and calls verify (line 181). verify calls SignatureCheckerLib.isValidSignatureNow(signer, toEthSignedMessageHash(hash), signature) at line 183. In the library, if extcodesize(signer) is zero (line 42) it runs ecrecover via precompile 1 (line 56). Otherwise it calls isValidSignature(bytes32,bytes) on the signer (lines 62-70). The signer here is an EOA, so the exposure is that key. onlyActive (lines 51-55) reverts outside [startTime, endTime]. setBaseParams (lines 73-88, onlyOwner) changes the window and the signer.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Claim windows are closed, so claims revert until the owner reopens the window.
- Ruled out: Hash binds chain id and contract address, so signatures do not replay across chains or clones.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
