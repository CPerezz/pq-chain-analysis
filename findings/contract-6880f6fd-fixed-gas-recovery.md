---
id: contract-6880f6fd-fixed-gas-recovery
format: 2
title: Fuel v1 lets anyone prove an honest signed block invalid under EIP-8151
status: candidate
severity: CRITICAL
justification: No update path, and a wrong fraud verdict pays the caller half of an honest producer's bond.
category: breaks-at-activation
pattern: PQ-14
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6880f6fd960d1581c2730a451a22eed1081cfd72'
  code: bytecode
  code_url: https://etherscan.io/address/0x6880f6fd960d1581c2730a451a22eed1081cfd72#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 18
  whose: users
  basis: held
activity:
  txs_90d: 6
impact: funds-loss
action: Commit no block of key-signed transactions within 93,046 blocks (about 13 days) before EIP-8151 activates,
  or after.
evidence_level: bytecode
checks:
- id: fixed-gas
  bytecode: '0x6880f6fd960d1581c2730a451a22eed1081cfd72'
  has: 6001610bb8f15060a051
  says: the deployed code calls address 1 with a fixed 3,000 gas, drops the success flag and reads the output word
  for:
  - action
  - evidence-1
  - justification
  - what
- id: price
  ref: https://github.com/ethereum/EIPs/blob/8194528a2ee9a4893a398a5871c470ab0ac3b09a/EIPS/eip-8151.md
  says: 'EIP-8151 at the study''s pinned commit: a successful recovery costs 200 (warm) or 3,100 (cold) gas more
    than 3,000'
  for:
  - what
- id: src-deployment
  ref: https://github.com/FuelLabs/fuel-v1-contracts/blob/2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22/src/deployments/Fuel.json#L3
  says: Fuel's repository records this address as its v1 mainnet deployment
  for:
  - evidence-1
  - what
- id: src-ecrecover
  ref: https://github.com/FuelLabs/fuel-v1-contracts/blob/2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22/src/Witness.yulp#L120-L145
  says: 'the helper calls the precompile with 3,000 gas, ignores the result and returns the cleared output word:
    zero on failure'
  for:
  - action
  - evidence-1
  - what
- id: src-null
  ref: https://github.com/FuelLabs/fuel-v1-contracts/blob/2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22/src/provers/InvalidWitness.yulp#L20-L31
  says: proveWitness treats a recovered witness of zero as fraud (null-witness)
  for:
  - evidence-2
  - justification
  - what
- id: src-prove
  ref: https://github.com/FuelLabs/fuel-v1-contracts/blob/2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22/src/Fuel.yulp#L213-L222
  says: proveInvalidWitness(bytes) is open to any caller that committed the fraud hash earlier
  for:
  - what
- id: src-fraud
  ref: https://github.com/FuelLabs/fuel-v1-contracts/blob/2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22/src/Fraud.yulp#L69-L133
  says: fraud in a block not yet final moves the tip back before it, clears its commitment and transfers half the
    bond to the caller
  for:
  - action
  - evidence-2
  - justification
  - what
- id: src-dispatch
  ref: https://github.com/FuelLabs/fuel-v1-contracts/blob/2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22/src/Fuel.yulp#L76-L415
  says: the dispatcher lists every external function; none is an owner, admin or upgrade function
  for:
  - action
  - justification
- id: prove-fn
  selector: '0x6880f6fd960d1581c2730a451a22eed1081cfd72'
  fn: proveInvalidWitness(bytes)
  says: the deployed code has the proveInvalidWitness(bytes) entry
  for:
  - what
- id: bond
  call: '0x6880f6fd960d1581c2730a451a22eed1081cfd72'
  fn: BOND_SIZE()(uint256)
  is: '500000000000000000'
  says: each block is committed with a 0.5 ETH bond
  for:
  - what
- id: delay
  call: '0x6880f6fd960d1581c2730a451a22eed1081cfd72'
  fn: FINALIZATION_DELAY()(uint256)
  is: 93046
  says: a block becomes final 93,046 blocks after it is committed
  for:
  - action
  - evidence-3
