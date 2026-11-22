---
id: withdrawglobalgroth16verifier-f0ddf241-snark-verifiers
format: 2
title: zERC20 teleport verifier trusts Groth16 proofs quantum attackers can forge
status: confirmed
severity: MEDIUM
justification: Forged BN254 proofs mint redeemable zERC20; MEDIUM because INTMAX's owner can repoint the consumer
  to a new verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf0ddf24143bf71b1f2221a58b4979ada1f07c874'
  name: WithdrawGlobalGroth16Verifier
  project: intmax
  code: verified
  code_url: https://etherscan.io/address/0xf0ddf24143bf71b1f2221a58b4979ada1f07c874#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 8
impact: funds-loss
action: Deploy a hash-based teleport verifier and have the zERC20 owner Safe repoint both Verifier proxies via setVerifiers.
evidence_level: source
checks:
- id: c1
  source: '0xf0ddf24143bf71b1f2221a58b4979ada1f07c874'
  file: src/verifiers/WithdrawGlobalGroth16Verifier.sol
  line: 68
  has: function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[3] calldata
    _pubSignals) public view returns (bool) {
  says: verifyProof takes a Groth16 proof and three public signals
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xf0ddf24143bf71b1f2221a58b4979ada1f07c874'
  file: src/verifiers/WithdrawGlobalGroth16Verifier.sol
  line: 85
  has: success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)
  says: uses BN254 ecMul precompile
  for:
  - what
- id: c3
  source: '0xf0ddf24143bf71b1f2221a58b4979ada1f07c874'
  file: src/verifiers/WithdrawGlobalGroth16Verifier.sol
  line: 95
  has: success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)
  says: uses BN254 ecAdd precompile
  for:
  - what
- id: c4
  source: '0xf0ddf24143bf71b1f2221a58b4979ada1f07c874'
  file: src/verifiers/WithdrawGlobalGroth16Verifier.sol
  line: 159
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: result comes from BN254 pairing precompile
  for:
  - action
  - evidence-2
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
  who: review (Review01)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews: []
related: []
---

## What happens

This contract checks snarkJS Groth16 proofs on BN254 for three public signals, used by zERC20 global teleport withdrawals. Its answer rests on a BN254 pairing check, so a quantum attacker who recovers the setup trapdoor can make a false withdrawal proof pass and mint zERC20.

## Evidence

- [verifyProof](https://etherscan.io/address/0xf0ddf24143bf71b1f2221a58b4979ada1f07c874#code) takes proof points A, B, C and three public signals.
- [checkPairing](https://etherscan.io/address/0xf0ddf24143bf71b1f2221a58b4979ada1f07c874#code) returns the result of the BN254 pairing precompile at address 8.

## Reviewer notes

### Mechanism

zERC20 Verifier.singleTeleport(isGlobal=true, ...) -> _verifySingleProof calls singleWithdrawGlobalVerifier.verifyProof(pA, pB, pC, pubSignals) on this contract. verifyProof (line 68) range-checks the signals, computes vk_x = IC0 + sum(IC_i * signal_i) with ecMul/ecAdd precompiles 7 and 6 (lines 85, 95), then runs a 4-pair BN254 pairing via precompile 8 (line 159) and returns its result. The signals are transfer root, recipient and cumulative value; _teleport checks the root is stored and mints the increase as zERC20, redeemable for USDC/ETH at the LiquidityManagers. With the Groth16 toxic waste (recoverable by discrete log on BN254 by a quantum attacker), any value against an existing root verifies. The contract has no owner and no proxy; the fix is the consumer's setVerifiers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Contract holds no funds itself
- Ruled out: Not upgradeable; no admin on this contract

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
