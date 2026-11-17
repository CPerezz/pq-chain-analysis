---
id: unidentified-fbeedcfe-signer-key
title: "Unidentified 1inch limit-order market maker: a quantum attacker who derives its operator's ECDSA key can sign 1inch orders that sell the contract's USD 1.1M inventory"
project: unidentified-fbeedcfe
status: confirmed
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0xfbeedcfe378866dab6abbafd8b2986f5c1768737"
  implementation: null
  name: unverified 1inch maker contract (ERC-1271)
  upgradeable: "no"
  admin: "unknown (unverified); operator signer 0xa009fa1ac416ec02f6f902a3a4a584b092ae6123 is immutable in the bytecode; storage slot 0 = deployer EOA 0x72e21ff5f6436345ae3781daa2bca02b7850fbee"
  value_usd: 1133444
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 7393
families: []
fix:
  layer: new-deployment
  who_acts: "the unidentified operator (deployer EOA 0x72e21ff5f6436345ae3781daa2bca02b7850fbee, operator EOA 0xa009fa1ac416ec02f6f902a3a4a584b092ae6123): deploy a maker contract whose isValidSignature verifies a post-quantum key, and move the inventory"
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-fbeedcfe-signer-key
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
  who: Review06 (Claude), 2026-11-17 review
  ref: debug_traceTransaction of three transactions; bytecode and storage reads on 2026-11-17
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

0xfbeedcfe… is an unverified market-maker contract that makes 1inch limit orders: the 1inch AggregationRouterV6
asks it `isValidSignature`, and it answers by `ecrecover`ing the order hash against one operator EOA, 0xa009fa1a…,
whose address is fixed in the bytecode. A quantum attacker who derives that key (it has sent 749k transactions) can
sign orders that sell the contract's tokens at any price; the contract held USD 1.13M on 2026-11-17. The operator is
not identified. Rated MEDIUM: step 4: the only fix is a new maker contract with a post-quantum key, to which the
operator moves its inventory.

## Mechanism

- In 1inch fills (tx 0x7e336514…, 0x878f7fb7…), the router 0x11111112… `STATICCALL`s `isValidSignature(bytes32,bytes)`
  (0x1626ba7e) on the contract; inside that frame the contract calls precompile 0x01, which returns 0xa009fa1a…. The
  router then calls the contract again (selector 0x0986bdd5, an interaction hook) and moves the maker's tokens.
- 0xa009fa1a… appears verbatim in the runtime bytecode, so the signer cannot be rotated; the same EOA sends the
  contract's own transactions (custom selectors 0x00000002, 0x00000033), including fills of UniswapX orders through
  a DELEGATECALL to 0x4347983e… (unverified, same deployer).
- Pattern PQ-4: one operator ECDSA key authorises orders that release the contract's own inventory. The exposure is
  the maker's own funds, not users'.

## Evidence

