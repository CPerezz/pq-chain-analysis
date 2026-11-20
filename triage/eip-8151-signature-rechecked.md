---
id: eip-8151-signature-rechecked
title: "Signatures checked again after others relied on them fail once the signer's account has code under EIP-8151"
status: candidate
severity: CRITICAL
patterns: [PQ-15]
impact: funds-loss
contracts:
- {address: "0x44b12bd193d9f88864dc21e59318e08c565068c8", family: "bc88e65a0213f6ebb0bc38fd73c79d85", copies: 603, upgradeable: "no", rating: CRITICAL, note: "Robonomics liabilities (603); same verdict. Bytecode and names. Update path: proxy to 0x3da3987500da899a06796950f248c124c0f5cb6b: no admin, no upgrade function in the implementation."}
- {address: "0xf471aed099a4ec581335eb52221cc4fbb948ffdb", family: "f36169d3dd2dce63b75983649bd8e530", copies: 9388, name: "Liability", upgradeable: "no", rating: CRITICAL, note: "Robonomics liability demand: the promisee named must have signed / Robonomics liability offer: the promisor named must have signed / Robonomics liability finalize: the result must be signed by the…. Read from source. Update path: delegates to a fixed address."}
- {address: "0xf488f79db9ad86a17eeb694737eade2b08f93eee", family: "cf7404a95d6bfbb3f78ed68718839b89", copies: 4305, name: "BondedECDSAKeep", upgradeable: "no", rating: CRITICAL, note: "Keep ManagedGrant.recoverStake: no signature (matched on a word) / Keep TokenGrant.recoverStake: no signature / Keep TokenGrantStake.recoverStake: no signature / Keep BondedECDSAKeep submitSignature:…. Read from source. Update path: delegates to a fixed address."}
evidence: {level: executed, block: 26438999}
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, signature relied on later"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

These contracts check a signature again after someone else has acted on it: channel states, fraud proofs, settlements, committee results. 3 code families, 14,296 addresses, $0 held, 0 recoveries in the study's two-week window. Rows by rating: CRITICAL 3. 0 rows were checked on a real transaction; the others were read from source, judged from bytecode or placed by measured rules (each row's note says which).

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- Each row's note says how it was decided: read from verified source, judged from bytecode and function names, placed by a rule measured against hand readings, or executed: a real transaction replayed on the fork's reference implementation with only the precompile changed, state at block 26,438,999.
- tBTC v2 WalletRegistry `0x46d52e41c2f300bc82217ce22b920c34995204eb`, validator `0x1a5f4f753bd071c907714aefb6e0bcee32401406` (`tryRecover`, false on mismatch). Executed on the last real DKG result: with one byte of code at operator `0xb71c49e11048bf3d2bc0bab81252334295dee012`, approval `0xdad127784152301e0be04a5d5bd40d676ab85f4a707331f0b82bd2323d9eab28` reverts and a challenge by an outsider succeeds with `DkgMaliciousResultSlashed(400 T, submitter)`. Today `seize` only emits an event.
- CsdUsdcSettlement `0x8863f0c477a30bb5a2077c813f42250d7fbefcb9`: `settleCsdUsdc` L483 `if (_recover(authHash, authSig) != auth.buyer) revert BadSignature();`. Executed: settlement `0x55d7ee240594f01a2339416dc20362814d42e610ad3681f0b24d995ba38690fb` reverts with code at buyer `0xcfc25c23c39525875908865980d7ef905287a98c`; after expiry `refundExpiredLock` pays the buyer, who has the seller's coins (read).
- Lithium `0xcc4c47cf0175aa8108e78679c2586a0a6abb242a`: `LithiumVerification.sol` L57–62 requires both parties' `ECDSA.recover`. Executed (300,000 gas added, because both senders' limits are already too tight under the EIP): updates `0x5c9d200171ba634ec878f8481a311a42b452742aba30ec3de9f48b761fc52e9b` and `0x9278bf51b908461e2d432b6d0bf2550517f0d0cc437eed3feb4190c9dc9026ea` revert with code at the counterparty.

## Impact and exposure

No row holds value at block 26,438,999.

Every row is in the header; `generated/triage_contracts.csv` lists them for search.

## Remediation

New deployments that check once, or accept ERC-1271; until then parties settle before migrating a signing address.

## History

- 2026-11-19: filed from study `eip-8151-impact`, one entry per root issue (D-022). The per-project entries filed earlier that day are in git history (commit `d9c90af`).
- Full write-ups of the executed rows before the merge: [tbtc-dkg-result-signer-code](https://github.com/kevaundray/pq-chain-analysis/blob/d9c90afac8137e134d5e884865dfc37bbcb0d397/triage/tbtc-dkg-result-signer-code.md), [unidentified-8863f0c4-csd-settlement-buyer-code](https://github.com/kevaundray/pq-chain-analysis/blob/d9c90afac8137e134d5e884865dfc37bbcb0d397/triage/unidentified-8863f0c4-csd-settlement-buyer-code.md), [hydranet-lithium-channel-party-code](https://github.com/kevaundray/pq-chain-analysis/blob/d9c90afac8137e134d5e884865dfc37bbcb0d397/triage/hydranet-lithium-channel-party-code.md).
- 2026-11-19: 28 rows added with --add from `verdicts.csv`.
- 2026-11-19: 29 rows added with --add from `verdicts.csv`.
- 2026-11-19: rows rated by how hard the fix is, one row per family and update path (D-024).
