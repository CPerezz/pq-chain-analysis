---
id: galxe-signer
title: "Galxe: a quantum attacker who recovers Galxe's backend ECDSA signer can activate fake earndrops and drain VestingEarndrop's pooled tokens, and forge deposit authorisations; the contracts hold about $0 today"
project: galxe
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0xd86193d0aefb386a4f8a6f1d024592f851c579f9"
  implementation: null
  name: VestingEarndrop
  upgradeable: config-only
  admin: "owner 0x62e3bab5d52ae8551468e3dca23375629eab86e4 (EOA, Ownable2Step) can setSigner/setTreasurer; signer 0xaa64fa67856f2c89d6456595bc21418237f78024 (read at block 26431457)"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-10-09
  txs_30d: 0
- address: "0x5f17bf773aba7f0f877db4ac82861c198891d1f9"
  implementation: null
  name: GeneralInstantPaymentLSDTreasurer
  upgradeable: config-only
  admin: "owner 0x78a6c322fe2b4a8ae7124702d92d3bf954e75e94 (EOA, Ownable2Step) can setSigner and set treasurers; signer 0x111ae6fe1ad173def8dc36e9dff5144c713f2880 (read at block 26431457)"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-07-06
  txs_30d: 0
- address: "0x07c78007ddcffa630fd908a815165e5b0af0c4f2"
  implementation: null
  name: GeneralInstantPaymentLSD
  upgradeable: config-only
  admin: "owner Safe 0x73eb342ebc92a4b77942b6cab927ad5faed595be (3 of 5) can setSigner/setTreasurer; signer 0x111ae6fe1ad173def8dc36e9dff5144c713f2880 (read at block 26431457)"
  value_usd: 0
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2025-12-03
  txs_30d: 0
families: []
fix:
  layer: new-deployment
  who_acts: "Galxe: redeploy with a post-quantum signer check (owners 0x62e3bab5d52ae8551468e3dca23375629eab86e4, 0x78a6c322fe2b4a8ae7124702d92d3bf954e75e94, Safe 0x73eb342ebc92a4b77942b6cab927ad5faed595be can only rotate the ECDSA signer)"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/galxe-signer/classification.jsonl
  - evidence/galxe-signer/onchain.json
  - evidence/galxe-signer/activity.json
  - evidence/galxe-signer/source-excerpts.md
  - evidence/galxe-signer/review-reads.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl,out_4.jsonl,out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review09 (finding review)
  ref: evidence/galxe-signer/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: LOW
related: []
---

## Summary

Three Galxe contracts accept actions only with a signature from Galxe's backend key (`signer`, one ECDSA key, PQ-4).
In VestingEarndrop the key authorises creating an earndrop and every claim paid from the contract's pooled token
balance, so a quantum attacker holding the key can authorise claims against that pool. In the two
GeneralInstantPayment contracts the key authorises deposits that the caller pays for, so forging it moves no one
else's funds. All three hold about $0 now, and none was called in the last
30 days. Rated LOW: a redeploy by Galxe would be MEDIUM (step 4), lowered by step 5 (measured exposure about $0).

## Mechanism

- VestingEarndrop: `activateEarndrop` (l.107-176) needs `signer`'s EIP-712 signature over the earndrop parameters and
  `msg.sender`, then pulls `totalAmount` from the creator; `claimEarndrop` (l.214-256) and `multiClaimEarndrop`
  (l.258-309) need `signer`'s signature plus a Merkle proof against the earndrop's root, and pay out of the contract's
  pooled balance of that token.
  `_verifySignature`: `ECDSA.recover(_hash, _signature) == signer` (l.383-385).
- GeneralInstantPaymentLSD: `deposit` / `swapDeposit` / `crossChainSwapDeposit` (l.188-309) check `_verify`
  (`ECDSA.recover(...) == signer`, l.580-582) over the deposit parameters, then pull the deposit from `msg.sender` and
  forward it to the saving contracts; `withdrawToken` (l.311) is treasurer-only, no signature.
- GeneralInstantPaymentLSDTreasurer: same deposit pattern (`deposit` l.208-238, `_verify` l.613-615); `_batchTransfer`
  (l.593-603) pays treasurers from `msg.sender` or from the ETH sent with the call.
- `setSigner` (`onlyOwner`) on each contract only rotates the ECDSA key.

Pattern PQ-4. Excerpts: [`source-excerpts.md`](../evidence/galxe-signer/source-excerpts.md).

## Evidence

- CHECKED (Sourcify verified source, read 2026-11-17): the functions and lines above
  ([`review-reads.json`](../evidence/galxe-signer/review-reads.json)).
- CHECKED (on-chain at block 26,431,457): owners (`0x62e3bab5…` and `0x78a6c322…` EOAs; Safe `0x73eb342e…`, 3 of 5)
  and signers; no proxies.
- CHECKED (Blockscout, 2026-11-17): VestingEarndrop holds 675,468 GTSI (no market price) and no ETH; the Treasurer
  0.0002 ETH; GeneralInstantPaymentLSD under $0.01.
- CHECKED (precompile trace to March 2026): 38,361, 29,234 and 26,583 pre-quantum calls in the year
  (`data/report/curated_contracts.csv`, `txs_y1`).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): no transactions; last activity 2025-10-09, 2026-07-06 and 2025-12-03
  ([`activity.json`](../evidence/galxe-signer/activity.json)).
- INFERRED: forged deposit authorisations would let an attacker credit tasks or skip task fees in Galxe's off-chain
  accounting; that effect is outside these contracts.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xd86193d0…` VestingEarndrop | config-only | $0 (unpriced GTSI) | 2025-10-09 | 0 |
| `0x5f17bf77…` GeneralInstantPaymentLSDTreasurer | config-only | $0 | 2026-07-06 | 0 |
| `0x07c78007…` GeneralInstantPaymentLSD | config-only | $0 | 2025-12-03 | 0 |

Only VestingEarndrop pools other people's tokens; it has had no activity for 13 months and holds no priced tokens.
If Galxe funds new earndrops in it, its pooled balance becomes the exposure.

## Remediation

- Galxe: redeploy with a post-quantum signer check (ERC-7913 verifier for an ML-DSA or hash-based backend key).
  Rotating `signer` with `setSigner` does not help.
- Users: nothing to do; deposits are paid by the caller and claims go to the Merkle-listed account.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review09): MEDIUM -> LOW, step 5: measured holdings of all three contracts are about $0 (block 26,431,457), so the redeploy case (MEDIUM, step 4) drops one level. Mechanism read in verified source: only VestingEarndrop pools other people's tokens behind the signer check; deposit contracts move only the caller's funds.
