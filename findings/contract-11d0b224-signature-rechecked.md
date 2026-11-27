---
id: contract-11d0b224-signature-rechecked
format: 2
title: Payment channel provider loses user-signed balances once users take real code
status: candidate
severity: MEDIUM
justification: 'A user that takes real code voids the balance it signed: the provider loses those earnings, or they
  stay locked.'
category: voided-by-migration
pattern: PQ-15
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x11d0b2243739656f54c0277ed0eecde46658a537'
  code: bytecode
  code_url: https://etherscan.io/address/0x11d0b2243739656f54c0277ed0eecde46658a537#code
  copies: 2
  family: baa73883b63370c91cf51cba4f85318f
  upgradeable: 'no'
value:
  usd: 7603
  whose: mixed
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Settle each open channel with its latest user-signed balance before EIP-8151 goes live; this code cannot
  be changed.
evidence_level: bytecode
checks:
- id: recover
  bytecode: '0x11d0b2243739656f54c0277ed0eecde46658a537'
  has: 5b60018682858560405160008152602001604052604051808581526020018460ff1660ff1681526020018381526020018281526020019450505050506020604051602081039080840390855afa
  says: the recovery helper calls address 1 (ecrecover) by STATICCALL with all remaining gas
  for:
  - evidence-1
  - justification
  - what
- id: helper
  bytecode: '0x11d0b2243739656f54c0277ed0eecde46658a537'
  has: 6000612f518386613742565b90508573ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff161415612f9357600193505050506130ae56
  says: the user-signature helper returns 1 only when the recovered address equals the user address it is given
  for:
  - action
  - evidence-1
  - justification
  - what
- id: dispute-closed
  bytecode: '0x11d0b2243739656f54c0277ed0eecde46658a537'
  has: 5b8460026005600083815260200190815260200160002060000160009054906101000a900460ff1660ff161461121a57
  says: the dispute requires the channel's status byte (mapping at slot 5) to be 2, closed
  for:
  - what
- id: dispute
  bytecode: '0x11d0b2243739656f54c0277ed0eecde46658a537'
  has: 5b15611366576000611343888888888660000160019054906101000a900473ffffffffffffffffffffffffffffffffffffffff1689612f2c565b905060018160ff161415611364578682600401819055508582600501819055505b505b600080611372896130b856
  says: the dispute passes the user from bytes 1-20 of the channel record, stores the new balance and nonce only
    on result 1, then settles
  for:
  - evidence-1
  - justification
  - what
  - whose
- id: settlement
  bytecode: '0x11d0b2243739656f54c0277ed0eecde46658a537'
  has: 6000612449898989898660000160019054906101000a900473ffffffffffffffffffffffffffffffffffffffff168a612f2c565b905060018160ff161415612478576000871115612473578782600401819055508682600501819055505b6124e6565b
  says: the provider's settlement of an open channel checks the user's signature against the channel's user and
    jumps to the revert otherwise
  for:
  - action
  - evidence-2
  - what
- id: user-sig-msg
  bytecode: '0x11d0b2243739656f54c0277ed0eecde46658a537'
  has: 7f696e76616c69642075736572207369676e617475726500000000000000000000
  says: the revert reason 'invalid user signature' is pushed in the code
  for:
  - evidence-2
- id: window
  bytecode: '0x11d0b2243739656f54c0277ed0eecde46658a537'
  has: 6000809054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff161461323d578060010154431161323c57
  says: settling lets the provider (slot 0) through at once and anyone else only after the stored settle block
  for:
  - what
- id: no-1271
  selector: '0x11d0b2243739656f54c0277ed0eecde46658a537'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the code never dispatches the ERC-1271 selector
  for:
  - notes
- id: no-1271-legacy
  selector: '0x11d0b2243739656f54c0277ed0eecde46658a537'
  fn: isValidSignature(bytes,bytes)
  absent: true
  says: the code never dispatches the legacy ERC-1271 selector
  for:
  - notes
- id: provider
  call: '0x11d0b2243739656f54c0277ed0eecde46658a537'
  fn: provider()(address)
  is: '0x3b12309c7544cD27BFc39c1367537c7a444eaF80'
  says: the provider key stored in slot 0
  for:
  - notes
- id: provider-eoa
  code: '0x3b12309c7544cd27bfc39c1367537c7a444eaf80'
  is: empty
  says: the provider has no code at the block
  for:
  - notes
- id: provider-nonce
  nonce: '0x3b12309c7544cd27bfc39c1367537c7a444eaf80'
  is: 135
  says: the provider key has sent 135 transactions
  for:
  - notes
- id: channel
  storage: '0x11d0b2243739656f54c0277ed0eecde46658a537'
  slot: '0x76afe5f087666d3e1e473cace51c3c23945f43fb6f5c43e64879ae9f0cb714f5'
  is: '0x00000000000000000000005a3b326d65de1a4fc82ff5d3d007452b2365d4d801'
  says: channel 0xe33cbfaa…01b4 (keccak(id, 5)) is open (status 1) and its user is 0x5a3b326d65de1a4fc82ff5d3d007452b2365d4d8
  for:
  - evidence-3
  - what
  - whose
- id: channel-user-eoa
  code: '0x5a3b326d65de1a4fc82ff5d3d007452b2365d4d8'
  is: empty
  says: that channel's user has no code today
  for:
  - notes
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x11d0b2243739656f54c0277ed0eecde46658a537'
  is: '4060800000000000000'
  says: the contract holds about 4.06 ETH
  for:
  - evidence-3
