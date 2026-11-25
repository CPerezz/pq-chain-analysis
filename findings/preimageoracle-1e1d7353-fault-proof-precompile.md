---
id: preimageoracle-1e1d7353-fault-proof-precompile
format: 2
title: OP Stack fault proofs can rule wrongly once a signer has real code on L1
status: reproduced
severity: HIGH
justification: Anyone can win a permissionless dispute with L1's answer; the fix needs a new proof program before the fork.
category: voided-by-migration
pattern: PQ-22
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: "0x1e1d73536a081ef2f355d29794547a9770aeb1e0"
  name: "PreimageOracle"
  project: optimism
  label:
  code: verified
  code_url: https://etherscan.io/address/0x1e1d73536a081ef2f355d29794547a9770aeb1e0#code
  proxy_of:
  copies: 1
  family:
  upgradeable: "no"
  admin:
value:
  usd: 679541567
  whose: users
  basis: escrow
activity:
  txs_90d: 0
  last:
impact: funds-loss
action: Stop answering ecrecover from L1's precompile in the fault-proof program and ship a new prestate before EIP-8151.
evidence_level: executed
checks:
- id: loader
  selector: "0x1e1d73536a081ef2f355d29794547a9770aeb1e0"
  fn: loadPrecompilePreimagePart(uint256,address,uint64,bytes)
  says: "the contract has the function that loads a precompile's answer for a caller-chosen precompile"
  for: [what, evidence-1]
- id: staticcall
  source: "0x1e1d73536a081ef2f355d29794547a9770aeb1e0"
  file: src/cannon/PreimageOracle.sol
  lines: [441, 448]
  has: "_precompile,"
  says: "the static call goes to the precompile address taken from the call, and its status and output are kept"
  for: [what, evidence-1]
- id: game-vm
  call: "0x2fa2fdf61f80467010d7345a9781d3498aa0466b"
  fn: vm()(address)
  is: "0xacc005dcd857b401e4732e6f7837135a22825cfa"
  says: "a game of Ink created before the block runs this VM"
  for: [evidence-3, notes]
- id: vm-oracle
  call: "0xacc005dcd857b401e4732e6f7837135a22825cfa"
  fn: oracle()(address)
  is: "0x1e1d73536a081ef2f355d29794547a9770aeb1e0"
  says: "that VM reads preimages from this contract"
  for: [what, evidence-3]
- id: in-use
  logs: "0x10d7b35078d3baabb96dd45a9143b94be65b12cd"
  topic: "0x5b565efe82411da98814f356d0e7bcb8f0219b8d970307c5afb4a6903a8b2e35"
  from: 25790999
  to: 26438999
  min: 1
  says: "the factory of Ink created dispute games in the 90 days to the block"
  for: [justification, notes]
- id: permissionless
  call: "0x2fa2fdf61f80467010d7345a9781d3498aa0466b"
  fn: proposer()(address)
  reverts: true
  says: "Ink's game has no proposer role: anyone can play it"
  for: [justification]
- id: permissionless-unichain
  call: "0xf9204353e40f98536c20150bfd265e59ea89eb53"
  fn: proposer()(address)
  reverts: true
  says: "Unichain's game has no proposer role: anyone can play it"
  for: [justification]
- id: vm-unichain
  call: "0xf9204353e40f98536c20150bfd265e59ea89eb53"
  fn: vm()(address)
  is: "0xacc005dcd857b401e4732e6f7837135a22825cfa"
  says: "Unichain's game runs a VM that reads preimages from this contract"
  for: [what, notes]
- id: permissionless-op-mainnet
  call: "0xb3f3f763189c06e82f5c1ca36423f9fa0172d7ce"
  fn: proposer()(address)
  reverts: true
  says: "OP Mainnet's game has no proposer role: anyone can play it"
  for: [justification]
- id: vm-op-mainnet
  call: "0xb3f3f763189c06e82f5c1ca36423f9fa0172d7ce"
  fn: vm()(address)
  is: "0xacc005dcd857b401e4732e6f7837135a22825cfa"
  says: "OP Mainnet's game runs a VM that reads preimages from this contract"
  for: [what, notes]
- id: executed
  ref: "https://github.com/CPerezz/pq-chain-analysis/blob/86507b9d77f948595a7f41dca46bd53fe22a9f45/studies/eip-8151-impact/results/area-s/s1-check-at-block.txt"
  says: "one valid recovery loaded at the block: 33 bytes kept today and under EIP-8151, 1 byte (empty answer) with code at the signer"
  for: [what, evidence-2, justification, action]
