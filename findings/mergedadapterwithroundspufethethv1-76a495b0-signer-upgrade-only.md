---
id: mergedadapterwithroundspufethethv1-76a495b0-signer-upgrade-only
format: 2
title: RedStone pufETH/ETH and ETH+/ETH feeds refuse oracle keys moved to real code
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless oracle keys move to real code; the five keys can be replaced only by upgrading
  the code.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x76a495b0bffb53ef3f0e94ef0763e03ce410835c'
  name: MergedAdapterWithRoundsPufethethV1
  project: redstone
  code: verified
  code_url: https://etherscan.io/address/0xa41107f9259bb835275eacaad8048307b80d7c00#code
  proxy_of: '0xa41107f9259bb835275eacaad8048307b80d7c00'
  copies: 3
  family: 124046a36acfb5987c9402e00b5bbea7
  upgradeable: 'yes'
  admin: '0x8223a6271d1e0bda019ee55d545d7b86eff1f573'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: Upgrade both feeds to a new signer list before any of their five oracle keys moves its account to real code.
evidence_level: source
checks:
- id: feed-id
  source: '0xa41107f9259bb835275eacaad8048307b80d7c00'
  file: contracts/ethereumPufetheth/MergedAdapterWithRoundsPufethethV1.sol
  line: 17
  has: return bytes32("pufETH/ETH");
  says: the feed is pufETH/ETH
  for:
  - what
- id: update
  source: '0xa41107f9259bb835275eacaad8048307b80d7c00'
  file: '@redstone-finance/on-chain-relayer/contracts/core/RedstoneAdapterBase.sol'
  line: 102
  has: uint256[] memory oracleValues = getOracleNumericValuesFromTxMsg(dataFeedsIdsArray);
  says: an update takes its values from the signed packages in the calldata
  for:
  - what
- id: ecrecover
  source: '0xa41107f9259bb835275eacaad8048307b80d7c00'
  file: '@redstone-finance/evm-connector/contracts/libs/SignatureLib.sol'
  line: 25
  has: return ecrecover(signedHash, v, r, s);
  says: each package signer is recovered with ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: recover
  source: '0xa41107f9259bb835275eacaad8048307b80d7c00'
  file: '@redstone-finance/evm-connector/contracts/core/RedstoneConsumerBase.sol'
  lines:
  - 220
  - 224
  has: signerIndex = getAuthorisedSignerIndex(signerAddress);
  says: the recovered address is looked up in the authorised signer list
  for:
  - evidence-1
  - what
- id: signers
  source: '0xa41107f9259bb835275eacaad8048307b80d7c00'
  file: '@redstone-finance/on-chain-relayer/contracts/price-feeds/data-services/MergedPriceFeedAdapterWithRoundsPrimaryProd.sol'
  lines:
  - 15
  - 22
  has: revert SignerNotAuthorised(signerAddress);
  says: five addresses fixed in the code are accepted; any other reverts
  for:
  - action
  - evidence-1
  - justification
  - what
- id: threshold-src
  source: '0xa41107f9259bb835275eacaad8048307b80d7c00'
  file: '@redstone-finance/on-chain-relayer/contracts/price-feeds/data-services/MergedPriceFeedAdapterWithRoundsPrimaryProd.sol'
  lines:
  - 8
  - 10
  has: return 2;
  says: two distinct signers are required
  for:
  - what
- id: threshold
  call: '0x76a495b0bffb53ef3f0e94ef0763e03ce410835c'
  fn: getUniqueSignersThreshold()(uint8)
  is: 2
  says: the feed requires two distinct signers
  for:
  - evidence-1
  - what
