---
id: gnosissafel2-66264e76-sender-gas-limits
format: 2
title: Safe transactions sent with a tight gas limit run out of gas under EIP-8151
status: confirmed
severity: LOW
justification: A real transaction of this Safe runs out of gas under EIP-8151; a higher gas limit from its sender
  fixes it.
category: breaks-at-activation
pattern: PQ-18
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x66264e76316b2122738998e325533a9a7d1b1e82'
  name: GnosisSafeL2
  code: verified
  code_url: https://etherscan.io/address/0x3e5c63644e683549055b9be8653de26e0b4cd36e#code
  proxy_of: '0x3e5c63644e683549055b9be8653de26e0b4cd36e'
  copies: 8589
  family: 922d81504c51927118b2dda3d8ce64ee
value:
  usd: 14
  whose: users
  basis: held
activity: {}
impact: liveness
action: 'Re-estimate gas limits under EIP-8151: this approve needed 3,300 more gas, 2,347 above the 94,345 limit
  it was sent with.'
evidence_level: executed
checks:
- id: threshold
  call: '0x66264e76316b2122738998e325533a9a7d1b1e82'
  fn: getThreshold()(uint256)
  args: []
  is: '2'
  says: two owner signatures are required
  for:
  - what
  - whose
- id: owners
  call: '0x66264e76316b2122738998e325533a9a7d1b1e82'
  fn: getOwners()(address[])
  args: []
  is:
  - '0xFA08377db6866b0a704DA0D15DF79eBb86Afa369'
  - '0xa571022e535A7046A2BefBA418237B5E659AC7bd'
  - '0xc13c969eb1FcDa98A237d3590b606db8960C9F51'
  says: the Safe has three owners
  for:
  - what
  - whose
- id: sender-owner
  call: '0x66264e76316b2122738998e325533a9a7d1b1e82'
  fn: isOwner(address)(bool)
  args:
  - '0xa571022e535a7046a2befba418237b5e659ac7bd'
  is: 'true'
  says: the transaction's sender is an owner of this Safe
  for:
  - what
- id: sender-eoa
  code: '0xa571022e535a7046a2befba418237b5e659ac7bd'
  is: empty
  says: the sender has no code
  for:
  - notes
- id: no-guard
  storage: '0x66264e76316b2122738998e325533a9a7d1b1e82'
  slot: '0x4a204f620c8c5ccdca3fd54d003badd85ba500436a431f0cbda4f558c93c34c8'
  is: 0
  says: no transaction guard is set
  for:
  - notes
- id: ecdsa
  source: '0x3e5c63644e683549055b9be8653de26e0b4cd36e'
  file: contracts/GnosisSafe.sol
  line: 299
  has: currentOwner = ecrecover(dataHash, v, r, s);
  says: a v=27/28 owner signature is recovered with ecrecover
  for:
  - evidence-2
  - what
- id: owner-match
  source: '0x3e5c63644e683549055b9be8653de26e0b4cd36e'
  file: contracts/GnosisSafe.sol
  line: 301
  has: owners[currentOwner] != address(0)
  says: the recovered address must be an owner
  for:
  - evidence-2
  - what
- id: exec-checks
  source: '0x3e5c63644e683549055b9be8653de26e0b4cd36e'
  file: contracts/GnosisSafe.sol
  line: 145
  has: checkSignatures(txHash, txHashData, signatures);
  says: execTransaction checks the owner signatures before executing
  for:
  - evidence-2
- id: tx
  tx: '0xbef15df1b3cc83bbb029e48432a7887ab6c1a953afb3385dab1dd55d397a1a06'
  to: '0x66264e76316b2122738998e325533a9a7d1b1e82'
  ok: true
  says: the real transaction calls this Safe and succeeded
  for:
  - evidence-1
  - justification
  - what
- id: replay-today
  replay: '0xbef15df1b3cc83bbb029e48432a7887ab6c1a953afb3385dab1dd55d397a1a06'
  run: today
  ok: true
  says: the replay reproduces the real receipt
  for:
  - action
  - evidence-1
