---
id: legion-sale-signer
title: "Legion pre-liquid sale 0x28be6260: a quantum attacker who recovers the Legion signer key could only let unapproved addresses invest their own USDC, and the sale has ended"
project: legion
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: none
alternative: key-rotation-only
role: core
contracts:
- address: "0x28be6260dbb7872de5effc9a4a73c85b7405a8c0"
  implementation: "0x11077eddfc6db5abfdb9e019a64172b5d8e81a3a"
  name: EIP-1167 clone -> LegionPreLiquidSaleV2
  upgradeable: config-only
  admin: not upgradeable; legionBouncer 0x4a7aca57a685c9e893f60a716415e5e588500533 (LegionBouncer) can re-sync legionSigner from the LegionAddressRegistry; projectAdmin acts on capital
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-10-02
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: Legion, for future sales (a sale implementation that verifies a post-quantum Legion signature); nothing to do for this ended sale
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/legion-sale-signer
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

This Legion pre-liquid sale (an EIP-1167 clone of `LegionPreLiquidSaleV2`) admits an investor only with an ECDSA
signature from Legion's signer key `0x18eafffa…4916` over (investor, sale, chain) (PQ-4). A quantum attacker who
recovers that key can let any address invest its own USDC; nothing in the sale is released by the signature (refunds,
excess capital and claims use the investor's own position and Merkle roots set by Legion's bouncer). The sale ended on
2025-10-08 (`hasEnded = true`, which no function resets), so `invest` now reverts. The USD 528k the clone holds is
not reachable through the check. Rated LOW, step 4: the check only admits investors and nothing can be taken through
it.

## Mechanism

- `LegionPreLiquidSaleV2.invest(amount, signature)` (`src/LegionPreLiquidSaleV2.sol` 68–98) first calls
  `_verifyLegionSignature(signature)` (`src/LegionSale.sol` 751–754):
  `keccak256(abi.encodePacked(msg.sender, address(this), block.chainid)).toEthSignedMessageHash().recover(sig)` must
  equal `addressConfig.legionSigner`; then `_verifySaleHasNotEnded()` (line 298: reverts if `hasEnded`), and pulls
  the investor's `bidToken` with `safeTransferFrom`.
- `legionSigner` is copied from the `LegionAddressRegistry` by `_syncLegionAddresses` (lines 536–554), callable by
  the bouncer through `syncLegionAddresses`; a new key would still be ECDSA (`key-rotation-only`).
- Funds leave the sale only through `refund` (own capital, refund period), `withdrawExcessInvestedCapital` and
  `claimTokenAllocation` (Merkle proofs against roots set by `onlyLegion`), `withdrawRaisedCapital` (`onlyProject`),
  and `emergencyWithdraw` (`onlyLegion`). None uses the signer signature.
- Pattern PQ-4, with only an admission gate behind it. The clone's own source excerpt is empty because the code sits
  at the EIP-1167 target `0x11077edd…1a3a`, verified on Sourcify.

## Evidence

- CHECKED (verified source, Sourcify, implementation `0x11077edd…1a3a`): the functions and lines above.
- CHECKED (`cast code`): `0x28be6260…` is an EIP-1167 minimal proxy to `0x11077edd…1a3a`.
- CHECKED (creation tx `0xd1867eeb…77d0`, `LegionAddressesSynced` log): bouncer `0x4a7aca57…0533` (LegionBouncer,
  verified contract), signer `0x18eafffa…4916` (EOA, no code, nonce 0; its signatures are in every `invest` call).
- CHECKED (on-chain read at block 26,431,536): `preLiquidSaleConfiguration()` `hasEnded` = true; `saleConfiguration()`
  end 2025-10-08, refund end 2025-10-22; `saleStatusDetails()` 5,222,545 USDC invested, accepted-capital Merkle root
  set, capital raised not yet published, tokens not supplied ([`sale.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/legion-sale-signer/sale.json)).
- CHECKED (block 26,431,597): USDC `balanceOf(0x28be6260…)` = 527,696.80.
- CHECKED (precompile trace): 64,450 transactions with `ecrecover`, 2025-09-29 to 2025-11-09 (the later ones are
  `invest` calls that recover the signer before reverting on `hasEnded`) [INFERRED for the reason].
- CHECKED (Xatu, any function): no transactions 2026-10-16 to 2026-11-16; last 2026-10-02
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/legion-sale-signer/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Exposed through the check | Last active | 30-day txs |
|---|---|---|---|---|
| `0x28be6260…` LegionPreLiquidSaleV2 clone | no (signer re-syncable) | none (holds USD 528k USDC, not reachable) | 2026-10-02 | 0 |

- The draft's `held` value (USD 527,497) is removed: it is investors' capital awaiting settlement, which the signer
  signature cannot release.
- With the sale open, a forged signature would only have bypassed Legion's investor allowlist (a compliance control),
  with the attacker paying in its own USDC.
- Wider (not rated here): `onlyLegion` functions, including `emergencyWithdraw`, are gated by `msg.sender` =
  LegionBouncer, whose own controllers are presumably ECDSA accounts; that is an account-key exposure, not this check.
- Other Legion sales sharing the same signer are not in this registry; any still open have the same admission-only
  exposure.

## Remediation

- Post-quantum replacement: verify Legion's admission signature through an ERC-7913 verifier (or an ERC-1271 signer
  contract with a post-quantum key) in future sale implementations; or admit investors on-chain (an allowlist set by
  the bouncer).
- Who must act: Legion, for new sales. This sale needs no action. No protocol change needed.
- Users: nothing.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review05): MEDIUM -> LOW, step 4: in the verified implementation the Legion signature only gates
  `invest` (the investor pays in); no path releases funds on it, and the sale ended 2025-10-08. `impact` funds-loss ->
  none; removed the USD 527k `held` value (not reachable through the check).

# Source excerpts: legion-sale-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x28be6260dbb7872de5effc9a4a73c85b7405a8c0`

No verified source on Sourcify or Blockscout.
