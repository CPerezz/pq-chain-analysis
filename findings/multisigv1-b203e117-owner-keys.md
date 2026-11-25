---
id: multisigv1-b203e117-owner-keys
format: 2
title: A quantum attacker with three owner keys controls this multisig wallet
status: confirmed
severity: MEDIUM
justification: Three forged owner keys take the funds; the fix needs the owners to replace their keys and the proxy
  admin.
category: quantum-exposure
pattern: PQ-12
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb203e1170a30e68dc5b20aac08aa42619842c79e'
  name: MultiSigV1
  code: verified
  code_url: https://etherscan.io/address/0x471756ad2124b04dc1c5c364ee6a9e29f8c3f67a#code
  proxy_of: '0x471756ad2124b04dc1c5c364ee6a9e29f8c3f67a'
  copies: 1
  upgradeable: 'yes'
  admin: '0xca30217205742ecdc440b736aa65e0d28bd823c2'
value:
  usd: 150187301
  basis: held
activity: {}
impact: funds-loss
action: Replace the four owners with new post-quantum accounts, and have the admin multisig hand the proxy to an
  admin with such owners.
evidence_level: source
checks:
- id: owners
  call: '0xb203e1170a30e68dc5b20aac08aa42619842c79e'
  fn: getOwners()(address[])
  is:
  - '0x44c341ad187d48eafb7df892f9d4411827bb9527'
  - '0xedf1b98a188b2d496797b14b6b28a0f3afe5bc10'
  - '0x967a529baa2dc7cec989a073ca9a81d8a80540ca'
  - '0x739463da605ae91de81d2fccd534623320166349'
  says: the wallet has four owners
  for:
  - evidence-2
  - what
- id: required
  call: '0xb203e1170a30e68dc5b20aac08aa42619842c79e'
  fn: required()(uint256)
  is: 3
  says: three owners must approve
  for:
  - evidence-1
  - what
- id: txcount
  call: '0xb203e1170a30e68dc5b20aac08aa42619842c79e'
  fn: transactionCount()(uint256)
  is: 150
  says: the wallet has recorded 150 transactions
  for:
  - evidence-3
- id: o1
  code: '0x44c341ad187d48eafb7df892f9d4411827bb9527'
  is: empty
  says: owner 1 has no code
  for:
  - evidence-2
  - what
- id: o2
  code: '0xedf1b98a188b2d496797b14b6b28a0f3afe5bc10'
  is: empty
  says: owner 2 has no code
  for:
  - evidence-2
  - what
- id: o3
  code: '0x967a529baa2dc7cec989a073ca9a81d8a80540ca'
  is: empty
  says: owner 3 has no code
  for:
  - evidence-2
  - what
- id: o4
  code: '0x739463da605ae91de81d2fccd534623320166349'
  is: empty
  says: owner 4 has no code
  for:
  - evidence-2
  - what
- id: sender
  source: '0x471756ad2124b04dc1c5c364ee6a9e29f8c3f67a'
  file: MultiSigV1.sol
  line: 1332
  has: require(isOwner[msg.sender], "MS90");
  says: executeTxWithPermits must be sent by an owner
  for:
  - evidence-1
  - what
- id: threshold
  source: '0x471756ad2124b04dc1c5c364ee6a9e29f8c3f67a'
  file: MultiSigV1.sol
  line: 1336
  has: require(rs.length + 1 == required, "MS94");
  says: the sender plus required - 1 signatures
  for:
  - evidence-1
  - justification
  - what
- id: ecdsa
  source: '0x471756ad2124b04dc1c5c364ee6a9e29f8c3f67a'
  file: MultiSigV1.sol
  lines:
  - 1359
  - 1364
  has: address owner = ecrecover(digest, vs[i], rs[i], ss[i]);
  says: each co-owner signature is recovered with ecrecover and must be an owner
  for:
  - evidence-1
  - justification
  - what
