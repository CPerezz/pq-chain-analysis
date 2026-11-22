---
id: contract-f3c2d0d8-zkbtc-plonk
format: 2
title: zkBTC redeem verifier accepts PLONK proofs a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: Setup trapdoor forges redeem proofs; Lightec's TEMPORARY_ROLE holder can repoint the bridge to a
  hash-based verifier.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf3c2d0d821ec7343160adeddd5559b745bb12be2'
  project: lightec
  code: decompiled
  code_url: code/0x00eb0c4822b6879e39a947a6b19c644b07bc70e02cacee06c778d14eabc0ea35.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a BtcTxVerifier with hash-based proofs and have the TEMPORARY_ROLE holder call updateBtcTxVerifier
  on zkBTCBridge.
evidence_level: bytecode
checks:
- id: b4
  bytecode: '0xf3c2d0d821ec7343160adeddd5559b745bb12be2'
  has: 60055afa
  says: the code calls the modexp precompile
  for:
  - evidence-2
  - what
- id: code
  code: '0xf3c2d0d821ec7343160adeddd5559b745bb12be2'
  is: contract
  bytes: 7045
  says: the address holds 7045 bytes of contract code
  for:
  - what
- id: sel
  selector: '0xf3c2d0d821ec7343160adeddd5559b745bb12be2'
  fn: Verify(bytes,uint256[])
  says: the gnark PLONK Verify(bytes,uint256[]) selector is present
  for:
  - action
  - evidence-1
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
  who: Review10 (bytecode, consumer source and on-chain review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This contract checks the gnark PLONK proofs that Lightec's zkBTC bridge uses to confirm a redemption was broadcast on Bitcoin. With the recovered setup trapdoor, a quantum attacker forges a proof that this verifier accepts, marking redemptions done that never happened.

## Evidence

- [The code](https://etherscan.io/address/0xf3c2d0d821ec7343160adeddd5559b745bb12be2#code) exposes the gnark PLONK export's Verify(bytes,uint256[]) entry point.
- [The verifier](https://etherscan.io/address/0xf3c2d0d821ec7343160adeddd5559b745bb12be2#code) calls the modexp precompile during proof checking.

## Reviewer notes

### Mechanism

zkBTCBridge.updateRedeem(params, txid, minerReward, proofData) calls BtcTxVerifier.verifyRedeemTx, which calls redeemVerifier.Verify(proofData, publicWitness) on this contract (selector 0x7e4f7a8a, gnark PLONK over BN254). The bytecode checks proof size and public input count, hashes the transcript with the SHA-256 precompile and calls modexp. Per kev, the code also uses ecadd, ecmul and ecpairing. The code holds no proxy or admin functions. BtcTxVerifier.updateRedeemVerifier needs DEFAULT_ADMIN_ROLE, which has no member. zkBTCBridge.updateBtcTxVerifier, gated by TEMPORARY_ROLE (an EOA), can replace the whole BtcTxVerifier. A trapdoor-derived proof passes Verify and lets the bridge update the change UTXO for a redemption that was never broadcast.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable: no proxy or admin functions in the bytecode.
- Ruled out: The precompile at 0x02 is SHA-256 (transcript hashing), not BLS12-381.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
