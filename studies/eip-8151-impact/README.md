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

Done, with everything pinned at block 26,438,999 (2026-11-18):

- Every contract creation on mainnet was listed, and the code each address holds at the pinned block was read from
  the node: 109,448,913 created addresses, 3,039,017 unique runtime codes.
- Every unique code was scanned for calls to the precompile at `0x01`, with constants followed across jumps: 110,481
  codes call it. The scanner was checked against verified source and against two weeks of traces.
- 100,000 blocks ending at the pinned block were traced: 5,107,550 recoveries with the gas given and used.
- A replay engine was built on the reference implementation of the fork, with only the precompile changed. It
  reproduces the real receipt of 640 of 640 sampled transactions under today's rules, and of every transaction
  replayed later (2,314 of 2,314).
- Codes were grouped into families (same code up to constructor values and metadata). 80,073 flagged families have
  a live address. The reading list holds 3,561 of them: every family with 1 ETH of value or more, with a recovery in
  the traced window, or run by 100 addresses or more, plus one family for each common way of calling the precompile
  (a template). It holds 99.998 % of the flagged value and every recovery of the window.
- For each listed family with a recovery in the window, real transactions were replayed (2,314 transactions, 1,846
  families): under today's rule, under EIP-8151, under EIP-8151 with one byte of code at the recovered signer, and
  with a 7702 delegation there. A transaction that failed under EIP-8151 was run again with 300,000 and then
  3,000,000 more gas, the sender being given the ether to pay for it.
- Every recovery site of the families with verified source was extracted: 2,288 distinct function texts, 2,242 of
  them read one by one (the other 46 belong to families read whole, or to no listed family). Families without source
  were judged from bytecode facts, function names, decompiled code and traces of their own transactions. Rules
  written from these readings place the rest; they were measured against the readings.
- Effects that looked like findings were executed on the engine against real state, with real transactions where
  they exist and with calls that never happened where they do not (marked as such).

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

Results of 2026-11-19 for the 3,561 families of the reading list. Every family has one verdict for activation day
and one for an account that takes real code, with how it was decided:

| Decided by | Families |
|---|---|
| Its recovery functions read one by one (verified source) | 2,239 |
| The whole family read by hand (source) | 179 |
| The same function texts as a family read by hand | 12 |
| Bytecode, function names, decompiled code and traces (no source) | 533 |
| A rule (no source and no reading); error measured below | 598 |

**On activation day, with nobody migrated.** A recovery that succeeds costs 200 gas more for a warm signer and
3,100 more for a cold one.

| What happens | Families | Value (ETH, tokens included) | How it is known |
|---|---|---|---|
| Only the extra cost | 3,080 | 23,716,469 | 1,407 by replaying real transactions, 1,669 from bytecode (the call gets all gas), 4 from traces |
| A real transaction fails with its sender's gas limit and passes with more gas | 435 | 7,718,422 | replayed |
| A real ERC-4337 operation fails whatever gas the bundler gives (a verification limit signed in the operation) | 2 | 127 | replayed and traced |
| A constant amount of gas reaches the precompile (table below) | 12 | 853 | bytecode, one executed |
| Calls address 1 without a recoverable input; nothing changes | 6 | 0 | traced |
| Never calls the precompile (code in the source bundle belongs to other contracts) | 26 | 5,498 | bytecode |

Of 2,314 replayed real transactions, 569 (438 families) fail under EIP-8151 with nobody migrated. All but three
pass when the sender gives more gas. The replays were chosen to include each family's tightest transaction, so this
is not a failure rate for the network. Gas refunds hide how tight a transaction was: a receipt can show thousands
of gas to spare that the transaction needed while it ran. Quorum checks pay the most: a Polygon StakeManager
checkpoint or a Snowbridge BeefyClient update with about 100 signatures costs 300,900 to 319,300 gas more.

**For an account that takes real code** (an account can keep using `ecrecover` through a 7702 delegation; real
code is what EIP-8151 turns off). A family counts in every class its recovery sites have.

| Class | What it means | Families | Value (ETH, tokens included) |
|---|---|---|---|
| key-replace | the signing key is stored and an owner, admin or the signers can replace it | 1,372 | 11,361,453 |
| route-lost | the signer loses one route (a signature) and keeps another (a direct call, another key) | 1,136 | 15,103,041 |
| route-kept-1271 | an account with code still signs through ERC-1271 | 455 | 5,846,536 |
| set-threshold | several signers; spare signers absorb one that migrates | 375 | 9,184,143 |
| key-fixed | the key cannot change; once it takes code the function stops for good | 250 | 1,438,789 |
| self-only | the account signs for itself (7702 accounts, self-signed calls) | 217 | 1,236,497 |
| key-owner, key-upgrade | replaced only by the owner, or by an upgrade | 103, 87 | 2,928, 81,223 |
| promise, evidence | a signature others rely on is checked again later (the shape of PQ-15) | 21, 9 | 315, 167 |
| right-lost | a right with no other way to exercise it (PQ-16) | 15 | 271 |
| helper, none, no-entry, curve | a view for other contracts, no signature check, no entry point, curve arithmetic | 54, 52, 81, 18 | 10,859, 8,031, 284, 4,709 |

