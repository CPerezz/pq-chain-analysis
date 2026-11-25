---
id: peggy-f955c57f-sender-gas-limits
format: 2
title: Injective bridge relays can run out of gas once signature checks cost more
status: confirmed
severity: LOW
justification: A real relayed update fails on its sender's gas limit; a higher limit fixes it, so LOW.
category: breaks-at-activation
pattern: PQ-18
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xf955c57f9ea9dc8781965feae0b6a2ace2bad6f3'
  name: Peggy
  project: injective
  code: verified
  code_url: https://etherscan.io/address/0x100dcb8b78c608d148cb207ac3875935dfe6abdc#code
  proxy_of: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  copies: 1
  upgradeable: 'yes'
  admin: '0x4b5dec94b961d06e568f98d69dfeabdf2b25d6bb'
value:
  usd: 4452078
  whose: users
  basis: held
activity: {}
impact: liveness
action: 'Have relayers re-estimate gas under EIP-8151: this valset update used about 49,600 more gas than today,
  46,000 above its limit.'
evidence_level: executed
checks:
- id: ecdsa
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1263
  has: return _signer == ecrecover(messageDigest, _v, _r, _s);
  says: each validator signature is recovered with the builtin ecrecover and compared with the validator's address
  for:
  - evidence-1
  - what
- id: loop
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  lines:
  - 1313
  - 1323
  has: Validator signature does not match.
  says: every supplied signature must recover to its validator, or the call reverts
  for:
  - evidence-1
  - what
- id: update
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  lines:
  - 1349
  - 1391
  has: checkValidatorSignatures(
  says: updateValset checks the current validators' signatures
  for:
  - action
  - what
- id: batch
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  line: 1492
  has: checkValidatorSignatures(
  says: submitBatch checks the current validators' signatures before paying out
  for:
  - what
- id: deposit
  source: '0x100dcb8b78c608d148cb207ac3875935dfe6abdc'
  file: Peggy.sol
  lines:
  - 1549
  - 1557
  has: IERC20(_tokenContract).safeTransferFrom(
  says: sendToInjective pulls users' tokens into the bridge, so what it holds is users' deposits
  for:
  - whose
- id: tx
  tx: '0x92ce6ef15cd5d0f39202de0ea969f44bf64334a9a46f17c5fbffaa3c9d8b70ba'
  to: '0xf955c57f9ea9dc8781965feae0b6a2ace2bad6f3'
  ok: true
  says: the relayed update was sent to this proxy and succeeded
  for:
  - action
  - evidence-2
  - what
- id: replay-today
  replay: '0x92ce6ef15cd5d0f39202de0ea969f44bf64334a9a46f17c5fbffaa3c9d8b70ba'
  run: today
  ok: true
  says: the update passes at today's prices
  for:
  - action
  - evidence-2
- id: replay-8151
  replay: '0x92ce6ef15cd5d0f39202de0ea969f44bf64334a9a46f17c5fbffaa3c9d8b70ba'
  run: eip8151
  ok: false
  says: the update reverts under EIP-8151 with its original gas limit
  for:
  - action
  - evidence-2
  - justification
  - what
- id: replay-more-gas
  replay: '0x92ce6ef15cd5d0f39202de0ea969f44bf64334a9a46f17c5fbffaa3c9d8b70ba'
  run: eip8151_more_gas
  ok: true
  says: with 300,000 more gas the update passes under EIP-8151
  for:
  - action
  - evidence-2
  - justification
  - what
- id: paused
  call: '0xf955c57f9ea9dc8781965feae0b6a2ace2bad6f3'
  fn: paused()(bool)
  is: false
  says: the bridge is not paused at the block
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-f955c57f, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: 'kept: LOW (PQ-18), a lead from the Peggy row: a real updateValset (gas limit 312,037) fails under EIP-8151
    as sent and passes with more gas, using about 49,600 more (16 recoveries) than today, 46,000 above its limit;
    the contract fixes no gas amount. Two refuters agreed on the card; Claude changed the action to the measured
    figure and a fresh refuter agrees. Claude read the sheet.'
related: []
---

## What happens

Injective's Peggy bridge accepts validator-set updates and withdrawal batches when validators holding enough power sign with ECDSA. Under EIP-8151 each check costs more: a real update sent with a tight gas limit runs out of gas, and passes with more gas.

## Evidence

- [checkValidatorSignatures](https://etherscan.io/address/0x100dcb8b78c608d148cb207ac3875935dfe6abdc#code) recovers each validator signature with ecrecover until the power passes the threshold.
- [An updateValset transaction](https://etherscan.io/tx/0x92ce6ef15cd5d0f39202de0ea969f44bf64334a9a46f17c5fbffaa3c9d8b70ba) reverts when replayed under EIP-8151 as sent, and passes with 300,000 more gas.

## Reviewer notes

### Mechanism

updateValset and submitBatch (callable by anyone) check the supplied validator set against the stored checkpoint, then checkValidatorSignatures (lines 1296-1336) calls verifySig, which compares the stored validator with Solidity's ecrecover of an eth_sign digest (line 1263), summing power until it passes state_powerThreshold. ecrecover is the builtin, which forwards all remaining gas: the code fixes no gas amount. Under EIP-8151 every recovery costs more, so a transaction whose sender left little margin over today's use runs out of gas. Replay of 0x92ce6ef1 (updateValset, called directly on the proxy by an EOA relayer, reward amount 0 so no token transfer): passes today, reverts under EIP-8151 as sent, passes under EIP-8151 with 300,000 more gas. The proxy is live at the block: paused() is false.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a gas amount fixed in code: verifySig uses Solidity's builtin ecrecover (line 1263), which forwards all gas, and the eip8151_more_gas replay passes, so the limit at fault is the sender's.
- Ruled out: other signed steps in the failing transaction: it calls updateValset on this proxy directly; the only signature checks in it are this contract's validator checks.
- Ruled out: an unused address: this proxy is the bridge in use (paused() false at the block; 93 transactions in the trace window); no copies listed.
- Ruled out: replay 0xa1c4a144 (submitBatch, many signatures) passes under EIP-8151 as sent; only the tight one fails.
- Ruled out: separate issue, not folded in: a validator whose account takes real code stops counting (replay 0x532303a4, run eip8151_signer_code, reverts; an EIP-7702 delegation keeps working). That is a migration notice on its own row; the recovered validators have no code at the block.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
