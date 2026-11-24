---
id: etherdelta-8d12a197-order-signature
format: 2
title: EtherDelta trusts ECDSA-signed orders to move depositors' funds
status: confirmed
severity: LOW
justification: Depositors' funds can be taken with forged ECDSA orders; the live admin can halt all trading with
  one setting.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  name: EtherDelta
  project: etherdelta
  code: verified
  code_url: https://etherscan.io/address/0x8d12a197cb00d4747a1fe03395095ce2a5cc6819#code
  copies: 1
  upgradeable: 'no'
  admin: '0x1ed014aec47fae44c9e55bac7662c0b78ae61798'
value:
  usd: 36635794
  whose: users
  basis: held
activity: {}
impact: funds-loss
action: Halt trading by pointing accountLevelsAddr at a contract that throws, then give up the admin role; ask depositors
  to withdraw.
evidence_level: source
checks:
- id: signed-order
  source: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  file: EtherDelta.sol
  line: 256
  has: orders[user][hash] || ecrecover(
  says: trade() takes an order that was posted on-chain or one whose ECDSA signature recovers to the maker
  for:
  - evidence-1
  - justification
  - what
- id: post-order
  source: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  file: EtherDelta.sol
  line: 248
  has: orders[msg.sender][hash] = true;
  says: order() posts an order on-chain for the caller, without a signature
  for:
  - what
- id: move
  source: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  file: EtherDelta.sol
  lines:
  - 277
  - 278
  has: tokens[tokenGive][user] = safeSub(tokens[tokenGive][user], safeMul(amountGive, amount) / amountGet);
  says: a filled order debits the maker's balance and credits the caller, at the price given in the order
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  has: 1626ba7e
  absent: true
  says: the code never refers to the ERC-1271 isValidSignature selector
  for:
  - what
- id: deposits
  source: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  file: EtherDelta.sol
  line: 215
  has: tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value)
  says: ETH deposits are credited to the depositor
  for:
  - whose
- id: eth-only-deposit
  source: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  file: EtherDelta.sol
  lines:
  - 177
  - 179
  has: throw;
  says: the fallback throws, so plain ETH transfers are refused and ETH enters only through deposit()
  for:
  - whose
- id: fee-balance
  call: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  fn: balanceOf(address,address)(uint256)
  args:
  - '0x0000000000000000000000000000000000000000'
  - '0xa6dad41066584f15659e718e49afed891e807fdc'
  is: '128082982617643287082'
  says: the fee account's ETH balance is 128.08 ETH, under 1% of the ETH held
  for:
  - whose
- id: withdraw
  source: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  file: EtherDelta.sol
  lines:
  - 219
  - 223
  has: if (!msg.sender.call.value(amount)()) throw;
  says: withdraw() pays the caller its own ETH balance, takes no signature and reads no account-levels address
  for:
  - action
  - evidence-3
- id: withdraw-token
  source: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  file: EtherDelta.sol
  lines:
  - 234
  - 240
  has: if (!Token(token).transfer(msg.sender, amount)) throw;
  says: withdrawToken() pays the caller its own token balance, takes no signature and reads no account-levels address
  for:
  - action
  - evidence-3
- id: no-proxy
  storage: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty, so the address is not a proxy
  for:
  - evidence-2
- id: no-upgrade
  selector: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - evidence-2
- id: admin
  call: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  fn: admin()(address)
  is: '0x1ed014aec47fae44c9e55bac7662c0b78ae61798'
  says: the admin is set
  for:
  - evidence-2
  - justification
- id: admin-eoa
  code: '0x1ed014aec47fae44c9e55bac7662c0b78ae61798'
  is: empty
  says: the admin is an account without code, controlled by one key
  for:
  - evidence-2
  - justification
- id: admin-nonce
  nonce: '0x1ed014aec47fae44c9e55bac7662c0b78ae61798'
  is: 3347
  says: the admin has sent 3,347 transactions, so its key is presumed live
  for:
  - evidence-2
  - justification
- id: levels-setter
  source: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  file: EtherDelta.sol
  lines:
  - 186
  - 189
  has: accountLevelsAddr = accountLevelsAddr_;
  says: the admin alone can set the account-levels address
  for:
  - action
  - evidence-2
  - justification
- id: levels-call
  source: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  file: EtherDelta.sol
  lines:
  - 269
  - 270
  has: AccountLevels(accountLevelsAddr).accountLevel(user);
  says: every trade calls the account-levels contract when its address is not zero
  for:
  - action
  - evidence-2
  - justification
- id: levels-unset
  call: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  fn: accountLevelsAddr()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: the account-levels address is zero, so trades make no external call today
  for:
  - notes
