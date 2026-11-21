---
id: contract-dcd4cebe-bls-group-key
format: 2
title: A forged BLS group signature can empty this dormant Wrapped Gonka bridge
status: candidate
severity: LOW
justification: Anyone can shut the signed path now; only the owner, one known key holding all WGNK, can reopen it.
category: quantum-exposure
pattern: PQ-6
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  code: decompiled
  code_url: code/0x4dec0b4edc0766b1eb7c8b6c1f3da9394516c303ba97fb2cd5d9c9c4c82bc40d.sol
  copies: 1
  upgradeable: 'no'
  admin: '0xeec5ca4286a5a16ea87c0612c55f73dd982a36c6'
value:
  usd: 3
  basis: held
activity: {}
impact: funds-loss
action: Call checkAndHandleTimeout to shut withdrawals and mints, then renounce ownership; the 3 USDT then stays
  locked.
evidence_level: bytecode
checks:
- id: sel-withdraw
  selector: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  fn: withdraw((uint64,bytes32,address,address,uint256,bytes))
  says: the code has a withdraw function taking an epoch, a request id, a recipient, a token, an amount and a signature
  for:
  - evidence-1
  - what
- id: sel-mint
  selector: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  fn: mintWithSignature((uint64,bytes32,address,uint256,bytes))
  says: the code has a mintWithSignature function taking an epoch, a request id, a recipient, an amount and a signature
  for:
  - evidence-1
  - what
- id: pairing
  bytecode: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  has: 600f6001600160a01b
  says: the code pushes address 0x0f, the BLS12-381 pairing-check precompile, as a call target (STATICCALL at 0x23fc
    with all gas)
  for:
  - evidence-1
  - what
- id: map
  bytecode: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  has: 60106001600160a01b
  says: the code pushes address 0x10, the BLS12-381 map-to-G1 precompile, as a call target (STATICCALL at 0x2964)
  for:
  - evidence-1
  - what
- id: modulus
  bytecode: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  has: 1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab
  says: the code holds the BLS12-381 base field modulus
  for:
  - evidence-1
- id: badsig
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  data: '0x70a1f3e900000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000005abababababababababababababababababababababababababababababababab000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000000000000000000000000000000000000002dc6c000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  reverts_with: '0x8baa579f'
  says: 'a withdraw of 3 USDT under epoch 5 with a wrong signature reverts with InvalidSignature(): the signature
    is what gates it'
  for:
  - evidence-1
  - what
- id: mintbad
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  data: '0xb7c9e84a00000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000005abababababababababababababababababababababababababababababababab000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  reverts_with: '0x8baa579f'
  says: a mint under epoch 5 with a wrong signature reverts with InvalidSignature()
  for:
  - evidence-1
  - what
- id: noepoch
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  data: '0x70a1f3e900000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000000007abababababababababababababababababababababababababababababababab000000000000000000000000000000000000000000000000000000000000dead000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec700000000000000000000000000000000000000000000000000000000002dc6c000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  reverts_with: '0xd5b25b63'
  says: 'a withdraw under epoch 7, which has no key, reverts with InvalidEpoch(): the signature is checked against
    the stored key of its epoch'
  for:
  - what
- id: key5
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  data: '0xdce67dfb0000000000000000000000000000000000000000000000000000000000000005'
  is: '0x0000000000000000000000000000000011f6324933c5f322ee9ec8261a96d2c7811f54c51c547217a768a8c0531b51c5f92dc80f98eb82499dc41e4b35536eb100000000000000000000000000000000198ec213d5b2b0806ad5c6e497f4f35509df5e143f43d77326a2879c1adec71316b66df9e283c1db4e5219387e1fe684000000000000000000000000000000000cf21e3b2fd06c510fc58f4e19db93227e4478a5cdb4326423cde61db200380d6dac9fcf8a9c9a286a9dbc2facf70ce4000000000000000000000000000000000148ccc82f3e9f686904dc020c95f1f7fdd07c88075b41a838a87c4ed9c1be7db972b757f400d7687456dbc4f75a7d61'
  says: the 256-byte public group key of epoch 5 is stored and readable by anyone
  for:
  - what
