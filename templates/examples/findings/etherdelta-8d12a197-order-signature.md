---
id: etherdelta-8d12a197-order-signature
format: 2
title: EtherDelta trusts ECDSA-signed orders to move depositors' funds
status: confirmed
severity: HIGH
justification: Depositors' funds can be taken with a forged signature, and nobody can change the contract.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-17
block: 26431214
contract:
  address: "0x8d12a197cb00d4747a1fe03395095ce2a5cc6819"
  name: EtherDelta
  project: etherdelta
  label:
  code: verified
  code_url: https://etherscan.io/address/0x8d12a197cb00d4747a1fe03395095ce2a5cc6819#code
  proxy_of:
  copies: 1
  family:
  upgradeable: "no"
  admin: "0x1ed014aec47fae44c9e55bac7662c0b78ae61798"
value:
  usd: 36707185
  whose: users
  basis: held
activity:
  txs_90d:
  last: 2026-11-15
impact: funds-loss
action: Ask depositors to withdraw; the contract cannot be changed and withdrawals need no signature.
evidence_level: source
checks:
- id: signed-order
  source: "0x8d12a197cb00d4747a1fe03395095ce2a5cc6819"
  file: EtherDelta.sol
  line: 256
  has: "orders[user][hash] || ecrecover("
  says: trade() takes an order that was posted on-chain or one signed with ECDSA
  for: [what, evidence-1, justification]
- id: deposits
  source: "0x8d12a197cb00d4747a1fe03395095ce2a5cc6819"
  file: EtherDelta.sol
  line: 215
  has: "tokens[0][msg.sender] = safeAdd(tokens[0][msg.sender], msg.value)"
  says: what the contract holds is credited to its depositors
  for: [what, justification]
- id: no-proxy
  storage: "0x8d12a197cb00d4747a1fe03395095ce2a5cc6819"
  slot: "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc"
  is: 0
  says: the EIP-1967 implementation slot is empty, so the address is not a proxy
  for: [evidence-2, justification]
- id: no-upgrade
  selector: "0x8d12a197cb00d4747a1fe03395095ce2a5cc6819"
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for: [evidence-2, justification]
- id: withdraw
  source: "0x8d12a197cb00d4747a1fe03395095ce2a5cc6819"
  file: EtherDelta.sol
  lines: [219, 222]
  has: "msg.sender.call.value(amount)()"
  says: withdraw() pays the caller its own balance and takes no signature
  for: [action]
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
reviews:
- who: Review20
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
  note: full source read; HIGH kept
related: []
---

## What happens

EtherDelta, a 2017 exchange, fills an order if the maker posted it on-chain or signed it with ECDSA. A quantum
attacker who recovers a depositor's key can sign an order that sells that depositor's balance for almost nothing.

## Evidence

- `trade()`, line 256 of the [verified source](https://etherscan.io/address/0x8d12a197cb00d4747a1fe03395095ce2a5cc6819#code):
  an order counts if it was posted on-chain or if `ecrecover(…) == user`.
- No proxy and no upgrade function in the [contract](https://etherscan.io/address/0x8d12a197cb00d4747a1fe03395095ce2a5cc6819).

## Reviewer notes

### Mechanism

`trade()` (lines 252-260) hashes the order with `sha256(this, …)` and accepts it if `orders[user][hash]` is set or
`ecrecover(sha3("\x19Ethereum Signed Message:\n32", hash), v, r, s) == user`; `tradeBalances` then moves the maker's
`tokenGive` balance to `msg.sender`. `order()` sets `orders[msg.sender][hash]` and does not switch the ECDSA path off.
`cancelOrder` uses the same check. No ERC-1271.

### Checks

- Block 26,431,214: code 6,613 bytes; the EIP-1967 implementation slot is empty; `admin()` is 0x1ed0…7798, which can
  change the admin, the fee account and the account-levels contract and lower fees, nothing else; 15,154.04 ETH and
  17 priced tokens, $36.7M (the first study counted $39.8M with tokens the tool does not price).
- Activity: 311 transactions from 2026-10-16 to 2026-11-16 (Xatu, any function); the 90-day count was not measured.
- Study eip-8151-impact (2026-11-19) replayed tx 0xabc26d98…82fe: with code at the signer the trade reverts; with a
  7702 delegation it passes.

### History

- 2026-11-04: classified (study top-callers-classification).
- 2026-11-17: filed HIGH (exposure rubric, step 4); reviewed, HIGH kept.
- 2026-11-19: study eip-8151-impact: EIP-8151 closes the path for depositors who move to an account with code.
