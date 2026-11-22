---
id: lcpclient-21fd9803-vsg-lcp-enclave-keys
format: 2
title: VSG redeem bridge client trusts quantum-forgeable enclave signatures
status: confirmed
severity: MEDIUM
justification: Forged enclave signatures prove false redeem packets; the immutable client needs a new deployment
  by the operator.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x21fd9803336f9800241122ee1e6bd1849f537549'
  name: LCPClient
  project: vector-smart-chain
  code: verified
  code_url: https://etherscan.io/address/0x21fd9803336f9800241122ee1e6bd1849f537549#code
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a client verifying post-quantum enclave signatures and RSA-free attestation, and move the redeem
  channel to it.
evidence_level: source
checks:
- id: c1
  source: '0x21fd9803336f9800241122ee1e6bd1849f537549'
  file: '@datachainlab/lcp-solidity/contracts/LCPClientBase.sol'
  line: 654
  has: return ECDSA.recover(commitment, signature);
  says: Signature check is ECDSA recovery.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x21fd9803336f9800241122ee1e6bd1849f537549'
  file: '@ensdomains/ens-contracts/contracts/dnssec-oracle/algorithms/ModexpPrecompile.sol'
  line: 7
  has: function modexp(
  says: modexp precompile wrapper used for RSA.
  for:
  - evidence-3
- id: c3
  source: '0x21fd9803336f9800241122ee1e6bd1849f537549'
  file: '@ensdomains/ens-contracts/contracts/dnssec-oracle/algorithms/RSAVerify.sol'
  line: 19
  has: return ModexpPrecompile.modexp(S, E, N);
  says: RSA recovery via modexp.
  for:
  - evidence-3
- id: c4
  source: '0x21fd9803336f9800241122ee1e6bd1849f537549'
  file: '@datachainlab/lcp-solidity/contracts/AVRValidator.sol'
  line: 96
  has: if (!verifySignature(sha256(report), signature, params.exponent, params.modulus)) {
  says: Attestation report accepted only on a valid RSA signature.
  for:
  - evidence-2
  - what
- id: c6
  source: '0x21fd9803336f9800241122ee1e6bd1849f537549'
  file: '@datachainlab/lcp-solidity/contracts/AVRValidator.sol'
  line: 115
  has: (bool ok, bytes memory result) = RSAVerify.rsarecover(modulus, exponent, signature);
  says: Report signature verified with RSA.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: ens-active
  source: '0x21fd9803336f9800241122ee1e6bd1849f537549'
  file: '@datachainlab/lcp-solidity/contracts/LCPClientBase.sol'
  has: function ensureActiveKey(ClientStorage storage clientStorage, address ekAddr)
  line: 619
  says: Recovered signer must be an active registered enclave key.
  for:
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

This light client accepts states and packet proofs when an ECDSA signature recovers to an enclave key. Enclave keys are registered from an Intel report checked with RSA. A quantum attacker who recovers either key can prove forged redeem packets.

## Evidence

- [verifyECDSASignature](https://etherscan.io/address/0x21fd9803336f9800241122ee1e6bd1849f537549#code) returns the signer that ECDSA.recover derives from the commitment.
- [verifyReport](https://etherscan.io/address/0x21fd9803336f9800241122ee1e6bd1849f537549#code) accepts an attestation report only if its RSA signature verifies.
- [rsarecover](https://etherscan.io/address/0x21fd9803336f9800241122ee1e6bd1849f537549#code) checks RSA signatures through the modexp precompile.

## Reviewer notes

### Mechanism

LCPClientBase.updateClient hashes the proxy message and calls verifySignatures. With no operators set, one signature must recover via verifyECDSASignature (lines 650-655, ECDSA.recover at line 654) to a key that ensureActiveKey (lines 619-628) finds registered and unexpired. With operators set, ensureSufficientValidSignatures (lines 630-640) requires a threshold of such signatures. verifyMembership checks packet commitments against the consensus states these signatures accept. Enclave keys are registered after AVRValidator.verifyReport (line 96) checks the Intel IAS report's RSA signature via verifySignature/RSAVerify.rsarecover (line 115). The signing cert is chained to the root CA with RSA (lines 127, 145), and the RSA math runs through ModexpPrecompile.modexp (precompile 5). Recovering a secp256k1 enclave key lets an attacker sign false states. Recovering Intel's RSA key lets an attacker register a fresh enclave key. Per kev, handler 0xb82d91d1 routes port redeem to VsgBridgeAppV2, which releases tokens on recvPacket. The client has no proxy or owner, so a fix needs a new deployment.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The client itself holds no funds.
- Ruled out: No upgrade path in the client: no proxy, no owner.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
