---
id: unidentified-049a6f30-signer-key
title: "Unidentified market maker's RFQ wallet 0x049a6f30 (also runs Hashflow pool \"ant\"): a quantum attacker who recovers its owner ECDSA key can sign Permit2 transfers out of the wallet or withdraw its USD 121k directly"
project: unidentified-049a6f30
status: confirmed
severity: MEDIUM
patterns: [PQ-4, PQ-17]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x049a6f30a91cdad18473739a69f957175acb83d3"
  implementation: null
  name: unverified market-maker wallet (isValidSignature = ECDSA against owner())
  upgradeable: config-only
  admin: "owner EOA 0x595744b06ee5df7c88b65ef5894fae36f2fc4a59 and manager EOA 0xda01030801473ab96af1b6121251bad6f9dcb114 (each can setOwner, setExecutor, approve, withdrawTokens, withdrawETH); no proxy, code fixed; read at block 26,431,537"
  value_usd: 121368
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-07-01
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "the market maker (owner EOA 0x595744b06ee5df7c88b65ef5894fae36f2fc4a59 or manager EOA 0xda01030801473ab96af1b6121251bad6f9dcb114): withdraw to a new wallet whose isValidSignature verifies a post-quantum signer"
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-049a6f30-signer-key
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: review (Review16)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-049a6f30-signer-key/escrow.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families c4b84705"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: []
---

## Summary

`0x049a6f30…` is a market maker's own trading wallet: it holds the maker's inventory, has approved Permit2 without
limit for each of its six main tokens, and answers ERC-1271 `isValidSignature` by checking an ECDSA signature against one stored `owner` key.
That key signs the maker's RFQ quotes (0x Settler / Relay fills via Permit2), so its public key is in calldata; a
quantum attacker who recovers it can sign Permit2 transfers of everything in the wallet, or send `withdrawTokens`
from the owner address itself. Exposed: USD 121k held (block 26,431,537). The wallet code is fixed and `setOwner`
only rotates to another ECDSA key, so the fix is a new wallet: MEDIUM (step 4). The operator is not identified by name.

## Mechanism

- Unverified bytecode (3,763 bytes, no proxy, no `DELEGATECALL`). `isValidSignature(bytes32,bytes)` (`0x1626ba7e`)
  runs an OpenZeppelin-style `ECDSA.tryRecover` (ecrecover precompile; error selectors `0xf645eedf`
  `ECDSAInvalidSignature`, `0xfce698f7` `ECDSAInvalidSignatureLength` in the code) and returns the magic value when
  the recovered address equals `owner()`. There is no account-code check and no forwarding to a contract owner.
- Traced fill (tx `0x30dab5e5…`, block 25,440,961, 2026-07-01): RelayRouterV3 → MainnetSettler `0x7f54f056…` →
  Permit2 `permitWitnessTransferFrom` → `0x049a6f30.isValidSignature` → ecrecover returns `0x595744b0…` (= `owner()`)
  → Permit2 pulls the wallet's USDC. Permit2 is approved for the maximum amount on every material token held
  (PENDLE, AAVE, USDT, NEIRO, WETH, USDC; read at block 26,431,537).
- A second path needs no signature check at all: `withdrawTokens(address[])` and `withdrawETH()` succeed when sent
  from the owner or the manager EOA and pay `msg.sender` (tx `0x2379f7d0…` sent 652,665 USDT and 641,173 USDC to the
  manager). Recovering either key therefore empties the wallet.
- `setOwner(address,address)` and `setExecutor(uint256,address)` replace keys, but the new owner is again compared
  with an `ecrecover` result, so only another ECDSA key can sign: `alternative: key-rotation-only`.
