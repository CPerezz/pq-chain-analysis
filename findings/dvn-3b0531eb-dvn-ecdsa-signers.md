---
id: dvn-3b0531eb-dvn-ecdsa-signers
format: 2
title: USDT0's LayerZero DVN accepts ECDSA quorums a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged ECDSA quorums verify fake messages; the operator fixes it by deploying a post-quantum DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3b0531eb02ab4ad72e7a531180beef9493a00dd2'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x3b0531eb02ab4ad72e7a531180beef9493a00dd2#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 79461
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0x3b0531eb02ab4ad72e7a531180beef9493a00dd2'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature is recovered with ECDSA.tryRecover.
  for:
  - action
  - evidence-2
  - evidence-3
  - justification
  - what
- id: c2
  source: '0x3b0531eb02ab4ad72e7a531180beef9493a00dd2'
  file: contracts/uln/dvn/MultiSig.sol
  line: 106
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: The check fails if recovery errors.
  for:
  - what
- id: c3
  source: '0x3b0531eb02ab4ad72e7a531180beef9493a00dd2'
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
  source: '0x3b0531eb02ab4ad72e7a531180beef9493a00dd2'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: Signer rotation is limited to onlySelf calls.
  for:
  - evidence-3
- id: q1
  source: '0x3b0531eb02ab4ad72e7a531180beef9493a00dd2'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Requires exactly quorum signatures of 65 bytes each.
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

This DVN verifies LayerZero messages for OApps on Ethereum and accepts a call when a quorum of its signers sign it with secp256k1 ECDSA. A quantum attacker who recovers the signer keys can forge that quorum and verify fake cross-chain messages for OApps that require this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x3b0531eb02ab4ad72e7a531180beef9493a00dd2#code) requires exactly quorum × 65 bytes of signatures.
- [verifySignatures](https://etherscan.io/address/0x3b0531eb02ab4ad72e7a531180beef9493a00dd2#code) recovers each signer with ECDSA.tryRecover, which calls ecrecover.
- [setSigner](https://etherscan.io/address/0x3b0531eb02ab4ad72e7a531180beef9493a00dd2#code) can rotate signers, but they are still checked with ECDSA.

## Reviewer notes

### Mechanism

DVN.execute (onlyRole ADMIN_ROLE) checks MultiSig.verifySignatures(hash, signatures). That function requires signatures.length == quorum*65 (line 94) and wraps the hash as an Ethereum signed message (line 98). For each 65-byte slice it calls ECDSA.tryRecover (line 104), which calls ecrecover (ECDSA.sol line 139). It requires the recovered signers in ascending order (line 107) and in signerSet (line 108). The approved call is then made, in practice ReceiveUln302.verify. Once all of an OApp's required DVNs have verified, the payload can be committed to EndpointV2 and executed through lzReceive. The finding records quorum 1 of 2 for this DVN, so one recovered key suffices. setSigner is onlySelf, and replacement signers are still ECDSA addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable: no proxy
- Ruled out: The DVN itself holds no funds; the funds at risk sit in the OApps

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
