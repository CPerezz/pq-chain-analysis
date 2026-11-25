---
id: preimageoracle-5b9bef4d-fault-proof-precompile
format: 2
title: Permissioned fault proofs can rule wrongly once a signer has real code on L1
status: reproduced
severity: MEDIUM
justification: Only each chain's permissioned proposer and challenger can play; the fix needs a new proof program first.
category: voided-by-migration
pattern: PQ-22
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: "0x5b9bef4d8c36fb013c70d0a6f455807c6bd5270b"
  name: "PreimageOracle"
  project: hashkey
  label:
  code: verified
  code_url: https://etherscan.io/address/0x5b9bef4d8c36fb013c70d0a6f455807c6bd5270b#code
  proxy_of:
  copies: 1
  family:
  upgradeable: "no"
  admin:
value:
  usd: 1282300
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
  selector: "0x5b9bef4d8c36fb013c70d0a6f455807c6bd5270b"
  fn: loadPrecompilePreimagePart(uint256,address,uint64,bytes)
  says: "the contract has the function that loads a precompile's answer for a caller-chosen precompile"
  for: [what, evidence-1]
- id: staticcall
  source: "0x5b9bef4d8c36fb013c70d0a6f455807c6bd5270b"
  file: src/cannon/PreimageOracle.sol
  lines: [380, 387]
  has: "_precompile,"
  says: "the static call goes to the precompile address taken from the call, and its status and output are kept"
  for: [what, evidence-1]
- id: game-vm
  call: "0x77908cb841e2a35f38f626efdf70ecef932304ac"
  fn: vm()(address)
  is: "0x7447b25b91336127042cc6899b2c15668a1ab8ba"
  says: "a game of HashKey Chain created before the block runs this VM"
  for: [evidence-3, notes]
- id: vm-oracle
  call: "0x7447b25b91336127042cc6899b2c15668a1ab8ba"
  fn: oracle()(address)
  is: "0x5b9bef4d8c36fb013c70d0a6f455807c6bd5270b"
  says: "that VM reads preimages from this contract"
  for: [what, evidence-3]
- id: in-use
  logs: "0x04ec030f362ce5a0b5fe2d4b4219f287c2ebde50"
  topic: "0x5b565efe82411da98814f356d0e7bcb8f0219b8d970307c5afb4a6903a8b2e35"
  from: 25790999
  to: 26438999
  min: 1
  says: "the factory of HashKey Chain created dispute games in the 90 days to the block"
  for: [justification, notes]
- id: permissioned
  call: "0x77908cb841e2a35f38f626efdf70ecef932304ac"
  fn: proposer()(address)
  is: "0xf660e0982b3720bc01692f9d10c647f688fd07ba"
  says: "HashKey Chain's game names a proposer: only permissioned actors play it"
  for: [justification]
- id: executed
  ref: "https://github.com/CPerezz/pq-chain-analysis/blob/86507b9d77f948595a7f41dca46bd53fe22a9f45/studies/eip-8151-impact/results/area-s/s1-check-at-block.txt"
  says: "one valid recovery loaded at the block: 33 bytes kept today and under EIP-8151, 1 byte (empty answer) with code at the signer"
  for: [what, evidence-2, justification, action]
repro:
  code: https://github.com/CPerezz/pq-chain-analysis/blob/86507b9d77f948595a7f41dca46bd53fe22a9f45/studies/eip-8151-impact/results/area-s/scripts/s1_check.py
  command: "ETH_RPC_URL=<archive node> uv run --with coincurve --with pycryptodome python s1_check.py 26438999 0x5b9bef4d8c36fb013c70d0a6f455807c6bd5270b"
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
  rating: MEDIUM
  note: "mechanism confirmed; permissioned games (proposer role answers); value backed by the committed values file"
- who: Claude, reader who settled the card
  date: 2026-11-25
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "the refuter found value figures not backed by a committed file and one chain wrongly marked not found; both fixed, checks re-run"
related: []
---

## What happens

Fault proofs for the OP Stack chain HashKey Chain get each recovered signer from this contract, which asks L1's precompile. Under EIP-8151 that answer is empty once the address has code on L1, so a dispute can be decided against the honest result.

## Evidence

- Lines 380-387 of the [verified source](https://sourcify.dev/server/repo-ui/1/0x5b9bef4d8c36fb013c70d0a6f455807c6bd5270b) call the precompile the caller names and keep its answer; the key holds no account state.
- Loaded at the block with code at the signer, it keeps an empty answer instead of the address ([record](https://github.com/CPerezz/pq-chain-analysis/blob/86507b9d77f948595a7f41dca46bd53fe22a9f45/studies/eip-8151-impact/results/area-s/s1-check-at-block.txt)).
- HashKey Chain's dispute games reach it through their VM's `oracle()` ([game](https://etherscan.io/address/0x77908cb841e2a35f38f626efdf70ecef932304ac)).

## Reviewer notes

### Mechanism

`loadPrecompilePreimagePart` hashes the precompile address, the required gas and the input into a type-6 key, static-calls the precompile named in the call with all remaining gas, and stores the status byte and the output as the preimage. The fault-proof program asks for `ecrecover` this way; the on-chain step then reads the stored answer. The key holds no L1 account state, so after EIP-8151 the stored answer for a recovery of an address with real code on L1 is empty, while the L2 execution, which never saw that code, got the address.

### Checks

- Block 26,438,999: every factory that created games in the 90 days to the block, its respected game, the game's `vm()` and the VM's `oracle()` ([consumers](https://github.com/CPerezz/pq-chain-analysis/blob/86507b9d77f948595a7f41dca46bd53fe22a9f45/studies/eip-8151-impact/results/area-s/consumers-at-block.json)). This contract serves 1 chain: HashKey Chain (permissioned, 1873 games in 90 days, $1,282,300).
- Value is what a false root could release: each chain's portal, ETH lockbox and standard bridge at the block, ETH and the priced tokens ([values](https://github.com/CPerezz/pq-chain-analysis/blob/378844f93c1b600646b45229266bfa063eb3a0e2/studies/eip-8151-impact/results/area-s/escrow.json); addresses from the chain's SystemConfig where it answers, else from the Superchain registry or L2BEAT).
- Executed with `eth_simulateV1` at the block and the study's behaviour wrapper at `0x01` ([script](https://github.com/CPerezz/pq-chain-analysis/blob/86507b9d77f948595a7f41dca46bd53fe22a9f45/studies/eip-8151-impact/results/area-s/scripts/s1_check.py)). The contract has never received a transaction, so no preimage was ever loaded on mainnet.

### History

- 2026-11-25: reported and executed (study eip-8151-impact, area S: static flag, manufactured calls, dispute game factories).
- 2026-11-25: reviewed by a refuter agent; value evidence committed and two value notes corrected; settled as reproduced.
