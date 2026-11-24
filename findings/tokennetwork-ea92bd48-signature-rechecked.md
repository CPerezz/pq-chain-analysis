---
id: tokennetwork-ea92bd48-signature-rechecked
format: 2
title: Channel payments are lost if the paying partner's account takes real code
status: confirmed
severity: CRITICAL
justification: A partner can void payments it already made by moving to real code, and nobody can change the contract.
category: voided-by-migration
pattern: PQ-15
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4'
  name: TokenNetwork
  code: verified
  code_url: https://etherscan.io/address/0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4#code
  copies: 5
  family: 4c461c57446e3e0f9cec219f328fab55
  upgradeable: 'no'
value:
  usd: 799
  whose: users
  basis: held
activity: {}
impact: funds-loss
action: Deprecate this network to stop new channels, and ask participants to settle open channels before partners
  move to real code.
evidence_level: source
checks:
- id: raiden
  source: '0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4'
  file: data/source/raiden/TokenNetwork.sol
  lines:
  - 8
  - 10
  has: Stores and manages all the Raiden Network channels
  says: the verified source names itself a Raiden Network token network
  for:
  - what
- id: deposits
  source: '0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4'
  file: data/source/raiden/TokenNetwork.sol
  lines:
  - 359
  - 373
  has: participant_state.deposit = total_deposit;
  says: deposited tokens are credited to the channel participant
  for:
  - what
  - whose
- id: close-recover
  source: '0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4'
  file: data/source/raiden/TokenNetwork.sol
  lines:
  - 534
  - 543
  has: require(non_closing_participant == recovered_non_closing_participant_address);
  says: closeChannel stores a balance proof with nonce above zero only if its signature recovers to the partner
  for:
  - evidence-1
  - justification
  - what
- id: update-recover
  source: '0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4'
  file: data/source/raiden/TokenNetwork.sol
  lines:
  - 635
  - 642
  has: require(closing_participant == recovered_closing_participant);
  says: updateNonClosingBalanceProof requires the closer's balance-proof signature to recover to the closer
  for:
  - evidence-2
  - justification
- id: update-window
  source: '0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4'
  file: data/source/raiden/TokenNetwork.sol
  line: 620
  has: require(channel.settle_block_number >= block.number);
  says: the update is possible only until the settle block
  for:
  - evidence-2
- id: ecverify-nonzero
  source: '0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4'
  file: data/source/lib/ECVerify.sol
  lines:
  - 34
  - 37
  has: require(signature_address != address(0x0));
  says: recovery uses ecrecover and reverts when it returns no address
  for:
  - evidence-1
  - what
