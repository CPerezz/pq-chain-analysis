---
id: rootchainproxy-86e4dc95-sender-gas-limits
format: 2
title: Checkpoints whose gas limit was estimated before EIP-8151 run out of gas
status: confirmed
severity: LOW
justification: Checkpoints estimated before activation and mined after it run out of gas; later estimates carry
  the new cost.
category: breaks-at-activation
pattern: PQ-18
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x86e4dc95c7fbdbf52e33d563bbdb00823894c287'
  name: RootChainProxy
  code: verified
  code_url: https://etherscan.io/address/0x536c55cfe4892e581806e10b38dfe8083551bd03#code
  proxy_of: '0x536c55cfe4892e581806e10b38dfe8083551bd03'
  copies: 1
  upgradeable: 'yes'
  admin: '0xcaf0aa768a3ae1297df20072419db8bb8b5c8cef'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: 'Have validators with a fixed or cached checkpoint gas limit re-estimate it under EIP-8151: two real ones
  used 307,100 more.'
evidence_level: executed
checks:
- id: impl
  call: '0x86e4dc95c7fbdbf52e33d563bbdb00823894c287'
  fn: implementation()(address)
  args: []
  is: '0x536c55cfe4892e581806e10b38dfe8083551bd03'
  says: this address delegates to the RootChain implementation 0x536c55cf…
  for:
  - proxy_of
  - what
