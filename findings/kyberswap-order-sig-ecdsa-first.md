---
id: kyberswap-order-sig-ecdsa-first
title: "KyberSwap RFQ and DS limit orders: a quantum attacker who recovers a maker's old ECDSA key (and, for limit orders, KyberSwap's cosigner key) can fill the maker's orders at any price, even after the maker moves to a post-quantum account"
project: kyberswap
status: confirmed
severity: MEDIUM
patterns: [PQ-2]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: sole
role: core
contracts:
- address: "0x7a819fa46734a49d0112796f9377e024c350fb26"
  implementation: null
  name: KyberSwapRFQ
  upgradeable: "no"
  admin: "KSAdmin admin 0xbe2f0354d970265bfc36d383af77f72736b81b54 (EOA with EIP-7702 delegation): rescueFund and operators only, no upgrade"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 8672
- address: "0xcab2fa2eeab7065b45cbcf6e3936dde2506b4f6c"
  implementation: null
  name: DSLOProtocol
  upgradeable: config-only
  admin: "owner 0x2475039bf2ecdce2ee4c82954e64be9674f43546 (MultiSigWalletWithDailyLimit, 2 of 3): updateDSOrderSigner, pause"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 31492
families: []
fix:
  layer: new-deployment
  who_acts: "KyberSwap: deploy an RFQ contract that checks maker code first and accepts long ERC-1271 signatures, and makers move to it; DSLO owner multisig 0x2475039bf2ecdce2ee4c82954e64be9674f43546 points updateDSOrderSigner at a post-quantum ERC-1271 cosigner and the cosigning service refuses ECDSA maker signatures from accounts with code"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/kyberswap-order-sig-ecdsa-first
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl,out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review13 (re-read verified source on Sourcify; storage, owner and maker reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/kyberswap-order-sig-ecdsa-first/reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [kyberswap-quote-signer]
---

## Summary

KyberSwap's RFQ contract and its DS limit-order contract check the maker's order signature with `ecrecover` first and
call ERC-1271 only if the recovered address differs (PQ-2). A maker who moves to a post-quantum account at the same
address stays forgeable: a quantum attacker with the old key signs an order that sells the maker's approved tokens at
any price (on the limit-order contract the attacker must also forge KyberSwap's cosigner, itself an ECDSA EOA). The RFQ
contract also rejects any signature that is not 64 or 65 bytes, so a post-quantum maker cannot use it at all. The
exposure is makers' approvals to these contracts, which is not measured; the only RFQ maker seen recently is a contract
and is not forgeable through `ecrecover`. Rated MEDIUM (step 4): KyberSwap must deploy a new RFQ contract that makers
move to and repoint the limit-order cosigner; the draft's "fix by upgrade" was wrong, neither contract is upgradeable.

## Mechanism

- KyberSwapRFQ (`contracts/rfq/KyberSwapRFQ.sol`): `fillOrderRFQTo` (line 116) calls `_validate(maker, orderHash,
  signature)` (line 170). `_validate` (lines 195-211) runs `ECDSA.tryRecover`, `require(recoveredSigner != address(0))`
  (so any signature that is not 64/65 bytes reverts), and only `if (recoveredSigner != signer)` calls
  `isValidSignature` on the maker. On success the maker's `makerAsset` is transferred to the taker.
- DSLOProtocol (`DSLOProtocol.sol`): every fill goes through `fillOrderTo` (line 1356; `fillBatchOrdersTo` calls it,
  line 1669). It first requires `SignatureChecker.isValidSignatureNow(_dsOrderSigner, dsOrderHash, opSignature)`
  (lines 1379-1387), then on the first fill `isValidSignatureNow(order.maker, orderHash, orderSignature)` (lines
  1403-1408). The embedded OpenZeppelin `SignatureChecker` (lines 587-602) tries `ECDSA.tryRecover` before ERC-1271.
  `_dsOrderSigner` is set by `updateDSOrderSigner` (`onlyOwner`, line 1318).
- Pattern PQ-2 (the RFQ length check also has the effect of PQ-3 for contract makers). Excerpts:
  [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/kyberswap-order-sig-ecdsa-first/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify, re-read 2026-11-17): the two code paths above.
- CHECKED (on-chain, block 26,431,214): neither contract is a proxy; both hold under USD 0.01
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/kyberswap-order-sig-ecdsa-first/onchain.json)).
- CHECKED (on-chain, block 26,431,552, [`reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/kyberswap-order-sig-ecdsa-first/reads.json)):
  KyberSwapRFQ `admin()` = `0xbe2f0354d970265bfc36d383af77f72736b81b54`, an EOA with an EIP-7702 delegation. DSLOProtocol
  storage (layout from Sourcify): `_owner` = `0x2475039bf2ecdce2ee4c82954e64be9674f43546`
  (MultiSigWalletWithDailyLimit, `required()` 2 of 3 owners, one of them `0xbe2f0354…`), not paused; `_dsOrderSigner`
  = `0x1840a2b4c9e5c1eee42ad31bd57ba24a446d7974`, code size 0 (an EOA).
- CHECKED (Blockscout logs): the newest 2,000 `OrderFilledRFQ` events (blocks 26,398,945 to 26,426,199) all have maker
  `0xbee3211ab312a8d065c4fef0247448e17a8da000`, a TransparentUpgradeableProxy contract.
- CHECKED (precompile trace, 12 months to March 2026, `curated_contracts.csv` `txs_y1`): `ecrecover` in 138,854
  transactions through KyberSwapRFQ and 23,279 through DSLOProtocol.
- CHECKED (Xatu, any function, 2026-10-16 to 2026-11-16): 8,672 and 31,492 transactions
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/kyberswap-order-sig-ecdsa-first/activity.json)).
- INFERRED: the attribution of DSLOProtocol to KyberSwap follows the source (`KyberSwapRole`, KyberSwap limit-order
  types); the deployer was not traced.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x7a819fa4…` KyberSwapRFQ | no | — | 2026-11-16 | 8,672 |
| `0xcab2fa2e…` DSLOProtocol | config-only | — | 2026-11-16 | 31,492 |

What can be taken is what makers have approved to these two contracts, and only for makers who later migrate their
address to post-quantum authorisation (for an unmigrated EOA the old key controls everything anyway). Allowances were
not enumerated; `value_usd` is `null`. The recent RFQ maker is a contract, so `ecrecover` cannot match it; its own
ERC-1271 check must accept 64/65-byte signatures, so its internal signer is ECDSA, which is the maker's exposure, not
this contract's. DS limit orders come from many end users; a forgery there also needs KyberSwap's cosigner key, which
has signed on-chain and is equally recoverable.

## Remediation

- RFQ: KyberSwap deploys an RFQ contract that checks the maker's code first and passes signatures of any length to
  ERC-1271 (PQ-13 order); makers revoke approvals to `0x7a819fa4…` and move. Nothing in the deployed contract can be
  changed.
- DS limit orders: the owner multisig sets `updateDSOrderSigner` to a contract cosigner that verifies a post-quantum
  signature through ERC-1271 (a contract cannot be matched by `ecrecover`), and KyberSwap's cosigning service refuses
  orders whose maker has code but signed with ECDSA. This closes the path without a redeployment; a new deployment
  with code-first checking removes it fully.
- Users: revoke approvals to both contracts before or when migrating an address to post-quantum authorisation.
- Protocol change: EIP-8151 would make the old key useless for migrated makers without KyberSwap acting.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review13): MEDIUM unchanged, step 4, reason corrected: neither contract is upgradeable; the fix is a new RFQ deployment that the few makers move to, and a DSLO cosigner change by the 2-of-3 owner multisig. Read admin, owner, `_dsOrderSigner` (an EOA) and recent RFQ makers.