- id: quorum
  source: '0xa41107f9259bb835275eacaad8048307b80d7c00'
  file: '@redstone-finance/evm-connector/contracts/core/RedstoneConsumerBase.sol'
  lines:
  - 299
  - 302
  has: revert InsufficientNumberOfUniqueSigners(
  says: fewer distinct signers than the threshold reverts the update
  for:
  - what
- id: revert0
  call: '0x76a495b0bffb53ef3f0e94ef0763e03ce410835c'
  fn: getAuthorisedSignerIndex(address)(uint8)
  args:
  - '0x0000000000000000000000000000000000000000'
  reverts: true
  says: an empty recovery (zero address) is refused with a revert
  for:
  - evidence-1
  - what
- id: padmin
  storage: '0x76a495b0bffb53ef3f0e94ef0763e03ce410835c'
  slot: '0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103'
  is: '0x0000000000000000000000008223a6271d1e0bda019ee55d545d7b86eff1f573'
  says: the proxy's admin is 0x8223...f573
  for:
  - action
  - evidence-2
  - justification
  - what
- id: upgrade-sel
  selector: '0x8223a6271d1e0bda019ee55d545d7b86eff1f573'
  fn: upgrade(address,address)
  says: the admin contract has the upgrade function
  for:
  - action
  - evidence-2
  - justification
  - what
- id: admin-impl
  call: '0x8223a6271d1e0bda019ee55d545d7b86eff1f573'
  fn: getProxyImplementation(address)(address)
  args:
  - '0x76a495b0bffb53ef3f0e94ef0763e03ce410835c'
  is: '0xa41107f9259bb835275eacaad8048307b80d7c00'
  says: the admin contract manages this proxy
  for:
  - evidence-2
- id: admin-owner
  call: '0x8223a6271d1e0bda019ee55d545d7b86eff1f573'
  fn: owner()(address)
  is: '0x6906f3a09bcc1b7cd3b0c8626724299618df4472'
  says: the admin contract's owner, who can upgrade
  for:
  - action
  - evidence-2
- id: safe-threshold
  call: '0x6906f3a09bcc1b7cd3b0c8626724299618df4472'
  fn: getThreshold()(uint256)
  is: 2
  says: the owner is a multisig needing two signatures
  for:
  - evidence-2
- id: safe-owners
  call: '0x6906f3a09bcc1b7cd3b0c8626724299618df4472'
  fn: getOwners()(address[])
  is:
  - '0xded99b7f82a3ddada95bc102f7d172e74d24a981'
  - '0xecad2ed2847e2b5474e95a74e84d9532f7cf66b1'
  - '0x52acd229e2550518400d3af420b80cfa843a5e6d'
  says: the multisig has three owners
  for:
  - evidence-2
- id: tx
  tx: '0xf330135ba408f2a749a5ce3e11358d1d042597dc68c74fcadd5fef03caf946ce'
  to: '0x76a495b0bffb53ef3f0e94ef0763e03ce410835c'
  ok: true
  says: a real signed update to this feed succeeded
  for:
  - evidence-3
- id: round
  call: '0x76a495b0bffb53ef3f0e94ef0763e03ce410835c'
  fn: latestRound()(uint80)
  is: 1201
  says: the feed has recorded 1,201 rounds
  for:
  - evidence-3
- id: e-impl
  call: '0x8223a6271d1e0bda019ee55d545d7b86eff1f573'
  fn: getProxyImplementation(address)(address)
  args:
  - '0x3b9c09bde7776c32c518e2e787412a9bbaa7685f'
  is: '0xf57ba29437c130e155ca4b65128630777638f05d'
  says: the same admin contract manages the ETH+/ETH feed proxy
  for:
  - action
  - evidence-2
  - what
- id: e-padmin
  storage: '0x3b9c09bde7776c32c518e2e787412a9bbaa7685f'
  slot: '0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103'
  is: '0x0000000000000000000000008223a6271d1e0bda019ee55d545d7b86eff1f573'
  says: the ETH+/ETH feed proxy has the same admin
  for:
  - action
  - evidence-2
  - justification
  - what
- id: e-feed
  call: '0x3b9c09bde7776c32c518e2e787412a9bbaa7685f'
  fn: getDataFeedId()(bytes32)
  is: '0x4554482b2f455448000000000000000000000000000000000000000000000000'
  says: the copy is the ETH+/ETH feed
  for:
  - what
- id: e-threshold
  call: '0x3b9c09bde7776c32c518e2e787412a9bbaa7685f'
  fn: getUniqueSignersThreshold()(uint8)
  is: 2
  says: the ETH+/ETH feed requires two distinct signers
  for:
  - what
- id: e-keys
  call: '0x3b9c09bde7776c32c518e2e787412a9bbaa7685f'
  fn: getAuthorisedSignerIndex(address)(uint8)
  args:
  - '0x8BB8F32Df04c8b654987DAaeD53D6B6091e3B774'
  is: 0
  says: the ETH+/ETH feed accepts the first of the same five keys
  for:
  - justification
  - what
- id: e-k1
  call: '0x3b9c09bde7776c32c518e2e787412a9bbaa7685f'
  fn: getAuthorisedSignerIndex(address)(uint8)
  args:
  - '0xdEB22f54738d54976C4c0fe5ce6d408E40d88499'
  is: 1
  says: second key
  for:
  - what
- id: e-k2
  call: '0x3b9c09bde7776c32c518e2e787412a9bbaa7685f'
  fn: getAuthorisedSignerIndex(address)(uint8)
  args:
  - '0x51Ce04Be4b3E32572C4Ec9135221d0691Ba7d202'
  is: 2
  says: third key
  for:
  - what
- id: e-k3
  call: '0x3b9c09bde7776c32c518e2e787412a9bbaa7685f'
  fn: getAuthorisedSignerIndex(address)(uint8)
  args:
  - '0xDD682daEC5A90dD295d14DA4b0bec9281017b5bE'
  is: 3
  says: fourth key
  for:
  - what
- id: e-k4
  call: '0x3b9c09bde7776c32c518e2e787412a9bbaa7685f'
  fn: getAuthorisedSignerIndex(address)(uint8)
  args:
  - '0x9c5AE89C4Af6aA32cE58588DBaF90d18a855B6de'
  is: 4
  says: fifth key
  for:
  - what
- id: e-revert0
  call: '0x3b9c09bde7776c32c518e2e787412a9bbaa7685f'
  fn: getAuthorisedSignerIndex(address)(uint8)
  args:
  - '0x0000000000000000000000000000000000000000'
  reverts: true
  says: the ETH+/ETH feed refuses an empty recovery
  for:
  - what
- id: e-round
  call: '0x3b9c09bde7776c32c518e2e787412a9bbaa7685f'
  fn: latestRound()(uint80)
  is: 1532
  says: the ETH+/ETH feed has recorded 1,532 rounds
  for:
  - evidence-3
- id: e-stale
  call: '0x3b9c09bde7776c32c518e2e787412a9bbaa7685f'
  fn: getBlockTimestampFromLatestUpdate()(uint256)
  is: 1782914723
  says: its last update is at 2026-07-01 14:05 UTC
  for:
  - evidence-3
- id: dep1
  bytecode: '0xa076ef6d0f2e75957015abed2701d9cddf28fadd'
  has: 76a495b0bffb53ef3f0e94ef0763e03ce410835c
  says: this adapter holds the pufETH/ETH feed address in its code
  for:
  - what
- id: dep1-desc
  call: '0xa076ef6d0f2e75957015abed2701d9cddf28fadd'
  fn: description()(string)
  is: pufETH/USD Chainlink Price Feed Adapter
  says: it is a pufETH/USD price feed
  for:
  - what
- id: dep2
  bytecode: '0x617667e30c8c4ffa2d639815b306bb40f3d32d53'
  has: 76a495b0bffb53ef3f0e94ef0763e03ce410835c
  says: this feed holds the pufETH/ETH feed address in its code
  for:
  - what
- id: dep2-desc
  call: '0x617667e30c8c4ffa2d639815b306bb40f3d32d53'
  fn: description()(string)
  is: 'TermMax price feed: pufETH/USD'
  says: it is a pufETH/USD price feed
  for:
  - what
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

RedStone's pufETH/ETH and ETH+/ETH price feeds accept a price only when two of five oracle keys set in their code sign it. A key moved to real code makes updates carrying its signature revert; below two keys, updates stop until upgraded. Several pufETH/USD feeds read the pufETH/ETH one.

## Evidence

- The [verified code](https://etherscan.io/address/0xa41107f9259bb835275eacaad8048307b80d7c00#code) recovers each signature with ecrecover, accepts five fixed addresses, reverts on any other, and needs two.
- Both feeds are proxies of one [admin contract](https://etherscan.io/address/0x8223a6271d1e0bda019ee55d545d7b86eff1f573), owned by a [2-of-3 multisig](https://etherscan.io/address/0x6906f3a09bcc1b7cd3b0c8626724299618df4472), which can upgrade them.
- A [signed update](https://etherscan.io/tx/0xf330135ba408f2a749a5ce3e11358d1d042597dc68c74fcadd5fef03caf946ce) to the pufETH/ETH feed succeeded (1,201 rounds); the ETH+/ETH feed last updated on 1 July 2026 (round 1,532).

## Reviewer notes

### Mechanism

updateDataFeedsValues (RedstoneAdapterBase, line 93) checks the caller (MergedAdapterWithRoundsPufethethV1.requireAuthorisedUpdater: five fixed updaters, or anyone 40 s after the last update), then calls getOracleNumericValuesFromTxMsg (line 102). RedstoneConsumerBase._extractDataPackage recovers each data package's signer with SignatureLib.recoverSignerAddress (ecrecover, all gas, line 25) and calls getAuthorisedSignerIndex (lines 220-224). MergedPriceFeedAdapterWithRoundsPrimaryProd maps five hard-coded addresses to indexes 0-4 and reverts SignerNotAuthorised for any other address, including the zero address (call reverts with 0xec459bc0). _getAggregatedValues reverts unless two distinct signers sign the feed (threshold 2). Under EIP-8151 a listed key with real code recovers to nothing, so any package it signs reverts the whole update; the relayer can drop that package and use two other keys, but with fewer than two plain keys no update can pass. The list lives in the implementation's code; the only way to change it is ProxyAdmin 0x8223...f573 upgrading the proxy, and its owner is Safe 0x6906...4472 (2 of 3). No signer storage, no setter. Copies: 0x3b9c...685f is the ETH+/ETH feed (implementation 0xf57b...f05d, other code hash), same admin, threshold 2, same five keys (calls at the block); last update 2026-07-01. 0x1bb8...144b is a second pufETH/ETH proxy with 0 rounds. 16 contracts hold 0x76a4 as a constant call target, among them pufETH/USD adapters.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: an ERC-1271 or code-size path for signers with code: none in the verified sources (no isValidSignature, SignatureLib line 25 is the only recovery).
- Ruled out: a setter for the signer list: getAuthorisedSignerIndex is pure code (lines 12-23), no storage; no function writes signers.
- Ruled out: unused implementation: this address is the proxy users call; the dossier shows 32 recoveries by it in the two-week window, and latestRound is 1,201 at the block.
- Ruled out: key state: all five listed keys have no code and nonce 0 at the block (they sign off-chain); presumed live.
- Ruled out: fixed gas: Solidity ecrecover forwards all gas; the scanner reports no constant gas for the call.
- Ruled out: a way to set the price without signatures: the only writer is updateDataFeedsValues, which always runs the signed-package extraction.
- Ruled out: old row said one stored key; the code holds five keys in code, threshold two, replaceable only by upgrade: root issue stands.
- Ruled out: scope: copy 0x1bb8...144b (pufETH/ETH) has latestRound 0: never updated, not cited as live.
- Ruled out: whose stays empty: the feeds hold $0; funds behind the 16 dependents not traced.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
