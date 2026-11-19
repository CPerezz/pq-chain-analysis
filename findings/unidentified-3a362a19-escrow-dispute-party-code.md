---
id: unidentified-3a362a19-escrow-dispute-party-code
title: "Trade escrows v2 (ETH and ERC-20): once EIP-8151 is active, a buyer or seller whose address has real code can no longer have a dispute resolved; the escrow waits 180 days for the operator instead"
project: unidentified-3a362a19
status: confirmed
severity: LOW
patterns: [PQ-16]
impact: funds-locked
contracts:
- address: "0x3a362a1966ff5aab35298e1565bda2c9fb124e41"
  implementation: null
  name: ETHEscrowV2 (verified on Sourcify)
  upgradeable: "no"
  admin: "owner and arbitrator 0x8e466cdd9508103c12731e9243e2926a829033c9; stuck escrows and fees go to withdrawTo 0x877cf5f02497607e0b4e4e6aaf6c275648cd5ce5"
  value_usd: 46205
  value_basis: held
  value_as_of: 2026-11-18
  last_active: 2026-11-18
  txs_30d: 7510
- address: "0xccb2718d633ed28bdf0639134380e2f5b05162b5"
  implementation: null
  name: ERC20EscrowV2 (verified on Sourcify; the same design for tokens)
  upgradeable: "no"
  admin: "the same owner, arbitrator and withdrawTo"
  value_usd: 151600
  value_basis: held
  value_as_of: 2026-11-18
  last_active: 2026-11-18
  txs_30d: 6038
families: []
fix:
  layer: new-deployment
  who_acts: "the operator (owner and arbitrator 0x8e466cdd…): a new escrow that also accepts the parties' ERC-1271 signatures, or a dispute request sent by the party itself as a call"
evidence:
  level: executed
  block: 26438999
  raw: null
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (verified source read, state read and replays on an archive node; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 83430300 (ETHEscrowV2) and ba1ed685 (ERC20EscrowV2), 2026-11-19"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

Two escrows hold a seller's ETH or tokens while a buyer pays off chain. Seller and buyer settle by their own calls,
but a dispute can be resolved only with an ECDSA signature of the buyer or of the seller, which the arbitrator
submits. Under EIP-8151 that signature stops recovering once the party's address has real code. Two real dispute
resolutions, one in each contract, revert when the signing party is given code. A party that migrates can then no
longer bring its trade to arbitration; unless the other side signs, the escrow waits 180 days until the operator can
send it to its own address. Nothing can be taken through this and the operator can still pay people off chain,
which is why this is rated LOW.

## Mechanism

Pattern PQ-16: the party's own ECDSA signature is the only way to a dispute.

- `release` (the seller) and `buyerCancel` (the buyer) check `msg.sender` only. They are not affected.
- `relay` lets a relayer submit the same two actions with the party's signature. A party with code loses this
  shortcut and keeps the direct calls.
- `resolveDispute` (ETH version lines 285 to 321) is called by the arbitrator with an outcome and a signature over
  `(MSG_DISPUTE, chain id, contract, trade hash, deadline)` that must recover to the buyer or the seller. No other
  function resolves a dispute; there is no ERC-1271 path.
- `claimStuck` lets the owner send an escrow to `withdrawTo` 180 days after it was funded.
- Under EIP-8151 a party whose address has code other than a 7702 delegation recovers to no address, so its dispute
  request fails with `InvalidDisputeSigner`. The arbitrator can still use the other party's signature, which a party
  in the wrong has no reason to give.

## Evidence

- CHECKED (verified source, Sourcify, `contracts/ETHEscrowV2.sol`): the functions named above; the dispute check:

  ```
        address signer = _recoverInner(inner, v, r, s);
        if (signer != buyer && signer != seller) revert InvalidDisputeSigner();
  ```

  `ERC20EscrowV2` has the same functions and checks (its source read by function list and caller checks).
- CHECKED (state at block 26,438,999): both contracts have the same owner and arbitrator
  `0x8e466cdd9508103c12731e9243e2926a829033c9` and the same `withdrawTo`; `stuckDelaySeconds` 15,552,000 (180 days)
  in both; the ETH escrow holds 25.60 ETH (12.93 reserved for open trades, 12.67 fees); the token escrow holds tokens
  worth about 84 ETH (USD 151,600 at the study's prices). No proxy, no upgrade function.
- CHECKED (logs from creation, blocks 25,774,665 and 25,748,268, to the pinned block): 12,713 and 8,380 trades
  created; 10,957 and 7,246 released; 1,279 and 862 cancelled by the buyer; 443 and 226 disputes resolved. In the
  last 30 days 7,510 and 6,038 transactions emitted an event of these contracts (the `txs_30d` above; calls that
  emit none are not counted).
- CHECKED (executed on the exact engine: the reference implementation of the fork with only the precompile changed;
  nothing was sent). The latest dispute resolution of each contract before the pinned block:

  | Transaction | Signing party | Today's rule | EIP-8151 | EIP-8151, code at that party |
  |---|---|---|---|---|
  | `0x34e6fa77…aa1b117` (ETH, block 26,437,892, index 199), seller wins | seller `0xea877a08dff750c6d9f7fff9d458375f281b945a` | success, the same as the receipt | success, 600 gas more | reverts, the recovery returned no address |
  | `0x47b43ace…10482ea0` (USDT, block 26,437,049, index 270), buyer wins | buyer `0xcb0ef6035d9dfbcd443931da516e0cf678b5c57c` | success, the same as the receipt | success, 3,100 gas more | reverts, the recovery returned no address |

- INFERRED (not executed): that the operator would use `claimStuck` after 180 days and pay the party off chain. The
  contract allows it; what the operator does is outside it.

## Impact and exposure

- Who loses: a buyer or seller whose address takes real code while a trade is open and who then needs arbitration.
  A buyer who paid off chain cannot make the arbitrator release the seller's funds to it; a seller whose buyer never
  pays cannot get its funds back early. In both cases the escrow can only wait for a release or cancel by the other
  side, or for the operator after 180 days.
- Disputes are common here: 669 in about two months, about 3 % of all trades.
- Value at the pinned block: 12.93 ETH reserved for open trades in the ETH escrow, about 84 ETH of tokens in the
  other (reserved and fees together).
- Today no party's address can have such code; it needs the account migration that EIP-8151 is built for. A party
  can avoid the issue by not migrating the address it trades with while a trade is open.

## Remediation

- The contracts cannot change. A new deployment can accept `isValidSignature` from a party with code, or let a party
  request a dispute by a call of its own.
- The operator can tell users not to migrate a trading address with open trades.
- No protocol change is needed.

## History

- 2026-11-19: reported from study `eip-8151-impact`. Found by reading families 83430300 and ba1ed685; the latest
  real dispute resolution of each contract replayed on the exact engine with code at the signing party.
