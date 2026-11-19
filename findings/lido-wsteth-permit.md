---
id: lido-wsteth-permit
title: "Lido wstETH: a quantum attacker who recovers a holder's ECDSA key can sign a permit and take that holder's wstETH, even after the holder migrates; post-quantum accounts cannot use permit"
project: lido
status: confirmed
severity: HIGH
patterns: [PQ-1]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: sole
role: auxiliary
contracts:
- address: "0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0"
  implementation: null
  name: WstETH
  upgradeable: "no"
  admin: none (not a proxy, no owner)
  value_usd: 8504705274
  value_basis: market-cap
  value_as_of: 2026-11-17
  last_active: 2026-11-16
  txs_30d: 71428
families: []
fix:
  layer: account-migration
  who_acts: nobody can change WstETH 0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0; each holder moves wstETH to a fresh post-quantum account, or Lido DAO deploys a new wrapper that holders migrate to
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/lido-wsteth-permit
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_4.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review07 (registry review)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/lido-wsteth-permit/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: HIGH
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by a person)"
  ref: "studies/eip-8151-impact, reading 3 (does EIP-8151 close this path), 2026-11-19"
  date: 2026-11-19
  verdict: confirmed
  rating: ''
related: [lido-steth-permit-code-first, lido-predeposit-bls12-381]
---

## Summary

WstETH's EIP-2612 `permit` accepts only an `ecrecover` signature from the holder (PQ-1). A quantum attacker who
recovers a holder's secp256k1 key from its public key can sign a permit for any spender and pull that holder's
wstETH, and this keeps working after the holder moves the same address to post-quantum authorisation; a
post-quantum account cannot use `permit` at all. The contract is immutable. Exposed: holders' balances, at most the
wstETH market cap of $8.50B (2026-11-17). Rated HIGH (step 4): users' own funds stay forgeable in a contract that
cannot change; only every holder moving or a protocol change such as EIP-8151 protects them.

## Mechanism

