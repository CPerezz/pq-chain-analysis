---
id: custodian-1789cca7-fixed-signer
format: 2
title: Retired Gemini dollar custodian refuses signers whose accounts take real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if signers move to real code; the set is fixed and the limiter it serves is retired.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb'
  name: Custodian
  code: verified
  code_url: https://etherscan.io/address/0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb#code
  copies: 2
  family: 896bf7be63d1b53fd4f559ab048ff938
  upgradeable: 'no'
value:
  usd: 0
  whose: operator
  basis: held
activity: {}
impact: liveness
action: Move the old logic's custodian off the limiter with confirmCustodianChangeProxy while two signers can sign;
  no function replaces a signer.
evidence_level: source
checks:
- id: ecrec1
  source: '0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb'
  file: Custodian.sol
  line: 249
  has: address signer1 = ecrecover(_requestMsgHash, _recoveryByte1, _ecdsaR1, _ecdsaS1);
  says: the first signature is recovered with ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: set1
  source: '0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb'
  file: Custodian.sol
  lines:
  - 250
  - 253
  has: require(signerSet[signer2]);
  says: each recovered address must be in the signer set
  for:
  - evidence-1
  - what
- id: distinct
  source: '0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb'
  file: Custodian.sol
  line: 254
  has: require(signer1 != signer2);
  says: the two signers must differ
  for:
  - evidence-1
  - what
- id: callback
  source: '0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb'
  file: Custodian.sol
  line: 275
  has: success = callbackAddress.call(callbackSelector, lockId);
  says: a completed request calls back the co-operating contract
  for:
  - action
  - what
- id: ctor
  source: '0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb'
  file: Custodian.sol
  lines:
  - 135
  - 139
  has: signerSet[_signers[i]] = true;
  says: the constructor writes the signer set
  for:
  - action
  - justification
  - what
- id: code
  code: '0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb'
  is: contract
  bytes: 3037
  says: the contract's own code runs here, 3,037 bytes
  for:
  - notes
- id: reqcount
  call: '0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb'
  fn: requestCount()(uint256)
  is: 12
  says: 12 unlock requests were made at this address
  for:
  - notes
- id: copyreq
  call: '0x9a7b5f6e453d0cda978163cb4a9a88367250a52d'
  fn: requestCount()(uint256)
  is: 8
  says: 8 unlock requests were made at the copy
  for:
  - notes
- id: primary
  call: '0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb'
  fn: signerSet(address)(bool)
  args:
  - '0xd24400ae8bfebb18ca49be86258a3c749cf46853'
  is: false
  says: the primary account is not a signer
  for:
  - notes
- id: plcust
  call: '0x72519fa6cd095c99d5d67e31ddc117409bc5c047'
  fn: custodian()(address)
  is: '0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb'
  says: the print limiter's custodian is this address
  for:
  - action
  - evidence-2
  - what
  - whose
- id: plimpl
  call: '0x72519fa6cd095c99d5d67e31ddc117409bc5c047'
  fn: erc20Impl()(address)
  is: '0x6704ba24b8640bccee6bf2fd276a6a1b8edf4ade'
  says: the print limiter governs the old token logic
  for:
  - evidence-2
  - justification
  - what
  - whose
- id: oldproxy
  call: '0x6704ba24b8640bccee6bf2fd276a6a1b8edf4ade'
  fn: erc20Proxy()(address)
  is: '0x056fd409e1d7a124bd7017459dfea2f387b6d5cd'
  says: that old logic belongs to the Gemini dollar proxy
  for:
  - what
  - whose
- id: symbol
  call: '0x056fd409e1d7a124bd7017459dfea2f387b6d5cd'
  fn: symbol()(string)
  is: GUSD
  says: the proxy is Gemini dollar
  for:
  - notes
- id: lastdone
  call: '0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb'
  fn: lastCompletedIdxs(address,bytes4)(uint256)
  args:
  - '0x72519fa6cd095c99d5d67e31ddc117409bc5c047'
  - '0x12460fdd'
  is: 9
  says: requests calling confirmCeilingRaise on the limiter completed here, up to request 9
  for:
  - what
- id: proxyimpl
  call: '0x056fd409e1d7a124bd7017459dfea2f387b6d5cd'
  fn: erc20Impl()(address)
  is: '0x483a1e7f16f46266400f1baf7abdf445c8d140a2'
  says: Gemini dollar now uses other token logic
  for:
  - evidence-2
  - justification
  - what
