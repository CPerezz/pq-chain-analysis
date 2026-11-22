---
id: signatureverifier-f1abf110-dl-signature-verifier
format: 2
title: Socket SignatureVerifier recovers ECDSA signers a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Transmitter and watcher roles rest on ECDSA; fixing needs new deployments by the Socket Safe
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf1abf110d1b6ff0e2e8c05dd64fbf9eba4d8af98'
  name: SignatureVerifier
  project: socket
  code: verified
  code_url: https://etherscan.io/address/0xf1abf110d1b6ff0e2e8c05dd64fbf9eba4d8af98#code
  copies: 1
  upgradeable: 'no'
  admin: '0xeef6520437a6545b4f325f6675c4cd49812d457b'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 10173
impact: funds-loss
action: Deploy a post-quantum verifier, set it on TransmitManager, and redeploy switchboard and execution manager
  using it
evidence_level: source
checks:
- id: c1
  source: '0xf1abf110d1b6ff0e2e8c05dd64fbf9eba4d8af98'
  file: contracts/utils/SignatureVerifier.sol
  line: 43
  has: signer = ECDSA.recover(digest, signature_);
  says: recoverSigner returns ECDSA.recover of the signature
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c3
  source: '0xf1abf110d1b6ff0e2e8c05dd64fbf9eba4d8af98'
  file: contracts/utils/SignatureVerifier.sol
  line: 35
  has: function recoverSigner(
  says: recoverSigner is the verifier's entry point
  for:
  - evidence-1
  - what
- id: c5
  source: '0xf1abf110d1b6ff0e2e8c05dd64fbf9eba4d8af98'
  file: contracts/TransmitManager.sol
  line: 82
  has: address transmitter = signatureVerifier__.recoverSigner(
  says: TransmitManager recovers the transmitter via recoverSigner
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c7
  source: '0xf1abf110d1b6ff0e2e8c05dd64fbf9eba4d8af98'
  file: contracts/switchboard/default-switchboards/SwitchboardBase.sol
  line: 165
  has: address tripper = signatureVerifier__.recoverSigner(
  says: tripGlobal recovers the tripper via recoverSigner
  for:
  - justification
- id: c8
  source: '0xf1abf110d1b6ff0e2e8c05dd64fbf9eba4d8af98'
  file: contracts/switchboard/default-switchboards/SwitchboardBase.sol
  line: 199
  has: address watcher = signatureVerifier__.recoverSigner(
  says: tripPath recovers the watcher via recoverSigner
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
  who: Review15 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract returns the signer of a digest by plain ECDSA recovery, and Socket's TransmitManager and switchboards trust that address to check roles. With forged transmitter and executor keys, a quantum attacker could get fake cross-chain messages accepted by Socket plugs.

## Evidence

- [recoverSigner](https://etherscan.io/address/0xf1abf110d1b6ff0e2e8c05dd64fbf9eba4d8af98#code) returns ECDSA.recover over the eth_sign digest.
- [checkTransmitter](https://etherscan.io/address/0xf1abf110d1b6ff0e2e8c05dd64fbf9eba4d8af98#code) takes the transmitter from recoverSigner.
- [tripPath](https://etherscan.io/address/0xf1abf110d1b6ff0e2e8c05dd64fbf9eba4d8af98#code) identifies the watcher through recoverSigner too.

## Reviewer notes

### Mechanism

SignatureVerifier.recoverSigner (lines 35-44) prefixes the digest with the eth_sign header and returns ECDSA.recover(digest, signature_) (line 43), which calls ecrecover in OpenZeppelin tryRecover (line 139). Callers check the role of the returned address: TransmitManager.checkTransmitter (line 82) for TRANSMITTER_ROLE on packet roots, setTransmissionFees (line 100) for fee updaters, and SwitchboardBase.tripGlobal/tripPath (lines 165, 199) for watchers. Per kev, ExecutionManager uses it for executors, and FastSwitchboard allows a packet after a timeout absent a watcher trip, so forged transmitter and executor keys let a fake inbound message reach plugs whose vaults release tokens.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The solmate ERC20 permit in the sources is library code, not this contract's verification path.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
