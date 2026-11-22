---
id: dvn-241c66a9-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum verifies fake messages for OApps requiring this DVN; operator must deploy a
  post-quantum DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x241c66a979125f230c239e79d103e0c2128c6618'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x241c66a979125f230c239e79d103e0c2128c6618#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1180
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0x241c66a979125f230c239e79d103e0c2128c6618'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: each signature slice is checked with ECDSA.tryRecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x241c66a979125f230c239e79d103e0c2128c6618'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: recovery uses the ecrecover precompile
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x241c66a979125f230c239e79d103e0c2128c6618'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: signer changes go through the contract's own signature-checked path
  for:
  - evidence-3
- id: vs-len
  source: '0x241c66a979125f230c239e79d103e0c2128c6618'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: quorum of 65-byte signatures required
  for:
  - evidence-1
  - what
- id: c-member
  source: '0x241c66a979125f230c239e79d103e0c2128c6618'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: recovered signer must be a committee member
  for:
  - evidence-2
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

This DVN accepts a call only when a quorum of ECDSA signatures recovers to addresses in its signer set. A quantum attacker who recovers a quorum of signer keys can make the DVN verify a fabricated cross-chain message for OApps that require it.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x241c66a979125f230c239e79d103e0c2128c6618#code) requires exactly quorum × 65 bytes and runs ECDSA.tryRecover on each slice.
- [tryRecover](https://etherscan.io/address/0x241c66a979125f230c239e79d103e0c2128c6618#code) recovers the signer with ecrecover, and the result must be a committee member.
- [setSigner](https://etherscan.io/address/0x241c66a979125f230c239e79d103e0c2128c6618#code) is onlySelf: signers rotate through the same signature check, to other address keys.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 93-112) checks _signatures.length == quorum*65 (line 94), prefixes the hash with the EIP-191 message header (line 98), then for each 65-byte slice calls ECDSA.tryRecover (line 104), which calls ecrecover (ECDSA.sol line 139). Signers must be in ascending order (line 107) and in signerSet (line 108). DVN.execute uses this check before making the target call, typically ReceiveUln302.verify; once all required DVNs verify, the payload is committed to EndpointV2 and the OApp's lzReceive executes it. setSigner (DVN.sol line 104) is onlySelf, so rotation only swaps in other ECDSA keys. Signer public keys are exposed by any signature they posted.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN itself holds no funds; the funds at stake sit in the OApps that require it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