- id: tip
  call: '0x6880f6fd960d1581c2730a451a22eed1081cfd72'
  fn: blockTip()(uint256)
  is: 8
  says: the rollup has 8 blocks at the block read
  for:
  - evidence-3
- id: tip-before
  call: '0x6880f6fd960d1581c2730a451a22eed1081cfd72'
  fn: blockTip()(uint256)
  is: 7
  at: 26332441
  says: the rollup had 7 blocks just before block 8 was committed
  for:
  - evidence-3
- id: commit-8
  tx: '0xa3edc9b7f682e42f071731ab83b2f966ebbaeacfb5d85c916653ce3ef6f08a1d'
  to: '0x6880f6fd960d1581c2730a451a22eed1081cfd72'
  ok: true
  says: the transaction that committed block 8 at L1 block 26,332,442 (2026-11-03), sent by 0x46c6e5b2d8bc00ff84e043cf567aa31fd5c6dcea
  for:
  - evidence-3
- id: eth-before
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x6880f6fd960d1581c2730a451a22eed1081cfd72'
  is: '251300000000000002'
  at: 26332441
  says: the contract held 0.2513 ETH before block 8
  for:
  - evidence-3
- id: eth-open
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x6880f6fd960d1581c2730a451a22eed1081cfd72'
  is: '751300000000000002'
  at: 26332442
  says: committing block 8 added the 0.5 ETH bond
  for:
  - evidence-3
- id: eth-now
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x6880f6fd960d1581c2730a451a22eed1081cfd72'
  is: '1000000000002'
  says: 'the contract holds 0.000001 ETH at the block read, less than one bond: no block''s bond is held'
  for:
  - evidence-3
- id: usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0x6880f6fd960d1581c2730a451a22eed1081cfd72'
  is: '11000000'
  says: 11 USDC held
  for:
  - evidence-3
  - whose
- id: usdt
  call: '0xdac17f958d2ee523a2206206994597c13d831ec7'
  fn: balanceOf(address)(uint256)
  args:
  - '0x6880f6fd960d1581c2730a451a22eed1081cfd72'
  is: '1000000'
  says: 1 USDT held
  for:
  - evidence-3
  - whose
- id: dai
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: balanceOf(address)(uint256)
  args:
  - '0x6880f6fd960d1581c2730a451a22eed1081cfd72'
  is: '6009500000000000000'
  says: 6.0095 DAI held
  for:
  - evidence-3
  - whose
- id: src-deposit
  ref: https://github.com/FuelLabs/fuel-v1-contracts/blob/2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22/src/Deposit.yulp#L35-L41
  says: deposit credits tokens to the named owner's rollup account
  for:
  - evidence-3
  - whose
- id: src-witness-types
  ref: https://github.com/FuelLabs/fuel-v1-contracts/blob/2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22/src/Transaction.yulp#L545-L578
  says: only the Signature witness type calls ecrecover; Caller uses commitWitness state, Producer uses the block
    producer
  for:
  - action
  - what
- id: src-commit
  ref: https://github.com/FuelLabs/fuel-v1-contracts/blob/2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22/src/Block.yulp#L84-L120
  says: the bond is msg.value; any caller may commit after the submission delay or in penalty mode; the header records
    caller() as producer
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: CRITICAL
reviews:
- who: r-6880f6fd, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: 'kept: CRITICAL candidate (PQ-14), drafted by Claude by hand (D-028 rule 7): Fuel v1''s witness recovery
    calls the precompile with a fixed 3,000 gas and ignores failure, a zero signer counts as fraud, and fraud in
    a block not yet final rolls the rollup back and pays the caller half the producer''s 0.5 ETH bond; no update
    path. Under EIP-8151 any block holding a key-signed transaction can be proved invalid within its 93,046-block
    window. Corrected after the first refuter (whose: depositors'' $18; action covers the 13 days before activation;
    Caller and Producer witnesses recover nothing). Block 8 is final (committed 26,332,442; bond left at 26,425,638):
    both later refuters'' summaries called it open but agreed with the card. Two refuters agree; waits for Anon''s
    sign-off.'
