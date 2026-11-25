---
id: dvn-db979d0a-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum verifies fake messages for OApps that require this DVN; operator must deploy
  a post-quantum DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdb979d0a36af0525afa60fc265b1525505c55d79'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0xdb979d0a36af0525afa60fc265b1525505c55d79#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their DVN configs at it.
evidence_level: source
checks:
- id: c1
  source: '0xdb979d0a36af0525afa60fc265b1525505c55d79'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature slice is recovered with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xdb979d0a36af0525afa60fc265b1525505c55d79'
  file: contracts/uln/dvn/MultiSig.sol
  line: 106
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: A failed recovery rejects the signature set.
  for:
  - what
- id: c3
  source: '0xdb979d0a36af0525afa60fc265b1525505c55d79'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xdb979d0a36af0525afa60fc265b1525505c55d79'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is onlySelf and takes a signer address.
  for:
  - evidence-3
- id: new-verify
  source: '0xdb979d0a36af0525afa60fc265b1525505c55d79'
  file: contracts/uln/dvn/MultiSig.sol
  has: function verifySignatures(bytes32 _hash, bytes calldata _signatures) public view returns (bool, Errors) {
  line: 93
  says: Signature quorum check function.
  for:
  - what
- id: new-insigner
  source: '0xdb979d0a36af0525afa60fc265b1525505c55d79'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: Recovered address must be in the signer set.
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

This DVN acts on a call only when a quorum of signatures recovers, through ECDSA, to addresses in its signer set. A quantum attacker who recovers enough signer keys can sign a call this DVN accepts and verify fake cross-chain messages for OApps that require it.

## Evidence

- [verifySignatures](https://etherscan.io/address/0xdb979d0a36af0525afa60fc265b1525505c55d79#code) recovers each 65-byte signature with ECDSA.tryRecover and checks the signer set.
- [tryRecover](https://etherscan.io/address/0xdb979d0a36af0525afa60fc265b1525505c55d79#code) calls the ecrecover precompile on secp256k1 signatures.
- [setSigner](https://etherscan.io/address/0xdb979d0a36af0525afa60fc265b1525505c55d79#code) is callable by the contract itself and adds signer addresses, which are ECDSA keys.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (MultiSig.sol lines 93-112) requires signatures.length == quorum*65, prefixes the hash with the Ethereum signed-message header (line 98), then for each 65-byte slice calls ECDSA.tryRecover (line 104, ecrecover at ECDSA.sol line 139), rejects errors (106), requires ascending signers (107) and membership in signerSet (108). Per kev, DVN.execute calls this before making the target call, in practice ReceiveUln302.verify, and quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner (DVN.sol line 104) is onlySelf and only rotates to other ECDSA addresses. Funds sit in the OApps that require this DVN, not in the DVN.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN itself holds no funds.
- Ruled out: Not upgradeable; no proxy.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
