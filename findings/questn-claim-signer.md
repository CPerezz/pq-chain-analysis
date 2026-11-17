---
id: questn-claim-signer
title: "QuestN: a quantum attacker who recovers QuestN's claim-signer key can sign reward claims and mint Quest3 reward NFTs and token payouts from its event-reward contract (reward vault empty on 2026-11-17)"
project: questn
status: candidate
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x7c838b25092925d0155a8358475bfe6c19921d9e"
  implementation: "0x43f985fc517b50c5fbfdf43ff1bf2896a314cb1d"
  name: TransparentUpgradeableProxy → unverified QuestN claim contract (version 0.4.0)
  upgradeable: "yes"
  admin: "ProxyAdmin 0x9ce99901b23fc9f65c5ff839405545b8168c6e4e, owner EOA 0x2f6f4be9ef26ef1cf6ebb4ab9c4b36873651fc83 (also logic owner: setClaimSigner); read at block 26,431,601"
  value_usd: 0
  value_basis: escrow
  value_as_of: 2026-11-17
  last_active: 2026-10-13
  txs_30d: 0
families: []
fix:
  layer: contract-upgrade
  who_acts: "QuestN: ProxyAdmin 0x9ce99901b23fc9f65c5ff839405545b8168c6e4e owner EOA 0x2f6f4be9ef26ef1cf6ebb4ab9c4b36873651fc83"
  protocol_change: not-needed
evidence:
  level: bytecode
  links:
  - evidence/questn-claim-signer/classification.jsonl
  - evidence/questn-claim-signer/onchain.json
  - evidence/questn-claim-signer/activity.json
  - evidence/questn-claim-signer/source-excerpts.md
  - evidence/questn-claim-signer/notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_3.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review11 (Claude), finding review
  ref: evidence/questn-claim-signer/notes.md
  date: 2026-11-17
  verdict: reported
  rating: LOW
related: []
---

## Summary

This proxy is QuestN's (formerly Quest3) event-reward claim contract: a user's claim is accepted when it carries a
signature from the claim signer `0x6288454b…`, and it mints a Quest3 reward NFT and can pay a token reward from QuestN's
vault (PQ-4). The signer's public key is recoverable from signed claims, so a quantum attacker can sign claims for any
event. The reward vault `0x0376a356…` and the proxy held nothing of value on 2026-11-17. Rated LOW: MEDIUM by step 4 (an
upgradeable proxy owned by one EOA), lowered by step 5 (measured exposure $0). Candidate: the implementation is
unverified.

## Mechanism

- Implementation `0x43f985fc…` is unverified. Its selectors include `claim(string,uint256,bytes)`, `claimSigner()`,
  `setClaimSigner(address)`, `isClaimable(string)`, `claimed(string,address,uint256)`, `vaultAddress()` and
  `setVaultAddress(address)` ([`notes.md`](../evidence/questn-claim-signer/notes.md)).
- A sample claim (tx `0x632b8e30…`, selector `0x1bcfaa66`) minted Quest3NFT token 50,467 to the caller and moved
  10.07 USDT from the vault `0x0376a356…` to the caller.
- [INFERENCE from selectors and the precompile trace] the claim path recovers the signer with `ecrecover` and compares
  it with `claimSigner`; rotating `claimSigner` keeps the scheme.

## Evidence

- CHECKED (precompile trace, all mainnet transactions to March 2026): `ecrecover` calls from this contract.
- CHECKED (bytecode selectors, block 26,431,601): the functions above; no verified source on Sourcify or Blockscout.
- CHECKED (on-chain read, block 26,431,601): ProxyAdmin `0x9ce99901…` owner EOA `0x2f6f4be9…`; logic owner the same
  EOA; `claimSigner()` `0x6288454b…`; vault `0x0376a356…` (owner the same EOA); NFTs named "Quest3NFT" and
  `baseTokenURI()` on `nft.questn.com`.
- CHECKED (Blockscout and `cast`, 2026-11-17): proxy, vault and vault strategy hold no priced assets (vault USDT 0).
- CHECKED (Xatu, any function): no calls 2026-10-16 to 2026-11-16; last 2026-10-13
  ([`activity.json`](../evidence/questn-claim-signer/activity.json)).
- INFERRED: that `claim` verifies `claimSigner` with `ecrecover` (bytecode, not source). This keeps the finding a
  candidate.

## Impact and exposure

| Contract | Upgradeable | Escrow (reward vault) | Last active | 30-day txs |
|---|---|---|---|---|
| `0x7c838b25…` QuestN claim proxy | yes (ProxyAdmin, owner EOA) | $0 in vault `0x0376a356…` | 2026-10-13 | 0 |

Escrow basis, 2026-11-17: the reward vault is empty; the exposure at any time is the vault's balance (the vault's funding history was
not traced). Forged claims also mint reward NFTs, which carry no measured value. Yearly pre-quantum count from
the census: 32,702 claims (`txs_y1`). The draft's family entry (63 contracts sharing the OpenZeppelin
TransparentUpgradeableProxy runtime code, listed as "BridgeV2") was removed: the shared code is the generic proxy, not
QuestN's logic.

## Remediation

- QuestN (ProxyAdmin owner EOA `0x2f6f4be9…`) upgrades the claim logic to verify claims through ERC-1271 from a signer
  account with post-quantum keys (or a Merkle allowlist per event). No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review11): MEDIUM -> LOW, step 5: the claims pay from reward vault 0x0376a356…, which held $0 on 2026-11-17. Project identified as QuestN (Quest3NFT contracts, nft.questn.com base URI); id kept. Removed the unrelated proxy-code family (63 contracts sharing the generic proxy code). Status stays candidate (implementation unverified).
- 2026-11-17 integration: id renamed from `unidentified-7c838b25-signer-key` (project identified).
