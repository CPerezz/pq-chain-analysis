---
id: dopsmartwallet-10006349-shielded-pool-groth16
format: 2
title: DOP shielded pool pays out on Groth16 proofs a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: Spends rest on a Groth16 BN254 proof; a quantum attacker could forge one. The admin can fix it by
  upgrading the proxy.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x100063491afd897b58828b3d4fe738ab979e13df'
  name: DOPSmartWallet
  project: dop
  code: verified
  code_url: https://etherscan.io/address/0x591334078a5a67f1136fedbc0bd3bc9c19003517#code
  proxy_of: '0x591334078a5a67f1136fedbc0bd3bc9c19003517'
  copies: 1
  upgradeable: 'yes'
  admin: '0x8593da65d55ccdb9367377231925d0688efb5007'
value:
  usd: 223
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace the Groth16 verifier with a hash-based proof system and upgrade the implementation, or empty and
  close the pool.
evidence_level: source
checks:
- id: c5
  source: '0x591334078a5a67f1136fedbc0bd3bc9c19003517'
  file: contracts/logic/Snark.sol
  line: 109
  has: success := staticcall(sub(gas(), 2000), 8, input, _PAIRING_INPUT_WIDTH, out, 0x20)
  says: pairing calls the BN254 pairing precompile 8
  for:
  - evidence-2
  - justification
  - what
- id: c6
  source: '0x591334078a5a67f1136fedbc0bd3bc9c19003517'
  file: contracts/logic/Snark.sol
  line: 143
  has: return pairing(negate(proof.a), proof.b, vk.alpha1, vk.beta2, vkX, vk.gamma2, proof.c, vk.delta2);
  says: Snark.verify is a Groth16 pairing check against the verifying key
  for:
  - action
  - evidence-1
  - justification
  - what
- id: unshield-transfer
  source: '0x591334078a5a67f1136fedbc0bd3bc9c19003517'
  file: contracts/logic/DOPLogic.sol
  has: token.safeTransfer(recipient, base);
  line: 719
  says: unshield sends the pool's tokens to the note recipient
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

This shielded pool pays tokens out on unshield after a Groth16 proof on BN254 passes the pairing check. A quantum attacker with the setup trapdoor could forge proofs for notes that do not exist and empty the pool.

## Evidence

- [verify](https://etherscan.io/address/0x591334078a5a67f1136fedbc0bd3bc9c19003517#code) accepts a proof when a Groth16 pairing check against the verifying key passes.
- [pairing](https://etherscan.io/address/0x591334078a5a67f1136fedbc0bd3bc9c19003517#code) calls the BN254 pairing precompile at address 8.
- [_processDecrypt](https://etherscan.io/address/0x591334078a5a67f1136fedbc0bd3bc9c19003517#code) transfers the note's token from the pool to the recipient.

## Reviewer notes

### Mechanism

DOPLogic.validateTransaction (line 409) rejects a transaction unless Verifier.verify (line 457) passes. Verifier.verify loads the owner-set verifying key (setVerificationKey, Verifier.sol line 38/43) and calls Snark.verify (line 143). Snark.verify computes vkX with the add and scalarMul precompiles 6/7 (lines 32, 55), then runs a Groth16 pairing check via precompile 8 (line 109). For unshield notes, _processDecrypt transfers the token from the proxy to the recipient (safeTransfer, line 719; ERC721 transferFrom, line 730). The proxy itself holds shielded balances. A forged Groth16 proof therefore releases pool funds. Upgrades go through ProxyAdmin 0x8593da65, which is owned by a 2-of-5 Safe.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The ECDSA signer check in _validateSignature only lets a depositor approve or reject their own pending deposit.
- Ruled out: The verification bypass needs tx.origin to be 0x…dEaD, which no one can sign for.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
