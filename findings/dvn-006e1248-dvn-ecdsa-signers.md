---
id: dvn-006e1248-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum verifies fake messages for OApps relying on it; operator must deploy a post-quantum
  DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x006e1248be5e40b4a4e7099397719df7ab872de7'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x006e1248be5e40b4a4e7099397719df7ab872de7#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps and defaults point to it.
evidence_level: source
checks:
- id: c1
  source: '0x006e1248be5e40b4a4e7099397719df7ab872de7'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature is checked with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x006e1248be5e40b4a4e7099397719df7ab872de7'
  file: contracts/uln/dvn/MultiSig.sol
  line: 106
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: Any recovery error rejects; a valid forged signature passes.
  for:
  - what
- id: c3
  source: '0x006e1248be5e40b4a4e7099397719df7ab872de7'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover secp256k1 precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x006e1248be5e40b4a4e7099397719df7ab872de7'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: Signer rotation is self-only and sets addresses.
  for:
  - evidence-3
- id: q
  source: '0x006e1248be5e40b4a4e7099397719df7ab872de7'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Exactly a quorum of 65-byte signatures is required.
  for:
  - what
- id: in
  source: '0x006e1248be5e40b4a4e7099397719df7ab872de7'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: Recovered signer must be in the committee.
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

This DVN verifies cross-chain messages for LayerZero OApps and acts only on a quorum of secp256k1 signatures from its signer set. A quantum attacker who recovers enough signer keys can sign fake packets that OApps relying on this DVN would accept.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x006e1248be5e40b4a4e7099397719df7ab872de7#code) recovers each 65-byte signature with ECDSA and checks it is in the signer set.
- [tryRecover](https://etherscan.io/address/0x006e1248be5e40b4a4e7099397719df7ab872de7#code) calls ecrecover, a secp256k1 check.
- [setSigner](https://etherscan.io/address/0x006e1248be5e40b4a4e7099397719df7ab872de7#code) rotates signers by address, so replacements are again ECDSA keys.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 93-112) requires signatures.length == quorum*65 (line 94), applies the EIP-191 prefix (line 98), then for each slice calls ECDSA.tryRecover (line 104), which uses ecrecover (ECDSA.sol line 139); it requires ascending signers (line 107) and membership in signerSet (line 108). The DVN's execute path relies on this check before calling ReceiveUln302.verify for packets; once all required DVNs of an OApp verify, the payload can be committed and executed. setSigner (DVN.sol line 104) is onlySelf and only swaps addresses, i.e. other ECDSA keys.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no funds itself; funds sit in the OApps that require it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
