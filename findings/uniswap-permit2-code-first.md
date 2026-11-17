---
id: uniswap-permit2-code-first
title: "Uniswap Permit2 (canonical and one copy): signatures from accounts with code go to ERC-1271 with the full signature; no exposure beyond each account's own key"
project: uniswap
status: not-affected
severity: NONE
patterns: [PQ-13]
primitives: [ecrecover]
trigger: none
impact: none
alternative: alternative-exists
role: core
contracts:
- address: "0x000000000022d473030f116ddee9f6b43ac78ba3"
  implementation: null
  name: Permit2
  upgradeable: "no"
  admin: none (not a proxy, no owner)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 1019660
- address: "0x31c2f6fcff4f8759b3bd5bf0e1084a055615c768"
  implementation: null
  name: Permit2 (non-canonical copy)
  upgradeable: "no"
  admin: none (not a proxy, no owner)
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-16
  txs_30d: 2228
families: []
fix:
  layer: none
  who_acts: none needed; users who migrate move to accounts with code (smart account or EIP-7702)
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/uniswap-permit2-code-first
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review07 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/uniswap-permit2-code-first/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: NONE
related: [uniswapx-cosigner]
---

## Summary

Permit2 checks whether the signer has code before anything else: accounts with code are verified through ERC-1271
with the full signature bytes, and only code-less addresses go to `ecrecover` (PQ-13). A post-quantum smart account,
or an EOA that delegates with EIP-7702, is not forgeable here with its old ECDSA key, and a code-less address was only
ever as safe as its own key. The canonical Permit2 and a second deployment of Permit2's code at `0x31c2f6fc…` (same
`SignatureVerification` library) behave the same. Rated NONE: no exposure beyond each account's own key.

## Mechanism

Every signature path (`AllowanceTransfer.permit`, `SignatureTransfer.permitTransferFrom`,
`permitWitnessTransferFrom`) calls `SignatureVerification.verify(signature, hash, claimedSigner)` (lines 21–46): if
`claimedSigner.code.length == 0` it accepts a 65- or 64-byte (EIP-2098) ECDSA signature through `ecrecover`, else it
calls `IERC1271(claimedSigner).isValidSignature(hash, signature)` with the whole signature. Pattern PQ-13. Lines:
[`notes.md`](#review-reads-uniswap-permit2-code-first-2026-11-17-review07).

## Evidence

- CHECKED (verified source, Sourcify, both addresses): the code check precedes `ecrecover`; ERC-1271 receives the full
  `bytes signature`.
- CHECKED (on-chain read at block 26,431,214): neither address is a proxy; no owner or admin.
- CHECKED (precompile trace to March 2026): 3,840,821 (canonical) and 41,477 (copy) transactions with `ecrecover` in
  the last year; Xatu: 1,019,660 and 2,228 transactions in 2026-10-16 to 2026-11-16.
- CHECKED (Blockscout): the copy was deployed on 2023-09-27 through the CREATE2 factory by `0xa4c00287…114d`, an
  unidentified deployer.

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x00000000…` Permit2 | no | none beyond account keys | 2026-11-16 | 1,019,660 |
| `0x31c2f6fc…` Permit2 (copy) | no | none beyond account keys | 2026-11-16 | 2,228 |

What Permit2 can move is users' approvals to it, not its own balance ($133k of stray USDC at block 26,431,214, which
the draft listed as held and which is removed here). Those approvals are forgeable only through a code-less owner's
own key.

## Remediation

- None needed in Permit2. Users protect approvals by moving to an account with code (smart account with a
  post-quantum signer, or EIP-7702 delegation to one); an address that stays code-less remains as exposed as its key.
- EIP-8151 is not needed for Permit2 itself (it already prefers code); it matters for contracts that call
  `ecrecover` without a code check.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated NONE (code checked first: no exposure beyond the account's own key).
- 2026-11-17 review (Review07): NONE unchanged. Both sources read; held $133k removed from `value_usd` (Permit2's own
  stray balance, not an exposure); related UniswapX finding linked.

# Review reads: uniswap-permit2-code-first (2026-11-17, Review07)

## Source (Sourcify, both addresses)

`SignatureVerification.verify(signature, hash, claimedSigner)` (lines 21–46, identical in
`0x000000000022d473030f116ddee9f6b43ac78ba3` `src/libraries/SignatureVerification.sol` and
`0x31c2f6fcff4f8759b3bd5bf0e1084a055615c768` `contracts/libraries/SignatureVerification.sol`, solc 0.8.17):

```solidity
   26          if (claimedSigner.code.length == 0) {
   27              if (signature.length == 65) { ... } else if (signature.length == 64) { ... EIP-2098 ... }
   39              address signer = ecrecover(hash, v, r, s);
   41              if (signer != claimedSigner) revert InvalidSigner();
   42          } else {
   43              bytes4 magicValue = IERC1271(claimedSigner).isValidSignature(hash, signature);
   44              if (magicValue != IERC1271.isValidSignature.selector) revert InvalidContractSignature();
```

The ERC-1271 branch forwards the full `bytes signature`, so post-quantum smart accounts (and EIP-7702 accounts,
which have code) are verified by their own code; `ecrecover` is reached only for addresses without code.

## On-chain and explorer reads

- `onchain.json` (block 26,431,214): both contracts are not proxies (code 9,152 and 7,020 bytes), no owner.
- Blockscout: both deployed through the CREATE2 factory `0x4e59b448…956c`; canonical by
  tx `0xf2f1fe96…d377`; `0x31c2f6fc…` on 2023-09-27 by `0xa4c0028748d8f534e6d7bab20d9b696f750f114d` (deployer not
  identified; Uniswap's code, not Uniswap's canonical address).
- Yearly pre-quantum use (`data/report/curated_contracts.csv`): canonical 3,840,821 `ecrecover` transactions;
  `0x31c2f6fc…` 41,477.
