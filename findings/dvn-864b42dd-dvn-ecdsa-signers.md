---
id: dvn-864b42dd-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum verifies fake messages for OApps relying on this DVN; operator must redeploy
  a post-quantum DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x864b42dddc43a610e7506c163048c087f0b406ef'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x864b42dddc43a610e7506c163048c087f0b406ef#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 221
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0x864b42dddc43a610e7506c163048c087f0b406ef'
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
  source: '0x864b42dddc43a610e7506c163048c087f0b406ef'
  file: contracts/uln/dvn/MultiSig.sol
  line: 106
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: A failed recovery rejects the signature set.
  for:
  - what
- id: c3
  source: '0x864b42dddc43a610e7506c163048c087f0b406ef'
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
  source: '0x864b42dddc43a610e7506c163048c087f0b406ef'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: Signer changes are onlySelf.
  for:
  - evidence-3
- id: vs-len
  source: '0x864b42dddc43a610e7506c163048c087f0b406ef'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Signatures must be exactly quorum 65-byte ECDSA signatures.
  for:
  - evidence-1
  - justification
  - what
- id: vs-committee
  source: '0x864b42dddc43a610e7506c163048c087f0b406ef'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: Recovered signer must be in the committee.
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
reviews: []
related: []
---

## What happens

This DVN acts on a call only when a quorum of signatures recovers, through ECDSA, to addresses in its signer set. A quantum attacker who recovers a quorum of signer keys can sign calls that this DVN accepts as its own verification of cross-chain messages.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x864b42dddc43a610e7506c163048c087f0b406ef#code) requires exactly quorum × 65 bytes of signatures.
- [verifySignatures](https://etherscan.io/address/0x864b42dddc43a610e7506c163048c087f0b406ef#code) recovers each signer with ECDSA (ecrecover) and checks it is in the committee.
- [setSigner](https://etherscan.io/address/0x864b42dddc43a610e7506c163048c087f0b406ef#code) is onlySelf, so signers rotate only to other addresses checked by ECDSA.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 93-112) checks _signatures.length == quorum*65 (line 94), builds an EIP-191 digest (line 98), then for each 65-byte slice calls ECDSA.tryRecover (line 104), which calls ecrecover (ECDSA.sol line 139); recovered signers must be strictly ascending (line 107) and in signerSet (line 108). Per kev's finding, DVN.execute uses this check before calling ReceiveUln302.verify, and quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner (DVN.sol line 104) is onlySelf and keeps ECDSA keys. Keys recovered from posted signatures let an attacker produce a valid quorum.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds about $0 itself; funds sit in OApps that require this DVN.
- Ruled out: Not upgradeable per registry data.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
