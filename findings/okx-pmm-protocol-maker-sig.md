---
id: okx-pmm-protocol-maker-sig
title: "OKX Lab PMMProtocol: RFQ maker orders are checked with ecrecover first, so a quantum attacker who recovers a market maker's key can fill forged orders against everything the maker approved (at least $2.2M for the main maker), even after the maker's address gets post-quantum code"
project: okx
status: confirmed
severity: LOW
patterns: [PQ-2, PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x2bd541ab3b704f7d4c9dff79efadeaa85ec034f1"
  implementation: null
  name: PMMProtocol ("OKX Lab PMM Protocol" 1.0)
  upgradeable: "no"
  admin: none (no proxy, no owner)
  value_usd: 2238335
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-11-10
  txs_30d: 3247
families: []
fix:
  layer: account-migration
  who_acts: "Each market maker (main maker 0x67336cec42645f55059eff241cb02ea5cc52ff86) quotes from a contract account that verifies a post-quantum signature through ERC-1271 and revokes approvals from its ECDSA address; OKX for a 1271-first PMMProtocol deployment"
  protocol_change: helps
evidence:
  level: source-read
  links:
  - evidence/okx-pmm-protocol-maker-sig/classification.jsonl
  - evidence/okx-pmm-protocol-maker-sig/onchain.json
  - evidence/okx-pmm-protocol-maker-sig/activity.json
  - evidence/okx-pmm-protocol-maker-sig/source-excerpts.md
  - evidence/okx-pmm-protocol-maker-sig/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: review (Review12)
  ref: findings review 2026-11-17; Sourcify source, Blockscout logs, cast allowance reads at block 26431692
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: [okx-wallet-link-groth16]
---

## Summary

`PMMProtocol` (EIP-712 name "OKX Lab PMM Protocol") settles RFQ quotes signed by market makers. Unless the filler asks
for the ERC-1271 path, a maker's signature is checked with `ecrecover` first (PQ-2), and the filler chooses the path.
A quantum attacker who recovers a maker's key signs orders at any price and fills them, pulling whatever the maker has
approved: the main maker (`0x67336cec…`, an EIP-7702 EOA) has unlimited approvals to the contract on USDT, USDC, WETH
and cbBTC worth $2.24M (2026-11-17). Adding post-quantum code to the maker's address does not help. A maker that quotes
from a contract account with no ECDSA key is not forgeable, and that path already exists. Rated LOW, step 4: an
existing alternative that each maker (one known party) can switch to.

## Mechanism

- `fillOrderRFQTo(order, signature, flagsAndAmount, target)` (`PmmProtocol.sol` lines 198–251; `fillOrderRFQCompact`
  110–173 the same with `r, vs`): if bit 254 (`_SIGNER_SMART_CONTRACT_HINT`) of the filler-supplied `flagsAndAmount` is
  set, `ECDSA.isValidSignature(maker, hash, signature)` (ERC-1271, full signature); otherwise
  `ECDSA.recoverOrIsValidSignature` (`ECDSA.sol` lines 118–131): `ecrecover` for 64/65-byte signatures, ERC-1271 only
  if that fails.
- `_fillOrderRFQTo` (line 253 ff.) then moves `makerAsset` from the maker to the filler (directly or through Permit2 when
  `order.usePermit2`) and `takerAsset` back, at the signed amounts.
- A forged order with a tiny `takerAmount` drains the maker's approved balance. For a maker address with an ECDSA key,
  the filler simply leaves the hint bit unset. Patterns PQ-2 (ECDSA tried before ERC-1271) and PQ-4 (one market-maker
  key authorises value).

## Evidence

- CHECKED (Sourcify full source, read 2026-11-17): the paths above; no owner, proxy or admin function
  ([`notes.md`](../evidence/okx-pmm-protocol-maker-sig/notes.md), [`source-excerpts.md`](../evidence/okx-pmm-protocol-maker-sig/source-excerpts.md)).
- CHECKED (block 26,431,214): no proxy, holds nothing ([`onchain.json`](../evidence/okx-pmm-protocol-maker-sig/onchain.json)).
- CHECKED (Blockscout logs, latest 50 `OrderFilledRFQ`, blocks 26,381,407–26,386,162): makers `0x67336cec…` (48 fills;
  EIP-7702 EOA) and `0xce79b081…` (2; plain EOA).
- CHECKED (cast at block 26,431,692): `0x67336cec…` has maximum allowance to PMMProtocol (and to Permit2) for USDT, USDC,
  WETH, cbBTC; Blockscout balances of those tokens $1,618,442 + $235,943 + $202,184 + $181,766 = $2,238,335.
  `0xce79b081…` has 0 allowance to PMMProtocol for its two largest holdings.
- CHECKED (Xatu, any function): 3,247 transactions 2026-10-16 to 2026-11-16, last 2026-11-10
  ([`activity.json`](../evidence/okx-pmm-protocol-maker-sig/activity.json)); precompile trace, year to March 2026:
  42,306 transactions calling `ecrecover`, $158.9M moved in them (`curated_contracts.csv`).
- INFERRED: attribution to OKX rests on the EIP-712 domain name in the verified source; the deployer
  (`0xf7745296…`, an EIP-7702 EOA) has no public label. Not confirmed with OKX.

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0x2bd541ab…` PMMProtocol | no | $2.24M (escrow: main maker's approved balances) | 2026-11-10 | 3,247 |

- Escrow: makers' balances approved to PMMProtocol. Measured for the main maker's four largest approved tokens only
  ($2,238,335); its other tokens and other makers were not summed, so this is a lower bound. Permit2 approvals
  (`usePermit2` orders) add to it but were not measured.
- Takers are not exposed through this check: they pay only what they send in their own transaction.

## Remediation

- Makers: quote from a contract account (ERC-1271) that verifies a post-quantum signature, holding the inventory there,
  and revoke the approvals of the ECDSA address. A 7702-delegated EOA is not enough: its ECDSA key still passes
  `ecrecover`.
- OKX: a new PMMProtocol deployment that checks the maker's code first (PQ-13 order) or lets the maker, not the filler,
  fix the scheme; the current contract is immutable.
- Protocol change: helps. EIP-8151 would make `ecrecover` fail for maker addresses with real account code.
- Who acts: each maker (main maker `0x67336cec…`); OKX for a new deployment.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated LOW (step 4: an alternative path exists that one known party can switch to).
- 2026-11-17 review (Review12): LOW -> LOW, step 4: makers can already quote from contract accounts (ERC-1271), which are not forgeable; each maker is one known party. Project identified as OKX from the EIP-712 domain name "OKX Lab PMM Protocol" (id kept). Added PQ-2 (ecrecover tried first; the filler chooses the path); escrow $2.24M measured from the main maker's allowances; fix.layer new-deployment -> account-migration, protocol_change -> helps.
- 2026-11-17 integration: id renamed from `unidentified-2bd541ab-signer-key` (project identified); linked with the other OKX finding, `okx-wallet-link-groth16`.
