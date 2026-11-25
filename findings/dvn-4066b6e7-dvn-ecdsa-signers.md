---
id: dvn-4066b6e7-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged signer quorum lets fake messages verify; fix is a post-quantum DVN deployed by the operator,
  no protocol change.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4066b6e7bfd761b579902e7e8d03f4feb9b9536e'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x4066b6e7bfd761b579902e7e8d03f4feb9b9536e#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 2
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps point their configs at it.
evidence_level: source
checks:
- id: c1
  source: '0x4066b6e7bfd761b579902e7e8d03f4feb9b9536e'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: each signature slice is checked with ECDSA.tryRecover
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c3
  source: '0x4066b6e7bfd761b579902e7e8d03f4feb9b9536e'
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
  source: '0x4066b6e7bfd761b579902e7e8d03f4feb9b9536e'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: signers are changed only through self-call setSigner by address
  for:
  - evidence-3
- id: vs-len
  source: '0x4066b6e7bfd761b579902e7e8d03f4feb9b9536e'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: signatures must be exactly quorum 65-byte slices
  for:
  - evidence-1
  - what
- id: c-signer
  source: '0x4066b6e7bfd761b579902e7e8d03f4feb9b9536e'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: recovered signer must be in the committee
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

This DVN accepts a call only if a quorum of 65-byte ECDSA signatures recovers to addresses in its signer set. A quantum attacker who recovers enough signer keys can forge that quorum and have the DVN verify fabricated cross-chain messages for OApps that require it.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x4066b6e7bfd761b579902e7e8d03f4feb9b9536e#code) requires exactly quorum × 65 bytes of signatures.
- [verifySignatures](https://etherscan.io/address/0x4066b6e7bfd761b579902e7e8d03f4feb9b9536e#code) recovers each signer with ECDSA and rejects any not in the committee.
- [setSigner](https://etherscan.io/address/0x4066b6e7bfd761b579902e7e8d03f4feb9b9536e#code) swaps signers by address, so a rotation still uses ECDSA keys.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (MultiSig.sol lines 93-112) requires _signatures.length == quorum * 65 (line 94), prefixes the hash as an Ethereum signed message (line 98), then for each 65-byte slice calls ECDSA.tryRecover (line 104, ecrecover at ECDSA.sol line 139), demands ascending signer order (line 107) and committee membership via isSigner (line 108). DVN.execute uses this check before making the target call, in practice ReceiveUln302.verify; once all of an OApp's required DVNs verify, the payload can be committed to EndpointV2 and executed by lzReceive, releasing or minting funds. setSigner (DVN.sol line 104) is onlySelf and only rotates to other ECDSA addresses. This DVN holds about $0; funds at risk sit in the OApps that require it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN itself holds no funds.
- Ruled out: Not upgradeable; no proxy admin read.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
