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

Find every deployed contract whose behaviour EIP-8151 changes, as specified at the pinned commit:

- what breaks for everyone on activation day (`regression`);
- what is lost when a signer's account takes real code (`migration-hazard`);
- what it means to protect and does not reach (`protection-gap`).

## Setup

- **The change.** `ecrecover` reads the recovered address's code. It returns the address only when the code is empty
  or a 7702 delegation indicator, and empty output otherwise. A successful recovery costs 200 gas more (warm) or 3,100
  more (cold).
- **State** pinned at block 26,438,999. A reth archive node serves traces, state and replays.
- **Engine.** The fork's reference implementation with only the precompile changed. It reproduces real receipts
  exactly.

## Procedure

1. **Inventory.** Every contract creation, and the code each address holds at the pinned block.
2. **Static scan.** Every unique runtime code is scanned for calls to `0x01`: the gas given, how the result is used,
   and what the recovered address is compared with. The scan is checked against verified source and against traces.
3. **Families.** Identical code is grouped. A family is read once and stands for all its copies. The common ways of
   calling the precompile get one template each.
4. **Traces.** The last 100,000 blocks, for every recovery's gas and context.
5. **Replays.** Real transactions of each active family run four ways: today; under EIP-8151; under EIP-8151 with code
   at the recovered signer; with a 7702 delegation there. Failures are re-run with more gas to separate the price from
   the code.
6. **Reading.** Every recovery site with verified source is read and classed by what a signer with code loses.
   Families without source are judged from bytecode, function names, decompiled code and their own traces. Measured
   rules place the rest.
7. **Rating.** By shape and by who can fix it (`findings/README.md`). Value and activity never lower a rating.
   Entries go to `triage/`.

## Reproduce

Not yet possible: the code will be linked at a commit when it is published.

## Results

Filed in `triage/` and `findings/` with this study as a source; listed in `generated/STUDIES.md` and
`generated/TRIAGE.md`.

## Limits

- Code at a signer is simulated: no account can take real code before the fork.
- Only the precompile's price is measured; other gas changes of the same fork are not.
- Run-time data covers only the traced window. Paths that never ran rely on the scan and on reading.
- Code without source is judged from bytecode. Template copies are compared with their template, not read one by
  one; low-shaped copies are counted, not listed, and copies no rule places are not filed.
- Value is ETH plus 49 tokens at the pinned block.
- Entries are AI-assisted and unreviewed until a reviewer confirms them.
