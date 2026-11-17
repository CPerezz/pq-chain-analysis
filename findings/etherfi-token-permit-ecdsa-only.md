---
id: etherfi-token-permit-ecdsa-only
title: "ether.fi weETH, eETH and Liquid ETH: a forged ECDSA permit lets a quantum attacker approve and take any exposed holder's tokens, even after the holder migrates; post-quantum accounts cannot permit"
project: etherfi
status: confirmed
severity: MEDIUM
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: sole
role: auxiliary
contracts:
- address: "0xcd5fe23c85820f7b72d0926fc9b05b43e359b7ee"
  implementation: "0xa6ca0607190d03cf16fe6f2865cf40c3d160ccf3"
  name: UUPSProxy → WeETH
  upgradeable: "yes"
  admin: EtherFiTimelock 0x9f26d4c958fd811a1f59b01b86be7dffc9d20761 (UPGRADE_TIMELOCK_ROLE in RoleRegistry 0x62247d29b4b9becf4bb73e0c722cf6445cfc7ce9; 10-day delay)
  value_usd: 5103835614
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 15635
- address: "0xf0bb20865277abd641a307ece5ee04e79073416c"
  implementation: null
  name: BoringVault (ether.fi Liquid ETH, LIQUIDETH)
  upgradeable: config-only
  admin: code immutable; RolesAuthority 0x485bde66bb668a51f2372e34e45b1c6226798122 (owner timelock 0xd829f278016b90fec735f9a12bf8b75e06102c89, 1-day delay) can set the beforeTransfer hook
  value_usd: 318697644
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 1587
- address: "0x35fa164735182de50811e8e2e824cfb9b6118ac2"
  implementation: "0xd1901dd36cbf4a81386d0162df2707f7ddb60527"
  name: UUPSProxy → EETH
  upgradeable: "yes"
  admin: EtherFiTimelock 0x9f26d4c958fd811a1f59b01b86be7dffc9d20761 (UPGRADE_TIMELOCK_ROLE in RoleRegistry 0x62247d29b4b9becf4bb73e0c722cf6445cfc7ce9; 10-day delay)
  value_usd: 181644103
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 10910
families: []
fix:
  layer: contract-upgrade
  who_acts: "ether.fi: EtherFiTimelock 0x9f26d4c958fd811a1f59b01b86be7dffc9d20761 upgrades weETH and eETH; for Liquid ETH (immutable BoringVault) the RolesAuthority 0x485bde66bb668a51f2372e34e45b1c6226798122 owner (timelock 0xd829f278016b90fec735f9a12bf8b75e06102c89) can only restrict transferFrom through the beforeTransfer hook, or holders move to a new vault"
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/etherfi-token-permit-ecdsa-only/classification.jsonl
  - evidence/etherfi-token-permit-ecdsa-only/onchain.json
  - evidence/etherfi-token-permit-ecdsa-only/activity.json
  - evidence/etherfi-token-permit-ecdsa-only/source-excerpts.md
  - evidence/etherfi-token-permit-ecdsa-only/admin.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review14 (verified source and upgrade-authority reads)
  ref: evidence/etherfi-token-permit-ecdsa-only/admin.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: []
---

## Summary

weETH, eETH and the Liquid ETH vault share accept EIP-2612 `permit` only through `ecrecover`. A quantum attacker who
recovers a holder's secp256k1 key from any past signature can sign a permit to themselves and `transferFrom` the
holder's balance, and this keeps working after the holder moves the address to post-quantum authorisation; accounts
that only have a post-quantum signer cannot use `permit` at all. Holders' balances (market caps: weETH USD 5.10B,
Liquid ETH USD 318.7M, eETH USD 181.6M, upper bounds) are what is exposed. weETH and eETH can be upgraded by
ether.fi's 10-day timelock; rated MEDIUM (step 4: contract upgrade).

## Mechanism

- `EETH.permit(owner, spender, value, deadline, v, r, s)` (implementation `0xd190…0527`, line 261):
  `signer = ECDSAUpgradeable.recover(hash, v, r, s); if (signer != owner) revert InvalidSignature(); _approve(owner,
  spender, value)` (lines 276–279). No ERC-1271 path.