repro:
  code: https://github.com/CPerezz/pq-chain-analysis/blob/86507b9d77f948595a7f41dca46bd53fe22a9f45/studies/eip-8151-impact/results/area-s/scripts/s1_check.py
  command: "ETH_RPC_URL=<archive node> uv run --with coincurve --with pycryptodome python s1_check.py 26438999 0x1e1d73536a081ef2f355d29794547a9770aeb1e0"
  inputs:
    block: 26438999
  expect: "stored length 33 today and under EIP-8151 with no code at the signer; stored length 1 with code at the signer"
sources:
- study: eip-8151-impact
  who: "Claude (area S of the study: static flag, manufactured calls, dispute game factories; executed with code at the signer)"
  date: 2026-11-25
  by: ai-assisted
  verdict: reported
reviews:
- who: OracleRefuter, refuter (a fresh agent that tried to break the card)
  date: 2026-11-25
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "mechanism confirmed in kona (the client trusts the oracle's ecrecover answer); permissionless type-9 games; value now backed by the committed values file"
- who: Claude, reader who settled the card
  date: 2026-11-25
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: "the refuter found value figures not backed by a committed file and one chain wrongly marked not found; both fixed, checks re-run"
related: []
---

## What happens

Fault proofs for 24 OP Stack chains, OP Mainnet, Ink, Unichain among them get each recovered signer from this contract, which asks L1's precompile. Under EIP-8151 that answer is empty once the address has code on L1, so a dispute can be decided against the honest result.

## Evidence

- Lines 441-448 of the [verified source](https://sourcify.dev/server/repo-ui/1/0x1e1d73536a081ef2f355d29794547a9770aeb1e0) call the precompile the caller names and keep its answer; the key holds no account state.
- Loaded at the block with code at the signer, it keeps an empty answer instead of the address ([record](https://github.com/CPerezz/pq-chain-analysis/blob/86507b9d77f948595a7f41dca46bd53fe22a9f45/studies/eip-8151-impact/results/area-s/s1-check-at-block.txt)).
- Ink's dispute games reach it through their VM's `oracle()` ([game](https://etherscan.io/address/0x2fa2fdf61f80467010d7345a9781d3498aa0466b)).

## Reviewer notes

### Mechanism

`loadPrecompilePreimagePart` hashes the precompile address, the required gas and the input into a type-6 key, static-calls the precompile named in the call with all remaining gas, and stores the status byte and the output as the preimage. The fault-proof program asks for `ecrecover` this way; the on-chain step then reads the stored answer. The key holds no L1 account state, so after EIP-8151 the stored answer for a recovery of an address with real code on L1 is empty, while the L2 execution, which never saw that code, got the address.

### Checks

- Block 26,438,999: every factory that created games in the 90 days to the block, its respected game, the game's `vm()` and the VM's `oracle()` ([consumers](https://github.com/CPerezz/pq-chain-analysis/blob/86507b9d77f948595a7f41dca46bd53fe22a9f45/studies/eip-8151-impact/results/area-s/consumers-at-block.json)). This contract serves 24 chains: Ink (permissionless, 119 games in 90 days, $41,665,072); Unichain (permissionless, 1313 games in 90 days, $35,156,386); OP Mainnet (permissionless, 1311 games in 90 days, $565,297,877); and 21 chains with permissioned games, listed in the consumers file.
- Value is what a false root could release: each chain's portal, ETH lockbox and standard bridge at the block, ETH and the priced tokens ([values](https://github.com/CPerezz/pq-chain-analysis/blob/378844f93c1b600646b45229266bfa063eb3a0e2/studies/eip-8151-impact/results/area-s/escrow.json); addresses from the chain's SystemConfig where it answers, else from the Superchain registry or L2BEAT); nothing held for 2 of them.
- Executed with `eth_simulateV1` at the block and the study's behaviour wrapper at `0x01` ([script](https://github.com/CPerezz/pq-chain-analysis/blob/86507b9d77f948595a7f41dca46bd53fe22a9f45/studies/eip-8151-impact/results/area-s/scripts/s1_check.py)). The contract has never received a transaction, so no preimage was ever loaded on mainnet.

### History

- 2026-11-25: reported and executed (study eip-8151-impact, area S: static flag, manufactured calls, dispute game factories).
- 2026-11-25: reviewed by a refuter agent; value evidence committed and two value notes corrected; settled as reproduced.
