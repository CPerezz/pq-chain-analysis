---
id: ethstoragecontractm2-f0193d6e-mining-groth16
format: 2
title: EthStorage pays miners on a Groth16 proof a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: Groth16 on BN254 falls to a quantum attacker who recovers the setup trapdoor; EthStorage can fix
  it by a proxy upgrade.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf0193d6e8fc186e77b6e63af4151db07524f6a7a'
  name: EthStorageContractM2
  project: ethstorage
  code: verified
  code_url: https://etherscan.io/address/0x99f5cc6ad111584c88891b4c6fff5784a46adf33#code
  proxy_of: '0x99f5cc6ad111584c88891b4c6fff5784a46adf33'
  copies: 1
  upgradeable: 'yes'
  admin: '0x654dd56444856e928917549263aac6f9d6a96372'
value:
  usd: 314
  basis: held
activity:
  txs_90d: 643
impact: funds-loss
action: Upgrade the implementation to check the decoding proof with a hash-based (STARK/FRI) verifier.
evidence_level: source
checks:
- id: c1
  source: '0x99f5cc6ad111584c88891b4c6fff5784a46adf33'
  file: contracts/EthStorageContractM2.sol
  line: 63
  has: return this.verifyProof(pA, pB, pC, pubSignals);
  says: decodeSamples returns the Groth16 verifyProof result
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c5
  source: '0x99f5cc6ad111584c88891b4c6fff5784a46adf33'
  file: contracts/zk-verify/Decoder2.sol
  line: 173
  has: let success := staticcall(sub(gas(), 2000), 8, _pPairing, 768, _pPairing, 0x20)
  says: the proof is decided by the BN254 pairing precompile
  for:
  - evidence-3
  - justification
  - what
- id: m-call
  source: '0x99f5cc6ad111584c88891b4c6fff5784a46adf33'
  file: contracts/EthStorageContractM2.sol
  has: if (!decodeSamples(_masks, kvIdxs, sampleIdxs, _miner, _decodeProof[0])) {
  line: 123
  says: verifySamples requires the decoding proof to pass
  for:
  - evidence-1
  - what
- id: m-sig
  source: '0x99f5cc6ad111584c88891b4c6fff5784a46adf33'
  file: contracts/zk-verify/Decoder2.sol
  has: uint256[6] calldata _pubSignals
  line: 76
  says: verifier takes six public signals
  for:
  - what
- id: m-key
  source: '0x99f5cc6ad111584c88891b4c6fff5784a46adf33'
  file: contracts/EthStorageContractM2.sol
  has: pubSignals[0] = _getEncodingKey(_kvIdxs[0], _miner);
  line: 55
  says: the miner's encoding key is a public signal
  for:
  - evidence-2
  - what
- id: m-mask
  source: '0x99f5cc6ad111584c88891b4c6fff5784a46adf33'
  file: contracts/EthStorageContractM2.sol
  has: pubSignals[4] = _masks[0];
  line: 59
  says: the masks are public signals
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
  who: Review15 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

The contract pays miners for storing an encoded replica of users' blobs and accepts the masks if a Groth16 proof over BN254 verifies. With the setup trapdoor, a whitelisted miner makes it verify for masks not derived from its key and is paid without its replica.

## Evidence

- [verifySamples](https://etherscan.io/address/0x99f5cc6ad111584c88891b4c6fff5784a46adf33#code) reverts unless decodeSamples accepts the masks for the miner.
- [decodeSamples](https://etherscan.io/address/0x99f5cc6ad111584c88891b4c6fff5784a46adf33#code) puts the miner's encoding key and the masks into the public signals and returns verifyProof's result.
- [checkPairing](https://etherscan.io/address/0x99f5cc6ad111584c88891b4c6fff5784a46adf33#code) decides the proof with the BN254 pairing precompile.

## Reviewer notes

### Mechanism

mine() (requires MINER_ROLE, enforced) -> _mine -> EthStorageContractM2.verifySamples (lines 97-128). For each random sample, _checkSample (line 88) checks checkInclusive(kvInfo.hash, sampleIdx, mask ^ encodedSample, proof), a KZG opening, or a zero check for empty entries. Then decodeSamples (lines 44-64) builds six public signals: _getEncodingKey(kvIdx, miner) for two samples, _getXIn(sampleIdx) for both, and the two masks. It calls this.verifyProof (line 63), the snarkjs Groth16 verifier in Decoder2. That verifier forms vk_x with ecmul and ecadd (lines 94, 104) and checks four pairings via precompile 8 (line 173). A forger who holds the BN254 trapdoor (toxic waste) can produce pA, pB, pC that pass for arbitrary masks. A miner then passes without the replica encoded with its key, and _rewardMiner pays minerReward from the contract balance.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Outside attackers who lack MINER_ROLE are not paid: mine pays the miner argument, which must hold MINER_ROLE.
- Ruled out: The KZG blob-opening dependency on the same path is covered by a separate finding.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
