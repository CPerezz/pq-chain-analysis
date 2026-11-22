---
id: blobsfactory-da8e1708-signed-shortcut-lost
format: 2
title: Blob keys whose accounts take real code lose the signed way to bar themselves
status: candidate
severity: INFORMATIONAL
justification: Breaks only if a Blob key moves to real code before it is barred; it can still bar itself by calling
  barSelf.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  name: BlobsFactory
  code: verified
  code_url: https://etherscan.io/address/0xda8e170898b27fb32473a03c9d88c8b3433a6251#code
  copies: 1
  upgradeable: 'no'
  admin: '0x2056241d9ea5e83428d6f48ff809a9b8246637f1'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 44
  last: 2026-11-05
impact: liveness
action: Relay a signed bar for coin 11's Blob key 0x1ebc…94b3 before it takes real code; launchers whose wallet
  is the key can use barSelf.
evidence_level: executed
checks:
- id: barsig
  source: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  file: src/BlobsFactory.sol
  lines:
  - 497
  - 500
  has: if (ECDSA.recover(h, sig) != who) revert BadArgs();
  says: barWithSig bars who only when the ECDSA signature recovers to who
  for:
  - action
  - evidence-1
  - justification
  - what
- id: barself
  source: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  file: src/BlobsFactory.sol
  lines:
  - 491
  - 492
  has: _bar(msg.sender);
  says: barSelf bars the caller with no signature
  for:
  - action
  - evidence-1
  - justification
  - what
- id: keyarg
  source: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  file: src/BlobsFactory.sol
  line: 308
  has: abi.encode(creator, a.agent)
  says: each coin's treasury is cloned with its launcher and its Blob key
  for:
  - what
- id: openlaunch
  source: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  file: src/BlobsFactory.sol
  lines:
  - 252
  - 254
  has: return _launch(a, msg.sender, msg.sender);
  says: anyone can launch a coin and name its Blob key
  for:
  - notes
- id: count
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: coinCount()(uint256)
  is: 12
  says: 12 coins launched at the block
  for:
  - evidence-3
- id: bal11
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x1ebc66fdbe56888ff0d45e31cb646b6aa1e694b3'
  is: 0
  says: coin 11's Blob key holds no ETH
  for:
  - action
  - what
- id: nonce11
  nonce: '0x1ebc66fdbe56888ff0d45e31cb646b6aa1e694b3'
  is: 0
  says: coin 11's Blob key has never sent a transaction
  for:
  - action
  - what
- id: code11
  code: '0x1ebc66fdbe56888ff0d45e31cb646b6aa1e694b3'
  is: empty
  says: coin 11's Blob key has no code yet
  for:
  - action
  - what
- id: platform
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: platformCoin()(address)
  is: '0x81de408e8e875a6c3e7956de2ebbcdcce5906cfc'
  says: the platform coin is launched, so launchPlatform's team buys are closed
  for:
  - notes
- id: keeper
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: keeper()(address)
  is: '0xb526de56c3c9c9fbfe5b3e20f182140020121f34'
  says: the factory's keeper, the wallet that sent both barWithSig transactions
  for:
  - notes
- id: tx
  tx: '0x55eb76b279e03317badd5ff73e609e952502c627b64a3b5dcb6864859f123174'
  to: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  ok: true
  says: a relayed barWithSig called this contract directly and succeeded
  for:
  - evidence-2
- id: replay-code
  replay: '0x55eb76b279e03317badd5ff73e609e952502c627b64a3b5dcb6864859f123174'
  run: eip8151_signer_code
  ok: false
  says: under EIP-8151 with real code at the signer the call reverts
  for:
  - evidence-2
  - what
- id: replay-deleg
  replay: '0x55eb76b279e03317badd5ff73e609e952502c627b64a3b5dcb6864859f123174'
  run: eip8151_signer_delegated
  ok: true
  says: with an EIP-7702 delegation at the signer it still passes
  for:
  - evidence-2
  - what
