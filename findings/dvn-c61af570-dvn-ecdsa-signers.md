---
id: dvn-c61af570-dvn-ecdsa-signers
format: 2
title: LayerZero DVN accepts ECDSA signer quorums that a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged quorum lets this DVN attest fake messages for OApps requiring it; its operator must deploy
  a post-quantum DVN.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc61af5706b80ca941a0aab1c7b3d7a953e4dd8c4'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0xc61af5706b80ca941a0aab1c7b3d7a953e4dd8c4#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1566
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApp configs point at it.
evidence_level: source
checks:
- id: c1
  source: '0xc61af5706b80ca941a0aab1c7b3d7a953e4dd8c4'
  file: contracts/uln/dvn/MultiSig.sol
  line: 104
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: Each signature is checked by ECDSA recovery.
  for:
  - action
  - evidence-2
  - evidence-3
  - justification
  - what
- id: c3
  source: '0xc61af5706b80ca941a0aab1c7b3d7a953e4dd8c4'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile (secp256k1).
  for:
  - evidence-2
  - what
- id: c4
  source: '0xc61af5706b80ca941a0aab1c7b3d7a953e4dd8c4'
  file: contracts/uln/dvn/DVN.sol
  line: 104
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is onlySelf and changes signer addresses.
  for:
  - action
  - evidence-3
  - justification
- id: s94
  source: '0xc61af5706b80ca941a0aab1c7b3d7a953e4dd8c4'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 94
  says: Exactly quorum 65-byte signatures are required.
  for:
  - evidence-1
  - justification
  - what
- id: s108
  source: '0xc61af5706b80ca941a0aab1c7b3d7a953e4dd8c4'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!isSigner(currentSigner)) return (false, Errors.SignerNotInCommittee);
  line: 108
  says: Each recovered address must be in the signer set.
  for:
  - evidence-2
  - justification
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

This DVN accepts a signed batch only if a quorum of ECDSA signatures recovers to addresses in its signer set. A quantum attacker who derives the signer keys forges that quorum and has the DVN attest fabricated cross-chain messages.

## Evidence

- [verifySignatures](https://etherscan.io/address/0xc61af5706b80ca941a0aab1c7b3d7a953e4dd8c4#code) requires exactly quorum × 65 signature bytes.
- [verifySignatures](https://etherscan.io/address/0xc61af5706b80ca941a0aab1c7b3d7a953e4dd8c4#code) recovers each signer with ECDSA (ecrecover) and rejects signers outside the committee.
- [setSigner](https://etherscan.io/address/0xc61af5706b80ca941a0aab1c7b3d7a953e4dd8c4#code) is onlySelf and swaps signer addresses, which are again checked by ECDSA.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures(_hash, _signatures) (MultiSig.sol lines 93-112) requires _signatures.length == quorum*65 (line 94), wraps the hash as an EIP-191 message (line 98), and for each 65-byte slice calls ECDSA.tryRecover (line 104 -> ecrecover at ECDSA.sol line 139). Recovered addresses must be strictly ascending (line 107) and in signerSet (line 108). DVN.execute uses this check before making calls such as ReceiveUln302.verify; once all required DVNs of an OApp verify a packet, it can be committed to EndpointV2 and executed by lzReceive. Signer rotation via setSigner (DVN.sol line 104, onlySelf) only installs other ECDSA addresses. A quantum attacker recovering quorum keys from posted signatures forges valid batches.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds about $0; funds at risk sit in OApps that require this DVN.
- Ruled out: Not upgradeable (no proxy).

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