- id: send
  source: '0x471756ad2124b04dc1c5c364ee6a9e29f8c3f67a'
  file: MultiSigV1.sol
  lines:
  - 1382
  - 1384
  has: destination.call{
  says: the approved call is made with the wallet's value to any destination
  for:
  - what
- id: direct
  source: '0x471756ad2124b04dc1c5c364ee6a9e29f8c3f67a'
  file: MultiSigV1.sol
  lines:
  - 1002
  - 1010
  has: ownerExists(msg.sender)
  says: an owner, including one with code, confirms and executes by calling directly
  for:
  - action
- id: replace-src
  source: '0x471756ad2124b04dc1c5c364ee6a9e29f8c3f67a'
  file: MultiSigV1.sol
  lines:
  - 959
  - 974
  has: isOwner[newOwner] = true;
  says: replaceOwner (callable by the wallet itself) swaps an owner for a new one
  for:
  - action
  - justification
- id: mutable
  storage: '0xb203e1170a30e68dc5b20aac08aa42619842c79e'
  slot: '0x7'
  is: '0x100'
  says: ownersImmutable is false and initialized is true on the wallet
  for:
  - action
- id: replace-sim
  call: '0xb203e1170a30e68dc5b20aac08aa42619842c79e'
  data: '0xe20056e6000000000000000000000000967a529baa2dc7cec989a073ca9a81d8a80540ca000000000000000000000000000000000000000000000000000000000000dead'
  from: '0xb203e1170a30e68dc5b20aac08aa42619842c79e'
  is: ''
  says: 'replaceOwner called by the wallet itself succeeds: its owners can be replaced'
  for:
  - action
  - justification
- id: admin-slot
  storage: '0xb203e1170a30e68dc5b20aac08aa42619842c79e'
  slot: '0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103'
  is: '0xca30217205742ecdc440b736aa65e0d28bd823c2'
  says: the proxy's admin is 0xca30..
  for:
  - action
  - evidence-2
  - what
- id: admin-owners
  call: '0xca30217205742ecdc440b736aa65e0d28bd823c2'
  fn: getOwners()(address[])
  is:
  - '0x44c341ad187d48eafb7df892f9d4411827bb9527'
  - '0xedf1b98a188b2d496797b14b6b28a0f3afe5bc10'
  - '0x967a529baa2dc7cec989a073ca9a81d8a80540ca'
  - '0x739463da605ae91de81d2fccd534623320166349'
  says: the admin is a multisig of the same four owners
  for:
  - evidence-2
  - what
- id: admin-required
  call: '0xca30217205742ecdc440b736aa65e0d28bd823c2'
  fn: required()(uint256)
  is: 3
  says: the admin needs three of them
  for:
  - what
- id: admin-fixed
  call: '0xca30217205742ecdc440b736aa65e0d28bd823c2'
  data: '0xe20056e6000000000000000000000000967a529baa2dc7cec989a073ca9a81d8a80540ca000000000000000000000000000000000000000000000000000000000000dead'
  from: '0xca30217205742ecdc440b736aa65e0d28bd823c2'
  reverts_with: MS01
  says: the admin's owners cannot be replaced (owners immutable)
  for:
  - action
  - evidence-2
- id: upgrade
  source: '0xb203e1170a30e68dc5b20aac08aa42619842c79e'
  file: TransparentUpgradeableProxy.sol
  line: 96
  has: function upgradeTo(address newImplementation) external ifAdmin {
  says: the admin can replace the wallet's code
  for:
  - what
- id: change-admin
  source: '0xb203e1170a30e68dc5b20aac08aa42619842c79e'
  file: TransparentUpgradeableProxy.sol
  line: 87
  has: function changeAdmin(address newAdmin) external virtual ifAdmin {
  says: the admin can hand the proxy to a new admin
  for:
  - action
  - justification
- id: in-use
  tx: '0x450849383d8a6d43d3b49c2be428433a6365f7827bb4d8912511e4a5dac622ac'
  to: '0xb203e1170a30e68dc5b20aac08aa42619842c79e'
  ok: true
  says: a real transaction to the wallet succeeded
  for:
  - evidence-3
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review23 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews:
- who: r-b203e117, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-12): a 3-of-4 MultiSigV1 wallet (37,006.85 ETH and 83.49M
    USDT, about $150M) whose four owners are plain key accounts with no code; a sender plus two ECDSA co-signatures
    move funds, and the proxy''s admin is a multisig of the same keys; owners can rotate themselves and hand over
    the admin (changeAdmin). Two refuters agree on the substance; Claude fixed one wording error (what-1) and a
    fresh refuter agrees. whose not established (operator unidentified). Claude read the sheet.'
related: []
---

## What happens

This 3-of-4 multisig wallet has four owners, plain key accounts with no code: one owner sends a transfer with two other owners' ECDSA signatures. A quantum attacker who recovers three keys can move all its funds, or upgrade it through its admin, a multisig of the same keys.

## Evidence

- [executeTxWithPermits](https://etherscan.io/address/0x471756ad2124b04dc1c5c364ee6a9e29f8c3f67a#code) checks each co-owner with ecrecover and needs the sender plus two signers.
- The four [owners](https://etherscan.io/address/0xb203e1170a30e68dc5b20aac08aa42619842c79e#readProxyContract) have no code, and the proxy admin has the same owners, which it cannot change.
- An owner uses the wallet in a real [transaction](https://etherscan.io/tx/0x450849383d8a6d43d3b49c2be428433a6365f7827bb4d8912511e4a5dac622ac); it has recorded 150 transactions.

## Reviewer notes

### Mechanism

executeTxWithPermits (MultiSigV1.sol 1323-1372, implementation 0x4717..) requires msg.sender to be an owner and rs.length + 1 == required (3), builds an EIP-712 digest, ecrecovers each (v, r, s) and requires the result to be an owner, then executeTransactionInner calls destination with value. The Gnosis base also lets owners act by msg.sender (submitTransaction / confirmTransaction / executeTransaction). Owners are changed by addOwner / removeOwner / replaceOwner / changeRequirement, all onlyWallet and notImmutable; on this wallet ownersImmutable is false (slot 7 = 0x0100: ownersImmutable byte 0 = false, initialized byte 1 = true) and a simulated replaceOwner from the wallet succeeds. The EIP-1967 admin 0xca30.. is a factory-made MultiSigWalletWithPermit with the same four owners, required 3, owners immutable (slot 7 = 0x0101; replaceOwner from itself reverts MS01); through TransparentUpgradeableProxy it can upgradeTo any implementation or changeAdmin. So three keys move the funds directly or by upgrade; the owners can fix both in place (replaceOwner to new post-quantum accounts at new addresses, changeAdmin to a post-quantum admin).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for co-owners: executeTxWithPermits has none (lines 1359-1365); owners with code can only act by msg.sender through confirmTransaction (lines 1002-1011).
- Ruled out: unused address: the wallet is in use (transactionCount 150; tx 0x450849.. from owner 0x44c3.. to this proxy succeeds; scan.window shows recoveries of owners 0x7394.. and 0xedf1..).
- Ruled out: the family replay 0xcc6d0fe5.. is another wallet on the same implementation (its signer 0x8cff.. is not an owner here); not cited. It passes under EIP-8151 alone, so nothing here breaks with nobody migrating.
- Ruled out: an owner that moves to post-quantum code at its own address stays forgeable here (ecrecover still returns it without EIP-8151), so the action says new accounts, not migrating in place.
- Ruled out: owner 0x967a.. has nonce 0; whether its public key is exposed was not checked. The other three (sender 0x44c3.. with nonce 153, and the two recovered co-signers) already meet the threshold of 3.
- Ruled out: copies: the dossier lists none; the wallet is rated as one wallet.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
