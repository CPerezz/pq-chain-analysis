---
id: daimop256verifier-78337799-dcap-p256-collateral
format: 2
title: Jovay's old P-256 verifier checks Intel collateral a quantum attacker forges
status: confirmed
severity: LOW
justification: Intel collateral is signed with P-256; Jovay's owner can require ZK proofs too; low value at stake.
category: quantum-exposure
pattern: PQ-9
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x783377992fca09009ead952d4fba6519e25726b4'
  name: DaimoP256Verifier
  project: jovay
  code: verified
  code_url: https://etherscan.io/address/0x783377992fca09009ead952d4fba6519e25726b4#code
  copies: 1
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Call Rollup setMode(1) so a ZK proof is also required to finalize batches, not P-256-signed TEE attestations
  alone.
evidence_level: source
checks:
- id: fallback-verify
  source: '0x783377992fca09009ead952d4fba6519e25726b4'
  file: script/utils/DaimoP256Verifier.sol
  has: 'uint256 ret = ecdsa_verify(hash, r, s, [x, y]) ? 1 : 0;'
  line: 37
  says: The fallback returns the result of ECDSA verification against the caller-supplied key.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: return-check
  source: '0x783377992fca09009ead952d4fba6519e25726b4'
  file: script/utils/DaimoP256Verifier.sol
  has: return r_x % n == r;
  line: 83
  says: A signature is accepted when the recomputed x coordinate equals r.
  for:
  - evidence-2
  - what
- id: curve-n
  source: '0x783377992fca09009ead952d4fba6519e25726b4'
  file: script/utils/DaimoP256Verifier.sol
  has: uint256 constant n = 0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551;
  line: 54
  says: The curve order constant is that of P-256.
  for:
  - evidence-2
  - justification
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode), filed under daimo-p256-verifier
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review22)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract verifies P-256 (secp256r1) ECDSA signatures behind a precompile-style fallback. It returns 1 when the signature matches the given public key. Anyone who recovers the signing private key with a quantum computer can produce signatures that pass.

## Evidence

- [fallback](https://etherscan.io/address/0x783377992fca09009ead952d4fba6519e25726b4#code) takes hash, r, s and public key and returns the ecdsa_verify result.
- [ecdsa_verify](https://etherscan.io/address/0x783377992fca09009ead952d4fba6519e25726b4#code) accepts when the recomputed x coordinate equals r on the P-256 curve.

## Reviewer notes

### Mechanism

fallback (line 26) rejects input that is not 160 bytes. Otherwise it decodes hash, r, s, x and y (lines 31-35) and calls ecdsa_verify (line 37). ecdsa_verify checks r and s against the curve order n (line 69) and checks that the key lies on the curve (line 73). It then computes uG+vQ with ecZZ_mulmuladd and accepts when r_x % n == r (line 83). Per kev's finding, this is the immutable P256_VERIFIER of Jovay's first PCCS DAOs. Those DAOs use it to check Intel-signed TCB, enclave identity and CRL collateral in their upsert functions. Those checks only hold while P-256 is unbroken. The Rollup has since moved to a new router that uses the 0x100 precompile.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds itself.
- Ruled out: It is no longer on the Rollup's live verification path, according to kev's finding.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