`WstETH.permit(owner, spender, value, deadline, v, r, s)` (WstETH.sol line 961, OpenZeppelin 3.4 `ERC20Permit`) hashes
the EIP-712 `Permit` struct, calls `ECDSA.recover(hash, v, r, s)` (line 978; `ecrecover` at line 750) and requires the
result to equal `owner`, then `_approve(owner, spender, value)`. There is no account-code check and no ERC-1271 call,
so the signature scheme is fixed to secp256k1 for every holder, contract or not. The spender then moves the tokens
with `transferFrom`. Pattern PQ-1. Excerpt: [`source-excerpts.md`](#source-excerpts-lido-wsteth-permit).

## Evidence

- CHECKED (verified source, Sourcify full match): `permit` → `ECDSA.recover` only, as above.
- CHECKED (`cast` at block 26,431,455): EIP-1967 implementation slot is zero; `onchain.json` (block 26,431,214) shows
  no proxy, no admin, no owner. The contract cannot be upgraded or reconfigured.
- CHECKED (`cast` at block 26,431,455 and Blockscout token data, 2026-11-17): `totalSupply()` 3,754,770.46 wstETH
  × $2,265.04 = $8.50B ([`notes.md`](#review-reads-lido-wsteth-permit-2026-11-17-review07)).
- CHECKED (precompile trace to March 2026; `studies/top-callers-classification/results/curated_contracts.csv`): 32,688 transactions with `ecrecover`
  in the last year, $17.2B transacted in them (a flow, not an exposure).
- CHECKED (Xatu, any function): 71,428 transactions called WstETH in 2026-10-16 to 2026-11-16; last 2026-11-16
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/lido-wsteth-permit/activity.json)).
- INFERRED: the attacker needs the holder's public key, i.e. a holder address that has signed at least one
  transaction or message; never-used addresses are not recoverable.
- CHECKED (executed, study `eip-8151-impact`, 2026-11-19): a real transaction,
  `0xae8dfb441dc71fe157a93c7960c3967f69ae45b99619677ab60707de317f45d8` (block 26,385,787, position 1), replayed on
  the reference implementation of the fork with only the precompile changed. Under today's rule it matches its
  receipt (666,533 gas); under EIP-8151 it also succeeds (676,014 gas). With one byte of code at the recovered signer
  `0x63cd5a1aa7d01d006e70722194dbf100a75a017c`, it reverts after that recovery returned no address; with a 7702
  delegation there it succeeds. Study family `7f046cb4` (WstETH).

## Impact and exposure

| Contract | Upgradeable | Exposure | Last active | 30-day txs |
|---|---|---|---|---|
| `0x7f39c581…` WstETH | no | $8.50B (market cap, upper bound) | 2026-11-16 | 71,428 |

The exposure is the holders' wstETH, bounded by the market cap; the contract's own 4.69M stETH backing is not taken
through `permit` (only holders' balances are). wstETH bridged to L2s is out of scope. Only mainnet WstETH carries this
check; stETH's `permit` is a separate finding (`lido-steth-permit-code-first`).

## Remediation

- WstETH cannot change. Holders whose addresses have exposed public keys protect themselves by moving wstETH to a
  fresh post-quantum account (smart account or EIP-8141 account) that has never signed with ECDSA.
- Post-quantum accounts can still use wstETH through on-chain `approve`, or through Permit2 (which checks account
  code first), instead of `permit`.
- Lido DAO could deploy a new wrapper whose `permit` checks account code first and passes the full signature to
  ERC-1271; holders would migrate to it.
- Protocol change: helps. EIP-8151 (make `ecrecover` fail for addresses with real code) would protect holders who
  migrate in place.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review07): HIGH unchanged (step 4). Source and immutability re-checked; market cap corrected from
  a stale $10.70B to $8.50B (supply × price on 2026-11-17); related Lido findings linked.
- 2026-11-19 (study `eip-8151-impact`, reading 3): EIP-8151 as written closes this path for an account that takes
  real code (executed on a real transaction); plain and 7702-delegated accounts stay exposed, and approvals already
  given stay valid.

# Source excerpts: lido-wsteth-permit

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0` — WstETH (verified source via sourcify)

### `WstETH.sol`

```solidity
  661       * For more information on the signature format, see the
  662       * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
  663       * section].
  664       */
  665      function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
  666  
  667      /**
  668       * @dev Returns the current nonce for `owner`. This value must be
  669       * included whenever a signature is generated for {permit}.
  ...
  746          require(uint256(s) <= 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0, "ECDSA: invalid signature 's' value");
  747          require(v == 27 || v == 28, "ECDSA: invalid signature 'v' value");
  748  
  749          // If the signature is valid (and not malleable), return the signer address
  750          address signer = ecrecover(hash, v, r, s);
  751          require(signer != address(0), "ECDSA: invalid signature");
  752  
  753          return signer;
  754      }
  ...
  957  
  958      /**
  959       * @dev See {IERC20Permit-permit}.
  960       */
  961      function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public virtual override {
  962          // solhint-disable-next-line not-rely-on-time
  963          require(block.timestamp <= deadline, "ERC20Permit: expired deadline");
  964  
  965          bytes32 structHash = keccak256(
  ...
  974          );
  975  
  976          bytes32 hash = _hashTypedDataV4(structHash);
  977  
  978          address signer = ECDSA.recover(hash, v, r, s);
  979          require(signer == owner, "ERC20Permit: invalid signature");
  980  
  981          _nonces[owner].increment();
  982          _approve(owner, spender, value);
  ...
```

# Review reads: lido-wsteth-permit (2026-11-17, Review07)

- Source: Sourcify full match for `0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0` (WstETH.sol, OpenZeppelin 3.4 `ERC20Permit`).
  `permit` (line 961) -> `ECDSA.recover(hash, v, r, s)` (line 978, `ecrecover` at line 750) == `owner`, then `_approve`.
  No `isValidSignature`, no code check.
- Block 26,431,455 (`cast`, publicnode):
  - EIP-1967 implementation slot: `0x0` (not a proxy; `onchain.json` kind `none`, code 6,492 bytes).
  - `totalSupply()` = 3,754,770.456318660285688209 wstETH.
  - `stEthPerToken()` = 1.249382748367543997.
- Blockscout `tokens/0x7f39…2ca0` on 2026-11-17: `exchange_rate` $2,265.04, `circulating_market_cap` $8,547,006,138.
  Market cap used here: totalSupply × exchange_rate = $8,504,705,274 (cross-check: supply × stEthPerToken × ETH
  $1,811.62 = $8,498,572,888). The draft's $10.70B came from a stale cached market cap.
- Yearly pre-quantum use (`data/report/curated_contracts.csv`): `txs_y1` 32,688 `ecrecover` transactions,
  `usd_tx_y1` $17.2B.
