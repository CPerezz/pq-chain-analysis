---
id: ethena-token-permit-ecdsa-only
title: "Ethena USDe, sUSDe, USDtb and sENA: permit accepts ECDSA only, so a recovered holder key can approve and drain that holder's tokens even after the holder moves to post-quantum keys; USDe and sUSDe cannot be upgraded"
project: ethena
status: confirmed
severity: HIGH
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: sole
role: auxiliary
contracts:
- address: "0x4c9edd5852cd905f086c759e8383e09bff1e68b3"
  implementation: null
  name: USDe
  upgradeable: "no"
  admin: none for the permit code (no proxy); owner EthenaTimelockController 0xe8dc0fab349ea169283c48ccfd09d797e6db7c94 can only set the minter
  value_usd: 4853105840
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 75657
- address: "0x9d39a5de30e57443bff2a8307a4256c8797a3497"
  implementation: null
  name: StakedUSDeV2 (sUSDe)
  upgradeable: "no"
  admin: none for the permit code (no proxy); owner EthenaTimelockController 0xe8dc0fab349ea169283c48ccfd09d797e6db7c94 holds parameter roles only
  value_usd: 1181500848
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 21822
- address: "0x8be3460a480c80728a8c4d7a5d5303c85ba7b3b9"
  implementation: "0x7fd57b46ae1a7b14f6940508381877ee03e1018b"
  name: Staked ENA (sENA), TransparentUpgradeableProxy → StakedENA
  upgradeable: "yes"
  admin: ProxyAdmin 0xf849d7792ff9b30a57656ee10a2776bcb49f4fe4, owned by Safe 0x3b0aaf6e6fcd4a7ceef8c92c32dfea9e64dc1862 (5 of 10, block 26431494)
  value_usd: 109914767
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 6534
- address: "0xc139190f447e929f090edeb554d95abb8b18ac1c"
  implementation: "0x9d6d77a21702b9afcf924983fbfb84aaaae79589"
  name: USDtb, TransparentUpgradeableProxy → AnchorageTokenUSDtb
  upgradeable: "yes"
  admin: ProxyAdmin 0x3c405f68d5c6ece868e5646cac926679839acd68, owned by EOA 0xd93826bb299765c87d13aeba2a7e5d9b27a03956 (block 26431788)
  value_usd: 317905055
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: null
families: []
fix:
  layer: account-migration
  who_acts: USDe and sUSDe holders (move balances to a fresh post-quantum address; the tokens cannot change); for sENA, Safe 0x3b0aaf6e6fcd4a7ceef8c92c32dfea9e64dc1862 (owner of ProxyAdmin 0xf849d7792ff9b30a57656ee10a2776bcb49f4fe4) and for USDtb, EOA 0xd93826bb299765c87d13aeba2a7e5d9b27a03956 (owner of ProxyAdmin 0x3c405f68d5c6ece868e5646cac926679839acd68) can upgrade the implementation
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/ethena-token-permit-ecdsa-only
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_0.jsonl,out_1.jsonl,out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review10 (source and on-chain review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/ethena-token-permit-ecdsa-only/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: HIGH
related: [ethena-minting-order-sig]
---

## Summary

USDe, sUSDe, USDtb and sENA implement EIP-2612 `permit` with OpenZeppelin `ERC20Permit`, which accepts only an ECDSA signature from the holder address (PQ-1). A quantum attacker who recovers a holder's key from its public key can sign a permit to itself and transfer the holder's tokens, and this keeps working for a holder that moves to post-quantum authorisation at the same address. Post-quantum accounts cannot use `permit` (plain `approve` still works). Upper bound: USDe $4.85B, sUSDe $1.18B, USDtb $318M, sENA $110M market cap (Blockscout, 2026-11-17). Rated HIGH (step 4): USDe and sUSDe are not proxies, so only every holder moving or a protocol change (EIP-8151) protects migrated holders; USDtb and sENA could be fixed by an upgrade.

## Mechanism

- USDe and sUSDe: OZ `ERC20Permit.permit(owner, spender, value, deadline, v, r, s)` computes the EIP-712 digest and requires `ECDSA.recover(hash, v, r, s) == owner`, then `_approve(owner, spender, value)`. No `isValidSignature` path.
- sENA (StakedENA implementation `0x7fd57b46…`) and USDtb (`AnchorageTokenUSDtb` implementation `0x9d6d77a2…`, which inherits it without override): OZ 4.9 `ERC20PermitUpgradeable.permit`, `ECDSAUpgradeable.recover(hash, v, r, s) == owner`, same effect.
- What it releases: an allowance on the holder's whole balance; the spender then calls `transferFrom`.
- Pattern PQ-1. The (v, r, s) interface also rules out a post-quantum signature even if the holder has code.

Source excerpts: [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/ethena-token-permit-ecdsa-only/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify: `USDe.sol`, `StakedUSDeV2.sol`, `StakedENA.sol`, `AnchorageTokenUSDtb.sol` with OZ `ERC20Permit` / `ERC20PermitUpgradeable`): the `permit` path above.
- CHECKED (on-chain, block 26,431,494): USDe and sUSDe have no proxy (code read at block 26,431,214, [`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/ethena-token-permit-ecdsa-only/onchain.json)); sENA EIP-1967 implementation `0x7fd57b46…`, admin ProxyAdmin `0xf849d779…`, whose `owner()` is Safe `0x3b0aaf6e…` with threshold 5 of 10 ([`review.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/ethena-token-permit-ecdsa-only/review.json)). The draft named the timelock `0xe8dc0fab…` as ProxyAdmin owner; that is sENA's own `owner()`, not the proxy admin.
- CHECKED (on-chain, block 26,431,788): USDtb EIP-1967 implementation `0x9d6d77a2…`, admin ProxyAdmin `0x3c405f68…`, whose `owner()` `0xd93826bb…` has no code (an EOA); `totalSupply()` 318.16M.
- CHECKED (Blockscout token API, 2026-11-17): circulating market caps USDe $4,853,105,840, sUSDe $1,181,500,848, USDtb $317,905,055, sENA $109,914,767. USDtb's last transaction 2026-11-16.
- CHECKED (precompile trace, last year, `studies/top-callers-classification/results/curated_contracts.csv` `txs_y1`): USDe 22,708, sUSDe 3,882, sENA 4,542 transactions with an ecrecover call; USDtb 594 (`data/agg/y1_caller.parquet`).
- CHECKED (Xatu, any function, 2026-10-16 to 2026-11-16): see table ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/ethena-token-permit-ecdsa-only/activity.json)); USDtb's 30-day count was not measured.

