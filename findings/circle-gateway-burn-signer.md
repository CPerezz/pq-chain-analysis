---
id: circle-gateway-burn-signer
title: "Circle Gateway: a quantum attacker who recovers Circle's burn-signer and TEE vouch ECDSA keys can debit depositors' $56M USDC balances in GatewayWallet"
project: circle
status: confirmed
severity: MEDIUM
patterns: [PQ-4, PQ-2]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x77777777dcc4d5a8b6e418fd04d8997ef11000ee"
  implementation: "0xf7a6d9d7df917c072ac8987a820c58aa27a0e798"
  name: ERC1967Proxy -> GatewayWallet
  upgradeable: "yes"
  admin: "UUPS owner 0x2a6a86466f181721ec8ff946967b56f1aa4758c5 (EOA; upgrades and adds/removes burn signers); read at block 26431457"
  value_usd: 56445665
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 3271
families: []
fix:
  layer: contract-upgrade
  who_acts: "Circle: GatewayWallet owner 0x2a6a86466f181721ec8ff946967b56f1aa4758c5 upgrades the implementation to verify post-quantum burn-signer and TEE signatures"
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/circle-gateway-burn-signer/classification.jsonl
  - evidence/circle-gateway-burn-signer/onchain.json
  - evidence/circle-gateway-burn-signer/activity.json
  - evidence/circle-gateway-burn-signer/source-excerpts.md
  - evidence/circle-gateway-burn-signer/review-reads.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_2.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review09 (finding review)
  ref: evidence/circle-gateway-burn-signer/review-reads.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [circle-cctp-attesters, circle-gateway-minter-attestation-key, circle-usdc-permit-code-first]
---

## Summary

GatewayWallet holds USDC that depositors keep available for Circle Gateway's cross-chain transfers. Its
`gatewayBurn` debits and burns depositors' balances when a batch is signed by a Circle burn signer (one ECDSA key,
PQ-4) and each burn intent is signed by the depositor, or vouched for by a registered TEE ECDSA key; depositor
signatures are tried with `ecrecover` first and ERC-1271 only for allowlisted contracts (PQ-2). A quantum attacker who
recovers the burn-signer key and a TEE key (or a depositor's key) can burn depositors' balances, $56.4M of USDC now;
with Circle's GatewayMinter attestation key as well, the matching mint on the destination goes to the attacker.
Rated MEDIUM (step 4): Circle's owner key can upgrade the contract.

## Mechanism

- `Burns.gatewayBurn(calldataBytes, signature)` (l.173) -> `_verifyBurnSignerSignature` (l.253-258):
  `ECDSA.recover(keccak256(calldataBytes).toEthSignedMessageHash(), signature)` must be in `burnSigners`
  (`addBurnSigner` / `removeBurnSigner`, `onlyOwner`, l.214-231).
- For each intent, `_validateSignatureAndGetSigner` (l.316-359): `ECDSA.tryRecover(digest, signature)` first; accepted
  if it recovers the intent's source signer (EOA path) or any `isContractSignatureSigner` (TEE vouch path); otherwise
  ERC-1271 with the full signature, but only if the source signer `_wasEverAllowlistedContractSigner`.
- `_processIntentsAndBurn` (l.366 onward) debits the depositor's balance in the wallet, burns the tokens and sends the
  fee (at most the intent's `maxFee`) to `feeRecipient`.
- Withdrawals by depositors (`initiateWithdrawal` / `withdraw`, Withdrawals.sol l.76-104) need no signature.

Patterns PQ-4 (burn signer, TEE vouch key) and PQ-2 (depositor intents). Excerpts:
[`source-excerpts.md`](../evidence/circle-gateway-burn-signer/source-excerpts.md).

## Evidence

- CHECKED (Sourcify verified source of `0xf7a6d9d7…`, read 2026-11-17): the functions and lines above
  ([`review-reads.json`](../evidence/circle-gateway-burn-signer/review-reads.json)).
- CHECKED (on-chain at block 26,431,457): EIP-1967 implementation `0xf7a6d9d7…`; `owner()` `0x2a6a8646…` (EOA, no
  code), `pendingOwner()` zero; `pauser()` `0x9812d5f0…`; `paused()` false; USDC balance 56,445,664.98.
- CHECKED (precompile trace to March 2026): `ecrecover`; 2,606 pre-quantum calls in the year
  (`data/report/curated_contracts.csv`, `txs_y1`).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): 3,271 transactions called the wallet (any function)
  ([`activity.json`](../evidence/circle-gateway-burn-signer/activity.json)).
- NOT READ: the current burn-signer and TEE signer sets (mappings; events not enumerated).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x77777777…` ERC1967Proxy -> GatewayWallet | yes | $56.4M (USDC) | 2026-11-16 | 3,271 |

The wallet's holdings are the depositors' balances and are what forged burns debit. The mint side, GatewayMinter
`0x2222222d7164433c4c09b0b0d809a9b52c04c205` (one ECDSA attestation signer; $136.6M of USDC, EURC and cirBTC minter
allowance at block 26,431,457), is covered in `circle-gateway-minter-attestation-key`.

## Remediation

- Circle (owner `0x2a6a8646…`): upgrade GatewayWallet so batches and TEE vouches are verified with a post-quantum
  scheme (ML-DSA or hash-based signatures, through an ERC-7913 verifier), and send depositor intents from accounts with
  code to ERC-1271 first instead of only allowlisted contracts. Rotating burn signers alone does not help.
- The owner key itself is an ECDSA EOA; moving ownership to a post-quantum account is part of the fix.
- Depositors: withdraw (`initiateWithdrawal` then `withdraw`) if Circle has not upgraded; balances in the wallet are
  exposed to forged burns.
- Protocol change: not needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review09): MEDIUM kept (step 4: one owner key can upgrade). Mechanism read in verified source: burn-signer key plus depositor or TEE vouch signature needed; PQ-2 added for depositor intents; owner confirmed as an EOA at block 26,431,457; holdings re-read ($56.4M USDC); GatewayMinter found and filed as `circle-gateway-minter-attestation-key`.
