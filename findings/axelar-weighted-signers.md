---
id: axelar-weighted-signers
title: "Axelar Gateway on Ethereum: a quantum attacker who recovers a weighted quorum of Axelar operator ECDSA keys can approve forged commands and release about USD 39.5M locked in the gateway"
project: axelar
status: confirmed
severity: MEDIUM
patterns: [PQ-5]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x3d3c73e91b1b0c243f1437f2d8363b1d5b093bd0"
  implementation: null
  name: AxelarAuthWeighted (current auth module, since 2026-11-12)
  upgradeable: config-only
  admin: owner AxelarGateway 0x4f4495243837681061c4743b74b3eedf548d56a5 (operator rotation via signed transferOperatorship; gateway upgradeable by AxelarServiceGovernance 0x7acbae6cba67d78aaf69e47000884ae00f9b2525)
  value_usd: 39499251
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: null
- address: "0xe3b83f79fbf01b25659f8a814945ab82186a8ad0"
  implementation: null
  name: AxelarAuthWeighted (retired auth module, replaced 2026-11-12)
  upgradeable: config-only
  admin: owner AxelarGateway 0x4f4495243837681061c4743b74b3eedf548d56a5; no longer called by it
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-12
  txs_30d: 4825
families: []
fix:
  layer: contract-upgrade
  who_acts: Axelar governance (AxelarServiceGovernance 0x7acbae6cba67d78aaf69e47000884ae00f9b2525, proposals from axelar10d07y265gmmuvt4z0w9aw880jnsr700j7v9daj, operator EOA 0xc8a8399c3d1207f4e109673be7047604737c1d56) upgrades the gateway to a post-quantum auth module; the Axelar validator set must sign with post-quantum keys
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/axelar-weighted-signers/classification.jsonl
  - evidence/axelar-weighted-signers/onchain.json
  - evidence/axelar-weighted-signers/activity.json
  - evidence/axelar-weighted-signers/source-excerpts.md
  - evidence/axelar-weighted-signers/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review18 (gateway and both auth modules from Sourcify, historical authModule reads, gateway escrow)
  ref: evidence/axelar-weighted-signers/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

Every command the Axelar Gateway on Ethereum executes (release or mint tokens, approve a contract call, rotate
operators) is accepted only if `AxelarAuthWeighted.validateProof` finds ECDSA signatures from Axelar operators whose
weights reach the threshold. A quantum attacker who derives enough operator keys from their public signatures can
sign `mintToken` commands that pay out the gateway's locked tokens (about USD 39.5M on 2026-11-17, within any
per-token mint limit per 6-hour period), approve arbitrary contract calls (Interchain Token Service releases), and rotate the
operator set to their own keys. Axelar governance can upgrade the gateway to a different auth module, as it did on
2026-11-12, but a post-quantum module also needs the Axelar validators to sign with new keys. Rated MEDIUM (step 4:
fixed by a governance upgrade plus several parties acting).

## Mechanism

- `AxelarGateway.execute(input)` (impl `0x16c22cbd…`, `AxelarGateway.sol` line 512) hashes the command batch and
  calls `IAxelarAuth(authModule).validateProof(messageHash, proof)` (line 519).
- `AxelarAuthWeighted.validateProof` → `_validateSignatures`: `ECDSA.recover(messageHash, signatures[i])` per
  signature (line 105), matched against the sorted operator list of an epoch no older than 16 rotations, summing
  weights to the threshold.
- Commands then run: `mintToken` → `_mintToken` transfers External tokens out of the gateway with `safeTransfer`
  (line 747) or mints internal Axelar tokens, counted against `tokenMintLimit`; `approveContractCall(WithMint)` lets
  a destination contract (for example Interchain Token Service) act on the message; `transferOperatorship` replaces
  the operator set when signed by the current one.
- Pattern PQ-5. Excerpts: [`source-excerpts.md`](../evidence/axelar-weighted-signers/source-excerpts.md).

## Evidence

- CHECKED (Sourcify exact matches, read 2026-11-17): gateway implementation `0x16c22cbd…` and both auth modules; the
  new module differs from the old one by one line in `_transferOperatorship`, the ECDSA check is identical
  ([`notes.md`](../evidence/axelar-weighted-signers/notes.md)).
- CHECKED (`cast`, eth.drpc.org): the gateway's `authModule()` was `0xe3b83f79…` at block 26,395,160 and is
  `0x3d3c73e9…` from block 26,395,170 to 26,431,544; the switch came with the upgrade to implementation `0x16c22cbd…`
  in tx `0x412a5698…`, sent by EOA `0xc8a8399c…` through `AxelarServiceGovernance.executeOperatorProposal`.
- CHECKED (`cast`, block 26,431,544): `governance()` = AxelarServiceGovernance `0x7acbae6c…` (governance chain
  "axelar", 3-day minimum timelock, operator `0xc8a8399c…`); both auth modules' `owner()` = gateway;
  `currentEpoch()` 20 (new) and 1,107 (old).
- CHECKED (Blockscout): gateway `Executed` events through block 26,426,190 (2026-11-16), so the new module is in use.
- CHECKED (Xatu, any function): the old module was called in 4,825 transactions in 2026-10-16 to 2026-11-16, last on
  2026-11-12 ([`activity.json`](../evidence/axelar-weighted-signers/activity.json)); 71,723 `ecrecover`-using
  transactions in the last year (`data/report/curated_contracts.csv`).
- CHECKED (Blockscout token balances, `cast balance`): gateway escrow as below.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x3d3c73e9…` AxelarAuthWeighted (current) | config-only | $39.5M escrow (gateway) | 2026-11-16 | not measured |
| `0xe3b83f79…` AxelarAuthWeighted (retired) | config-only | — | 2026-11-12 | 4,825 |

Escrow: AxelarGateway `0x4f4495243837681061c4743b74b3eedf548d56a5` holds USD 39.5M of priced tokens (ZIG 18.4M,
USDC 13.3M, WBTC 3.1M, WETH 1.7M, BUSD 1.3M, others) and 0.9 ETH on 2026-11-17. The per-symbol mint limits slow
but do not stop a drain, and a forged quorum can also rotate the operators. Not included: tokens in Interchain
Token Service token managers released by forged `approveContractCall` messages, and the market value of internal
Axelar tokens a forged `mintToken` would mint. The old module holds nothing and is no longer reachable from the
gateway.

## Remediation

- Axelar governance (`AxelarServiceGovernance` `0x7acbae6cba67d78aaf69e47000884ae00f9b2525`, proposals from
  `axelar10d07y265gmmuvt4z0w9aw880jnsr700j7v9daj`, executed by operator `0xc8a8399c…` or after the 3-day timelock)
  upgrades the gateway to an auth module that verifies a post-quantum scheme (hash-based or lattice threshold
  signatures, or a STARK proof of the validator signatures). The 2026-11-12 upgrade shows the path works.
- The Axelar validators must generate and sign with post-quantum keys; rotating ECDSA operators
  (`transferOperatorship`) does not help.
- Governance proposals reach the gateway through the same `validateProof`, so a forged quorum could also schedule
  a governance action; the 3-day timelock leaves time to react only if someone watches.
- No Ethereum protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review18): MEDIUM kept, step 4. The gateway switched to a new auth module `0x3d3c73e9…` on
  2026-11-12 (same ECDSA check); added it as the main contract and marked `0xe3b83f79…` retired. Measured the
  gateway escrow (USD 39.5M). `fix.layer` new-deployment -> contract-upgrade (governance upgrades the gateway).
