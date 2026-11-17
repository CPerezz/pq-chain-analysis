---
id: memeland-meme-permit
title: "Memeland MEME token: permit is ECDSA-only, but it can only approve the MemecoinDelegate, so a forged holder permit takes nothing unless the owner Safes are forged too; the owner Safe can close the path with one setting"
project: memeland
status: confirmed
severity: LOW
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: auxiliary
contracts:
- address: "0xb131f4a55907b10d1f0a50d8ab8fa09ec342cd74"
  implementation: null
  name: Memecoin
  upgradeable: config-only
  admin: owner() = Safe 0x06b1ba8c14d3dd9486012d2bc962a5a58ec6eaa7 (2 of 3), sets tokenPool via setTokenPool (read at block 26431523)
  value_usd: 28055215
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 8925
families: []
fix:
  layer: onchain-config
  who_acts: Memecoin owner Safe 0x06b1ba8c14d3dd9486012d2bc962a5a58ec6eaa7 (setTokenPool to an inert address, then renounceOwnership); otherwise the owners of Safes 0x06b1ba8c… and 0x873bcbc7… move to post-quantum signers
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/memeland-meme-permit/classification.jsonl
  - evidence/memeland-meme-permit/onchain.json
  - evidence/memeland-meme-permit/activity.json
  - evidence/memeland-meme-permit/source-excerpts.md
  - evidence/memeland-meme-permit/review-reads.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review22)
  ref: evidence/memeland-meme-permit/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

MEME's `permit` accepts holder signatures only through `ecrecover`, so a quantum attacker can forge a permit for any
holder whose key has signed, including holders who later move to post-quantum accounts. But `permit` reverts unless the
spender is `tokenPool`, which is set to `MemecoinDelegate` `0x32c1f663…`. That delegate only moves tokens for two fixed
Memeland contracts, and both pull only from their own caller. So a forged permit takes nothing unless the attacker also
forges 2 of 3 owners of the Memecoin owner Safe (to repoint `tokenPool`) or of the delegate's owner Safe (to authorise
itself). Holders' balances, at most the $28.1M market cap, are exposed only through that combination. Rated LOW (step 4:
one known party, the owner Safe, can close the path with one setting).

## Mechanism

- `Memecoin.permit` (`Memecoin.sol` lines 25-32) reverts with `Unauthorized()` if `spender != tokenPool`, then calls
  OpenZeppelin `ERC20Permit.permit`: `ECDSA.recover(hash, v, r, s) == owner`, with no ERC-1271 path
  (`ERC20Permit.sol` lines 49-68). PQ-1.
- `setTokenPool(address)` is `onlyOwner`. `owner()` is Safe `0x06b1ba8c…` (2 of 3). The contract has no proxy.
- `tokenPool` = `MemecoinDelegate` `0x32c1f663…` (verified). `transferFrom(from, to, amount)` is `onlyAuthorized`
  (0x `AuthorizableV08`). The authorised addresses are `MemecoinStaking` proxy `0xc059a531…`, whose upgrader is
  0x0 so it can no longer be upgraded, and `MemecoinMultiClaim` `0x71a41517…` (immutable). Both call
  `_delegatePermit` and `_delegateTransfer` with `_msgSender()` as owner and `from`
  (`MemecoinDelegatable(Upgradeable).sol`), so they never pull from anyone but their caller. The delegate's owner, which
  can add authorised addresses, is Safe `0x873bcbc7…` (2 of 3).
- Attack paths for a CRQC holder against a holder who has migrated: (a) forge 2 of 3 owners of `0x06b1ba8c…`, call
  `setTokenPool(attacker)`, forge the holder's permit, then `transferFrom`; or (b) forge 2 of 3 owners of `0x873bcbc7…`,
  `addAuthorizedAddress(attacker)`, forge a permit to the delegate, then call `delegate.transferFrom(holder, attacker)`.
  Without (a) or (b), a forged permit only gives the delegate an allowance that nobody can use against the holder.

## Evidence

- CHECKED (verified source: Sourcify for Memecoin; Blockscout for MemecoinDelegate `0x32c1f663…`, MemecoinStaking
  implementation `0x319e9a7a…`, MemecoinMultiClaim `0x71a41517…`): the code paths above.
- CHECKED (RPC at block 26,431,523; [`review-reads.json`](../evidence/memeland-meme-permit/review-reads.json)):
  `owner()` = Safe `0x06b1ba8c…`, threshold 2, owners `0xa473496d…`, `0x34ce7b36…`, `0x9470e8d5…`; `tokenPool()` =
  `0x32c1f663…`; delegate `owner()` = Safe `0x873bcbc7…` (2 of 3); `getAuthorizedAddresses()` = [`0xc059a531…`,
  `0x71a41517…`]; staking `upgrader()` = 0x0, implementation `0x319e9a7a…`, `owner()` = Safe `0x549f4b7a…`.
- CHECKED (Blockscout `circulating_market_cap`, 2026-11-17): $28.1M. This is an upper bound on what the forged-permit
  path could reach, and only in combination with a forged Safe.
- CHECKED (Xatu, any function): 8,925 transactions in 2026-10-16 to 2026-11-16 (token transfers included). There were
  32,724 pre-quantum calls in the year to March 2026 (`curated_contracts.csv` `txs_y1`).
- INFERRED: Safe owners `0x06b1ba8c…` and `0x873bcbc7…` are ECDSA keys that have signed, so they are recoverable (PQ-12
  on those Safes, outside this finding).

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0xb131f4a5…` Memecoin | config-only (`tokenPool`) | $28.1M (market cap, upper bound) | 2026-11-16 | 8,925 |

The contract's own balance ($2.1k of stray tokens) is not the exposure. The exposure is holders' MEME, reachable only
through a forged permit combined with a forged owner Safe (paths a and b). Post-quantum holders lose only the permit
convenience; `approve` works for them.

## Remediation

- One setting closes the path: the Memecoin owner Safe `0x06b1ba8c…` calls `setTokenPool` with an address nobody
  controls, then `renounceOwnership()`. After that, a forged permit can only approve that dead address. Staking and
  claim flows would then need a separate `approve` instead of a permit.
- Otherwise, the owners of Safes `0x06b1ba8c…` and `0x873bcbc7…` move to post-quantum signers (Safe supports contract
  owners), which removes paths (a) and (b).
- Holders: use `approve` rather than `permit`. Moving funds to a fresh post-quantum account removes the residual
  exposure. Protocol change: helps (EIP-8151 would make `ecrecover` fail for holders whose address has post-quantum
  code).

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review22): HIGH -> LOW, step 4: `permit` only approves `tokenPool` (MemecoinDelegate), whose two authorised contracts pull only from their caller, so a forged permit alone takes nothing; the owner Safe 0x06b1ba8c (one known party) can make the path inert with `setTokenPool` plus `renounceOwnership`. `upgradeable` corrected to config-only; `alternative` to alternative-exists (`approve`); `fix.layer` to onchain-config.