- id: replay-8151
  replay: '0x55eb76b279e03317badd5ff73e609e952502c627b64a3b5dcb6864859f123174'
  run: eip8151
  ok: true
  says: under EIP-8151 alone, with nobody migrating, the call still passes
  for:
  - justification
- id: coin0
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: coins(uint256)(address)
  args:
  - 0
  is: '0x93efcdeae49c1bf3634a14ff1dfe25d9d0556d06'
  says: coin 0 of the factory
  for:
  - action
  - evidence-3
- id: tre0
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: treasuryOf(address)(address)
  args:
  - '0x93efcdeae49c1bf3634a14ff1dfe25d9d0556d06'
  is: '0x93e296ba9e8c0b512c6a165775478e15b701eb64'
  says: coin 0's treasury
  for:
  - action
  - evidence-3
- id: agent0
  call: '0x93e296ba9e8c0b512c6a165775478e15b701eb64'
  fn: agent()(address)
  is: '0x82805ba21699e8e408030fc214a01f37bbd76e1d'
  says: coin 0's Blob key
  for:
  - action
  - evidence-3
- id: creator0
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: creatorOf(address)(address)
  args:
  - '0x93efcdeae49c1bf3634a14ff1dfe25d9d0556d06'
  is: '0x82805ba21699e8e408030fc214a01f37bbd76e1d'
  says: coin 0's launcher
  for:
  - action
  - evidence-3
- id: barred0
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: forbidden(address)(bool)
  args:
  - '0x82805ba21699e8e408030fc214a01f37bbd76e1d'
  is: false
  says: whether coin 0's Blob key is barred
  for:
  - action
  - evidence-3
- id: coin1
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: coins(uint256)(address)
  args:
  - 1
  is: '0x64fdb8e1c80b52e70e8a783aaf8255fbc6585a64'
  says: coin 1 of the factory
  for:
  - action
  - evidence-3
- id: tre1
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: treasuryOf(address)(address)
  args:
  - '0x64fdb8e1c80b52e70e8a783aaf8255fbc6585a64'
  is: '0x967ba2e60a6f40083fa4f3687ede76a465277c81'
  says: coin 1's treasury
  for:
  - action
  - evidence-3
- id: agent1
  call: '0x967ba2e60a6f40083fa4f3687ede76a465277c81'
  fn: agent()(address)
  is: '0xb5e0d6407164097450b63c3f49128059ed273630'
  says: coin 1's Blob key
  for:
  - action
  - evidence-3
- id: creator1
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: creatorOf(address)(address)
  args:
  - '0x64fdb8e1c80b52e70e8a783aaf8255fbc6585a64'
  is: '0xb5e0d6407164097450b63c3f49128059ed273630'
  says: coin 1's launcher
  for:
  - action
  - evidence-3
- id: barred1
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: forbidden(address)(bool)
  args:
  - '0xb5e0d6407164097450b63c3f49128059ed273630'
  is: false
  says: whether coin 1's Blob key is barred
  for:
  - action
  - evidence-3
- id: coin2
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: coins(uint256)(address)
  args:
  - 2
  is: '0x600090eabd56b96beb7cead479f44e2e47070726'
  says: coin 2 of the factory
  for:
  - action
  - evidence-3
- id: tre2
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: treasuryOf(address)(address)
  args:
  - '0x600090eabd56b96beb7cead479f44e2e47070726'
  is: '0x3d8325173d89e84604fc3fad93bd59aef14ead7c'
  says: coin 2's treasury
  for:
  - action
  - evidence-3
- id: agent2
  call: '0x3d8325173d89e84604fc3fad93bd59aef14ead7c'
  fn: agent()(address)
  is: '0xb00b06073d459a5c0c9d6040b2a0e665642faced'
  says: coin 2's Blob key
  for:
  - action
  - evidence-3
- id: creator2
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: creatorOf(address)(address)
  args:
  - '0x600090eabd56b96beb7cead479f44e2e47070726'
  is: '0xb00b06073d459a5c0c9d6040b2a0e665642faced'
  says: coin 2's launcher
  for:
  - action
  - evidence-3
