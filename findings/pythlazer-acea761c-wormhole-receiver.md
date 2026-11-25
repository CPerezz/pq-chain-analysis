---
id: pythlazer-acea761c-wormhole-receiver
format: 2
title: PythLazer trusts prices signed by an ECDSA key a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Forged Lazer prices reach every reader; MEDIUM because the owner can upgrade PythLazer to a post-quantum
  verifier.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xacea761c27a909d4d3895128ebe6370fde2df481'
  name: PythLazer
  project: pyth
  code: verified
  code_url: https://etherscan.io/address/0xa089a10d05ce37f4b99dc4f1824ba253434a779e#code
  proxy_of: '0xa089a10d05ce37f4b99dc4f1824ba253434a779e'
  copies: 1
  upgradeable: 'yes'
  admin: '0xccd7e24e71ba746cbc758c39cbab11f4e0dfc46f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 123073
impact: funds-loss
action: Upgrade PythLazer to verify a post-quantum signature instead of ECDSA.tryRecover; rotating the trusted signer
  does not help.
evidence_level: source
checks:
- id: c1
  source: '0xa089a10d05ce37f4b99dc4f1824ba253434a779e'
  file: src/PythLazer.sol
  line: 151
  has: (signer, , ) = ECDSA.tryRecover(
  says: verifyUpdate recovers the signer with ECDSA.tryRecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xa089a10d05ce37f4b99dc4f1824ba253434a779e'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: tryRecover uses the ecrecover precompile
  for:
  - evidence-1
  - what
- id: valid-signer
  source: '0xa089a10d05ce37f4b99dc4f1824ba253434a779e'
  file: src/PythLazer.sol
  has: if (!isValidSigner(signer)) {
  line: 160
  says: verifyUpdate rejects signers that are not trusted
  for:
  - evidence-2
  - what
- id: is-valid
  source: '0xa089a10d05ce37f4b99dc4f1824ba253434a779e'
  file: src/PythLazer.sol
  has: return block.timestamp < trustedSignerToExpiresAtMapping[signer];
  line: 94
  says: a signer is valid only before its stored expiry
  for:
  - evidence-2
- id: auth-upgrade
  source: '0xa089a10d05ce37f4b99dc4f1824ba253434a779e'
  file: src/PythLazer.sol
  has: function _authorizeUpgrade(address) internal override onlyOwner {}
  line: 39
  says: the owner can upgrade the implementation
  for:
  - action
  - evidence-3
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode), for 0x74f09cb3
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review17 (PythLazer source, bytecode selectors, on-chain reads, Blockscout internal calls)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

PythLazer verifies Pyth Lazer price updates by recovering an ECDSA signer from the payload hash and requiring it to be a trusted, unexpired signer. A quantum attacker who recovers a trusted signer's key can sign false prices that verifyUpdate accepts.

## Evidence

- [verifyUpdate](https://etherscan.io/address/0xa089a10d05ce37f4b99dc4f1824ba253434a779e#code) recovers the signer of keccak256(payload) with ECDSA.tryRecover.
- [verifyUpdate](https://etherscan.io/address/0xa089a10d05ce37f4b99dc4f1824ba253434a779e#code) reverts unless the recovered signer is a trusted signer whose expiry is in the future.
- [_authorizeUpgrade](https://etherscan.io/address/0xa089a10d05ce37f4b99dc4f1824ba253434a779e#code) lets the owner upgrade the contract.

## Reviewer notes

### Mechanism

verifyUpdate (src/PythLazer.sol 130-171) checks the fee, the magic and the length, takes payload = update[71:71+len], hashes it with keccak256 (line 150) and calls ECDSA.tryRecover(hash, v, r, s) at line 151, which uses ecrecover (ECDSA.sol line 148). Line 160 requires isValidSigner(signer), i.e. block.timestamp < trustedSignerToExpiresAtMapping[signer] (line 94). Signers are set by updateTrustedSigner (onlyOwner), so the owner can rotate keys, but every key is still ECDSA. A forged signature from a trusted key returns an attacker-chosen payload to consumers. _authorizeUpgrade (line 39) is onlyOwner, so the owner (the Pyth executor, itself gated by a guardian-quorum VAA) can replace the scheme.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Signer rotation via updateTrustedSigner keeps the ECDSA scheme and does not fix the issue.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
