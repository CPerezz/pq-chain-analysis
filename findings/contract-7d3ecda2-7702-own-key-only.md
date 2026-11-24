---
id: contract-7d3ecda2-7702-own-key-only
format: 2
title: This account's own key stops counting if it moves to real code
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if the holder moves this account to real code; moving the funds or the delegation first
  avoids it.
category: migration-notice
pattern: PQ-20
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7d3ecda2850c5709b7bfbdbc2a1579dbb8981d5d'
  code: verified
  code_url: https://etherscan.io/address/0x63c0c19a282a1b52b07dd5a65b58948a07dae32b#code
  copies: 341287
  family: 51dfccec0e9ce7b13786b6898dc14964
value:
  usd: 6467158
  whose: users
  basis: held
activity: {}
impact: funds-locked
action: Move the funds out, or delegate to logic that checks another key, before this account takes real code.
evidence_level: source
checks:
- id: deleg
  code: '0x7d3ecda2850c5709b7bfbdbc2a1579dbb8981d5d'
  is: delegation
  target: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  says: the account's code is an EIP-7702 delegation to the stateless delegator logic
  for:
  - action
  - evidence-2
  - justification
  - what
  - whose
- id: own
  source: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  file: src/EIP7702/EIP7702StatelessDeleGator.sol
  line: 55
  has: if (ECDSA.recover(_hash, _signature) == address(this)) return ERC1271Lib.EIP1271_MAGIC_VALUE;
  says: a signature counts only if it recovers to the account's own address
  for:
  - evidence-1
  - justification
  - what
  - whose
- id: erc1271
  source: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  file: src/EIP7702/EIP7702DeleGatorCore.sol
  line: 320
  has: return _isValidSignature(_hash, _signature);
  says: ERC-1271 isValidSignature uses the same own-key check
  for:
  - evidence-1
  - what
- id: userop
  source: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  file: src/EIP7702/EIP7702DeleGatorCore.sol
  line: 542
  has: bytes4 result_ = _isValidSignature(_userOpHash, _userOp.signature);
  says: user operations are validated by the same own-key check
  for:
  - evidence-1
  - what
- id: selfcall
  source: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  file: src/EIP7702/EIP7702DeleGatorCore.sol
  line: 125
  has: if (msg.sender != address(entryPoint) && msg.sender != address(this)) revert NotEntryPointOrSelf();
  says: execute takes calls only from the EntryPoint or the account itself
  for:
  - action
  - justification
  - what
- id: dm
  source: '0xdb9b1e94b5b69df7e401ddbede43491141047db3'
  file: src/DelegationManager.sol
  line: 176
  has: bytes32 result_ = IERC1271(delegation_.delegator).isValidSignature(typedDataHash_, delegation_.signature);
  says: the DelegationManager checks a delegator with code through its own isValidSignature
  for:
  - what
- id: nonce
  nonce: '0x7d3ecda2850c5709b7bfbdbc2a1579dbb8981d5d'
  is: 2298
  says: the account has sent 2,298 transactions
  for:
  - evidence-2
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x7d3ecda2850c5709b7bfbdbc2a1579dbb8981d5d'
  is: '2435377822057255761795'
  says: the account holds 2,435.38 ETH
  for:
  - evidence-2
- id: eip8151
  ref: https://github.com/ethereum/EIPs/blob/8194528a2ee9a4893a398a5871c470ab0ac3b09a/EIPS/eip-8151.md
  says: ecrecover returns nothing for an account with real code, and still recovers one with a 7702 delegation indicator
  for:
  - justification
  - what
- id: eip3607
  ref: https://github.com/ethereum/EIPs/blob/8194528a2ee9a4893a398a5871c470ab0ac3b09a/EIPS/eip-3607.md
  says: a transaction from an account with deployed code is rejected
  for:
  - what
- id: eip7702
  ref: https://github.com/ethereum/EIPs/blob/8194528a2ee9a4893a398a5871c470ab0ac3b09a/EIPS/eip-7702.md
  says: the key holder can change the account's delegation with a new authorization
  for:
  - action
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-7d3ecda2, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: INFORMATIONAL notice (PQ-20): a live account (2,298 transactions, about 2,435 ETH) delegated to MetaMask''s
    EIP7702StatelessDeleGator, which accepts only signatures recovering to the account itself; the delegation keeps
    working under EIP-8151, but if the account takes this logic as real code its key stops counting and EIP-3607
    stops it from sending, locking what it holds. Refuter agrees; Claude read the sheet. Its sender-gas-limits row
    is separate (a question: the cited replay is USDC''s own recovery).'
related: []
---

## What happens

This account delegates to logic that accepts a signature only when it recovers to the account's own address. An EIP-7702 delegation keeps working. With real code its key stops counting and it cannot send transactions, so what it holds is stuck.

## Evidence

- [The account logic](https://etherscan.io/address/0x63c0c19a282a1b52b07dd5a65b58948a07dae32b#code) accepts a signature only if it recovers to the account itself, for ERC-1271 and user operations alike.
- [This account](https://etherscan.io/address/0x7d3ecda2850c5709b7bfbdbc2a1579dbb8981d5d) delegates to that logic, has sent 2,298 transactions and holds 2,435 ETH.

## Reviewer notes

### Mechanism

The account's code is a 7702 delegation to EIP7702StatelessDeleGator. Every signature it accepts goes through _isValidSignature (line 55), which returns the ERC-1271 magic value only when ECDSA.recover equals address(this). isValidSignature (line 320) and validateUserOp via _validateUserOpSignature (line 542) both use it. execute and redeemDelegations take only the EntryPoint (which needs a valid user-operation signature) or the account itself (onlyEntryPointOrSelf, line 125). executeFromExecutor takes only the DelegationManager (line 248), which checks a delegator with code through isValidSignature on that delegator (DelegationManager.sol line 176), so it comes back to the same comparison. Under EIP-8151 a delegated account still recovers. With real code, the recovery returns nothing, the comparison fails, and EIP-3607 stops the account sending transactions, so no path is left that moves its funds.

### Checks

- Header facts: this address alone, at block 26,438,999; 341,287 addresses run this code.
- Ruled out: erc1271: this logic is itself the account's ERC-1271 answer, and it accepts only the account's own ECDSA key; no stored key, no code-size branch (StatelessDeleGator line 55).
- Ruled out: direct-path: the self path (line 125) needs a transaction from the account, which EIP-3607 forbids once it has real code; the DelegationManager's empty-context self execution also needs the account or the EntryPoint as caller.
- Ruled out: unused-implementation / wrong-code: this address is a user account with 2,298 transactions and 2,435 ETH, delegated to the verified logic at 0x63c0c19a…; the card is about this account alone. The other 341,286 accounts that delegate to the same logic are copies, not described here.
- Ruled out: breaks-by-itself: replay 0xe7aafe9f… (to USDC 0xa0b86991…, selector 0xe3ee160e transferWithAuthorization, kind tight) reverts under EIP-8151 alone, with the delegated account 0x40c641e8… as signer. That looks like a gas-limit failure set by the sender, not by this logic; without a trace I cannot tell if this logic's recovery ran in it. If it is a separate sender-gas-limits notice, the reviewer should link it. Not cited here.
- Ruled out: replay 0xacab00d7… (to DelegationManager, redeemDelegations) passes under EIP-8151 and reverts with real code at the account 0x37794d2d…, a copy of this logic. Not cited, because I cannot read the transaction's calls to rule out other steps that check the same signer.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
