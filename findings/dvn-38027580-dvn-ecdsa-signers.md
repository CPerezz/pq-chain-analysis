---
id: dvn-38027580-dvn-ecdsa-signers
format: 2
title: Horizen DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: 'Forged signer quorum lets DVN verify fake messages; MEDIUM: operator can deploy a post-quantum DVN,
  no protocol change'
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x380275805876ff19055ea900cdb2b46a94ecf20d'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x380275805876ff19055ea900cdb2b46a94ecf20d#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 125232
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs, and have OApps and LayerZero defaults point
  at it
evidence_level: source
checks:
- id: c1
  source: '0x380275805876ff19055ea900cdb2b46a94ecf20d'
  file: contracts/uln/dvn/MultiSig.sol
  line: 91
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: each signature is recovered with ECDSA.tryRecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x380275805876ff19055ea900cdb2b46a94ecf20d'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile
  for:
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x380275805876ff19055ea900cdb2b46a94ecf20d'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is onlySelf and takes an ECDSA address
  for:
  - evidence-3
- id: q1
  source: '0x380275805876ff19055ea900cdb2b46a94ecf20d'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 82
  says: exactly quorum signatures of 65 bytes are required
  for:
  - evidence-1
  - what
- id: m1
  source: '0x380275805876ff19055ea900cdb2b46a94ecf20d'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!signers[currentSigner]) return (false, Errors.SignerNotInCommittee);
  line: 95
  says: recovered address must be an active signer
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

This DVN accepts a call only with a quorum of ECDSA signatures from its signer set. A quantum attacker who recovers enough signer keys can sign fabricated packets for this DVN to verify, helping release bridged funds from OApps that require it.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x380275805876ff19055ea900cdb2b46a94ecf20d#code) requires exactly quorum 65-byte signatures and recovers each with ECDSA.
- [verifySignatures](https://etherscan.io/address/0x380275805876ff19055ea900cdb2b46a94ecf20d#code) accepts a recovered signer if it is in the signers mapping.
- [setSigner](https://etherscan.io/address/0x380275805876ff19055ea900cdb2b46a94ecf20d#code) is callable only by the DVN itself and sets an address, so rotation stays on ECDSA keys.

## Reviewer notes

### Mechanism

DVN.execute (onlyRole ADMIN_ROLE) hashes each target call and checks MultiSig.verifySignatures(hash, signatures). verifySignatures (MultiSig.sol lines 81-99) requires signatures.length == quorum*65 (line 82), wraps the hash as an Ethereum signed message (line 86), and for each 65-byte slice calls ECDSA.tryRecover (line 91), which uses ecrecover (ECDSA.sol line 139); signers must be ascending (line 94) and in the signers mapping (line 95). The executed call is ReceiveUln302.verify; once all required DVNs of an OApp verify, the payload hash is committed to EndpointV2 and lzReceive runs. quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner (DVN.sol line 99) is onlySelf and only rotates to other ECDSA addresses. Per kev, this Horizen DVN has quorum 2 of 2 and is required by Stargate V2 pools.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: DVN contract itself holds no funds
- Ruled out: No proxy or upgrade function

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