- id: replay-8151
  replay: '0xbef15df1b3cc83bbb029e48432a7887ab6c1a953afb3385dab1dd55d397a1a06'
  run: eip8151
  ok: false
  says: under EIP-8151 as sent, the transaction fails
  for:
  - action
  - evidence-1
  - justification
  - what
- id: replay-more-gas
  replay: '0xbef15df1b3cc83bbb029e48432a7887ab6c1a953afb3385dab1dd55d397a1a06'
  run: eip8151_more_gas
  ok: true
  says: under EIP-8151 with 300,000 more gas, it succeeds
  for:
  - action
  - evidence-1
  - justification
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-66264e76, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: 'kept: LOW (PQ-18), a lead found in review: a 2-of-3 GnosisSafeL2 whose real execTransaction (gas limit
    94,345; 93,392 used) fails under EIP-8151 and passes with more gas (3,300 more used, 2,347 above its limit);
    the Safe fixes no gas amount for the recovery, so the sender re-estimates. Two refuters agree; Claude read the
    sheet.'
related: []
---

## What happens

This Safe wallet acts when two of its three owners sign, and checks each owner signature with ecrecover. Under EIP-8151 each check costs more: a real transaction one owner sent with a gas limit just above today's need runs out of gas. With a higher limit it goes through.

## Evidence

- [This approve](https://etherscan.io/tx/0xbef15df1b3cc83bbb029e48432a7887ab6c1a953afb3385dab1dd55d397a1a06) succeeded; replayed under EIP-8151 it runs out of gas, and with more gas it succeeds.
- [checkNSignatures](https://etherscan.io/address/0x3e5c63644e683549055b9be8653de26e0b4cd36e#code) recovers each owner signature with ecrecover and requires the signer to be an owner.

## Reviewer notes

### Mechanism

execTransaction (GnosisSafe.sol 1.3.0, lines 111-194; the L2 variant emits an event and calls it) builds the transaction hash, bumps the nonce and calls checkSignatures (line 145), which loops over threshold signatures (lines 240-304). A signature with v 27/28 goes to ecrecover(dataHash, v, r, s) (line 299), a Solidity call that forwards the available gas; the recovered address must be an owner and strictly increasing (line 301). Then the inner call runs with all remaining gas (line 176). Transaction 0xbef15df1 (block 26,388,755) is execTransaction from owner 0xa571...c7bd to wstETH approve(0x94e7...c485, ...), with safeTxGas 0, gasPrice 0 and two v=27/28 signatures. Its receipt shows 93,392 gas used against a 94,345 limit (953 spare). Under EIP-8151 the replay uses 93,391 and fails at the limit; with 300,000 more gas it succeeds using 96,692, i.e. 3,300 more than today, 2,347 above the limit. Nothing in the contract fixes a gas amount; the sender's limit is the only cause.

### Checks

- Header facts: this address alone, at block 26,438,999; 8,589 addresses run this code.
- Ruled out: a fixed gas amount for the recovery: ecrecover is a Solidity call that forwards available gas (line 299), and the same transaction succeeds with 300,000 more gas.
- Ruled out: another signed step failing in the same transaction: the inner call is a plain wstETH approve from the Safe, which checks no signature; the only signature checks are this Safe's own.
- Ruled out: a guard adding checks: the guard slot 0x4a20...34c8 is zero at the block.
- Ruled out: the sender: 0xa571022e535a7046a2befba418237b5e659ac7bd has no code, is an owner of this Safe, and has a nonce of 85 at the block.
- Ruled out: a migration notice beside it: an owner whose account takes real code can still sign through ERC-1271 (v = 0, line 285) or an approved hash (v = 1, line 291), so no owner is locked out.
- Ruled out: the other 8,588 Safes running this singleton: not judged here; each fails only if its own senders set a limit this tight.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
