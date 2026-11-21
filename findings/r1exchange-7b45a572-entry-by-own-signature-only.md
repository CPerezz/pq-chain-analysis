---
id: r1exchange-7b45a572-entry-by-own-signature-only
format: 2
title: R1Exchange depositors whose accounts take real code can no longer trade
status: candidate
severity: INFORMATIONAL
justification: Breaks only if a depositor moves to real code; its ETH here is stuck if that code needs over 2,300
  gas.
category: migration-notice
pattern: PQ-21
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  name: R1Exchange
  code: verified
  code_url: https://etherscan.io/address/0x7b45a572ea991887a01fd919c05edf1cac79c311#code
  copies: 2
  family: d556a97c0f05d2eaf51eb07fee318a28
  upgradeable: 'no'
  admin: '0xfe2d982f5b8f7281dd665f153a1b9f5bd64645e7'
value:
  usd: 1185
  basis: held
activity: {}
impact: funds-locked
action: Tell depositors to finish trading before moving to real code, and to withdraw ETH first unless the new code
  accepts a 2,300-gas transfer.
evidence_level: source
checks:
- id: ec-maker
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  line: 361
  has: v[0], r[0], s[0]) == makerOrder.user);
  says: trade requires the maker's ECDSA signature to recover to the maker
  for:
  - action
  - evidence-1
  - justification
  - what
- id: ec-taker
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  line: 362
  has: v[1], r[1], s[1]) == takerOrder.user);
  says: trade requires the taker's ECDSA signature to recover to the taker
  for:
  - action
  - evidence-1
  - justification
  - what
- id: only-admin-trade
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  lines:
  - 314
  - 324
  has: onlyAdmin
  says: only an admin can submit a trade
  for:
  - evidence-1
  - what
- id: ec-withdraw
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  line: 247
  has: v, r, s) == user);
  says: adminWithdraw requires the user's ECDSA signature to recover to the user
  for:
  - what
- id: only-admin-withdraw
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  lines:
  - 231
  - 235
  has: onlyAdmin
  says: only an admin can submit a signed withdrawal
  for:
  - notes
- id: withdraw-no-limit
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  lines:
  - 209
  - 218
  has: require(msg.sender.send(amount));
  says: withdrawNoLimit pays the caller from its own balance, with no signature, when withdrawals are enabled
  for:
  - evidence-2
  - what
- id: enabled
  call: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  fn: withdrawEnabled()(bool)
  is: true
  says: direct withdrawals are switched on at this address
  for:
  - evidence-2
- id: stop
  call: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  fn: stop()(bool)
  is: false
  says: trading is not stopped at this address
  for:
  - evidence-2
- id: withdraw
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  lines:
  - 187
  - 205
  has: safeSub(block.timestamp, latestApply[token][msg.sender]) > applyWait
  says: withdraw pays the caller once applyWait has passed since its application, with no signature
  for:
  - what
- id: apply
  call: '0xe18898c76a39ba4cd46a544b87ebe1166fbe7052'
  fn: applyWait()(uint256)
  is: 86400
  says: the copy's wait between an application and a withdrawal is one day
  for:
  - notes
- id: copy-disabled
  call: '0xe18898c76a39ba4cd46a544b87ebe1166fbe7052'
  fn: withdrawEnabled()(bool)
  is: false
  says: direct withdrawals without a wait are off at the copy
  for:
  - notes
- id: deposit
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  line: 146
  has: tokenList[0][msg.sender] = safeAdd(tokenList[0][msg.sender], msg.value);
  says: deposits are credited to the depositor's own balance
  for:
  - notes
- id: send-withdraw
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  line: 200
  has: require(msg.sender.send(amount));
  says: withdraw pays ETH with send, which forwards 2,300 gas
  for:
  - action
  - evidence-3
  - justification
- id: send-nolimit
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  line: 213
  has: require(msg.sender.send(amount));
  says: withdrawNoLimit pays ETH with send, which forwards 2,300 gas
  for:
  - action
  - evidence-3
  - justification
- id: send-admin
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  line: 252
  has: require(user.send(amount));
  says: adminWithdraw pays ETH with send, which forwards 2,300 gas
  for:
  - action
  - evidence-3
  - justification
- id: fee-withdraw
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  line: 249
  has: tokenList[token][feeAccount] = safeAdd(tokenList[token][feeAccount], fee);
  says: withdrawal fees are credited to a fee account in the depositors' ledger
  for:
  - notes
