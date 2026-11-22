---
id: keeper-6b581546-rotate-signer-before-migrating
format: 2
title: StakeWise Keeper oracles must rotate before taking real code
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless oracles move to real code; the owner can replace any oracle key without its
  signature.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6b5815467da09daa7dc83db21c9239d98bb487b5'
  name: Keeper
  project: stakewise
  label: 'deployed by StakeWise: Deployer 1'
  code: verified
  code_url: https://etherscan.io/address/0x6b5815467da09daa7dc83db21c9239d98bb487b5#code
  copies: 1
  upgradeable: 'no'
  admin: '0x144a98cb1cdbb23610501fe6108858d9b7d24934'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 20540
  last: 2026-11-18
impact: liveness
action: Replace an oracle with removeOracle and addOracle before that oracle's account takes real code.
evidence_level: source
checks:
- id: author
  source: '0x6b5815467da09daa7dc83db21c9239d98bb487b5'
  file: contracts/keeper/Keeper.sol
  line: 16
  has: '@author StakeWise'
  says: the verified source names StakeWise as its author
  for:
  - what
- id: ecdsa
  source: '0x6b5815467da09daa7dc83db21c9239d98bb487b5'
  file: contracts/keeper/KeeperOracles.sol
  line: 99
  has: currentOracle = ECDSA.recover(data, signatures[startIndex:startIndex + _signatureLength]);
  says: each oracle signature is recovered with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: inset
  source: '0x6b5815467da09daa7dc83db21c9239d98bb487b5'
  file: contracts/keeper/KeeperOracles.sol
  line: 102
  has: if (currentOracle <= lastOracle || !isOracle[currentOracle]) revert Errors.InvalidOracle();
  says: the recovered address must be a listed oracle, in ascending order, or the call reverts
  for:
  - evidence-1
  - justification
  - what
- id: rewcall
  source: '0x6b5815467da09daa7dc83db21c9239d98bb487b5'
  file: contracts/keeper/KeeperRewards.sol
  lines:
  - 94
  - 95
  has: rewardsMinOracles,
  says: updateRewards verifies rewardsMinOracles oracle signatures
  for:
  - evidence-1
  - what
- id: valcall
  source: '0x6b5815467da09daa7dc83db21c9239d98bb487b5'
  file: contracts/keeper/KeeperValidators.sol
  lines:
  - 59
  - 60
  has: validatorsMinOracles,
  says: approveValidators verifies validatorsMinOracles oracle signatures
  for:
  - evidence-1
  - what
- id: minrew
  call: '0x6b5815467da09daa7dc83db21c9239d98bb487b5'
  fn: rewardsMinOracles()(uint256)
  is: 6
  says: a rewards update needs 6 oracle signatures
  for:
  - evidence-1
  - what
- id: minval
  call: '0x6b5815467da09daa7dc83db21c9239d98bb487b5'
  fn: validatorsMinOracles()(uint256)
  is: 6
  says: a validator approval needs 6 oracle signatures
  for:
  - evidence-1
  - what
- id: total
  call: '0x6b5815467da09daa7dc83db21c9239d98bb487b5'
  fn: totalOracles()(uint256)
  is: 11
  says: 11 oracles are listed
  for:
  - what
