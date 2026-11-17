---
id: unidentified-1c6ad754-signer-key
title: "Unidentified ERC-4337 operator (deployer 0xac6a87c6): a quantum attacker who recovers its ECDSA signer keys can drain the VerifyingPaymaster deposit and sign LiquidityBank releases (both now empty), and with an account owner's key plus the fixed co-signer key can take over the 852 smart accounts on its ownership module (about $6.6k)"
project: unidentified-1c6ad754
status: candidate
severity: LOW
patterns: [PQ-4, PQ-12]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x1c6ad754810b4385ec3c46b0340e2954350c3e00"
  implementation: null
  name: VerifyingPaymaster (unverified, v0.6, with tx.origin allow-list)
  upgradeable: config-only
  admin: "owner EOA 0xbe4c70a00dcc0c0757257740e4e6f3f57d9a7c85 (deposit, withdrawTo, addOrigin/removeOrigin); verifyingSigner EOA 0x7e416860b6bbb0db05563116ce3750798c01e825; read at block 26,431,544"
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-01-03
  txs_30d: 0
- address: "0x3762a79b34dfb6774cfd45dbf5fd9a2780873783"
  implementation: "0xab8a2cfc2e4ca8f44cbd0bce309a361bb4c9aeb5"
  name: LiquidityBank (EIP-712 name; TransparentUpgradeableProxy, implementation unverified; paused)
  upgradeable: "yes"
  admin: ProxyAdmin 0x166fd12e962290250aebf178f60ff0a250e2159c owned by EOA 0xd77dbd0699582ca487f8519d2fecc4c0b41b78f9; logic owner EOA 0x82d04d2b250c3e017fcc2e333ec043b6b9bf7c77; read at block 26,431,733
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-10-09
  txs_30d: 0
- address: "0x82eace5d23ef8fc5e825a05e8eacd908289ee4dc"
  implementation: null
  name: "unverified ERC-1271 co-signer of module 0xba418fa6 (isValidSignature, getVerifyingSigner, setMode, getMode)"
  upgradeable: "no"
  admin: "none: owner() = 0x0 (renounced); verifying signer 0x5e028b8ce6397e8a81f94d80931ee02a8a854cdd is fixed"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-14
  txs_30d: 32
- address: "0xba418fa699622de824b258c61eb150ed7a13967b"
  implementation: null
  name: "Multichain PassKeys Ownership Registry Module 0.2.0 (unverified fork of Biconomy Smart Account v2 EcdsaOwnershipRegistryModule)"
  upgradeable: "no"
  admin: none (no proxy); each account enables or disables the module; co-signer 0x82eace5d23ef8fc5e825a05e8eacd908289ee4dc is an immutable (read at block 26431523)
  value_usd: 6557
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-14
  txs_30d: 25
families: []
fix:
  layer: new-deployment
  who_acts: "the operator behind deployer EOA 0xac6a87c681a5ed4cb58bc4fa7bf81a83b928c83c: paymaster owner EOA 0xbe4c70a00dcc0c0757257740e4e6f3f57d9a7c85 keeps deposits at zero or deploys a post-quantum paymaster; LiquidityBank ProxyAdmin owner EOA 0xd77dbd0699582ca487f8519d2fecc4c0b41b78f9 keeps it paused or upgrades it; a new module and co-signer replace 0xba418fa6/0x82eace5d, and each smart-account owner enables it and disables 0xba418fa6"
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/unidentified-1c6ad754-signer-key/classification.jsonl
  - evidence/unidentified-1c6ad754-signer-key/onchain.json
  - evidence/unidentified-1c6ad754-signer-key/activity.json
  - evidence/unidentified-1c6ad754-signer-key/source-excerpts.md
  - evidence/unidentified-1c6ad754-signer-key/notes.md
  - evidence/unidentified-1c6ad754-signer-key/notes-liquiditybank.md
  - evidence/unidentified-1c6ad754-signer-key/notes-cosigner.md
  - evidence/unidentified-1c6ad754-signer-key/module-0xba418fa6.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_0.jsonl,out_3.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review08 (paymaster bytecode, EntryPoint deposit reads, deployer siblings)
  ref: evidence/unidentified-1c6ad754-signer-key/notes.md
  date: 2026-11-17
  verdict: reported
  rating: LOW