Replays with code at the recovered signer, where the plain EIP passes (1,333 transactions): 1,200 revert, of which
1,083 after a recovery returned no address and 117 before any (the contract sends an account with code to ERC-1271
first, which the test code does not answer); 120 end without error but with other logs (the failure is caught
inside, the guarded action does not happen); 13 do the same with the same logs, and each was explained by reading
(a first recovery that decides nothing, spare signatures, a recovery that decides nothing at all). With a 7702
delegation at the signer, 1,191 pass; 142 revert before any recovery, in contracts that ask an account with code for
ERC-1271 and get no answer from the test delegate.

Rules were measured against the families read by hand: stored key 522 of 538 agree, permit-like 678 of 690, named
signer with ERC-1271 208 of 219, self-only 70 of 70, stored key replaced by the owner 58 of 62, by an upgrade 22 of
28.

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
- [tbtc-dkg-result-signer-code](../../findings/tbtc-dkg-result-signer-code.md) (PQ-15): a tBTC wallet-creation
  result signed by an operator whose address has code is rejected and its submitter punished. Executed on the last
  real result.
- [unidentified-8863f0c4-csd-settlement-buyer-code](../../findings/unidentified-8863f0c4-csd-settlement-buyer-code.md)
  (PQ-15): a buyer that migrates after locking cannot be settled against and is refunded. A real settlement
  replayed.
- [hydranet-lithium-channel-party-code](../../findings/hydranet-lithium-channel-party-code.md) (PQ-15): a payment
  channel with a party that has code can no longer be updated or settled. Two real updates replayed.
- [unidentified-3a362a19-escrow-dispute-party-code](../../findings/unidentified-3a362a19-escrow-dispute-party-code.md)
  (PQ-16): a trade party with code can no longer have a dispute resolved. Two real resolutions replayed.
- [bitgo-walletsimple-ecdsa-signers](../../findings/bitgo-walletsimple-ecdsa-signers.md) (an existing finding, this
  study added as a source): a real transaction replayed with code at the co-signer's address reverts; with a 7702
  delegation it succeeds.
- [safe-owner-ecdsa-keys](../../findings/safe-owner-ecdsa-keys.md) (an existing finding, this study added as a
  source): on Safe 1.3.0 a real transaction reverts when the signing owner's address has code, and an owner keeps
  two other ways of signing. A second real transaction, sent with 1,941 gas to spare, reverts under the EIP with
  nobody migrated: the recovery costs 3,100 more.

Leads that were read but not executed (key-fixed wallets with large balances, dormant channels and escrows, signed
promises) are kept with the study's working notes until they are executed or dropped.

## Limits

- The gas given to the precompile is read from bytecode. A gas value that comes from storage, from calldata or
  from arithmetic the scanner cannot fold is not in the fixed-gas list. Ten families whose call target is not a
  constant were found only in traces and read from them.
- Replays cover the 1,846 listed families with a recovery in the traced two weeks, one to three transactions each.
  The other 1,715 have no replay; their activation-day verdict comes from how their code gives gas to the precompile.
- The run with more gas changes the transaction's gas limit and gives its sender the ether to pay for it. A contract
  that reads its caller's balance could behave differently; none was seen to.
- "Code at the signer" is one byte of code (or, for 7702 accounts, the delegate's code as real code). An account
  that migrates with code implementing ERC-1271 can still pass where a contract offers that path; the class says
  where it does.
- 168 families were still open after the first readings. They were settled by source (30, some found on Blockscout),
  traces of their own transactions (60), decompiled code (heimdall 0.9.2, 43) and function names (35, 23 of those as
  the same design as a family settled by evidence). 27 carry an open part in their row, for example who may write
  the signer slot. The decompiler can miss functions.
- 52,779 families with under 1 ETH, no recovery in the window and under 100 addresses each are covered only by the
  template of their way of calling the precompile; they were not tested one by one. 7,362 such families with no
  template were left out.
- Value is ETH plus 49 tokens priced on-chain at the pinned block. Other tokens and NFTs are not counted.
- The code that produced these numbers is not published yet, so no finding of this study is at level `reproduced`.
- Findings were written by an AI agent and have not been reviewed by a person.
