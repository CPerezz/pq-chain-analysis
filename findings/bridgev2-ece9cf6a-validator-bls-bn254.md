---
id: bridgev2-ece9cf6a-validator-bls-bn254
format: 2
title: EYWA bridge accepts BLS committee signatures a quantum attacker could forge
status: confirmed
severity: MEDIUM
justification: BLS on BN254 falls to a quantum attacker; the scheme is fixed in code, so a new bridge is the fix.
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xece9cf6a8f2768a3b8b65060925b646afeaa5167'
  name: BridgeV2
  project: eywa
  code: verified
  code_url: https://etherscan.io/address/0xece9cf6a8f2768a3b8b65060925b646afeaa5167#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Revoke this bridge's VALIDATOR_ROLE and move cross-chain messaging to a post-quantum verified bridge.
evidence_level: source
checks:
- id: c1
  source: '0xece9cf6a8f2768a3b8b65060925b646afeaa5167'
  file: contracts/utils/Bls.sol
  line: 143
  has: return pairing(e1points, e2points);
  says: verifyMultisig returns the pairing result
  for:
  - evidence-2
  - justification
  - what
- id: c3
  source: '0xece9cf6a8f2768a3b8b65060925b646afeaa5167'
  file: contracts/utils/Bls.sol
  line: 211
  has: success := staticcall(sub(gas(), 2000), 8, add(input, 0x20), mul(inputSize, 0x20), out, 0x20)
  says: pairing uses the BN254 precompile 0x08
  for:
  - evidence-2
  - justification
  - what
- id: rv-sig
  source: '0xece9cf6a8f2768a3b8b65060925b646afeaa5167'
  file: contracts/bridge/BridgeV2.sol
  has: function receiveV2(ReceiveParams[] calldata params) external override onlyRole(VALIDATOR_ROLE)
  line: 150
  says: the line or bytes the card cites
  for:
  - justification
  - what
- id: rv-verify
  source: '0xece9cf6a8f2768a3b8b65060925b646afeaa5167'
  file: contracts/bridge/BridgeV2.sol
  has: verifyEpoch(currentEpoch, params[i]);
  line: 159
  says: the line or bytes the card cites
  for:
  - evidence-1
  - what
- id: rv-call
  source: '0xece9cf6a8f2768a3b8b65060925b646afeaa5167'
  file: contracts/bridge/BridgeV2.sol
  has: 'to.functionCall(data, "Bridge: receive failed");'
  line: 190
  says: the line or bytes the card cites
  for:
  - evidence-3
  - what
- id: rv-role
  source: '0xece9cf6a8f2768a3b8b65060925b646afeaa5167'
  file: contracts/bridge/BridgeV2.sol
  has: bytes32 public constant VALIDATOR_ROLE
  line: 24
  says: the line or bytes the card cites
  for:
  - action
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

The bridge executes cross-chain requests from EYWA-chain blocks once the epoch committee's aggregate BN254 BLS signature verifies. A quantum attacker with the committee keys and the validator key can forge a block whose request calls the target contract.

## Evidence

- [receiveV2](https://etherscan.io/address/0xece9cf6a8f2768a3b8b65060925b646afeaa5167#code) verifies the block header against the current or previous epoch's BLS key.
- [verifyMultisig](https://etherscan.io/address/0xece9cf6a8f2768a3b8b65060925b646afeaa5167#code) ends in a BN254 pairing check through precompile 0x08.
- [receiveV2](https://etherscan.io/address/0xece9cf6a8f2768a3b8b65060925b646afeaa5167#code) then calls the decoded target with the request data.

## Reviewer notes

### Mechanism

receiveV2 (BridgeV2.sol line 150, onlyRole(VALIDATOR_ROLE)) selects the current or previous epoch by Block.epochHash(blockHeader) (lines 154-165) and calls verifyEpoch -> Block.verify -> Bls.verifyMultisig (Bls.sol 113-144), which hashes the message to G1 and runs a three-pair BN254 pairing via precompile 8 (line 211) against the epoch aggregate G2 key. It proves the request into the header's tx root (Merkle.prove, line 168), decodes (requestId, data, to, chainIdTo), and calls to.functionCall(check) and to.functionCall(data) (lines 187-190). Historically `to` was UnifiedRouterV2, which runs PortalV2.unlock or SynthesisV2 minting. updateEpoch (line 83) accepts new epoch keys signed by the current BLS committee, so a forged committee also controls rotation. The scheme is immutable; only keys rotate.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: PortalV2 currently points at a new AddressBook and UnifiedRouterV2 is paused, so this bridge reaches the escrow only if the admin repoints it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