- id: fee-token
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  line: 412
  has: tokenList[order.feeToken][feeAccount] = safeAdd(
  says: trade fees paid in a fee token are credited to a fee account in the same ledger
  for:
  - notes
- id: fee-buy
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  line: 417
  has: tokenList[order.tokenBuy][feeAccount] = safeAdd(
  says: trade fees taken from the bought token are credited to a fee account in the same ledger
  for:
  - notes
- id: batch-admin
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  lines:
  - 421
  - 431
  has: trade(addresses[i], values[i], v[i], r[i], s[i]);
  says: batchTrade is admin-only and only loops over trade
  for:
  - what
- id: balance-internal
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  line: 367
  has: function balance(Order makerOrder, Order takerOrder, address feeAccount, uint256 tradeAmount) internal {
  says: the balance swap of a trade is internal; no public function trades
  for:
  - evidence-1
  - justification
  - what
- id: send-refund
  source: '0x7b45a572ea991887a01fd919c05edf1cac79c311'
  file: R1Exchange.sol
  line: 440
  has: require(user.send(amount));
  says: the admin refund pays ETH with send, which forwards 2,300 gas
  for:
  - action
  - evidence-3
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

R1Exchange trades only when its admin submits two orders that both traders signed with ECDSA; no direct call trades. A depositor whose account takes real code can no longer trade or sign a withdrawal, but can still withdraw by a direct call. An EIP-7702 delegation keeps working.

## Evidence

- [trade](https://etherscan.io/address/0x7b45a572ea991887a01fd919c05edf1cac79c311#code) is admin-only, needs both recovered signers to equal the named traders, and moves balances internally.
- [withdrawNoLimit](https://etherscan.io/address/0x7b45a572ea991887a01fd919c05edf1cac79c311#code) pays the caller with no signature and is switched on here; trading is not stopped.
- [Every ETH payout](https://etherscan.io/address/0x7b45a572ea991887a01fd919c05edf1cac79c311#code) (withdraw, withdrawNoLimit, signed withdrawal, refund) uses send, which forwards 2,300 gas.

## Reviewer notes

### Mechanism

trade (lines 314-366) is onlyAdmin, isFeeAccount and notStop; it hashes each order with getOrderHash and requires ecrecover of the eth-signed hash to equal makerOrder.user (line 361) and takerOrder.user (line 362), then calls the internal balance() (line 367) to swap both users' tokenList balances. batchTrade (421-431) is onlyAdmin and only loops trade. There is no on-chain order posting and no public function that moves balances between users, so trading needs both signatures. adminWithdraw (231-257) is onlyAdmin and requires ecrecover(...) == user (line 247): this is the signed shortcut beside the direct exits withdraw (187-205, after applyWithdraw and applyWait, 86,400 s at the copy, capped at 7 days by line 124) and withdrawNoLimit (209-218, when withdrawEnabled: true here, false at the copy 0xe18898c76a39ba4cd46a544b87ebe1166fbe7052). Every ETH payout is send with 2,300 gas (lines 200, 213, 252, 440). A depositor with ETH whose new code needs more gas to receive cannot withdraw it, and trading the ETH into a token is the signed path it lost, so that ETH is locked.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-size path for signers with code: trade and adminWithdraw compare ecrecover with the user directly (lines 247, 361, 362); the selector 1626ba7e is absent from the code.
- Ruled out: a direct way to trade: trade and batchTrade are onlyAdmin (lines 321, 427) and balance() is internal (line 367); the signed withdrawal does have direct alternatives (withdraw, withdrawNoLimit), so it is named in a sentence, not as the root issue.
- Ruled out: a fixed gas amount for the precompile: each of the three recoveries forwards all gas but 25,710 (PUSH2 0x646e GAS SUB CALL), not a constant.
- Ruled out: a closed path: stop() is false at this address at the block; whether any admin still submits trades is not read (the admins mapping cannot be listed without logs), and the owner can appoint admins with setAdmin (line 112).
- Ruled out: the 2,300-gas ETH transfer is not caused by EIP-8151: it fails today for any receiver whose code needs more gas; it makes the ETH locked only together with the lost signed trading.
- Ruled out: a signature checked again after others relied on it: each order and withdrawal signature is checked once, in the transaction that moves the balances.

### Questions

- How much of the balance belongs to depositors and how much to the operator's fee accounts: trade and withdrawal fees are credited to fee accounts in the same ledger as deposits (lines 249, 412, 417), and the fee accounts cannot be listed without a log scan.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
