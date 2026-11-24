---
id: eternalstorageproxy-4c36d291-validator-signatures
format: 2
title: Gnosis bridge messages can be forged with four validators' ECDSA keys
status: confirmed
severity: MEDIUM
justification: Forging four validator keys releases bridged tokens; the fix is a contract upgrade by the bridge's
  Safe.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4c36d2919e407f0cc2ee3c993ccf8ac26d9ce64e'
  name: EternalStorageProxy
  code: verified
  code_url: https://etherscan.io/address/0x098f51bdfb5d6d319dd4fdf06b64773d25bd1316#code
  proxy_of: '0x098f51bdfb5d6d319dd4fdf06b64773d25bd1316'
  copies: 1
  upgradeable: 'yes'
  admin: '0x42f38ec5a75accec50054671233dfac9c0e7a3f6'
value:
  usd: 5
  whose: users
  basis: held
activity: {}
impact: funds-loss
action: Upgrade the bridge through its Safe so that executing a message also needs a post-quantum check, not only
  the validators' ECDSA signatures.
evidence_level: source
checks:
- id: impl-slot
  storage: '0x4c36d2919e407f0cc2ee3c993ccf8ac26d9ce64e'
  slot: '0x8'
  is: '0x000000000000000000000000098f51bdfb5d6d319dd4fdf06b64773d25bd1316'
  says: the proxy's implementation slot holds ForeignAMB 0x098f51bd
  for:
  - proxy_of
- id: impl-call
  call: '0x4c36d2919e407f0cc2ee3c993ccf8ac26d9ce64e'
  fn: implementation()(address)
  is: '0x098f51bdfb5d6d319dd4fdf06b64773d25bd1316'
  says: the proxy reports ForeignAMB 0x098f51bd as its implementation
  for:
  - proxy_of
