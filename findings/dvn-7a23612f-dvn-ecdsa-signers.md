---
id: dvn-7a23612f-dvn-ecdsa-signers
format: 2
title: BWare LayerZero DVN accepts ECDSA signer quorums a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorums verify fake messages for OApps requiring this DVN; operators fix by moving
  to a post-quantum DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7a23612f07d81f16b26cf0b5a4c3eca0e8668df2'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x7a23612f07d81f16b26cf0b5a4c3eca0e8668df2#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0x7a23612f07d81f16b26cf0b5a4c3eca0e8668df2'
  file: contracts/uln/dvn/MultiSig.sol
  line: 91
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: verifySignatures recovers each signature with ECDSA.tryRecover.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x7a23612f07d81f16b26cf0b5a4c3eca0e8668df2'
  file: contracts/uln/dvn/MultiSig.sol
  line: 93
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: A failed recovery rejects the signature batch.
  for:
  - evidence-1
  - what
- id: c3
  source: '0x7a23612f07d81f16b26cf0b5a4c3eca0e8668df2'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile (secp256k1).
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x7a23612f07d81f16b26cf0b5a4c3eca0e8668df2'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is callable only by the DVN itself.
  for:
  - action
  - evidence-3
- id: len
  source: '0x7a23612f07d81f16b26cf0b5a4c3eca0e8668df2'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 82
  says: Exactly quorum signatures of 65 bytes are required.
  for:
  - what
- id: committee
  source: '0x7a23612f07d81f16b26cf0b5a4c3eca0e8668df2'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!signers[currentSigner]) return (false, Errors.SignerNotInCommittee);
  line: 95
  says: Each recovered signer must be in the signer set.
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

This DVN verifies LayerZero messages on Ethereum and accepts a call only with a quorum of ECDSA signatures from its signer set. A quantum attacker who recovers the signer keys can sign fabricated packets for any OApp that requires this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x7a23612f07d81f16b26cf0b5a4c3eca0e8668df2#code) recovers each 65-byte signature with ECDSA.tryRecover and rejects failures.
- [tryRecover](https://etherscan.io/address/0x7a23612f07d81f16b26cf0b5a4c3eca0e8668df2#code) gets the signer from the ecrecover precompile.
- [setSigner](https://etherscan.io/address/0x7a23612f07d81f16b26cf0b5a4c3eca0e8668df2#code) is onlySelf, so signers rotate only to other ECDSA keys.

## Reviewer notes

### Mechanism

DVN.execute (ADMIN_ROLE) hashes each target call and checks MultiSig.verifySignatures(hash, signatures): signatures.length must equal quorum*65 (line 82), the hash is EIP-191 prefixed (line 86), then each 65-byte slice goes through ECDSA.tryRecover (line 91), which calls ecrecover (ECDSA.sol line 139); recovered signers must be ascending (line 94) and in the signers mapping (line 95). The call made is in practice ReceiveUln302.verify; once all required DVNs of an OApp have verified, the payload hash can be committed to EndpointV2 and lzReceive executes it. quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner/setQuorum are onlySelf (DVN.sol line 99), so rotation stays within ECDSA keys.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN itself holds no funds; value sits in the OApps that require it.
- Ruled out: Not upgradeable; fix requires a new deployment.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
