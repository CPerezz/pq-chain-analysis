---
id: dvn-38179d3b-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum verifies fake messages for OApps using this DVN; operator fixes by deploying
  a post-quantum DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x38179d3bfa6ef1d69a8a7b0b671ba3d8836b2ae8'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x38179d3bfa6ef1d69a8a7b0b671ba3d8836b2ae8#code
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
  source: '0x38179d3bfa6ef1d69a8a7b0b671ba3d8836b2ae8'
  file: contracts/uln/dvn/MultiSig.sol
  line: 91
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: verifySignatures recovers each signer with ECDSA.tryRecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x38179d3bfa6ef1d69a8a7b0b671ba3d8836b2ae8'
  file: contracts/uln/dvn/MultiSig.sol
  line: 93
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: a signature that fails recovery is rejected
  for:
  - what
- id: c3
  source: '0x38179d3bfa6ef1d69a8a7b0b671ba3d8836b2ae8'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x38179d3bfa6ef1d69a8a7b0b671ba3d8836b2ae8'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: signer rotation is onlySelf and sets addresses
  for:
  - evidence-3
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

This DVN verifies LayerZero messages on Ethereum and accepts a call only with a quorum of secp256k1 signatures from its signer set. A quantum attacker who recovers a quorum of signer keys can sign fabricated packets this DVN treats as verified.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x38179d3bfa6ef1d69a8a7b0b671ba3d8836b2ae8#code) recovers each 65-byte signature with ECDSA.tryRecover.
- [tryRecover](https://etherscan.io/address/0x38179d3bfa6ef1d69a8a7b0b671ba3d8836b2ae8#code) calls the ecrecover precompile to get the signer.
- [setSigner](https://etherscan.io/address/0x38179d3bfa6ef1d69a8a7b0b671ba3d8836b2ae8#code) rotates signers by address, so replacements are again ECDSA keys.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 81-99) requires _signatures.length == quorum*65, builds the EIP-191 digest, and for each 65-byte slice calls ECDSA.tryRecover (line 91), which uses ecrecover (ECDSA.sol line 139). Recovered signers must be ascending and in the signers mapping (lines 94-95). Per kev's finding, DVN.execute uses this check before calling ReceiveUln302.verify, and quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. Once all required DVNs of an OApp verify, the payload commits to EndpointV2 and lzReceive releases funds. setSigner (DVN.sol line 99) is onlySelf and only swaps ECDSA addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN itself holds no funds; exposure sits in the OApps that require it.
- Ruled out: Not upgradeable; fix is a new deployment.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
