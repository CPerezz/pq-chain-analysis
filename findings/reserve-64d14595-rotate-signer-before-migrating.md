---
id: reserve-64d14595-rotate-signer-before-migrating
format: 2
title: Reserve refuses orders from account users whose accounts move to real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only when a user moves to real code; a Nuo admin can add a key first, signed by that user.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x64d14595152b430cf6940da15c6e39545c7c5b7e'
  name: Reserve
  label: 'Nuo Network: Reserve'
  code: verified
  code_url: https://etherscan.io/address/0x64d14595152b430cf6940da15c6e39545c7c5b7e#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: Have the account's user sign addUser to add a backup key, submitted by a Nuo admin, before migrating.
evidence_level: source
checks:
- id: recover
  source: '0x64d14595152b430cf6940da15c6e39545c7c5b7e'
  file: Reserve.sol
  line: 576
  has: return ecrecover(_hash, v, r, s);
  says: signatures are recovered with the ecrecover precompile, with no other branch
  for:
  - evidence-1
  - what
- id: admin
  source: '0x64d14595152b430cf6940da15c6e39545c7c5b7e'
  file: Reserve.sol
  line: 1186
  has: require(config.isAdminValid(msg.sender), "Reserve::_ INVALID_ADMIN_ACCOUNT");
  says: createOrder and cancelOrder are called by an admin of the config
  for:
  - what
