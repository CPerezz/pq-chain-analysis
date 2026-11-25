---
id: offramp-408428bc-ocr-don-ecdsa-signers
format: 2
title: Chainlink CCIP OffRamp executes messages approved by forgeable ECDSA committees
status: confirmed
severity: MEDIUM
justification: Committee ECDSA keys are forgeable; MEDIUM because the owner can deploy post-quantum verification
  and repoint.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x408428bca0e24a25ac8baac1b70f64af257717c3'
  name: OffRamp
  project: chainlink
  code: verified
  code_url: https://etherscan.io/address/0x408428bca0e24a25ac8baac1b70f64af257717c3#code
  copies: 1
  upgradeable: 'no'
  admin: '0x44835bbba9d40deda9b64858095ecfb2693c9449'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 18105
impact: funds-loss
action: Deploy post-quantum committee verification and register it in the resolver for every lane.
evidence_level: source
checks:
- id: c1
  source: '0x408428bca0e24a25ac8baac1b70f64af257717c3'
  file: node_modules/@chainlink/contracts/src/v0.8/shared/access/Ownable2Step.sol
  line: 43
  has: function transferOwnership(
  says: the contract has an owner-gated transferOwnership
  for:
  - action
  - evidence-1
  - justification
  - what
- id: code
  code: '0x408428bca0e24a25ac8baac1b70f64af257717c3'
  is: contract
  bytes: 24253
  says: the address holds deployed contract code
  for:
  - what
- id: mod-check
  source: '0x408428bca0e24a25ac8baac1b70f64af257717c3'
  file: node_modules/@chainlink/contracts/src/v0.8/shared/access/Ownable2Step.sol
  has: public override onlyOwner
  line: 45
  says: transferOwnership uses the onlyOwner modifier
  for:
  - evidence-1
- id: accept-check
  source: '0x408428bca0e24a25ac8baac1b70f64af257717c3'
  file: node_modules/@chainlink/contracts/src/v0.8/shared/access/Ownable2Step.sol
  has: if (msg.sender != s_pendingOwner) {
  line: 65
  says: acceptOwnership requires the pending owner
  for:
  - evidence-2
  - what
- id: own-check
  source: '0x408428bca0e24a25ac8baac1b70f64af257717c3'
  file: node_modules/@chainlink/contracts/src/v0.8/shared/access/Ownable2Step.sol
  has: if (msg.sender != s_owner) {
  line: 78
  says: _validateOwnership reverts for callers other than the owner
  for:
  - evidence-3
  - justification
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review11 (Claude), finding review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract is a Chainlink CCIP OffRamp whose administration is held by a single owner through two-step ownership transfer. Owner-only functions revert for any other caller, so the owner is the party that can replace or reconfigure it.

## Evidence

- [transferOwnership](https://etherscan.io/address/0x408428bca0e24a25ac8baac1b70f64af257717c3#code) is gated by onlyOwner.
- [acceptOwnership](https://etherscan.io/address/0x408428bca0e24a25ac8baac1b70f64af257717c3#code) completes a transfer only when the pending owner calls it.
- [_validateOwnership](https://etherscan.io/address/0x408428bca0e24a25ac8baac1b70f64af257717c3#code) reverts unless the caller is the stored owner.

## Reviewer notes

### Mechanism

Per kev's finding: execute (OffRamp.sol line 188) is permissionless and checks only the RMN curse, the lane and the onRamp. executeSingleMessage (line 308) asks each required CCV to verifyMessage (lines 342-352) and then releases or mints through the token pool. All 69 lanes use the VersionedVerifierResolver, whose inbound implementation is CommitteeVerifier 2.0.0. Its SignatureQuorumValidator._validateSignatures ecrecovers each signature and needs 9 distinct configured signers. Signer public keys are exposed by their signatures, so a quantum attacker who recovers 9 keys can attest invented messages and release pool tokens. Rotating signers keeps ECDSA. The OffRamp.sol lines are not among the source files shown here. Only Ownable2Step admin control (lines 43-87) is checked.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract itself holds about $0; the funds at risk sit in CCIP token pools.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
