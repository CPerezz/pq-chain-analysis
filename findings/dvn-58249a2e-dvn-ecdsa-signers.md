---
id: dvn-58249a2e-dvn-ecdsa-signers
format: 2
title: Luganodes DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged quorum verifies fake messages for OApps requiring this DVN; operator fixes by deploying a
  post-quantum DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x58249a2ec05c1978bf21df1f5ec1847e42455cf4'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x58249a2ec05c1978bf21df1f5ec1847e42455cf4#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 8582
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0x58249a2ec05c1978bf21df1f5ec1847e42455cf4'
  file: contracts/uln/dvn/MultiSig.sol
  line: 91
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature slice is recovered with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x58249a2ec05c1978bf21df1f5ec1847e42455cf4'
  file: contracts/uln/dvn/MultiSig.sol
  line: 93
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: Recovery errors reject the quorum.
  for:
  - what
- id: c3
  source: '0x58249a2ec05c1978bf21df1f5ec1847e42455cf4'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x58249a2ec05c1978bf21df1f5ec1847e42455cf4'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is onlySelf and sets an address signer.
  for:
  - action
  - evidence-3
  - justification
- id: q1
  source: '0x58249a2ec05c1978bf21df1f5ec1847e42455cf4'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 82
  says: Exactly quorum 65-byte signatures are required.
  for:
  - what
- id: q2
  source: '0x58249a2ec05c1978bf21df1f5ec1847e42455cf4'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!signers[currentSigner]) return (false, Errors.SignerNotInCommittee);
  line: 95
  says: Recovered address must be a registered signer.
  for:
  - evidence-1
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
reviews: []
related: []
---

## What happens

This DVN verifies LayerZero messages and accepts a call when a quorum of 65-byte ECDSA signatures recovers to its registered signers. A quantum attacker who derives the signer keys can sign a fabricated packet that this DVN then verifies.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x58249a2ec05c1978bf21df1f5ec1847e42455cf4#code) recovers each signature with ECDSA.tryRecover and checks it against the signer set.
- [tryRecover](https://etherscan.io/address/0x58249a2ec05c1978bf21df1f5ec1847e42455cf4#code) calls ecrecover on secp256k1 signatures.
- [setSigner](https://etherscan.io/address/0x58249a2ec05c1978bf21df1f5ec1847e42455cf4#code) sets signer addresses, which stay ECDSA keys.

## Reviewer notes

### Mechanism

DVN.execute (ADMIN_ROLE) hashes each target call and checks MultiSig.verifySignatures(hash, signatures): signatures.length must equal quorum*65 (line 82), the hash is wrapped as an Ethereum signed message (line 86), then each 65-byte slice goes through ECDSA.tryRecover (line 91), which calls ecrecover (ECDSA.sol line 139); errors fail (line 93), signers must be ascending (line 94) and in the signers mapping (line 95). The verified call is in practice ReceiveUln302.verify; once all required DVNs of an OApp verify, the payload can be committed to EndpointV2 and executed by lzReceive. quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner/setQuorum are onlySelf and keep ECDSA keys.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN itself holds no funds; the exposed funds sit in OApps that require it.
- Ruled out: Not upgradeable; no proxy.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
