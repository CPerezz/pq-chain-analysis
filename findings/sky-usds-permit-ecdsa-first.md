---
id: sky-usds-permit-ecdsa-first
title: "USDS and sUSDS (Sky): permit tries ecrecover before ERC-1271, so a quantum attacker with a holder's old ECDSA key can sign permits for an address that has migrated to post-quantum authorisation; fixable by a governance upgrade"
project: sky
status: confirmed
severity: MEDIUM
patterns: [PQ-2]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: auxiliary
contracts:
- address: "0xdc035d45d973e3ec169d2276ddab16f1e407384f"
  implementation: "0x1923dfee706a8e78157416c29cbccfde7cdf4102"
  name: ERC1967Proxy -> Usds
  upgradeable: "yes"
  admin: "UUPS, _authorizeUpgrade gated by wards: Sky pause proxy 0xbe8e3e3618f7474f8cb1d074a26affef007e98fb (governance, Chief 0x929d9a1435662357f54adcf64dcee4d6b867a6f9, 48 h delay) and UsdsJoin 0x3c0f895007ca717aa01c8693e59df1e8c3777feb"
  value_usd: 5234715755
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 132728
- address: "0xa3931d71877c0e7a3148cb7eb4463524fec27fbd"
  implementation: "0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0"
  name: ERC1967Proxy -> SUsds
  upgradeable: "yes"
  admin: "UUPS, _authorizeUpgrade gated by wards: Sky pause proxy 0xbe8e3e3618f7474f8cb1d074a26affef007e98fb (governance) and SPBEAM 0x36b072ed8afe665e3aa6daba79decbec63752b22"
  value_usd: 3687043328
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 28038
families: []
fix:
  layer: contract-upgrade
  who_acts: "Sky governance: an executive spell voted in the Chief 0x929d9a1435662357f54adcf64dcee4d6b867a6f9, executed through DSPause 0xbe286431454714f511008713973d3b053a2d38f3 (48 h delay) and pause proxy 0xbe8e3e3618f7474f8cb1d074a26affef007e98fb, upgrades both implementations"
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/sky-usds-permit-ecdsa-first/classification.jsonl
  - evidence/sky-usds-permit-ecdsa-first/onchain.json
  - evidence/sky-usds-permit-ecdsa-first/activity.json
  - evidence/sky-usds-permit-ecdsa-first/source-excerpts.md
  - evidence/sky-usds-permit-ecdsa-first/governance.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl,out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review15 (finding review)
  ref: findings/sky-usds-permit-ecdsa-first.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [sky-dai-permit-ecdsa-only]
---

## Summary

USDS and sUSDS `permit` accept ERC-1271 signatures, so post-quantum smart accounts can use them, but for a 65-byte
signature they try `ecrecover` first and accept it if it matches the owner (PQ-2). An address that migrates to
post-quantum authorisation in place (EIP-7702/8141) stays forgeable here: a quantum attacker who recovers its old
secp256k1 key signs a permit and drains its USDS or sUSDS. Exposure is holders' balances, at most the supplies of
USDS (USD 5.23B) and sUSDS (USD 3.69B), which overlap (see below). Rated MEDIUM (step 4: Sky governance can fix both by
upgrading the UUPS implementations).

## Mechanism

`permit(owner, spender, value, deadline, bytes signature)` (`Usds.sol` 220–251, `SUsds.sol` 439–470; the
`(v, r, s)` overload packs and forwards) calls `_isValidSignature(owner, digest, signature)` (`Usds.sol` 191–218,
`SUsds.sol` 410–437): if `signature.length == 65` and `owner == ecrecover(digest, v, r, s)` it returns true; only
otherwise, if `owner.code.length > 0`, it calls `IERC1271.isValidSignature(digest, signature)` with the full bytes. A
valid permit sets `allowance[owner][spender] = value`, after which the spender can `transferFrom` the owner's balance.
Pattern PQ-2: the ERC-1271 path is full-length (post-quantum accounts are not locked out), but the ECDSA branch comes
first, so an EIP-7702/8141 account with code is still accepted with its old key. Excerpt:
[`source-excerpts.md`](../evidence/sky-usds-permit-ecdsa-first/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify, implementations `0x1923…4102` and `0x4e79…61e0`): `_isValidSignature` order as
  above; `_authorizeUpgrade(address) internal override auth {}` at `Usds.sol` line 73 and `SUsds.sol` line 132.
