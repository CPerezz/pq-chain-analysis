---
id: p256verifier-00000000-p256-verifier
format: 2
title: Solady passkey verifier accepts signatures a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: P-256 keys fall to a quantum attacker; wallet owners fix it by adding a post-quantum signer and removing
  the passkey.
category: quantum-exposure
pattern: PQ-9
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x000000000000d01ea45f9efd5c54f037fa57ea1a'
  name: P256Verifier
  project: solady
  code: verified
  code_url: https://etherscan.io/address/0x000000000000d01ea45f9efd5c54f037fa57ea1a#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Add a post-quantum signer to each wallet that verifies passkeys here and remove the P-256 passkey signer.
evidence_level: source
checks:
- id: fn-fallback
  source: '0x000000000000d01ea45f9efd5c54f037fa57ea1a'
  file: src/P256Verifier.sol
  has: fallback() external payable {
  line: 20
  says: Verification runs in the fallback function.
  for:
  - action
  - justification
  - what
- id: doc-returns
  source: '0x000000000000d01ea45f9efd5c54f037fa57ea1a'
  file: src/P256Verifier.sol
  has: Returns `uint256(1)` on verification success.
  line: 8
  says: Returns 1 on a valid signature.
  for:
  - what
- id: load-key
  source: '0x000000000000d01ea45f9efd5c54f037fa57ea1a'
  file: src/P256Verifier.sol
  has: let Qx := calldataload(0x60)
  line: 124
  says: Public key is read from caller's calldata.
  for:
  - evidence-1
  - what
- id: on-curve
  source: '0x000000000000d01ea45f9efd5c54f037fa57ea1a'
  file: src/P256Verifier.sol
  has: eq(mulmod(Qy, Qy, p), addmod(mulmod(addmod(mulmod(Qx, Qx, p), mload(returndatasize()), p), Qx, p), B, p))
  line: 134
  says: Key must lie on the P-256 curve.
  for:
  - evidence-1
- id: final-check
  source: '0x000000000000d01ea45f9efd5c54f037fa57ea1a'
  file: src/P256Verifier.sol
  has: eq(mod(mulmod(x, mulmod(mload(returndatasize()), mload(returndatasize()), p), p), n), r)
  line: 283
  says: Accepts when computed x mod N equals r (ECDSA check).
  for:
  - evidence-2
  - what
- id: curve-n
  source: '0x000000000000d01ea45f9efd5c54f037fa57ea1a'
  file: src/P256Verifier.sol
  has: uint256 private constant N = 0xFFFFFFFF00000000FFFFFFFFFFFFFFFFBCE6FAADA7179E84F3B9CAC2FC632551;
  line: 17
  says: Curve order of P-256, an elliptic-curve scheme.
  for:
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
  rating: LOW
reviews: []
related: []
---

## What happens

This immutable verifier checks a P-256 ECDSA signature against a public key the calling wallet supplies and returns 1 if it is valid. A quantum attacker who recovers a passkey's private key from its public key makes signatures this verifier accepts for that wallet.

## Evidence

- [fallback](https://etherscan.io/address/0x000000000000d01ea45f9efd5c54f037fa57ea1a#code) reads the public key Qx, Qy from calldata and checks it lies on the P-256 curve.
- [The verifier](https://etherscan.io/address/0x000000000000d01ea45f9efd5c54f037fa57ea1a#code) returns 1 when the computed point's x coordinate mod N equals r.

## Reviewer notes

### Mechanism

fallback() (line 20) takes calldata (hash, r, s, Qx, Qy). Lines 105-125 load r, s (normalized to low-s at line 111), Qx and Qy. Lines 127-143 return 0 for malformed input or off-curve keys (line 134). Lines 148-269 compute u1*G + u2*Q with a Shamir ladder. Lines 280-287 return 1 if x(R)/z^2 mod N equals r. The contract has no state or owner. The calling wallet supplies the passkey public key and decides what a valid result authorizes. Security rests on the P-256 discrete log, which Shor's algorithm breaks, so a recovered private key yields signatures this verifier accepts.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier holds no funds and has no admin or upgrade path.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
