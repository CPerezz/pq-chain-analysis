---
id: bridgev2-55239859-mpc-signer
format: 2
title: Symbiosis BridgeV2 trusts one MPC ECDSA key a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: One secp256k1 MPC key authorizes bridge calls; owner Safe can switch mpc to a PQ ERC-1271 verifier,
  not built yet.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5523985926aa12ba58dc5ad00ddca99678d7227e'
  name: BridgeV2
  project: symbiosis
  code: verified
  code_url: https://etherscan.io/address/0x1995bb51aabe557ce119249289c37e0bf5282f32#code
  proxy_of: '0x1995bb51aabe557ce119249289c37e0bf5282f32'
  copies: 1
  upgradeable: 'yes'
  admin: '0x1da522b35363c1eda4833bc121c8f3c67b2caa75'
value:
  usd: 849
  basis: held
activity:
  txs_90d: 35235
impact: funds-loss
action: Point mpc via changeMPC at an ERC-1271 contract verifying a post-quantum threshold signature from the relayers.
evidence_level: source
checks:
- id: c1
  source: '0x1995bb51aabe557ce119249289c37e0bf5282f32'
  file: contracts/synth-core/bridge/BridgeV2.sol
  line: 73
  has: 'require(SignatureChecker.isValidSignatureNow(mpc(), hash, signature), "BridgeV2: invalid signature");'
  says: onlySignedByMPC checks the signature against mpc() via SignatureChecker.
  for:
  - evidence-1
  - justification
  - what
- id: c5
  source: '0x1995bb51aabe557ce119249289c37e0bf5282f32'
  file: '@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol'
  line: 26
  has: (address recovered, ECDSA.RecoverError error) = ECDSA.tryRecover(hash, signature);
  says: SignatureChecker first recovers an ECDSA signer.
  for:
  - justification
  - what
- id: c6
  source: '0x1995bb51aabe557ce119249289c37e0bf5282f32'
  file: '@openzeppelin/contracts/utils/cryptography/SignatureChecker.sol'
  line: 27
  has: if (error == ECDSA.RecoverError.NoError && recovered == signer) {
  says: An ECDSA signature recovering to mpc() is accepted.
  for:
  - what
- id: sendmpc
  source: '0x1995bb51aabe557ce119249289c37e0bf5282f32'
  file: contracts/synth-core/bridge/BridgeV2.sol
  has: 'require(msg.sender == mpc(), "BridgeV2: forbidden");'
  line: 55
  says: receiveRequestV2 accepts calls sent from the mpc address.
  for:
  - what
- id: proc
  source: '0x1995bb51aabe557ce119249289c37e0bf5282f32'
  file: contracts/synth-core/bridge/BridgeV2.sol
  has: 'require(isTransmitter[_receiveSide], "BridgeV2: untrusted transmitter");'
  line: 250
  says: Requests run only against whitelisted receive sides.
  for:
  - evidence-2
  - what
- id: call
  source: '0x1995bb51aabe557ce119249289c37e0bf5282f32'
  file: contracts/synth-core/bridge/BridgeV2.sol
  has: (bool success, bytes memory data) = _receiveSide.call(_callData);
  line: 252
  says: The request calldata is forwarded to the receive side.
  for:
  - evidence-2
- id: chgs
  source: '0x1995bb51aabe557ce119249289c37e0bf5282f32'
  file: contracts/synth-core/bridge/BridgeV2.sol
  has: onlySignedByMPC(this.getMpcHash(_newMPC), signature)
  line: 219
  says: changeMPCSigned replaces the MPC on an MPC signature.
  for:
  - evidence-3
  - what
- id: chg
  source: '0x1995bb51aabe557ce119249289c37e0bf5282f32'
  file: contracts/synth-core/bridge/BridgeV2.sol
  has: function changeMPC(address _newMPC) external onlyOwnerOrMPC returns (bool) {
  line: 210
  says: The owner can set a new MPC address.
  for:
  - action
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review06 (Claude), 2026-11-17 review
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

BridgeV2 executes cross-chain requests on whitelisted receive sides when they are signed by, or sent from, the mpc() address. A quantum attacker who derives the MPC key forges these signatures to run arbitrary calls on trusted receive sides or replace the MPC with changeMPCSigned.

## Evidence

- [onlySignedByMPC](https://etherscan.io/address/0x1995bb51aabe557ce119249289c37e0bf5282f32#code) accepts a request when SignatureChecker validates the signature for mpc().
- [_processRequest](https://etherscan.io/address/0x1995bb51aabe557ce119249289c37e0bf5282f32#code) calls the receive side with attacker-chosen calldata once it is a transmitter.
- [changeMPCSigned](https://etherscan.io/address/0x1995bb51aabe557ce119249289c37e0bf5282f32#code) lets a signature from the current MPC set a new MPC.

## Reviewer notes

### Mechanism

receiveRequestV2Signed (line 137) is guarded by onlySignedByMPC (line 72-75), which calls OpenZeppelin SignatureChecker.isValidSignatureNow(mpc(), getRequestHash(...), signature); that tries ECDSA.tryRecover (ecrecover, ECDSA.sol line 173) first and accepts if the recovered address equals mpc(). receiveRequestV2 (line 126) accepts the same when msg.sender == mpc() (onlyMPC, line 55). _processRequest (line 247) requires isTransmitter[_receiveSide] and then does _receiveSide.call(_callData) (line 252), so the MPC key controls arbitrary calls into trusted receive sides such as the Portal that unlocks tokens. changeMPCSigned (line 217) lets an MPC signature install a new MPC; changeMPC (line 210) is open to owner or MPC, which is the fix path: set mpc() to a contract verifying a post-quantum scheme via ERC-1271.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The tokens at stake sit in the Portal receive side, not in BridgeV2 itself.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
