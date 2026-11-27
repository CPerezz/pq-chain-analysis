---
id: adexcore-333420fc-signature-rechecked
format: 2
title: AdEx earners lose unpaid balances if channel validators move to real code
status: confirmed
severity: CRITICAL
justification: A validator moving to real code voids its signed state; the creator then reclaims the balance at
  expiry.
category: voided-by-migration
pattern: PQ-15
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x333420fc6a897356e69b62417cd17ff012177d2b'
  name: AdExCore
  code: verified
  code_url: https://etherscan.io/address/0x333420fc6a897356e69b62417cd17ff012177d2b#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 16036
  whose: users
  basis: held
activity:
  txs_90d: 1
impact: funds-loss
action: Open new channels only on a version that asks validators with real code through ERC-1271.
evidence_level: source
checks:
- id: recover
  source: '0x333420fc6a897356e69b62417cd17ff012177d2b'
  file: AdExCore.sol
  line: 146
  has: return ecrecover(hash, v, signature[1], signature[2]);
  says: validator signatures are recovered with ecrecover only
  for:
  - action
  - evidence-1
  - justification
  - what
- id: supermajority
  source: '0x333420fc6a897356e69b62417cd17ff012177d2b'
  file: AdExCore.sol
  lines:
  - 242
  - 246
  has: return signs*3 >= channel.validators.length*2;
  says: a state root needs ECDSA signatures from two thirds of the channel's validators
  for:
  - evidence-1
  - justification
  - what
- id: withdraw
  source: '0x333420fc6a897356e69b62417cd17ff012177d2b'
  file: AdExCore.sol
  line: 315
  has: require(channel.isSignedBySupermajority(hashToSign, signatures), "NOT_SIGNED_BY_VALIDATORS");
  says: an earner is paid only on a state root the validators signed
  for:
  - evidence-1
  - justification
  - what
- id: deadline
  source: '0x333420fc6a897356e69b62417cd17ff012177d2b'
  file: AdExCore.sol
  line: 312
  has: require(now <= channel.validUntil, "EXPIRED");
  says: earners can withdraw only until the channel ends
  for:
  - what
- id: expired
  source: '0x333420fc6a897356e69b62417cd17ff012177d2b'
  file: AdExCore.sol
  lines:
  - 294
  - 302
  has: SafeERC20.transfer(channel.tokenAddr, msg.sender, toWithdraw);
  says: after the end the creator alone takes back all that was not withdrawn
  for:
  - evidence-2
  - justification
  - what
  - whose
- id: open
  source: '0x333420fc6a897356e69b62417cd17ff012177d2b'
  file: AdExCore.sol
  line: 279
  has: require(msg.sender == channel.creator, "INVALID_CREATOR");
  says: any account can open a channel as its creator, depositing its own tokens
  for:
  - action
  - whose
- id: lasttx
  tx: '0x4431ebd313ad35a2fe4d05d589d77ef0889246927790a6982566f1921cddc1f8'
  ok: true
  says: a creator's expired-channel withdrawal of 10 DAI succeeded at block 26,225,357
  for:
  - evidence-3
- id: dai
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: balanceOf(address)(uint256)
  args:
  - '0x333420fc6a897356e69b62417cd17ff012177d2b'
  is: '16043635039390768824665'
  says: the contract holds about 16,044 DAI of channel deposits
  for:
  - evidence-3
- id: opens-all
  logs: '0x333420fc6a897356e69b62417cd17ff012177d2b'
  topic: '0x13c5d35090070a7e2a5e8eaab30efb0db4dd2a622fc0e1ed61960bbff1580ef3'
  from: 7438381
  count: 1548
  says: 1,548 channels were opened from the contract's creation to the block
  for:
  - what
- id: opens-to-last
  logs: '0x333420fc6a897356e69b62417cd17ff012177d2b'
  topic: '0x13c5d35090070a7e2a5e8eaab30efb0db4dd2a622fc0e1ed61960bbff1580ef3'
  from: 7438381
  to: 18013362
  count: 1548
  says: all 1,548 were opened by block 18,013,362 (2023-08-28)
  for:
  - what