- id: barred2
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: forbidden(address)(bool)
  args:
  - '0xb00b06073d459a5c0c9d6040b2a0e665642faced'
  is: false
  says: whether coin 2's Blob key is barred
  for:
  - action
  - evidence-3
- id: coin3
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: coins(uint256)(address)
  args:
  - 3
  is: '0x49aaadc8d18507399e596d780fddb1a1c744bf49'
  says: coin 3 of the factory
  for:
  - action
  - evidence-3
- id: tre3
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: treasuryOf(address)(address)
  args:
  - '0x49aaadc8d18507399e596d780fddb1a1c744bf49'
  is: '0xa33b87f1147ceb97504da328343c64271a2464b1'
  says: coin 3's treasury
  for:
  - action
  - evidence-3
- id: agent3
  call: '0xa33b87f1147ceb97504da328343c64271a2464b1'
  fn: agent()(address)
  is: '0xb5e0d6407164097450b63c3f49128059ed273630'
  says: coin 3's Blob key
  for:
  - action
  - evidence-3
- id: creator3
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: creatorOf(address)(address)
  args:
  - '0x49aaadc8d18507399e596d780fddb1a1c744bf49'
  is: '0xb5e0d6407164097450b63c3f49128059ed273630'
  says: coin 3's launcher
  for:
  - action
  - evidence-3
- id: barred3
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: forbidden(address)(bool)
  args:
  - '0xb5e0d6407164097450b63c3f49128059ed273630'
  is: false
  says: whether coin 3's Blob key is barred
  for:
  - action
  - evidence-3
- id: coin4
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: coins(uint256)(address)
  args:
  - 4
  is: '0x0c3b96631e43f68df1c66c0f4ef97d8228bea2e2'
  says: coin 4 of the factory
  for:
  - action
  - evidence-3
- id: tre4
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: treasuryOf(address)(address)
  args:
  - '0x0c3b96631e43f68df1c66c0f4ef97d8228bea2e2'
  is: '0x69692394af5330be072d93d37ee87900721e5746'
  says: coin 4's treasury
  for:
  - action
  - evidence-3
- id: agent4
  call: '0x69692394af5330be072d93d37ee87900721e5746'
  fn: agent()(address)
  is: '0xb5e0d6407164097450b63c3f49128059ed273630'
  says: coin 4's Blob key
  for:
  - action
  - evidence-3
- id: creator4
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: creatorOf(address)(address)
  args:
  - '0x0c3b96631e43f68df1c66c0f4ef97d8228bea2e2'
  is: '0xb5e0d6407164097450b63c3f49128059ed273630'
  says: coin 4's launcher
  for:
  - action
  - evidence-3
- id: barred4
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: forbidden(address)(bool)
  args:
  - '0xb5e0d6407164097450b63c3f49128059ed273630'
  is: false
  says: whether coin 4's Blob key is barred
  for:
  - action
  - evidence-3
- id: coin5
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: coins(uint256)(address)
  args:
  - 5
  is: '0xdd8acf7b8f3b92050d30a7c8f2e0f056632ecce3'
  says: coin 5 of the factory
  for:
  - action
  - evidence-3
- id: tre5
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: treasuryOf(address)(address)
  args:
  - '0xdd8acf7b8f3b92050d30a7c8f2e0f056632ecce3'
  is: '0xb630d07c6d55cdf35b345a9b48276e4495deacd4'
  says: coin 5's treasury
  for:
  - action
  - evidence-3
- id: agent5
  call: '0xb630d07c6d55cdf35b345a9b48276e4495deacd4'
  fn: agent()(address)
  is: '0xb5e0d6407164097450b63c3f49128059ed273630'
  says: coin 5's Blob key
  for:
  - action
  - evidence-3
- id: creator5
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: creatorOf(address)(address)
  args:
  - '0xdd8acf7b8f3b92050d30a7c8f2e0f056632ecce3'
  is: '0xb5e0d6407164097450b63c3f49128059ed273630'
  says: coin 5's launcher
  for:
  - action
  - evidence-3
