---
id: dvn-02041731-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Signers are ECDSA keys; the operator fixes it by deploying a post-quantum DVN that OApp configs then
  point at.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x02041731cb8cbae90838bb8632c359fc0c2b0775'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x02041731cb8cbae90838bb8632c359fc0c2b0775#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs, and have default and OApp configs point at
  it.
evidence_level: source
checks:
- id: c1
  source: '0x02041731cb8cbae90838bb8632c359fc0c2b0775'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature slice is recovered with ECDSA.tryRecover.
  for:
  - evidence-1
  - justification
  - what
- id: c3
  source: '0x02041731cb8cbae90838bb8632c359fc0c2b0775'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile (secp256k1).
  for:
  - justification
  - what
- id: c4
  source: '0x02041731cb8cbae90838bb8632c359fc0c2b0775'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is onlySelf and takes an address-based signer.
  for:
  - action
  - evidence-3
  - justification
- id: len
  source: '0x02041731cb8cbae90838bb8632c359fc0c2b0775'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Signatures must be exactly quorum 65-byte ECDSA signatures.
  for:
  - evidence-1
  - what
- id: member
  source: '0x02041731cb8cbae90838bb8632c359fc0c2b0775'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: A recovered address passes if it is in the signer set.
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

This DVN verifies LayerZero cross-chain messages and accepts a call only with a quorum of ECDSA signatures from its signer set. A quantum attacker who derives the signers' private keys from their public keys can forge that quorum and verify fabricated messages.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x02041731cb8cbae90838bb8632c359fc0c2b0775#code) requires exactly quorum × 65 bytes of signatures and recovers each signer with ECDSA.
- [verifySignatures](https://etherscan.io/address/0x02041731cb8cbae90838bb8632c359fc0c2b0775#code) accepts a recovered address if it is in the signer set.
- [setSigner](https://etherscan.io/address/0x02041731cb8cbae90838bb8632c359fc0c2b0775#code) can only be called by the contract itself and only swaps one address-based signer for another.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures(hash, signatures) (MultiSig.sol lines 93-112) first requires signatures.length == quorum*65 (line 94). It then builds the EIP-191 digest (line 98). For each 65-byte slice it calls ECDSA.tryRecover (line 104), which uses ecrecover (ECDSA.sol line 139). It requires ascending signer order (line 107) and membership in signerSet (line 108). DVN.execute relies on this check before calling targets such as ReceiveUln302.verify. Once all of an OApp's required DVNs have verified a packet, it can be committed and delivered via lzReceive, releasing or minting funds. setSigner is onlySelf (DVN.sol line 104), so signers can only be rotated to other ECDSA addresses.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable: no proxy.
- Ruled out: The DVN itself holds no funds; the funds at risk sit in the OApps that require it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
