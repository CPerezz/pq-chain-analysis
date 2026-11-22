---
id: biz-235f7d42-7702-own-key-only
format: 2
title: Account's funds lock if it takes its wallet logic as real code
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if this account takes this logic as real code; its holder can keep the EIP-7702 delegation
  instead.
category: migration-notice
pattern: PQ-20
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x235f7d421b12f8df9ca0c61bb4add3586ad45573'
  name: Biz
  project: trust-wallet
  code: verified
  code_url: https://etherscan.io/address/0xd2e28229f6f2c235e57de2ebc727025a1d0530fb#code
  copies: 506663
  family: 5fca14e7c21e90902ece1b0104ea5d89
value:
  usd: 5101031
  whose: users
  basis: held
activity: {}
impact: funds-locked
action: Tell Biz account holders to keep the EIP-7702 delegation, or move to logic with another key, before taking
  real code.
evidence_level: source
checks:
- id: deleg
  code: '0x235f7d421b12f8df9ca0c61bb4add3586ad45573'
  is: delegation
  target: '0xd2e28229f6f2c235e57de2ebc727025a1d0530fb'
  says: the account's code is an EIP-7702 delegation to the verified Biz logic
  for:
  - evidence-3
  - justification
  - name
  - what
  - whose
- id: nonce
  nonce: '0x235f7d421b12f8df9ca0c61bb4add3586ad45573'
  is: 2
  says: 'the account has a nonce of 2: it is an EOA in use'
  for:
  - evidence-3
- id: bal
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x235f7d421b12f8df9ca0c61bb4add3586ad45573'
  is: '2826744568061297748649'
  says: the account holds 2,826.74 ETH
  for:
  - evidence-3
- id: acctid
  call: '0x235f7d421b12f8df9ca0c61bb4add3586ad45573'
  fn: accountId()(string)
  is: TrustWallet.Biz.v1.0.0
  says: the logic the account runs names itself Trust Wallet's Biz
  for:
  - action
  - name
  - what
- id: flag
  storage: '0x235f7d421b12f8df9ca0c61bb4add3586ad45573'
  slot: '0xa77908bfab24e6768503125e99551a4fa5c3c75f3106fee5dea5ac0cebc017a4'
  is: '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: no persistent 4337 flag is set, so no execution runs without a validated signature
  for:
  - what
- id: own
  source: '0xd2e28229f6f2c235e57de2ebc727025a1d0530fb'
  file: src/Biz.sol
  line: 290
  has: isValid = (address(this) == ECDSA.recover(hash, signature));
  says: a signature is valid only when ECDSA recovers the account's own address
  for:
  - action
  - evidence-1
  - justification
  - what
  - whose
- id: uop
  source: '0xd2e28229f6f2c235e57de2ebc727025a1d0530fb'
  file: src/Biz.sol
  line: 169
  has: bool isValid = _validateSignature(_getEncodedMsgHash(BIZ_USEROP_HASH, userOpHash), userOp.signature);
  says: user operations are validated by the own-key check
  for:
  - evidence-1
  - what
- id: erc1271
  source: '0xd2e28229f6f2c235e57de2ebc727025a1d0530fb'
  file: src/Biz.sol
  lines:
  - 194
  - 196
  has: '_validateSignature(_getEncodedMsgHash(BIZ_MSG_HASH, hash), signature) ? ERC1271_SUCCESS : ERC1271_FAILURE;'
  says: ERC-1271 replies come from the own-key check
  for:
  - evidence-1
  - what
- id: sigexec
  source: '0xd2e28229f6f2c235e57de2ebc727025a1d0530fb'
  file: src/Biz.sol
  lines:
  - 257
  - 263
  has: revert InvalidSignature();
  says: executeWithSignature runs a batch only when the own-key check passes
  for:
  - evidence-1
  - what
- id: self
  source: '0xd2e28229f6f2c235e57de2ebc727025a1d0530fb'
  file: src/Biz.sol
  line: 85
  has: if (msg.sender != address(this)) revert OnlySelf();
  says: execute and executeBatch accept only calls from the account itself
  for:
  - evidence-2
  - what