- id: barred5
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: forbidden(address)(bool)
  args:
  - '0xb5e0d6407164097450b63c3f49128059ed273630'
  is: false
  says: whether coin 5's Blob key is barred
  for:
  - action
  - evidence-3
- id: coin6
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: coins(uint256)(address)
  args:
  - 6
  is: '0x5ecab0f16b592d64dcf65fe28e1bab0c605e613d'
  says: coin 6 of the factory
  for:
  - action
  - evidence-3
- id: tre6
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: treasuryOf(address)(address)
  args:
  - '0x5ecab0f16b592d64dcf65fe28e1bab0c605e613d'
  is: '0xc8dbb2291b4ea1c456aa8e064a504f10b1444a1f'
  says: coin 6's treasury
  for:
  - action
  - evidence-3
- id: agent6
  call: '0xc8dbb2291b4ea1c456aa8e064a504f10b1444a1f'
  fn: agent()(address)
  is: '0xbfcc2d8e526df72d6ffb88d25236aa5c2b4413d3'
  says: coin 6's Blob key
  for:
  - action
  - evidence-3
- id: creator6
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: creatorOf(address)(address)
  args:
  - '0x5ecab0f16b592d64dcf65fe28e1bab0c605e613d'
  is: '0xbfcc2d8e526df72d6ffb88d25236aa5c2b4413d3'
  says: coin 6's launcher
  for:
  - action
  - evidence-3
- id: barred6
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: forbidden(address)(bool)
  args:
  - '0xbfcc2d8e526df72d6ffb88d25236aa5c2b4413d3'
  is: false
  says: whether coin 6's Blob key is barred
  for:
  - action
  - evidence-3
- id: coin7
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: coins(uint256)(address)
  args:
  - 7
  is: '0xd06e2ca900134764f6f1a3fd8c416349cbdf37c1'
  says: coin 7 of the factory
  for:
  - action
  - evidence-3
- id: tre7
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: treasuryOf(address)(address)
  args:
  - '0xd06e2ca900134764f6f1a3fd8c416349cbdf37c1'
  is: '0x76b74460b8c1b24bd90e4a3ca00caa1ec5413558'
  says: coin 7's treasury
  for:
  - action
  - evidence-3
- id: agent7
  call: '0x76b74460b8c1b24bd90e4a3ca00caa1ec5413558'
  fn: agent()(address)
  is: '0xbfcc2d8e526df72d6ffb88d25236aa5c2b4413d3'
  says: coin 7's Blob key
  for:
  - action
  - evidence-3
- id: creator7
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: creatorOf(address)(address)
  args:
  - '0xd06e2ca900134764f6f1a3fd8c416349cbdf37c1'
  is: '0xbfcc2d8e526df72d6ffb88d25236aa5c2b4413d3'
  says: coin 7's launcher
  for:
  - action
  - evidence-3
- id: barred7
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: forbidden(address)(bool)
  args:
  - '0xbfcc2d8e526df72d6ffb88d25236aa5c2b4413d3'
  is: false
  says: whether coin 7's Blob key is barred
  for:
  - action
  - evidence-3
- id: coin8
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: coins(uint256)(address)
  args:
  - 8
  is: '0xfcddd1343b409f0e010d5675b7e56f1d65a87dfd'
  says: coin 8 of the factory
  for:
  - action
  - evidence-3
- id: tre8
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: treasuryOf(address)(address)
  args:
  - '0xfcddd1343b409f0e010d5675b7e56f1d65a87dfd'
  is: '0x47713c883901b61e665babfbf1ce7cf8a68a9406'
  says: coin 8's treasury
  for:
  - action
  - evidence-3
- id: agent8
  call: '0x47713c883901b61e665babfbf1ce7cf8a68a9406'
  fn: agent()(address)
  is: '0xb5e0d6407164097450b63c3f49128059ed273630'
  says: coin 8's Blob key
  for:
  - action
  - evidence-3
