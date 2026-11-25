---
id: dvn-89ca1593-dvn-ecdsa-signers
format: 2
title: WBTC Canary LayerZero DVN trusts ECDSA signers a quantum attacker could forge
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
  address: '0x89ca15937e1033af26fe4c5e976216e8c8179408'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x89ca15937e1033af26fe4c5e976216e8c8179408#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs, and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0x89ca15937e1033af26fe4c5e976216e8c8179408'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature slice is checked with ECDSA.tryRecover.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c3
  source: '0x89ca15937e1033af26fe4c5e976216e8c8179408'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover calls the ecrecover precompile.
  for:
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x89ca15937e1033af26fe4c5e976216e8c8179408'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner can be called only by the contract itself.
  for:
  - action
  - evidence-3
  - justification
- id: v94
  source: '0x89ca15937e1033af26fe4c5e976216e8c8179408'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Signature bytes must equal quorum times 65.
  for:
  - evidence-1
  - what
- id: v108
  source: '0x89ca15937e1033af26fe4c5e976216e8c8179408'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: The recovered address must be in the signer set.
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

This LayerZero DVN accepts a call only with a quorum of secp256k1 signatures from its signer set, checked by ECDSA recovery. A quantum attacker who recovers the signer keys can forge that quorum and verify fabricated cross-chain packets for OApps that require this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x89ca15937e1033af26fe4c5e976216e8c8179408#code) requires exactly quorum × 65 bytes of signatures.
- [verifySignatures](https://etherscan.io/address/0x89ca15937e1033af26fe4c5e976216e8c8179408#code) recovers each signer with ECDSA and rejects addresses outside the committee.
- [setSigner](https://etherscan.io/address/0x89ca15937e1033af26fe4c5e976216e8c8179408#code) is onlySelf, so signers rotate only to other ECDSA-checked addresses.

## Reviewer notes

### Mechanism

DVN.execute (ADMIN_ROLE) hashes each target call and calls MultiSig.verifySignatures(hash, signatures). Line 94 requires signatures.length == quorum*65; line 98 wraps the hash as an Ethereum signed message; lines 101-110 loop over 65-byte slices, call ECDSA.tryRecover (line 104, reaching ecrecover at ECDSA.sol line 139), require ascending signer order (107) and committee membership (108). The call made is in practice ReceiveUln302.verify; once all required DVNs of an OApp verify, the payload can be committed to EndpointV2 and executed by lzReceive. quorumChangeAdmin grants ADMIN_ROLE on quorum signatures alone. setSigner (DVN.sol line 104) is onlySelf, so signer rotation stays within ECDSA.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN itself holds no funds; the funds sit in the OApps that require it.
- Ruled out: Not upgradeable: no proxy or upgrade function.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
