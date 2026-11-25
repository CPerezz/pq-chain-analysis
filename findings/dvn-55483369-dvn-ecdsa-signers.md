---
id: dvn-55483369-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Quorum of secp256k1 signers verifies messages; the operator fixes it by deploying a post-quantum
  DVN. MEDIUM.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x554833698ae0fb22ecc90b01222903fd62ca4b47'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x554833698ae0fb22ecc90b01222903fd62ca4b47#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 117
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0x554833698ae0fb22ecc90b01222903fd62ca4b47'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: verifySignatures recovers each signer with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x554833698ae0fb22ecc90b01222903fd62ca4b47'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x554833698ae0fb22ecc90b01222903fd62ca4b47'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is callable only by the DVN itself.
  for:
  - evidence-3
  - justification
- id: vs-len
  source: '0x554833698ae0fb22ecc90b01222903fd62ca4b47'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Signatures must number exactly quorum times 65 bytes.
  for:
  - what
- id: is-signer
  source: '0x554833698ae0fb22ecc90b01222903fd62ca4b47'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: Each recovered address must be in the signer committee.
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
reviews: []
related: []
---

## What happens

This DVN accepts a call only when a quorum of 65-byte signatures each recovers, via ECDSA, to an address in its signer set. A quantum attacker who recovers enough signer keys forges the quorum, so this DVN vouches for fabricated cross-chain messages.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x554833698ae0fb22ecc90b01222903fd62ca4b47#code) recovers each signer with ECDSA.tryRecover and requires it to be in the committee.
- [tryRecover](https://etherscan.io/address/0x554833698ae0fb22ecc90b01222903fd62ca4b47#code) relies on the ecrecover precompile.
- [setSigner](https://etherscan.io/address/0x554833698ae0fb22ecc90b01222903fd62ca4b47#code) is onlySelf, so signers rotate only through the same signature check, to other addresses.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (MultiSig.sol lines 93-112) requires _signatures.length == quorum * 65 (line 94), prefixes the hash with the Ethereum signed-message header (line 98), then for each 65-byte slice calls ECDSA.tryRecover (line 104), which uses ecrecover (ECDSA.sol line 139). Signers must be ascending (line 107) and in signerSet (line 108). Per kev, DVN.execute uses this check before calling ReceiveUln302.verify, and quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner (DVN.sol line 104) is onlySelf, so rotation stays within ECDSA keys. Recovering the quorum's secp256k1 keys from posted signatures lets an attacker verify a fabricated packet; if this DVN is a required DVN of an OApp, the OApp can release funds.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract is not upgradeable.
- Ruled out: The DVN holds no funds itself; funds sit in the OApps that use it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