- id: upgrade
  source: '0x4c36d2919e407f0cc2ee3c993ccf8ac26d9ce64e'
  file: EternalStorageProxy.sol
  lines:
  - 300
  - 301
  has: function upgradeTo(uint256 version, address implementation) public onlyUpgradeabilityOwner { _upgradeTo(version,
    implementation);
  says: the upgradeability owner can point the proxy at new code
  for:
  - action
  - justification
  - upgradeable
- id: upowner
  call: '0x4c36d2919e407f0cc2ee3c993ccf8ac26d9ce64e'
  fn: upgradeabilityOwner()(address)
  is: '0x42f38ec5a75accec50054671233dfac9c0e7a3f6'
  says: the upgradeability owner is Safe 0x42f38ec5
  for:
  - action
  - justification
  - upgradeable
- id: safe-threshold
  call: '0x42f38ec5a75accec50054671233dfac9c0e7a3f6'
  fn: getThreshold()(uint256)
  is: 8
  says: the Safe needs 8 owner signatures
  for:
  - action
- id: ecdsa
  source: '0x098f51bdfb5d6d319dd4fdf06b64773d25bd1316'
  file: Message.sol
  lines:
  - 123
  - 125
  has: address recoveredAddress = ecrecover(hash, v, r, s); require(_validatorContract.isValidator(recoveredAddress));
    require(!addressArrayContains(encounteredAddresses, recoveredAddress));
  says: each signature is recovered with ecrecover and must be a distinct listed validator
  for:
  - evidence-1
  - justification
  - what
- id: allow
  source: '0x098f51bdfb5d6d319dd4fdf06b64773d25bd1316'
  file: BasicForeignAMB.sol
  line: 94
  has: Message.hasEnoughValidSignatures(_data, _signatures, validatorContract(), true);
  says: message execution is gated by the validator signature check
  for:
  - action
  - evidence-1
  - justification
  - what
- id: exec
  source: '0x098f51bdfb5d6d319dd4fdf06b64773d25bd1316'
  file: MessageProcessor.sol
  line: 235
  has: bool status = _contract.call.gas(_gas)(_data);
  says: the bridge calls the message's executor with the message's data
  for:
  - what
- id: hashi-on
  source: '0x098f51bdfb5d6d319dd4fdf06b64773d25bd1316'
  file: BasicBridge.sol
  line: 29
  has: bool public constant HASHI_IS_ENABLED = true;
  says: Hashi is enabled, fixed in the code
  for:
  - what
- id: hashi-mgr
  call: '0x4c36d2919e407f0cc2ee3c993ccf8ac26d9ce64e'
  fn: hashiManager()(address)
  is: '0x93f6eE78451AaCc1Db1db49a12aBfCc4662B9Cc9'
  says: a Hashi manager is set
  for:
  - what
- id: hashi-send
  source: '0x098f51bdfb5d6d319dd4fdf06b64773d25bd1316'
  file: BasicBridge.sol
  lines:
  - 88
  - 89
  has: function _maybeSendDataWithHashi(bytes data) internal { if (HASHI_IS_ENABLED) {
  says: outgoing message data is also dispatched through Hashi
  for:
  - what
- id: hashi-record
  source: '0x098f51bdfb5d6d319dd4fdf06b64773d25bd1316'
  file: BasicForeignAMB.sol
  lines:
  - 134
  - 137
  has: _validateHashiMessage(chainId, threshold, sender, adapters); bytes32 hashMsg = keccak256(abi.encodePacked(data));
    require(!isApprovedByHashi(hashMsg)); _setHashiApprovalForMessage(hashMsg, true);
  says: incoming Hashi messages are validated against the manager and recorded as approved
  for:
  - what
- id: hashi-adapter
  code: '0x9c63010f056e4692a44a510f2f5e8a44b94960bf'
  is: empty
  says: Hashi's only configured adapter has no code on Ethereum
  for:
  - notes
- id: hashi-threshold
  call: '0x93f6ee78451aacc1db1db49a12abfcc4662b9cc9'
  fn: threshold()(uint256)
  is: 1
  says: Hashi's manager requires only 1 of its adapters
  for:
  - notes
- id: hashi-off
  source: '0x098f51bdfb5d6d319dd4fdf06b64773d25bd1316'
  file: BasicBridge.sol
  line: 30
  has: bool public constant HASHI_IS_MANDATORY = false;
  says: Hashi's approval is not required to execute a message, fixed in the code
  for:
  - what
- id: valset
  call: '0x4c36d2919e407f0cc2ee3c993ccf8ac26d9ce64e'
  fn: validatorContract()(address)
  is: '0xed84a648b3c51432ad0fd1c2cd2c45677e9d4064'
  says: the bridge's validator contract is 0xed84a648
  for:
  - what
- id: valcount
  call: '0xed84a648b3c51432ad0fd1c2cd2c45677e9d4064'
  fn: validatorCount()(uint256)
  is: 7
  says: the validator contract lists 7 validators
  for:
  - evidence-1
  - what
- id: req
  call: '0x4c36d2919e407f0cc2ee3c993ccf8ac26d9ce64e'
  fn: requiredSignatures()(uint256)
  is: 4
  says: 4 validator signatures are required
  for:
  - evidence-1
  - justification
  - what
- id: omni-bridge
  call: '0x88ad09518695c6c3712ac10a214be5109a655671'
  fn: bridgeContract()(address)
  is: '0x4c36d2919e407f0cc2ee3c993ccf8ac26d9ce64e'
  says: the Omnibridge uses this address as its message bridge
  for:
  - evidence-2
  - what
  - whose
- id: omni-impl
  call: '0x88ad09518695c6c3712ac10a214be5109a655671'
  fn: implementation()(address)
  is: '0x8eb3b7d8498a6716904577b2579e1c313d48e347'
  says: the Omnibridge runs ForeignOmnibridge 0x8eb3b7d8
  for:
  - what
- id: omni-mediator
  source: '0x8eb3b7d8498a6716904577b2579e1c313d48e347'
  file: ForeignOmnibridge.sol
  lines:
  - 936
  - 939
  has: function _onlyMediator() internal view { IAMB bridge = bridgeContract(); require(msg.sender == address(bridge));
    require(bridge.messageSender() == mediatorContractOnOtherSide());
  says: the Omnibridge's handlers accept calls from the bridge carrying the other side's mediator
  for:
  - evidence-2
  - what
  - whose
- id: omni-release
  source: '0x8eb3b7d8498a6716904577b2579e1c313d48e347'
  file: ForeignOmnibridge.sol
  lines:
  - 2324
  - 2331
  has: function handleNativeTokens( address _token, address _recipient, uint256 _value ) external onlyMediator {
    _ackBridgedTokenDeploy(_token); _handleTokens(_token, true, _recipient, _value);
  says: a bridge message makes the Omnibridge hand native tokens to a recipient
  for:
  - justification
  - what
  - whose
- id: omni-gno
  call: '0x6810e776880c02933d47db1b9fc05908e5386b96'
  fn: balanceOf(address)(uint256)
  args:
  - '0x88ad09518695c6c3712ac10a214be5109a655671'
  is: 1441749628120038694860329
  says: the Omnibridge holds about 1.44 million GNO
  for:
  - evidence-2
  - what
  - whose
- id: gno-symbol
  call: '0x6810e776880c02933d47db1b9fc05908e5386b96'
  fn: symbol()(string)
  is: GNO
  says: the token is GNO
  for:
  - evidence-2
  - what
- id: sigtx
  tx: '0xcfbb2d27a905b7e1e782651b35429fdbf8c040a32f2d2cfc3ff885932cb70943'
  to: '0x4c36d2919e407f0cc2ee3c993ccf8ac26d9ce64e'
  ok: true
  says: a real executeSignatures transaction went to this bridge and succeeded
  for:
  - evidence-3
  - what
- id: sel
  selector: '0x098f51bdfb5d6d319dd4fdf06b64773d25bd1316'
  fn: executeSignatures(bytes,bytes)
  says: the relay entry point that takes the signatures is in the running code
  for:
  - evidence-3
  - what
- id: omni-usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0x88ad09518695c6c3712ac10a214be5109a655671'
  is: 12941739665316
  says: the Omnibridge holds about 12.9 million USDC
  for:
  - evidence-2
  - what
- id: usdc-symbol
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: symbol()(string)
  is: USDC
  says: the token is USDC
  for:
  - evidence-2
  - what
- id: r-limit-code
  source: '0x8eb3b7d8498a6716904577b2579e1c313d48e347'
  file: ForeignOmnibridge.sol
  lines:
  - 2978
  - 2979
  has: require(withinExecutionLimit(_token, _value)); addTotalExecutedPerDay(_token, getCurrentDay(), _value);
  says: every token release from a bridge message is capped by the execution limits
  for:
  - evidence-2
  - what
- id: r-limit-fn
  source: '0x8eb3b7d8498a6716904577b2579e1c313d48e347'
  file: ForeignOmnibridge.sol
  lines:
  - 1325
  - 1330
  has: function withinExecutionLimit(address _token, uint256 _amount) public view returns (bool) { uint256 nextLimit
    = totalExecutedPerDay(_token, getCurrentDay()).add(_amount); return executionDailyLimit(address(0)) > 0 && executionDailyLimit(_token)
    >= nextLimit && _amount <= executionMaxPerTx(_token);
  says: the limit is per token, per day and per message
  for:
  - what
- id: r-gno-daily
  call: '0x88ad09518695c6c3712ac10a214be5109a655671'
  fn: executionDailyLimit(address)(uint256)
  args:
  - '0x6810e776880c02933d47db1b9fc05908e5386b96'
  is: 36000000000000000000001
  says: at most about 36,000 GNO can be released per day
  for:
  - evidence-2
  - what
- id: r-gno-max
  call: '0x88ad09518695c6c3712ac10a214be5109a655671'
  fn: executionMaxPerTx(address)(uint256)
  args:
  - '0x6810e776880c02933d47db1b9fc05908e5386b96'
  is: 36000000000000000000000
  says: at most 36,000 GNO per message
  for:
  - what
- id: r-usdc-daily
  call: '0x88ad09518695c6c3712ac10a214be5109a655671'
  fn: executionDailyLimit(address)(uint256)
  args:
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is: 35000000000000
  says: 35M USDC per day, above the 12.9M held
  for:
  - evidence-2
  - what
- id: r-usdc-max
  call: '0x88ad09518695c6c3712ac10a214be5109a655671'
  fn: executionMaxPerTx(address)(uint256)
  args:
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is: 15000000000000
  says: 15M USDC per message, above the 12.9M held
  for:
  - what
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
reviews:
- who: r-4c36d291, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-5): Gnosis''s ForeignAMB runs any message 4 of its 7 validators
    sign with ECDSA; Hashi is enabled but HASHI_IS_MANDATORY is fixed false; a forged message can release all 12.94M
    USDC from the Omnibridge in one message and GNO up to 36,000 a day; an 8-of-15 Safe can upgrade. Claude added
    the execution limits after a refuter; a fresh refuter agrees on the final card, as two did before on the rest.
    Claude read the sheet. A relay replay failing on its sender''s gas limit is noted for a possible row.'
related: []
---

## What happens

This bridge runs any message that 4 of its 7 validators sign with ECDSA. Four keys recovered from public signatures can forge Omnibridge payouts: all 12.9 million USDC in one message, GNO up to 36,000 a day. Hashi is enabled and records messages, but a message runs without its approval.

## Evidence

- [The signature check](https://etherscan.io/address/0x098f51bdfb5d6d319dd4fdf06b64773d25bd1316#code) recovers each signature with ecrecover and needs 4 distinct listed validators out of 7.
- [The Omnibridge](https://etherscan.io/address/0x88ad09518695c6c3712ac10a214be5109a655671#code) takes its messages from this bridge and holds 1.44 million GNO and 12.9 million USDC, released within per-token daily limits.
- [A real transaction](https://etherscan.io/tx/0xcfbb2d27a905b7e1e782651b35429fdbf8c040a32f2d2cfc3ff885932cb70943) calls executeSignatures on this bridge and succeeds, so validator signatures are public on Ethereum.

## Reviewer notes

### Mechanism

The address is an EternalStorageProxy whose implementation (slot 8) is ForeignAMB 0x098f51bd. executeSignatures calls Message.hasEnoughValidSignatures (Message.sol 95-128): requiredSignatures() rounds of ecrecover, each recovered address must pass validatorContract().isValidator and be distinct. The validator contract 0xed84a648 lists 7 validators and requires 4. _executeMessage (108-124) requires Hashi's approval only if HASHI_IS_ENABLED && HASHI_IS_MANDATORY. HASHI_IS_ENABLED is true and hashiManager() returns a live manager (0x93f6ee78): outgoing data is dispatched through Hashi (BasicBridge.sol 88-92) and incoming Hashi messages are validated and recorded as approved (onMessage, BasicForeignAMB.sol 134-137); HASHI_IS_MANDATORY is the constant false (BasicBridge.sol 30), so that approval is never required to execute. processMessage then calls the executor with the message data (MessageProcessor.sol 235). The Omnibridge 0x88ad0951 (implementation 0x8eb3b7d8) names this AMB as bridgeContract(); its onlyMediator handlers accept calls from this AMB carrying the other side's mediator, and release tokens to the recipient; it holds 1.44M GNO and 12.9M USDC. Validator signatures are posted on Ethereum in relay calldata, so their public keys are public. upgradeTo is onlyUpgradeabilityOwner, Safe 0x42f38ec5; the Safe also owns the validator contract and the Omnibridge.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for validators: hasEnoughValidSignatures has none (Message.sol 111-127).
- Ruled out: a fix by setting: HASHI_IS_MANDATORY is a compile-time constant, so making Hashi required needs an upgrade; rotating validators to new keys does not help once old keys sign on-chain.
- Ruled out: Hashi already stopping a forged message without ECDSA: its only adapter has no code on Ethereum and its threshold is 1, so a required-Hashi upgrade needs a real adapter set first, not just flipping HASHI_IS_MANDATORY.
- Ruled out: unused implementation: isInitialized() is true, the Omnibridge names this address as its bridgeContract, and a real executeSignatures transaction against it succeeded; the tool's empty proxy_of is only because the implementation sits in slot 8, not an EIP-1967 slot.
- Ruled out: the value shown is only what this address holds (about $5 of DAI dust); the money at stake sits in the Omnibridge 0x88ad0951, priced here in GNO and USDC, the full escrow was not priced.
- Ruled out: the dossier scan.recovered and scan.families replays for this family (including the sender 0xb54b5572 tx) point to a real target 0x9a873656c19efecbfb4f9fab5b7acdeab6a0b0, an unrelated ERC1967Proxy sharing only a 4-byte selector, not evidence about this contract; this card cites sigtx, a transaction read directly against this address, instead.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