- CHECKED (debug_traceTransaction via eth.drpc.org; tx hashes from `data/agg/y1_tx_caller.parquet`): the call
  sequence and recovered address above ([`trace-notes.md`](#trace-notes-review06-2026-11-17)).
- CHECKED (runtime bytecode, 20,373 bytes, 2026-11-17): contains 0xa009fa1a…; no proxy; dispatch on non-standard
  selectors ([`bytecode.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-fbeedcfe-signer-key/bytecode.json)); storage slot 0 =
  0x72e21ff5… (deployer, EOA, per Blockscout creator).
- CHECKED (on-chain read at block 26,431,214): 9.98 ETH and tokens, USD 1,133,444 in total (WETH USD 758k)
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-fbeedcfe-signer-key/onchain.json)).
- CHECKED (Xatu, any function): 7,393 transactions in 2026-10-16 to 2026-11-16, last on 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/unidentified-fbeedcfe-signer-key/activity.json)); `curated_contracts.csv`: 111,020
  ecrecover calls in the last year.
- INFERRED: the operator EOA can also move funds directly through the contract's private functions; not decoded.
- Identity: not established. Blockscout has no name or tag for the contract, the operator or the deployer; the
  deployer's other contracts (0x4347983e…, 0xdbb4aec6…, 0x9461cda2… and others) are unverified.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xfbeedcfe…` maker contract | no (signer immutable) | $1.13M (2026-11-17) | 2026-11-16 | 7,393 |

- The held value is the exposure: a forged order sells this inventory. No users' approvals are involved.

## Remediation

- Deploy a maker contract whose `isValidSignature` verifies a post-quantum signature (or calls a verifier contract
  that can be upgraded), and move the inventory to it; retire this contract.
- Who acts: the unidentified operator controlling 0x72e21ff5… and 0xa009fa1a…. No protocol change is needed;
  EIP-8151 would not help (the operator is a code-less EOA).

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by a new deployment that the operator and users move to).
- 2026-11-17 review (Review06): MEDIUM confirmed (step 4: the operator must redeploy and move USD 1.13M). Status candidate -> confirmed: transaction traces show the 1inch router calling isValidSignature and the contract recovering the immutable operator 0xa009fa1a…; operator not identified.

# Source excerpts: unidentified-fbeedcfe-signer-key

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xfbeedcfe378866dab6abbafd8b2986f5c1768737`

No verified source on Sourcify or Blockscout.

# Trace notes (Review06, 2026-11-17)

debug_traceTransaction (callTracer) via https://eth.drpc.org; tx hashes from data/agg/y1_tx_caller.parquet (caller = this contract, precompile ecrecover). Summary printed by a throwaway script: frames to/from the contract and every call to precompile 0x01.

```
== 0x7e3365144aba9d14a0de76cd03c06b6ecc6e5080a8df30cf73947d077bb1131b top input 0x07ed2379 to 0x111111125421ca6dc452d289314280a0f8842a65
          STATICCALL 0x11111112->0xfbeedcfe378866dab6abbafd8b2986f5c1768737 0x1626ba7e val=None
          CALL 0x11111112->0xfbeedcfe378866dab6abbafd8b2986f5c1768737 0x0986bdd5 val=0x0
ECRECOVER {"depth": 6, "ecrecover_from_frame": "0xfbeedcfe378866dab6abbafd8b2986f5c1768737", "ctx": ["0x11111112", "0x990636ec", "0x990636ec", "0x990636ec", "0x11111112", "0xfbeedcfe"], "input": "0x32d2cff469a99b661de76c427c28a21af5ce1e1cd48c0d33cbab14fdb0778d4c000000000000000000000000000000000000000000000000000000000000001bddae6cfedbcbc27e7e8fafd98e982075af0617e2f0092b14997e2425e7ceea095d942f948a4c8ad471a75773d655827eceb49d889fc23181be22d35f21598077", "output": "0x000000000000000000000000a009fa1ac416ec02f6f902a3a4a584b092ae6123"}
== 0x878f7fb77827d652f5129ea1ea3bf091bf82c35a2948b8cfe512652c84492e70 top input 0x5f575529 to 0x881d40237659c251811cec9c364ef91dc08d300c
ECRECOVER {"depth": 7, "ecrecover_from_frame": "0xfbeedcfe378866dab6abbafd8b2986f5c1768737", "ctx": ["0x881d4023", "0x74de5d4f", "0x7cdf68ce", "0x11111112", "0x5141b82f", "0x11111112", "0xfbeedcfe"], "input": "0x294a51f75096adf861272445000f7d0d2ea8779e4683e8622eb317653d5f8375000000000000000000000000000000000000000000000000000000000000001bed08fe90779a7768a00655fb44bddc0fe33afea2bd2aff210947b40d3bc82f32214d59e6f43b8bd727ef6c03fd2baad7406981a96263c4796187bae692275f3c", "output": "0x000000000000000000000000a009fa1ac416ec02f6f902a3a4a584b092ae6123"}
== 0x443208622922b8719df43f0f7b911565cc937819be701b4a8f0a3d170b991952 top input 0x00000002 to 0xfbeedcfe378866dab6abbafd8b2986f5c1768737
CALL 0xa009fa1a->0xfbeedcfe378866dab6abbafd8b2986f5c1768737 0x00000002 val=0x1935057
  CALL 0xfbeedcfe->0x92560c178ce069cc014138ed3c2f5221ba71f58a 0x128acb08 val=0x0
    CALL 0x92560c17->0xfbeedcfe378866dab6abbafd8b2986f5c1768737 0xfa461e33 val=0x0
      CALL 0xfbeedcfe->0xc18360217d8f7ab5e7c516566761ea12ce7f9d72 0xa9059cbb val=0x0
  CALL 0xfbeedcfe->0x4838b106fce9647bdf1e7877bf73ce8b0bad5f97 0x val=0x3b3af4e4cfe
```

- Router 0x111111125421ca6dc452d289314280a0f8842a65 = 1inch AggregationRouterV6; selector 0x1626ba7e = isValidSignature(bytes32,bytes).
- ecrecover inside the contract's frame returns 0xa009fa1ac416ec02f6f902a3a4a584b092ae6123 (EOA, nonce 749,392 at 2026-11-17), which also sends the contract's own transactions (selectors 0x00000002, 0x00000033).
- 0xa009fa1a… appears verbatim in the runtime bytecode (immutable); storage slot 0 = 0x72e21ff5f6436345ae3781daa2bca02b7850fbee (the deployer, EOA).
- Deployer 0x72e21ff5… also created 0x4347983e483ea47099e8cbca160c92599791b76a (unverified), which the contract DELEGATECALLs in fills of UniswapX V2DutchOrderReactor 0x00000011f84b9aa48e5f8aa8b9897600006289be orders (tx 0xc7143268…).
