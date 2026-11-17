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
  links:
  - evidence/unidentified-fbeedcfe-signer-key/classification.jsonl
  - evidence/unidentified-fbeedcfe-signer-key/onchain.json
  - evidence/unidentified-fbeedcfe-signer-key/activity.json
  - evidence/unidentified-fbeedcfe-signer-key/source-excerpts.md
  - evidence/unidentified-fbeedcfe-signer-key/trace-notes.md
  - evidence/unidentified-fbeedcfe-signer-key/bytecode.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
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
  sequence and recovered address above ([`trace-notes.md`](../evidence/unidentified-fbeedcfe-signer-key/trace-notes.md)).
- CHECKED (runtime bytecode, 20,373 bytes, 2026-11-17): contains 0xa009fa1a…; no proxy; dispatch on non-standard
  selectors ([`bytecode.json`](../evidence/unidentified-fbeedcfe-signer-key/bytecode.json)); storage slot 0 =
  0x72e21ff5… (deployer, EOA, per Blockscout creator).
- CHECKED (on-chain read at block 26,431,214): 9.98 ETH and tokens, USD 1,133,444 in total (WETH USD 758k)
  ([`onchain.json`](../evidence/unidentified-fbeedcfe-signer-key/onchain.json)).
- CHECKED (Xatu, any function): 7,393 transactions in 2026-10-16 to 2026-11-16, last on 2026-11-16
  ([`activity.json`](../evidence/unidentified-fbeedcfe-signer-key/activity.json)); `curated_contracts.csv`: 111,020
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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by a new deployment that the operator and users move to).
- 2026-11-17 review (Review06): MEDIUM confirmed (step 4: the operator must redeploy and move USD 1.13M). Status candidate -> confirmed: transaction traces show the 1inch router calling isValidSignature and the contract recovering the immutable operator 0xa009fa1a…; operator not identified.