- id: state
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  fn: getCurrentState()(uint8)
  is: 1
  says: the bridge is in state 1, normal operation, in which withdraw and mint are open
  for:
  - evidence-2
  - justification
  - what
- id: usdt
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  is: 3000000
  says: the bridge holds 3 USDT
  for:
  - action
  - evidence-2
  - what
- id: supply
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  fn: totalSupply()(uint256)
  is: 1000000000
  says: WGNK supply here is 1,000,000,000 base units (1e-9 WGNK at 18 decimals)
  for:
  - evidence-2
  - justification
- id: ownerwgnk
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  fn: balanceOf(address)(uint256)
  args:
  - '0xeec5ca4286a5a16ea87c0612c55f73dd982a36c6'
  is: 1000000000
  says: the owner holds the whole WGNK supply
  for:
  - evidence-2
  - justification
- id: owner
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  fn: owner()(address)
  is: '0xeec5ca4286a5a16ea87c0612c55f73dd982a36c6'
  says: the owner
  for:
  - evidence-2
  - justification
- id: owner-eoa
  code: '0xeec5ca4286a5a16ea87c0612c55f73dd982a36c6'
  is: empty
  says: the owner is an account without code (an ECDSA key)
  for:
  - notes
- id: owner-nonce
  nonce: '0xeec5ca4286a5a16ea87c0612c55f73dd982a36c6'
  min: 95
  says: the owner key has sent transactions, so its public key is on chain
  for:
  - notes
- id: no-upgradeto
  selector: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  fn: upgradeTo(address)
  absent: true
  says: no upgradeTo function
  for:
  - notes
- id: no-upgradecall
  selector: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  fn: upgradeToAndCall(address,bytes)
  absent: true
  says: no upgradeToAndCall function
  for:
  - notes
- id: timeout
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  fn: isTimeoutReached()(bool)
  is: true
  says: more than 30 days have passed since the last group key
  for:
  - action
  - evidence-2
  - justification
  - what
- id: duration
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  fn: TIMEOUT_DURATION()(uint256)
  is: 2592000
  says: the timeout is 2,592,000 seconds, 30 days
  for:
  - evidence-2
- id: handle
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  data: '0xbafe519e'
  is: ''
  says: 'checkAndHandleTimeout() succeeds for any caller at the block: anyone can switch the bridge to admin control'
  for:
  - action
  - evidence-3
  - justification
- id: setkey-owner
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  data: '0x0d23959500000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000010011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
  from: '0xeec5ca4286a5a16ea87c0612c55f73dd982a36c6'
  reverts_with: '0x9d2a9928'
  says: setGroupKey from the owner passes the owner check and stops only at the state check (not in admin control)
  for:
  - evidence-3
  - justification
- id: setkey-other
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  data: '0x0d23959500000000000000000000000000000000000000000000000000000000000000060000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000010011111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111'
  from: '0x000000000000000000000000000000000000dead'
  reverts_with: 'Ownable: caller is not the owner'
  says: setGroupKey from anyone else fails the owner check
  for:
  - evidence-3
  - justification
- id: meta
  storage: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  slot: '0x9'
  is: '0x0000000000000000000000000000000100000000692025e30000000000000005'
  says: 'the bridge''s state word: latest epoch 5, its key set at timestamp 1763714531 (2025-11-21 08:42 UTC), state
    1 (normal operation)'
  for:
  - evidence-2
  - what
- id: key6
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  data: '0xdce67dfb0000000000000000000000000000000000000000000000000000000000000006'
  is: '0x00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
  says: 'no group key is stored for epoch 6: none has been added after epoch 5'
  for:
  - evidence-2
  - what
- id: reset-owner
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  data: '0xa90f5cc5'
  from: '0xeec5ca4286a5a16ea87c0612c55f73dd982a36c6'
  reverts_with: '0x9d2a9928'
  says: resetToNormalOperation from the owner passes the owner check and stops only at the state check (the bridge
    is not in admin control)
  for:
  - evidence-3
  - justification
- id: reset-other
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  data: '0xa90f5cc5'
  from: '0x000000000000000000000000000000000000dead'
  reverts_with: 'Ownable: caller is not the owner'
  says: 'resetToNormalOperation from anyone else fails the owner check: only the owner can reopen the bridge'
  for:
  - action
  - evidence-3
  - justification
