---
id: eternalstorageproxy-4aa42145-validator-signatures
format: 2
title: Forged validator ECDSA signatures could release xDAI bridge deposits
status: confirmed
severity: MEDIUM
justification: Four forged validator keys release users' deposits; an upgrade by an 8-of-15 Safe can change the
  check.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4aa42145aa6ebf72e164c9bbc74fbd3788045016'
  name: EternalStorageProxy
  code: verified
  code_url: https://etherscan.io/address/0x257bdd093cab1bd39ebf837dcb60f33d031d7d49#code
  proxy_of: '0x257bdd093cab1bd39ebf837dcb60f33d031d7d49'
  copies: 1
  upgradeable: 'yes'
  admin: '0x42f38ec5a75accec50054671233dfac9c0e7a3f6'
value:
  usd: 47165296
  whose: users
  basis: held
activity:
  txs_90d: 1357
impact: funds-loss
action: Upgrade the bridge so that withdrawals no longer rest on validator ECDSA signatures alone.
evidence_level: source
checks:
- id: impl
  call: '0x4aa42145aa6ebf72e164c9bbc74fbd3788045016'
  fn: implementation()(address)
  is: '0x257bdd093cab1bd39ebf837dcb60f33d031d7d49'
  says: the proxy runs the XDaiForeignBridge implementation 0x257bdd09…
  for:
  - proxy_of
- id: impl-slot
  storage: '0x4aa42145aa6ebf72e164c9bbc74fbd3788045016'
  slot: '0x2'
  is: '0x257bdd093cab1bd39ebf837dcb60f33d031d7d49'
  says: slot 2 of the proxy, its _implementation variable, holds 0x257bdd09…
  for:
  - proxy_of
  - upgradeable