- id: add
  source: '0x6b5815467da09daa7dc83db21c9239d98bb487b5'
  file: contracts/keeper/KeeperOracles.sol
  lines:
  - 32
  - 48
  has: function addOracle(address oracle) external override onlyOwner {
  says: the owner adds an oracle to the list
  for:
  - action
  - evidence-2
  - justification
  - what
- id: remove
  source: '0x6b5815467da09daa7dc83db21c9239d98bb487b5'
  file: contracts/keeper/KeeperOracles.sol
  lines:
  - 51
  - 65
  has: function removeOracle(address oracle) external override onlyOwner {
  says: the owner removes an oracle from the list
  for:
  - action
  - evidence-2
  - justification
  - what
- id: owner
  call: '0x6b5815467da09daa7dc83db21c9239d98bb487b5'
  fn: owner()(address)
  is: '0x144a98cb1cdbb23610501fe6108858d9b7d24934'
  says: the owner that manages the oracle list
  for:
  - action
  - evidence-2
  - justification
  - what
- id: safe
  call: '0x144a98cb1cdbb23610501fe6108858d9b7d24934'
  fn: VERSION()(string)
  is: 1.3.0
  says: the owner is a Safe 1.3.0
  for:
  - evidence-2
- id: threshold
  call: '0x144a98cb1cdbb23610501fe6108858d9b7d24934'
  fn: getThreshold()(uint256)
  is: 4
  says: the Safe needs 4 of its owners
  for:
  - evidence-2
- id: txrew
  tx: '0xa19ee7f44a656ba3ac34f1ea60c2cef8aa0d18516870ef8f022408bc0bec1f88'
  to: '0x6b5815467da09daa7dc83db21c9239d98bb487b5'
  ok: true
  says: a real rewards update (selector 0x556a6899, updateRewards) succeeded
  for:
  - evidence-3
- id: oracle1
  call: '0x6b5815467da09daa7dc83db21c9239d98bb487b5'
  fn: isOracle(address)(bool)
  args:
  - '0x624ec1141eb0c3be58b382737718852665c35cf0'
  is: true
  says: an oracle recovered in that transaction is listed
  for:
  - evidence-3
- id: oracle2
  call: '0x6b5815467da09daa7dc83db21c9239d98bb487b5'
  fn: isOracle(address)(bool)
  args:
  - '0x3f77cc37b5f49561e84e36d87fae1f032e1f771e'
  is: true
  says: an oracle recovered in that transaction is listed
  for:
  - evidence-3
- id: oracle3
  call: '0x6b5815467da09daa7dc83db21c9239d98bb487b5'
  fn: isOracle(address)(bool)
  args:
  - '0x6d403394848ead12356c9bb667ed27bce1945914'
  is: true
  says: an oracle recovered in that transaction is listed
  for:
  - evidence-3
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

StakeWise rewards updates and validator approvals need ECDSA signatures from 6 of the 11 listed oracles. An oracle whose account takes real code is refused; an EIP-7702 delegation still counts. If fewer than 6 oracles keep plain keys, these updates stop until the owner replaces keys.

## Evidence

- The [verified source](https://etherscan.io/address/0x6b5815467da09daa7dc83db21c9239d98bb487b5#code) recovers each signature with ECDSA and requires a listed oracle, 6 of them per update.
- The [owner](https://etherscan.io/address/0x144a98cb1cdbb23610501fe6108858d9b7d24934), a 4-of-7 Safe, adds and removes oracles directly.
- A [rewards update](https://etherscan.io/tx/0xa19ee7f44a656ba3ac34f1ea60c2cef8aa0d18516870ef8f022408bc0bec1f88) signed by the oracles succeeded on this contract.

## Reviewer notes

### Mechanism

_verifySignatures (KeeperOracles.sol 78-112) recovers requiredSignatures signatures with ECDSA.recover (OZ, plain ecrecover with all gas, line 142 of ECDSA.sol), requires them in ascending order and each to be in isOracle, else reverts InvalidOracle. updateRewards (KeeperRewards.sol 83-129) uses rewardsMinOracles; approveValidators and updateExitSignatures (KeeperValidators.sol 49-115) use validatorsMinOracles. At block 26,438,999: totalOracles 11, both minimums 6. addOracle/removeOracle (KeeperOracles.sol 32-65) are onlyOwner, no signature from the oracle; owner is a Safe 1.3.0 proxy with threshold 4 and 7 owners, pendingOwner unset. The submitter chooses which signatures to include, so one oracle with real code only stops the updates when fewer than 6 listed oracles can still sign.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for an oracle with code: _verifySignatures has none (KeeperOracles.sol 96-111).
- Ruled out: unused implementation: not a proxy, upgradeable no, and a real updateRewards call succeeded at block 26,373,846.
- Ruled out: key state: the three oracles seen in the study window are listed (isOracle true) and have no code at the block.
- Ruled out: a direct path: updateRewards, approveValidators and updateExitSignatures have no owner or caller bypass of the signatures.
- Ruled out: fixed gas: ECDSA.recover calls ecrecover with all remaining gas; no constant gas amount.
- Ruled out: sender gas limit: tx 0xa19ee7f4... had limit 233,023 and used 131,946, a margin far above 6 x 3,100 extra gas; the dossier lists no replay and the window shows 0 failed recoveries. Not checked for every submitter.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
