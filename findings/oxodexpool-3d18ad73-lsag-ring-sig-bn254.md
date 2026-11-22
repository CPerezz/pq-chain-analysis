---
id: oxodexpool-3d18ad73-lsag-ring-sig-bn254
format: 2
title: 0xODex pool accepts BN254 ring signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Withdrawals rest on BN254 discrete-log keys; MEDIUM because the admin can upgrade the pool to a post-quantum
  scheme.
category: quantum-exposure
pattern: PQ-11
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3d18ad735f949febd59bbfcb5864ee0157607616'
  name: OxODexPool
  project: 0xodex
  code: verified
  code_url: https://etherscan.io/address/0x987efaf33812745da619372c4af7a4fbaf787fc6#code
  proxy_of: '0x987efaf33812745da619372c4af7a4fbaf787fc6'
  copies: 1
  upgradeable: 'yes'
  admin: '0x8eb3e786b3a6abb5206856285b9b5c46b0bf90a6'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 6
impact: funds-loss
action: Upgrade the pool to a post-quantum withdrawal authorisation, such as hash-based nullifiers with a STARK
  membership proof.
evidence_level: source
checks:
- id: c1
  source: '0x987efaf33812745da619372c4af7a4fbaf787fc6'
  file: contracts/lib/AltBn128.sol
  line: 34
  has: if iszero(staticcall(not(0), 0x06, i, 0x80, retP, 0x40)) {
  says: ecAdd calls the BN254 addition precompile 0x06
  for:
  - evidence-3
- id: c2
  source: '0x987efaf33812745da619372c4af7a4fbaf787fc6'
  file: contracts/lib/AltBn128.sol
  line: 49
  has: if iszero(staticcall(not(0), 0x07, i, 0x60, retP, 0x40)) {
  says: ecMul calls the BN254 scalar multiplication precompile 0x07
  for:
  - evidence-3
  - justification
  - what
- id: lsag-call
  source: '0x987efaf33812745da619372c4af7a4fbaf787fc6'
  file: contracts/OxODexPool.sol
  has: bool signatureVerified = LSAG.verify(
  line: 279
  says: withdraw authorises via LSAG ring signature verification
  for:
  - action
  - evidence-1
  - justification
  - what
- id: lsag-msg
  source: '0x987efaf33812745da619372c4af7a4fbaf787fc6'
  file: contracts/OxODexPool.sol
  has: abi.encodePacked(ring.ringHash, recipient, withdrawalData.token)
  line: 280
  says: the signed message binds ring, recipient and token
  for:
  - evidence-1
  - what
- id: lsag-verify
  source: '0x987efaf33812745da619372c4af7a4fbaf787fc6'
  file: contracts/lib/LSAG.sol
  has: function verify(
  line: 98
  says: LSAG ring signature verifier
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
  who: Review06 (Claude), 2026-11-17 review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

OxODexPool is an ETH mixer that releases a deposit when an LSAG ring signature over the depositors' BN254 public keys verifies. A quantum attacker can derive a depositor's key from its public point and sign a withdrawal of an unclaimed deposit to their own address.

## Evidence

- [withdraw](https://etherscan.io/address/0x987efaf33812745da619372c4af7a4fbaf787fc6#code) authorises a withdrawal through LSAG.verify over the ring hash, recipient and token.
- [LSAG verify](https://etherscan.io/address/0x987efaf33812745da619372c4af7a4fbaf787fc6#code) checks the ring signature with BN254 curve operations.
- [ecMul](https://etherscan.io/address/0x987efaf33812745da619372c4af7a4fbaf787fc6#code) and ecAdd call the BN254 precompiles 0x07 and 0x06.

## Reviewer notes

### Mechanism

deposit(_amount, uint256[4] _publicKey) stores BN254 G1 public keys per ring. withdraw(recipient, withdrawalData, relayerGasCharge) calls LSAG.verify(abi.encodePacked(ring.ringHash, recipient, withdrawalData.token), c0, keyImage, s, publicKeys) at OxODexPool.sol lines 279-284; LSAG.verify (LSAG.sol line 98, Liu-Wei-Wong LSAG) uses AltBn128.ecAdd (precompile 0x06, line 34), ecMul (0x07, line 49) and powmod (0x05). Knowing the scalar of either ring public key lets one sign; a CRQC recovers it from the stored point, so any ring not yet withdrawn can be withdrawn to the attacker. The key image only prevents a second withdrawal from the same ring.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not a SNARK; no trusted setup is involved.
- Ruled out: The 148-contract proxy family shares only generic proxy bytecode and is not affected.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
