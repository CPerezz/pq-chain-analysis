---
id: peggy-f955c57f-validator-signatures
format: 2
title: Injective bridge funds can be taken by forging its validators' ECDSA keys
status: confirmed
severity: MEDIUM
justification: Forged validator signatures release every locked token; only a proxy upgrade by a Safe can change
  the check.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
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
impact: funds-loss
action: Upgrade the bridge to require post-quantum validator signatures, with an Injective chain upgrade so validators
  produce them.
evidence_level: source
checks:
- id: ecdsa
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1263
  has: return _signer == ecrecover(messageDigest, _v, _r, _s);
  says: each validator signature is checked with ecrecover against the validator's address
  for:
  - evidence-1
  - justification
  - what
- id: quorum
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  lines:
  - 1336
  - 1340
  has: cumulativePower > _powerThreshold,
  says: the signing validators' power must exceed the threshold
  for:
  - evidence-1
  - justification
  - what
- id: threshold
  call: '0xf955c57f9ea9dc8781965feae0b6a2ace2bad6f3'
  fn: state_powerThreshold()(uint256)
  is: 2863311530
  says: the threshold is two thirds of the total power 2^32
  for:
  - evidence-1
  - what
- id: batchhash
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1503
  has: 0x7472616e73616374696f6e426174636800000000000000000000000000000000,
  says: validators sign a hash of the batch's amounts, destinations, token and nonce
  for:
  - what
- id: payout
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  lines:
  - 1523
  - 1527
  has: IERC20(_tokenContract).safeTransfer(
  says: submitBatch transfers the signed amounts of the signed token to the signed destinations
  for:
  - evidence-1
  - justification
  - what
  - whose
- id: rotate
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1405
  has: state_lastValsetCheckpoint = newCheckpoint;
  says: updateValset installs the new validator set signed by the current one
  for:
  - evidence-3
  - what
- id: cosmos
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1433
  has: It is approved by the current Cosmos validator set.
  says: the signers are the Injective (Cosmos) chain's validator set
  for:
  - action
  - what
- id: deposit
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  lines:
  - 1549
  - 1559
  has: IERC20(_tokenContract).safeTransferFrom(
  says: sendToInjective locks users' tokens in the bridge
  for:
  - whose
- id: peggyid
  call: '0xf955c57f9ea9dc8781965feae0b6a2ace2bad6f3'
  fn: state_peggyId()(bytes32)
  is: '0x696e6a6563746976652d70656767796964000000000000000000000000000000'
  says: the bridge's id is the text injective-peggyid
  for:
  - notes
- id: inj
  call: '0xe28b3b32b6c345a34ff64674606124dd5aceca30'
  fn: balanceOf(address)(uint256)
  args:
  - '0xf955c57f9ea9dc8781965feae0b6a2ace2bad6f3'
  is: '94968243174186154547365397'
  says: the bridge holds 94,968,243 INJ
  for:
  - what
- id: upgrade
  source: '0xf955c57f9ea9dc8781965feae0b6a2ace2bad6f3'
  file: TransparentUpgradeableProxy.sol
  lines:
  - 463
  - 465
  has: function upgradeTo(address newImplementation) external virtual ifAdmin {
  says: the proxy's admin can replace the implementation
  for:
  - action
  - evidence-2
  - justification
- id: pa-owner
  call: '0x4b5dec94b961d06e568f98d69dfeabdf2b25d6bb'
  fn: owner()(address)
  is: '0x545a65a9d36ecedceeb7162574859a2a50ecf9ed'
  says: the proxy admin contract is owned by a Safe
  for:
  - action
  - evidence-2
  - justification
- id: safe
  call: '0x545a65a9d36ecedceeb7162574859a2a50ecf9ed'
  fn: getThreshold()(uint256)
  is: 3
  says: the Safe needs 3 owner signatures
  for:
  - evidence-2
  - justification
- id: owner
  call: '0xf955c57f9ea9dc8781965feae0b6a2ace2bad6f3'
  fn: owner()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: Peggy's own owner is zero
  for:
  - evidence-2
- id: pause
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1580
  has: function emergencyPause() external onlyOwner {
  says: only the owner can pause the bridge
  for:
  - evidence-2
- id: sigtx
  tx: '0x1bcf9f63581862ef5df7acbf3a27d55ce96e998475170410704786d29035d8e5'
  to: '0xf955c57f9ea9dc8781965feae0b6a2ace2bad6f3'
  ok: true
  says: a real updateValset carrying validator signatures in its calldata
  for:
  - evidence-3
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

Injective's bridge pays out locked tokens, or installs a new validator set, when validators holding over two thirds of the power sign with ECDSA keys. A quantum attacker who derives enough of those keys can sign a batch that pays out what it holds, including 95 million INJ.

## Evidence

- [checkValidatorSignatures](https://etherscan.io/address/0x100dcb8b78c608d148cb207ac3875935dfe6abdc#code) recovers each signature with ecrecover and needs over two thirds of the power before submitBatch pays out.
- Its [proxy](https://etherscan.io/address/0xf955c57f9ea9dc8781965feae0b6a2ace2bad6f3#code) is upgraded by an admin contract owned by a Safe needing 3 signatures; Peggy's own owner is zero, so nobody can pause it.
- Validators' signatures are public in every [valset update](https://etherscan.io/tx/0x1bcf9f63581862ef5df7acbf3a27d55ce96e998475170410704786d29035d8e5), which exposes their keys.

## Reviewer notes

### Mechanism

submitBatch (lines 1436-1547) checks the supplied valset against state_lastValsetCheckpoint, then checkValidatorSignatures over keccak256(peggyId, "transactionBatch", amounts, destinations, fees, batchNonce, token, timeout) and safeTransfers amounts of any token to any destinations. checkValidatorSignatures (1296-1342) requires verifySig (1253-1264, plain ecrecover on the eth_sign digest) for every non-zero v and sums power until it exceeds state_powerThreshold (2,863,311,530 at the block, two thirds of 2^32). updateValset (1349-1430) uses the same check to install a new checkpoint, so a forged quorum can also take the bridge over for good. Validators sign each valset and batch, so their public keys are recoverable from calldata. Upgrade path: TransparentUpgradeableProxy upgradeTo is ifAdmin; admin is ProxyAdmin 0x4b5dec94 whose owner() is Safe 0x545a65a9 (v1.1.1, threshold 3, five owners). Peggy's owner() is zero and isOwnershipExpired() is true, so emergencyPause cannot be called. Rated MEDIUM: funds-loss, fixable only by a contract upgrade plus an Injective chain change (several parties).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or other path for signers: verifySig is ecrecover only (line 1263); not relevant against a quantum attacker anyway.
- Ruled out: unused implementation: the address is the proxy users call; the checkpoint is set and the valset nonce is 192,179,307 at the block, with valset updates and batches in the scan window.
- Ruled out: a pause or owner rescue: owner() is zero and ownership expired; emergencyPause is onlyOwner.
- Ruled out: value: the tool's figure (USD 4.45M) covers priced tokens only; the bridge also holds 94,968,243 INJ (balanceOf at the block), which is not priced. The old card's USD 657M figure is not restated.
- Ruled out: the EIP-8151 study's sender-gas-limits issue (replay 0x92ce6ef1 of updateValset reverts under EIP-8151 as sent) is a separate rated issue on this contract, not folded in here.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
