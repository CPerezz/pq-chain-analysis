---
id: entrypoint-28375939-bungee-auction-signers
format: 2
title: Bungee Entrypoint lets a quantum attacker forge the MOFA auction signer
status: confirmed
severity: MEDIUM
justification: One ECDSA key authorises auction batches; Bungee must deploy a post-quantum Entrypoint and repoint
  the gateway.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2837593949f6c5f7abb66dd848ed4e5b774d4ef5'
  name: Entrypoint
  project: socket
  code: verified
  code_url: https://etherscan.io/address/0x2837593949f6c5f7abb66dd848ed4e5b774d4ef5#code
  copies: 1
  upgradeable: 'no'
  admin: '0xdaee4d2156de6fe6f7d50ca047136d758f96a6f0'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 22
impact: liveness
action: Deploy an Entrypoint that verifies MOFA batches with a post-quantum signature and point the BungeeGateway
  at it.
evidence_level: source
checks:
- id: c2
  source: '0x2837593949f6c5f7abb66dd848ed4e5b774d4ef5'
  file: src/lib/AuthenticationLib.sol
  line: 25
  has: return ecrecover(_ethSignedMessageHash, v, r, s);
  says: recoverSigner uses ecrecover (secp256k1 ECDSA)
  for:
  - evidence-2
  - justification
  - what
- id: e63
  source: '0x2837593949f6c5f7abb66dd848ed4e5b774d4ef5'
  file: src/core/Entrypoint.sol
  has: _checkMofaSig(extractExecs, mofaSignature);
  line: 63
  says: executeSOR checks the MOFA signature first
  for:
  - evidence-1
  - what
- id: e65
  source: '0x2837593949f6c5f7abb66dd848ed4e5b774d4ef5'
  file: src/core/Entrypoint.sol
  has: BUNGEE_GATEWAY.executeImpl(
  line: 65
  says: Entrypoint forwards the batch to the gateway
  for:
  - what
- id: e67
  source: '0x2837593949f6c5f7abb66dd848ed4e5b774d4ef5'
  file: src/core/Entrypoint.sol
  has: abi.encodeCall(SingleOutputRequestImpl.extractRequests, (extractExecs, msg.sender))
  line: 67
  says: gateway extractRequests runs with caller as transmitter
  for:
  - evidence-1
  - what
- id: e101
  source: '0x2837593949f6c5f7abb66dd848ed4e5b774d4ef5'
  file: src/core/Entrypoint.sol
  has: address signer = AuthenticationLib.authenticate(batchHash, mofaSignature);
  line: 101
  says: batch signer is recovered from the signature
  for:
  - justification
  - what
- id: e104
  source: '0x2837593949f6c5f7abb66dd848ed4e5b774d4ef5'
  file: src/core/Entrypoint.sol
  has: if (signer != MOFA_SIGNER) revert MofaSignatureInvalid();
  line: 104
  says: only a MOFA_SIGNER signature passes
  for:
  - action
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
  who: Review15 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

The Entrypoint forwards solver request batches to the BungeeGateway once they carry a MOFA_SIGNER signature checked with ecrecover. A quantum attacker who derives that key can submit batches as auction winner. The gateway still enforces each user's signed minimum output.

## Evidence

- [executeSOR](https://etherscan.io/address/0x2837593949f6c5f7abb66dd848ed4e5b774d4ef5#code) checks the MOFA signature, then calls the gateway with the caller as transmitter.
- [_checkMofaSig](https://etherscan.io/address/0x2837593949f6c5f7abb66dd848ed4e5b774d4ef5#code) reverts unless the ecrecover-recovered signer equals MOFA_SIGNER.

## Reviewer notes

### Mechanism

Entrypoint.executeSOR (line 58) and executeSR (line 79) call _checkMofaSig (lines 96-120). It hashes the batch and calls AuthenticationLib.authenticate (line 101/116). That applies the eth_sign prefix and recoverSigner (line 23), which uses ecrecover on a 65-byte signature (lines 25, 29). It reverts if the result differs from MOFA_SIGNER (line 104/119). After that it calls BUNGEE_GATEWAY.executeImpl with extractRequests or fulfilRequests and msg.sender as transmitter (lines 65-67, 83-85). Per kev, the gateway enforces promisedAmount >= minOutputAmount and pays only after a Socket DL settlement message. A forged MOFA key therefore chooses who fills, not what users receive. setMofaSigner is CONFIG_ROLE-gated (line 42). Rotating to another ECDSA key does not remove the exposure.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The Entrypoint holds no funds.
- Ruled out: A forged MOFA signature alone releases no escrow; settlement needs a Socket DL message.
- Ruled out: Not upgradeable; only the signer and gateway are configurable.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