- id: upg
  source: '0x86e4dc95c7fbdbf52e33d563bbdb00823894c287'
  file: RootChainProxy.sol
  lines:
  - 413
  - 418
  has: function updateImplementation(address _newProxyTo) public onlyOwner {
  says: the owner can replace the implementation
  for:
  - upgradeable
- id: owner
  call: '0x86e4dc95c7fbdbf52e33d563bbdb00823894c287'
  fn: owner()(address)
  args: []
  is: '0xcaf0aa768a3ae1297df20072419db8bb8b5c8cef'
  says: the owner at the block is 0xcaf0…8cef
  for:
  - upgradeable
- id: submit
  source: '0x536c55cfe4892e581806e10b38dfe8083551bd03'
  file: RootChain.sol
  line: 870
  has: uint256 _reward = stakeManager.checkSignatures(
  says: submitCheckpoint passes the checkpoint's signatures to the staking contract
  for:
  - evidence-1
  - what
- id: rootchain
  call: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  fn: rootChain()(address)
  args: []
  is: '0x86e4dc95c7fbdbf52e33d563bbdb00823894c287'
  says: the staking contract takes checkSignatures from this address
  for:
  - what
- id: smimpl
  call: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  fn: implementation()(address)
  args: []
  is: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  says: the staking proxy runs the StakeManager code at 0x1d9e…f5cc
  for:
  - evidence-1
- id: loop
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/staking/stakeManager/StakeManager.sol
  line: 545
  has: for (uint256 i = 0; i < sigs.length; ++i) {
  says: checkSignatures goes through every signature
  for:
  - what
- id: recover
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/staking/stakeManager/StakeManager.sol
  line: 546
  has: address signer = ECVerify.ecrecovery(voteHash, sigs[i]);
  says: each signature is recovered
  for:
  - evidence-1
  - what
- id: ecr
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/common/lib/ECVerify.sol
  line: 29
  has: address result = ecrecover(hash, v, r, s);
  says: the recovery is a plain ecrecover, with no gas amount set in code
  for:
  - evidence-1
- id: tx1
  tx: '0xb4798037668a032b050e250dbc6af8e95e172daf979ef2cfa7d272945ccd018a'
  to: '0x86e4dc95c7fbdbf52e33d563bbdb00823894c287'
  ok: true
  says: a real checkpoint sent to this address succeeds today
  for:
  - action
  - evidence-2
- id: tx2
  tx: '0x3d1a36a7db0bd23b73c3c977656523a31f69de493c8bd0ed5504b38d0ed23edc'
  to: '0x86e4dc95c7fbdbf52e33d563bbdb00823894c287'
  ok: true
  says: a second real checkpoint sent to this address succeeds today
  for:
  - action
  - evidence-3
- id: r1-8151
  replay: '0xb4798037668a032b050e250dbc6af8e95e172daf979ef2cfa7d272945ccd018a'
  run: eip8151
  ok: false
  says: under EIP-8151 the first checkpoint fails as sent
  for:
  - evidence-2
  - justification
  - what
- id: r1-more
  replay: '0xb4798037668a032b050e250dbc6af8e95e172daf979ef2cfa7d272945ccd018a'
  run: eip8151_more_gas
  ok: false
  says: with 300,000 more gas it still fails
  for:
  - action
  - evidence-2
  - what
- id: r1-1m
  replay: '0xb4798037668a032b050e250dbc6af8e95e172daf979ef2cfa7d272945ccd018a'
  run: eip8151_more_gas_1m
  ok: true
  says: with 1,000,000 more gas it passes, using 2,427,350
  for:
  - action
  - evidence-2
  - justification
  - what
- id: r2-8151
  replay: '0x3d1a36a7db0bd23b73c3c977656523a31f69de493c8bd0ed5504b38d0ed23edc'
  run: eip8151
  ok: false
  says: under EIP-8151 the second checkpoint fails as sent
  for:
  - evidence-3
  - justification
  - what
- id: r2-more
  replay: '0x3d1a36a7db0bd23b73c3c977656523a31f69de493c8bd0ed5504b38d0ed23edc'
  run: eip8151_more_gas
  ok: false
  says: with 300,000 more gas it still fails
  for:
  - action
  - evidence-3
  - what
- id: r2-1m
  replay: '0x3d1a36a7db0bd23b73c3c977656523a31f69de493c8bd0ed5504b38d0ed23edc'
  run: eip8151_more_gas_1m
  ok: true
  says: with 1,000,000 more gas it passes, using 2,427,490
  for:
  - action
  - evidence-3
  - justification
  - what
- id: val1
  call: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  fn: signerToValidator(address)(uint256)
  args:
  - '0x048cfedf907c4c9ddd11ff882380906e78e84bbe'
  is: 143
  says: the first checkpoint's sender is the signer of validator 143
  for:
  - action
- id: val2
  call: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  fn: signerToValidator(address)(uint256)
  args:
  - '0x203847fbc212987f83680e0682e45e930eb11b0e'
  is: 194
  says: the second checkpoint's sender is the signer of validator 194
  for:
  - action
- id: heimdall
  ref: https://github.com/0xPolygon/heimdall-v2/blob/1f88b5c628f5edddcee1499e8d65d958c8d17a42/helper/tx.go#L238-L248
  says: SendCheckpoint sets each checkpoint's gas limit from eth_estimateGas (GenerateAuthObj, lines 91, 185-186)
  for:
  - action
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-86e4dc95, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: 'kept: LOW (PQ-18, liveness): a Polygon checkpoint whose gas limit was estimated before EIP-8151 activates
    and that is mined after runs out of gas at its limit (replays: about 307,100 more gas per checkpoint; +300,000
    still fails, +1M passes); Heimdall v2 estimates gas for every checkpoint (refuter read SendCheckpoint at 1f88b5c),
    so later checkpoints include the new cost. Rewritten to this narrow claim after the first refuter; two refuters
    agree on it. Claude read the sheet.'
related: []
---

## What happens

This contract records a checkpoint once the staking contract recovers its validator signatures one by one. Two real checkpoints run out of gas under EIP-8151 at their limits and with 300,000 more. Validator software estimates each limit, so the failures hit checkpoints estimated before activation.

## Evidence

- [submitCheckpoint](https://etherscan.io/address/0x536c55cfe4892e581806e10b38dfe8083551bd03#code) hands the signatures to the staking contract, which recovers each with ecrecover.
- [A real checkpoint](https://etherscan.io/tx/0xb4798037668a032b050e250dbc6af8e95e172daf979ef2cfa7d272945ccd018a) fails replayed under EIP-8151, also with 300,000 more gas; it passes with 1,000,000 more.
- [A second one](https://etherscan.io/tx/0x3d1a36a7db0bd23b73c3c977656523a31f69de493c8bd0ed5504b38d0ed23edc) behaves the same in replay.

## Reviewer notes

### Mechanism

This address is a proxy (implementation() returns 0x536c55cf…). submitCheckpoint (RootChain.sol 861-879) calls stakeManager.checkSignatures (line 870); the StakeManager proxy 0x5e3e…d908 (implementation 0x1d9e…f5cc) accepts it only from rootChain, which is this address. checkSignatures (StakeManager.sol 524-598) loops over every signature and recovers each with ECVerify.ecrecovery, a plain ecrecover that forwards all gas. Replays (dossier): 0xb479… limit 2,206,777, used 2,120,250 today; under EIP-8151 it fails as sent and at +300,000, and passes at +1,000,000 using 2,427,350 (307,100 more). 0x3d1a… limit 2,219,623, used 2,120,390; same pattern, 2,427,490 (307,100 more). +300,000 is not enough although only ~207,900-220,600 more is used above the limit, because each nested call keeps 1/64 of the gas. Limits are estimated per submission: Heimdall v2 SendCheckpoint (helper/tx.go 238-271, commit 1f88b5c) builds the transaction with GenerateAuthObj, which sets auth.GasLimit from eth_estimateGas (lines 91, 185-186). After activation the estimate includes the new recovery cost, so what fails is a checkpoint estimated before activation and mined after, or a sender that sets its limit by hand. Limits and gas used read with cast tx/receipt through the gateway.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a gas amount fixed in code (would be fixed-gas-recovery): ECVerify line 29 is a plain ecrecover with all gas, and the 1,000,000-more replays pass, so the sender's limit decides.
- Ruled out: the card belonging to the staking contract that recovers: the failing transactions are sent to this address by its senders, who set the gas limit; the staking contract only accepts calls from this address (rootChain() at the block).
- Ruled out: a bundled step that checks the same signer: both transactions call only submitCheckpoint on this address, and their receipts log only from this address.
- Ruled out: a separate notice, not folded here: ECVerify line 32 requires a non-zero recovery, so under EIP-8151 a validator whose signer account takes real code makes every checkpoint it signs revert (an EIP-7702 delegation still recovers); validators can replace their signer with updateSigner (StakeManager.sol 501). That belongs to the staking contract's row.
- Ruled out: checkpoints stopping until senders raise their limit (the earlier claim): Heimdall v2 estimates gas for each submission (helper/tx.go lines 91, 185-186), so only limits estimated before activation, or set by hand, are too low.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
