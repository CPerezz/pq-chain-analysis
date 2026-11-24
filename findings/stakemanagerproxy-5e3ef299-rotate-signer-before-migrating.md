---
id: stakemanagerproxy-5e3ef299-rotate-signer-before-migrating
format: 2
title: Checkpoints revert if a validator signer key moves to real code
status: candidate
severity: INFORMATIONAL
justification: A validator can rotate its signer key with updateSigner before moving that key's account to real
  code.
category: migration-notice
pattern: PQ-17
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  name: StakeManagerProxy
  code: verified
  code_url: https://etherscan.io/address/0x1d9ee26f794676acf56bac9a479f766403d0f5cc#code
  proxy_of: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  copies: 1
  upgradeable: 'yes'
  admin: '0xcaf0aa768a3ae1297df20072419db8bb8b5c8cef'
value:
  usd: 499
  whose: mixed
  basis: held
activity: {}
impact: liveness
action: Tell validators to replace their signer key with updateSigner before moving that key's account to real code.
evidence_level: source
checks:
- id: impl
  call: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  fn: implementation()(address)
  is: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  says: the proxy runs StakeManager at 0x1d9e...f5cc
  for:
  - proxy_of
  - upgradeable
- id: owner
  call: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  fn: owner()(address)
  is: '0xcaf0aa768a3ae1297df20072419db8bb8b5c8cef'
  says: the proxy owner that can upgrade it
  for:
  - upgradeable