- CHECKED (block 26,431,426): EIP-1967 implementation slots hold `0x1923dfee…` and `0x4e7991e5…`; EIP-1967 admin slots
  are zero (UUPS). `wards(pause proxy) = 1` on both; `Rely`/`Deny` logs (Blockscout) leave wards USDS = {pause proxy,
  UsdsJoin `0x3c0f…7feb`} and sUSDS = {pause proxy, SPBEAM `0x36b0…2b22`} (the deployers' wards were denied at blocks
  20,663,732 and 20,677,436). Pause proxy `owner()` = DSPause `0xbe28…38f3`, whose `authority()` = Chief
  `0x929d…a6f9` and `delay()` = 172,800 s ([`governance.md`](../evidence/sky-usds-permit-ecdsa-first/governance.md)).
- CHECKED (`totalSupply()` at block 26,431,426): 5,234,715,755 USDS; sUSDS `totalAssets()` = 3,687,043,328 USDS.
- CHECKED (precompile trace to March 2026): `ecrecover` only; in the last year 8,048 pre-quantum calls through USDS
  (USD 4.80B transferred in those transactions) and 788 through sUSDS (USD 112M) (`curated_contracts.csv`).
- CHECKED (Xatu, any function, 2026-10-16 to 2026-11-16): 132,728 transactions called USDS and 28,038 called sUSDS;
  both last active 2026-11-16 ([`activity.json`](../evidence/sky-usds-permit-ecdsa-first/activity.json)).
- INFERRED: UsdsJoin and SPBEAM are fixed-code contracts with no call path to `upgradeToAndCall`, so in practice only
  governance can upgrade (not checked in their source).

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0xdc035d45…` USDS | yes (governance) | USD 5.23B (supply, upper bound) | 2026-11-16 | 132,728 |
| `0xa3931d71…` sUSDS | yes (governance) | USD 3.69B (`totalAssets`, upper bound) | 2026-11-16 | 28,038 |

The two figures overlap: 3.69B of the USDS supply is held by the sUSDS contract itself (`onchain.json`), which has
code, no ECDSA key and no ERC-1271, so it cannot be permitted away; holders' exposure across both tokens is about
USD 5.24B. Only holders who migrate an address in place and keep tokens there are exposed beyond their own key. The
contracts' own token holdings (USD 48 in USDS) are not the exposure. DAI, the predecessor, is immutable and covered by
[`sky-dai-permit-ecdsa-only`](sky-dai-permit-ecdsa-only.md).

## Remediation

- Sky governance upgrades both implementations so `_isValidSignature` checks `owner.code.length > 0` first and then
  uses only ERC-1271 with the full signature (PQ-13 order, as in current OpenZeppelin `SignatureChecker`). This needs
  an executive spell (Chief vote, 48 h DSPause delay); no protocol change.
- Protocol change helps: EIP-8151 would make the `ecrecover` branch fail for migrated addresses without the upgrade.
- Holders who migrate before the fix: move USDS/sUSDS to a fresh post-quantum account.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by upgrading the contract (admin or governance)).
- 2026-11-17 review (Review15): MEDIUM confirmed (step 4). Market caps replaced by on-chain `totalSupply`/`totalAssets` at block 26,431,426 (USDS 9.57B -> 5.23B, sUSDS 4.51B -> 3.69B); wards and governance chain read from storage and logs; linked to the DAI finding.