- id: eip
  ref: https://github.com/ethereum/EIPs/blob/8194528a2ee9a4893a398a5871c470ab0ac3b09a/EIPS/eip-8151.md
  says: ecrecover returns nothing for an account with real code; an EIP-7702 delegation still recovers
  for:
  - action
  - justification
  - what
- id: eip3607
  ref: https://github.com/ethereum/EIPs/blob/3e56771ce1ee7ebfcbe1dac119a6b71da89c46b6/EIPS/eip-3607.md
  says: an account with real code cannot send transactions
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This account runs Trust Wallet's Biz logic through an EIP-7702 delegation, which keeps working. Signed batches, user operations and ERC-1271 replies count only if they recover to the account itself. As real code, this logic could not sign, and EIP-3607 blocks it from sending: funds lock.

## Evidence

- The [verified logic](https://etherscan.io/address/0xd2e28229f6f2c235e57de2ebc727025a1d0530fb#code) accepts a signature only when ECDSA recovers the account's own address; no stored key stands beside it.
- Its [execute and executeBatch](https://etherscan.io/address/0xd2e28229f6f2c235e57de2ebc727025a1d0530fb#code) run only for calls from the account itself, a transaction the account sends.
- The [account](https://etherscan.io/address/0x235f7d421b12f8df9ca0c61bb4add3586ad45573) delegates to this logic and holds 2,826.7 ETH.

## Reviewer notes

### Mechanism

The address is an EOA whose code is the EIP-7702 indicator to Biz (0xd2e2...30fb, verified, not upgradeable). Biz is stateless apart from a 4337 flag. Every signature path goes through _validateSignature (Biz.sol 289-291), which is true only when ECDSA.recover of the EIP-712 hash equals address(this): validateUserOp (169, also needs BizGuard.is4337Enabled, true at the block), executeWithSignature (257-263) and isValidSignature (194-196). execute and executeBatch are onlySelf (85, 206, 215), i.e. a transaction the EOA sends to itself. There is no stored owner, no session key and no ERC-1271 fallback. Under EIP-8151 the delegated account still recovers. If the account held Biz as real code, ECDSA.recover would return nothing for its own key, every signature path would fail, and EIP-3607 stops it from sending transactions, so nothing could move its ETH and tokens. The 4337 storage flag at the account is 0, so execute4337Op cannot run without a validated op.

### Checks

- Header facts: this address alone, at block 26,438,999; 506,663 addresses run this code.
- Ruled out: an ERC-1271 or stored-key path: _validateSignature (line 290) compares only with address(this); Biz keeps no owner.
- Ruled out: the BizGuard owner (0x2524...56b9) only toggles 4337 support and keeps per-account nonces; it cannot authorise actions for the account.
- Ruled out: the persistent 4337 flag (slot keccak('Biz(bool Flag4337)')) is 0 at this account, and Biz never writes 6789 there.
- Ruled out: unused-implementation: this address is a live account (nonce 2, 2,826.7 ETH), not the implementation; the other 506,662 accounts delegating to Biz are their own rows and are not described here.
- Ruled out: breaks-by-itself, replay 0x1c02...ed0de (USDC transferWithAuthorization from Biz account 0x8b24...1295): reverts under EIP-8151 alone with gas limit 92,657 vs 91,710 used; USDC asks the delegated account through ERC-1271, so Biz's recovery (+200 gas) runs inside. Looks like a sender-gas-limits issue of that transaction, not this address; not folded in, reviewer may link a separate rated finding.
- Ruled out: breaks-by-itself, replay 0xa047...35a5 (handleOps, one op from Biz account 0x3dfc...43a1 with a paymaster): under EIP-8151 alone the top call succeeds but differs from the receipt (+3,300 gas). Biz recovers only in validation, and a failed validation would revert handleOps, so the difference is in execution or the paymaster, not Biz's check. Not cited.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
