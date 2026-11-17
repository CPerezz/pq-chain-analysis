---
id: aster-vault-validator-sigs
title: "Aster AstherusVault: withdrawals are authorised by ECDSA keys (a weighted validator quorum, or fixed business and ledger signers); recovering them plus one operator key releases the vault's $204.5M"
project: aster
status: confirmed
severity: MEDIUM
patterns: [PQ-5, PQ-4]
primitives: [ecrecover]
trigger: committee-keys
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x604dd02d620633ae427888d41bfd15e38483736e"
  implementation: "0x2cc878ac49c3bf8b0f2b053af7845ba6590eec4f"
  name: AstherusVault (ERC1967 UUPS proxy)
  upgradeable: "yes"
  admin: UUPS _authorizeUpgrade onlyTimeLock = AstherusTimelock 0x20f4e8cbf7c0062464e1496164b6847112ec41bf (1-day delay), proposer/executor Safe 0x1fe3fe2ddd19ab58b0c56054a5af217afb27ecea (4 of 7); the same Safe holds ADMIN_ROLE (validator sets)
  value_usd: 204534121
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 10385
families: []
fix:
  layer: contract-upgrade
  who_acts: Aster, through Safe 0x1fe3fe2ddd19ab58b0c56054a5af217afb27ecea (4 of 7) scheduling a UUPS upgrade on AstherusTimelock 0x20f4e8cbf7c0062464e1496164b6847112ec41bf
  protocol_change: not-needed
evidence:
  level: source-read
  links:
  - evidence/aster-vault-validator-sigs/classification.jsonl
  - evidence/aster-vault-validator-sigs/onchain.json
  - evidence/aster-vault-validator-sigs/activity.json
  - evidence/aster-vault-validator-sigs/source-excerpts.md
  - evidence/aster-vault-validator-sigs/review.json
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  who: Review10 (source and on-chain review)
  ref: evidence/aster-vault-validator-sigs/review.json
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: [aster-treasury-claim-signer]
---

## Summary

AstherusVault, Aster's Ethereum deposit vault, releases funds through two `withdraw` functions, both gated by ECDSA: a weighted quorum of validator keys (PQ-5), or the fixed `BUSINESS_SIGNER` and `LEDGER_SIGNER` keys of AsterWithdrawValidator plus the user's own signature (PQ-4). Both also need the transaction to come from one of five OPERATE_ROLE EOAs. A quantum attacker who recovers those keys from their public signatures can withdraw the vault's holdings, $204.5M on 2026-11-17, at up to the $6M-per-hour limit before the vault pauses itself. Rated MEDIUM (step 4): the vault is a UUPS proxy that Aster's 4-of-7 Safe can upgrade through a 1-day timelock.

## Mechanism

- Path 1, `withdraw(id, validators, action, validatorSignatures)` (selector `0xe79158b1`, `onlyRole(OPERATE_ROLE)`): `verifyValidatorSignature` (L426-448) looks up the registered set by `keccak256(abi.encode(validators))`, recovers each signature over `toEthSignedMessageHash(digest)` with OZ `ECDSA.recover`, and requires the matched power to be at least 2/3 of the set's total. Sets are added and removed by ADMIN_ROLE (`addValidator`, `removeValidator`).
- Path 2, `withdraw(tokenAddress, realFee, userRequestInfo, businessInfo, signatureInfo)` (selector `0x0cd4b1fe`, `onlyRole(OPERATE_ROLE)`): calls the immutable `WITHDRAW_VALIDATOR` = AsterWithdrawValidator `0x10065113…`, whose `withdrawCheck` requires a user EIP-712 signature from `businessInfo.userAddress`, an EIP-191 signature from the immutable `BUSINESS_SIGNER`, and one from the immutable `LEDGER_SIGNER`. Its `SignatureChecker.isValidSignatureNow` treats any 65-byte signature as ECDSA; longer ones carry a type byte (ECDSA or a Safe `checkSignatures`).
- Both paths then `checkLimit` (USD value via price feed against `hourlyLimit`; above it the vault pauses) and `_transfer` the token to the receiver.
- The user signature on path 2 can be the attacker's own; the keys that guard pooled funds are the business and ledger signers, the validator set, and an OPERATE_ROLE EOA.

