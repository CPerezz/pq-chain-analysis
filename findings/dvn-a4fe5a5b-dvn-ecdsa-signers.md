---
id: dvn-a4fe5a5b-dvn-ecdsa-signers
format: 2
title: LayerZero Canary DVN accepts ECDSA quorums a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: 'Forged ECDSA quorum keys verify fake messages. MEDIUM: operators deploy post-quantum DVNs, no protocol
  change'
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 262566
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps and default configs point at
  it.
evidence_level: source
checks:
- id: c1
  source: '0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: each signature slice is checked with ECDSA.tryRecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd'
  file: contracts/uln/dvn/MultiSig.sol
  line: 106
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: an ECDSA recovery error fails verification
  for:
  - what
- id: c3
  source: '0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: recovery uses the ecrecover precompile (secp256k1)
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: signer changes are onlySelf and take an address
  for:
  - evidence-3
- id: v1
  source: '0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: signature blob must be exactly quorum 65-byte signatures
  for:
  - evidence-1
  - what
- id: v2
  source: '0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: recovered ECDSA signer must be in the committee
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

This DVN accepts a call only with a quorum of secp256k1 signatures from its signer set, recovered with ecrecover. A quantum attacker who recovers the signer keys can produce that quorum and verify fabricated cross-chain packets for OApps that require this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd#code) requires quorum × 65 bytes of signatures and runs ECDSA.tryRecover on each slice.
- [tryRecover](https://etherscan.io/address/0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd#code) gets the signer from ecrecover, a secp256k1 check.
- [setSigner](https://etherscan.io/address/0xa4fe5a5b9a846458a70cd0748228aed3bf65c2cd#code) is onlySelf and swaps signers as addresses, so rotation stays on ECDSA keys.

## Reviewer notes

### Mechanism

DVN.execute (ADMIN_ROLE) hashes each target call and checks MultiSig.verifySignatures(hash, signatures). In MultiSig.sol, line 94 requires signatures.length == quorum*65. Line 98 builds an EIP-191 digest. Lines 101-110 run ECDSA.tryRecover per 65-byte slice, which calls ecrecover at ECDSA.sol line 139. Recovered signers must be in ascending order and in signerSet. The verified call is in practice ReceiveUln302.verify. Once all required DVNs of an OApp have verified, the payload hash is committed to EndpointV2 and lzReceive executes it. Per kev, quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner/setQuorum are onlySelf and accept only other address (ECDSA) signers. Kev reads this DVN (Canary) at a quorum of 1 of 1. It is required by Stargate's USDC and native pools.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable: no proxy; only config changes
- Ruled out: DVN itself holds no funds; funds sit in the OApps

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
