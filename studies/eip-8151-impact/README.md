---
id: eip-8151-impact
title: "EIP-8151 as written: what breaks, what a migrating account loses, and where its protection does not reach"
authors: [CPerezz]
status: planned
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

Not started.

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

Not started.

## Limits

Not started.
