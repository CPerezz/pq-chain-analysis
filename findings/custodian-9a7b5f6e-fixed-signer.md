---
id: custodian-9a7b5f6e-fixed-signer
format: 2
title: Retired Gemini dollar custodian stalls if its signers move to real code
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless Gemini restores this retired custodian and its signers move their accounts
  to real code.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9a7b5f6e453d0cda978163cb4a9a88367250a52d'
  name: Custodian
  code: verified
  code_url: https://etherscan.io/address/0x9a7b5f6e453d0cda978163cb4a9a88367250a52d#code
  copies: 2
  family: 896bf7be63d1b53fd4f559ab048ff938
  upgradeable: 'no'
value:
  usd: 0
  whose: operator
  basis: held
activity: {}
impact: liveness
action: 'Keep this custodian retired, or deploy a new one before any of its signers moves to real code: its signer
  set cannot change.'
evidence_level: source
checks:
- id: author
  source: '0x9a7b5f6e453d0cda978163cb4a9a88367250a52d'
  file: Custodian.sol
  line: 21
  has: '@author  Gemini Trust Company, LLC'
  says: the verified source names Gemini Trust Company as author
  for:
  - what
  - whose
- id: rec1
  source: '0x9a7b5f6e453d0cda978163cb4a9a88367250a52d'
  file: Custodian.sol
  lines:
  - 249
  - 250
  has: address signer1 = ecrecover(_requestMsgHash, _recoveryByte1, _ecdsaR1, _ecdsaS1);
  says: the first signature is recovered with ecrecover and must be in the signer set
  for:
  - evidence-1
  - justification
  - what
- id: rec2
  source: '0x9a7b5f6e453d0cda978163cb4a9a88367250a52d'
  file: Custodian.sol
  lines:
  - 252
  - 254
  has: address signer2 = ecrecover(_requestMsgHash, _recoveryByte2, _ecdsaR2, _ecdsaS2);
  says: the second signature is recovered with ecrecover, must be in the set and differ from the first
  for:
  - evidence-1
  - what
- id: fixed
  source: '0x9a7b5f6e453d0cda978163cb4a9a88367250a52d'
  file: Custodian.sol
  line: 138
  has: signerSet[_signers[i]] = true;
  says: the signer set is written only in the constructor
  for:
  - action
  - evidence-1
  - justification
  - what
- id: callback
  source: '0x9a7b5f6e453d0cda978163cb4a9a88367250a52d'
  file: Custodian.sol
  line: 275
  has: success = callbackAddress.call(callbackSelector, lockId);
  says: a completed unlock only calls back the co-operating contract; the custodian moves nothing itself
  for:
  - whose
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x9a7b5f6e453d0cda978163cb4a9a88367250a52d'
  is: 0
  says: the custodian holds no ETH
  for:
  - whose
- id: handover-proxy
  call: '0x9a7b5f6e453d0cda978163cb4a9a88367250a52d'
  fn: lastCompletedIdxs(address,bytes4)(uint256)
  args:
  - '0x056fd409e1d7a124bd7017459dfea2f387b6d5cd'
  - '0x3a8343ee'
  is: 7
  says: request 7 completed confirmCustodianChange on the GUSD proxy
  for:
  - what
- id: handover-store
  call: '0x9a7b5f6e453d0cda978163cb4a9a88367250a52d'
  fn: lastCompletedIdxs(address,bytes4)(uint256)
  args:
  - '0xc42b14e49744538e3c239f8ae48a1eaaf35e68a0'
  - '0x3a8343ee'
  is: 8
  says: request 8 completed confirmCustodianChange on the GUSD store
  for:
  - what
- id: count
  call: '0x9a7b5f6e453d0cda978163cb4a9a88367250a52d'
  fn: requestCount()(uint256)
  is: 8
  says: the custodian has made 8 requests in all, so request 8 was its last
  for:
  - notes
- id: cust-proxy
  call: '0x056fd409e1d7a124bd7017459dfea2f387b6d5cd'
  fn: custodian()(address)
  is: '0x39dC6ED3e8D762F69A84AaCBD31c4ee872b0699c'
  says: the GUSD proxy's custodian is now another address
  for:
  - action
  - evidence-2
  - justification
  - what
- id: cust-store
  call: '0xc42b14e49744538e3c239f8ae48a1eaaf35e68a0'
  fn: custodian()(address)
  is: '0x39dC6ED3e8D762F69A84AaCBD31c4ee872b0699c'
  says: the GUSD store's custodian is now another address
  for:
  - justification
  - what
- id: newcust-code
  code: '0x39dc6ed3e8d762f69a84aacbd31c4ee872b0699c'
  is: empty
  says: the current custodian is an account without code
  for:
  - evidence-2