- id: upgrade
  source: '0x4aa42145aa6ebf72e164c9bbc74fbd3788045016'
  file: EternalStorageProxy.sol
  lines:
  - 248
  - 250
  has: function upgradeTo(uint256 version, address implementation) public onlyProxyOwner { _upgradeTo(version, implementation);
  says: the proxy owner can point the proxy at a new implementation
  for:
  - action
  - evidence-2
  - justification
  - upgradeable
- id: upg-owner
  call: '0x4aa42145aa6ebf72e164c9bbc74fbd3788045016'
  fn: upgradeabilityOwner()(address)
  is: '0x42f38ec5a75accec50054671233dfac9c0e7a3f6'
  says: the proxy owner is the Safe 0x42f38ec5…
  for:
  - action
  - evidence-2
  - justification
  - upgradeable
- id: safe-threshold
  call: '0x42f38ec5a75accec50054671233dfac9c0e7a3f6'
  fn: getThreshold()(uint256)
  is: 8
  says: the Safe needs 8 owner signatures
  for:
  - evidence-2
  - justification
- id: safe-owners
  call: '0x42f38ec5a75accec50054671233dfac9c0e7a3f6'
  fn: getOwners()(address[])
  is:
  - '0x4b5f5231e2f08ad49d79ce5672a8339a63cfbd43'
  - '0xddf2d07267eaf2ce3e13ee4319be1f34d55ed992'
  - '0xf59e447e97bc03c2b0c5719e2e551f0b15b724e5'
  - '0xa07888742c18d7e658132ae0148ff205fff46481'
  - '0x329c54289ff5d6b7b7dae13592c6b1eda1543ed4'
  - '0xcf9ebf877688ed88a7479a6e63457fd78d4275ce'
  - '0x5b10ce4ddd27f57d4d432d409a5321219cba7893'
  - '0xc44caeb7f0724a156806664d2361fd6f32a2d2c8'
  - '0x839395e20bbb182fa440d08f850e6c7a8f6f0780'
  - '0xb646b8b5fe6cbc7770578b7679208337ef747ae4'
  - '0x10dd75875a2a8a284529ae7223b1ace410d606bd'
  - '0x80ba18503a1fa16ea22f3ef1af23e2994eac1d97'
  - '0xb2a33ae0e07fd2ca8dbde9545f6ce0b3234dc4e8'
  - '0x57b11cc8f93f2cfec4c1c5b95213f17cad81332b'
  - '0x544ce64c3fc6da72ceb2456cc4cf19e7c7972efa'
  says: the Safe has 15 owners
  for:
  - evidence-2
  - justification
- id: safe-nonce
  call: '0x42f38ec5a75accec50054671233dfac9c0e7a3f6'
  fn: nonce()(uint256)
  is: 93
  says: the Safe has executed 93 transactions, so it is in use
  for:
  - notes
- id: exec
  source: '0x257bdd093cab1bd39ebf837dcb60f33d031d7d49'
  file: BasicForeignBridge.sol
  line: 23
  has: Message.hasEnoughValidSignatures(message, signatures, validatorContract(), false);
  says: executeSignatures first checks the validators' signatures on the message
  for:
  - evidence-1
  - what
- id: loop
  source: '0x257bdd093cab1bd39ebf837dcb60f33d031d7d49'
  file: Message.sol
  line: 125
  has: for (uint256 i = 0; i < requiredSignatures; i++) {
  says: as many signatures are checked as the validator contract requires
  for:
  - evidence-1
  - what
- id: recover
  source: '0x257bdd093cab1bd39ebf837dcb60f33d031d7d49'
  file: Message.sol
  line: 137
  has: address recoveredAddress = ecrecover(hash, v, r, s);
  says: each signature is recovered with ECDSA
  for:
  - action
  - evidence-1
  - justification
  - what
- id: isval
  source: '0x257bdd093cab1bd39ebf837dcb60f33d031d7d49'
  file: Message.sol
  lines:
  - 138
  - 139
  has: require(_validatorContract.isValidator(recoveredAddress)); require(!addressArrayContains(encounteredAddresses,
    recoveredAddress));
  says: each recovered address must be a distinct listed validator
  for:
  - evidence-1
  - justification
  - what
- id: hashi-line
  source: '0x257bdd093cab1bd39ebf837dcb60f33d031d7d49'
  file: BasicForeignBridge.sol
  line: 37
  has: if (HASHI_IS_ENABLED && HASHI_IS_MANDATORY) require(isApprovedByHashi(hashMsg));
  says: the Hashi approval is required only when it is mandatory
  for:
  - evidence-1
  - what
- id: hashi-const
  source: '0x257bdd093cab1bd39ebf837dcb60f33d031d7d49'
  file: BasicBridge.sol
  line: 29
  has: bool public constant HASHI_IS_MANDATORY = false;
  says: Hashi is not mandatory, and it is a constant, not a setting
  for:
  - action
  - evidence-1
  - what
- id: hashi-off
  call: '0x4aa42145aa6ebf72e164c9bbc74fbd3788045016'
  fn: HASHI_IS_MANDATORY()(bool)
  is: false
  says: the running code reports Hashi as not mandatory
  for:
  - evidence-1
  - what
- id: payout
  source: '0x257bdd093cab1bd39ebf837dcb60f33d031d7d49'
  file: XDaiForeignBridge.sol
  lines:
  - 130
  - 137
  has: return token.transfer(_recipient, _amount);
  says: a passing message is paid to its recipient from the bridge's USDS (or as DAI converted from it)
  for:
  - evidence-1
  - justification
  - what
- id: withdraw
  source: '0x257bdd093cab1bd39ebf837dcb60f33d031d7d49'
  file: XDaiForeignBridge.sol
  lines:
  - 152
  - 154
  has: _withdraw(address(token), withdrawAmount);
  says: when its USDS runs short, the bridge withdraws from its sUSDS to pay
  for:
  - what
- id: valcontract
  call: '0x4aa42145aa6ebf72e164c9bbc74fbd3788045016'
  fn: validatorContract()(address)
  is: '0xe1579debdd2df16ebdb9db8694391fa74eea201e'
  says: the bridge asks the validator contract 0xe1579deb…
  for:
  - evidence-2
  - what
- id: required
  call: '0xe1579debdd2df16ebdb9db8694391fa74eea201e'
  fn: requiredSignatures()(uint256)
  is: 4
  says: 4 validator signatures are required
  for:
  - evidence-1
  - evidence-2
  - justification
  - what
- id: count
  call: '0xe1579debdd2df16ebdb9db8694391fa74eea201e'
  fn: validatorCount()(uint256)
  is: 7
  says: 7 validators are listed
  for:
  - evidence-2
  - what
- id: vallist
  call: '0xe1579debdd2df16ebdb9db8694391fa74eea201e'
  fn: validatorList()(address[])
  is:
  - '0x59d3c2829900ae20d02ca547082b09fd27380ea6'
  - '0xa2746d5ee860a6a9cbb79c34533313144d467ca8'
  - '0xc9f0d7e76e7970590e217c57af5d2b7d07a62c13'
  - '0x2245bfad58a6cd50e9e413084d4091c497281911'
  - '0x82b00ca9d162859f645b51967746e55bb6498dfc'
  - '0xb54b5572f3c4f70ff3cc8f67c19c8cddb838fbaa'
  - '0x1312e98995bbcc30fc63db3cef807e20cdd33dca'
  says: the 7 validators
  for:
  - evidence-2
- id: val-owner
  call: '0xe1579debdd2df16ebdb9db8694391fa74eea201e'
  fn: owner()(address)
  is: '0x42f38ec5a75accec50054671233dfac9c0e7a3f6'
  says: the validator contract's owner is the same Safe
  for:
  - evidence-2
- id: val-upg-owner
  call: '0xe1579debdd2df16ebdb9db8694391fa74eea201e'
  fn: upgradeabilityOwner()(address)
  is: '0x42f38ec5a75accec50054671233dfac9c0e7a3f6'
  says: the same Safe can upgrade the validator contract
  for:
  - notes
- id: add-val
  source: '0x6943a218d58135793f1fe619414ed476c37ad65a'
  file: BridgeValidators.sol
  lines:
  - 329
  - 336
  has: function addValidator(address _validator) external onlyOwner {
  says: the validator owner can add and remove validators
  for:
  - notes
- id: maxtx
  call: '0x4aa42145aa6ebf72e164c9bbc74fbd3788045016'
  fn: executionMaxPerTx()(uint256)
  is: '10000000000000000000000000'
  says: one message can pay at most 10 million USDS
  for:
  - what
- id: daily
  call: '0x4aa42145aa6ebf72e164c9bbc74fbd3788045016'
  fn: executionDailyLimit()(uint256)
  is: '15000000000000000000000000'
  says: messages can pay at most 15 million USDS a day
  for:
  - what
- id: limit-revert
  source: '0x257bdd093cab1bd39ebf837dcb60f33d031d7d49'
  file: ForeignBridgeErcToNative.sol
  lines:
  - 62
  - 64
  has: function onFailedMessage(address, uint256, bytes32) internal { revert(); }
  says: a message above the limits reverts
  for:
  - what
- id: relay
  source: '0x257bdd093cab1bd39ebf837dcb60f33d031d7d49'
  file: ForeignBridgeErcToNative.sol
  line: 73
  has: erc20token().transferFrom(msg.sender, address(this), _amount);
  says: the bridge's USDS comes from users bridging to Gnosis Chain
  for:
  - whose
- id: claim-guard
  source: '0x257bdd093cab1bd39ebf837dcb60f33d031d7d49'
  file: XDaiForeignBridge.sol
  lines:
  - 101
  - 102
  has: require(_token != bridgedToken
  says: the owner cannot claim the bridged USDS, nor the sUSDS while interest is on
  for:
  - whose
- id: usds-bal
  call: '0xdc035d45d973e3ec169d2276ddab16f1e407384f'
  fn: balanceOf(address)(uint256)
  args:
  - '0x4aa42145aa6ebf72e164c9bbc74fbd3788045016'
  is: '801301761583051694665638'
  says: the bridge holds 801,301 USDS
  for:
  - what
  - whose
- id: susds-bal
  call: '0xa3931d71877c0e7a3148cb7eb4463524fec27fbd'
  fn: balanceOf(address)(uint256)
  args:
  - '0x4aa42145aa6ebf72e164c9bbc74fbd3788045016'
  is: '41518675172336209378984123'
  says: the bridge holds 41.5 million sUSDS shares
  for:
  - what
- id: invested
  call: '0x4aa42145aa6ebf72e164c9bbc74fbd3788045016'
  fn: investedAmount(address)(uint256)
  args:
  - '0xdc035d45d973e3ec169d2276ddab16f1e407384f'
  is: '46363460559434699779431085'
  says: 46.4 million USDS of deposits are invested in sUSDS
  for:
  - whose
- id: interest
  call: '0x4aa42145aa6ebf72e164c9bbc74fbd3788045016'
  fn: interestAmount(address)(uint256)
  args:
  - '0xdc035d45d973e3ec169d2276ddab16f1e407384f'
  is: '1309391300661055322450'
  says: only 1,309 USDS of the sUSDS is unpaid interest; the rest is deposits
  for:
  - whose
- id: gsn-off
  call: '0x4aa42145aa6ebf72e164c9bbc74fbd3788045016'
  fn: getTrustedForwarder()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: the GSN entry point, which needs the trusted forwarder as caller, is unreachable
  for:
  - notes
- id: v230-done
  storage: '0xe1579debdd2df16ebdb9db8694391fa74eea201e'
  slot: '0xe5c0a1036c807fae4099670e044db6cd5649a2acfadf5e56e9298644dc1f6593'
  is: 1
  says: the validator contract's one-time upgradeToV230 has already run
  for:
  - notes
- id: hashi-enabled-src
  source: '0x257bdd093cab1bd39ebf837dcb60f33d031d7d49'
  file: BasicBridge.sol
  line: 28
  has: bool public constant HASHI_IS_ENABLED = true;
  says: Hashi itself is enabled, by a constant
  for:
  - evidence-1
- id: hashi-enabled
  call: '0x4aa42145aa6ebf72e164c9bbc74fbd3788045016'
  fn: HASHI_IS_ENABLED()(bool)
  is: true
  says: the running code reports Hashi as enabled
  for:
  - evidence-1
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

The bridge pays out from the USDS and sUSDS it holds when a message carries ECDSA signatures from 4 of its 7 validators. Someone who derives four validator keys with a quantum computer can forge withdrawals: up to 10 million USDS a message and 15 million a day.

## Evidence

- [executeSignatures](https://etherscan.io/address/0x257bdd093cab1bd39ebf837dcb60f33d031d7d49#code) recovers 4 signatures with ECDSA, matches each to a validator and pays; a constant makes Hashi's approval optional.
- The [validator contract](https://etherscan.io/address/0xe1579debdd2df16ebdb9db8694391fa74eea201e) lists 7 validators, 4 required; its owner, an 8-of-15 Safe, also upgrades this bridge.

## Reviewer notes

### Mechanism

executeSignatures (BasicForeignBridge lines 22-44, implementation 0x257bdd09…) calls Message.hasEnoughValidSignatures (Message lines 109-142): for each of requiredSignatures() (4, from the validator contract 0xe1579deb…) it ecrecovers the message hash and requires a distinct isValidator address. Within executionMaxPerTx (10M) and executionDailyLimit (15M), with an unused nonce and Hashi's approval not required (HASHI_IS_MANDATORY is a constant false; Hashi itself is enabled), onExecuteMessage (XDaiForeignBridge lines 123-141) pays USDS, withdrawing from sUSDS when USDS runs short (lines 149-155); above the limits it reverts. The validator contract's owner, the Safe, can add or remove validators and change requiredSignatures, but every signature is still recovered with ECDSA, so rotating keys does not remove the exposure. The proxy keeps its implementation at slot 2 (OwnedUpgradeabilityProxy, not EIP-1967), which is why the tool read no proxy; upgradeTo is onlyProxyOwner, and upgradeabilityOwner() is the same Safe (1.3.0, 8 of 15, nonce 93). Rating: pooled user deposits can be taken by forging a 4-key committee; the fix is an implementation upgrade by the Safe, so MEDIUM.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Unused implementation or wrong code: this proxy is in use (336 recoveries, 7 distinct signers in the study's window); implementation() and slot 2 both give the verified XDaiForeignBridge 0x257bdd09…, settling the dossier's note.
- Ruled out: A second signed path: executeSignaturesGSN uses the same check but only for the trusted forwarder, which is unset.
- Ruled out: Hashi as a gate: it is asked only if HASHI_IS_MANDATORY, a constant false the owner cannot turn on.
- Ruled out: A fix by setting: the owner can lower limits or replace validators, but new validators still sign with ECDSA; only an upgrade changes the check.
- Ruled out: Validators replaced without approval: BridgeValidators.upgradeToV230 has no access check, but its one-time flag is already set, so it cannot run again.
- Ruled out: Whose money: investedAmount (46.4M USDS) dwarfs unpaid interest (1,309 USDS); claimTokens refuses USDS and, while interest is on, sUSDS.
- Ruled out: The old finding's AMB and Omnibridge escrow are other addresses, not this card.
- Ruled out: A replay of a real transaction here (today ok, gas 176,535; EIP-8151 alone reverts, gas 177,169) is not cited: its sender's own gas limit, not this card's issue; left for the reviewer to route.
- Ruled out: The Safe's owners are ECDSA keys; that exposure belongs to the Safe's own row.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
