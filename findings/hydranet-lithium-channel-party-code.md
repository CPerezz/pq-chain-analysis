---
id: hydranet-lithium-channel-party-code
title: "Lithium payment channels: once EIP-8151 is active, a channel whose party has real code can no longer be updated or settled, so both balances stay locked; a party that opened a dispute with an old state and then migrated cannot be overridden or penalised"
project: hydranet
status: confirmed
severity: LOW
patterns: [PQ-15]
impact: funds-locked
contracts:
- address: "0xcc4c47cf0175aa8108e78679c2586a0a6abb242a"
  implementation: null
  name: Lithium (Hydranet, verified on Sourcify)
  upgradeable: "no"
  admin: "none: no owner, no proxy, no delegatecall"
  value_usd: 12359
  value_basis: held
  value_as_of: 2026-11-18
  last_active: 2026-11-18
  txs_30d: 226
families: []
fix:
  layer: new-deployment
  who_acts: "Hydranet: a channel contract that also accepts ERC-1271 signatures from a party with code, or that lets a party settle on the last co-signed state it can prove without a fresh check; until then, channel software can close channels before a party migrates"
evidence:
  level: executed
  block: 26438999
  raw: null
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (verified source read, state read and replays on an archive node; not reviewed by a person)"
  ref: "studies/eip-8151-impact, family c3b241e8 (Lithium), 2026-11-19"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

Lithium is a two-party payment channel contract. Every state that moves money on chain, whether submitted together
or by one party in a dispute, must carry ECDSA signatures of both parties, checked when it is submitted. Under
EIP-8151 a party whose address has real code recovers to no address, so after one party migrates no state of its
channels verifies any more: neither side can update, settle or close, and both balances stay in the contract. Two
real channel updates revert when the counterparty is given code. Read in the source and not executed: a party that
opens a dispute with an old state and then migrates cannot be overridden with a newer state or penalised, because
both need its signature again. The contract holds about USD 12,000, which is why this is rated LOW.

## Mechanism

Pattern PQ-15: each party relied on the other's signatures on the latest state; the contract checks them again when
the state is used.

- `verifyAssetChannelStateSignatures` (`LithiumVerification.sol` lines 31 to 63) recovers both signatures with
  OpenZeppelin `ECDSA.recover`, which reverts when no address comes back, and requires `alice` and `bob`.
- `updateChannel` (`LithiumUpdater.sol` line 50) and `unilateralSettleChannel` (`LithiumSettler.sol` line 56, also
  for overriding an open dispute with a higher nonce) call it; their calldata variants do the same. The "last-resort
  recovery from the on-chain state" still needs a co-signed state (comment at lines 104 to 106).
- `penalizeRevokedChannel` recovers the revoker's signature on a revocation and requires it to be `alice` or `bob`
  (`LithiumVerification.sol` lines 157 to 177).
- `confirmUnilateralSettlement` pays out an open dispute after its period without a new signature.
- Under EIP-8151: once either party's address has code other than a 7702 delegation, every co-signed state and every
  revocation it signed fails. A dispute opened before the migration still confirms.

## Evidence

- CHECKED (verified source, Sourcify, `src/libraries/LithiumVerification.sol` lines 57 to 62):

  ```
        if (ECDSA.recover(ethSignedHash, signedAssetState.aliceSignature) != alice) {
            revert InvalidAliceSignature();
        }
        if (ECDSA.recover(ethSignedHash, signedAssetState.bobSignature) != bob) {
            revert InvalidBobSignature();
        }
  ```

- CHECKED (state at block 26,438,999): 5.40 ETH and 2,614.67 USDC held; no owner, no proxy (created at block
  25,667,649).
- CHECKED (logs from creation to the pinned block): 812 events with the topic the two replayed updates emit
  (`ChannelUpdated`), 35 `ChannelClosed`, 24 `ClaimableCredited`, 11 `AssetClaimed`; 226 transactions emitted an
  event in the last 30 days; the last on 2026-11-18.
- CHECKED (executed on the exact engine: the reference implementation of the fork with only the precompile changed;
  nothing was sent). Two real channel updates (`ChannelUpdated`), each sent by one party with the other's signature.
  Both senders' gas limits were too tight for the new price, so the EIP runs add 300,000 gas:

  | Transaction | Party given code | Today's rule | EIP-8151, more gas | EIP-8151, more gas, code at that party |
  |---|---|---|---|---|
  | `0x5c9d2001…1fc52e9b` (block 26,401,193, index 2) | `0x53f1067c4d85000f24d8019b8d676fbf7f321ca3` | success, the same as the receipt | success, the same events | reverts, one recovery returned no address |
  | `0x9278bf51…dc9026ea` (block 26,409,235, index 192) | `0x7d6df35861660d880e0c3ddd132fbd5b9c9d7d1e` | success, the same as the receipt | success, the same events | reverts, one recovery returned no address |

  Without the added gas both transactions already fail under EIP-8151 with nobody migrated (the senders' own limits;
  this study's activation-day table).
- INFERRED (source read, not executed): settlement and the dispute override use the same check, so they fail the
  same way; the stolen-difference case needs a dispute opened before the migration, which a replay of past blocks
  cannot stage.

## Impact and exposure

- Every channel with a party whose address takes real code is frozen: nobody can take either balance out, unless
  a dispute was already open.
- A party can turn this against its counterparty: open a dispute with an older state that pays it more, migrate,
  and wait for the dispute period. The counterparty can neither submit the newer state nor the party's revocation.
- Value: 5.40 ETH and 2,614.67 USDC in the contract, about USD 12,359 at the pinned block.
- Today no party address can have such code; it needs the account migration that EIP-8151 is built for. Channel
  parties are ordinary accounts that sign states off chain.

## Remediation

- The contract cannot change. A new deployment can accept ERC-1271 from a party with code.
- Until then: close channels cooperatively before migrating a channel address, and watchtowers should treat a
  counterparty that takes code during an open dispute as an alarm.
- No protocol change is needed.

## History

- 2026-11-19: reported from study `eip-8151-impact`. Found by reading family c3b241e8; two real channel updates
  replayed on the exact engine with code at the counterparty.
