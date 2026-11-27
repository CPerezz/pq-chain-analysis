---
id: channelmanager-bf2aeab0-signature-rechecked
format: 2
title: Channel users lose newer balances if the hub's account takes real code
status: confirmed
severity: CRITICAL
justification: Users rely on hub-signed states rechecked on exit; the hub is fixed, so users who did nothing lose.
category: voided-by-migration
pattern: PQ-15
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xbf2aeab03b82c182599930217272ef0fc5cf662b'
  name: ChannelManager
  project: connext
  code: verified
  code_url: https://etherscan.io/address/0xbf2aeab03b82c182599930217272ef0fc5cf662b#code
  copies: 5
  family: 5c6fba46e8a71080eacef5aafd837cf4
value:
  usd: 88308
  whose: mixed
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Keep the hub's account free of real code (an EIP-7702 delegation keeps working) until every open channel
  is settled on chain.
evidence_level: source
checks:
- id: hubsig
  source: '0xbf2aeab03b82c182599930217272ef0fc5cf662b'
  file: ChannelManager.sol
  line: 1198
  has: require(hub == ECTools.recoverSigner(state, sigHub), "hub signature invalid");
  says: the hub's signature on a channel state is recovered with ECDSA and must equal the stored hub
  for:
  - action
  - evidence-1
  - justification
  - what
- id: both
  source: '0xbf2aeab03b82c182599930217272ef0fc5cf662b'
  file: ChannelManager.sol
  line: 578
  has: '[true, true] // [checkHubSig?, checkUser] <- check both sigs'
  says: an exit with an off-chain state needs both the hub's and the user's signature
  for:
  - justification
  - what
- id: challenge
  source: '0xbf2aeab03b82c182599930217272ef0fc5cf662b'
  file: ChannelManager.sol
  line: 656
  has: '[true, true] // [checkHubSig?, checkUser] <- check both sigs'
  says: a challenge to an exit needs a newer state that the hub signed
  for:
  - justification
  - what
- id: startexit
  source: '0xbf2aeab03b82c182599930217272ef0fc5cf662b'
  file: ChannelManager.sol
  lines:
  - 528
  - 532
  has: require(msg.sender == hub || msg.sender == user, "exit initiator must be user or hub");
  says: the hub can start an exit on the on-chain balances without any signature
  for:
  - justification
  - what
- id: hubset
  source: '0xbf2aeab03b82c182599930217272ef0fc5cf662b'
  file: ChannelManager.sol
  line: 348
  has: hub = _hub;
  says: the hub is assigned in the constructor
  for:
  - evidence-1
  - justification
- id: balances
  source: '0xbf2aeab03b82c182599930217272ef0fc5cf662b'
  file: ChannelManager.sol
  line: 312
  has: uint256[3] weiBalances; // [hub, user, total]
  says: each channel holds both the hub's and the user's balance
  for:
  - whose
- id: chwei
  call: '0xbf2aeab03b82c182599930217272ef0fc5cf662b'
  fn: totalChannelWei()(uint256)
  is: '48936188029127750134'
  says: 48.94 ETH is counted as held in channels
  for:
  - evidence-2
  - whose
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0xbf2aeab03b82c182599930217272ef0fc5cf662b'
  is: '48936188029127750134'
  says: the contract's whole ETH balance is in channels
  for:
  - evidence-2
- id: hub
  call: '0xbf2aeab03b82c182599930217272ef0fc5cf662b'
  fn: hub()(address)
  is: '0x526d0cd57a8b977D3628f12cDeceAb12dd49297C'
  says: the hub address at the block
  for:
  - notes
- id: hubeoa
  code: '0x526d0cd57a8b977d3628f12cdeceab12dd49297c'
  is: empty
  says: the hub's account has no code at the block
  for:
  - action
- id: hubnonce
  nonce: '0x526d0cd57a8b977d3628f12cdeceab12dd49297c'
  is: 5091
  at: 20000000
  says: the hub had sent 5,091 transactions by block 20,000,000
  for:
  - evidence-2
- id: hubnonce2
  nonce: '0x526d0cd57a8b977d3628f12cdeceab12dd49297c'
  is: 5091
  says: and none since, up to the block
  for:
  - evidence-2
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: CRITICAL
reviews:
- who: r-bf2aeab0, the row's refuter
  date: 2026-11-27
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection (the card was edited after this answer)
- who: reader-1, the reader who settled the row (also its author)
  date: 2026-11-27
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: 'kept: Connext v1 ChannelManager: a channel''s newest balance is paid when a party shows a state signed
    by both the user and the hub, and a challenge to an exit needs a newer hub-signed state. The hub is set once
    in the constructor; no setter, owner or upgrade. If the hub''s account takes real code its signature no longer
    recovers, users cannot prove newer states, and the hub can close on older ones. PQ-15, CRITICAL: no update path
    and users who did nothing lose. Fix: keep the hub''s account free of real code until every channel is settled.
    Refuter agreed; its one gap (the hub looks inactive) is now on the card: evidence-2 says the hub has sent nothing
    since block 20,000,000 (nonce checks). Reader dropped the author''s question about off-chain states (unreadable
    on chain; noted under ruled_out); the hub''s inactivity question is answered by the nonce checks.'
related: []
---

## What happens

Connext's channel manager pays out a channel's newest balance when a party shows a state signed by both the user and the hub. If the hub's account takes real code, its signature no longer recovers, so users cannot prove newer states and the hub can close on older ones.

## Evidence

- [_verifySig](https://etherscan.io/address/0xbf2aeab03b82c182599930217272ef0fc5cf662b#code) requires the recovered address to equal the hub, set once in the constructor.
- At block 26,438,999 the [contract](https://etherscan.io/address/0xbf2aeab03b82c182599930217272ef0fc5cf662b#code) counts 48.94 ETH as held in channels, all of its ETH; the hub has sent nothing since block 20,000,000.

## Reviewer notes

### Mechanism

ECTools.recoverSigner (lines 17-43) calls ecrecover on the prefixed state hash. _verifySig (lines 1164-1204) requires hub == recoverSigner(state, sigHub) and user == recoverSigner(state, sigUser). startExitWithUpdate (line 578) and emptyChannelWithChallenge (line 656) check both signatures; userAuthorizedUpdate checks the hub's (line 484). startExit (lines 519-532) lets the hub open a dispute on the on-chain balances with no signature, and emptyChannel (lines 723-760) pays those balances after the 86,400-second challenge period. The only answer to an outdated exit is emptyChannelWithChallenge with a newer state the hub signed. hub is assigned only in the constructor (line 348). Under EIP-8151, once the hub's account has real code, sigHub recovers nothing and every hub-signed state the user holds stops counting.

### Checks

- Header facts: this address alone, at block 26,438,999; 5 addresses run this code.
- Ruled out: an ERC-1271 or code-size branch for the hub: the source has neither; recoverSigner returns ecrecover directly (line 42).
- Ruled out: a setter for hub: hub is written only in the constructor (line 348); there is no owner or upgrade path.
- Ruled out: the hub taking back a user's newer state without migrating: startExit uses on-chain balances, and the user can answer within the challenge period with the hub-signed state (line 656).
- Ruled out: the hub already holding code: hub 0x526d0cd57a8b977d3628f12cdeceab12dd49297c has no code at the block.
- Ruled out: Which users hold off-chain states newer than those on chain: not readable on chain; the card states the mechanism, the ETH in channels and the hub's inactivity, not any one channel's position.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-27: reviewed again and rewritten from checks that were re-run.