- id: creator8
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: creatorOf(address)(address)
  args:
  - '0xfcddd1343b409f0e010d5675b7e56f1d65a87dfd'
  is: '0xb5e0d6407164097450b63c3f49128059ed273630'
  says: coin 8's launcher
  for:
  - action
  - evidence-3
- id: barred8
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: forbidden(address)(bool)
  args:
  - '0xb5e0d6407164097450b63c3f49128059ed273630'
  is: false
  says: whether coin 8's Blob key is barred
  for:
  - action
  - evidence-3
- id: coin9
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: coins(uint256)(address)
  args:
  - 9
  is: '0x81de408e8e875a6c3e7956de2ebbcdcce5906cfc'
  says: coin 9 of the factory
  for:
  - action
  - evidence-3
- id: tre9
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: treasuryOf(address)(address)
  args:
  - '0x81de408e8e875a6c3e7956de2ebbcdcce5906cfc'
  is: '0x25802587eb04c14635f54137dc65989e67943997'
  says: coin 9's treasury
  for:
  - action
  - evidence-3
- id: agent9
  call: '0x25802587eb04c14635f54137dc65989e67943997'
  fn: agent()(address)
  is: '0x39b73e0c18221eb4ecc351d5b7045045bf18081f'
  says: coin 9's Blob key
  for:
  - action
  - evidence-3
- id: creator9
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: creatorOf(address)(address)
  args:
  - '0x81de408e8e875a6c3e7956de2ebbcdcce5906cfc'
  is: '0x0000000000000000000000000000000000000000'
  says: coin 9's launcher
  for:
  - action
  - evidence-3
- id: barred9
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: forbidden(address)(bool)
  args:
  - '0x39b73e0c18221eb4ecc351d5b7045045bf18081f'
  is: true
  says: whether coin 9's Blob key is barred
  for:
  - action
  - evidence-3
- id: coin10
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: coins(uint256)(address)
  args:
  - 10
  is: '0xed8f9aa995ae720b464da18a2deb7ec5faa664ef'
  says: coin 10 of the factory
  for:
  - action
  - evidence-3
- id: tre10
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: treasuryOf(address)(address)
  args:
  - '0xed8f9aa995ae720b464da18a2deb7ec5faa664ef'
  is: '0x5816dec409a75ac30391851335d0200b3143ee3a'
  says: coin 10's treasury
  for:
  - action
  - evidence-3
- id: agent10
  call: '0x5816dec409a75ac30391851335d0200b3143ee3a'
  fn: agent()(address)
  is: '0x5068019f307902b5e683cf914327a936807fad89'
  says: coin 10's Blob key
  for:
  - action
  - evidence-3
- id: creator10
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: creatorOf(address)(address)
  args:
  - '0xed8f9aa995ae720b464da18a2deb7ec5faa664ef'
  is: '0x67559f3bbd7ad192abc8cc428f4e75641b6885e6'
  says: coin 10's launcher
  for:
  - action
  - evidence-3
- id: barred10
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: forbidden(address)(bool)
  args:
  - '0x5068019f307902b5e683cf914327a936807fad89'
  is: true
  says: whether coin 10's Blob key is barred
  for:
  - action
  - evidence-3
- id: coin11
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: coins(uint256)(address)
  args:
  - 11
  is: '0x7dc19ebd9807488c2aafcc6fc70e3c41667cc7d4'
  says: coin 11 of the factory
  for:
  - action
  - evidence-3
  - what
- id: tre11
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: treasuryOf(address)(address)
  args:
  - '0x7dc19ebd9807488c2aafcc6fc70e3c41667cc7d4'
  is: '0xdcfa4b33ba11b936354e517b28432564ae83b684'
  says: coin 11's treasury
  for:
  - action
  - evidence-3
  - what
- id: agent11
  call: '0xdcfa4b33ba11b936354e517b28432564ae83b684'
  fn: agent()(address)
  is: '0x1ebc66fdbe56888ff0d45e31cb646b6aa1e694b3'
  says: coin 11's Blob key
  for:
  - action
  - evidence-3
  - what
