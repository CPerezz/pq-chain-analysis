---
id: contract-2fcec0d5-fixed-gas-recovery
format: 2
title: Token game's oracle draws all fail once EIP-8151 raises the recovery cost
status: candidate
severity: MEDIUM
justification: Anyone can fund a draw; draws stall only because the oracle's known senders are silent. EIP-8151
  ends them for good.
category: breaks-at-activation
pattern: PQ-14
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  code: decompiled
  code_url: code/0xb4cad51ac6c267cd391d87ae5a9eb791203a0b59ce4cd365bb5a13fe5e5882a3.sol
  copies: 1
  upgradeable: 'no'
  admin: '0x67decb8b210254841fa74b51a0367cbcaf168589'
value:
  usd: 0
  whose: users
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Sweep the game's ETH with takeAll after any deposit, and tell players that draws can never be answered once
  EIP-8151 is live.
evidence_level: bytecode
checks:
- id: fixed-gas
  bytecode: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  has: 208160808360006001610bb8f19250805191
  says: the call to the signature precompile (address 1) gets a constant 3,000 gas and the recovered address is
    read from its output buffer
  for:
  - action
  - evidence-1
  - justification
  - what
- id: cb-only
  bytecode: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  has: 5b6000610ce161163f565b73ffffffffffffffffffffffffffffffffffffffff163373ffffffffffffffffffffffffffffffffffffffff16141515610d1a57600080fd
  says: the callback body reverts unless the caller is the oracle's callback address
  for:
  - evidence-1
  - what
- id: proof-revert
  bytecode: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  has: 6000610d27858585611955565b60ff16141515610d3657600080fd
  says: the callback reverts unless the proof check returns 0
  for:
  - action
  - evidence-1
  - justification
  - what
- id: callback-sel
  selector: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  fn: __callback(bytes32,string,bytes)
  says: the code has the oracle's callback with a proof
  for:
  - what
- id: roll-sel
  selector: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  fn: roll(uint256)
  says: the code has the roll function of the game
  for:
  - what
- id: no-upgrade
  selector: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - action
  - justification
- id: no-proxy
  storage: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty, so the address is not a proxy
  for:
  - action
  - justification
- id: owner
  call: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  fn: owner()(address)
  is: '0x67decb8b210254841fa74b51a0367cbcaf168589'
  says: the owner at the block
  for:
  - evidence-3
- id: takeall-owner
  call: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  data: '0xde3bcb97'
  from: '0x67decb8b210254841fa74b51a0367cbcaf168589'
  is: 0x
  says: takeAll called by the owner succeeds
  for:
  - action
  - evidence-3
- id: takeall-other
  call: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  data: '0xde3bcb97'
  from: '0x000000000000000000000000000000000000dEaD'
  reverts: true
  says: takeAll called by anyone else reverts
  for:
  - action
  - evidence-3
- id: roll-stake
  bytecode: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  has: 5b6000600a82148061085b5750606482145b8061086757506103e882145b151561087257600080fd
  says: roll reverts unless the stake is 10, 100 or 1,000 (in whole tokens)
  for:
  - evidence-2
  - what
  - whose
- id: stake-to-owner
  bytecode: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  has: 610940600860009054906101000a900473ffffffffffffffffffffffffffffffffffffffff1682610fac565b50610949611182565b
  says: roll then transfers the stake to the owner (slot 8) and sends the oracle query (routine 0x1182)
  for:
  - evidence-2
  - justification
  - what
- id: caller-pays
  bytecode: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  has: 610fe957600080fd5b61103b82600660003373
  says: the transfer routine roll uses debits the caller's token balance
  for:
  - evidence-2
  - whose
- id: answers-in-order
  bytecode: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  has: 5b60008060096000600c54
  says: each accepted answer settles the oldest open roll, numbered by the counter in slot 12
  for:
  - evidence-2
  - whose
- id: rolls-placed
  storage: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  slot: '0xb'
  is: 20
  says: 20 rolls have been placed
  for:
  - evidence-2
- id: rolls-answered
  storage: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  slot: '0xc'
  is: 19
  says: 19 rolls (0 to 18) have been answered, so the open roll is index 19, the last of the 20 placed
  for:
  - evidence-2