- id: usdt
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0x11d0b2243739656f54c0277ed0eecde46658a537'
  is: '275300000'
  says: the contract holds 275.3 USDT
  for:
  - evidence-3
- id: user-transfer
  bytecode: '0x11d0b2243739656f54c0277ed0eecde46658a537'
  has: 8260000160019054906101000a900473ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff166108fc839081150290604051600060405180830381858888f193505050
  says: an ETH channel's settlement pays the user's share by a 2,300-gas transfer and reverts if it fails
  for:
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: CRITICAL
reviews:
- who: r-11d0b224, the row's refuter
  date: 2026-11-27
  by: ai-assisted
  verdict: refuted
  note: 'disagree: what-3: an ETH channel (like the cited one) pays the user''s share by a 2,300-gas transfer in
    every settlement; the user''s claim settles only if its new code accepts that; otherwise dispute and settlement
    revert and the channel''s ETH, provider''s share included, stays locked; justification/impact: ''only the provider''s
    earnings are lost'' (funds-loss) holds only for user code that accepts that transfer; the card should add the
    locked case. MEDIUM unchanged (the card was edited after this answer)'
- who: reader-1, the reader who settled the row (also its author)
  date: 2026-11-27
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 're-rated: Re-rated CRITICAL to MEDIUM. Unverified user-to-provider payment channel (4.06 ETH and 275.3
    USDT held). Read from the disassembly: the provider''s dispute (0x57a4bfed) and settlement (0x908c1c06) recover
    the user''s off-chain signed balance with ecrecover and compare it with the channel''s user; no ERC-1271. A
    user whose account takes real code voids the balance it signed: the dispute is ignored and the user''s own unsigned
    close-time claim settles. PQ-15, MEDIUM: no update path and, beyond the migrating user''s own deposit, only
    the provider''s (operator''s) money is at stake. Fix: the provider settles each open channel with its latest
    signed balance before activation. Evidence level bytecode: stays a candidate. First author proposed a question
    (decompiler garbled the comparison); sent back with feedback, the second author read it from the disassembly.
    Refuter disagreed on two parts, accepted by the reader: an ETH channel pays the user''s share with a 2,300-gas
    transfer that reverts the settlement when it fails, so unless the user''s new code accepts it the channel''s
    ETH, the provider''s share included, stays locked. What happens (shortened) and the justification now say so,
    backed by the refuter''s user-transfer check; MEDIUM unchanged, as the refuter agreed. Impact stays funds-loss:
    a user that migrates to void its payment chooses code that takes the transfer.'
related: []
---

## What happens

Users pay the provider with balances they sign off chain. Its dispute and settlement compare the recovered signer with the channel's user. If that user takes real code, its own claim settles instead; in an ETH channel, unless its code accepts a 2,300-gas transfer, the ETH stays locked.

## Evidence

- [The provider's dispute](https://etherscan.io/address/0x11d0b2243739656f54c0277ed0eecde46658a537#code) applies a balance only when the user's signature recovers to the channel's user, then settles.
- [The settlement](https://etherscan.io/address/0x11d0b2243739656f54c0277ed0eecde46658a537#code) of an open channel reverts with "invalid user signature" unless it does.
- [The contract](https://etherscan.io/address/0x11d0b2243739656f54c0277ed0eecde46658a537#code) holds 4.06 ETH and 275.3 USDT; at least one channel is open.

## Reviewer notes

### Mechanism

Disassembly of the runtime code. A shared helper (pc 0x37b1) calls the ecrecover precompile (address 1) by STATICCALL with all remaining gas. The user-signature helper (pc 0x2f2c) recovers the signed balance under two hashes and returns 1 when the result equals the user address it is passed, 2 when it equals the provider (slot 0), else 0. Dispute 0x57a4bfed (pc 0x117d): requires the channel's status byte to be 2 (closed) and the caller to be the provider, then, if the given balance or nonce differs from the stored claim, calls the helper with the user read from bytes 1-20 of the channel record's first word (mapping at slot 5) and stores the new balance and nonce only on a result of 1; it then settles at once (pc 0x30b8) with whatever is stored, so a failed recovery leaves the user's own claim. Settlement 0x908c1c06 (pc 0x21ec): open channel, provider only, same helper call, reverts 'invalid user signature' on anything but 1. The settle routine lets the provider settle at any time and anyone else only after the stored settle block. Under EIP-8151 a user whose account has real code recovers to nothing, so the provider can neither prove a later balance in a dispute nor settle an open channel with it.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 path: neither selector 0x1626ba7e nor 0x20c13b0b is pushed in the code; the only STATICCALL is the ecrecover call.
- Ruled out: a fixed gas amount: the ecrecover STATICCALL forwards GAS (pc 0x37fc), so nothing fails at activation by itself.
- Ruled out: the user taking back the balance without migrating: a user's close only starts the settle window; until the settle block passes, only the provider can settle, and its dispute applies the user-signed balance.
- Ruled out: a dead provider: the provider 0x3b12309c7544cd27bfc39c1367537c7a444eaf80 has no code and has sent 135 transactions.
- Ruled out: the decompiler's reading of the comparisons (inverted, require(0 == 1)): the disassembly shows an EQ against the channel's user.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-27: reviewed again and rewritten from checks that were re-run.