- id: creator11
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: creatorOf(address)(address)
  args:
  - '0x7dc19ebd9807488c2aafcc6fc70e3c41667cc7d4'
  is: '0x847be56ef5b9ba26f8f4c5d96ab44e498222cc66'
  says: coin 11's launcher
  for:
  - action
  - evidence-3
- id: barred11
  call: '0xda8e170898b27fb32473a03c9d88c8b3433a6251'
  fn: forbidden(address)(bool)
  args:
  - '0x1ebc66fdbe56888ff0d45e31cb646b6aa1e694b3'
  is: false
  says: whether coin 11's Blob key is barred
  for:
  - action
  - evidence-3
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

BlobsFactory lets a coin's Blob key bar itself from module payouts for good, by calling barSelf or by a signature anyone relays. A key whose account takes real code loses the signed way; an EIP-7702 delegation keeps working. Coin 11's key holds no ETH and is not barred.

## Evidence

- [barWithSig](https://etherscan.io/address/0xda8e170898b27fb32473a03c9d88c8b3433a6251#code) bars an address only if the ECDSA signature recovers to it; barSelf needs no signature.
- A relayed [barWithSig](https://etherscan.io/tx/0x55eb76b279e03317badd5ff73e609e952502c627b64a3b5dcb6864859f123174) reverts if the signer has real code and passes with a delegation.
- Of the 12 [coins](https://etherscan.io/address/0xda8e170898b27fb32473a03c9d88c8b3433a6251#code), 9 use the launcher's own wallet as Blob key; 2 other keys are barred, coin 11's is not.

## Reviewer notes

### Mechanism

barWithSig(who, sig) (lines 497-501) hashes ("blob.bar", this factory, chain id, who) as an EIP-191 message, requires ECDSA.recover(h, sig) == who and sets forbidden[who] for good. barSelf (lines 491-493) sets forbidden[msg.sender] with no signature. Each launch clones a treasury with (creator, agent) as immutable arguments (line 308); launch is open to anyone (252-254). At block 26,438,999 coinCount is 12. Coins 0-8 name the launcher's own wallet as agent (treasury agent() == creatorOf), four EOAs with nonces 1, 7, 23 and 1702, none barred: they can call barSelf themselves and lose only the signed way. Coins 9 (platform coin), 10 and 11 name a separate key with nonce 0. The keys of coins 9 and 10 were barred by barWithSig transactions sent by the factory's keeper 0xb526de56...1f34 (txs 0xdb2e14bd..., 0x55eb76b2...); coin 11's key 0x1ebc66fd...94b3 holds no ETH, has no code and is not barred, so today only a relayed signature bars it. A key whose account takes real code makes the precompile return nothing, ECDSA.recover reverts, and only barSelf, sent from the key's account, remains. The replayed transaction is a single direct call to barWithSig (selector 0xcdad030f) on this contract; no other step checks the signer.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 or a code-size branch: barWithSig calls ECDSA.recover directly (line 499), no SignatureChecker.
- Ruled out: breaks by itself: the replay under EIP-8151 alone succeeds; the recovery passes all remaining gas.
- Ruled out: key-state: 9 of 12 keys are the launchers' own wallets, not platform keys as the comment at line 146 says; for them nothing but the signed way is lost, so the action leaves them to barSelf. Who holds coin 11's key is not shown on chain (see questions).
- Ruled out: the coins' EIP-2612 permit: it is in each BlobsToken, separate contracts this factory deploys, not in this code.
- Ruled out: Permit2 team buys in launchPlatform: Permit2 checks those signatures, and the platform coin is already launched so the path is closed (platformCoin set).
- Ruled out: path closed: barWithSig has no pause or end, and launch is open, so new coins can name new keys.
- Ruled out: value: the factory holds no ETH or tokens; the money a missing bar touches is each coin treasury's module payouts, not shown here, so whose is left empty.

### Questions

- Who holds coin 11's Blob key 0x1ebc66fd…94b3: the platform's signer (as the source comment at line 146 says, and as the keeper's relays for coins 9 and 10 suggest) or the launcher 0x847be56e…cc66? The chain does not show it.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