- by: ai-assisted
  who: Review18 (LiquidityBank bytecode strings and selectors, proxy and paymaster reads)
  ref: evidence/unidentified-1c6ad754-signer-key/notes-liquiditybank.md
  date: 2026-11-17
  verdict: reported
  rating: LOW
- by: ai-assisted
  who: Review15 (co-signer bytecode, module immutable, traced user operation)
  ref: evidence/unidentified-1c6ad754-signer-key/notes-cosigner.md
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
- by: ai-assisted
  who: Review22 (module bytecode, NAME/VERSION, trace, account enumeration and balances; moved from biconomy-ecdsa-validator)
  ref: evidence/unidentified-1c6ad754-signer-key/module-0xba418fa6.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [biconomy-ecdsa-validator]
---

## Summary

One unidentified operator (all contracts deployed by EOA `0xac6a87c6…`) runs an ERC-4337 stack on Ethereum, and
each piece trusts one secp256k1 key (PQ-4). Its VerifyingPaymaster pays gas for user operations signed by
`verifyingSigner`. Its upgradeable "LiquidityBank" takes deposits against orders that a verifying signer authorises.
Its smart-account ownership module `0xba418fa6…` (a fork of Biconomy's Smart Account v2 ECDSA module) validates each
user operation with the account owner's ECDSA signature plus a fixed co-signer's (PQ-12). A quantum attacker who
recovers the paymaster or LiquidityBank signer could drain the paymaster's EntryPoint deposit or sign releases of
LiquidityBank deposits. Both are empty (USD 0 on 2026-11-17), and LiquidityBank has been paused since 2026-04-20. With
an account owner's key plus the co-signer key, the attacker controls that account. The 852 accounts on the module hold
about USD 6.6k. Rated LOW (step 5): each fix is one operator redeploying or upgrading, or account owners switching
modules (MEDIUM at step 4), and less than USD 50k is exposed.

## Mechanism

- **VerifyingPaymaster `0x1c6ad754…`** (bytecode; eth-infinitism v0.6 `VerifyingPaymaster` plus a `tx.origin`
  allow-list): `validatePaymasterUserOp` (`0xf465c77e`, called by EntryPoint v0.6 `0x5ff137d4…`) parses
  `paymasterAndData`, hashes it with `getHash` and recovers the signer with OpenZeppelin `ECDSA`; INFERRED: it compares
  the signer with `verifyingSigner`, and `tx.origin` must be an allow-listed bundler ("Invalid tx origin"). On success
  the EntryPoint charges gas to the paymaster's deposit.
- **LiquidityBank `0x3762a79b…`** (bytecode of implementation `0xab8a2cfc…`): order deposits, releases and refunds
  ("Invalid deposit order", "Order already released", "Invalid refund order", "Origin not whitelisted"). There is an
  EIP-712 domain "LiquidityBank", OpenZeppelin `ECDSA` and a stored `getVerifyingSigner()`; `PAYMASTER()` points at
  sibling paymaster `0xf7bb387e…`. INFERRED: orders, releases and refunds are authorised by the verifying signer's
  EIP-712 signature. Which selector does this was not established.
- **Co-signer `0x82eace5d…`** (bytecode): `isValidSignature(bytes32,bytes)` recovers with `ecrecover` and compares
  with `getVerifyingSigner()` = `0x5e028b8c…`; the owner is renounced. A forged co-signature still needs the owner's
  signature.
- **Ownership module `0xba418fa6…`** (bytecode; `NAME()` = "Multichain PassKeys Ownership Registry Module",
  `VERSION()` = "0.2.0"): Biconomy Smart Account v2 module interface (`initForSmartAccount`, `getOwner`,
  `transferOwnership` with `NotEOA(address)`, `validateUserOp` for EntryPoint v0.6, `isValidSignature`,
  `isValidSignatureForAddress`); runtime code differs from Biconomy's `EcdsaOwnershipRegistryModule` `0x0000001c…ea8e`.
  It holds `0x82eace5d…` as an immutable. A traced call (tx `0x5f57a90e…`, 2026-11-14) shows `validateUserOp` calling
  `0x82eace5d….isValidSignature` (`ecrecover` → `0x5e028b8c…`), then `ecrecover`ing the account owner `0xd0b3b7a0…`.
  Owners must be EOAs (`NotEOA`), so the only post-quantum path is a different module.
- No verified source for any of the four implementations
  ([`source-excerpts.md`](../evidence/unidentified-1c6ad754-signer-key/source-excerpts.md); the LiquidityBank proxy's
  verified build only bundles unrelated files).

## Evidence

- CHECKED (paymaster, block 26,431,544, [`notes.md`](../evidence/unidentified-1c6ad754-signer-key/notes.md)):
  `owner()` EOA `0xbe4c70a0…`; `verifyingSigner()` EOA `0x7e416860…`; `entryPoint()` v0.6; EntryPoint deposit 0, not
  staked. Siblings `0xf7bb387e…` (same signer) and `0x8cbd4a19…` (signer `0x67575ef3…`), same owner, have zero
  deposits in EntryPoint v0.6 and v0.7.
- CHECKED (LiquidityBank, block 26,431,733,
  [`notes-liquiditybank.md`](../evidence/unidentified-1c6ad754-signer-key/notes-liquiditybank.md)): EIP-1967 admin
  ProxyAdmin `0x166fd12e…` (owner EOA `0xd77dbd06…`); implementation `0xab8a2cfc…`; `owner()` EOA `0x82d04d2b…`;
  `paused()` true (`setPaused()` 2026-04-20); `getVerifyingSigner()` EOA `0x75814d09…`; `PAYMASTER()` `0xf7bb387e…`;
  ETH 0, tokens USD 0.09. Its last transactions are `withdraw` calls on 2026-10-09.
- CHECKED (co-signer, block ~26,431,608,
  [`notes-cosigner.md`](../evidence/unidentified-1c6ad754-signer-key/notes-cosigner.md)): selectors as above;
  `owner()` = 0x0; `getVerifyingSigner()` = `0x5e028b8c…` (no code, nonce 0); the module's runtime code holds
  `0x82eace5d…` as an immutable; EntryPoint v0.6 tx `0x6535749d…` (2026-03, paymaster `0xf7bb387e…`) shows `ecrecover`
  calls from both the co-signer and the module.
- CHECKED (deployment): the paymaster (2024-12-20) and the co-signer (2024-09-10) were created through CREATE2 factory
  `0x4e59b448…` by EOA `0xac6a87c6…`. LiquidityBank's proxy was deployed by the same EOA (Sourcify record, block
  20,719,196). No ENS, tag or source attribution identifies the operator.