- id: fallback-throws
  call: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  fn: accountLevel(address)(uint256)
  args:
  - '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  reverts: true
  says: EtherDelta itself throws on accountLevel(), so setting it as the account-levels address stops every trade
  for:
  - action
  - justification
- id: change-admin
  source: '0x8d12a197cb00d4747a1fe03395095ce2a5cc6819'
  file: EtherDelta.sol
  lines:
  - 181
  - 184
  has: admin = admin_;
  says: the admin can hand its role to any address
  for:
  - action
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews:
- who: r-8d12a197, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: 're-rated: Re-rated to LOW, pattern PQ-1, as Anon decided (D-028 rule 6): trade() fills an order posted
    on-chain or signed with ECDSA, so a forged signature can trade away a depositor''s balance (15,154 ETH and priced
    tokens held as deposits); the live admin (3,347 txs) can halt all trading with one setting (changeAccountLevelsAddr)
    while withdrawals stay open. A second refuter''s PQ-2 reading is parked for Anon; Claude applied its wording
    point (the trade-time call is unset today) and a fresh refuter agrees on the final card; the first refuter agreed
    before. Claude read the sheet.'
related: []
---

## What happens

EtherDelta fills an order if the maker posted it on-chain or signed it with ECDSA, and moves the maker's deposit to the taker. A quantum attacker who recovers a depositor's key can sign an order selling that deposit for almost nothing, even after the depositor moves to post-quantum authorisation.

## Evidence

- [trade](https://etherscan.io/address/0x8d12a197cb00d4747a1fe03395095ce2a5cc6819#code) accepts an order posted on-chain or one whose ECDSA signature recovers to the maker, then moves the maker's balance.
- The [contract](https://etherscan.io/address/0x8d12a197cb00d4747a1fe03395095ce2a5cc6819) cannot be upgraded, but its active admin can set the address every trade would call (unset today).
- [withdraw](https://etherscan.io/address/0x8d12a197cb00d4747a1fe03395095ce2a5cc6819#code) pays the caller its own balance, takes no signature and makes no call to that address.

## Reviewer notes

### Mechanism

trade (lines 252-263) hashes the order with sha256(this, ...) and throws unless orders[user][hash] is set or ecrecover(sha3(prefix, hash), v, r, s) == user (line 256). tradeBalances (265-279) debits tokens[tokenGive][user] and credits msg.sender at the price in the order's arguments, so a forged order with a tiny amountGet hands over the whole deposit. order (246-250) sets orders[msg.sender][hash]; nothing lets an account switch the ECDSA branch off, and no ERC-1271 call exists, so a depositor who moves its address to post-quantum authorisation stays forgeable. The team's lever: changeAccountLevelsAddr (186-189) lets the admin set accountLevelsAddr, which tradeBalances calls on every trade when it is not zero (269-270). Set to a contract that throws on accountLevel(), for example EtherDelta itself (its fallback throws, 177-179), every trade reverts; withdraw and withdrawToken (219-240) never read that address, so depositors still get out. The admin key is ECDSA too, so after the halt the admin should hand the role to an address nobody controls with changeAdmin (181-184). The admin 0x1ed0...7798 has no code and has sent 3,347 transactions, so it is presumed able to act; under the quantum-exposure rubric that is one known operator changing a setting (LOW, per the final reader's ruling).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for makers with code: the isValidSignature selector 1626ba7e is not in the code, and the only other path is order(), a direct call that does not switch ECDSA off.
- Ruled out: PQ-2: the code accepts no signature scheme besides ECDSA, so the 'accepts newer signatures' line is false here; PQ-1 fits (signed orders checked only with ecrecover).
- Ruled out: unused implementation code: admin() is set, the address holds 15,154 ETH, and scan.window shows 9 recoveries in real transactions; tx 0xabc26d98...82fe (block 26,381,100) emitted logs from this address. It is used on its own, whatever the 7 delegating addresses do.
- Ruled out: an upgrade or a change of the signature check by the admin: EIP-1967 slot empty, no upgradeTo selector, and the admin functions (181-212) set only admin, fee account, account-levels address and lower fees.
- Ruled out: the path being closed today: accountLevelsAddr() is zero, so trade makes no external call and works.
- Ruled out: the value being the operator's: ETH enters only through deposit(), which credits the sender (fallback throws), and the fee account's ETH balance is 128.08 of 15,154 ETH. Not measured: how much of the 17 priced tokens is credited to depositors rather than sent by plain transfer (that needs logs); stray tokens belong to nobody's balance and cannot be taken through trade.
- Ruled out: the unchecked year '2017' from the earlier draft: dropped.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