- Pattern PQ-4 (one key signs RFQ quotes). No verified source exists
  ([`source-excerpts.md`](#source-excerpts-unidentified-049a6f30-signer-key)).

## Evidence

- CHECKED (bytecode, evmole selectors + openchain names, disassembly): selectors and the `tryRecover` tail listed
  above; no `DELEGATECALL`; the only other `STATICCALL` is ERC-20 `balanceOf` in `withdrawTokens`.
- CHECKED (drpc `debug_traceTransaction`, tx `0x30dab5e5…`, block 25,440,961): Permit2 → `isValidSignature` →
  ecrecover → `0x595744b0…`.
- CHECKED (`eth_call` replay at block 26,431,537): the same `isValidSignature` input still returns `0x1626ba7e`; with
  one byte of the hash changed it returns `0xffffffff`.
- CHECKED (`eth_call` at block 26,431,537): `owner()` = `0x595744b0…`, `0xe73c35eb()` = `0xda010308…`,
  `executor0()` = creator `0x9e995485…`, `executor1/2()` = zero; both key holders have no code (EOAs).
  `setOwner`/`setExecutor`/`approve`/`withdrawTokens`/`withdrawETH` succeed from the owner and the manager and revert
  (`0x1f6078af`) from `executor0` and from an unrelated address.
- CHECKED (`eth_call` at block 26,431,537): token balances and Permit2 allowances (all max) in
  [`escrow.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-049a6f30-signer-key/escrow.json); prices from Blockscout `exchange_rate`.
- CHECKED (Blockscout): created 2024-09-09 by `0x9e995485…` with constructor arguments (owner `0x595744b0…`, manager
  `0xda010308…`). The same creator created HashflowPool `0xfbf37e48…` (pool `name()` = "ant", `operations()` = the
  creator) through HashflowFactory and called `updateSigner` on it. No ENS name or explorer tag for the wallet, creator,
  owner or manager; a web search for the address found nothing. `findings_map.csv` has no note for this address.
- CHECKED (Blockscout token transfers; [`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-049a6f30-signer-key/activity.json)):
  last value-moving transaction 2026-07-01 (block 25,440,961); later entries are unsolicited token airdrops
  (2026-07-23 to 2026-10-19) and two address-poisoning transactions (2026-01-17). No transaction in 2026-10-16 to
  2026-11-16. Yearly pre-quantum calls (`curated_contracts.csv`, `txs_y1`): 84,885.
- INFERRED: the owner key has never sent a transaction (Blockscout count 0) but its signatures are in fill calldata,
  so its public key is recoverable; the manager key has sent transactions (last 2024-12-06).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x049a6f30…` market-maker wallet | config-only | USD 121k | 2026-07-01 | 0 |

Holdings at block 26,431,537 (ETH at USD 1,811.62, tokens at Blockscout `exchange_rate` on 2026-11-17): PENDLE
38,014.8 (USD 54,741), AAVE 298.6 (USD 32,378), USDT 12,035.8 (USD 12,027), NEIRO 234.4M (USD 11,500), WETH 4.035
(USD 7,323), USDC 3,380.9 (USD 3,380), other tokens USD 11, ETH 0.0046 (USD 8). Total USD 121,368, all the
maker's own inventory; no third-party funds sit here. The wallet has been idle since 2026-07-01 but still holds value,
so rubric step 1 does not apply. The maker's Hashflow pool `0xfbf37e48…` is a HashflowPool clone covered by
`hashflow-pool-quote-signer`; it was not measured here.

## Remediation

- Replacement: a wallet whose `isValidSignature` verifies a post-quantum signature (for example an ERC-7913 verifier
  for the maker's quote key), or that delegates to a post-quantum smart account, with Permit2 approvals moved to it.
- Who acts: the market maker, from owner EOA `0x595744b06ee5df7c88b65ef5894fae36f2fc4a59` or manager EOA
  `0xda01030801473ab96af1b6121251bad6f9dcb114`: deploy the new wallet and `withdrawTokens`/`withdrawETH` everything to
  it; the old wallet's Permit2 approvals then cover nothing.
- Protocol change: not needed; EIP-8151 would not help, because the owner is a code-less EOA. Nobody else can act:
  the funds are the maker's own.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review16): MEDIUM -> MEDIUM, step 4: signer check confirmed by trace and `eth_call` replay (ECDSA against `owner()` `0x595744b0…`, no ERC-1271 forwarding); code is fixed, so the fix is a new wallet; USD 121,368 held at block 26,431,537 (over USD 50k, step 5 does not lower); active until 2026-07-01 (step 1 does not apply). Corrected admin (owner and manager EOAs, both able to withdraw directly; `executor0` cannot), fix.who_acts, title; status candidate -> confirmed. Operator not identified (creator also runs Hashflow pool "ant").
- 2026-11-19 (study `eip-8151-impact`, PQ-17): under EIP-8151 the signer key can be replaced; it must be rotated before its account takes code.

# Source excerpts: unidentified-049a6f30-signer-key

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x049a6f30a91cdad18473739a69f957175acb83d3`

No verified source on Sourcify or Blockscout.
