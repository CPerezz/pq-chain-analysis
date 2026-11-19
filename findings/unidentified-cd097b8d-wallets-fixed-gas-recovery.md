---
id: unidentified-cd097b8d-wallets-fixed-gas-recovery
title: "18,825 two-signature wallets from two factories give ecrecover 3,072 gas: once EIP-8151 is active no transfer and no owner change can succeed, and the code cannot change"
project: unidentified-cd097b8d
status: confirmed
severity: LOW
patterns: [PQ-14]
impact: funds-locked
contracts:
- address: "0x94fde2d6ac81379872dc6c7a1a6b9226662dacd2"
  implementation: null
  name: two-signature wallet (unverified, 1,041 bytes), the one used in the replay
  upgradeable: "no"
  admin: "none: no DELEGATECALL, SELFDESTRUCT or CREATE in the code; owner changes are self-calls, which need the same two signatures"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-17
  txs_30d: null
- address: "0xfd1e02b42694e845fbf28741e5ce9881507d9551"
  implementation: null
  name: two-signature wallet (unverified, same code), the one that holds most
  upgradeable: "no"
  admin: "none: same code"
  value_usd: 2327
  value_basis: held
  value_as_of: 2026-11-18
  last_active: null
  txs_30d: null
families:
- code: "0x94fde2d6ac81379872dc6c7a1a6b9226662dacd2"
  name: "wallets with runtime code hash 0x46550840f29528f1c203e196cc1082e1c1423c7cddb471748db9517c485ca81d (the address given is one instance, not an implementation)"
  instances: 17653
  list: "every address created by factory 0xcd097b8dd0505aed5ed3f6a02416b0fb9e19fc59 that holds this code"
  upgradeable: "no"
  value_usd: 4719
  value_basis: held
  value_as_of: 2026-11-18
- code: "0x016c670f5cacf03515d9f6c2fb6bf34f6a5ca5cf"
  name: "wallets with runtime code hash 0x08b417379dea69621e151474a028a33ed19219a26491e1387695cf7e130d59e1 (one instance given)"
  instances: 1168
  list: "every address created by factory 0x6ccab97ec94f8158fda451c5504db728adad7dc2 that holds this code"
  upgradeable: "no"
  value_usd: null
  value_basis: null
  value_as_of: null
- code: "0x276164d5121df16e039c90f74c4b65d225c65635"
  name: "wallets with runtime code hash 0xaf293bbb5e21635401653fe5bca367b5721479e3c22fe6070f3e1bedca869583 (one instance given)"
  instances: 4
  list: "four addresses"
  upgradeable: "no"
  value_usd: null
  value_basis: null
  value_as_of: null
fix:
  layer: account-migration
  who_acts: "the owner and the co-signer of each wallet: move every asset out before EIP-8151 is active. After that nobody can. The EIP's authors can also avoid it: see Remediation"
evidence:
  level: executed
  block: 26438999
  raw: null
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (bytecode read and one real transaction replayed; not reviewed by a person)"
  ref: "studies/eip-8151-impact, fixed-gas list of 2026-11-19"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

18,825 wallet contracts, made by two factories between March 2019 and October 2021, check two signatures with
`ecrecover` and give each check exactly 3,072 gas. A check costs 3,000 today. Under EIP-8151 it costs 3,200 or 6,100,
so every check fails and the wallet stops with an invalid instruction. The two functions that move assets and the
three that change owners all pass through that check, and the code has no way to be upgraded. From the day the change
is active, whatever a wallet holds stays there. The 17 wallets with a balance hold about USD 4,700 in ETH and 49
large tokens; other tokens were not counted. The project behind the factories is not identified.

## Mechanism

Pattern PQ-14. The wallet has seven functions: `transferErc20` (`0xf063042d`, three signatures), a general call
(`0x9d55b53f`, two signatures), `addOwner`, `removeOwner`, one more setter (`0x7fb372b0`), `isOwner` and a getter.
Both asset functions recover their signers through one routine. The general call builds a hash bound to the
wallet's address, requires the first signer to be a stored owner and the second to hold the stored value 3. The
three setters accept only a call from the wallet itself, which the general call alone can make. The routine forwards a literal 3,072 gas
to address `0x01` and executes `INVALID` when the call fails. With EIP-8151 a successful recovery costs more than
3,072, so the call fails for every valid signature.

## Evidence

