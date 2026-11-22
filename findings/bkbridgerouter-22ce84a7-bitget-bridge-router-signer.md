---
id: bkbridgerouter-22ce84a7-bitget-bridge-router-signer
format: 2
title: Bitget bridge router trusts an ECDSA co-signer a quantum attacker could forge
status: confirmed
severity: LOW
justification: 'LOW: a forged co-signature alone releases nothing; Bitget can keep the router paused or deploy a
  post-quantum router.'
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x22ce84a7f86662b78e49c6ec9e51d60fdde7b70a'
  name: BKBridgeRouter
  project: bitget-wallet
  code: verified
  code_url: https://etherscan.io/address/0x22ce84a7f86662b78e49c6ec9e51d60fdde7b70a#code
  copies: 1
  admin: '0x9287b8e84d972dd02f618bbed45b9a6d7ed16384'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Keep the router paused, or deploy a router that verifies a post-quantum co-signature.
evidence_level: source
checks:
- id: c1
  source: '0x22ce84a7f86662b78e49c6ec9e51d60fdde7b70a'
  file: contracts/BKBridgeAccess.sol
  line: 193
  has: address signer_ = finalMsgHash.recover(_signature);
  says: _checkSigner recovers the co-signer with ECDSA.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x22ce84a7f86662b78e49c6ec9e51d60fdde7b70a'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 144
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile.
  for:
  - what
- id: c3
  source: '0x22ce84a7f86662b78e49c6ec9e51d60fdde7b70a'
  file: contracts/BKBridgeAccess.sol
  line: 116
  has: function pause() external onlyOperator {
  says: Operator can pause the router.
  for:
  - action
  - evidence-3
  - justification
- id: signer-cmp
  source: '0x22ce84a7f86662b78e49c6ec9e51d60fdde7b70a'
  file: contracts/BKBridgeAccess.sol
  has: if (signer_ != signer) {
  line: 195
  says: Recovered address must equal the stored signer.
  for:
  - evidence-1
  - what
- id: relayer
  source: '0x22ce84a7f86662b78e49c6ec9e51d60fdde7b70a'
  file: contracts/BKBridgeAccess.sol
  has: if (!isRelayer[msg.sender]) {
  line: 151
  says: Relayer calls require a whitelisted msg.sender.
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
reviews: []
related: []
---

## What happens

This router accepts bridge orders only with a co-signature that ECDSA recovers to the backend signer key. A quantum attacker who forges that key skips the backend's approval, but relay calls still require a whitelisted relayer as caller.

## Evidence

- [_checkSigner](https://etherscan.io/address/0x22ce84a7f86662b78e49c6ec9e51d60fdde7b70a#code) reverts unless the ECDSA-recovered address equals the stored signer.
- [_checkRelayer](https://etherscan.io/address/0x22ce84a7f86662b78e49c6ec9e51d60fdde7b70a#code) reverts unless msg.sender is a whitelisted relayer.
- [pause](https://etherscan.io/address/0x22ce84a7f86662b78e49c6ec9e51d60fdde7b70a#code) lets the operator stop the router.

## Reviewer notes

### Mechanism

_checkSigner (BKBridgeAccess.sol lines 186-198) spends an unordered nonce, hashes (nonce, chainid, this, msg.sender, transferId, dstChainId), applies toEthSignedMessageHash and requires ECDSA.recover (ecrecover, ECDSA.sol line 144) to equal `signer`. It is called by send/sendV1/sendV2 (onlySender: the caller pays its own tokens into the vault) and by relay/relayV1/relayV2/cancel/refund (onlyRelayer, lines 150-154), whose payouts are safeTransferFrom from the relayer's own balance. A forged signer key therefore removes the backend's approval but releases no funds on its own. setAccess (owner) can rotate signer only to another ECDSA key; the operator's pause() (line 116) stops the path.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Router holds no funds; payouts come from relayers' own balances.
- Ruled out: No proxy; logic is not upgradeable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
