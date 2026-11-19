---
id: eip-8151-impact
title: "EIP-8151 as written: what breaks, what a migrating account loses, and where its protection does not reach"
authors: [CPerezz]
status: running
started: 2026-11-17
published: null
topic: eip-8151
code: none
spec:
  repo: ethereum/EIPs
  path: EIPS/eip-8151.md
  commit: 8194528a2ee9a4893a398a5871c470ab0ac3b09a
---

## Goal

Find, on mainnet, everything that EIP-8151 changes for deployed contracts and the transactions that use them, under
the text at the commit pinned above:

- what works today and breaks for everyone once it is active (class `regression`);
- what an account loses by taking real code once it is active (class `migration-hazard`);
- which paths it is meant to protect and does not reach (class `protection-gap`);
- defects in the text itself (class `spec-issue`).

The study tests the EIP exactly as specified. "`ecrecover` disabled for every account" would be a different study.

## Setup

**The change.** After recovering an address, the `ecrecover` precompile reads that address's code. It returns the
address only if the code is empty or exactly an EIP-7702 delegation indicator; otherwise it returns empty output, the
same as for a bad signature. A successful recovery costs 200 gas more when the recovered address is warm and 3,100
more when it is cold; a failed recovery still costs 3,000.

**Data and tools.**

- A reth archive node (v2.5.1) for traces, state and re-execution. It cannot trace blocks 25,955,318 to 25,955,320.
- The precompile-usage corpus described in [precompile-callers-census](../precompile-callers-census/): successful
  calls only, up to block 24.7M, without the gas each call was given and without its output.
- The 40 findings whose header says `fix.protocol_change: helps`. They are the places EIP-8151 is supposed to
  protect; whether it does, as written, has not been checked.
- A before/after replay harness, kept in its own repository and not yet published. It re-runs a block's
  transactions on the parent state, with and without a change, and compares.

## Procedure

In progress. Done so far, with everything pinned at block 26,438,999 (2026-11-18):

- Every contract creation on mainnet was listed, and the code each address holds at the pinned block was read from
  the node: 109,448,913 created addresses, 3,039,017 unique runtime codes.
- Every unique code was scanned for calls to the precompile at `0x01`, with constants followed across jumps: 110,481
  codes call it. The scanner was checked against verified source and against two weeks of traces.
- 100,000 blocks ending at the pinned block were traced: 5,107,550 recoveries with the gas given and used.
- A replay engine was built on the reference implementation of the fork, with only the precompile changed. It
  reproduces the real receipt of 640 of 640 sampled transactions under today's rules.
- Reading of the flagged code families has started with the contracts that give `ecrecover` a fixed amount of gas.

The transaction filter below was the first plan. It is kept as written.

Planned way of choosing transactions, so that nothing that obviously cannot change is replayed:

1. Take only transactions that call `ecrecover`. One trace per block lists them with the gas each call was given
   and used.
2. Drop those that cannot change: every call on the way to `ecrecover` has more spare gas than the extra cost, and no
   recovered address has code.
3. Group the rest by contract code and function.
4. Replay a few per group, and a whole group only when its samples disagree.

## Reproduce

Not started.

## Results

First results, 2026-11-19. Not complete.

**Contracts that give `ecrecover` a constant amount of gas** (pattern PQ-14). The list is complete for code alive
at the pinned block, as far as the scanner sees the gas operand. Counts are machine facts; two families were read
by hand and executed.

| Gas forwarded | Under EIP-8151 | Code families | Addresses |
|---|---|---|---|
| 3,000 or 3,072 | every valid signature fails | 262 | 20,072 |
| 5,000 | fails when the recovered address is cold | 4 | 4 |
| 0 | not examined | 5 | 10 |
| 6,100 or more | enough | 17 | 76 |

The 262 families hold 863 ETH and about USD 1,800 in 49 large tokens. In 223 of them the code does not look at
whether the call succeeded and goes on with whatever the output word holds. What follows from that was read by
hand only for Fuel v1.

Findings:

- [fuel-v1-fixed-gas-witness-recovery](../../findings/fuel-v1-fixed-gas-witness-recovery.md): an honest rollup
  block can be rolled back for a reward. Simulated on the node.
- [unidentified-cd097b8d-wallets-fixed-gas-recovery](../../findings/unidentified-cd097b8d-wallets-fixed-gas-recovery.md):
  18,825 wallets stop working. A real transaction replayed: success today, failure under the EIP.
- [bitgo-walletsimple-ecdsa-signers](../../findings/bitgo-walletsimple-ecdsa-signers.md) (an existing finding, this
  study added as a source): a real transaction replayed with code at the co-signer's address reverts; with a 7702
  delegation it succeeds.
- [safe-owner-ecdsa-keys](../../findings/safe-owner-ecdsa-keys.md) (an existing finding, this study added as a
  source): on Safe 1.3.0 a real transaction reverts when the signing owner's address has code, and an owner keeps
  two other ways of signing. A second real transaction, sent with 1,941 gas to spare, reverts under the EIP with
  nobody migrated: the recovery costs 3,100 more.

## Limits

So far:

- The gas given to the precompile is read from bytecode. A gas value that comes from storage, from calldata or
  from arithmetic the scanner cannot fold is not in the list above.
- Value is ETH plus 49 tokens priced on-chain at the pinned block. Other tokens and NFTs are not counted.
- The code that produced these numbers is not published yet, so no finding of this study is at level `reproduced`.
- Findings were written by an AI agent and have not been reviewed by a person.
