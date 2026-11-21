---
id: limitordersettler-d06dfc33-entry-by-own-signature-only
format: 2
title: Users whose accounts take real code can no longer get limit orders filled here
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a user moves its own account to real code; that user's orders are then refused.
category: migration-notice
pattern: PQ-21
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd06dfc33388d2c71a50eadd2a312b0dca9e17672'
  name: LimitOrderSettler
  code: verified
  code_url: https://etherscan.io/address/0xd06dfc33388d2c71a50eadd2a312b0dca9e17672#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  whose: users
  basis: held
activity:
  txs_90d: 31
  last: 2026-11-16
impact: liveness
action: Tell users that orders from accounts with real code stop filling; add a deployment that accepts ERC-1271
  signatures if needed.
evidence_level: source
checks:
- id: settle
  source: '0xd06dfc33388d2c71a50eadd2a312b0dca9e17672'
  file: src/LimitOrderSettler.sol
  lines:
  - 107
  - 129
  has: _requireValidOrder(_limitOrder, _quote, _computeSigner(_limitOrder, _userSignature), address(i_depositToken));
  says: settleLimitOrder validates the order against the recovered signer, then mints or redeems through the retailer
    and pays the user
  for:
  - what
- id: pull
  source: '0xd06dfc33388d2c71a50eadd2a312b0dca9e17672'
  file: src/LimitOrderSettler.sol
  lines:
  - 191
  - 199
  has: IERC20(_limitOrder.asset).safeTransferFrom(_limitOrder.user, address(this), _limitOrder.size);
  says: the tokens traded are pulled from the order's user
  for:
  - action
  - what
  - whose
- id: signer
  source: '0xd06dfc33388d2c71a50eadd2a312b0dca9e17672'
  file: src/LimitOrderSettler.sol
  line: 340
  has: return _digest.recover(_signature.v, _signature.r, _signature.s);
  says: the order's signer is recovered with ECDSA from the EIP-712 digest
  for:
  - action
  - evidence-1
  - what
- id: user-is-signer
  source: '0xd06dfc33388d2c71a50eadd2a312b0dca9e17672'
  file: src/utils/SanityChecks.sol
  line: 116
  has: if (_user != _signer) revert UserIsNotSigner(_user, _signer);
  says: the order reverts unless the recovered signer is the order's user
  for:
  - action
  - evidence-1
  - justification
  - what
- id: ecrecover-zero
  source: '0xd06dfc33388d2c71a50eadd2a312b0dca9e17672'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  lines:
  - 190
  - 192
  has: address signer = ecrecover(hash, v, r, s);
  says: ECDSA.recover calls ecrecover and treats a zero result as an invalid signature
  for:
  - action
  - justification
  - what
- id: bundler
  call: '0xd06dfc33388d2c71a50eadd2a312b0dca9e17672'
  fn: i_morphoBundler()(address)
  is: '0x6566194141eefa99af43bb5aa71460ca2dc90245'
  says: the Morpho bundler the settlements go through is this contract's i_morphoBundler
  for:
  - notes
- id: signer-code
  code: '0xce3cd081d8858102bcdf8e50b1fcde3fed857e51'
  is: delegation
  target: '0x6d154b2eccaf6c9d2ae0d07897d4cf522ecb2e93'
  says: the most frequent real signer is a 7702-delegated account at the block
  for:
  - notes
- id: no-1271
  bytecode: '0xd06dfc33388d2c71a50eadd2a312b0dca9e17672'
  has: 1626ba7e
  absent: true
  says: the ERC-1271 selector is not in the runtime code
  for:
  - action
- id: price-gate
  source: '0xd06dfc33388d2c71a50eadd2a312b0dca9e17672'
  file: src/utils/SanityChecks.sol
  lines:
  - 77
  - 90
  has: revert PriceTooHigh(_requestedPrice, _quotePrice);
  says: an order fills only when the quote price meets its limit
  for:
  - what
