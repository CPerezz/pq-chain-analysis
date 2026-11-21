---
id: circle-usdc-permit-code-first
title: "Circle USDC: permit and transfer-with-authorization check account code first and pass full-length signatures to ERC-1271; no exposure beyond each holder's own key"
project: circle
status: not-affected
severity: NONE
patterns: [PQ-13, PQ-18]
primitives: [ecrecover]
trigger: none
impact: none
alternative: alternative-exists
role: auxiliary
contracts:
- address: "0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"
  implementation: "0x43506849d7c04f9138d1a2050bbf3a0c054402dd"
  name: FiatTokenProxy -> FiatTokenV2_2
  upgradeable: "yes"
  admin: "proxy admin 0x807a96288a1a408dbc13de2b1d087d10356395d2 (EOA); owner 0xfcb19e6a322b27c06842a71e8c725399f049ae3a (EOA); read at block 26431457"
  value_usd: 44379756452
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 9852443
families: []
fix:
  layer: none
  who_acts: "nobody needs to act; Circle (proxy admin 0x807a96288a1a408dbc13de2b1d087d10356395d2) could only add protection for code-less addresses, which is a protocol matter (EIP-8151)"
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/circle-usdc-permit-code-first
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review09 (finding review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/circle-usdc-permit-code-first/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: NONE
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, families 0e8d4075"
  date: 2026-11-19
  verdict: reported
  rating: LOW
related: [circle-cctp-attesters, circle-gateway-burn-signer, gatewayminter-2222222d-attestation-key]
---

## Summary

USDC's signed approvals (`permit`) and signed transfers (EIP-3009 `transferWithAuthorization`,
`receiveWithAuthorization`, `cancelAuthorization`) go through Circle's `SignatureChecker`, which asks whether the signer
has code first: accounts with code are checked through ERC-1271 with the full signature bytes, only code-less addresses
use `ecrecover` (PQ-13). A post-quantum smart account (or an EIP-7702 account delegated to post-quantum validation) can
sign USDC authorisations with signatures of any length, and its old ECDSA key is not accepted here. A quantum attacker
can only forge for code-less addresses, which were only ever as safe as their own key. Rated NONE (rubric table: account
code checked first).

## Mechanism

- `FiatTokenV2_2` (implementation `0x43506849…`) exposes `bytes signature` overloads: `permit(owner, spender, value,
  deadline, bytes signature)` (l.95), `transferWithAuthorization(…, bytes signature)` (l.116),
  `receiveWithAuthorization(…, bytes)` (l.149), `cancelAuthorization(…, bytes)` (l.177). The legacy `(v, r, s)`
  overloads pack the three values into 65 bytes and use the same checker (`EIP2612._permit`, l.65).
- `EIP2612._permit` (l.102-107) and `EIP3009._requireValidSignature` (l.281-286) call
  `SignatureChecker.isValidSignatureNow(signer, digest, signature)`.
- `SignatureChecker.isValidSignatureNow` (util/SignatureChecker.sol l.38-47): `if (!isContract(signer))` (extcodesize)
  then `ECRecover.recover(digest, signature) == signer` (65 bytes only); otherwise `isValidERC1271SignatureNow`, which
  staticcalls `isValidSignature(digest, signature)` with the full byte array.
- What it releases: an allowance (`permit`) or a transfer of the signer's own USDC.

Pattern PQ-13. Excerpts: [`source-excerpts.md`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/circle-usdc-permit-code-first/source-excerpts.md).

## Evidence

- CHECKED (Sourcify verified source of `0x43506849…`, read 2026-11-17): `SignatureChecker.sol` and the four
  `bytes`-signature entry points above; ERC-1271 call passes the full signature
  ([`review-reads.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/circle-usdc-permit-code-first/review-reads.json)).
- CHECKED (on-chain at block 26,431,457): implementation slot = `0x43506849…`; proxy admin `0x807a9628…` and owner
  `0xfcb19e6a…` are EOAs; `totalSupply()` = 44,379,756,452 USDC.
- CHECKED (precompile trace to March 2026): `ecrecover` only; 921,052 pre-quantum calls in the year
  (`studies/top-callers-classification/results/curated_contracts.csv`, `txs_y1`).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): 9,852,443 transactions called the token (any function)
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/circle-usdc-permit-code-first/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Value | Last active | 30-day txs |
|---|---|---|---|---|
| `0xa0b86991…` FiatTokenProxy -> FiatTokenV2_2 | yes | $44.38B (mainnet supply, upper bound) | 2026-11-16 | 9,852,443 |

The value is the mainnet `totalSupply` (not the $70.8B cross-chain market cap the draft used): the most that holders'
signatures here could ever move. None of it is exposed beyond each holder's own key: code-less holders lose only what
their own (pre-quantum) key already controls, and holders with account code are checked through ERC-1271. The
contract's own token balance ($0.29M of stray tokens sent to it) is not the exposure.

## Remediation

- Nothing to change in USDC for post-quantum accounts: they use the `bytes` overloads through ERC-1271.
- Holders: move USDC to an account with post-quantum validation (smart account, or EIP-7702 delegation to one); an
  address that keeps no code stays forgeable with its ECDSA key everywhere, not only here.
- Protocol: EIP-8151 would not change anything here, because code-bearing accounts never reach `ecrecover`.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated NONE (code checked first: no exposure beyond the account's own key).
- 2026-11-17 review (Review09): NONE kept. Confirmed in verified source that the ERC-1271 path passes the full-length `bytes` signature (PQ-13, not PQ-3); value changed from the cross-chain market cap ($70.78B) to the mainnet `totalSupply` ($44.38B, block 26,431,457); admin and owner checked as EOAs.
- 2026-11-19 (study `eip-8151-impact`, PQ-18): under EIP-8151 a real transaction fails as sent and passes with more gas: whoever sends it must add gas on activation day. Executed: a real transaction reverts when its signer has code, before any recovery returned nothing.
