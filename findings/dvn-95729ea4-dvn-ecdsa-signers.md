---
id: dvn-95729ea4-dvn-ecdsa-signers
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
  address: '0x95729ea44326f8add8a9b1d987279dbdc1dd3dff'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x95729ea44326f8add8a9b1d987279dbdc1dd3dff#code
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
  source: '0x95729ea44326f8add8a9b1d987279dbdc1dd3dff'
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
  source: '0x95729ea44326f8add8a9b1d987279dbdc1dd3dff'
  file: contracts/uln/dvn/MultiSig.sol
  line: 93
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: a failed recovery rejects the signature set
  for:
  - what
- id: c3
  source: '0x95729ea44326f8add8a9b1d987279dbdc1dd3dff'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x95729ea44326f8add8a9b1d987279dbdc1dd3dff'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: signers are changed only by the contract itself via setSigner
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

This DVN contract accepts a call only when a quorum of signatures recovers, via ECDSA, to addresses in its signer set. A quantum attacker who derives the signer keys from their public keys can forge that quorum and have the DVN verify fabricated cross-chain messages.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x95729ea44326f8add8a9b1d987279dbdc1dd3dff#code) recovers each 65-byte signature with ECDSA.tryRecover.
- [tryRecover](https://etherscan.io/address/0x95729ea44326f8add8a9b1d987279dbdc1dd3dff#code) calls ecrecover on the signed digest.
- [setSigner](https://etherscan.io/address/0x95729ea44326f8add8a9b1d987279dbdc1dd3dff#code) is onlySelf and sets signer addresses, so rotation stays within ECDSA keys.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 81-99) requires signatures.length == quorum*65, hashes with the Ethereum signed-message prefix, then for each slice calls ECDSA.tryRecover (line 91), which uses ecrecover (ECDSA.sol line 139); it rejects errors (line 93), unordered or duplicate signers (line 94) and non-members (line 95). Per kev's finding, DVN.execute checks this before calling targets such as ReceiveUln302.verify, and quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone, so forged signer keys suffice to verify fabricated packets for OApps requiring this DVN. setSigner (DVN.sol line 99) is onlySelf and only swaps ECDSA signer addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no funds itself; no proxy or upgrade path read.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