related: []
---

## What happens

Fuel v1 recovers each rollup signature with a fixed 3,000 gas and ignores a failed call. Under EIP-8151 those recoveries fail, so anyone can prove invalid a block holding a key-signed transaction before it is final, roll the rollup back and take half its producer's 0.5 ETH bond.

## Evidence

- The [published helper](https://github.com/FuelLabs/fuel-v1-contracts/blob/2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22/src/Witness.yulp#L120-L145) calls the precompile with 3,000 gas and returns its output unchecked; the deployed code does the same.
- A [zero signer is fraud](https://github.com/FuelLabs/fuel-v1-contracts/blob/2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22/src/provers/InvalidWitness.yulp#L20-L31), and [fraud pays the caller](https://github.com/FuelLabs/fuel-v1-contracts/blob/2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22/src/Fraud.yulp#L69-L133) half the bond.
- Block 8 was [committed on 2026-11-03](https://etherscan.io/tx/0xa3edc9b7f682e42f071731ab83b2f966ebbaeacfb5d85c916653ce3ef6f08a1d) with a 0.5 ETH bond and is final; no block is open now, and the contract holds about $18 of depositors' tokens.

## Reviewer notes

### Mechanism

Witness.yulp ecrecover (lines 120-145) writes the digest, v, r and s to memory, clears the output word at 160, calls address 1 with a fixed 3,000 gas, ignores the success flag and returns the word at 160. The deployed code carries the same sequence at offset 0x2a6f (PUSH1 1, PUSH2 0x0bb8, CALL, POP, PUSH1 0xa0, MLOAD). Under EIP-8151 a successful recovery costs 200 (warm) or 3,100 (cold) gas more, so every recovery of a Signature witness runs out of gas and the helper returns zero; Caller and Producer witnesses recover nothing (Transaction.yulp lines 545-578). proveInvalidWitness(bytes) (Fuel.yulp lines 213-222) needs only the caller's earlier fraud-hash commitment, verifies the inputs and runs proveWitness, whose first assertion (InvalidWitness.yulp lines 20-31) is that the recovered witness is not zero. With zero, assertOrFraud (Fraud.yulp lines 69-133) requires the block not yet final (93,046 blocks), moves the tip back before it, clears its commitment, starts the penalty period and transfers half of BOND_SIZE (0.5 ETH) to the caller. A block is committed with exactly BOND_SIZE as value (Block.yulp line 89); after the submission delay anyone may commit one (lines 98-104). Block 8 was committed at L1 block 26,332,442 by 0x46c6e5b2d8bc00ff84e043cf567aa31fd5c6dcea, final at 26,425,488, and the ETH left before block 26,438,999.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Execution: no recovery through this contract is in the study's trace window and no replay exists; building a fraud proof for an open block was not attempted. The evidence is the deployed bytecode and the published source, which the repository's deployment record ties to this address.
- Ruled out: An update path: the published dispatcher (Fuel.yulp lines 76-415) has no owner, admin or upgrade function, and the deployed code is not a proxy (24,407 bytes).
- Ruled out: Dormancy: the rollup is rarely used but not dormant; block 8 was committed on 2026-11-03 with a 0.5 ETH bond and finalized, and the ETH was withdrawn before the block read.
- Ruled out: Witnesses that need no signature: a transaction authorized on-chain (commitWitness, the Caller type) or by the block producer (the Producer type) recovers nothing (Transaction.yulp lines 545-578), so a block holding only those cannot be proved invalid this way.
- Ruled out: Whose bond: the header records the committing account as the block's producer (Block.yulp lines 84-120); block 8 was committed by the account 0x46c6e5b2d8bc00ff84e043cf567aa31fd5c6dcea, while operator() is a contract.
- Ruled out: The $18 of tokens are credited to depositors' rollup accounts (Deposit.yulp lines 35-41); what a rollback does to their exits was not read.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
