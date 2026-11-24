---
id: fuel-59bd11f8-fixed-gas-recovery
format: 2
title: Fuel rollup's signature fraud proofs stop working once EIP-8151 is live
status: candidate
severity: CRITICAL
justification: Signature fraud proofs fail from activation day and the code cannot change, so bad blocks would stand.
category: breaks-at-activation
pattern: PQ-14
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  name: Fuel
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
action: Exit and retire this rollup before EIP-8151 activates; its code cannot be changed.
evidence_level: bytecode
checks:
- id: fixed-gas
  bytecode: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  has: 600160206080608084856001610bb8f1151510156118d55760208152602081fd
  says: the call to address 1 with 128 bytes in and 32 out gets a constant 3,000 gas (PUSH2 0bb8), and the code
    reverts when the call fails
  for:
  - evidence-1
  - justification
  - what
- id: witness-proof
  selector: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: proveInvalidWitness(bytes,bytes)
  says: the code answers selector 0x67df9aa7, proveInvalidWitness(bytes,bytes) in the published Fuel source
  for:
  - what
- id: sum-proof
  selector: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: proveInvalidSum(bytes,bytes)
  says: the code answers selector 0x84e9520c, proveInvalidSum(bytes,bytes) in the published Fuel source
  for:
  - what
- id: sum-site
  bytecode: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  has: 615bc98c6121ac565b611891565b14610bf756
  says: a caller of the recovery routine at 0x1891 compares the recovered address with a value from the input proof
    and requires them to be equal
  for:
  - notes
- id: no-proxy
  storage: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty, so the address is not a proxy
  for:
  - action
  - evidence-2
  - justification
- id: no-admin
  storage: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  slot: '0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103'
  is: 0
  says: the EIP-1967 admin slot is empty
  for:
  - action
  - evidence-2
  - justification
- id: no-upgrade
  selector: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - action
  - evidence-2
  - justification
- id: tip
  call: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: blockTip()(uint256)
  is: 3
  says: the rollup's block tip is 3 at the pinned block
  for:
  - evidence-3
  - what
- id: no-block-4
  call: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: blockCommitment(uint256)(bytes32)
  args:
  - 4
  is: '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: no block 4 is committed at the pinned block
  for:
  - evidence-3
  - what
- id: name
  call: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: name()(string)
  is: Fuel
  says: the contract's own name() returns Fuel
  for:
  - name
  - what
- id: version
  call: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: version()(string)
  is: 1.0.0
  says: the contract's own version() returns 1.0.0
  for:
  - notes
- id: open
  call: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  data: '0xb4cb0fbc00000000000000000000000000000000000000000000000000000000000000aa00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000401111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
  from: '0x000000000000000000000000000000000000dEaD'
  is: 0x
  says: 'commitRoot(bytes32,uint256,uint256,bytes) from a plain account succeeds at the pinned block: the contract
    still takes transaction roots'
  for:
  - evidence-3
- id: operator
  call: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: operator()(address)
  is: '0xb02b12bf1f2337d2e45554aec474e4e25bdf8c76'
  says: operator() returns this address
  for:
  - notes
- id: operator-code
  code: '0xb02b12bf1f2337d2e45554aec474e4e25bdf8c76'
  is: contract
  says: the operator address has code
  for:
  - notes
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  is: 3000000000000000
  says: the address holds 0.003 ETH
  for:
  - notes
- id: dai
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: balanceOf(address)(uint256)
  args:
  - '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  is: 20000000000000000000
  says: the address holds 20 DAI
  for:
  - notes
- id: usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  is: 20000000
  says: the address holds 20 USDC
  for:
  - notes
- id: tip-before
  call: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: blockTip()(uint256)
  is: 2
  at: 11566104
  says: the block tip is 2 at Ethereum block 11,566,104
  for:
  - evidence-3
- id: tip-then
  call: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: blockTip()(uint256)
  is: 3
  at: 11566105
  says: the block tip is 3 from Ethereum block 11,566,105
  for:
  - evidence-3
- id: then-time
  call: '0xeefba1e63905ef1d7acba5a8513c70307c1ce441'
  fn: getCurrentBlockTimestamp()(uint256)
  is: 1609473024
  at: 11566105
  says: 'the time of Ethereum block 11,566,105 is 1,609,473,024: 1 January 2021'
  for:
  - evidence-3
- id: commit-tx
  tx: '0x1e99ab8b965c4ce0018d466c335cd4cc135d87815fcb08675eea40468c003857'
  to: '0xb02b12bf1f2337d2e45554aec474e4e25bdf8c76'
  ok: true
  says: the transaction of Ethereum block 11,566,105 that committed rollup block 3, sent to the operator contract
  for:
  - evidence-3
- id: commit-log
  logs: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  topic: '0x2521e5f2f7ee2cc8938e535746c063cc841d508a3036af3032bea136cad013a9'
  from: 11566105
  to: 11566105
  count: 1
  says: the rollup emitted one block-committed event in Ethereum block 11,566,105
  for:
  - evidence-3
- id: born-before
  code: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  is: empty
  at: 11559669
  says: the address has no code at Ethereum block 11,559,669
  for:
  - notes
