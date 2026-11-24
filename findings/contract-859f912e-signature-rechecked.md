---
id: contract-859f912e-signature-rechecked
format: 2
title: Payment channel cannot settle signed payments if its signer takes real code
status: candidate
severity: CRITICAL
justification: 'No update path: once the signator''s account has real code, payments it signed are void and nothing
  else pays out.'
category: voided-by-migration
pattern: PQ-15
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  code: decompiled
  code_url: code/0xafadbb50e5272d07009227b705663eb4172dbee21cd58b065c865a2304786e6a.sol
  copies: 7
  family: 354598d4dfa46f57470f533d99ff0c1a
  upgradeable: 'no'
value:
  usd: 1805
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: Settle every signed payment and withdraw the rest before the signator's account takes real code.
evidence_level: bytecode
checks:
- id: sig-cmp
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 6001549091506001600160a01b03808316610100909204161461
  says: after the recovery, the result must equal the address held above the lowest byte of slot 1, else the call
    reverts
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sig-msg
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 4d657373616765207369676e6572206d757374206265207369676e61746f7220746f2074686973206368616e6e656c
  says: 'the revert reason of that comparison: Message signer must be signator to this channel'
  for:
  - evidence-1
  - justification
  - what
- id: signator
  storage: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  slot: 1
  is: '0x0000000000000000000000d2ffe8f8f98b162f02140611e49c87de043021d500'
  says: 'slot 1: the signator 0xd2ffe8f8f98b162f02140611e49c87de043021d5 and a pause flag of zero'
  for:
  - evidence-2
  - what
- id: recover-gas
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 60019260a0808401939192601f1981019281900390910190855afa
  says: the recovery is a static call to the precompile at address 1 with all the gas left, not a fixed amount
  for:
  - what
- id: dispatch
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 60003560e01c8063074540da146100fe5780631f69565f146101d657806329f1c849146102275780633f4ba83a146102fd57806346fbf68e146103125780635c975abb146103595780636ef8d66d1461036e57806382dc1ec4146103835780638456cb59146103b6578063e4860339146103cb578063f54d853914610410575b
  says: 'the whole dispatcher: eleven selectors (three exits, two views of balances and counters, six pause and
    pauser-role functions)'
  for:
  - evidence-1
  - evidence-2
  - justification
  - what
- id: sel-withdraw
  selector: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  fn: withdraw(address,address,uint256,uint256,bytes)
  says: selector 0x074540da is withdraw(token, recipient, amount, nonce, signature)
  for:
  - action
  - evidence-1
- id: sel-settle-withdraw
  selector: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  fn: settleAndWithdraw(address,address,uint256,uint256,bytes)
  says: selector 0x29f1c849 is settleAndWithdraw(token, recipient, amount, nonce, signature)
  for:
  - action
  - evidence-1
- id: sel-settle
  selector: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  fn: settle(address,uint256,uint256,bytes)
  says: selector 0xf54d8539 is settle(token, amount, nonce, signature)
  for:
  - action
  - evidence-1
- id: caller
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 5b6002546001600160a01b0316331461
  says: settle and settleAndWithdraw require the caller to be the address in slot 2, the counterparty
  for:
  - what
- id: counterparty
  storage: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  slot: 2
  is: '0x0000000000000000000000003ef230bc8eee62fb65f137b59381b6c7a1d0c859'
  says: 'slot 2: the counterparty that is paid, 0x3ef230bc8eee62fb65f137b59381b6c7a1d0c859'
  for:
  - what
- id: timelock
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 6003546301fe348001
  says: withdraw compares the block time with slot 3 plus 33,436,800 seconds, 387 days
  for:
  - action
- id: lastuse
  storage: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  slot: 3
  is: '0x62f44b9b'
  says: 'slot 3, the time of the last payout, still its first value: 1,660,177,307, which is 11 August 2022'
  for:
  - action
  - evidence-3
  - what
- id: pause-off
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 6001805460ff19169055
  says: unpause clears only the lowest byte of slot 1 and keeps the signator bytes
  for:
  - evidence-2
  - justification
  - what
- id: pause-on
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 6001805460ff191681179055
  says: pause sets only the lowest byte of slot 1 and keeps the signator bytes
  for:
  - evidence-2
  - justification
  - what
