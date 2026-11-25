---
id: eternalstorageproxy-d0764fae-validator-signatures
format: 2
title: Forged validator signatures could release tokens locked by a PulseChain bridge
status: confirmed
severity: MEDIUM
justification: Five forged validator keys release the escrow; one account can fix it by upgrading the bridge's code.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd0764fae29e0a6a96ff685f71cfc685456d5636c'
  name: EternalStorageProxy
  code: verified
  code_url: https://etherscan.io/address/0xe98699957d3504acd57fff861e4b77b57eb02467#code
  proxy_of: '0xe98699957d3504acd57fff861e4b77b57eb02467'
  copies: 1
  upgradeable: 'yes'
  admin: '0x0fb17adb94627eea37bb7ef12f85ab4590e3805f'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 27412
impact: funds-loss
action: Upgrade the bridge to check validator messages with a post-quantum scheme; new ECDSA validator keys would
  stay forgeable.
evidence_level: source
checks:
- id: ecrec
  source: '0xe98699957d3504acd57fff861e4b77b57eb02467'
  file: ForeignAMB.sol
  line: 134
  has: address recoveredAddress = ecrecover(hash, v, r, s);
  says: each validator signature on a message is recovered with ecrecover (ECDSA)
  for:
  - action
  - evidence-1
  - what
- id: isval
  source: '0xe98699957d3504acd57fff861e4b77b57eb02467'
  file: ForeignAMB.sol
  line: 135
  has: require(_validatorContract.isValidator(recoveredAddress));
  says: each recovered address must be listed by the validator contract
  for:
  - evidence-1
  - what
- id: reqloop
  source: '0xe98699957d3504acd57fff861e4b77b57eb02467'
  file: ForeignAMB.sol
  line: 113
  has: uint256 requiredSignatures = _validatorContract.requiredSignatures();
  says: the number of signatures checked is the validator contract's requiredSignatures
  for:
  - evidence-1
  - what
- id: dedupe
  source: '0xe98699957d3504acd57fff861e4b77b57eb02467'
  file: ForeignAMB.sol
  line: 136
  has: require(!addressArrayContains(encounteredAddresses, recoveredAddress));
  says: the recovered validators must all be different
  for:
  - what
