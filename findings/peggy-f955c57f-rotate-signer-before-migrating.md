---
id: peggy-f955c57f-rotate-signer-before-migrating
format: 2
title: Injective bridge validators must rotate keys before taking real code
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless validators move their accounts to real code, and the set can rotate their keys
  first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf955c57f9ea9dc8781965feae0b6a2ace2bad6f3'
  name: Peggy
  project: injective
  code: verified
  code_url: https://etherscan.io/address/0x100dcb8b78c608d148cb207ac3875935dfe6abdc#code
  proxy_of: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  copies: 1
  upgradeable: 'yes'
  admin: '0x4b5dec94b961d06e568f98d69dfeabdf2b25d6bb'
value:
  usd: 4452078
  whose: users
  basis: held
activity: {}
impact: liveness
action: Ask each validator to move its signing key to a new address by a valset update before its account takes
  real code.
evidence_level: source
checks:
- id: ecdsa
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1263
  has: return _signer == ecrecover(messageDigest, _v, _r, _s);
  says: each validator signature is recovered with ecrecover and compared with the validator's stored address
  for:
  - evidence-1
  - justification
  - what
- id: skip
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1313
  has: if (_v[i] != 0) {
  says: a validator with v = 0 is skipped, so its power does not count
  for:
  - what
- id: nomatch
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1323
  has: '"Validator signature does not match."'
  says: a submitted signature that does not recover to the validator reverts the call
  for:
  - what
- id: threshold
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1338
  has: cumulativePower > _powerThreshold,
  says: the signing validators' power must exceed the threshold
  for:
  - evidence-1
  - what
- id: threshold-value
  call: '0xf955c57f9ea9dc8781965feae0b6a2ace2bad6f3'
  fn: state_powerThreshold()(uint256)
  is: 2863311530
  says: the power threshold is set
  for:
  - what
- id: batch-sigs
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1492
  has: checkValidatorSignatures(
  says: submitBatch checks the validator signatures
  for:
  - evidence-1
  - what
- id: valset-sigs
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1391
  has: checkValidatorSignatures(
  says: updateValset checks the current validators' signatures
  for:
  - evidence-2
  - what
- id: payout
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1524
  has: IERC20(_tokenContract).safeTransfer(
  says: submitBatch pays tokens out to the batch's destinations
  for:
  - what
  - whose
- id: deposit
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1555
  has: IERC20(_tokenContract).safeTransferFrom(
  says: sendToInjective pulls users' tokens into the bridge
  for:
  - whose
- id: rotate
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  lines:
  - 1349
  - 1358
  has: function updateValset(
  says: updateValset takes a new validator set and the current set's signatures
  for:
  - action
  - evidence-2
  - justification
- id: rotate-store
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1405
  has: state_lastValsetCheckpoint = newCheckpoint;
  says: updateValset stores the new validator set's checkpoint
  for:
  - action
  - evidence-2
  - justification
- id: cosmos
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1433
  has: approved by the current Cosmos validator set
  says: the signers are the Cosmos-side validator set, not the team alone
  for:
  - action
- id: paused
  call: '0xf955c57f9ea9dc8781965feae0b6a2ace2bad6f3'
  fn: paused()(bool)
  is: false
  says: the bridge is not paused
  for:
  - notes
- id: owner
  call: '0xf955c57f9ea9dc8781965feae0b6a2ace2bad6f3'
  fn: owner()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: ownership is renounced, so nobody can pause or unpause
  for:
  - notes
- id: admin
  call: '0x4b5dec94b961d06e568f98d69dfeabdf2b25d6bb'
  fn: getProxyAdmin(address)(address)
  args:
  - '0xf955c57f9ea9dc8781965feae0b6a2ace2bad6f3'
  is: '0x4b5dec94b961d06e568f98d69dfeabdf2b25d6bb'
  says: the ProxyAdmin is the proxy's admin and can upgrade it
  for:
  - evidence-2
  - what
- id: admin-owner
  call: '0x4b5dec94b961d06e568f98d69dfeabdf2b25d6bb'
  fn: owner()(address)
  is: '0x545a65a9d36ecedceeb7162574859a2a50ecf9ed'
  says: the ProxyAdmin's owner
  for:
  - what
- id: admin-owner-code
  code: '0x545a65a9d36ecedceeb7162574859a2a50ecf9ed'
  is: contract
  bytes: 170
  says: the ProxyAdmin's owner is a contract (170 bytes, not identified)
  for:
  - what
- id: signer-1
  code: '0xe7f2370b7aa22b96a75ea126d63fbcca1e1b3ea8'
  is: empty
  says: a recovered validator has no code today
  for:
  - justification
- id: signer-2
  code: '0x600bfcada54f7ac717adb1bee91f60008c220b58'
  is: empty
  says: a recovered validator has no code today
  for:
  - justification
- id: signer-3
  code: '0xc0aa00a9d6b7f8eddd160acf5e8c31c96576b551'
  is: empty
  says: a recovered validator has no code today
  for:
  - justification
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-f955c57f, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: INFORMATIONAL (PQ-17): Injective''s Peggy bridge counts only ECDSA validator signatures for payouts
    and valset changes, so a validator whose account takes real code stops counting (replay 0x532303a4 under signer_code
    reverts, under signer_delegated passes); validators can rotate first through updateValset, and the ProxyAdmin''s
    3-of-5 Safe can upgrade. Its tight-gas valset replay is the sibling PQ-18 row. Refuter agrees; Claude read the
    sheet.'
related: []
---

## What happens

Withdrawals from this bridge and changes to its validator set need ECDSA signatures from validators holding more than a set power threshold. A validator whose account takes real code stops counting; if too much power moves unrotated, both stop until the proxy admin upgrades the code.

## Evidence

- The [verified source](https://etherscan.io/address/0x100dcb8b78c608d148cb207ac3875935dfe6abdc#code) recovers each validator signature with ecrecover and needs their power to exceed the threshold.
- [updateValset](https://etherscan.io/address/0x100dcb8b78c608d148cb207ac3875935dfe6abdc#code) installs a new validator set when the current set signs it; the proxy admin can also upgrade the code.

## Reviewer notes

### Mechanism

Proxy 0xf955 runs Peggy at 0x100d. submitBatch (line 1436) and updateValset (line 1349) both take the current valset, check it against state_lastValsetCheckpoint, and call checkValidatorSignatures (1296-1342): for each validator with v != 0, verifySig (1253-1264) compares the stored validator address with ecrecover of the eth-signed hash, reverting on mismatch; powers are summed and must exceed state_powerThreshold (2,863,311,530 at the block). A relayer can pass v = 0 to skip a validator, so a validator whose account takes real code (ecrecover returns nothing under EIP-8151) just stops counting; once the remaining signers cannot exceed the threshold, batches (token payouts at 1524) and valset updates both fail. updateValset installs a new checkpoint signed by the current set, so a validator can be replaced before it migrates. Peggy's owner is renounced (owner() = 0), so nobody can pause; the contract is not paused. The EIP-1967 admin is ProxyAdmin 0x4b5d, owned by contract 0x545a (170 bytes), which can upgrade the implementation.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 or a code-size branch for validators with code: verifySig is pure and only calls ecrecover (line 1263).
- Ruled out: Unused implementation: this is the proxy in use, with 1,916 recoveries in 93 transactions in the two-week window and 4.45M USD held.
- Ruled out: Key state: the three most frequent recovered signers have no code at the block; the full valset is stored only as a checkpoint hash, so its members cannot be read without logs.
- Ruled out: Pause or closed path: paused() is false and owner() is the zero address, so the path cannot be paused any more.
- Ruled out: Direct path: no function releases tokens without validator signatures; deployERC20 reverts; the only other way is a proxy upgrade.
- Ruled out: Replay 0x532303a4 (run eip8151_signer_code reverts) not cited: the transaction calls wrapper 0xb422b27b... (selector 0x18405256) that embeds submitBatch calldata; without a trace I cannot exclude another check of the same signer in the wrapper.
- Ruled out: Breaks by itself: replay 0x92ce6ef1 (updateValset, kind tight) reverts under EIP-8151 alone at 309,300 gas versus 308,422 today; that is a sender gas-limit issue on this contract, a separate rated finding, not part of this notice.
- Ruled out: Copies: the code family has 2 addresses; the dossier lists no copies in use and only this address holds value.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