## Impact and exposure

| Contract | Upgradeable | Value (market cap, upper bound) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x4c9edd58…` USDe | no | $4.85B | 2026-11-16 | 75,657 |
| `0x9d39a5de…` StakedUSDeV2 (sUSDe) | no | $1.18B | 2026-11-16 | 21,822 |
| `0x8be3460a…` sENA → StakedENA | yes | $110M | 2026-11-16 | 6,534 |
| `0xc139190f…` USDtb → AnchorageTokenUSDtb | yes (EOA ProxyAdmin owner) | $318M | 2026-11-16 | not measured |

- The exposure is holders' balances, not the token contracts' own holdings (sUSDe holds $1.18B of USDe as vault assets, sENA holds ENA; both are holders' funds and already counted in the market caps). Only holders whose key is recoverable and who keep balances at an address with a known public key are at risk; the market cap is an upper bound.
- Removed the draft family entry (code `0x7fd57b46…`, 2 instances): its second member, USDtb `0xc139190f…`, runs a different implementation and is now listed as its own contract.
- Sibling mechanism: EthenaMinting's signed orders, [ethena-minting-order-sig](ethena-minting-order-sig.md).

## Remediation

- USDe and sUSDe: the code cannot change. A holder protects itself by moving its balance to a fresh address whose authorisation is post-quantum (a contract account), since the old ECDSA key keeps signing permits for the old address. EIP-8151 would protect holders who give their address real code, without moving. A wrapper token with an ERC-1271-aware permit would only help holders who wrap.
- sENA: Safe `0x3b0aaf6e…` (via ProxyAdmin `0xf849d779…`) can upgrade StakedENA to a permit that checks account code first and passes the full signature to ERC-1271 (current OZ `SignatureChecker`, PQ-13). USDtb: the ProxyAdmin owner EOA `0xd93826bb…` can make the same upgrade; that EOA is itself an ECDSA key that controls the token's code (PQ-12).
- Post-quantum users can use `approve` instead of `permit` today.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review10): MEDIUM -> HIGH, step 4: USDe ($4.85B) and sUSDe ($1.18B) are not upgradeable, so migrated holders stay forgeable unless every holder moves or EIP-8151 ships; only sENA can be upgraded. Corrected sENA's ProxyAdmin owner to Safe 0x3b0aaf6e (5 of 10), updated market caps, removed a family entry that mixed in USDtb, fix.layer contract-upgrade -> account-migration.
- 2026-11-17 review follow-up (Review10): added USDtb `0xc139190f…` (same project and mechanism; upgradeable through an EOA-owned ProxyAdmin; market cap $317.9M). Rating stays HIGH (step 4, decided by USDe and sUSDe).