- id: byuser
  source: '0x64d14595152b430cf6940da15c6e39545c7c5b7e'
  file: Reserve.sol
  lines:
  - 1260
  - 1262
  has: if(signer != order.byUser){
  says: createOrder requires the recovered signer to be the order's user
  for:
  - evidence-1
  - justification
  - what
  - whose
- id: isuser
  source: '0x64d14595152b430cf6940da15c6e39545c7c5b7e'
  file: Reserve.sol
  line: 1277
  has: if(!Account(order.account).isUser(signer)){
  says: createOrder requires the signer to be a user of the account
  for:
  - evidence-1
  - justification
  - what
  - whose
- id: cancel-recover
  source: '0x64d14595152b430cf6940da15c6e39545c7c5b7e'
  file: Reserve.sol
  line: 1338
  has: address signer = _recoverSigner(cancelOrderHash, _signature);
  says: cancelOrder recovers the signer of the cancel message
  for:
  - evidence-1
  - what
- id: cancel-isuser
  source: '0x64d14595152b430cf6940da15c6e39545c7c5b7e'
  file: Reserve.sol
  line: 1340
  has: if(!Account(order.account).isUser(signer)){
  says: cancelOrder requires the signer to be a user of the account
  for:
  - evidence-1
  - what
- id: adduser-live
  selector: '0x78b37409628e10df0b661c6b205b872a4df8dd6e'
  fn: addUser(address,uint256,bytes)
  says: the master copy behind the newest order's account has addUser
  for:
  - notes
- id: account-impl
  call: '0xe103ac584c3c949ad5b39a0140f81dcd0ad0d9ac'
  fn: implementation()(address)
  is: '0x78B37409628e10df0B661C6B205B872a4DF8DD6E'
  says: the account of the newest order is a proxy to the master copy that has addUser
  for:
  - action
  - evidence-2
  - justification
- id: escrow
  call: '0x64d14595152b430cf6940da15c6e39545c7c5b7e'
  fn: escrow()(address)
  is: '0x802275979B020F0ec871c5eC1db6e412b72fF20b'
  says: the escrow that holds order funds
  for:
  - evidence-3
  - what
- id: escrow-usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0x802275979B020F0ec871c5eC1db6e412b72fF20b'
  is: '0'
  says: the escrow holds no USDC
  for:
  - evidence-3
  - what
- id: escrow-dai
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: balanceOf(address)(uint256)
  args:
  - '0x802275979B020F0ec871c5eC1db6e412b72fF20b'
  is: '0'
  says: the escrow holds no DAI
  for:
  - evidence-3
  - what
- id: last-order
  call: '0x64d14595152b430cf6940da15c6e39545c7c5b7e'
  fn: getOrder(bytes32)(address,address,address,uint256,uint256,uint256,uint256)
  args:
  - '0x8be84ba53d2249cbb4c5d0b3b38542e6673e41e3f8ee0eabd805f152053ebc01'
  is:
  - '0xe103AC584C3C949ad5b39a0140F81dcD0Ad0D9AC'
  - '0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48'
  - '0x5Cb72e8B42f6c84DD4Df6ab823cEa0AE8F1a321C'
  - '8449419297'
  - '2460278635'
  - '859387648'
  - '1596278635'
  says: the newest of the 10,096 orders was created at 1596278635, 1 August 2020
  for:
  - evidence-3
  - what
- id: last-cancelled
  call: '0x64d14595152b430cf6940da15c6e39545c7c5b7e'
  fn: cancelledOrders(bytes32)(bool)
  args:
  - '0x8be84ba53d2249cbb4c5d0b3b38542e6673e41e3f8ee0eabd805f152053ebc01'
  is: 'true'
  says: the newest order is cancelled
  for:
  - evidence-3
  - what
- id: adduser-nonadmin
  call: '0xe103ac584c3c949ad5b39a0140f81dcd0ad0d9ac'
  from: '0x1111111111111111111111111111111111111111'
  data: '0x6a44f65f0000000000000000000000002222222222222222222222222222222222222222000000000000000000000000000000000000000000000000000000000000000700000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000041111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111b00000000000000000000000000000000000000000000000000000000000000'
  reverts_with: Account::_ INVALID_ADMIN_ACCOUNT
  says: the running addUser refuses an arbitrary caller
  for:
  - action
  - evidence-2
  - justification
- id: adduser-user
  call: '0xe103ac584c3c949ad5b39a0140f81dcd0ad0d9ac'
  from: '0x5Cb72e8B42f6c84DD4Df6ab823cEa0AE8F1a321C'
  data: '0x6a44f65f0000000000000000000000002222222222222222222222222222222222222222000000000000000000000000000000000000000000000000000000000000000700000000000000000000000000000000000000000000000000000000000000600000000000000000000000000000000000000000000000000000000000000041111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111b00000000000000000000000000000000000000000000000000000000000000'
  reverts_with: Account::_ INVALID_ADMIN_ACCOUNT
  says: the running addUser refuses the account's own user
  for:
  - action
  - evidence-2
  - justification
- id: adduser-src
  source: '0x64d14595152b430cf6940da15c6e39545c7c5b7e'
  file: Reserve.sol
  lines:
  - 863
  - 868
  has: emit LogError("Account::addUser", "SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT");
  says: in the verified Account code, addUser recovers the signer of the add-user message and adds nobody unless
    that signer is a current user
  for:
  - action
  - justification
- id: adduser-sig
  bytecode: '0x78b37409628e10df0b661c6b205b872a4df8dd6e'
  has: 6002602052604090205490955060ff16151561102c57604080518181526010818301527f4163636f756e743a3a6164645573657200000000000000000000000000000000606082015260806020820181905260229082015260008051602061
  says: the running master checks the signer against the user mapping (slot 2) and on a miss logs and returns
  for:
  - action
  - evidence-2
  - justification
- id: adduser-sig-text
  bytecode: '0x78b37409628e10df0b661c6b205b872a4df8dd6e'
  has: 6125ff83398151915260a082015260f260020a6113950260c0820152
  says: that error text is the 32-byte chunk at code offset 0x25ff followed by 'NT'
  for:
  - action
  - evidence-2
  - justification
- id: signer-text
  bytecode: '0x78b37409628e10df0b661c6b205b872a4df8dd6e'
  has: 565b509056005349474e45525f4e4f545f415554484f52495a45445f574954485f4143434f55
  says: that tail is 'SIGNER_NOT_AUTHORIZED_WITH_ACCOU', the error logged on a miss
  for:
  - action
  - evidence-2
  - justification
- id: isuser-slot
  storage: '0xe103ac584c3c949ad5b39a0140f81dcd0ad0d9ac'
  slot: '0x9c3066b3ebb948aa9bf6f1bf4d56df25727184af6aed1a2cd4dbb7506f4a5637'
  is: '0x0000000000000000000000000000000000000000000000000000000000000001'
  says: 'slot 2 is the isUser mapping: the entry for the account''s user 0x5cb7... is set'
  for:
  - action
  - evidence-2
  - justification
- id: admin-eoa
  code: '0x3e990e787a88cd4426fb3af9b90dd1d951e2cb87'
  is: empty
  says: the Config admin 0x3e99... has no code, so it can still send transactions
  for:
  - action
  - evidence-2
  - justification
- id: admin-valid
  call: '0x431f429035a1e3059d5c6a9a83208c6d3143d925'
  fn: isAdminValid(address)(bool)
  args:
  - '0x3E990e787a88cD4426fB3AF9B90DD1D951E2cb87'
  is: 'true'
  says: 0x3e99... is an admin of the Nuo Config
  for:
  - action
  - evidence-2
  - justification
- id: account-config
  call: '0xe103ac584c3c949ad5b39a0140f81dcd0ad0d9ac'
  fn: config()(address)
  is: '0x431F429035a1e3059d5c6a9a83208c6D3143D925'
  says: the account uses that Config
  for:
  - action
  - evidence-2
  - justification
- id: user-is-user
  call: '0xe103ac584c3c949ad5b39a0140f81dcd0ad0d9ac'
  fn: isUser(address)(bool)
  args:
  - '0x5Cb72e8B42f6c84DD4Df6ab823cEa0AE8F1a321C'
  is: 'true'
  says: 0x5cb7... is a user of the account
  for:
  - action
  - evidence-2
  - justification
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

An admin moves an account's tokens into a Reserve order, or cancels one early, only with an ECDSA signature by a user of that account. A user whose account takes real code stops counting; an EIP-7702 delegation keeps working. The escrow is empty and the newest order, from August 2020, is cancelled.

## Evidence

- [createOrder and cancelOrder](https://etherscan.io/address/0x64d14595152b430cf6940da15c6e39545c7c5b7e#code) recover the signature with ECDSA and require the signer to be a user of the account.
- The [account](https://etherscan.io/address/0xe103ac584c3c949ad5b39a0140f81dcd0ad0d9ac) behind the newest order needs a Nuo admin to send addUser, and its bytecode requires the recovered signer to already be one of the account's users.
- The [escrow](https://etherscan.io/address/0x802275979b020f0ec871c5ec1db6e412b72ff20b) holds no USDC or DAI, and the newest order, created on 1 August 2020, is cancelled.

## Reviewer notes

### Mechanism

createOrder/cancelOrder (onlyAdmin) recover the signer with ecrecover, require signer==order.byUser and Account(order.account).isUser(signer); createOrder then has the escrow pull tokens, cancelOrder returns them. processOrder returns value without a signature only after expiry. The account behind the newest order is a proxy to a master that is NOT the Account embedded in Reserve.sol: its addUser reverts INVALID_ADMIN_ACCOUNT for any non-admin sender, including the account's own user. Its bytecode also looks the recovered signer up in the same user-mapping slot that isUser(address) reads, and on a miss logs 'Account::addUser'/SIGNER_NOT_AUTHORIZED_WITH_ACCOUNT and adds nobody. So a key is added only when an admin sends addUser carrying a signature from a current user: neither side alone is enough.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size branch: _recoverSigner calls ecrecover only, and createOrder compares with byUser directly (Reserve.sol 576, 595-601, 1262).
- Ruled out: a fixed gas amount: Solidity's ecrecover call forwards all gas; the scan reports no gas constant.
- Ruled out: a direct path without a signature: createOrder and cancelOrder always recover; only processOrder after expiry, admin-only and years away for recent orders.
- Ruled out: closed path: stopped() is false and createOrder remains callable; the escrow holds none of the tokens checked, so nothing is locked today.
- Ruled out: unused implementation: the Reserve is not a proxy and recorded 10,096 orders.
- Ruled out: a user adding its own key alone: the running addUser reverts INVALID_ADMIN_ACCOUNT from the account's own user.
- Ruled out: an admin adding a key alone: a junk admin signature returns without reverting but proves nothing (a bad signer is logged and skipped, not reverted); the running bytecode carries that same signer check, so a real user signature is still required.
- Ruled out: Account.transferByUser has its own user-signature check; it is the account's code, not this row.

### Questions

- Accounts created from other master copies (the factory's current master differs) were not checked; their addUser may be gated differently.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