- id: execpub
  source: '0xe98699957d3504acd57fff861e4b77b57eb02467'
  file: ForeignAMB.sol
  line: 1514
  has: function executeSignatures(bytes _data, bytes _signatures) public {
  says: anyone can relay a message with its signatures; they are passed in calldata
  for:
  - what
- id: allow
  source: '0xe98699957d3504acd57fff861e4b77b57eb02467'
  file: ForeignAMB.sol
  line: 1584
  has: Message.hasEnoughValidSignatures(_data, _signatures, validatorContract(), true);
  says: every relay path checks the signatures against the validator contract
  for:
  - what
- id: unpack
  source: '0xe98699957d3504acd57fff861e4b77b57eb02467'
  file: ForeignAMB.sol
  line: 1525
  has: (msgId, sender, executor, gasLimit, dataType, chainIds, data) = ArbitraryMessage.unpackData(_data);
  says: sender, executor and call data all come from the signed message
  for:
  - what
- id: setsender
  source: '0xe98699957d3504acd57fff861e4b77b57eb02467'
  file: ForeignAMB.sol
  line: 1323
  has: setMessageSender(_sender);
  says: the bridge records the message's sender for the executor to read
  for:
  - what
- id: callexec
  source: '0xe98699957d3504acd57fff861e4b77b57eb02467'
  file: ForeignAMB.sol
  line: 1339
  has: bool status = _contract.call.gas(_gas)(_data);
  says: the bridge calls the executor named in the message with the message's data
  for:
  - what
- id: vcinit
  source: '0xe98699957d3504acd57fff861e4b77b57eb02467'
  file: ForeignAMB.sol
  lines:
  - 905
  - 909
  has: addressStorage[VALIDATOR_CONTRACT] = _validatorContract;
  says: the validator contract is set only in initialize, which runs once
  for:
  - notes
- id: init
  call: '0xd0764fae29e0a6a96ff685f71cfc685456d5636c'
  fn: isInitialized()(bool)
  is: true
  says: this address is initialized with its own state
  for:
  - notes
- id: impl
  call: '0xd0764fae29e0a6a96ff685f71cfc685456d5636c'
  fn: implementation()(address)
  is: '0xe98699957d3504acd57fff861e4b77b57eb02467'
  says: the proxy runs the ForeignAMB code at 0xe9869995
  for:
  - evidence-1
  - proxy_of
- id: uowner
  call: '0xd0764fae29e0a6a96ff685f71cfc685456d5636c'
  fn: upgradeabilityOwner()(address)
  is: '0xdf5d165a7eb95d26355c56d53799b7da1240e585'
  says: the account that can upgrade the bridge's code
  for:
  - action
  - evidence-3
  - justification
  - upgradeable
- id: uocode
  code: '0xdf5d165a7eb95d26355c56d53799b7da1240e585'
  is: empty
  says: the upgradeability owner is an account with no code
  for:
  - evidence-3
  - justification
- id: upgto
  source: '0xd0764fae29e0a6a96ff685f71cfc685456d5636c'
  file: EternalStorageProxy.sol
  line: 300
  has: function upgradeTo(uint256 version, address implementation) public onlyUpgradeabilityOwner {
  says: upgradeTo replaces the code behind the proxy
  for:
  - action
  - evidence-3
  - justification
  - upgradeable
- id: onlyuo
  source: '0xd0764fae29e0a6a96ff685f71cfc685456d5636c'
  file: EternalStorageProxy.sol
  line: 280
  has: require(msg.sender == upgradeabilityOwner());
  says: only the upgradeability owner can call upgradeTo
  for:
  - action
  - evidence-3
  - justification
  - upgradeable
- id: vcontract
  call: '0xd0764fae29e0a6a96ff685f71cfc685456d5636c'
  fn: validatorContract()(address)
  is: '0x2fa878ab3f87cc1c9737fc071108f904c0b0c95d'
  says: the validator contract the bridge asks
  for:
  - evidence-1
- id: reqsig
  call: '0xd0764fae29e0a6a96ff685f71cfc685456d5636c'
  fn: requiredSignatures()(uint256)
  is: 5
  says: 5 validator signatures are required per message
  for:
  - evidence-1
  - justification
  - what
- id: vcount
  call: '0x2fa878ab3f87cc1c9737fc071108f904c0b0c95d'
  fn: validatorCount()(uint256)
  is: 8
  says: the validator contract lists 8 validators
  for:
  - evidence-1
  - what
- id: srcchain
  call: '0xd0764fae29e0a6a96ff685f71cfc685456d5636c'
  fn: sourceChainId()(uint256)
  is: 1
  says: this side of the bridge is Ethereum, chain 1
  for:
  - what
- id: dest
  call: '0xd0764fae29e0a6a96ff685f71cfc685456d5636c'
  fn: destinationChainId()(uint256)
  is: 369
  says: the other side of the bridge is chain 369
  for:
  - what
- id: chain369
  ref: https://github.com/ethereum-lists/chains/blob/54c599bfd40a6df6812fc4d130bde2d9162a7f47/_data/chains/eip155-369.json
  says: the public chain list names chain 369 PulseChain
  for:
  - what
- id: relay
  tx: '0xd7eb7767d5280f41106e9a5a8f02da6e8544c7be0acb013f7e6b56b4eb1779be'
  to: '0xd0764fae29e0a6a96ff685f71cfc685456d5636c'
  ok: true
  says: a real relay with validator signatures sent to this bridge succeeded
  for:
  - what
- id: obbridge
  call: '0x1715a3e4a142d8b698131108995174f37aeba10d'
  fn: bridgeContract()(address)
  is: '0xd0764fae29e0a6a96ff685f71cfc685456d5636c'
  says: the Omnibridge at 0x1715a3e4 takes its messages from this bridge
  for:
  - evidence-2
  - what
- id: obimpl
  call: '0x1715a3e4a142d8b698131108995174f37aeba10d'
  fn: implementation()(address)
  is: '0xb7df1e00ae030e966e635ede273625240546b873'
  says: the Omnibridge runs the ForeignOmnibridge code at 0xb7df1e00
  for:
  - evidence-2
- id: onlymed
  source: '0xb7df1e00ae030e966e635ede273625240546b873'
  file: ForeignOmnibridge.sol
  line: 939
  has: require(bridge.messageSender() == mediatorContractOnOtherSide());
  says: the Omnibridge only checks that the bridge reports its mediator as the message sender
  for:
  - evidence-2
  - what
- id: native
  source: '0xb7df1e00ae030e966e635ede273625240546b873'
  file: ForeignOmnibridge.sol
  lines:
  - 2312
  - 2319
  has: _handleTokens(_token, true, _recipient, _value);
  says: handleNativeTokens, behind onlyMediator, releases tokens to the recipient the message names
  for:
  - evidence-2
  - justification
  - what
- id: release
  source: '0xb7df1e00ae030e966e635ede273625240546b873'
  file: ForeignOmnibridge.sol
  line: 2935
  has: _releaseTokens(_isNative, _token, _recipient, _value, _value);
  says: the Omnibridge pays the tokens out of what it holds
  for:
  - what
- id: usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0x1715a3e4a142d8b698131108995174f37aeba10d'
  is: 11421909336261
  says: the Omnibridge holds 11,421,909.34 USDC
  for:
  - evidence-2
  - what
- id: usdcdec
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: decimals()(uint8)
  is: 6
  says: USDC has 6 decimals
  for:
  - evidence-2
- id: dai
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: balanceOf(address)(uint256)
  args:
  - '0x1715a3e4a142d8b698131108995174f37aeba10d'
  is: 10408627210930690522325605
  says: the Omnibridge holds about 10,408,627 DAI
  for:
  - evidence-2
  - what
- id: daidec
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: decimals()(uint8)
  is: 18
  says: DAI has 18 decimals
  for:
  - evidence-2
- id: weth
  call: '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
  fn: balanceOf(address)(uint256)
  args:
  - '0x1715a3e4a142d8b698131108995174f37aeba10d'
  is: 4051220120644765119415
  says: the Omnibridge holds about 4,051 WETH
  for:
  - evidence-2
- id: wethdec
  call: '0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
  fn: decimals()(uint8)
  is: 18
  says: WETH has 18 decimals
  for:
  - evidence-2
- id: usdt
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0x1715a3e4a142d8b698131108995174f37aeba10d'
  is: 3789148751887
  says: the Omnibridge holds 3,789,148.75 USDT
  for:
  - evidence-2
- id: usdtdec
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: decimals()(uint256)
  is: 6
  says: USDT has 6 decimals
  for:
  - evidence-2
- id: limitchk
  source: '0xb7df1e00ae030e966e635ede273625240546b873'
  file: ForeignOmnibridge.sol
  line: 2932
  has: require(withinExecutionLimit(_token, _value));
  says: each release is checked against the token's execution limits
  for:
  - notes
- id: usdclimit
  call: '0x1715a3e4a142d8b698131108995174f37aeba10d'
  fn: executionDailyLimit(address)(uint256)
  args:
  - '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  is: 1000000000000000000
  says: the USDC daily execution limit is 10^18 base units, far above the USDC held
  for:
  - notes
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
reviews:
- who: r-d0764fae, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: The Ethereum side of a PulseChain bridge (an upgradeable proxy) executes a message once 5 of its
    8 validators sign it with ECDSA; all eight are code-less; its Omnibridge then pays out locked tokens (11.42M
    USDC, 10.41M DAI, 4,051 WETH, 3.79M USDT) with execution limits far above its balances. MEDIUM, PQ-5: five forged
    validator keys release the escrow; the upgradeability owner, one code-less account that has sent no transaction,
    can replace the code. Author A-d0764fae; refuter R-d0764fae agreed with no objection; the reader changed nothing.
    The header shows nothing held because the tokens sit in the Omnibridge. The dossier''s replay 0x7657de29 (works
    today, reverts under EIP-8151 alone) was sent to another address and is routed as a gas-limit lead, not cited
    here.'
related: []
---

## What happens

This bridge between Ethereum and PulseChain executes a message once 5 of its 8 validators sign it with ECDSA. Relays publish those signatures, so a quantum computer could derive five keys and forge a message. Its Omnibridge then releases locked tokens to whoever the message names.

## Evidence

- [The bridge's code](https://etherscan.io/address/0xe98699957d3504acd57fff861e4b77b57eb02467#code) recovers each signature with ecrecover and accepts it if the validator contract lists it; that contract lists 8 and requires 5.
- [The Omnibridge](https://etherscan.io/address/0x1715a3e4a142d8b698131108995174f37aeba10d#code) it serves pays out on a message from this bridge that names its mediator; it holds 11.42M USDC, 10.41M DAI, 4,051 WETH and 3.79M USDT.
- The bridge is a proxy: [its upgradeability owner](https://etherscan.io/address/0xd0764fae29e0a6a96ff685f71cfc685456d5636c#code), one account with no code, can replace its code with upgradeTo.

## Reviewer notes

### Mechanism

EternalStorageProxy; implementation() and slot 8 give the ForeignAMB code at 0xe9869995. executeSignatures and the safeExecuteSignatures* wrappers are public and run Message.hasEnoughValidSignatures (lines 106-139): for requiredSignatures() entries, ecrecover, isValidator(recovered), no repeats. Validator contract 0x2fa878ab: 8 validators, 5 required. _executeMessage checks only version, destination chain id and replay; _passMessage sets messageSender to the signed sender and calls the signed executor with the signed data (lines 1315-1345). ForeignOmnibridge proxy 0x1715a3e4 (code 0xb7df1e00) has bridgeContract() = this address; onlyMediator (lines 936-940) requires msg.sender = bridge and messageSender = mediatorContractOnOtherSide; handleNativeTokens releases escrow to the message's recipient within execution limits (lines 2922-2938). Fix: upgradeTo by upgradeabilityOwner 0xdf5d165a (no code, nonce 0, presumed live).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: no proxy per the tool: not EIP-1967; implementation() and slot 8 (_implementation) give 0xe9869995, verified ForeignAMB.
- Ruled out: unused implementation: 0x6e0c69b5 holds this address in neither slot 8 nor the EIP-1967 slot; this address is initialized and a real relay to it succeeded.
- Ruled out: ERC-1271 or another path: hasEnoughValidSignatures only uses ecrecover and isValidator; every relay function calls it (line 1584).
- Ruled out: rotating validators: owner 0x3ea02ef8 can change the set, but new keys are still ECDSA and exposed once they sign a relay.
- Ruled out: swapping the validator contract by a setting: set only in initialize (lines 905-909), which runs once.
- Ruled out: execution limits: daily limits for USDC, USDT (10^18 units), DAI and WETH (10^30) are far above the balances.
- Ruled out: value: this address holds nothing; the Omnibridge's tokens are given as amounts. Omnibridge 0xe20e337d and other executors not read.
- Ruled out: EIP-8151: the dossier's replay 0x7657de29 (to 0xf700e0c1, not this address) reverts under EIP-8151; calls not read, not cited; left to the main reviewer as a possible sender-gas-limits row.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
