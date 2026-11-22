---
id: p256verifier-c2b78104-p256-verifier
format: 2
title: Daimo P256Verifier lets quantum-recovered passkeys sign for smart wallets
status: confirmed
severity: MEDIUM
justification: Wallets trust its P-256 check; a quantum key recovery forges passkey signatures. Owners must add
  post-quantum signers.
category: quantum-exposure
pattern: PQ-9
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xc2b78104907f722dabac4c69f826a522b2754de4'
  name: P256Verifier
  project: daimo
  code: verified
  code_url: https://etherscan.io/address/0xc2b78104907f722dabac4c69f826a522b2754de4#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 3947
impact: funds-loss
action: Ship post-quantum validators so wallet owners can add a post-quantum signer and remove the P-256 passkey.
evidence_level: source
checks:
- id: fallback
  source: '0xc2b78104907f722dabac4c69f826a522b2754de4'
  file: src/P256Verifier.sol
  has: fallback(bytes calldata input) external returns (bytes memory) {
  line: 26
  says: Entry point takes raw calldata, no selector.
  for:
  - evidence-1
  - justification
  - what
- id: layout-x
  source: '0xc2b78104907f722dabac4c69f826a522b2754de4'
  file: src/P256Verifier.sol
  has: uint256 x = uint256(bytes32(input[96:128]));
  line: 34
  says: Public key comes from the caller's calldata.
  for:
  - evidence-1
  - what
- id: verify
  source: '0xc2b78104907f722dabac4c69f826a522b2754de4'
  file: src/P256Verifier.sol
  has: 'uint256 ret = ecdsa_verify(hash, r, s, [x, y]) ? 1 : 0;'
  line: 37
  says: The result is a P-256 ECDSA verification.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: ret
  source: '0xc2b78104907f722dabac4c69f826a522b2754de4'
  file: src/P256Verifier.sol
  has: return abi.encodePacked(ret);
  line: 39
  says: Returns the validity flag to the caller.
  for:
  - evidence-2
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review22)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This stateless contract checks a P-256 ECDSA signature against a public key supplied in calldata and returns 1 if it is valid. Passkey wallets rely on that answer, so a quantum attacker who derives the private key from the stored public key can sign for those wallets.

## Evidence

- [fallback](https://etherscan.io/address/0xc2b78104907f722dabac4c69f826a522b2754de4#code) takes hash, r, s and public key x, y as raw calldata.
- [ecdsa_verify](https://etherscan.io/address/0xc2b78104907f722dabac4c69f826a522b2754de4#code) decides the result returned to the calling wallet.

## Reviewer notes

### Mechanism

The fallback(bytes) function (line 26) returns 0 unless the input is 160 bytes long (line 27). It decodes hash, r, s, x and y (lines 31-35), calls ecdsa_verify(hash, r, s, [x, y]) on line 37 and returns 1 or 0 (line 39). It has no state and no owner. Wallet validators, such as ZeroDev WebAuthnValidator inside an EntryPoint v0.7 handleOps call, pass in the passkey public key stored in the wallet and treat a return value of 1 as authorization. P-256 ECDSA is broken by Shor's algorithm. An attacker with a quantum computer who recovers the private key from (x, y) therefore produces signatures that this function accepts. The fix is account migration in each wallet; the verifier cannot be changed.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The verifier itself holds no funds and has no admin.
- Ruled out: Switching to the 0x100 precompile does not change the exposure.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
