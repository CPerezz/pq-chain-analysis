---
id: tokenlon-order-sig-ecdsa-first
title: "Tokenlon AMMWrapperWithPath and PMM: a recovered user ECDSA key signs swaps that pull the user's tokens approved to Tokenlon, even after the address moves to post-quantum code"
project: tokenlon
status: confirmed
severity: MEDIUM
patterns: [PQ-2, PQ-3]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x4a14347083b80e5216ca31350a2d21702ac3650d"
  implementation: null
  name: AMMWrapperWithPath
  upgradeable: "no"
  admin: none on the contract; Tokenlon UserProxy 0x03f34be1bf910116595db1b11e9d1b2ca5d59659 operator DelayedMultiSig 0x9afc226dc049b99342ad6774eeb08bfa2f874465 (3 of 5) can disable or replace it, and as Spender 0x3c68dfc45dc92c9c605d92b49858073e10b857a6 operator can deauthorize it
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 5138
- address: "0x8d90113a1e286a5ab3e496fbd1853f265e5913c6"
  implementation: null
  name: PMM
  upgradeable: "no"
  admin: none on the contract; Tokenlon UserProxy 0x03f34be1bf910116595db1b11e9d1b2ca5d59659 operator DelayedMultiSig 0x9afc226dc049b99342ad6774eeb08bfa2f874465 (3 of 5) can disable or replace it, and as Spender 0x3c68dfc45dc92c9c605d92b49858073e10b857a6 operator can deauthorize it
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 2331
families: []
fix:
  layer: new-deployment
  who_acts: Tokenlon operator DelayedMultiSig 0x9afc226dc049b99342ad6774eeb08bfa2f874465 (3 of 5) deploys strategy contracts that check account code before ECDSA and accept full-length ERC-1271 signatures, points UserProxy 0x03f34be1bf910116595db1b11e9d1b2ca5d59659 at them (upgradeAMMWrapper, upgradePMM) and deauthorizes the old ones in Spender 0x3c68dfc45dc92c9c605d92b49858073e10b857a6
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tokenlon-order-sig-ecdsa-first
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review02 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tokenlon-order-sig-ecdsa-first/onchain-review.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by a person)"
  ref: "studies/eip-8151-impact, reading 3 (does EIP-8151 close this path), 2026-11-19"
  date: 2026-11-19
  verdict: confirmed
  rating: ''
related: []
---

## Summary