- CHECKED (precompile trace, year to March 2026, `curated_contracts.csv`): `ecrecover` transactions: paymaster
  70,948; LiquidityBank 47,243 (USD 16.6M of transfers in them); co-signer 82,572 calls. Xatu, 2026-10-16 to
  2026-11-16: paymaster 0, LiquidityBank 0, co-signer 32 transactions (last 2026-11-14)
  ([`activity.json`](../evidence/unidentified-1c6ad754-signer-key/activity.json)).
- CHECKED (module, RPC at block 26,431,523; Xatu call frames since block 24,700,000, 5,193 EntryPoint v0.6 bundles;
  [`module-0xba418fa6.json`](../evidence/unidentified-1c6ad754-signer-key/module-0xba418fa6.json)): no proxy; created
  2024-09-10 through the CREATE2 factory by `0xac6a87c6…`, which also deployed `SmartAccountFactory` `0xb3f15a44…`
  (Smart Account v2). Of 856 `handleOps` senders, 852 have `getOwner` ≠ 0; they hold 0.081 ETH and USD 6.4k in
  USDC/USDT/WETH/WBTC, USD 6,557 in total (eight major tokens counted). There were 80,263 pre-quantum calls in the year
  to March 2026 (`curated_contracts.csv`) and 25 transactions in 2026-10-16 to 2026-11-16.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x1c6ad754…` VerifyingPaymaster | config-only | $0 (EntryPoint v0.6 deposit) | 2026-01-03 | 0 |
| `0x3762a79b…` LiquidityBank (paused) | yes | $0 held | 2026-10-09 | 0 |
| `0x82eace5d…` co-signer | no | none through this key alone | 2026-11-14 | 32 |
| `0xba418fa6…` ownership module | no | $6.6k (escrow: 852 accounts; owner key + co-signer key) | 2026-11-14 | 25 |

The exposure returns if the owner refills a paymaster deposit or unpauses LiquidityBank and users deposit again. The
smart accounts behind module `0xba418fa6…` are reachable only with both the account owner's key and the co-signer key.

## Remediation

- Paymaster owner EOA `0xbe4c70a0…`: keep deposits at zero, or sponsor through a paymaster that verifies a post-quantum
  sponsor signature (ERC-7913 verifier) or through EIP-8141 frame-transaction sponsorship.
- LiquidityBank ProxyAdmin owner EOA `0xd77dbd06…`: keep it paused and empty, or upgrade it to verify order signatures
  with a post-quantum scheme.
- Module and co-signer: neither can be changed (no proxy; co-signer owner renounced). The operator must deploy a new
  module and co-signer with post-quantum verification; each account owner enables it and calls
  `disableModule(0xba418fa6…)`. Protocol change: EIP-8151 would also help owner EOAs that move to post-quantum code.
- Rotating any of these signer keys does not help; the owners and signers are themselves ECDSA EOAs. No protocol change
  is needed for the operator's fixes.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review08): MEDIUM -> LOW, step 5: EntryPoint deposit measured at 0 (escrow USD 0, block 26,431,544); status confirmed -> candidate and evidence source-read -> bytecode (no verified source exists); tx.origin allow-list found; project still unidentified (deployer EOA 0xac6a87c6… has no ENS or tag).
- 2026-11-17 (merged from `unidentified-3762a79b-signer-key`): created MEDIUM by `scripts/15_findings.py`; review (Review18): MEDIUM -> LOW, step 5: LiquidityBank holds USD 0 and has been paused since 2026-04-20; mechanism refined from bytecode.
- 2026-11-17 (merged from `unidentified-82eace5d-signer-key`): created MEDIUM by `scripts/15_findings.py`; review (Review15): MEDIUM -> LOW, step 4: the key is a co-signature next to the account owner's, so forging it alone takes nothing; identified as the co-signer of module 0xba418fa6 by deployer 0xac6a87; status candidate -> confirmed (bytecode plus trace).
- 2026-11-17 review (Review18, merge): `unidentified-3762a79b-signer-key` and `unidentified-82eace5d-signer-key`
  merged here (same deployer `0xac6a87c6…`); their evidence moved to `notes-liquiditybank.md` / `notes-cosigner.md` and
  the merged JSON files. Merged rating LOW (step 5: paymaster and LiquidityBank USD 0 exposed; co-signer LOW at step 4).
  Status `candidate`: two of three contracts are bytecode-only without a second check.
- 2026-11-17 review (Review22, move): module `0xba418fa6…` moved here from `biconomy-ecdsa-validator` (same deployer `0xac6a87c6…`; there it was rated MEDIUM at step 4). Here MEDIUM at step 4 (owners switch modules), LOW at step 5 (852 accounts, USD 6,557); finding stays LOW. Pattern PQ-12 added.
