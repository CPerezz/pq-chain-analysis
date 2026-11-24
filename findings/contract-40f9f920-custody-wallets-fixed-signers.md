---
id: contract-40f9f920-custody-wallets-fixed-signers
format: 2
title: Wallet with fixed owners locks its ETH if they move accounts to real code
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if owners move their accounts to real code; three owners can first move the ETH to a
  new wallet.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  label: Amina Deposit
  code: bytecode
  code_url: https://etherscan.io/address/0x40f9f920ece7cce223625c088a6c1281ef396cf2#code
  copies: 622
  family: 41d5f6fd5664c2004bb441bf88ab4aa7
  upgradeable: 'no'
value:
  usd: 36462814
  basis: held
activity:
  txs_90d: 10
impact: funds-locked
action: Before any owner moves its account to real code, have three owners sign a transfer of the funds to a wallet
  whose owners can change.
evidence_level: executed
checks:
- id: dispatch
  bytecode: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  has: 60806040526004361061009f575f3560e01c80639e4e7318116100635780639e4e731814610227578063a0ab965314610251578063a0e67e2b14610279578063affed0e0146102a3578063ba9a91a5146102cd578063f698da25146102f7576100df565b806304622c2e146101435780631279991b1461016d5780632f54bf6e1461019757806333330fe0146101d357806342cde4e8146101fd576100df56
  says: the dispatcher routes eleven selectors and sends anything else to the fallback
  for:
  - action
  - evidence-1
  - what
- id: fallback
  bytecode: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  has: 5b366100df577fe1fffcc4923d04b559f4d29a8bfc6cda04eb5b0d3c460751c2402c5c5cc9109c33346040516100d59291906109b2565b60405180910390a1005b335f357fffffffff0000000000000000000000000000000000000000000000000000000016346040517fc46a58f800000000000000000000000000000000000000000000000000000000815260040161013a93929190610a13565b60405180910390fd
  says: a call without data only logs a deposit; any other unknown call reverts
  for:
  - what
- id: lencheck
  bytecode: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  has: 5b600154875114
  says: execute compares the number of signatures with the threshold in slot 1
  for:
  - what
- id: loop
  bytecode: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  has: 5b60015481101561073c575f6001
  says: the loop runs threshold times and calls precompile 0x01 (ecrecover)
  for:
  - evidence-1
  - justification
  - what
- id: recover
  bytecode: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  has: 5afa15801561063a573d5f5f3e3d5ffd5b5050506020604051035190508273ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff16116106ab576040517f39d43e8800000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b60025f8273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f9054906101000a900460ff1661072b57
  says: ecrecover gets all gas; the recovered address must exceed the previous one and be marked in the owner mapping
    at slot 2, else revert
  for:
  - evidence-1
  - evidence-3
  - justification
  - what
- id: sstore
  bytecode: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  has: 5b5060015f5461074b9190611293565b5f81905550
  says: after the signatures execute writes nonce + 1 to slot 0
  for:
  - action
  - evidence-1
  - what
- id: callseg
  bytecode: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  has: 5b5f8873ffffffffffffffffffffffffffffffffffffffff16888690896040516107c29190611318565b5f60405180830381858888f1
  says: execute then calls the signed destination with the signed value and data
  for:
  - action
  - justification
  - what
- id: selnonce
  selector: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  fn: nonce()
  says: one of the eleven selectors is the nonce getter
  for:
  - what
- id: selthreshold
  selector: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  fn: threshold()
  says: one of the eleven selectors is the threshold getter
  for:
  - what
- id: selisowner
  selector: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  fn: isOwner(address)
  says: one of the eleven selectors is the owner lookup
  for:
  - what
- id: selgetowners
  selector: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  fn: getOwners()
  says: one of the eleven selectors lists the owners
  for:
  - what
- id: seldomain
  selector: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  fn: domainSeparator()
  says: one of the eleven selectors is the domain separator getter
  for:
  - what
- id: selname
  selector: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  fn: NAME_HASH()
  says: one of the eleven selectors is a constant getter
  for:
  - what
- id: selversion
  selector: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  fn: VERSION_HASH()
  says: one of the eleven selectors is a constant getter
  for:
  - what
- id: seltxtype
  selector: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  fn: TXTYPE_HASH()
  says: one of the eleven selectors is a constant getter
  for:
  - what
- id: selsalt
  selector: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  fn: SALT()
  says: one of the eleven selectors is a constant getter
  for:
  - what