Tokenlon's swap strategies AMMWrapperWithPath and PMM accept a user's signed order and then pull the user's tokens
through Tokenlon's Spender and AllowanceTarget. Both accept a plain ECDSA signature for the user address even when
that address has code (AMMWrapperWithPath lets the signer pick the scheme; PMM always runs `ecrecover` first), so a
quantum attacker who recovers a user's old key can sign a swap of everything that user approved to Tokenlon, with
the proceeds sent to the attacker, even after the user moves the address to post-quantum code (PQ-2). The exposure is
users' approvals to AllowanceTarget `0x8a42d311…`, which is not measurable here. The contracts are immutable, but
Tokenlon's 3-of-5 operator multisig can disable them and point UserProxy at replacements, so the rating is MEDIUM
(step 4: fix by new deployment and one team's configuration).

## Mechanism

- AMMWrapperWithPath: `UserProxy.toAMM(payload)` (anyone) → `AMMWrapperWithPath.trade(order, feeFactor, sig, ...)`
  (`onlyUserProxy`) → `_verify` builds the EIP-712 digest over the order including `receiverAddr` and calls
  `isValidSignature(order.userAddr, digest, "", sig)` (`contracts/AMMWrapper.sol` line 365). In
  `contracts/utils/SignatureValidator.sol` (lines 67–174) the last signature byte selects the type: `EIP712` and
  `EthSign` call `ecrecover` and compare with the user address; `WalletBytes`, `WalletBytes32` and `Wallet` call the
  account's ERC-1271 `isValidSignature` with the full signature. `_prepare` then calls
  `spender.spendFromUser(order.userAddr, takerAsset, amount)` and `_settle` pays the output to `receiverAddr`.
- PMM: `UserProxy.toPMM(payload)` (any EOA) → `PMM.fill(userSalt, data, userSignature)` → `_assertTransaction`
  sets `user = _ecrecoverAddress(transactionHash, userSignature)`; only if that differs from
  `order.feeRecipientAddress` does it require the fee-recipient address to be a contract and call its
  `isValidSignature(bytes32, userSignature)` (`PMM.sol` lines 1420–1437). `decodeUserSignatureWithoutSign` requires the
  user signature to be 85 or 86 bytes, so the ERC-1271 path cannot carry a post-quantum signature (PQ-3 for PMM; a
  wallet that accepts pre-approved hashes can still use it). `spender.spendFromUser(user, ...)` pulls the tokens and
  `_settle` pays `receiver` (taken from the signature).
- Excerpts: [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tokenlon-order-sig-ecdsa-first/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify, both contracts): the paths above; neither contract is a proxy and neither has a
  function that changes the signature check.
- CHECKED (on-chain read at block 26,431,454, [`onchain-review.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tokenlon-order-sig-ecdsa-first/onchain-review.json)):
  UserProxy `0x03f34be1…` (TransparentUpgradeableProxy, implementation UserProxy 5.2.0 `0x0b9f13ff…`, EIP-1967 admin
  DelayedMultiSig `0x74c3ca94…`) returns `ammWrapperAddr()` = AMMWrapperWithPath and `pmmAddr()` = PMM, both enabled;
  its `operator()` is DelayedMultiSig `0x9afc226d…` (3 of 5, `secondsTimeLocked` 0), which also operates Spender
  `0x3c68dfc4…`; Spender `isAuthorized` is true for both contracts and its `allowanceTarget()` is `0x8a42d311…`.
- CHECKED (UserProxy source): `upgradeAMMWrapper`, `upgradePMM`, `setAMMStatus`, `setPMMStatus` are `onlyOperator`;
  Spender `deauthorize` is `onlyOperator` without timelock (authorising a new caller goes through the timelock).
- CHECKED (on-chain read at block 26,431,214, [`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tokenlon-order-sig-ecdsa-first/onchain.json)):
  the two contracts hold USD 102,046 and USD 44,143 in tokens and ETH.
- CHECKED (Xatu, [`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/tokenlon-order-sig-ecdsa-first/activity.json)): 5,138 and 2,331
  transactions 2026-10-16 to 2026-11-16.
- INFERRED: the contracts' own balances are fee and residual balances; a forged user signature pulls tokens from the
  user through Spender, not from these balances.
- CHECKED (executed, study `eip-8151-impact`, 2026-11-19): a real transaction,
  `0x0274429f6c48ecddfd14f2263bcceb1441825531e18a814895d5e14ba63def2d` (block 26,436,435, position 0), replayed on
  the reference implementation of the fork with only the precompile changed. Under today's rule it matches its
  receipt (417,223 gas); under EIP-8151 it also succeeds (420,323 gas). With one byte of code at the recovered signer
  `0x4b9fe9607a8428c3f8e0cde671e2338bd5b202ee`, it reverts after that recovery returned no address; with a 7702
  delegation there it succeeds. Study family `443221c0` (AMMWrapperWithPath).

## Impact and exposure

| Contract | Upgradeable | Held now (not the exposure) | Last active | 30-day txs | Pre-quantum txs (12 months) |
|---|---|---|---|---|---|
| `0x4a143470…` AMMWrapperWithPath | no | $102k | 2026-11-16 | 5,138 | 142,818 |
| `0x8d90113a…` PMM | no | $44k | 2026-11-15 | 2,331 | 103,846 |

The exposure is what users have approved to Tokenlon's AllowanceTarget `0x8a42d311d282bfcaa5133b2de0a8bcdbecea3073`
(bounded by each user's balance), which needs a per-user allowance scan and is not measured; `value_usd` is null. The
contracts' own holdings (block 26,431,214) are not what a forged signature releases and were removed as `held` values.
Yearly counts are `txs_y1` from `studies/top-callers-classification/results/curated_contracts.csv`.

Siblings not checked: the same UserProxy routes to RFQ `0xfd6c2d24…`, RFQv2 `0x91c98670…` and LimitOrder
`0x623a6b34…`, which are not in the census data.

## Remediation

- Replacement: new AMM and PMM strategy contracts that verify through ERC-1271 with the full signature whenever the
  user address has code and use `ecrecover` only for code-less addresses (PQ-13 ordering, e.g. current OpenZeppelin
  `SignatureChecker`), with no length limit on the ERC-1271 signature.
- Who acts: Tokenlon operator DelayedMultiSig `0x9afc226d…` (3 of 5) deploys them, calls `upgradeAMMWrapper` /
  `upgradePMM` on UserProxy `0x03f34be1…`, and `deauthorize`s the old contracts in Spender `0x3c68dfc4…`. No contract
  upgrade of the old code is possible or needed.
- Protocol change: EIP-8151 would help (it makes `ecrecover` fail for addresses with real code, closing the ECDSA path
  for migrated users without Tokenlon).
- Users: revoke approvals to AllowanceTarget `0x8a42d311…`, or move funds to a fresh post-quantum account.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review02): HIGH -> MEDIUM, step 3: the contracts are immutable but the Tokenlon operator DelayedMultiSig 0x9afc226d… (3 of 5) can disable and replace both in UserProxy 0x03f34be1… and deauthorize them in Spender (read at block 26,431,454), so the fix is a new deployment by one team. Removed the `held` values (contract balances are not the exposure; the exposure is user approvals to AllowanceTarget, unmeasured). Added PQ-3 for PMM's 85/86-byte user-signature limit.
- 2026-11-19 (study `eip-8151-impact`, reading 3): EIP-8151 as written closes this path for an account that takes
  real code (executed on a real transaction); plain and 7702-delegated accounts stay exposed, and approvals already
  given stay valid.