- id: born
  code: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  is: contract
  at: 11559670
  says: the code is at the address from Ethereum block 11,559,670
  for:
  - notes
- id: deposits
  logs: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  topic: '0x5dee5732ff6c20f2db5d2eb497dbb3cfc9bf1126f758a758efc772793b1639bf'
  from: 11559670
  to: 11566105
  count: 5
  says: five DepositMade(address,uint32,uint256) events between deployment and rollup block 3
  for:
  - notes
- id: deposits-one
  logs: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  topic: '0x5dee5732ff6c20f2db5d2eb497dbb3cfc9bf1126f758a758efc772793b1639bf'
  topics:
  - '0x000000000000000000000000d2a8dd8f9f4371b636bfe8dd036772957a5d425c'
  from: 11559670
  to: 11566105
  count: 5
  says: all five name the owner 0xd2a8dd8f9f4371b636bfe8dd036772957a5d425c
  for:
  - notes
- id: bond
  call: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: BOND_SIZE()(uint256)
  is: '500000000000000000'
  says: a block's bond is 0.5 ETH
  for:
  - notes
- id: eth-then
  call: '0xeefba1e63905ef1d7acba5a8513c70307c1ce441'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  is: '1503000000000000000'
  at: 11566105
  says: 'at Ethereum block 11,566,105 the address held 1.503 ETH: three bonds and the 0.003 ETH deposited'
  for:
  - notes
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

This Fuel rollup recovers transaction signers in its fraud proofs with a fixed 3,000 gas and reverts when that call fails. Once EIP-8151 raises the cost, those proofs revert, so a block that spends funds with the wrong key's signature can no longer be challenged. Its chain stands at block 3.

## Evidence

- The [deployed code](https://etherscan.io/address/0x59bd11f8a5a833f26723d044cbb501a40c9c5e43#code) calls the signature check at address 1 with a constant 3,000 gas and reverts if the call fails.
- The [contract](https://etherscan.io/address/0x59bd11f8a5a833f26723d044cbb501a40c9c5e43#code) has no upgrade function and its proxy slots are empty.
- Its block tip has been 3 since [1 January 2021](https://etherscan.io/tx/0x1e99ab8b965c4ce0018d466c335cd4cc135d87815fcb08675eea40468c003857); a plain account can still submit a transaction root.

## Reviewer notes

### Mechanism

Unverified code; the published Fuel v1 source (FuelLabs/fuel-v1-contracts, commit b22cc103) is a lead only, matched by all 35 selectors. The routine at 0x1891 stores the transaction id, v, r, s at memory 0-127 and runs CALL(3000, 0x01, 0, 0, 128, 128, 32) at 0x18c4, reverting if the call fails, else returning mload(128). Its four callers are 0x29db in proveInvalidWitness's recoverWitness, and 0x5bca, 0x5bee, 0x5c18 in proveInvalidSum, each requiring the recovered address equal the input's owner before sums are compared. Tracing jump targets from every selector, only proveInvalidWitness(bytes,bytes) and proveInvalidSum(bytes,bytes) reach it; deposit, commitRoot, commitBlock, withdraw, bondWithdraw and the other provers never call address 1. Under EIP-8151 a successful recovery costs 3,200 or 6,100 gas, so the call runs out of gas and both proofs revert for every signature that recovers an address. State at block: blockTip() 3, operator() a contract, no proxy or upgrade path.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an update path: the EIP-1967 implementation and admin slots are empty, no upgradeTo selector, and the disassembly has no DELEGATECALL, CALLCODE or SELFDESTRUCT; 3,000 is a code literal, not a setting.
- Ruled out: a handled failure: the routine reverts when the call to address 1 fails; it does not continue with an empty or stale address.
- Ruled out: another entry point that recovers a signer: only proveInvalidWitness and proveInvalidSum reach the routine; withdraw and the other provers never call address 1.
- Ruled out: a contract closed for good: commitRoot from a plain account still succeeds at the block.
- Ruled out: implementation code used only by proxies: the dossier lists no copy, proxy or dependent; this address has its own tip, tokens and balances.
- Ruled out: the decompiled file: it shows only the dispatcher, so nothing here rests on it.
- Ruled out: a replay or simulation: none exists for this address; the effect is read from the bytecode, not executed.
- Ruled out: who runs it: operator() is a contract; who controls it was not read, so the card names no team.
- Ruled out: idle since (reader): the tip is 2 at Ethereum block 11,566,104 and 3 from block 11,566,105 (1 January 2021) on; the code is there from block 11,559,670, a day earlier.
- Ruled out: the money (reader): five deposit events, all by 0xd2a8dd8f9f4371b636bfe8dd036772957a5d425c, before block 3: three of 0.001 ETH, 20 DAI and 20 USDC, equal to the holdings; the three 0.5 ETH bonds have left.

### Questions

- Whose money: the one depositor 0xd2a8dd8f9f4371b636bfe8dd036772957a5d425c may be a user or the team's own test account; `whose` stays empty.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-24: reviewed again and rewritten from checks that were re-run.
