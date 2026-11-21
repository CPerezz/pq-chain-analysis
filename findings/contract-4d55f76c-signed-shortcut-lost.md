---
id: contract-4d55f76c-signed-shortcut-lost
format: 2
title: Makers with real code lose signed orders on this EtherDelta-style exchange
status: candidate
severity: INFORMATIONAL
justification: Breaks only if a maker moves its account to real code; that maker can still post its orders on-chain.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x4d55f76ce2dbbae7b48661bef9bd144ce0c9091b'
  code: bytecode
  code_url: https://etherscan.io/address/0x4d55f76ce2dbbae7b48661bef9bd144ce0c9091b#code
  copies: 1
  upgradeable: 'no'
  admin: '0x4499514831219df01cf5d6b66c76ca9d76ac4f74'
value:
  usd: 4473651
  whose: users
  basis: held
activity:
  txs_90d: 49
  last: 2026-10-03
impact: liveness
action: Tell makers to post orders with order() instead of signing them before they move their accounts to real
  code.
evidence_level: bytecode
checks:
- id: sel-trade
  selector: '0x4d55f76ce2dbbae7b48661bef9bd144ce0c9091b'
  fn: trade(address,uint256,address,uint256,uint256,uint256,address,uint8,bytes32,bytes32,uint256)
  says: the code has EtherDelta's trade function
  for:
  - evidence-1
  - what
- id: sel-order
  selector: '0x4d55f76ce2dbbae7b48661bef9bd144ce0c9091b'
  fn: order(address,uint256,address,uint256,uint256,uint256)
  says: the code has order(), the direct way to post an order on-chain
  for:
  - action
  - justification
  - what
- id: trade-sig
  bytecode: '0x4d55f76ce2dbbae7b48661bef9bd144ce0c9091b'
  has: 60ff1680610de457508573ffffffffffffffffffffffffffffffffffffffff1660018260405180807f19457468657265756d205369676e6564204d6573736167653a0a333200000000
  says: trade reads orders[user][hash]; only if unset it calls ecrecover on the signed-message hash
  for:
  - action
  - evidence-1
  - justification
  - what
- id: trade-eq
  bytecode: '0x4d55f76ce2dbbae7b48661bef9bd144ce0c9091b'
  has: 6020604051035173ffffffffffffffffffffffffffffffffffffffff16145b8015610df05750874311155b
  says: the recovered address must equal user, then block.number must not exceed expires
  for:
  - evidence-1
  - what
- id: cancel-eq
  bytecode: '0x4d55f76ce2dbbae7b48661bef9bd144ce0c9091b'
  has: 6020604051035173ffffffffffffffffffffffffffffffffffffffff16145b151561159b57610000565b88600860003373
  says: cancelOrder requires the recovered address to match before writing orderFills[msg.sender]
  for:
  - notes
- id: ec-gas
  bytecode: '0x4d55f76ce2dbbae7b48661bef9bd144ce0c9091b'
  has: 6161da5a03f1
  says: precompile calls pass gasleft minus 25,050, not a fixed gas amount
  for:
  - notes
- id: no-1271
  selector: '0x4d55f76ce2dbbae7b48661bef9bd144ce0c9091b'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: no ERC-1271 path
  for:
  - evidence-2
  - what
- id: deposit
  bytecode: '0x4d55f76ce2dbbae7b48661bef9bd144ce0c9091b'
  has: 60066000600073ffffffffffffffffffffffffffffffffffffffff16815260200190815260200160002060003373ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020016000205434
  says: deposit() adds msg.value to tokens[0][msg.sender], so held ETH is depositors' balances
  for:
  - whose
- id: admin
  call: '0x4d55f76ce2dbbae7b48661bef9bd144ce0c9091b'
  fn: admin()(address)
  is: '0x4499514831219df01cf5d6b66c76ca9d76ac4f74'
  says: the admin at the block
  for:
  - notes
- id: admin-eoa
  code: '0x4499514831219df01cf5d6b66c76ca9d76ac4f74'
  is: empty
  says: the admin is an account without code
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This unverified exchange, built like EtherDelta, fills a maker's order if the maker posted it with order() or signed it with ECDSA. A maker who moves its account to real code can no longer get signed orders filled; orders it posts with order() still fill.

## Evidence

- In the [code](https://etherscan.io/address/0x4d55f76ce2dbbae7b48661bef9bd144ce0c9091b#code), trade() fills an order posted with order() or one whose ecrecover result is the maker.
- The [code](https://etherscan.io/address/0x4d55f76ce2dbbae7b48661bef9bd144ce0c9091b#code) has no ERC-1271 isValidSignature function, so a maker with real code has no signed path.

## Reviewer notes

### Mechanism

Unverified bytecode, read by disassembly (the decompiler missed the recoveries). Selectors match EtherDelta: trade, order, cancelOrder, availableVolume, testTrade, deposit, withdraw, depositToken, withdrawToken, admin setters. trade() hashes the order with sha256(this, ...), reads orders[user][hash] (slot 7) and, only if it is unset, calls ecrecover (precompile 0x01) on keccak("\x19Ethereum Signed Message:\n32", hash) and requires the result to equal user, then block.number <= expires and orderFills (slot 8) + amount <= amountGet. order() sets orders[msg.sender][hash], so a maker with code can still post orders by a direct call. cancelOrder recovers against msg.sender (second ecrecover); a code-holding maker cannot cancel a signed-only order, but such an order cannot be filled either. The third ecrecover is in availableVolume (view). Each recovery gets gasleft()-25050, not a fixed amount. deposit() credits tokens[0][msg.sender] with msg.value, so the held ETH is depositors' balances. admin() is 0x4499...4f74, an EOA with nonce 165; its setters change fees, fee account, account-levels contract and an account map, not the order check.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path: isValidSignature(bytes32,bytes) selector absent; trade has only the orders[] lookup or ecrecover.
- Ruled out: a fixed gas amount to the precompile: every precompile call uses GAS - 0x61da (gasleft minus 25,050), so the change does not break it by itself.
- Ruled out: a proxy or unused implementation: no DELEGATECALL, EIP-1967 slots empty (tool facts); it holds 2,479 ETH of deposits.
- Ruled out: a signature relied on and rechecked later: a trade is atomic, so a maker voiding its own signed order costs the taker nothing.
- Ruled out: the decompiler's admin-only account map (0x3fb9950a) that withdraw() may pay to is not judged here; the card claims nothing about withdrawals.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