- id: roll19-player
  storage: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  slot: '0x20eb389d0739387175ea0af71ea83e439c1e64b1f1d88bc1a63c293936f1ddf9'
  is: '0x000000000000000000000000006696df7fcddf5c0d8728a7200ced6da372527b'
  says: roll 19 was placed by 0x006696df7fcddf5c0d8728a7200ced6da372527b
  for:
  - evidence-2
- id: roll19-stake
  storage: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  slot: '0x2e60ceb69e96fe6481ce9457171ef3f030bf0150171842d8842b77cad9c3b355'
  is: 1000
  says: roll 19 staked 1,000 tokens
  for:
  - evidence-2
- id: roll18-cleared
  storage: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  slot: '0xe84bfcbbf6b4a03922a064640cc123c559d873e4452e4de9b4c8ae3d625b15f0'
  is: 0
  says: the record of the answered roll 18 is cleared
  for:
  - evidence-2
- id: eth-zero
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  is: 0
  says: the game holds no ETH at the block
  for:
  - evidence-3
- id: roll-reverts
  call: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  data: '0x1f7b4f30000000000000000000000000000000000000000000000000000000000000000a'
  from: '0x006696df7fcddf5c0d8728a7200ced6da372527b'
  reverts: true
  says: a new roll of 10 tokens by a player holding 17,380 tokens reverts at the block
  for:
  - evidence-3
- id: roll-nonpayable
  bytecode: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  has: 5b341561025a57600080fd5b610270
  says: roll reverts when sent ETH, so a roll's oracle fee comes from the game's own balance
  for:
  - evidence-3
- id: getrandom-entry
  bytecode: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  has: 5b61060f61118256
  says: getRandom (selector 0xaacc5a17) accepts ETH and jumps straight to the oracle query routine roll uses, with
    no caller check
  for:
  - evidence-3
  - justification
- id: getrandom-noeth
  call: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  data: '0xaacc5a17'
  from: '0x000000000000000000000000000000000000dEaD'
  reverts: true
  says: a draw with no ETH attached reverts at the block, since the game cannot pay the fee
  for:
  - evidence-3
  - justification
- id: receive-entry
  bytecode: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  has: 5b61038c610c6a56
  says: receiveFromGame (selector 0x386304e4, dispatched to 0x0385) accepts ETH from any caller and jumps to routine
    0x0c6a
  for:
  - action
- id: receive-log
  bytecode: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  has: 5b7f85177f287940f2f05425a4029951af0e047a7f9c4eaa9a6e6917bcd869f866953334
  says: routine 0x0c6a only logs EthReceived(caller, value)
  for:
  - action
- id: payout
  bytecode: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  has: 6108fc611d5660023073ffffffffffffffffffffffffffffffffffffffff1631612b18
  says: after the Winner event, the roll's player is sent the game's ETH balance divided by 2 (SafeMath div 0x2b18)
    with a 2,300-gas transfer
  for:
  - action
  - what
  - whose
- id: oar
  call: '0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed'
  fn: getAddress()(address)
  is: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  says: the oracle's resolver (the game's slot 0) names this connector
  for:
  - what
- id: sender-now
  nonce: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: 584553
  says: the oracle's first known callback sender has sent 584,553 transactions by the block
  for:
  - justification
  - what
- id: sender-2022
  nonce: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: 584553
  at: 14000000
  says: the first sender's count was the same in January 2022
  for:
  - justification
  - what
- id: sender-unregistered
  call: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  fn: cbAddress()(address)
  from: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: '0x0000000000000000000000000000000000000000'
  says: the connector no longer accepts that sender as a callback address
  for:
  - justification
  - what
- id: s2-2022
  nonce: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  is: 63426
  at: 14000000
  says: the oracle's second known callback sender had sent 63,426 transactions by January 2022
  for:
  - justification
  - what
- id: s2-now
  nonce: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  is: 63426
  says: and has sent none since
  for:
  - justification
  - what
- id: s2-unregistered
  call: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  fn: cbAddress()(address)
  from: '0x000042425e06b0B1E8E20A811C91D6864608324B'
  is: '0x0000000000000000000000000000000000000000'
  says: the connector no longer accepts the second sender as a callback address
  for:
  - justification
  - what