- id: expiry
  source: '0xd06dfc33388d2c71a50eadd2a312b0dca9e17672'
  file: src/utils/SanityChecks.sol
  line: 133
  has: _requireDeadlineNotExpired(_order.expiration);
  says: an order cannot fill after its expiration
  for:
  - notes
- id: recover-reverts
  source: '0xd06dfc33388d2c71a50eadd2a312b0dca9e17672'
  file: lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  lines:
  - 202
  - 204
  has: _throwError(error, errorArg);
  says: ECDSA.recover reverts when the recovery fails
  for:
  - action
  - justification
  - what
- id: attestation
  source: '0xd06dfc33388d2c71a50eadd2a312b0dca9e17672'
  file: src/LimitOrderSettler.sol
  lines:
  - 161
  - 163
  has: i_retailer.mintWithAttestation(
  says: the quote and its signature are passed to the retailer's mintWithAttestation
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

This contract fills signed GM token limit orders: a relayer brings the order and a signed price quote, and the contract trades the user's tokens. The order's ECDSA signature must recover to the user it names. Once that user's account has real code, its orders are refused; its tokens stay put.

## Evidence

- [settleLimitOrder](https://etherscan.io/address/0xd06dfc33388d2c71a50eadd2a312b0dca9e17672#code) recovers the order's signer with ECDSA and reverts unless it is the order's user.

## Reviewer notes

### Mechanism

settleLimitOrder (LimitOrderSettler.sol 107-129) calls _computeSigner (337-341): it builds the EIP-712 struct hash, consuming the order's nonce for order.user, and recovers with OpenZeppelin ECDSA.recover(digest, v, r, s), which calls ecrecover and reverts when it returns zero (ECDSA.sol 190-192, 202-205). _requireValidOrder (SanityChecks.sol 125-144) then requires order.user == signer (line 137, 115-117). The contract pulls the deposit token or the GM asset from order.user (191-199), pays the relayer fee from order.user, mints or redeems through the immutable retailer 0x43cc...594f, and pushes the proceeds to order.user. No ERC-1271 or code-size branch (selector 1626ba7e absent from the runtime). An order fills only when a relayer brings a quote signed by the GM attestation signer (comment line 86, checked in the retailer) whose price meets the limit (SanityChecks 77-90) before the order's expiration (line 133); the user cannot force a fill. Not a proxy, no owner, no pause: the path is open at the block. Settlements arrive through the Morpho bundler 0x6566...0245 (i_morphoBundler), sent by relayer 0x9d5d...11a1. Recoveries in the trace window: 6 calls, 2 distinct signers, both 7702-delegated accounts at the block.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: erc1271: the only signature check is ECDSA.recover (v, r, s); the source has no isValidSignature or code-size branch.
- Ruled out: breaks-by-itself: with nobody migrating, the replay of 0x68906ca5... under EIP-8151 alone succeeds (676,283 gas vs 673,483 today); OZ ECDSA forwards all gas to the precompile.
- Ruled out: rechecked-later: the signature is checked once, at settlement; nobody has paid or delivered on it before then, a relayer only loses gas.
- Ruled out: direct-path: settleLimitOrder is the contract's only state-changing external function and always requires the signature; the user calling it directly still needs one. Whether the retailer 0x43cc...594f lets a user trade directly at market was not checked; that is another contract and not a limit order.
- Ruled out: unused-implementation / path-closed: not a proxy, no initializer, no pause or owner; real settlements recovered signers up to block 26,429,086.
- Ruled out: value-whose: the contract holds $0 at the block; tokens are pulled from and pushed to order.user within the transaction.
- Ruled out: replay 0x68906ca5... not cited: its first bundled call goes to the signer's own 7702 wallet (batchExecuteRelayed), so code at the signer breaks the bundle before this contract runs; the evidence rests on source.
- Ruled out: key-state / wrong-code / children: the key checked is order.user itself (SanityChecks 116), the source is this address's verified code, and the recovery happens here, not in the retailer.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