- id: no-1271
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 1626ba7e
  absent: true
  says: the ERC-1271 selector isValidSignature(bytes32,bytes) is not in the code
  for:
  - evidence-1
  - justification
  - what
- id: no-1271-legacy
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 20c13b0b
  absent: true
  says: the legacy selector isValidSignature(bytes,bytes) is not in the code
  for:
  - evidence-1
  - justification
  - what
- id: signator-code
  code: '0xd2ffe8f8f98b162f02140611e49c87de043021d5'
  is: empty
  says: the signator's account has no code at the block
  for:
  - evidence-2
- id: signator-nonce
  nonce: '0xd2ffe8f8f98b162f02140611e49c87de043021d5'
  is: 0
  says: the signator's account has sent no transaction
  for:
  - evidence-2
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  is: '1000000000000000000'
  says: the contract holds 1 ETH
  for:
  - evidence-3
  - what
- id: nonce-eth
  call: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  data: '0xe48603390000000000000000000000000000000000000000000000000000000000000000'
  is: '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: the payment counter for ETH (token address zero) is zero
  for:
  - evidence-3
  - what
- id: nonce-write
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: '6000818152600460205260408120848155'
  says: each exit stores the signed counter for its token, which must exceed the stored one, so a zero counter means
    no payout
  for:
  - evidence-3
  - what
- id: paused
  call: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  fn: paused()(bool)
  is: false
  says: the contract is not paused
  for:
  - notes
- id: born-before
  code: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  is: empty
  at: 15317517
  says: the address had no code at block 15,317,517
  for:
  - evidence-3
  - what
- id: born
  code: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  is: contract
  bytes: 5311
  at: 15317518
  says: 'the code is at the address from block 15,317,518: it was deployed in that block'
  for:
  - evidence-3
  - what
- id: deploy-time
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getCurrentBlockTimestamp()(uint256)
  is: 1660177307
  at: 15317518
  says: 'the time of block 15,317,518 is 1,660,177,307, 11 August 2022: the value slot 3 still holds'
  for:
  - evidence-3
  - what
- id: stamp
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 5b610e70610b1d565b600355
  says: the pay routine, after sending an amount above zero, stores in slot 3 what the routine at 0xb1d returns
  for:
  - evidence-3
  - what
- id: clock
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 5b429056
  says: the routine at 0xb1d returns the block time
  for:
  - evidence-3
  - what
- id: settle-topic
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 89e690b1d5aaae14f3e85f108dc92d9ab3763a58d45aed8b59daedbbae8fe794
  says: the code holds the event topic of Settle(address,uint256,uint256,uint256)
  for:
  - notes
- id: withdraw-topic
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 457f950b75085c30ff780acd57bde642ff1316cc4aad9f286af2c1ffc4163a78
  says: the code holds the event topic of Withdraw(address,uint256,address,uint256)
  for:
  - notes
- id: no-settle-then
  logs: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  topic: '0x89e690b1d5aaae14f3e85f108dc92d9ab3763a58d45aed8b59daedbbae8fe794'
  from: 15317518
  to: 15317518
  count: 0
  says: the address emitted no Settle event in its deployment block
  for:
  - evidence-3
  - what
- id: no-withdraw-then
  logs: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  topic: '0x457f950b75085c30ff780acd57bde642ff1316cc4aad9f286af2c1ffc4163a78'
  from: 15317518
  to: 15317518
  count: 0
  says: the address emitted no Withdraw event in its deployment block
  for:
  - evidence-3
  - what
- id: pauser
  logs: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  topic: '0x6719d08c1888103bea251a4ed56406bd0c3e69723c8a1686e017e7bbe159b6f8'
  from: 15317518
  to: 15317518
  count: 1
  has: 9469d0b3915fe1d4175f3e2b539586d6aa16dcdc
  says: the one PauserAdded(address) event of the deployment block names 0x9469d0b3915fe1d4175f3e2b539586d6aa16dcdc
  for:
  - notes
- id: deploy-tx
  tx: '0x8887e91376527b6146e7e10e1ba746d81faa1968d6b85467656e5ae4cc298d0e'
  to: '0x9469d0b3915fe1d4175f3e2b539586d6aa16dcdc'
  ok: true
  says: the transaction of block 15,317,518 that carries the channel's first events is a call to 0x9469d0b3915fe1d4175f3e2b539586d6aa16dcdc
  for:
  - notes
