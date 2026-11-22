---
id: dopsmartwallet-9a3152b6-shielded-pool-groth16
format: 2
title: DOP shielded pool lets a quantum attacker forge Groth16 withdrawal proofs
status: confirmed
severity: MEDIUM
justification: Withdrawals rest on a Groth16 BN254 proof; DOP can fix it by upgrading the pool to a hash-based verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9a3152b61420ed4d5e594c0b48bb932ee41b7376'
  name: DOPSmartWallet
  project: dop
  code: verified
  code_url: https://etherscan.io/address/0xb157dc78c2815280906a6730984a5e0dca65e247#code
  proxy_of: '0xb157dc78c2815280906a6730984a5e0dca65e247'
  copies: 1
  upgradeable: 'yes'
  admin: '0x8593da65d55ccdb9367377231925d0688efb5007'
value:
  usd: 45624
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Replace the Groth16 verifier with a hash-based proof system and upgrade the pool, or empty and close it
  if unused.
evidence_level: source
checks:
- id: c4
  source: '0xb157dc78c2815280906a6730984a5e0dca65e247'
  file: contracts/logic/Snark.sol
  line: 111
  has: success := staticcall(sub(gas(), 2000), 8, input, _PAIRING_INPUT_WIDTH, out, 0x20)
  says: Pairing check calls the BN254 pairing precompile 0x08.
  for:
  - evidence-2
  - justification
  - what
- id: c5
  source: '0xb157dc78c2815280906a6730984a5e0dca65e247'
  file: contracts/logic/Snark.sol
  line: 143
  has: return pairing(negate(proof.a), proof.b, vk.alpha1, vk.beta2, vkX, vk.gamma2, proof.c, vk.delta2);
  says: Snark.verify is a Groth16 pairing equation over the verifying key.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c7
  source: '0xb157dc78c2815280906a6730984a5e0dca65e247'
  file: contracts/logic/Verifier.sol
  line: 32
  has: _verificationKeys[nullifiers][commitments] = verifyingKey;
  says: The owner stores the verifying key per nullifier/commitment count.
  for:
  - action
  - evidence-3
  - what
- id: v81
  source: '0xb157dc78c2815280906a6730984a5e0dca65e247'
  file: contracts/logic/Verifier.sol
  has: bool validity = verifyProof(verifyingKey, transaction.proof, inputs);
  line: 81
  says: Transaction validity comes from the SNARK proof check.
  for:
  - evidence-1
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

This shielded pool accepts a private transaction when a Groth16 proof on BN254 verifies against an owner-set verifying key. A quantum attacker who recovers the setup trapdoor can forge proofs for notes that do not exist and withdraw the pool's tokens.

## Evidence

- [verify](https://etherscan.io/address/0xb157dc78c2815280906a6730984a5e0dca65e247#code) returns the result of the Groth16 proof check for the transaction.
- [Snark.verify](https://etherscan.io/address/0xb157dc78c2815280906a6730984a5e0dca65e247#code) ends in a pairing check through the BN254 pairing precompile.
- [setVerificationKey](https://etherscan.io/address/0xb157dc78c2815280906a6730984a5e0dca65e247#code) lets the owner store the verifying key used for each transaction shape.

## Reviewer notes

### Mechanism

Verifier.verify (Verifier.sol lines 60-89) loads _verificationKeys[nullifierCount][commitmentCount]. It builds public inputs from merkleRoot, the bound-params hash, nullifiers and commitments, then calls verifyProof -> Snark.verify (Snark.sol line 143). That is a Groth16 pairing check through precompile 0x08 (line 111). Per kev's review, DOPLogic.validateTransaction rejects transactions unless Verifier.verify passes, and _processDecrypt transfers unshielded tokens from the proxy, which holds all shielded balances. Knowing the setup trapdoor (recoverable by discrete log on BN254) lets an attacker forge proofs for arbitrary nullifiers and commitments and unshield the pool's tokens. The verifying key is set by the owner (setVerificationKey, line 32). The implementation sits behind a proxy whose ProxyAdmin is owned by a 2-of-5 Safe, so an upgrade is the fix.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: tx.origin bypass uses 0x...dEaD, which no one can sign for
- Ruled out: encrypt-approval ECDSA signer only affects a depositor's own pending deposit

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