- CHECKED (bytecode of `0x94fde2d6…` at block 26,438,999, read instruction by instruction). The recovery routine:

  ```
  187 PUSH1 0x20      output size
  189 PUSH1 0x00      output offset
  191 PUSH1 0x80      input size (128 bytes)
  193 PUSH1 0x00      input offset
  195 PUSH1 0x01      the precompile
  197 PUSH2 0x0c00    gas: 3,072
  200 STATICCALL
  201 ISZERO
  202 ISZERO
  203 PUSH2 0x00d0
  206 JUMPI           continue when the call succeeded
  207 INVALID         stop when it failed
  ```

- CHECKED (same bytecode): the routine is entered from five places: twice in `0x9d55b53f` (pc 579, 621) and three
  times in `transferErc20` (pc 729, 780, 859). After the first recovery of `0x9d55b53f` the code requires a non-zero
  storage value under the recovered address (pc 583 to 595), after the second it requires the value 3 (pc 625 to
  642). Each failure is `INVALID`.
- CHECKED (same bytecode): `addOwner`, `removeOwner` and `0x7fb372b0` each compare `CALLER` with `ADDRESS` and stop
  otherwise (pc 415, 442, 478). The code holds 2 `STATICCALL`, 2 `CALL`, and no `DELEGATECALL`, `SELFDESTRUCT`,
  `CREATE` or `CREATE2`.
- CHECKED (executed). Transaction `0x0323ebe3274b24b64ec6193d93729c9a37fecb1371d921cfd6d7dc98628dbd0f` (block
  26,432,607, position 180, a call of `0x9d55b53f` on `0x94fde2d6…`) replayed on the reference implementation of
  the fork, from the parent block's state, with only the precompile changed:

  | Run | Status | Gas used | The first call to `0x01` |
  |---|---|---|---|
  | Today's rules | success | 64,082, equal to the real receipt | 3,072 given, 3,000 used |
  | EIP-8151 | **failure, invalid instruction** | 200,000, the whole limit | 3,072 given, out of gas |

- CHECKED (inventory at block 26,438,999): 17,653 addresses hold the code with hash `0x46550840…`, 1,168 the code
  `0x08b41737…`, 4 the code `0xaf293bbb…`. All three forward 3,072 gas. Factory `0xcd097b8d…` created 17,652 of
  them and factory `0x6ccab97e…` 1,168, in blocks 7,302,683 to 13,479,797, from deployer accounts `0xb428ffc8…` and
  `0x7f14e5a4…`.
- CHECKED (precompile-usage corpus to block 24,683,719, and traces of blocks 26,339,000 to 26,438,999): 17,152 of
  the wallets have recovered signatures, 87,496 times in all. 149 did so after block 22,000,000 and 19 after block
  24,000,000. In the traced two weeks one wallet did, in 7 transactions.
- CHECKED (balances at block 26,438,999): 17 wallets hold ETH or one of 49 large tokens: 2.34 ETH and USD 505 of
  tokens.
- INFERRED: the names `addOwner`, `removeOwner`, `isOwner` and `transferErc20` come from a public selector
  database. No source is published.
- INFERRED: the two smaller code versions behave the same. Their call sites were found by the same scanner; only
  the largest version was read by hand and executed.

## Impact and exposure

- Every wallet of the three code versions: 18,825 addresses. None can be upgraded.
- Value seen: about USD 4,700 (ETH at USD 1,804.56, tokens at on-chain prices of block 26,438,999). Tokens outside
  the 49 priced ones, and NFTs, were not counted. This is a floor.
- Activity is low and not zero: 149 wallets used a signature since early 2025.
- Rated LOW by the study's rule: the consequence is the worst one for the owners (funds locked in code that cannot
  change, which alone would be HIGH), and the value known to be at stake is under USD 50,000. If uncounted tokens
  change that sum, the rating goes up.

## Remediation

- Each wallet's owner and co-signer move everything out before the change is active. They have until then, and
  nothing is broken today.
- The project behind the factories, once identified, can warn its users. No fix to the contracts is possible.
- A protocol-side way exists and belongs to the EIP's authors: this failure comes from the price of a successful
  recovery rising above the gas that old code forwards. 3,072 and 3,000 are the two amounts found on mainnet
  below 3,200.

## History

- 2026-11-19: reported from study `eip-8151-impact`. Found by a scan of every unique runtime code for the gas
  operand of calls to `0x01`; bytecode read by hand; one real transaction replayed before and after.