- id: upgrade
  source: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  file: StakeManagerProxy.sol
  line: 201
  has: function updateImplementation(address _newProxyTo) public onlyProxyOwner {
  says: the proxy owner can replace the implementation
  for:
  - upgradeable
- id: rootchain-mod
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/staking/stakeManager/StakeManager.sol
  line: 530
  has: ) external onlyRootChain returns (uint256) {
  says: checkSignatures can only be called by the root chain contract
  for:
  - what
- id: rootchain
  call: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  fn: rootChain()(address)
  is: '0x86e4dc95c7fbdbf52e33d563bbdb00823894c287'
  says: the root chain contract that submits checkpoints
  for:
  - evidence-3
  - what
- id: recover
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/staking/stakeManager/StakeManager.sol
  line: 546
  has: address signer = ECVerify.ecrecovery(voteHash, sigs[i]);
  says: each checkpoint signature is recovered with ECDSA
  for:
  - evidence-1
  - what
- id: lookup
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/staking/stakeManager/StakeManager.sol
  line: 558
  has: uint256 validatorId = signerToValidator[signer];
  says: the recovered address is matched to a validator by its stored signer key
  for:
  - evidence-1
  - what
- id: revert
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/common/lib/ECVerify.sol
  line: 32
  has: require(result != address(0x0));
  says: an empty recovery reverts instead of being skipped
  for:
  - evidence-1
  - what
- id: rotate-fn
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/staking/stakeManager/StakeManager.sol
  line: 501
  has: function updateSigner(uint256 validatorId, bytes memory signerPubkey) public onlyStaker(validatorId) {
  says: updateSigner is callable by the validator's staker
  for:
  - action
  - evidence-2
  - justification
- id: rotate-set
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/staking/stakeManager/StakeManager.sol
  lines:
  - 516
  - 518
  has: signerToValidator[signer] = validatorId; validators[validatorId].signer = signer;
  says: updateSigner installs the new signer key for the validator
  for:
  - action
  - evidence-2
  - justification
- id: staker
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/staking/stakeManager/StakeManager.sol
  line: 52
  has: require(NFTContract.ownerOf(validatorId) == msg.sender);
  says: the staker is the owner of the validator's NFT
  for:
  - action
  - evidence-2
  - justification
- id: limit
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/staking/stakeManager/StakeManager.sol
  line: 504
  has: require(_currentEpoch >= latestSignerUpdateEpoch[validatorId].add(signerUpdateLimit), "Not allowed");
  says: a signer can be changed only after signerUpdateLimit epochs since the last change
  for:
  - evidence-2
- id: limit-val
  call: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  fn: signerUpdateLimit()(uint256)
  is: 100
  says: the limit is 100 epochs
  for:
  - evidence-2
- id: cp-tx
  tx: '0x2313615eb8084f7a7d6362298dd8b6f6f4650fcc33c2d77e871d6282e3696951'
  to: '0x86e4dc95c7fbdbf52e33d563bbdb00823894c287'
  ok: true
  says: a real checkpoint submission to the root chain succeeded
  for:
  - evidence-3
- id: deleg-code
  code: '0x3a9df5dfcb4cc102ce20d40434a2b1baca9eafd3'
  is: delegation
  bytes: 23
  target: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  says: this signer key's account has an EIP-7702 delegation
  for:
  - what
- id: deleg-id
  call: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  fn: signerToValidator(address)(uint256)
  args:
  - '0x3a9df5dfcb4cc102ce20d40434a2b1baca9eafd3'
  is: 105
  says: the delegated account is the signer of validator 105
  for:
  - what
- id: locked
  call: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  fn: locked()(bool)
  is: false
  says: the contract is not locked at the block
  for:
  - notes
- id: pol-token
  call: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  fn: token()(address)
  is: '0x455e53cbb86018ac2b8092fdcd39d8444affc3f6'
  says: the staking token is POL
  for:
  - what
  - whose
- id: pol-bal
  call: '0x455e53cbb86018ac2b8092fdcd39d8444affc3f6'
  fn: balanceOf(address)(uint256)
  args:
  - '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  is: 3970443943541359351217550800
  says: the contract holds about 3.97 billion POL
  for:
  - what
  - whose
- id: stake-total
  call: '0x5e3ef299fddf15eaa0432e6e66473ace8c13d908'
  fn: currentValidatorSetTotalStake()(uint256)
  is: 3810437535960775870265659032
  says: about 3.81 billion POL of it is the validator set's total stake, delegations included
  for:
  - what
  - whose
- id: val-dep
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/staking/stakeManager/StakeManager.sol
  line: 374
  has: _transferAndTopUp(signer, msg.sender, heimdallFee, amount, pol);
  says: a validator's stake is transferred into this contract when it stakes
  for:
  - what
  - whose
- id: del-dep
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/staking/stakeManager/StakeManager.sol
  line: 343
  has: bool result = token_.transferFrom(delegator, address(this), amount);
  says: a delegator's deposit is transferred into this contract
  for:
  - what
  - whose
- id: del-call
  source: '0x1d9ee26f794676acf56bac9a479f766403d0f5cc'
  file: contracts/staking/validatorShare/ValidatorShare.sol
  lines:
  - 261
  - 262
  has: stakeManager.delegationDeposit(validatorId, amountToDeposit, msg.sender)
  says: buying delegation shares deposits the delegator's tokens through this contract
  for:
  - what
  - whose
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: INFORMATIONAL candidate (PQ-17): Polygon''s StakeManagerProxy (about 3.97B POL of validators'' and
    delegators'' stake, unpriced) reverts a whole checkpoint when any signer''s account has real code; each validator
    can rotate its signer with updateSigner (100-epoch cooldown) first. The refuter''s only open point, checkpoints
    failing at activation with nobody migrating, is settled by Claude''s fork replays (two real checkpoints revert
    under EIP-8151 as sent and pass with 1,000,000 more gas) and filed as its own row, sender-gas-limits|0x86e4dc95…
    (RootChainProxy), which this card names. The rest held under three refuters'' reads; Claude read the sheet.'
related: []
---

## What happens

It holds about 3.97 billion POL, mostly validators' and delegators' stake. Each checkpoint from its root chain contract needs ECDSA signatures matched to validators' stored signer keys. One signer whose account takes real code reverts the whole checkpoint. An EIP-7702 delegation keeps working.

## Evidence

- [checkSignatures](https://etherscan.io/address/0x1d9ee26f794676acf56bac9a479f766403d0f5cc#code) recovers each signature, maps it to a validator, and reverts when a recovery returns nothing.
- [updateSigner](https://etherscan.io/address/0x1d9ee26f794676acf56bac9a479f766403d0f5cc#code) lets a validator's owner install a new signer key, at most once every 100 epochs.
- [A real checkpoint](https://etherscan.io/tx/0x2313615eb8084f7a7d6362298dd8b6f6f4650fcc33c2d77e871d6282e3696951) sent to the root chain contract passes these checks.

## Reviewer notes

### Mechanism

The address is a proxy (custom slot keccak('matic.network.proxy.implementation')) delegating to StakeManager 0x1d9e...f5cc; its owner 0xcaf0...8cef (a contract) can call updateImplementation. RootChain (0x86e4...c287, rootChain()) calls checkSignatures (onlyRootChain, line 530) on each submitCheckpoint. For every signature, ECVerify.ecrecovery(bytes32,uint256[3]) (ECVerify.sol lines 4-35) calls ecrecover and requires a non-zero result (line 32), so an empty recovery under EIP-8151 reverts the whole call; it is not skipped. The recovered address is looked up in signerToValidator (line 558) and its stake counted. A validator's signer is replaced by updateSigner (lines 501-522), callable by the owner of the validator NFT (onlyStaker, line 52), and allowed once signerUpdateLimit epochs (100 at the block) have passed since its last update (line 504). The new signer is derived from a 64-byte public key (_getAndAssertSigner), i.e. a fresh EOA key. Governance can also forceUnstake a validator (line 174).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for signers with code: checkSignatures and ECVerify have none (StakeManager.sol 524-598, ECVerify.sol 4-35).
- Ruled out: a paused or closed path: locked() is false at the block and real checkpoints pass in the study window (1,098 transactions, 100 distinct signers recovered).
- Ruled out: a signer that already has real code: of the three signers in the dossier, two have no code and 0x3a9d...afd3 (validator 105) has an EIP-7702 delegation, which still recovers.
- Ruled out: signature-rechecked: signatures are checked once, when the checkpoint is submitted; nothing paid out earlier depends on them, so this stays a notice.
- Ruled out: a breaks-at-activation gas failure, not folded in: per the main reviewer's feedback (not replayed by me), checkpoint tx 0xb4798037... reverts under EIP-8151 alone at its sent gas limit (about 100 recoveries cost about 307,000 more gas) and passes with 600,000 more. It belongs to the contract the checkpoint transaction calls and is filed as its own row: sender-gas-limits|0x86e4dc95c7fbdbf52e33d563bbdb00823894c287 (RootChainProxy, rootChain() here).

### Questions

- Whether the off-chain software that bundles checkpoint signatures (Heimdall / the proposer) would leave out a signature from a signer with real code, so the checkpoint still passes on the remaining stake, or include it and revert: this cannot be read from the chain.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
