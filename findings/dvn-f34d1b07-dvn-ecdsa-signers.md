---
id: dvn-f34d1b07-dvn-ecdsa-signers
format: 2
title: LayerZero DVN trusts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum verifies fake messages for OApps using this DVN; operator fixes by deploying
  a post-quantum DVN
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf34d1b07c64c4f4d492ae3ddd0aab0658a2975eb'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0xf34d1b07c64c4f4d492ae3ddd0aab0658a2975eb#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 89
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it
evidence_level: source
checks:
- id: c1
  source: '0xf34d1b07c64c4f4d492ae3ddd0aab0658a2975eb'
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
  source: '0xf34d1b07c64c4f4d492ae3ddd0aab0658a2975eb'
  file: contracts/uln/dvn/MultiSig.sol
  line: 93
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: A recovery error rejects the signature set.
  for:
  - what
- id: c3
  source: '0xf34d1b07c64c4f4d492ae3ddd0aab0658a2975eb'
  file: node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile (secp256k1).
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0xf34d1b07c64c4f4d492ae3ddd0aab0658a2975eb'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: Signers are changed only via onlySelf setSigner with an address.
  for:
  - evidence-3
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

This DVN acts only when a quorum of 65-byte signatures each recover via ECDSA to an active signer. A quantum attacker who derives the signer keys from public keys forges that quorum and has the DVN verify fabricated cross-chain messages. Signers can be rotated, but only to other ECDSA addresses.

## Evidence

- [verifySignatures](https://etherscan.io/address/0xf34d1b07c64c4f4d492ae3ddd0aab0658a2975eb#code) recovers each signer with ECDSA.tryRecover.
- [tryRecover](https://etherscan.io/address/0xf34d1b07c64c4f4d492ae3ddd0aab0658a2975eb#code) calls ecrecover on the secp256k1 signature.
- [setSigner](https://etherscan.io/address/0xf34d1b07c64c4f4d492ae3ddd0aab0658a2975eb#code) changes signer addresses, which remain ECDSA keys.

## Reviewer notes

### Mechanism

DVN.execute hashes the target calls and checks MultiSig.verifySignatures(hash, signatures): length must equal quorum*65 (line 82), the hash is EIP-191 wrapped (line 86), each 65-byte slice goes through ECDSA.tryRecover (line 91), which calls ecrecover (ECDSA.sol line 139); errors fail (line 93), signers must ascend (line 94) and be active in signers (line 95). Once verified, the DVN's call (in practice ReceiveUln302.verify) is made, so forged signer keys let an attacker verify fabricated packets for any OApp requiring this DVN. setSigner (DVN.sol line 99) is onlySelf and only swaps ECDSA addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN holds about $0 itself; funds at stake sit in the OApps that require it.
- Ruled out: No proxy or upgrade path read for this contract.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
