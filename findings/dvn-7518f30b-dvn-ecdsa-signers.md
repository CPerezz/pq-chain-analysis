---
id: dvn-7518f30b-dvn-ecdsa-signers
format: 2
title: Superform's LayerZero DVN trusts ECDSA signers a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: ECDSA signer quorum is quantum-forgeable; MEDIUM as the operator can deploy a post-quantum DVN and
  OApps repoint
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7518f30bd5867b5fa86702556245dead173afe46'
  name: DVN
  project: layerzero
  code: verified
  code_url: https://etherscan.io/address/0x7518f30bd5867b5fa86702556245dead173afe46#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 159
impact: funds-loss
action: Deploy a DVN that verifies post-quantum signatures or proofs and have OApps and LayerZero defaults point
  to it
evidence_level: source
checks:
- id: c1
  source: '0x7518f30bd5867b5fa86702556245dead173afe46'
  file: contracts/uln/dvn/MultiSig.sol
  line: 91
  has: (address currentSigner, ECDSA.RecoverError error) = ECDSA.tryRecover(messageDigest, signature);
  says: verifySignatures recovers each signature with ECDSA.tryRecover.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x7518f30bd5867b5fa86702556245dead173afe46'
  file: contracts/uln/dvn/MultiSig.sol
  line: 93
  has: if (error != ECDSA.RecoverError.NoError) return (false, Errors.SignatureError);
  says: A recovery error rejects the signature set.
  for:
  - what
- id: c3
  source: '0x7518f30bd5867b5fa86702556245dead173afe46'
  file: node_modules/@openzeppelin/contracts/utils/cryptography/ECDSA.sol
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c4
  source: '0x7518f30bd5867b5fa86702556245dead173afe46'
  file: contracts/uln/dvn/DVN.sol
  line: 99
  has: function setSigner(address _signer, bool _active) external onlySelf {
  says: setSigner is restricted to the contract itself.
  for:
  - evidence-3
  - justification
- id: q1
  source: '0x7518f30bd5867b5fa86702556245dead173afe46'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (_signatures.length != uint256(quorum) * 65) {
  line: 82
  says: Signature count must equal the quorum.
  for:
  - what
- id: q2
  source: '0x7518f30bd5867b5fa86702556245dead173afe46'
  file: contracts/uln/dvn/MultiSig.sol
  has: if (!signers[currentSigner]) return (false, Errors.SignerNotInCommittee);
  line: 95
  says: Each recovered address must be an active signer.
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

This DVN executes calls such as message verification only when a quorum of signatures from its signer set recovers via ECDSA. A quantum attacker who derives the signer keys could forge that quorum and verify fake cross-chain messages for OApps that require this DVN.

## Evidence

- [verifySignatures](https://etherscan.io/address/0x7518f30bd5867b5fa86702556245dead173afe46#code) recovers each 65-byte signature with ECDSA.tryRecover and checks it against the signer set.
- [tryRecover](https://etherscan.io/address/0x7518f30bd5867b5fa86702556245dead173afe46#code) relies on the ecrecover precompile (secp256k1).
- [setSigner](https://etherscan.io/address/0x7518f30bd5867b5fa86702556245dead173afe46#code) is callable only by the contract itself and rotates to other ECDSA signer addresses.

## Reviewer notes

### Mechanism

MultiSig.verifySignatures (lines 81-99) requires _signatures.length == quorum*65 (line 82), prefixes the hash with the Ethereum signed-message header (line 86), then for each 65-byte slice calls ECDSA.tryRecover (line 91), which calls ecrecover (ECDSA.sol line 139); it requires no error (line 93), strictly ascending signers (line 94) and membership in signers (line 95). DVN.execute uses this check before making the call, in practice ReceiveUln302.verify; once all of an OApp's required DVNs verify, the payload can be committed to EndpointV2 and executed by lzReceive. setSigner (DVN.sol line 99) is onlySelf, so signers rotate only to other ECDSA addresses. Kev's census reads this Superform DVN's quorum as 1 of 1.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The DVN holds no funds itself; funds at risk sit in OApps that require it.
- Ruled out: No proxy: the code is not upgradeable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
