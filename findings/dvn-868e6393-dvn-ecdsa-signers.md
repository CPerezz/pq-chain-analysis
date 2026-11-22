---
id: dvn-868e6393-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum lets fake messages verify; the DVN operator fixes it by deploying a post-quantum
  DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x868e6393aea25e8c7e58bc5d4c90a5237c573ff6'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x868e6393aea25e8c7e58bc5d4c90a5237c573ff6#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0x868e6393aea25e8c7e58bc5d4c90a5237c573ff6'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature slice is recovered with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x868e6393aea25e8c7e58bc5d4c90a5237c573ff6'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the secp256k1 ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x868e6393aea25e8c7e58bc5d4c90a5237c573ff6'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: Signer changes are onlySelf and set addresses.
  for:
  - action
  - evidence-3
  - justification
- id: vs-len
  source: '0x868e6393aea25e8c7e58bc5d4c90a5237c573ff6'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Exactly quorum 65-byte signatures are required.
  for:
  - what
- id: sig-member
  source: '0x868e6393aea25e8c7e58bc5d4c90a5237c573ff6'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: Each recovered signer must be in the committee.
  for:
  - evidence-1
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

This DVN accepts a call only with a quorum of ECDSA signatures from its signer set. A quantum attacker who recovers a quorum of signer keys can sign fabricated packet verifications that OApps relying on this DVN would accept.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x868e6393aea25e8c7e58bc5d4c90a5237c573ff6#code) recovers each 65-byte signature with ECDSA and requires the signer to be in the committee.
- [tryRecover](https://etherscan.io/address/0x868e6393aea25e8c7e58bc5d4c90a5237c573ff6#code) relies on the ecrecover precompile (secp256k1).
- [setSigner](https://etherscan.io/address/0x868e6393aea25e8c7e58bc5d4c90a5237c573ff6#code) is onlySelf and adds signer addresses, so rotation stays within ECDSA keys.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 93-112) requires _signatures.length == quorum*65 (line 94), applies the EIP-191 prefix (line 98), then for each 65-byte slice calls ECDSA.tryRecover (line 104), which uses ecrecover (ECDSA.sol line 139). Signers must be ascending (line 107) and in signerSet (line 108). Per kev's finding, DVN.execute checks these signatures before calling targets such as ReceiveUln302.verify; once all of an OApp's required DVNs verify, the payload can be committed to EndpointV2 and executed by lzReceive. setSigner (DVN.sol line 104) is onlySelf and only rotates to other address (ECDSA) signers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable.
- Ruled out: DVN itself holds about $0; funds at risk sit in the OApps that use it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
