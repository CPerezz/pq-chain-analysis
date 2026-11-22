---
id: dvn-2f0ba3db-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Signer quorum is ECDSA only; the DVN operator fixes it by deploying a post-quantum DVN that OApps
  then point at.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2f0ba3dbb93cf087e32c15aab46726fdb4fb24cf'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x2f0ba3dbb93cf087e32c15aab46726fdb4fb24cf#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs, and have OApps and LayerZero defaults point
  at it.
evidence_level: source
checks:
- id: c1
  source: '0x2f0ba3dbb93cf087e32c15aab46726fdb4fb24cf'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: each signature is recovered with ECDSA.tryRecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x2f0ba3dbb93cf087e32c15aab46726fdb4fb24cf'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: recovery uses the ecrecover precompile
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x2f0ba3dbb93cf087e32c15aab46726fdb4fb24cf'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is callable only by the contract itself
  for:
  - evidence-3
  - justification
- id: n1
  source: '0x2f0ba3dbb93cf087e32c15aab46726fdb4fb24cf'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: exactly quorum 65-byte signatures are required
  for:
  - what
- id: n2
  source: '0x2f0ba3dbb93cf087e32c15aab46726fdb4fb24cf'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: each recovered signer must be in the committee
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

This DVN accepts a call only with a quorum of ECDSA signatures from its signer set, recovered with ecrecover. A quantum attacker who recovers enough signer keys can forge that quorum and have the DVN verify fabricated cross-chain messages.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x2f0ba3dbb93cf087e32c15aab46726fdb4fb24cf#code) recovers each 65-byte signature with ECDSA and requires the signer to be in the committee.
- [tryRecover](https://etherscan.io/address/0x2f0ba3dbb93cf087e32c15aab46726fdb4fb24cf#code) relies on the ecrecover precompile (secp256k1).
- [setSigner](https://etherscan.io/address/0x2f0ba3dbb93cf087e32c15aab46726fdb4fb24cf#code) is onlySelf, so it changes members of the ECDSA signer set.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 93-112) requires _signatures.length == quorum*65 (line 94), hashes with the EIP-191 prefix (line 98), and for each slice calls ECDSA.tryRecover (line 104), which uses ecrecover (ECDSA.sol line 139). Recovered signers must be ascending (line 107) and in signerSet (line 108). The DVN's execute path relies on this check before forwarding calls such as ReceiveUln302.verify; once all required DVNs of an OApp verify a packet, it can be committed to EndpointV2 and executed via lzReceive. setSigner (DVN.sol line 104) is onlySelf and changes membership of the ECDSA signer set.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN itself holds about $0; funds sit in the OApps that require it.
- Ruled out: Not upgradeable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