Source excerpts: [`source-excerpts.md`](../evidence/aster-vault-validator-sigs/source-excerpts.md).

## Evidence

- CHECKED (verified source, Sourcify: AstherusVault implementation `0x2cc878ac…`, AsterWithdrawValidator `0x10065113…`, AstherusTimelock `0x20f4e8cb…`): the two paths above; `_authorizeUpgrade` is `onlyTimeLock`; `TIMELOCK_ADDRESS` and `WITHDRAW_VALIDATOR` are immutables.
- CHECKED (on-chain, block 26,431,494): EIP-1967 implementation `0x2cc878ac…`; `WITHDRAW_VALIDATOR()` `0x10065113…`; `hourlyLimit()` 6e14 (USD with 8 decimals, $6,000,000 per hour); not paused; OPERATE_ROLE 5 EOAs; DEFAULT_ADMIN_ROLE and ADMIN_ROLE Safe `0x1fe3fe2d…` (v1.3.0, 4 of 7); timelock `getMinDelay()` 86,400 s, proposer and executor the same Safe; `BUSINESS_SIGNER` `0x71c91e0c…`, `LEDGER_SIGNER` `0xa35eb116…` ([`review.json`](../evidence/aster-vault-validator-sigs/review.json)).
- CHECKED (Blockscout, 2026-11-17): tokens $202.84M (USDT $157.0M, USDC $18.5M, WBTC $16.2M, USD1 $10.8M) plus 934.97 ETH. Last 50 transactions: 18 withdrawals, all through path 2; none through path 1.
- CHECKED (precompile trace, last year): 57,561 transactions with ecrecover (`txs_y1`); Xatu: 10,385 transactions 2026-10-16 to 2026-11-16 ([`activity.json`](../evidence/aster-vault-validator-sigs/activity.json)).
- NOT ESTABLISHED: which validator sets are registered for path 1 (hash-keyed mapping; the event-log scan did not finish on public RPCs).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x604dd02d…` AstherusVault | yes (UUPS, timelock) | $204.5M | 2026-11-16 | 10,385 |

- Held value: $202,840,313 in tokens plus 934.97 ETH at $1,811.62 = $204.5M (2026-11-17). This is what forged withdrawals release. The hourly limit pauses the vault once $6M has left in an hour; it slows a drain, it does not prevent one.
- The keys involved have all signed publicly (signatures in withdrawal calldata, or transactions sent by the operator EOAs), so their public keys are known.
- Sibling: ApolloxExchangeTreasury `0xb40eed68…` sends funds to this vault (`counterParty`); its single truth-holder key is [aster-treasury-claim-signer](aster-treasury-claim-signer.md).

## Remediation

- Aster upgrades the vault (Safe `0x1fe3fe2d…` schedules on AstherusTimelock `0x20f4e8cb…`, 1-day delay) to verify a post-quantum scheme for withdrawal authorisation (hash-based or ML-DSA signatures through an ERC-7913 verifier, or a STARK proof of the off-chain ledger), and replaces AsterWithdrawValidator, whose signers are immutable. Rotating validators or deploying a new AsterWithdrawValidator with new ECDSA keys does not help.
- The admin Safe and the operator EOAs are themselves ECDSA keys (PQ-12); they must move to post-quantum signers before the upgrade path is safe.
- No protocol change is needed.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review10): MEDIUM confirmed, step 4 (UUPS upgrade through the timelock by the 4-of-7 Safe). Added the AsterWithdrawValidator path (business and ledger signer keys, PQ-4), which carries all recent withdrawals; named the timelock's proposer Safe; value recomputed at 2026-11-17.
