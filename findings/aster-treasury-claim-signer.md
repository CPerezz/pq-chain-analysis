---
id: aster-treasury-claim-signer
title: "Aster ApolloxExchangeTreasury: one truth-holder ECDSA key authorises every claim; a quantum attacker who recovers it can withdraw the treasury's $114k"
project: aster
status: confirmed
severity: MEDIUM
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0xb40eed68d7d6b3b6d6f4e93de6239b7c53efc786"
  implementation: null
  name: ApolloxExchangeTreasury
  upgradeable: config-only
  admin: owner and operator Safe 0x9b7c0a5829ab078c219f2f751a2ab46ab911bbec (3 of 6, block 26431609); owner can _pause, _changeTruthHolder, and operator can transferToCounterParty (to AstherusVault 0x604dd02d620633ae427888d41bfd15e38483736e)
  value_usd: 113593
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-15
  txs_30d: 187
families: []
fix:
  layer: new-deployment
  who_acts: Aster, through Safe 0x9b7c0a5829ab078c219f2f751a2ab46ab911bbec (owner and operator)
  protocol_change: not-needed
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aster-treasury-claim-signer
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_5.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review10 (source and on-chain review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aster-treasury-claim-signer/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [aster-vault-validator-sigs]
---

## Summary

ApolloxExchangeTreasury pays out a claim to anyone who presents a message signed by the single `truthHolder` ECDSA key (PQ-4). The key's signatures are public in claim calldata, so a quantum attacker can recover it and sign claims for the whole balance: $114k on 2026-11-17 (USDT, WBTC, USDC, BUSD, 0.38 ETH). `claim` is open to any caller. Rotating `truthHolder` to a new ECDSA key does not help; the contract cannot verify another scheme. Rated MEDIUM (step 4): the fix is a new deployment by Aster's 3-of-6 Safe; the value is above USD 50k.

## Mechanism

- `claim(bytes message, bytes signature)` (no access restriction, `notPaused`): `source(message, signature)` = `ECDSA.recover(keccak256("\x19Ethereum Signed Message:\n32" ‖ keccak256(message)), signature)` must equal `truthHolder`; the message decodes to `(id, to, isETH, currency, amount, deadline)`; the id is marked used and `amount` of ETH or a supported token goes to `to`.
- Admin: `_changeTruthHolder`, `_pause`/`_unpause`, `_addCurrency` are `onlyOwner`; `transferToCounterParty` (operator) moves funds to `counterParty`, currently AstherusVault.
- Pattern PQ-4: one operator key, fixed scheme.

Source excerpts: [`source-excerpts.md`](#source-excerpts-aster-treasury-claim-signer).

## Evidence

- CHECKED (verified source, Sourcify `ApolloxExchangeTreasury.sol`, read in full): the code path above; no proxy, no upgrade function.
- CHECKED (on-chain, block 26,431,609): `owner()` and `operator()` = Safe `0x9b7c0a58…` (threshold 3 of 6); `truthHolder()` `0x39194a2f…`; `counterParty()` AstherusVault `0x604dd02d…`; `paused()` false; 0.384 ETH ([`review.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aster-treasury-claim-signer/review.json)).
- CHECKED (Blockscout tokens, 2026-11-17): USDT $98,882, WBTC $5,976, USDC $5,423, BUSD $2,492; with ETH at $1,811.62, $113,593 in total.
- CHECKED (precompile trace, last year): 13,751 transactions with ecrecover (`txs_y1`); Xatu: 187 transactions 2026-10-16 to 2026-11-16, last 2026-11-15 ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/aster-treasury-claim-signer/activity.json)).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0xb40eed68…` ApolloxExchangeTreasury | config-only | $114k | 2026-11-15 | 187 |

- Exposed: the treasury's own balance, $113,593 (2026-11-17). Funds are swept to AstherusVault by the operator, so the balance varies.
- Sibling: AstherusVault `0x604dd02d…`, which receives this treasury's funds, is [aster-vault-validator-sigs](aster-vault-validator-sigs.md).

## Remediation

- Aster (Safe `0x9b7c0a58…`): deploy a treasury that verifies claims with a post-quantum scheme (an ERC-7913 verifier for an ML-DSA or hash-based truth-holder key, or a proof of the off-chain ledger), then `transferToCounterParty` the balance out and `_pause` this one. Until then, keeping the balance low limits the exposure.
- The Safe owners are ECDSA keys themselves (PQ-12).
- No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review10): MEDIUM confirmed, step 4 (new deployment by one known Safe; $114k is above the step-5 threshold). Added the owner/operator Safe and the counterparty link to AstherusVault.

# Source excerpts: aster-treasury-claim-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0xb40eed68d7d6b3b6d6f4e93de6239b7c53efc786` — ApolloxExchangeTreasury (verified source via sourcify)

### `/Users/user/workspace/cloud-protocol-eth/contracts/ApolloxExchangeTreasury.sol`

```solidity
    3  
    4  import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
    5  import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
    6  import "@openzeppelin/contracts/access/Ownable.sol";
    7  import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";
    8  
    9  pragma experimental ABIEncoderV2;
   10  
   11  contract ApolloxExchangeTreasury is Ownable {
  ...
   85      }
   86  
   87      function source(bytes memory message, bytes memory signature) public pure returns (address) {
   88          bytes32 hash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", keccak256(message)));
   89          return ECDSA.recover(hash, signature);
   90      }
   91  
   92      function _pause() external onlyOwner {
   93          paused = true;
  ...
```

Library files with the primitive itself (not excerpted): `@openzeppelin/contracts/utils/cryptography/ECDSA.sol`
