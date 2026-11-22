---
id: dvn-6c70db9c-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: DVN signers are ECDSA keys; forged quorums verify fake messages. The operator must deploy a post-quantum
  DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6c70db9ce65fa37499c1f1a150a6440fc9c7273a'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x6c70db9ce65fa37499c1f1a150a6440fc9c7273a#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs, and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0x6c70db9ce65fa37499c1f1a150a6440fc9c7273a'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature is recovered with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x6c70db9ce65fa37499c1f1a150a6440fc9c7273a'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the secp256k1 ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x6c70db9ce65fa37499c1f1a150a6440fc9c7273a'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: Signer changes are onlySelf, gated by the multisig.
  for:
  - action
  - evidence-3
  - justification
- id: v-len
  source: '0x6c70db9ce65fa37499c1f1a150a6440fc9c7273a'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Exactly quorum 65-byte signatures are required.
  for:
  - what
- id: v-member
  source: '0x6c70db9ce65fa37499c1f1a150a6440fc9c7273a'
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

This DVN accepts a call only with a quorum of ECDSA signatures from its signer set. A quantum attacker who recovers enough signer keys can forge that quorum and have the DVN verify fabricated cross-chain messages for OApps that require it.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x6c70db9ce65fa37499c1f1a150a6440fc9c7273a#code) recovers each 65-byte signature with ECDSA and requires the signer to be in the committee.
- [tryRecover](https://etherscan.io/address/0x6c70db9ce65fa37499c1f1a150a6440fc9c7273a#code) relies on the ecrecover precompile (secp256k1).
- [setSigner](https://etherscan.io/address/0x6c70db9ce65fa37499c1f1a150a6440fc9c7273a#code) rotates signers through the same multisig, so replacements are again ECDSA addresses.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 93-112) requires _signatures.length == quorum*65 (line 94). It takes the EIP-191 digest (line 98) and, for each slice, calls ECDSA.tryRecover (line 104), which uses ecrecover (ECDSA.sol line 139). It requires ascending signer order (line 107) and committee membership (line 108). Per kev's finding, DVN.execute checks this before calling ReceiveUln302.verify. Once all required DVNs have verified, the payload commits to EndpointV2 and the OApp's lzReceive releases funds. setSigner is onlySelf (DVN.sol line 104), so signer rotation goes through the same ECDSA quorum.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable per registry record
- Ruled out: DVN itself holds about $0; funds sit in OApps

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