- id: renounce
  call: '0xdcd4cebe3917a8f1728b8af61299085edfd91f44'
  data: '0x715018a6'
  from: '0xeec5ca4286a5a16ea87c0612c55f73dd982a36c6'
  is: ''
  says: the owner can renounce ownership at the block
  for:
  - action
- id: live-bridge
  code: '0x972a7a92d92796a98801a8818bcf91f1648f2f68'
  says: the other Gonka bridge deployment named by the first study has code at the block
  is: contract
  for:
  - notes
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
reviews: []
related: []
---

## What happens

This earlier Wrapped Gonka bridge pays out tokens and mints WGNK on a BLS signature checked against its epoch's stored group key. That key is public, so a quantum computer can recover its secret and take the 3 USDT held. No group key has been set since 2025-11-21.

## Evidence

- [Bytecode](https://etherscan.io/address/0xdcd4cebe3917a8f1728b8af61299085edfd91f44#code) calls the BLS12-381 pairing and map-to-curve precompiles; withdraw and mint revert on a wrong signature.
- [State](https://etherscan.io/address/0xdcd4cebe3917a8f1728b8af61299085edfd91f44#code): open, last group key (epoch 5) set on 2025-11-21, 30-day timeout passed, 3 USDT held; the owner holds all WGNK.
- [Admin control](https://etherscan.io/address/0xdcd4cebe3917a8f1728b8af61299085edfd91f44#code): anyone can enter it now; only the owner passes the checks of setGroupKey and resetToNormalOperation.

## Reviewer notes

### Mechanism

Unverified code; judged from the bytecode, the decompiled reading and calls at the block. withdraw (0x70a1f3e9) and mintWithSignature (0xb7c9e84a) require state 1, look up the 256-byte G2 key of the command's epoch (InvalidEpoch if none), map the message to G1 (0x10), run a pairing check (0x0f) and revert InvalidSignature on failure. Slot 9 packs epoch 5, its key time 1763714531 (2025-11-21) and state 1; epoch 6 is empty, so the 30-day TIMEOUT_DURATION has passed. checkAndHandleTimeout (anyone) then sets state 0 (admin control); in the decompiled reading withdraw and mint revert 0x2745ed2e when state is not 1. A refuter saw that revert with an eth_call state override of slot 9 at the block; a check cannot record an override, and the selector is not a literal in the bytecode, so that step rests on the decompiled reading and the override. In state 0, only the owner (EOA 0xeec5...36c6) can setGroupKey for a later epoch and resetToNormalOperation. The decompiled selector list has no rescue function, so the 3 USDT leaves only by a signed withdraw: the owner can set its own key, reopen and sign it out, then shut again by timeout or leave it. Rated LOW by the quantum-exposure table: one known operator fixes it with settings (anyone shuts it, the owner alone reopens or renounces); no upgrade, vote or user migration is needed. The first study rated it MEDIUM.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: key-state: the epoch 5 key is set and non-zero, and an epoch without a key is refused (InvalidEpoch), so the check is live against a stored key.
- Ruled out: path-closed: the bridge is in state 1 (open) at the block; it is shut only once someone calls checkAndHandleTimeout, which nobody had done.
- Ruled out: an upgrade or verifier swap: no upgradeTo/upgradeToAndCall selectors and the tool read no proxy.
- Ruled out: ECDSA owner path (separate, not folded in): the owner 0xeec5...36c6 is an EOA that has sent 95+ transactions; a CRQC that breaks that key can enter admin control, install its own group key and reopen. The reviewer may want a separate owner-key finding.
- Ruled out: D-028 dormancy: no key since 2025-11-21 but a live owner could restart it, so the finding stays and the card states the dormancy. The other Gonka bridge, 0x972a7a92d92796a98801a8818bcf91f1648f2f68, has code at the block and is its own row.
- Ruled out: value: the $3 is 3 USDT held by this address; who deposited it cannot be read without logs, so whose is left empty.

### Questions

- Does the Gonka chain still release native GNK for WGNK burned on this earlier deployment? If it does, forged mints here reach Gonka's escrow; no read on Ethereum can settle it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