- id: newcust-nonce
  nonce: '0x39dc6ed3e8d762f69a84aacbd31c4ee872b0699c'
  is: 2
  says: 'the current custodian has sent transactions: a live key'
  for:
  - evidence-2
- id: gusd-name
  call: '0x056fd409e1d7a124bd7017459dfea2f387b6d5cd'
  fn: name()(string)
  is: Gemini dollar
  says: the proxy is the Gemini dollar token
  for:
  - notes
- id: request-proxy
  source: '0x056fd409e1d7a124bd7017459dfea2f387b6d5cd'
  file: .sol
  lines:
  - 99
  - 104
  has: function requestCustodianChange(address _proposedCustodian) public returns (bytes32 lockId) {
  says: anyone can propose a new custodian on the GUSD proxy
  for:
  - evidence-2
  - what
- id: confirm-proxy
  source: '0x056fd409e1d7a124bd7017459dfea2f387b6d5cd'
  file: .sol
  lines:
  - 119
  - 120
  has: custodian = getCustodianChangeReq(_lockId);
  says: confirmCustodianChange, callable only by the current custodian, installs the proposed custodian
  for:
  - action
  - evidence-2
  - justification
  - what
- id: only-custodian
  source: '0x056fd409e1d7a124bd7017459dfea2f387b6d5cd'
  file: .sol
  line: 83
  has: require(msg.sender == custodian);
  says: onlyCustodian lets only the current custodian confirm
  for:
  - notes
- id: confirm-store
  source: '0xc42b14e49744538e3c239f8ae48a1eaaf35e68a0'
  file: ERC20Store.sol
  lines:
  - 119
  - 120
  has: custodian = getCustodianChangeReq(_lockId);
  says: the GUSD store has the same custodian change by its current custodian
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-9a7b5f6e, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: INFORMATIONAL notice (PQ-17), dormant: a retired Gemini dollar custodian whose six signers are fixed
    in its constructor (no setter, no ERC-1271); GUSD''s proxy and store now name another custodian, a live key
    that could point custody back here with one confirmation (D-028 rule 4, consistent with the settled copy 0x1789cca7).
    Author''s not-affected reversed by Claude; two refuters agree on the notice; Claude read the sheet.'
related: []
---

## What happens

This Gemini dollar custodian completes a request when two of its signers sign, and its signer set is fixed. It is retired: GUSD now names another custodian, which can point custody back here. A signer whose account takes real code stops counting; an EIP-7702 delegation keeps working.

## Evidence

- [completeUnlock](https://etherscan.io/address/0x9a7b5f6e453d0cda978163cb4a9a88367250a52d#code) recovers two signatures with ecrecover and accepts only signers set at deployment.
- [GUSD](https://etherscan.io/address/0x056fd409e1d7a124bd7017459dfea2f387b6d5cd#code) lets anyone propose a custodian and its current custodian, another account, confirm it.

## Reviewer notes

### Mechanism

requestUnlock (lines 165-210) stores a request with a callback address and selector. completeUnlock (lines 228-283) recovers two signatures with ecrecover (lines 249, 252), requires both in signerSet and distinct, waits out the time lock, then calls callbackAddress with the lock id (line 275). signerSet is written only in the constructor (line 138); no function changes it, and the contract has no owner or upgrade path. Its 8 requests ended with confirmCustodianChange on the GUSD proxy (request 7) and store (request 8), so both now name 0x39dc6ed3e8d762f69a84aacbd31c4ee872b0699c, an account without code that has sent 2 transactions. On the proxy and the store (same CustodianUpgradeable code), requestCustodianChange is open to anyone (line 99) and confirmCustodianChange (lines 119-120) is onlyCustodian (line 83): the current custodian can set this address again, and its fixed signers would then control GUSD's custodian functions. If enough of those signers move to real code that fewer than two still recover, completeUnlock reverts and the callbacks cannot complete. The contract holds 0 ETH.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: not-affected as unused: refuted by the reopened path. GUSD's current custodian, a live account (nonce 2), can confirm a change back to this address on the proxy and store; a dormant contract a live key could restart keeps its notice.
- Ruled out: an ERC-1271 path or second signer path: completeUnlock has none (lines 228-283); the only way to complete a request is two recovered signers.
- Ruled out: a fixed gas amount for the recovery: both ecrecover calls in the runtime code pass GAS (all remaining gas) to CALL, so nothing breaks under the change with nobody migrating.
- Ruled out: requests 1 to 6: their callback targets need logs; none of the GUSD proxy, store, current implementation (0x483a1e7f16f46266400f1baf7abdf445c8d140a2) or its custodian (0x342c1b88c2108f159a4ef37e322b4170b18c42f6) names this address.
- Ruled out: the copy with the same code, 0x1789cca7430aacbdb7c89f9b5695a9c06e4764eb, is its own row; this card covers this address only.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