- id: storeimpl
  call: '0xc42b14e49744538e3c239f8ae48a1eaaf35e68a0'
  fn: erc20Impl()(address)
  is: '0x483a1e7f16f46266400f1baf7abdf445c8d140a2'
  says: the store also points to the new logic
  for:
  - what
- id: newpl
  call: '0x483a1e7f16f46266400f1baf7abdf445c8d140a2'
  fn: custodian()(address)
  is: '0x342c1b88c2108f159a4ef37e322b4170b18c42f6'
  says: the new logic answers to another print limiter
  for:
  - notes
- id: proxycust
  call: '0x056fd409e1d7a124bd7017459dfea2f387b6d5cd'
  fn: custodian()(address)
  is: '0x39dc6ed3e8d762f69a84aacbd31c4ee872b0699c'
  says: the proxy's current custodian
  for:
  - what
- id: curcode
  code: '0x39dc6ed3e8d762f69a84aacbd31c4ee872b0699c'
  is: empty
  says: the current custodian is an account without code
  for:
  - notes
- id: implchange
  selector: '0x056fd409e1d7a124bd7017459dfea2f387b6d5cd'
  fn: confirmImplChange(bytes32)
  says: the proxy has a function to change its token logic
  for:
  - what
- id: onlycust
  source: '0x6704ba24b8640bccee6bf2fd276a6a1b8edf4ade'
  file: ERC20Impl.sol
  lines:
  - 223
  - 224
  has: function confirmImplChange(bytes32 _lockId) public onlyCustodian {
  says: confirmImplChange, callable only by the custodian, sets the token logic (shared upgrade code)
  for:
  - what
- id: copyproxy
  call: '0x9a7b5f6e453d0cda978163cb4a9a88367250a52d'
  fn: lastCompletedIdxs(address,bytes4)(uint256)
  args:
  - '0x056fd409e1d7a124bd7017459dfea2f387b6d5cd'
  - '0x3a8343ee'
  is: 7
  says: the copy confirmed custodian changes on the proxy
  for:
  - notes
- id: pprint
  source: '0x72519fa6cd095c99d5d67e31ddc117409bc5c047'
  file: PrintLimiter.sol
  lines:
  - 1205
  - 1206
  has: erc20Impl.confirmPrint(_lockId);
  says: confirmPrintProxy, for the custodian only, confirms a print on the token logic with no ceiling check
  for:
  - evidence-2
  - what
- id: pceil
  source: '0x72519fa6cd095c99d5d67e31ddc117409bc5c047'
  file: PrintLimiter.sol
  lines:
  - 1155
  - 1168
  has: totalSupplyCeiling = newCeiling;
  says: confirmCeilingRaise, for the custodian only, raises the print ceiling
  for:
  - evidence-2
  - what
- id: pcustx
  source: '0x72519fa6cd095c99d5d67e31ddc117409bc5c047'
  file: PrintLimiter.sol
  lines:
  - 1222
  - 1223
  has: erc20Impl.confirmCustodianChange(_lockId);
  says: confirmCustodianChangeProxy, for the custodian only, confirms a custodian change on the token logic
  for:
  - action
  - evidence-2
  - what
- id: implcc
  source: '0x6704ba24b8640bccee6bf2fd276a6a1b8edf4ade'
  file: ERC20Impl.sol
  lines:
  - 119
  - 120
  has: custodian = getCustodianChangeReq(_lockId);
  says: confirming a custodian change replaces the old logic's custodian
  for:
  - action
- id: reqcc
  source: '0x6704ba24b8640bccee6bf2fd276a6a1b8edf4ade'
  file: ERC20Impl.sol
  line: 99
  has: function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
  says: anyone can request a custodian change on the old logic
  for:
  - action
- id: oldcust
  call: '0x6704ba24b8640bccee6bf2fd276a6a1b8edf4ade'
  fn: custodian()(address)
  is: '0x72519fa6cd095c99d5d67e31ddc117409bc5c047'
  says: the old token logic's custodian is the print limiter
  for:
  - action
  - evidence-2
  - what
- id: doneprint
  call: '0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb'
  fn: lastCompletedIdxs(address,bytes4)(uint256)
  args:
  - '0x72519fa6cd095c99d5d67e31ddc117409bc5c047'
  - '0x8cbf4145'
  is: 0
  says: no confirmPrintProxy request on the limiter ever completed here
  for:
  - what
- id: donecust
  call: '0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb'
  fn: lastCompletedIdxs(address,bytes4)(uint256)
  args:
  - '0x72519fa6cd095c99d5d67e31ddc117409bc5c047'
  - '0x051d9955'
  is: 0
  says: no confirmCustodianChangeProxy request on the limiter ever completed here
  for:
  - what
- id: waterline
  source: '0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb'
  file: Custodian.sol
  line: 270
  has: lastCompletedIdxs[callbackAddress][callbackSelector] = request.idx;
  says: every completed request records its index per callback target and function
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: MEDIUM
reviews: []
related: []
---

## What happens

Two signers of a fixed set confirm uncapped prints, ceiling raises and custodian changes on Gemini dollar's old logic; only raises completed. Gemini dollar no longer uses that logic; its custodian can restore it. Signers whose accounts take real code stop counting; EIP-7702 delegations still do.

## Evidence

- [completeUnlock](https://etherscan.io/address/0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb#code) recovers both signatures with ecrecover and requires two distinct signers from the set.
- The [print limiter](https://etherscan.io/address/0x72519fa6cd095c99d5d67e31ddc117409bc5c047#code), whose custodian this is, raises its own print ceiling and passes prints and custodian changes to logic [Gemini dollar](https://etherscan.io/address/0x056fd409e1d7a124bd7017459dfea2f387b6d5cd#code) no longer uses.

## Reviewer notes

### Mechanism

completeUnlock (lines 228-283) recovers signer1 and signer2 with ecrecover (249, 252), requires signerSet of each and signer1 != signer2 (250, 253, 254), then calls callbackAddress.call(callbackSelector, lockId) (275). signerSet is written only in the constructor (135-139); no proxy. Callback target: PrintLimiter 0x72519fa6cd095c99d5d67e31ddc117409bc5c047 has custodian() = this address and erc20Impl() = 0x6704ba24b8640bccee6bf2fd276a6a1b8edf4ade; lastCompletedIdxs(PrintLimiter, confirmCeilingRaise) = 9 of requestCount 12. That ERC20Impl's erc20Proxy() is GUSD 0x056fd409e1d7a124bd7017459dfea2f387b6d5cd and erc20Store() is 0xc42b14e49744538e3c239f8ae48a1eaaf35e68a0; but the proxy and the store now have erc20Impl() = 0x483a1e7f16f46266400f1baf7abdf445c8d140a2 and custodian() = 0x39dc6ed3e8d762f69a84aacbd31c4ee872b0699c, an account without code. Through the PrintLimiter this address confirms confirmPrintProxy (uncapped print, 1205-1206), confirmCeilingRaise (1155-1168) and confirmCustodianChangeProxy (1222-1223); lastCompletedIdxs: 0, 9, 0. While retired, a print reverts (the store's setTotalSupply is onlyImpl, 963, and the store names the new logic); a custodian change on the old logic still works. GUSD's custodian can restore the old logic via confirmImplChange.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-size path for signers with code: completeUnlock has none (lines 249-254).
- Ruled out: a setter or upgrade that replaces the signer set: signerSet is assigned only at line 138 in the constructor; the contract has no DELEGATECALL (tool facts).
- Ruled out: a path that completes without two signatures: the callback at line 275 is reached only after lines 249-254.
- Ruled out: a rated issue: ecrecover is called through Solidity 0.4 with all gas forwarded, no fixed gas amount; the signature is not relied on by another party before being checked.
- Ruled out: the primary 0xd244...6853 as a signer: signerSet(primary) is false at the block; primary is an account without code.
- Ruled out: this being Gemini dollar's live custodian: the GUSD proxy and store name custodian 0x39dc6ed3… and logic 0x483a1e7f…, whose custodian is 0x342c1b88…; neither is this address.
- Ruled out: the copy 0x9a7b5f6e… as a separate live dependency: its completed callbacks went to the GUSD proxy (7) and store (8) confirmCustodianChange, and both now name 0x39dc6ed3… as custodian; it is a former GUSD custodian and gets its own row.

### Questions

- Who holds the signer keys, how many are there, and does any already hold real code? The set is a mapping and cannot be listed from state; the constructor arguments of the creation transaction or the signers in Completed events are needed.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
