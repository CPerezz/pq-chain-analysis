---
id: dvn-94aafe0a-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum verifies fake messages for OApps relying on this DVN; operator must deploy a
  post-quantum DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x94aafe0a92a8300f0a2100a7f3de47d6845747a9'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x94aafe0a92a8300f0a2100a7f3de47d6845747a9#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps and default configs point to
  it.
evidence_level: source
checks:
- id: c1
  source: '0x94aafe0a92a8300f0a2100a7f3de47d6845747a9'
  file: contracts/uln/dvn/MultiSig.sol
  line: 91
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: verifySignatures recovers each quorum signer with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x94aafe0a92a8300f0a2100a7f3de47d6845747a9'
  file: contracts/uln/dvn/MultiSig.sol
  line: 93
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: A failed recovery rejects the signature set.
  for:
  - what
- id: c3
  source: '0x94aafe0a92a8300f0a2100a7f3de47d6845747a9'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x94aafe0a92a8300f0a2100a7f3de47d6845747a9'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner changes signer addresses, callable only by the DVN itself.
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

This LayerZero DVN acts on a call only when a quorum of signatures recovers, via ECDSA, to addresses in its signer set. A quantum attacker who derives the signer keys can forge the quorum and verify fabricated cross-chain messages for OApps that require this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x94aafe0a92a8300f0a2100a7f3de47d6845747a9#code) recovers each signer of the quorum with ECDSA.tryRecover.
- [tryRecover](https://etherscan.io/address/0x94aafe0a92a8300f0a2100a7f3de47d6845747a9#code) relies on the ecrecover precompile (secp256k1).
- [setSigner](https://etherscan.io/address/0x94aafe0a92a8300f0a2100a7f3de47d6845747a9#code) rotates signers by address, so replacements are again ECDSA keys.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 81-99) requires quorum*65 bytes of signatures, wraps the hash as an Ethereum signed message, and for each 65-byte slice calls ECDSA.tryRecover (line 91), which calls ecrecover (ECDSA.sol line 139); recovered signers must be ascending and present in `signers`. In kev's finding, DVN.execute uses this check before calling ReceiveUln302.verify, and quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner (DVN.sol line 99) is onlySelf and only swaps addresses, i.e. other ECDSA keys. Signer public keys are exposed by signatures they posted, so a quantum attacker can derive the keys and forge a quorum.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN itself holds about $0; funds at stake sit in the OApps that require it.
- Ruled out: No proxy or upgrade path recorded for this contract.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
