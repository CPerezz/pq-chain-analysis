---
id: cow-aave-adapter-order-code-first
title: "Aave Labs' Aave V3 × CoW flash-loan adapter factory checks account code before ECDSA; a quantum attacker gains nothing beyond each EOA's own key"
project: aave
status: not-affected
severity: NONE
patterns: [PQ-13]
primitives: [ecrecover]
trigger: none
impact: none
alternative: alternative-exists
role: core
contracts:
- address: "0xdecc46a4b09162f5369c5c80383aaa9159bcf192"
  implementation: null
  name: AaveV3AdapterFactory
  upgradeable: config-only
  admin: owner Safe 0x187aae17d4931310b3fc75743e7f16bdc9ed77e9 (5 of 8; setAdapterImplementation, pause, rescueTokens)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 4691
families: []
fix:
  layer: none
  who_acts: nobody needs to act; owner Safe 0x187aae17d4931310b3fc75743e7f16bdc9ed77e9 (Aave Labs deployment) controls adapter listing and pause only
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/cow-aave-adapter-order-code-first/classification.jsonl
  - evidence/cow-aave-adapter-order-code-first/onchain.json
  - evidence/cow-aave-adapter-order-code-first/activity.json
  - evidence/cow-aave-adapter-order-code-first/source-excerpts.md
  - evidence/cow-aave-adapter-order-code-first/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review18 (Sourcify source incl. OpenZeppelin SignatureChecker, deployer history on Blockscout, owner read)
  ref: evidence/cow-aave-adapter-order-code-first/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: NONE
related: [aave-atoken-permit-ecdsa-only]
---

## Summary

The AaveV3AdapterFactory lets an Aave user authorise a CoW Protocol order that runs a flash-loan adapter (debt swap,
collateral swap, repay with collateral) by signing the adapter order. It verifies that signature with OpenZeppelin
`SignatureChecker`, which sends any signer with code to ERC-1271 with the full signature and uses `ecrecover` only for
code-less addresses (PQ-13). A quantum attacker therefore gains nothing here beyond the EOA key they already broke,
and an account that migrates with real code (a smart account or an EIP-7702 delegate) is not forgeable. Rated NONE.
The contract was deployed by Aave Labs, not CoW: project changed to `aave`.

## Mechanism

- A CoW order's owner is a per-order adapter instance; when the settlement checks the instance's ERC-1271 signature,
  the instance calls `BaseAdapterFactory.verifyOrderSignature(orderOwner, order, signature)` (line 151), which builds
  an EIP-712 digest over the adapter order and returns `SignatureChecker.isValidSignatureNow(orderOwner, digest,
  signature)` (line 172).
- OpenZeppelin `SignatureChecker.isValidSignatureNow` (line 33): `signer.code.length == 0` → `ECDSA.tryRecover`;
  otherwise `isValidERC1271SignatureNow`, passing the whole signature (line 53).
- Pattern PQ-13. Excerpts: [`source-excerpts.md`](../evidence/cow-aave-adapter-order-code-first/source-excerpts.md).

## Evidence

- CHECKED (Sourcify full source, read 2026-11-17): `verifyOrderSignature` and the code-first `SignatureChecker` as above;
  `@author Aave Labs.` in `AaveV3AdapterFactory.sol` and `BaseAdapterFactory.sol`
  ([`notes.md`](../evidence/cow-aave-adapter-order-code-first/notes.md)).
- CHECKED (Sourcify deployment record, Blockscout): deployed at block 23,812,751 by EOA
  `0xdf0a18f9be8cecc1d4fde078d99ee2ed4885ac5e`, which also deployed the newer Aave adapter factories through Aave's
  `TransparentProxyFactory` `0xeb0682d148e874553008730f0686ea89db7da412`.
- CHECKED (`cast`, block 26,431,494): `owner()` = Safe `0x187aae17d4931310b3fc75743e7f16bdc9ed77e9` (5 of 8 at block
  26,431,214, [`onchain.json`](../evidence/cow-aave-adapter-order-code-first/onchain.json)); `paused()` = false; not a
  proxy.
- CHECKED (precompile trace): 18,605 `ecrecover` calls in the last year (`data/report/curated_contracts.csv`).
- CHECKED (Xatu, any function): last active 2026-11-16, 4,691 transactions in 2026-10-16 to 2026-11-16
  ([`activity.json`](../evidence/cow-aave-adapter-order-code-first/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xdecc46a4…` AaveV3AdapterFactory | config-only | none beyond each signer's own key | 2026-11-16 | 4,691 |

The factory holds nothing between transactions (USD 0 at block 26,431,214). Siblings checked: the newer factories
deployed 2026-10-09 (proxies `0xd2cc30cb…`, `0x0c6f0d00…`, `0xfdfa0362…`, same owner Safe; implementations
`0xde33afe5…`, `0xaed8fb57…`, `0x38a9bdc0…`) use OpenZeppelin v5.6.0 `SignatureChecker.isValidSignatureNowCalldata`,
also code-first; not affected either. CoW's GPv2Settlement, which settles these orders, is a separate finding
(`cow-order-sig-scheme-select`); adapter orders reach it through the `Eip1271` scheme.

## Remediation

None needed in the contract. EOA users who move to post-quantum authorisation keep this path working by giving the
address real code (EIP-7702 delegate or smart account) that implements ERC-1271 with a post-quantum signature.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated NONE (code checked first: no exposure beyond the account's own key).
- 2026-11-17 review (Review18): NONE kept. Project changed from `cow-protocol` to `aave`: source says `@author Aave
  Labs.` and the deployer EOA `0xdf0a18f9…` deploys Aave's adapter factories through Aave's TransparentProxyFactory;
  code-first check confirmed in OpenZeppelin `SignatureChecker`; newer factories checked, same pattern.