- id: domaintype
  call: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  data: '0x33330fe0'
  is: '0xd87cd6ef79d4e2b95e15ce8abf732db51ec771f1ca2edccf22a46c729ac56472'
  says: the eleventh selector returns the EIP-712 domain type hash, a constant
  for:
  - what
- id: no1271a
  selector: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: the code never asks a signer through ERC-1271
  for:
  - what
- id: no1271b
  selector: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  fn: isValidSignature(bytes,bytes)
  absent: true
  says: nor through the legacy ERC-1271 selector
  for:
  - what
- id: threshold
  call: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  fn: threshold()(uint256)
  is: 3
  says: three signatures are needed
  for:
  - action
  - evidence-1
  - evidence-3
  - justification
  - what
- id: owners
  call: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  fn: getOwners()(address[])
  is:
  - '0x07f08a83e8be14a51e283e293aef7b30b3e9f679'
  - '0x166b4d6eb73d06ddeaef61f0fe3f4b1ac6c76a78'
  - '0x23c42048ac9a3e0bef1e75cfff6c3f341824353a'
  - '0xbe4ce2ca694f87c125aad17779ca70c93d1d75be'
  - '0xd9c19e0a49f2f7fabb0f5a36bb5ab34762dbcfac'
  - '0xed2be45f5819f873a8e6536ae365e0776c6a0adb'
  - '0xfad043f5dc616af8cc5235445c4fa596a39a0678'
  says: the wallet has seven owners
  for:
  - evidence-1
  - what
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  is: '20205930730000000483328'
  says: the wallet holds 20,205.93 ETH
  for:
  - what
- id: exectx
  tx: '0xa5bca887d190eb57bb30e3a945255b44ae1f0cd12b5f3ba795706e60f22403df'
  to: '0x40f9f920ece7cce223625c088a6c1281ef396cf2'
  ok: true
  says: a signed execute on this wallet succeeded in November 2026
  for:
  - action
  - evidence-3
  - justification
- id: o1
  code: '0x07f08a83e8be14a51e283e293aef7b30b3e9f679'
  is: empty
  says: owner 1 has no code
  for:
  - evidence-3
- id: o2
  code: '0x166b4d6eb73d06ddeaef61f0fe3f4b1ac6c76a78'
  is: empty
  says: owner 2 has no code
  for:
  - evidence-3
- id: o3
  code: '0x23c42048ac9a3e0bef1e75cfff6c3f341824353a'
  is: empty
  says: owner 3 has no code
  for:
  - evidence-3
- id: o4
  code: '0xbe4ce2ca694f87c125aad17779ca70c93d1d75be'
  is: empty
  says: owner 4 has no code
  for:
  - evidence-3
- id: o5
  code: '0xd9c19e0a49f2f7fabb0f5a36bb5ab34762dbcfac'
  is: empty
  says: owner 5 has no code
  for:
  - evidence-3
- id: o6
  code: '0xed2be45f5819f873a8e6536ae365e0776c6a0adb'
  is: empty
  says: owner 6 has no code
  for:
  - evidence-3
- id: o7
  code: '0xfad043f5dc616af8cc5235445c4fa596a39a0678'
  is: empty
  says: owner 7 has no code
  for:
  - evidence-3
- id: twincode
  code: '0xa712fc560cdb8f7055308c7f160d7450892c11c9'
  is: contract
  bytes: 5201
  says: the replayed wallet holds code of the same size
  for:
  - evidence-2
- id: twinrecover
  bytecode: '0xa712fc560cdb8f7055308c7f160d7450892c11c9'
  has: 5afa15801561063a573d5f5f3e3d5ffd5b5050506020604051035190508273ffffffffffffffffffffffffffffffffffffffff168173ffffffffffffffffffffffffffffffffffffffff16116106ab576040517f39d43e8800000000000000000000000000000000000000000000000000000000815260040160405180910390fd5b60025f8273ffffffffffffffffffffffffffffffffffffffff1673ffffffffffffffffffffffffffffffffffffffff1681526020019081526020015f205f9054906101000a900460ff1661072b57
  says: the replayed wallet runs the same recovery and owner check
  for:
  - evidence-2
- id: replaytoday
  replay: '0x719e8198658cb1558a9f47f6ccea03e54b637339eee71d04ceddc3c0dd7c3a11'
  run: today
  ok: true
  says: the replay reproduces the real payout
  for:
  - evidence-2
- id: replay8151
  replay: '0x719e8198658cb1558a9f47f6ccea03e54b637339eee71d04ceddc3c0dd7c3a11'
  run: eip8151
  ok: true
  says: under EIP-8151 alone the payout still succeeds
  for:
  - evidence-2