- id: query-gas
  bytecode: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  has: 5b6000806000806007935060009250620493e0
  says: the oracle query routine (offset 0x1182) asks for 300,000 callback gas
  for:
  - evidence-3
  - justification
- id: oracle-fee
  call: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  fn: getPrice(string,uint256)(uint256)
  args:
  - random
  - 300000
  from: '0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0'
  is: 6042379346001950
  says: the oracle charges the game about 0.006 ETH for a random draw with 300,000 callback gas
  for:
  - evidence-3
  - justification
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

This game takes token stakes and picks winners from an oracle's answer, accepted only with a signed proof. Its signature check gets a fixed 3,000 gas, so under EIP-8151 every answer reverts. A winning roll gets half the game's ETH. The oracle's known senders have sent nothing since January 2022.

## Evidence

- The [deployed code](https://etherscan.io/address/0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0#code) gives the signature precompile a fixed 3,000 gas; the oracle's answer reverts unless that proof check passes.
- Each [roll](https://etherscan.io/address/0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0#code) stakes 10, 100 or 1,000 tokens, paid to the owner; rolls 0 to 18 are answered, the last one (1,000 tokens) is open.
- The [game](https://etherscan.io/address/0x2fcec0d5976e7bab9390a98ab5c148719eb56ee0#code) holds no ETH; anyone can pay a draw's 0.006 ETH oracle fee through getRandom. The owner can sweep ETH with takeAll.

## Reviewer notes

### Mechanism

Unverified code, read from disassembly (decompiler names as leads). roll(uint256): stake in {10,100,1000}, debits stake*1e18 tokens from the caller to the owner (slot 8), records (caller, stake) at slot 0xb, then the Oraclize randomDS query routine 0x1182; roll is non-payable, so its fee comes from the game's balance. getRandom() is payable and jumps straight to 0x1182 with no caller check, so a caller can attach the fee. receiveFromGame() is payable and only logs EthReceived. Both __callback forms require msg.sender == cbAddress() and the proof check 0x1955 == 0; it walks to safer_ecrecover: CALL(3000, 0x01, ...), the only 0x0bb8 push and only call to 0x01. Under EIP-8151 a recovery costs 3,200 or 6,100, the CALL fails, the compare fails and the callback reverts. An accepted answer settles the roll at slot 0xc and pays its player half the game's balance (SafeMath div 0x2b18, 2,300-gas transfer). State: 20 rolls, 19 answered, roll 19 (1,000 tokens) open; 0 ETH; owner 0x67de...8589 is an EOA whose nonce (501) is unchanged since block 14,000,000.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: gas: literal PUSH2 0x0bb8 (3,000) to address 1, below both new prices; a failed call makes the callback revert.
- Ruled out: path-closed: not closed. roll reverts at the block because the game holds no ETH for the fee, but getRandom() takes the fee from its caller: an eth_call of getRandom with 0.01 ETH from 0x...dEaD succeeds at the block (not expressible as a check: call checks carry no value), and without ETH it reverts (getrandom-noeth). Draws stall on the oracle's silence, which the card states.
- Ruled out: direct-path: the callback requires msg.sender == cbAddress(); no other function settles a roll.
- Ruled out: setter: no function changes the gas amount or the proof check; no upgrade function, no DELEGATECALL, EIP-1967 slot empty.
- Ruled out: unused-implementation / children: not a proxy; own state (20 rolls, 19 answered); no copies or dependents in the dossier.
- Ruled out: erc1271 / key-state: not relevant to a gas failure; the recovery fails whatever the key.
- Ruled out: value-whose: the game holds 0 ETH now; a winner is paid half the game's ETH, which anyone can add through receiveFromGame; stakes are the game's own unpriced token and already sit with the owner. The fallback returns any plain ETH transfer to its sender. takeAll succeeds from the owner and reverts from another address.
- Ruled out: oracle liveness: the two known callback senders (0x26588a93...12d51 and 0x000042425e...08324B) have the same nonce at blocks 14,000,000 and 26,438,999, and cbAddress() from either returns zero. A later sender is not excluded: the connector's sender list cannot be read without logs, so the card says the known senders are silent, not that the oracle is dead.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
