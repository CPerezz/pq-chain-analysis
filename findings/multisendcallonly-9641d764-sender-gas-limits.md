---
id: multisendcallonly-9641d764-sender-gas-limits
format: 2
title: Safe batches sent with a tight gas limit run out of gas under EIP-8151
status: confirmed
severity: LOW
justification: A real batch fails under EIP-8151 as sent and passes with more gas; its sender only has to raise
  the gas limit.
category: breaks-at-activation
pattern: PQ-18
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x9641d764fc13c8b624c04430c7356c1c7c8102e2'
  name: MultiSendCallOnly
  code: verified
  code_url: https://etherscan.io/address/0x9641d764fc13c8b624c04430c7356c1c7c8102e2#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity: {}
impact: liveness
action: 'Re-estimate the gas limit of batches under EIP-8151: this one used 15,100 more gas, 10,185 above its limit.'
evidence_level: executed
checks:
- id: forwards
  source: '0x9641d764fc13c8b624c04430c7356c1c7c8102e2'
  file: contracts/libraries/MultiSendCallOnly.sol
  line: 51
  has: success := call(gas(), to, value, data, dataLength, 0, 0)
  says: each entry of the batch is called with all the gas left; no gas amount is fixed
  for:
  - action
  - evidence-2
  - what
- id: reverts-all
  source: '0x9641d764fc13c8b624c04430c7356c1c7c8102e2'
  file: contracts/libraries/MultiSendCallOnly.sol
  lines:
  - 57
  - 59
  has: revert(0, 0)
  says: when one call fails the whole batch reverts
  for:
  - evidence-2
  - what
- id: tx
  tx: '0x09827fd946d676f0c1ed2123efc82c8a9e8ee00cfbee153ea8160453e8391328'
  to: '0x9641d764fc13c8b624c04430c7356c1c7c8102e2'
  ok: true
  says: a real transaction sent to this contract succeeded on chain
  for:
  - action
  - evidence-1
  - justification
  - what
- id: today
  replay: '0x09827fd946d676f0c1ed2123efc82c8a9e8ee00cfbee153ea8160453e8391328'
  run: today
  ok: true
  says: the replay under today's rules passes, as the receipt
  for:
  - evidence-1
  - justification
  - what
- id: price
  replay: '0x09827fd946d676f0c1ed2123efc82c8a9e8ee00cfbee153ea8160453e8391328'
  run: eip8151
  ok: false
  says: the same transaction fails under EIP-8151 as sent
  for:
  - action
  - evidence-1
  - justification
  - what
- id: more-gas
  replay: '0x09827fd946d676f0c1ed2123efc82c8a9e8ee00cfbee153ea8160453e8391328'
  run: eip8151_more_gas
  ok: true
  says: under EIP-8151 with 300,000 more gas it passes, so only the sender's gas limit fails it
  for:
  - action
  - evidence-1
  - justification
  - what
- id: threshold
  call: '0x74eb970cb623634168904a92ca4c54d2d25a6e64'
  fn: getThreshold()(uint256)
  args: []
  is: 4
  says: the Safe the batch calls needs four owner signatures per transaction
  for:
  - what
- id: safe-version
  call: '0x74eb970cb623634168904a92ca4c54d2d25a6e64'
  fn: VERSION()(string)
  args: []
  is: 1.4.1
  says: the contract the batch calls is a Safe, version 1.4.1
  for:
  - notes
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

This contract runs a batch of calls in one transaction and reverts all of them if one fails. A real batch of calls to a Safe that needs four owner signatures had a tight gas limit: under EIP-8151 the signature checks cost more and the batch runs out of gas.

## Evidence

- [This batch](https://etherscan.io/tx/0x09827fd946d676f0c1ed2123efc82c8a9e8ee00cfbee153ea8160453e8391328) passes today; under EIP-8151 it fails as sent and passes with more gas.
- [multiSend](https://etherscan.io/address/0x9641d764fc13c8b624c04430c7356c1c7c8102e2#code) gives each call all the gas left and reverts the batch when a call fails.

## Reviewer notes

### Mechanism

multiSend (MultiSendCallOnly.sol, lines 25-64) loops over packed entries, calls each target with gas() (line 51) and reverts when a call fails (lines 57-59). It has no signature check and fixes no gas amount. Transaction 0x09827fd9… (block 26,436,226) is sent by an EOA straight to this address, gas limit 477,135, and used 472,220. Its calldata decodes to eight entries, all execTransaction (0x6a761202) on the Safe 0x74eb970cb623634168904a92ca4c54d2d25a6e64 (Safe 1.4.1, threshold 4 of 7 owners; the sender 0x72eb78f5… is one owner). Each entry carries 260 bytes of signatures, four ECDSA signatures with v 27 or 28, so 32 recoveries in all; each inner call is an ERC-20 approve with safeTxGas, baseGas and gasPrice 0. Replays in the dossier: today passes as the receipt; under EIP-8151 as sent it fails (474,887 gas used); under EIP-8151 with 300,000 more gas it passes using 487,320. So this transaction uses 15,100 more gas, 10,185 above its limit. The recoveries happen in the Safe, not here; the card sits on this row because the transaction's `to` is this address and its sender set the limit.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a fixed gas amount in this code: line 51 forwards gas(); the more-gas replay passes, so the limit is the sender's.
- Ruled out: the transaction not reaching this address: its `to` is this address (tx check) and the selector is multiSend(bytes) 0x8d80ff0a.
- Ruled out: another step failing for a signer reason: all eight entries call the same Safe; the failing run changes only the precompile (no code set at any signer), and more gas alone makes it pass.
- Ruled out: this address being unused implementation code: it is not a proxy target here; the transaction calls it directly, not by delegatecall from a Safe.
- Ruled out: the card belonging to the Safe instead: the recoveries are in the Safe 0x74eb970c…, which this contract calls. The instruction puts a sender-gas-limits card on the contract the failing transaction calls, which is this one; the reviewer may want to link or move it.
- Ruled out: a project name: the verified source names two authors (Stefan George, Richard Meissner) but no project, so `project` is left empty.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
