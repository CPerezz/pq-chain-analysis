---
id: virtualpaymentmanager-07bfa78d-signature-rechecked
format: 2
title: Virtual payments here stop paying once a signing device key moves to real code
status: confirmed
severity: CRITICAL
justification: A payee loses a signed payment if the payer's or guardian's device key moves to real code first.
category: voided-by-migration
pattern: PQ-15
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x07bfa78d66d104fe9936201427400b0d78a2284c'
  name: VirtualPaymentManager
  code: verified
  code_url: https://etherscan.io/address/0x07bfa78d66d104fe9936201427400b0d78a2284c#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 13956
  whose: users
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Tell payees to redeem signed payments before any payer or guardian device key moves its account to real
  code.
evidence_level: source
checks:
- id: process
  source: '0x07bfa78d66d104fe9936201427400b0d78a2284c'
  file: VirtualPaymentManager.sol
  lines:
  - 431
  - 438
  has: guardian.verifySignature(_messageHash, _guardianSignature, true)
  says: a redeem requires both the sender's and the guardian's signature over the payment
  for:
  - action
  - evidence-1
  - justification
  - what
- id: acct
  source: '0x07bfa78d66d104fe9936201427400b0d78a2284c'
  file: VirtualPaymentManager.sol
  lines:
  - 263
  - 268
  has: _result = AbstractAccount(_address).verifySignature(
  says: for an address with code, the signature is checked against that account's devices
  for:
  - action
  - evidence-2
  - justification
  - what
- id: acct-rec
  source: '0x07bfa78d66d104fe9936201427400b0d78a2284c'
  file: VirtualPaymentManager.sol
  lines:
  - 234
  - 242
  has: _result = isAnyDevice(_account, _recovered);
  says: the device is found by ECDSA recovery and looked up in the account's devices mapping
  for:
  - evidence-2
- id: payout
  source: '0x07bfa78d66d104fe9936201427400b0d78a2284c'
  file: VirtualPaymentManager.sol
  line: 389
  has: _transfer(_recipient, _token, _processedValue);
  says: withdrawPayment pays the recipient from the sender's deposit
  for:
  - what
- id: deposit
  source: '0x07bfa78d66d104fe9936201427400b0d78a2284c'
  file: VirtualPaymentManager.sol
  line: 327
  has: deposits[msg.sender][address(0)].value = deposits[msg.sender][address(0)].value.add(msg.value);
  says: ETH sent here is credited to the sender's own deposit
  for:
  - evidence-3
  - what
  - whose
- id: unlock
  source: '0x07bfa78d66d104fe9936201427400b0d78a2284c'
  file: VirtualPaymentManager.sol
  lines:
  - 395
  - 409
  has: deposits[msg.sender][_token].withdrawalUnlockedAt = now.add(depositWithdrawalLockPeriod);
  says: a payer withdraws its deposit only after a lock period it starts itself
  for:
  - justification
  - what
- id: lock
  call: '0x07bfa78d66d104fe9936201427400b0d78a2284c'
  fn: depositWithdrawalLockPeriod()(uint256)
  is: '2592000'
  says: the lock period is 30 days
  for:
  - notes
- id: guardian-set
  source: '0x07bfa78d66d104fe9936201427400b0d78a2284c'
  file: VirtualPaymentManager.sol
  line: 314
  has: guardian = _guardian;
  says: the guardian is set in the constructor
  for:
  - justification
- id: guardian
  call: '0x07bfa78d66d104fe9936201427400b0d78a2284c'
  fn: guardian()(address)
  is: '0x99819fedbcf9986824bbe094df928887d1a443a6'
  says: the guardian at the block
  for:
  - notes
- id: guardian-code
  code: '0x99819fedbcf9986824bbe094df928887d1a443a6'
  is: contract
  says: the guardian is a contract account, so its devices' keys are recovered
  for:
  - notes
- id: bal
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x07bfa78d66d104fe9936201427400b0d78a2284c'
  is: '7733589295864071582'
  says: the contract holds 7.73 ETH
  for:
  - evidence-3
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: CRITICAL
reviews:
- who: r-07bfa78d, the row's refuter
  date: 2026-11-27
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection (the card was edited after this answer)
- who: reader-1, the reader who settled the row (also its author)
  date: 2026-11-27
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: 'kept: Archanova VirtualPaymentManager: payers deposit ETH and sign payments off chain; a payee redeems
    one later with the payer''s and the guardian''s signatures, and for account senders and the guardian the contract
    recovers a device key with ECDSA and asks the account whether it lists that device, never isValidSignature.
    Once a device key has real code the redeem fails, and the payer can withdraw after the 30-day lock. PQ-15, CRITICAL:
    no proxy, no upgrade, the guardian is fixed in the constructor, and payees lose. Fix: payees redeem before any
    payer or guardian device key migrates. Refuter agreed with no objection. Reader dropped the author''s two log
    questions (dormancy, the guardian''s full device list): the card states neither; noted under ruled_out.'
related: []
---

## What happens

Payers deposit funds here and sign payments off chain. A payee cashes one in later with the payer's and the guardian's signatures. For account senders and the guardian, it recovers a device key. Once that key has real code, the payment fails and the payer can withdraw.

## Evidence

- [_processPayment](https://etherscan.io/address/0x07bfa78d66d104fe9936201427400b0d78a2284c#code) requires the sender's and the guardian's signatures when a payment is redeemed.
- [verifySignature](https://etherscan.io/address/0x07bfa78d66d104fe9936201427400b0d78a2284c#code) asks a contract account to list the device recovered with ECDSA; it has no ERC-1271 path.
- The [contract](https://etherscan.io/address/0x07bfa78d66d104fe9936201427400b0d78a2284c#code) holds 7.73 ETH of depositors' funds.

## Reviewer notes

### Mechanism

depositPayment/withdrawPayment call _processPayment (lines 411-473). It hashes (this, sender, recipient, token, id, value) and requires sender.verifySignature(non-strict) and guardian.verifySignature(strict) (lines 431-438). AddressLibrary.verifySignature (257-273): if the address has code, AccountLibrary.verifySignature recovers the signature with ECDSA and asks the account's devices() mapping (234-242); otherwise it recovers and compares with the address. Under EIP-8151 a device key with real code recovers to zero, so _result stays false and the redeem reverts. The guardian (0x99819f…43a6) is a contract account, set only in the constructor (line 314). A payer can withdraw its deposit 30 days (depositWithdrawalLockPeriod = 2,592,000 s) after requesting it (395-409); a redeem clears that request (467-469). So today a payee is protected while it redeems within the window, but a device key moving to real code voids the voucher outright, and the payer then takes the deposit back.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271: the code-size branch asks the account's devices() with an ECDSA-recovered key (lines 234-242), never isValidSignature, so a device with real code does not count.
- Ruled out: taken-back: without migrating, a payer needs 30 days after a withdrawal request, and any redeem in that window clears the request (lines 395-409, 467-469).
- Ruled out: upgrade or setter: facts show no proxy and no upgrade path; guardian is written only in the constructor (line 314).
- Ruled out: Dormancy since block 9,271,239 and the guardian's full device list: both need event logs; the card says neither. It cites one guardian device read at the block, and states the mechanism and the ETH held.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-27: reviewed again and rewritten from checks that were re-run.
