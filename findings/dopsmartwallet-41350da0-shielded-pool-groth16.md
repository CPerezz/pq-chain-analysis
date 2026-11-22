---
id: dopsmartwallet-41350da0-shielded-pool-groth16
format: 2
title: DOP shielded pool accepts Groth16 proofs a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Groth16 on BN254 falls to a quantum attacker with the setup trapdoor; the admin can fix it by upgrading
  the proxy.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x41350da0c6ca2842b567799e7dac6e24f43aca69'
  name: DOPSmartWallet
  project: dop
  code: verified
  code_url: https://etherscan.io/address/0x18d04735d18495b5336e00cd092c5d17c9e5a0b4#code
  proxy_of: '0x18d04735d18495b5336e00cd092c5d17c9e5a0b4'
  copies: 1
  upgradeable: 'yes'
  admin: '0x005a5956c22c142175b49e7916b7e0ebfe56b34a'
value:
  usd: 7
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace the Groth16 verifier with a hash-based proof system and upgrade the pool, or empty and close it.
evidence_level: source
checks:
- id: c5
  source: '0x18d04735d18495b5336e00cd092c5d17c9e5a0b4'
  file: contracts/logic/Snark.sol
  line: 109
  has: success := staticcall(sub(gas(), 2000), 8, input, _PAIRING_INPUT_WIDTH, out, 0x20)
  says: Pairing check calls the BN254 precompile 0x08.
  for:
  - evidence-1
  - justification
  - what
- id: c6
  source: '0x18d04735d18495b5336e00cd092c5d17c9e5a0b4'
  file: contracts/logic/Snark.sol
  line: 143
  has: return pairing(negate(proof.a), proof.b, vk.alpha1, vk.beta2, vkX, vk.gamma2, proof.c, vk.delta2);
  says: Snark.verify is a Groth16 pairing check.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c8
  source: '0x18d04735d18495b5336e00cd092c5d17c9e5a0b4'
  file: contracts/logic/Verifier.sol
  line: 43
  has: _verificationKeys[nullifiers][commitments] = verifyingKey;
  says: The owner-set verifying key is stored.
  for:
  - evidence-2
  - what
- id: c9
  source: '0x18d04735d18495b5336e00cd092c5d17c9e5a0b4'
  file: contracts/logic/Verifier.sol
  line: 38
  has: function setVerificationKey(
  says: setVerificationKey is defined.
  for:
  - evidence-2
- id: c10
  source: '0x18d04735d18495b5336e00cd092c5d17c9e5a0b4'
  file: '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol'
  line: 74
  has: function transferOwnership(address newOwner) public virtual onlyOwner {
  says: The logic is owner-controlled (Ownable).
  for:
  - justification
- id: dec1
  source: '0x18d04735d18495b5336e00cd092c5d17c9e5a0b4'
  file: contracts/logic/DOPLogic.sol
  has: token.safeTransfer(recipient, base);
  line: 726
  says: Unshield transfers the token from the pool to the recipient.
  for:
  - evidence-3
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review11 (Claude), finding review
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This DOP shielded pool pays tokens out to unshield recipients from its own balance. It trusts a Groth16 proof checked with BN254 pairings against an owner-set verifying key. With the setup trapdoor, a quantum attacker forges spend proofs for notes that do not exist and empties the pool.

## Evidence

- [Snark.verify](https://etherscan.io/address/0x18d04735d18495b5336e00cd092c5d17c9e5a0b4#code) accepts a proof when a BN254 pairing check passes.
- [setVerificationKey](https://etherscan.io/address/0x18d04735d18495b5336e00cd092c5d17c9e5a0b4#code) stores the owner-set Groth16 verifying key.
- [_processDecrypt](https://etherscan.io/address/0x18d04735d18495b5336e00cd092c5d17c9e5a0b4#code) transfers the note's token from the pool to the recipient.

## Reviewer notes

### Mechanism

DOPLogic.validateTransaction rejects a transaction unless Verifier.verify passes; Verifier.verify loads the verifying key set by the owner via setVerificationKey (Verifier.sol lines 38-43) and calls Snark.verify (Snark.sol line 143), which runs the pairing precompile 0x08 (line 109) over BN254. For a valid transaction, unshield notes go to _processDecrypt (DOPLogic.sol line 712), which calls token.safeTransfer(recipient, base) at line 726 from the proxy's own balance. Anyone who knows the trusted-setup trapdoor, which a quantum attacker can recover from the public key, can produce proofs for fabricated notes and drain the pool. The proxy is upgradeable through ProxyAdmin 0x005a5956..., owned by an EOA.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The ECDSA signer check in _validateSignature only lets a depositor approve or reject their own pending deposit; it is not counted as exposure.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