- id: settle-zero
  source: '0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4'
  file: data/source/raiden/TokenNetwork.sol
  lines:
  - 1468
  - 1474
  has: if (participant.balance_hash == 0 &&
  says: with no stored proof, settle accepts only a zero transferred amount for that side
  for:
  - what
- id: no-proxy
  storage: '0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty
  for:
  - evidence-3
  - justification
- id: no-upgrade
  selector: '0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - evidence-3
  - justification
- id: open-channel
  call: '0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4'
  fn: channels(uint256)(uint256,uint8)
  args:
  - 168
  is:
  - 500
  - 1
  says: channel 168 is in state Opened
  for:
  - action
  - evidence-3
  - what
- id: dai-balance
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: balanceOf(address)(uint256)
  args:
  - '0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4'
  is: '798950400000000000000'
  says: the contract holds 798.95 DAI
  for:
  - what
- id: switch-off
  call: '0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4'
  fn: safety_deprecation_switch()(bool)
  is: false
  says: the network is not deprecated
  for:
  - action
- id: executor
  call: '0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4'
  fn: deprecation_executor()(address)
  is: '0xbBF11c2f66E1887681C902095CEfB1018C854c0f'
  says: the deprecation executor is set
  for:
  - action
- id: deprecate
  source: '0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4'
  file: data/source/raiden/TokenNetwork.sol
  lines:
  - 255
  - 258
  has: function deprecate() public isSafe onlyDeprecationExecutor {
  says: the deprecation executor can switch off new channels and deposits
  for:
  - action
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: CRITICAL
reviews:
- who: r-ea92bd48, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: 'kept: Second refuter (D-028) agrees on every part: closeChannel and updateNonClosingBalanceProof recover
    a balance-proof signature taken as payment earlier; no ERC-1271, no proxy or upgrade; the only privileged key
    flips a deprecation switch that does not gate close or settle; channels 1, 142, 159 and 168 open and 58 closed
    but unsettled at the block. Both refuters agree; Claude read the sheet. CRITICAL, kept; waits for Anon''s sign-off
    before filing.'
related: []
---

## What happens

This Raiden token network holds DAI deposited into payment channels; many are still open. At close it checks again the partner's signature on the balance proof a participant took as payment. If that partner's account takes real code first, the proof fails and the payments return to the partner.

## Evidence

- [closeChannel](https://etherscan.io/address/0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4#code) accepts a balance proof only if its signature recovers to the partner.
- [updateNonClosingBalanceProof](https://etherscan.io/address/0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4#code) needs the closer's signature too, so a closer that migrates in the settle window blocks it.
- The [contract](https://etherscan.io/address/0xea92bd481e54bbb9bb6c927970a54e82ee26c6b4#code) has no proxy slot or upgrade function, and its channels are still open.

## Reviewer notes

### Mechanism

Participants deposit DAI into a channel (setTotalDeposit) and pay each other off-chain with signed balance proofs. closeChannel requires the closer's counter-signature (lines 519-528) and, when the proof's nonce is above zero, recovers the partner's balance-proof signature and requires it to equal the partner (535-543). updateNonClosingBalanceProof, open until the settle block (620), recovers the closer's balance-proof signature and requires it to equal the closer (635-642). Recovery goes through ECVerify.ecverify, which calls ecrecover and requires a non-zero result (ECVerify 34-37). If no proof is stored for a side, settleChannel only accepts a zero transferred amount for it (verifyBalanceHashData 1468-1474), so the payments it covered are refunded to the payer. Under EIP-8151, once the payer's account has real code the recovery returns nothing and the proof can never be submitted: a payee closing must use nonce 0, and a payer that closed with a stale proof and then migrates blocks the payee's update. An EIP-7702 delegation still recovers. State at block 26,438,999: channel_counter 169, many channels in state Opened (e.g. 168), safety_deprecation_switch false, 798.95 DAI held. Copies: 0x5b60 (WETH, switch false, 23 channels), 0x34ff (DAI, switch true, 208), 0x4261 (WETH, switch true, 0 channels), 0xe556 (test token, switch true, 6). The deprecation switch blocks only openChannel and setTotalDeposit; close, update and settle stay open on all copies.

### Checks

- Header facts: this address alone, at block 26,438,999; 5 addresses run this code.
- Ruled out: an ERC-1271 or code-size branch: ECVerify (lines 5-40) only calls ecrecover.
- Ruled out: a path without the partner's signature: setTotalWithdraw recovers both participants' signatures (lines 408-421), itself needing the withdrawing participant's own signature; that migration hazard is separate and not folded in here.
- Ruled out: unused implementation: the address is not a proxy target; it holds its own channels (channel 168 Opened) and 798.95 DAI.
- Ruled out: path closed: safety_deprecation_switch is false, and closeChannel and updateNonClosingBalanceProof do not carry the isSafe modifier anyway.
- Ruled out: an upgrade or admin fix: no EIP-1967 slot, no upgradeTo; the deprecation executor (an EOA, nonce 44) can only set the deprecation switch (lines 255-258).
- Ruled out: a fixed-gas issue: Solidity ecrecover forwards all gas; no replay exists for this family, so evidence stays source.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
