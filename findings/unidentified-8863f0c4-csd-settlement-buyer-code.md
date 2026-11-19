---
id: unidentified-8863f0c4-csd-settlement-buyer-code
title: "CsdUsdcSettlement (USDC for coins of another chain): once EIP-8151 is active, a buyer whose address takes real code after locking cannot be settled against, and gets its USDC back after the seller has paid"
project: unidentified-8863f0c4
status: confirmed
severity: LOW
patterns: [PQ-15]
impact: funds-loss
contracts:
- address: "0x8863f0c477a30bb5a2077c813f42250d7fbefcb9"
  implementation: null
  name: CsdUsdcSettlement (verified on Sourcify)
  upgradeable: "no"
  admin: "none: no owner, no proxy, no delegatecall; USDC address, total lock limit (300 USDC) and the other chain's genesis hash are immutables"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-18
  last_active: 2026-11-16
  txs_30d: 127
families: []
fix:
  layer: new-deployment
  who_acts: "the deployer (unidentified): a new contract that checks the buyer's signature once, when the USDC is locked, and settles on the payment proof alone"
evidence:
  level: executed
  block: 26438999
  raw: null
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (verified source read, state read and replays on an archive node; not reviewed by a person)"
  ref: "studies/eip-8151-impact, family e2498adf (CsdUsdcSettlement), 2026-11-19"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

CsdUsdcSettlement trades USDC on Ethereum for coins of another proof-of-work chain ("CSD"). The buyer signs an
authorisation and its USDC is locked; the seller pays on the other chain; anyone then settles with a proof of that
payment, and the USDC goes to the seller. Settlement checks the buyer's signature again. Under EIP-8151 that check
fails once the buyer's address has real code, so a buyer that migrates its account between lock and settlement
cannot be settled against, and when the lock expires anyone can return the USDC to it. The seller has paid and gets
nothing. A real settlement replayed with code at the buyer reverts. Trades are capped at 30 USDC and nothing was
locked at the pinned block, which is why this is rated LOW.

## Mechanism

Pattern PQ-15: the buyer's signature is relied on by the seller at lock time and checked again at settlement.

- `_lock` (lines 307 to 349): the buyer's signature over the authorisation must recover to `auth.buyer`; the USDC is
  pulled from the buyer and locked until `lockedUntil` (10 minutes plus 5 per required confirmation, 3 to 60).
- `settleCsdUsdc` (lines 471 to 518): needs the lock to be open, the same signature to recover to `auth.buyer` again
  (line 483), and an SPV proof of the seller's payment. Then the USDC goes to the seller.
- `refundExpiredLock` (lines 367 to 386): after `lockedUntil`, anyone can return the USDC to `auth.buyer`. No
  signature is checked.
- `releaseEarly` (the buyer waives the wait) also needs the buyer's signature.
- Under EIP-8151 the precompile returns no address for an account with code other than a 7702 delegation. A buyer
  that migrates its account after locking makes line 483 revert with `BadSignature` for the rest of the lock, and the
  refund then pays it back. The seller cannot settle at all: the check is not about who submits.

## Evidence

- CHECKED (verified source, Sourcify, `CsdUsdcSettlement.sol`): the lines named above. Line 483:

  ```
        if (_recover(authHash, authSig) != auth.buyer) revert BadSignature();
  ```

  `refundExpiredLock` clears the lock and calls `IERC20(auth.usdc).transfer(auth.buyer, amount)`; it has no other
  condition than the lock having expired and not being finalized. `MAX_USDC_PER_TRADE` is 30 USDC.
- CHECKED (state at block 26,438,999): no owner, no proxy; `maxTotalLocked` 300 USDC; `totalLocked` 0; USDC held 0.
- CHECKED (logs from creation at block 26,304,249 to the pinned block): 66 locks, 44 settlements (497.65 USDC in all,
  the largest 29.75), 17 early releases; 127 transactions with an event in the last 30 days; last one on 2026-11-16.
- CHECKED (executed on the exact engine: the reference implementation of the fork with only the precompile changed;
  nothing was sent). A real settlement, block 26,318,326, index 125
  (`0x55d7ee240594f01a2339416dc20362814d42e610ad3681f0b24d995ba38690fb`), buyer
  `0xcfc25c23c39525875908865980d7ef905287a98c` (no code on chain):

  | Run | Result |
  |---|---|
  | Today's rule | success, 331,192 gas, 4 logs: the same as the receipt |
  | EIP-8151 | success, 3,100 gas more |
  | EIP-8151, one byte of code at the buyer | reverts after one recovery that returned no address |

  A real early release (block 26,379,491, index 28) replayed the same way also reverts with code at its buyer.
- INFERRED (source read, not executed): the refund after expiry. It needs the lock to expire, which a replay of past
  blocks cannot do; the function has no check that code at the buyer would change.

## Impact and exposure

- Who loses: the seller of a trade whose buyer migrates its account to real code while the USDC is locked. The seller
  has paid the other chain's coins; the buyer gets its USDC back. Per trade at most 30 USDC; at most 300 USDC locked at
  any time.
- The buyer can do it on purpose: lock, wait for the seller's payment, migrate, refund. The lock lasts 25 minutes to
  about 5 hours.
- At the pinned block nothing is locked. The contract is new (19 days) and active.
- Today no buyer address can have such code; it needs the account migration that EIP-8151 is built for.

## Remediation

- The contract cannot change. A new deployment can check the buyer's signature once, in `_lock`, and settle on the
  payment proof and the stored lock alone.
- Until then sellers carry the risk; a buyer that already has code cannot lock at all, so only a migration during a
  lock matters.
- No protocol change is needed.

## History

- 2026-11-19: reported from study `eip-8151-impact`. Found by reading family e2498adf; a real settlement and a real
  early release replayed on the exact engine with code at the buyer.