- `WeETH` (`0xa6ca…ccf3`) inherits OpenZeppelin `ERC20PermitUpgradeable.permit`: `ECDSAUpgradeable.recover(hash, v,
  r, s)` (excerpt line 71).
- `BoringVault` (`0xf0bb…416c`) inherits Solmate `ERC20.permit`: raw `ecrecover` on the EIP-712 digest (lines 116–134).
  Every transfer and `transferFrom` calls `hook.beforeTransfer(from, to, msg.sender)` (line 121); `hook` is set with
  `setBeforeTransferHook` (`requiresAuth`, line 113) and is currently the LayerZeroTellerWithRateLimiting `0x9aa7…4734`.
- The released value is the allowance: the attacker then calls `transferFrom(owner, attacker, balance)`. Pattern PQ-1.

## Evidence

- CHECKED (Sourcify verified source, read 2026-11-17): the three `permit` functions above; `_authorizeUpgrade(...)
  onlyUpgradeTimelock` in EETH (line 444) and WeETH (line 241)
  ([`source-excerpts.md`](../evidence/etherfi-token-permit-ecdsa-only/source-excerpts.md)).
- CHECKED (cast via eth.drpc.org at block 26,431,595): EIP-1967 implementations of eETH and weETH; `roleRegistry()` =
  `0x6224…7ce9`, whose `roleHolders(UPGRADE_TIMELOCK_ROLE)` = EtherFiTimelock `0x9f26…0761`, `getMinDelay()` = 864000 s;
  BoringVault `owner()` = 0, `authority()` = `0x485b…8122` (owner `0xd829…2c89`, `getMinDelay()` = 86400), `hook()` =
  `0x9aa7…4734` ([`admin.json`](../evidence/etherfi-token-permit-ecdsa-only/admin.json)).
- CHECKED (precompile trace, trace year): `ecrecover` transactions eETH 15,732, BoringVault 1,048, weETH 458
  (`data/agg/y1_caller.parquet`).
- CHECKED (Xatu, any function, 2026-10-16 to 2026-11-16): transactions in the table
  ([`activity.json`](../evidence/etherfi-token-permit-ecdsa-only/activity.json)).
- CHECKED (`data/report/permit_tokens_market_cap.csv`): market caps used below.

## Impact and exposure

| Contract | Upgradeable | Exposed (market cap, upper bound) | Last active | 30-day txs |
|---|---|---|---|---|
| `0xcd5fe23c…` weETH | yes (EtherFiTimelock, 10 days) | USD 5.10B | 2026-11-16 | 15,635 |
| `0xf0bb2086…` Liquid ETH BoringVault | code no; transfer hook configurable | USD 318.7M | 2026-11-16 | 1,587 |
| `0x35fa1647…` eETH | yes (EtherFiTimelock, 10 days) | USD 181.6M | 2026-11-16 | 10,910 |

Only holders whose key is exposed (has signed on-chain) and who still hold the token are at risk; the market cap is the
upper bound. The contracts' own balances (weETH USD 13.6k, eETH USD 7.8k, BoringVault USD 7.9M on 2026-11-17) are not
the exposure.

## Remediation

- weETH and eETH: upgrade `permit` to check account code first and verify contract signers through ERC-1271 with the
  full signature (PQ-13 pattern, e.g. OpenZeppelin `SignatureChecker`), through EtherFiTimelock `0x9f26…0761` (10-day
  delay).
- Liquid ETH: the BoringVault code cannot change. The RolesAuthority owner can install a `beforeTransfer` hook that
  rejects `transferFrom` by third-party operators, which stops theft through forged permits but also breaks normal
  approvals; otherwise holders must move to a new vault.
- EIP-8151 would make `ecrecover` fail for addresses with code, protecting migrated holders without the team.
- Holders can move balances to a fresh post-quantum account, which no old key controls.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review14): MEDIUM kept, step 4 (EtherFiTimelock upgrade for weETH/eETH; BoringVault mitigable through its transfer hook). Upgrade authority read from RoleRegistry; BoringVault `upgradeable` set to config-only.