- id: factory-code
  code: '0x9469d0b3915fe1d4175f3e2b539586d6aa16dcdc'
  is: contract
  says: 0x9469d0b3915fe1d4175f3e2b539586d6aa16dcdc is a contract
  for:
  - notes
- id: funded
  tx: '0xc0320e71e632c287ff42baf3c6d15cb438cdd7445251085c2d78fd9739244c8c'
  to: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  ok: true
  says: a transaction to this address in block 10,719,615
  for:
  - notes
- id: funded-before
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  is: '1000000000000000000'
  at: 15317517
  says: the address already held 1 ETH one block before its code was deployed
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews: []
related: []
---

## What happens

This payment channel pays its counterparty only on messages signed by one fixed signator key. If that key's account takes real code, payments already signed can no longer be settled, and the 1 ETH it holds stays locked. It has paid out nothing since it was deployed on 11 August 2022.

## Evidence

- The [code](https://etherscan.io/address/0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae#code) of all three exits reverts unless the signature recovers to the stored signator, and it never asks a signer contract.
- The [signator](https://etherscan.io/address/0xd2ffe8f8f98b162f02140611e49c87de043021d5) has no code and has sent no transaction; the contract has no function that replaces it.
- The [contract](https://etherscan.io/address/0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae) holds 1 ETH and has paid out nothing since it was deployed on 11 August 2022.

## Reviewer notes

### Mechanism

Unverified code, read from opcodes; decompiled.sol was a lead only. Slot 1 holds a pause flag (lowest byte) and the signator above it; slot 2 the counterparty; slot 3 the time of the last payout, set at deployment; mapping 4 a payment counter per token. settle and settleAndWithdraw require the caller to be the counterparty; withdraw takes any caller once 387 days have passed since slot 3. Each hashes its arguments, recovers the signature with a static call to the precompile forwarding all gas, and reverts unless the result equals the signator (the output word is zeroed first, so an empty answer fails). The token counter must then rise; the amount goes to the counterparty; settleAndWithdraw and withdraw also send the remaining balance to the recipient, by a 2,300-gas ETH transfer. No DELEGATECALL, SELFDESTRUCT or CREATE exists. At the block the 387 days are already over (slot 3 plus 33,436,800 seconds falls in September 2023), so withdraw itself needs only the signature.

### Checks

- Header facts: this address alone, at block 26,438,999; 7 addresses run this code.
- Ruled out: a signer contract asked another way: neither ERC-1271 selector is in the code; the recovered address is compared directly.
- Ruled out: a setter or an upgrade: none of the 11 selectors writes slot 2 or the signator bytes of slot 1; not a proxy.
- Ruled out: an exit without the signature: only the 3 exits transfer, and each reaches the recovery first.
- Ruled out: a pause closing the path: paused() is false, and the exits never read the flag.
- Ruled out: breaking with nobody migrating: the recovery forwards all gas; no call in 90 days, no replay in the dossier.
- Ruled out: unused code: slots 1-3 are set and the address holds 1 ETH.
- Ruled out: a separate notice for the rest of the deposit: not filed; the same failing check locks it, and this card says so.
- Ruled out: the other 6 addresses with this code: not read; facts and value here are this address's own.
- Ruled out: a payout since deployment (reader): slot 3 still holds the time of the deployment block 15,317,518; the pay routine rewrites it at every payout above zero, and that block has no Settle or Withdraw event.
- Ruled out: who funded it (reader): one transaction sent the 1 ETH in block 10,719,615, before the code existed; the channel was deployed through the factory 0x9469d0b3915fe1d4175f3e2b539586d6aa16dcdc, its only pauser.

### Questions

- Whether an unsettled signed payment exists: payments are signed off chain and nothing on chain shows one.
- Who holds the signator key, who the counterparty and the sender of the 1 ETH are, and whose factory 0x9469d0b3915fe1d4175f3e2b539586d6aa16dcdc is: not established; no project is named and `whose` is empty.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-24: reviewed again and rewritten from checks that were re-run.
