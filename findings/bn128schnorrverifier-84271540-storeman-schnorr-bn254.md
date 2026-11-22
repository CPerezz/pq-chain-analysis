---
id: bn128schnorrverifier-84271540-storeman-schnorr-bn254
format: 2
title: Wanchain verifier trusts a BN254 group key a quantum attacker can break
status: confirmed
severity: MEDIUM
justification: Group key is BN254 discrete log; Wanchain must register a post-quantum verifier via governance, so
  MEDIUM.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x84271540f80e8879826c377ebc496dfae270321a'
  name: Bn128SchnorrVerifier
  project: wanchain
  code: verified
  code_url: https://etherscan.io/address/0x84271540f80e8879826c377ebc496dfae270321a#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 660
impact: funds-loss
action: Deploy a post-quantum threshold verifier and register it in SignatureVerifier through GroupApprove.
evidence_level: source
checks:
- id: c1
  source: '0x84271540f80e8879826c377ebc496dfae270321a'
  file: Bn128SchnorrVerifier.sol
  line: 108
  has: if iszero(staticcall(gas, 0x06, input, 0x80, outValue, 0x40)) {
  says: ecadd calls the BN254 add precompile 0x06
  for:
  - evidence-3
- id: c2
  source: '0x84271540f80e8879826c377ebc496dfae270321a'
  file: Bn128SchnorrVerifier.sol
  line: 129
  has: if iszero(staticcall(gas, 0x07, input, 0x60, outValue, 0x40)) {
  says: ecmul calls the BN254 mul precompile 0x07
  for:
  - evidence-2
- id: v-fn
  source: '0x84271540f80e8879826c377ebc496dfae270321a'
  file: Bn128SchnorrVerifier.sol
  has: function verify(bytes32 signature, bytes32 groupKeyX, bytes32 groupKeyY
  line: 178
  says: verify takes a signature and the group public key
  for:
  - action
  - what
- id: v-eq
  source: '0x84271540f80e8879826c377ebc496dfae270321a'
  file: Bn128SchnorrVerifier.sol
  has: flag = state._left.x == state._right.x && state._left.y == state._right.y;
  line: 203
  says: accepts when s·G equals R + h·groupKey
  for:
  - evidence-1
  - justification
  - what
- id: v-sg
  source: '0x84271540f80e8879826c377ebc496dfae270321a'
  file: Bn128SchnorrVerifier.sol
  has: (state._left.x, state._left.y) = sg(state.signature);
  line: 198
  says: computes s·G on BN254
  for:
  - justification
  - what
- id: v-cm
  source: '0x84271540f80e8879826c377ebc496dfae270321a'
  file: Bn128SchnorrVerifier.sol
  has: cmul(state.groupKey.x, state.groupKey.y, state._hash)
  line: 200
  says: multiplies the group public key by the hash
  for:
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review14 (call path, SignatureVerifier and GroupApprove source, escrow)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract checks Wanchain storeman group Schnorr signatures on BN254 against the group public key. A quantum attacker who derives the group secret from the public key can produce signatures this check accepts.

## Evidence

- [verify](https://etherscan.io/address/0x84271540f80e8879826c377ebc496dfae270321a#code) accepts when s·G equals R plus hash times the group key.
- [ecmul](https://etherscan.io/address/0x84271540f80e8879826c377ebc496dfae270321a#code) uses the BN254 scalar-multiplication precompile.
- [ecadd](https://etherscan.io/address/0x84271540f80e8879826c377ebc496dfae270321a#code) uses the BN254 point-addition precompile.

## Reviewer notes

### Mechanism

verify (line 178) builds the hash h(message, R.x, R.y) with sha256 reduced mod the BN254 order (lines 193-196), computes s·G via sg/ecmul (line 198, precompile 0x07 at line 129), hash·groupKey via cmul (line 200), adds R via cadd/ecadd (line 201, precompile 0x06 at line 108), and returns true when both points match (line 203). Security rests on the discrete log of the group key; a CRQC recovers the group secret and signs any message. Per kev, CrossProxy calls this through SignatureVerifier for smgRelease.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract is not upgradeable; fix is repointing SignatureVerifier

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