- id: max-validity
  source: '0x333420fc6a897356e69b62417cd17ff012177d2b'
  file: AdExCore.sol
  lines:
  - 221
  - 223
  has: if (channel.validUntil > currentTime + MAX_VALIDITY) {
  says: a channel cannot be opened to last more than MAX_VALIDITY, 365 days (line 161)
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
- who: reader-1, the reader who settled the row (also its author)
  date: 2026-11-27
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: 'kept: AdExCore pays an earner only on a balance root that two thirds of a channel''s validators signed
    with ecrecover (no ERC-1271, no owner, no upgrade); after validUntil the creator alone takes back what was not
    withdrawn. A validator that moves to real code voids a root earners served against. PQ-15, CRITICAL: no update
    path and others lose; the rating does not depend on value. Fix: open channels only on a version that accepts
    ERC-1271. Refuter was unsure whether any channel is open (it could not read logs). Reader read the LogChannelOpen
    logs: 1,548 opens, the last in block 18,013,362 (2023-08-28), and channelOpen caps validity at 365 days, so
    no channel is open at the block. The card now says so (what-2, checks opens-all, opens-to-last, max-validity),
    what-1 was shortened, the action no longer asks earners to withdraw open balances (there are none) and asks
    for a version with ERC-1271, and the question is answered. The contract stays a finding: anyone can open a channel.'
related: []
---

## What happens

AdEx channels pay earners on a balance root two thirds of the validators signed with ECDSA; a validator that moves to real code stops counting, and the creator takes back what earners did not withdraw. No channel has opened since August 2023 and one lasts a year at most: none is open at the block.

## Evidence

- [channelWithdraw](https://etherscan.io/address/0x333420fc6a897356e69b62417cd17ff012177d2b#code) requires two thirds of the validators' ECDSA signatures before it pays an earner.
- [channelWithdrawExpired](https://etherscan.io/address/0x333420fc6a897356e69b62417cd17ff012177d2b#code) returns all that was not withdrawn to the creator once the channel ends.
- [A creator withdrew an expired channel](https://etherscan.io/tx/0x4431ebd313ad35a2fe4d05d589d77ef0889246927790a6982566f1921cddc1f8) in October 2026; the contract holds about 16,000 DAI.

## Reviewer notes

### Mechanism

channelWithdraw (lines 307-331) hashes the channel id with a state root, and isSignedBySupermajority (lines 228-247) counts signatures whose ecrecover result (line 146) equals validators[i] (line 155); signs*3 must reach validators.length*2. The earner then proves its leaf in the root and is paid. It works only while now <= validUntil (line 312). After that, channelWithdrawExpired (lines 289-305) lets the creator alone take tokenAmount minus what was withdrawn. There is no ERC-1271 path, no owner and no upgrade path. Under EIP-8151 a validator whose account has real code recovers to nothing, so a state root that earners relied on (they served ads against it) stops paying when too few validators still count, and the creator recovers the earners' share at expiry. A creator who is also a validator can do this on purpose. The latest call (block 26,225,357) was a channelWithdrawExpired of 10 DAI by a creator; recoveries in the public table end at block 20,111,605.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271 path for validators with code: recoverAddr and isValidSignature (lines 129-156) use ecrecover only.
- Ruled out: taken-back: validators cannot revoke a signed state root, and the creator's refund opens only after validUntil, when earners can no longer withdraw (lines 294, 312).
- Ruled out: path-closed: channelOpen (lines 274-287) is open to anyone as creator, so new channels can open at any time.
- Ruled out: The old note said the first validator must always sign; the code counts any two thirds (lines 240-246).
- Ruled out: Open channels at the block: 1,548 LogChannelOpen events, the last in block 18,013,362 (2023-08-28); channelOpen refuses a validUntil more than 365 days ahead (lines 221-223), so every channel had ended before the block, and the DAI held is ended channels' money their creators take back alone (lines 294-302).

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-27: reviewed again and rewritten from checks that were re-run.
