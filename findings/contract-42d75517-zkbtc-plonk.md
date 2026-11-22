---
id: contract-42d75517-zkbtc-plonk
format: 2
title: Lightec zkBTC deposit verifier trusts PLONK proofs a quantum attacker can forge
status: candidate
severity: MEDIUM
justification: BN254 PLONK trapdoor is quantum-recoverable; MEDIUM as Lightec can repoint the bridge to a new verifier
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x42d75517041801406dc5374f849bd766945b4d15'
  project: lightec
  code: decompiled
  code_url: code/0xa1574574f870b287bcad8c9931029f6a5fae1272ae0546bdaca8424ade75ef4e.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Deploy a BtcTxVerifier with hash-based proofs and have the TEMPORARY_ROLE holder call updateBtcTxVerifier
evidence_level: bytecode
checks:
- id: b4
  bytecode: '0x42d75517041801406dc5374f849bd766945b4d15'
  has: 60055afa
  says: the code calls the modexp precompile used in proof verification
  for:
  - evidence-2
  - justification
  - what
- id: sel
  selector: '0x42d75517041801406dc5374f849bd766945b4d15'
  fn: Verify(bytes,uint256[])
  says: the code exposes gnark PLONK Verify(bytes,uint256[])
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

This contract checks the PLONK proof behind each zkBTC bridge deposit through its Verify function. With the BN254 setup trapdoor, a quantum attacker can prove a Bitcoin deposit that never happened and mint unbacked zkBTC.

## Evidence

- [Verify](https://etherscan.io/address/0x42d75517041801406dc5374f849bd766945b4d15#code) is the PLONK proof check entry point of this contract.
- [The code](https://etherscan.io/address/0x42d75517041801406dc5374f849bd766945b4d15#code) calls the modexp precompile while checking a proof.

## Reviewer notes

### Mechanism

zkBTCBridge.deposit decodes the Bitcoin transaction. It then calls BtcTxVerifier.verifyDepositTx, which calls this contract's Verify(bytes,uint256[]) (selector 0x7e4f7a8a) with the proof and the public witness. The decompiled body requires 14 public inputs and a proof of 0x360 bytes, and checks openings against r. It hashes with the SHA-256 precompile, uses modexp (precompile 5) and runs the BN254 pairing checks of gnark PLONK. If the proof passes, the bridge records the UTXO and mints zkBTC. Anyone who holds the setup trapdoor can produce a passing proof for any witness. This contract has no admin functions. The fix is a new BtcTxVerifier, installed through zkBTCBridge.updateBtcTxVerifier, which requires TEMPORARY_ROLE.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not upgradeable; no proxy or admin in this verifier
- Ruled out: Checks b1-b3 label precompile 0x02 (SHA-256) as BLS12-381; not cited

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