- id: replaycode
  replay: '0x719e8198658cb1558a9f47f6ccea03e54b637339eee71d04ceddc3c0dd7c3a11'
  run: eip8151_signer_code
  ok: false
  says: with real code at a signer the payout reverts
  for:
  - evidence-2
  - justification
  - what
- id: replaydeleg
  replay: '0x719e8198658cb1558a9f47f6ccea03e54b637339eee71d04ceddc3c0dd7c3a11'
  run: eip8151_signer_delegated
  ok: true
  says: with an EIP-7702 delegation at the signer it succeeds
  for:
  - evidence-2
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews:
- who: r-40f9f920, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 're-rated: An unverified 3-of-7 wallet holding 20,205.93 ETH whose owners are fixed: no function adds, removes
    or replaces one, and nothing upgrades it; all seven owners are code-less at the block; 621 more addresses run
    this code. INFORMATIONAL, PQ-17 (was HIGH): nothing breaks unless owners move their accounts to real code, and
    three owners can first move the ETH; the same reading as the five wallets-fixed-signers rows already settled.
    Evidence is bytecode, one real payout of November 2026 and the replays of a same-code wallet (works today and
    under EIP-8151, fails with code at a signer, works with a delegation there). Author A-40f9f920; refuter R-40f9f920
    disassembled the code itself and agreed with no objection; the reader changed nothing. Not this row''s card:
    three forged owner keys would move the ETH (PQ-12); no row carries that for this wallet, parked for Anon.'
related: []
---

## What happens

This wallet moves funds only when three of its seven owners sign with ECDSA. Its owners are fixed: no function adds, removes or replaces one. An owner whose account takes real code stops counting, so if five of them do, the wallet's ETH is locked; an EIP-7702 delegation keeps working.

## Evidence

- [The wallet's code](https://etherscan.io/address/0x40f9f920ece7cce223625c088a6c1281ef396cf2#code) recovers each signature with ECDSA, accepts only listed owners, needs three of seven and cannot change them.
- A replay of [a real payout](https://etherscan.io/tx/0x719e8198658cb1558a9f47f6ccea03e54b637339eee71d04ceddc3c0dd7c3a11) by a wallet with the same code reverts once a signer has real code, and succeeds with an EIP-7702 delegation.
- [This payout](https://etherscan.io/tx/0xa5bca887d190eb57bb30e3a945255b44ae1f0cd12b5f3ba795706e60f22403df) carried three owner signatures; none of the seven owner accounts has code today.

## Reviewer notes

### Mechanism

execute(uint8[],bytes32[],bytes32[],address,uint256,bytes,address,uint256) requires exactly threshold signatures (slot 1, 3 at the block) and the executor argument to be the caller or zero. It hashes the call (destination, value, data, nonce from slot 0, executor, gas limit) under the stored EIP-712 domain separator (slot 3), then for each signature calls the ecrecover precompile with all remaining gas, requires the recovered address to be above the previous one (so address zero never passes) and isOwner[recovered] (mapping at slot 2), and reverts otherwise. It then writes nonce + 1, the only storage write in the runtime code, requires code at a destination that receives data, and calls the destination with the value, data and signed gas limit. Owners and threshold are written only at deployment. The other ten functions are getters (nonce, threshold, isOwner, getOwners, domainSeparator, EIP-712 constants); a call without data emits a deposit event and any other call reverts. No DELEGATECALL, CREATE or SELFDESTRUCT. An owner with real code makes ecrecover return nothing, the recovered address reads as zero and execute reverts; with seven owners and a threshold of three, the wallet keeps working while three owners have no code.

### Checks

- Header facts: this address alone, at block 26,438,999; 622 addresses run this code.
- Ruled out: an ERC-1271 or code-size path for owners with code: neither ERC-1271 selector is in the code, and its one static call is the recovery.
- Ruled out: a way to replace owners or upgrade: eleven functions, ten of them getters; execute writes only the nonce; no delegatecall.
- Ruled out: a direct path: execute needs the signatures whoever calls it; the executor field only limits who submits.
- Ruled out: breaks by itself: the recovery gets all remaining gas; the replay under EIP-8151 alone succeeds (84,812 gas of a 120,000 limit).
- Ruled out: unused address: not a proxy; it executed a payout in November 2026 and holds 20,205.93 ETH at the block.
- Ruled out: owners already with code: all seven accounts are empty at the block.
- Ruled out: copies: 621 more addresses run this code; the replay is of 0xa712fc560cdb8f7055308c7f160d7450892c11c9, same code, a direct call paying an account without code.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
