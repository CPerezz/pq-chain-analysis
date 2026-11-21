---
id: bridgeimplementation-3ee18b22-sender-gas-limits
format: 2
title: Wormhole token bridge redeems sent with tight gas limits fail under EIP-8151
status: confirmed
severity: LOW
justification: A redeem sent with a tight gas limit runs out of gas; the sender fixes it by raising the limit, so
  LOW.
category: breaks-at-activation
pattern: PQ-18
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x3ee18b2214aff97000d974cf647e7c347e8fa585'
  name: BridgeImplementation
  project: wormhole
  code: verified
  code_url: https://etherscan.io/address/0x381752f5458282d317d12c30d2bd4d6e1fd8841e#code
  proxy_of: '0x381752f5458282d317d12c30d2bd4d6e1fd8841e'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 271199398
  whose: users
  basis: held
activity: {}
impact: liveness
action: 'Re-estimate redeem gas limits under EIP-8151: this redeem used about 40,300 more gas than today, 32,900
  above its limit.'
evidence_level: executed
checks:
- id: tx
  tx: '0x2b26d4ed5f6cfc17d65a5c91b0feee280259145a9fc1e47f5c9d69b9d09817f3'
  to: '0x3ee18b2214aff97000d974cf647e7c347e8fa585'
  ok: true
  says: a real redeem sent directly to this bridge succeeded on chain
  for:
  - action
  - evidence-1
- id: replay-8151
  replay: '0x2b26d4ed5f6cfc17d65a5c91b0feee280259145a9fc1e47f5c9d69b9d09817f3'
  run: eip8151
  ok: false
  says: under EIP-8151, with its original gas limit, the redeem fails
  for:
  - action
  - evidence-1
  - justification
  - what
- id: replay-more
  replay: '0x2b26d4ed5f6cfc17d65a5c91b0feee280259145a9fc1e47f5c9d69b9d09817f3'
  run: eip8151_more_gas
  ok: true
  says: under EIP-8151 with 300,000 more gas the same redeem succeeds
  for:
  - action
  - evidence-1
  - justification
  - what
- id: complete
  source: '0x381752f5458282d317d12c30d2bd4d6e1fd8841e'
  file: contracts/bridge/Bridge.sol
  line: 468
  has: function completeTransfer(bytes memory encodedVm) public {
  says: completeTransfer redeems a signed transfer message
  for:
  - evidence-2
  - what
- id: verify
  source: '0x381752f5458282d317d12c30d2bd4d6e1fd8841e'
  file: contracts/bridge/Bridge.sol
  line: 496
  has: wormhole().parseAndVerifyVM(encodedVm);
  says: the redeem asks the core contract to verify the message, with no gas amount set
  for:
  - action
  - evidence-2
  - what
- id: valid
  source: '0x381752f5458282d317d12c30d2bd4d6e1fd8841e'
  file: contracts/bridge/Bridge.sol
  line: 498
  has: require(valid, reason);
  says: the redeem reverts unless the message verifies
  for:
  - evidence-2
  - what
- id: release
  source: '0x381752f5458282d317d12c30d2bd4d6e1fd8841e'
  file: contracts/bridge/Bridge.sol
  line: 573
  has: SafeERC20.safeTransfer(transferToken, transferRecipient, transferAmount);
  says: a verified redeem pays the bridged tokens out to the recipient
  for:
  - what
  - whose
- id: deposit
  source: '0x381752f5458282d317d12c30d2bd4d6e1fd8841e'
  file: contracts/bridge/Bridge.sol
  line: 256
  has: SafeERC20.safeTransferFrom(IERC20(token), msg.sender, address(this), amount);
  says: the tokens the bridge holds are pulled from users who bridge them out
  for:
  - whose
- id: core
  call: '0x3ee18b2214aff97000d974cf647e7c347e8fa585'
  fn: wormhole()(address)
  is: '0x98f3c9e6E3fAce36bAAd05FE09d375Ef1464288B'
  says: the bridge's verifier is the Wormhole core contract
  for:
  - evidence-2
  - what
- id: gov-upgrade
  source: '0x381752f5458282d317d12c30d2bd4d6e1fd8841e'
  file: contracts/bridge/BridgeGovernance.sol
  line: 43
  has: function upgrade(bytes memory encodedVM) public {
  says: a guardian-signed governance message can upgrade the bridge
  for:
  - upgradeable
- id: gov-upgrade-to
  source: '0x381752f5458282d317d12c30d2bd4d6e1fd8841e'
  file: contracts/bridge/BridgeGovernance.sol
  line: 105
  has: _upgradeTo(newImplementation);
  says: upgrade replaces the proxy's implementation
  for:
  - upgradeable
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

The token bridge pays out a transfer from another chain once the Wormhole core contract verifies the guardians' signatures on its message. EIP-8151 makes each signature check cost more, so a redeem sent with a tight gas limit runs out of gas; the same redeem with more gas succeeds.

## Evidence

- A [real redeem](https://etherscan.io/tx/0x2b26d4ed5f6cfc17d65a5c91b0feee280259145a9fc1e47f5c9d69b9d09817f3) to this bridge fails under EIP-8151 as sent and succeeds with 300,000 more gas.
- [completeTransfer](https://etherscan.io/address/0x381752f5458282d317d12c30d2bd4d6e1fd8841e#code) asks the Wormhole core contract to verify the message and reverts if it is not valid.

## Reviewer notes

### Mechanism

The address is an EIP-1967 proxy (TokenBridge) running BridgeImplementation. completeTransfer(bytes) (Bridge.sol line 468) calls _completeTransfer, which calls wormhole().parseAndVerifyVM(encodedVm) on the core contract 0x98f3c9e6e3face36baad05fe09d375ef1464288b (line 496) with no gas argument and reverts unless the message is valid (line 498); it then releases the tokens to the recipient (line 573). The core verifies the guardian signatures with ecrecover. Transaction 0x2b26d4ed... (block 26,403,085) calls the proxy directly with completeTransfer (selector 0xc6878519) and a gas limit of 303,653; it used 296,241. Replayed under EIP-8151 it fails as sent; with 300,000 more gas it succeeds using 336,541 = 296,241 + 13 x 3,100 (13 cold guardian recoveries). Each call layer (proxy delegatecall, call to the core proxy, its delegatecall) keeps back 1/64 of the gas, hence 3,200 per signature rather than 3,100.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a fixed gas amount in this contract: the call to parseAndVerifyVM passes no gas argument (line 496), and the replay with 300,000 more gas succeeds, so the failure is the sender's gas limit.
- Ruled out: another signed step in the transaction: it is sent straight to this proxy with completeTransfer; its receipt logs only this bridge's TransferRedeemed and one token Transfer from the bridge to the sender, so the guardians' check is the only signature check.
- Ruled out: the core contract 0x98f3c9e6e3face36baad05fe09d375ef1464288b: its guardian-signature check is its own row; this card covers only redeems sent to the token bridge.
- Ruled out: the sender 0x08bb17cf80ed16483efa0217480c94c233dd9900 holds an EIP-7702 delegation at block 26,438,999 (code 0xef0100490aac...), which still sends transactions; the gas limit is the sender's choice.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
