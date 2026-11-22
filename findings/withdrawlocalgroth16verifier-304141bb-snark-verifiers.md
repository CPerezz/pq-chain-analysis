---
id: withdrawlocalgroth16verifier-304141bb-snark-verifiers
format: 2
title: INTMAX zERC20 local withdraw verifier accepts quantum-forgeable Groth16 proofs
status: confirmed
severity: MEDIUM
justification: BN254 Groth16 setup trapdoor lets forged withdrawals mint zERC20; the owner Safe can repoint to a
  post-quantum verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x304141bb56d9a6b24d7b6dc5c571c3069dfa1c8f'
  name: WithdrawLocalGroth16Verifier
  project: intmax
  code: verified
  code_url: https://etherscan.io/address/0x304141bb56d9a6b24d7b6dc5c571c3069dfa1c8f#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Build a hash-based teleport verifier and have the zERC20 owner Safe repoint singleWithdrawLocalVerifier
  via setVerifiers.
evidence_level: source
checks:
- id: c1
  source: '0x304141bb56d9a6b24d7b6dc5c571c3069dfa1c8f'
  file: src/verifiers/WithdrawLocalGroth16Verifier.sol
  line: 68
  has: function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[3] calldata
    _pubSignals) public view returns (bool) {
  says: verifyProof takes Groth16 proof points and three public signals.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c4
  source: '0x304141bb56d9a6b24d7b6dc5c571c3069dfa1c8f'
  file: src/verifiers/WithdrawLocalGroth16Verifier.sol
  line: 159
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: Validity is decided by the BN254 pairing precompile (address 8).
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

This contract checks Groth16 withdrawal proofs over BN254 with three public signals for zERC20's local teleport path. It accepts a proof when the pairing check passes, so a quantum attacker who recovers the setup trapdoor can prove any withdrawal value.

## Evidence

- [verifyProof](https://etherscan.io/address/0x304141bb56d9a6b24d7b6dc5c571c3069dfa1c8f#code) takes proof points A, B, C and three public signals.
- [checkPairing](https://etherscan.io/address/0x304141bb56d9a6b24d7b6dc5c571c3069dfa1c8f#code) decides validity with the BN254 pairing precompile at address 8.

## Reviewer notes

### Mechanism

verifyProof (line 68) range-checks the public signals, then checkPairing builds vk_x from IC0..IC3 using ecMul (precompile 7, line 85) and ecAdd (precompile 6, line 95), and runs the four-pair Groth16 equation e(-A,B)e(alpha,beta)e(vk_x,gamma)e(C,delta)=1 through precompile 8 (line 159). Soundness rests on the BN254 discrete log and the secret setup trapdoor; a quantum attacker who derives the trapdoor from the verification key can produce a passing proof for any public signals (transfer root, recipient, cumulative value). Per kev, zERC20 Verifier proxies call this contract from _verifySingleProof when singleTeleport is called with isGlobal=false, and _teleport mints zERC20 redeemable at the LiquidityManagers. The contract has no owner or upgrade path; the fix is the consumer repointing via setVerifiers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: The contract holds no funds and has no owner or proxy.
- Ruled out: No use of this local verifier was identified in the study window.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
