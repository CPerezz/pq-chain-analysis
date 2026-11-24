---
id: contract-59bd11f8-fixed-gas-recovery
format: 2
title: Fuel v1 rollup can no longer challenge forged signatures under EIP-8151
status: candidate
severity: CRITICAL
justification: Signature challenges revert after activation, so a forged spend becomes final, and the code cannot
  change.
category: breaks-at-activation
pattern: PQ-14
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  project: fuel-labs
  code: bytecode
  code_url: https://etherscan.io/address/0x59bd11f8a5a833f26723d044cbb501a40c9c5e43#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 45
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Have the remaining deposits withdrawn and retire this rollup before EIP-8151 activates; its code cannot
  change.
evidence_level: bytecode
checks:
- id: fixed-gas
  bytecode: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  has: 6001610bb8f1151510156118d55760208152602081fd
  says: the call to the recovery precompile gets a constant 3,000 gas and the code reverts when it fails
  for:
  - evidence-1
  - justification
  - what
- id: prover-sel
  selector: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: proveInvalidWitness(bytes,bytes)
  says: the deployed code has the invalid-witness challenge
  for:
  - what
- id: no-proxy
  storage: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty, so the address is not a proxy
  for:
  - action
  - justification
- id: no-upgrade
  selector: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - action
  - justification
- id: tip
  call: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: blockTip()(uint256)
  is: 3
  says: only three rollup blocks were ever committed
  for:
  - what
- id: deposit
  call: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: depositAt(address,uint32,uint32)(uint256)
  args:
  - '0xd2a8dd8f9f4371b636bfe8dd036772957a5d425c'
  - 1
  - 11562584
  is: '20000000000000000000'
  says: an account deposited 20 DAI (token id 1) that the contract records
  for:
  - action
- id: recover-src
  ref: https://github.com/FuelLabs/fuel-v1-contracts/blob/49c35e8de752200175174a08b6a8eae42796790d/src/Witness.yulp#L86-L95
  says: the published recovery helper calls 0x01 with 3,000 gas and requires success
  for:
  - evidence-2
  - what
- id: prover-src
  ref: https://github.com/FuelLabs/fuel-v1-contracts/blob/49c35e8de752200175174a08b6a8eae42796790d/src/provers/InvalidWitness.yulp#L9-L99
  says: the invalid-witness challenge recovers each Signature witness and records fraud when it does not match the
    owner
  for:
  - justification
  - what
- id: dispatch-src
  ref: https://github.com/FuelLabs/fuel-v1-contracts/blob/49c35e8de752200175174a08b6a8eae42796790d/src/Fuel.yulp#L70-L427
  says: the contract's functions at the deployment commit include no upgrade, admin or selfdestruct path
  for:
  - action
  - justification
- id: deploy
  ref: https://github.com/FuelLabs/fuel-v1-contracts/blob/49c35e8de752200175174a08b6a8eae42796790d/src/deployments/Fuel.json
  says: Fuel's repository lists this address as its v1 mainnet deployment
  for:
  - evidence-3
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews: []
related: []
---

## What happens

Fuel's first rollup, now dormant at three blocks, lets anyone challenge a spend made without the owner's signature. Its signature check gets a fixed 3,000 gas and reverts on failure. Under EIP-8151 recovery costs more, so challenges revert and a forged spend of a deposit becomes final.

## Evidence

- The [deployed code](https://etherscan.io/address/0x59bd11f8a5a833f26723d044cbb501a40c9c5e43#code) calls the recovery with a constant 3,000 gas and reverts when the call fails.
- Fuel's [source at deployment](https://github.com/FuelLabs/fuel-v1-contracts/blob/49c35e8de752200175174a08b6a8eae42796790d/src/Witness.yulp#L86-L95) gives the recovery 3,000 gas and requires it to succeed.
- Fuel's [deployment list](https://github.com/FuelLabs/fuel-v1-contracts/blob/49c35e8de752200175174a08b6a8eae42796790d/src/deployments/Fuel.json) names this address as its v1 mainnet contract.

## Reviewer notes

### Mechanism

The recovery routine (pc 0x1891) stores hash, v, r, s at 0x00-0x80 and CALLs 0x01 with a constant 0x0bb8 gas, output at 0x80; if the call fails it REVERTs (pc 0x18c4-0x18d4). This matches Witness.yulp lines 86-95 at the deployment-day commit 49c35e8 (call(3000,1,...), require(gt(result,0), error"ecrecover")). The four call sites (0x29db, 0x5bca, 0x5bee, 0x5c18) correspond to recoverFromWitness (Transaction.yulp 333-337), used by proveInvalidWitness for every input type, and verifyWitness (verifiers/Witness.yulp), used by proveInvalidSum. Under EIP-8151 a recovery that returns an address costs 3,200 or 6,100 gas, so both challenges revert for any Signature witness that recovers an address. Deposit, commitRoot, commitBlock, withdraw and bondWithdraw do not call the routine, so a block spending a deposit with a forged signature passes the finalization delay (93,046 blocks) and its outputs can be withdrawn. The operator and parameters are constructor constants read from code; there is no proxy slot, no upgrade function and no admin.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an update path: the EIP-1967 slot is empty, upgradeTo is absent, and the dispatcher at the deployment commit has no upgrade, admin or selfdestruct function.
- Ruled out: a handled failure: the call's success flag is checked and the routine reverts, so no other address is read.
- Ruled out: Caller and Producer witnesses do not use the recovery and keep working; only Signature witnesses are affected.
- Ruled out: a signature that recovers no address may still cost 3,000 gas under EIP-8151; whoever forges a spend picks one that recovers an address.
- Ruled out: the other Fuel deployment 0x6880f6fd (later code that drops the call's result) is a separate finding.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-24: reviewed again and rewritten from checks that were re-run.
