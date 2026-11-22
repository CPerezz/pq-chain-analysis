---
id: bridgev3-9291c558-validator-bls-bn254
format: 2
title: EYWA BridgeV3 trusts BN254 BLS committee signatures a quantum attacker can forge
status: confirmed
severity: MEDIUM
justification: BLS on BN254 falls to a quantum computer; the EYWA admin must point the Receiver at a new post-quantum
  bridge.
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9291c5586217348542720c5fb1028c9c976c7b50'
  name: BridgeV3
  project: eywa
  code: verified
  code_url: https://etherscan.io/address/0x9291c5586217348542720c5fb1028c9c976c7b50#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Revoke BridgeV3's RECEIVER_ROLE on the Receiver or replace it with a post-quantum bridge.
evidence_level: source
checks:
- id: c1
  source: '0x9291c5586217348542720c5fb1028c9c976c7b50'
  file: project/contracts/utils/Bls.sol
  line: 143
  has: return pairing(e1points, e2points);
  says: verifyMultisig returns the pairing check result
  for:
  - evidence-2
  - justification
  - what
- id: c3
  source: '0x9291c5586217348542720c5fb1028c9c976c7b50'
  file: project/contracts/utils/Bls.sol
  line: 211
  has: success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
  says: pairing calls the BN254 pairing precompile 0x08
  for:
  - evidence-2
  - justification
  - what
- id: v3-verify
  source: '0x9291c5586217348542720c5fb1028c9c976c7b50'
  file: project/contracts/bridge/BridgeV3.sol
  has: verifyEpoch(currentEpoch, params[i]);
  line: 197
  says: receiveV3 verifies the block signature against the current epoch
  for:
  - evidence-1
  - what
- id: v3-receiver
  source: '0x9291c5586217348542720c5fb1028c9c976c7b50'
  file: project/contracts/bridge/BridgeV3.sol
  has: IReceiver(receiver).receiveData(sender, uint64(chainIdFrom), payload_, requestId);
  line: 226
  says: verified payload is forwarded to the Receiver
  for:
  - action
  - evidence-3
  - justification
  - what
- id: v3-role
  source: '0x9291c5586217348542720c5fb1028c9c976c7b50'
  file: project/contracts/bridge/BridgeV3.sol
  has: onlyRole(VALIDATOR_ROLE)
  line: 187
  says: receiveV3 is gated by the VALIDATOR_ROLE relayer
  for:
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review16 (verified source of BridgeV2, BridgeV3, Receiver, UnifiedRouterV2, PortalV2; on-chain reads at block
    26,431,537)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

BridgeV3 accepts cross-chain messages when an aggregate BN254 BLS signature from the epoch committee verifies against the stored epoch key. A quantum attacker who recovers the committee keys and the relayer key forges a block and has BridgeV3 pass its payload to the Receiver.

## Evidence

- [receiveV3](https://etherscan.io/address/0x9291c5586217348542720c5fb1028c9c976c7b50#code) verifies the block against the current or previous epoch before decoding the request.
- [verifyMultisig](https://etherscan.io/address/0x9291c5586217348542720c5fb1028c9c976c7b50#code) ends in a BN254 pairing check through precompile 0x08.
- [receiveV3](https://etherscan.io/address/0x9291c5586217348542720c5fb1028c9c976c7b50#code) forwards the decoded payload to the Receiver's receiveData.

## Reviewer notes

### Mechanism

receiveV3 (BridgeV3.sol l.187, onlyRole(VALIDATOR_ROLE)) picks currentEpoch or previousEpoch by Block.epochHash(blockHeader) (l.192-203) and calls verifyEpoch (l.278) -> Block.verify -> Bls.verifyMultisig (Bls.sol l.113-144), which builds three G1/G2 pairs and calls the BN254 pairing precompile 0x08 (l.211). It then Merkle-proves the request into the header's tx root (l.206), decodes (requestId, data, to, chainIdTo), and calls IReceiver(receiver).receiveHash or receiveData (l.223, l.226). Receiver confirmations from BridgeV3 alone meet the threshold of 1, so execute reaches the Diamond router, PortalV2.unlock and SynthesisV2 minting. updateEpoch (l.85) rotates keys under the current epoch's BLS signature; the scheme itself is fixed.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: BridgeV3 itself holds no funds; the exposure is PortalV2's escrow

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
