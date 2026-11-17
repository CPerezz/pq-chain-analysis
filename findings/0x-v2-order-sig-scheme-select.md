---
id: "0x-v2-order-sig-scheme-select"
title: "0x v2.1 Exchange: a forged maker or taker ECDSA signature spends that address's token approvals to the 0x v2 asset proxies, even after the address moves to post-quantum authorisation"
project: "0x"
status: confirmed
severity: MEDIUM
patterns: [PQ-2]
primitives: [ecrecover]
trigger: user-key
impact: funds-loss
alternative: alternative-exists
role: core
contracts:
- address: "0x080bf510fcbf18b91105470639e9561022937712"
  implementation: null
  name: Exchange
  upgradeable: "no"
  admin: "ZeroExGovernor 0x7d3455421bbc5ed534a83c88fd80387dc8271392 (2 of 4, time-locked multisig; owns the Exchange and all its asset proxies, can de-authorise the Exchange on them; read at block 26,431,454)"
  value_usd: null
  value_basis: null
  value_as_of: null
  last_active: 2026-11-15
  txs_30d: 2331
families: []
fix:
  layer: onchain-config
  who_acts: "ZeroExGovernor 0x7d3455421bbc5ed534a83c88fd80387dc8271392 (2 of 4) removes 0x080bf510… from the authorised addresses of ERC20Proxy 0x95e6f48254609a6ee006f7d493c8e5fb97094cef, ERC721Proxy 0xefc70a1b18c432bdc64b596838b4d138f6bc6cad, MultiAssetProxy 0xef701d5389ae74503d633396c4d654eabedc9d78 and ERC1155Proxy 0x7eefbd48fd63d441ec7435d024ec7c5131019add; users revoke approvals to those proxies"
  protocol_change: helps
evidence:
  level: source-read
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/0x-v2-order-sig-scheme-select
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
- by: ai-assisted
  study: top-callers-classification
  who: Review08 (verified source and on-chain reads)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/0x-v2-order-sig-scheme-select/notes.md
  date: 2026-11-17
  verdict: confirmed
  rating: MEDIUM
related: ["0x-v4-order-sig-ecdsa-only"]
---

## Summary

The immutable 0x v2.1 Exchange lets the signature itself choose the scheme: an `EIP712` or `EthSign` signature is
checked with `ecrecover` against any maker or signer address, whether or not that address has account code (PQ-2). A
quantum attacker who recovers an address's secp256k1 key can sign orders or 0x transactions for it and spend whatever
that address has approved to the 0x v2 asset proxies (ERC20Proxy `0x95e6f482…` and three others), also after the
address has moved to post-quantum authorisation. Those approvals are the exposure; they are not measured (the Exchange
itself holds nothing). Rated MEDIUM (step 4): the Exchange cannot change, but 0x's 2-of-4 ZeroExGovernor can close the
path by de-authorising it on the asset proxies; the draft's HIGH assumed nobody could.

## Mechanism

- `MixinSignatureValidator.isValidSignature(bytes32 hash, address signerAddress, bytes signature)` (`Exchange.sol`
  lines 2521-2654) pops the last byte as `SignatureType`. `EIP712` (lines 2577-2589) and `EthSign` (2595-2607) require
  65 bytes and return `signerAddress == ecrecover(...)`. No `extcodesize` check precedes them.
- The alternatives a post-quantum account can use: `Wallet` (staticcall `isValidSignature(bytes32,bytes)` on the
  maker, which must return the 0x-specific magic `0xb0671381`, not the ERC-1271 value; the full signature is passed),
  `Validator` (a validator contract the signer approved with `setSignatureValidatorApproval`), and `PreSigned` (the
  signer called `preSign`). None of them disables the ECDSA types for that address.
- Callers: `fillOrder` checks the maker signature on the first fill (line 1611); `executeTransaction` (line 4092)
  runs any Exchange function (fills as taker, cancels) for `signerAddress` when the caller is not that address. Tokens
  move through the asset proxies with `transferFrom` on the maker's and taker's approvals.

Pattern PQ-2. Excerpts: [`source-excerpts.md`](#source-excerpts-0x-v2-order-sig-scheme-select).

## Evidence

- CHECKED (Sourcify full match, `Exchange.sol`, read in full around lines 2521-2790): the signature-type dispatch and the
  `ecrecover` branches above.
- CHECKED (`cast`, block 26,431,454): `owner()` is ZeroExGovernor `0x7d3455…`, a 2-of-4 multisig with a 14-day default
  time lock; `getAssetProxy` returns the four proxies; each proxy's `getAuthorizedAddresses()` still includes
  `0x080bf510…`, and each proxy's `owner()` is the same ZeroExGovernor ([`notes.md`](#review-notes-review08-2026-11-17)).
- CHECKED (on-chain read at block 26,431,214): the Exchange holds no ETH or tokens; it is not a proxy
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/0x-v2-order-sig-scheme-select/onchain.json)).
- CHECKED (Xatu, 2026-10-16 to 2026-11-16): 2,331 transactions called the Exchange (2 directly), last on 2026-11-15
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/0x-v2-order-sig-scheme-select/activity.json)).
- CHECKED (precompile trace, year to March 2026, `studies/top-callers-classification/results/curated_contracts.csv`): 86,593 transactions with an
  `ecrecover` in this contract; their transfers total USD 1.47B (`usd_tx_y1`, a flow, not funds at risk).
- INFERRED: whether the governor's `removeAuthorizedAddressAtIndex` is exempt from the time lock was not read.

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x080bf510…` Exchange (v2.1) | no | $0 (not the exposure) | 2026-11-15 | 2,331 |

The exposure is every allowance users have granted to ERC20Proxy `0x95e6f482…`, ERC721Proxy `0xefc70a1b…`,
MultiAssetProxy `0xef701d53…` and ERC1155Proxy `0x7eefbd48…`, capped by those users' balances. It is not measured
(it needs every approval to these proxies). The same ERC20Proxy is also authorised for the 0x v3 Exchange
`0x61935cbd…` and ZrxVault `0xba7f8b5f…`, which are not part of this finding.

## Remediation

- 0x: ZeroExGovernor `0x7d3455…` (2 of 4) de-authorises `0x080bf510…` on the four asset proxies. That retires v2.1
  fills; the Exchange code itself cannot be changed.
- Users: revoke approvals to the v2 asset proxies. A post-quantum account can still trade here with `PreSigned` or a
  `Validator`, but stays forgeable with its old key while its approvals stand.
- Protocol: EIP-8151 would help, since `ecrecover` would fail for addresses with real code. It does not protect
  code-less EOAs.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated HIGH (step 4: users' own funds stay forgeable after they migrate and the contract cannot change; only every user moving or a protocol change (EIP-8151) protects them).
- 2026-11-17 review (Review08): HIGH -> MEDIUM, step 4: the asset proxies' owner (ZeroExGovernor 0x7d3455…, 2 of 4) can de-authorise the immutable Exchange, so one known multisig can close the path without a protocol change; `admin` and `fix` corrected from "nobody can change it".

# Source excerpts: 0x-v2-order-sig-scheme-select

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x080bf510fcbf18b91105470639e9561022937712` — Exchange (verified source via sourcify)

### `Exchange.sol`

```solidity
 1047      /// @param hash Message hash that is signed.
 1048      /// @param signerAddress Address of signer.
 1049      /// @param signature Proof of signing.
 1050      /// @return Validity of order signature.
 1051      function isValidSignature(
 1052          bytes32 hash,
 1053          address signerAddress,
 1054          bytes memory signature
 1055      )
  ...
 1610  
 1611          // Validate Maker signature (check only if first time seen)
 1612          if (orderInfo.orderTakerAssetFilledAmount == 0) {
 1613              require(
 1614                  isValidSignature(
 1615                      orderInfo.orderHash,
 1616                      order.makerAddress,
 1617                      signature
 1618                  ),
  ...
 2407      /// @dev Verifies that a signature is valid.
 2408      /// @param hash Message hash that is signed.
 2409      /// @param signature Proof of signing.
 2410      /// @return Validity of order signature.
 2411      function isValidSignature(
 2412          bytes32 hash,
 2413          bytes signature
 2414      )
 2415          external
  ...
 2444      /// @param hash Message hash that is signed.
 2445      /// @param signerAddress Address that should have signed the given hash.
 2446      /// @param signature Proof of signing.
 2447      /// @return Validity of order signature.
 2448      function isValidSignature(
 2449          bytes32 hash,
 2450          address signerAddress,
 2451          bytes signature
 2452      )
  ...
 2482          external
 2483      {
 2484          if (signerAddress != msg.sender) {
 2485              require(
 2486                  isValidSignature(
 2487                      hash,
 2488                      signerAddress,
 2489                      signature
 2490                  ),
  ...
 2517      /// @param hash Any 32 byte hash.
 2518      /// @param signerAddress Address that should have signed the given hash.
 2519      /// @param signature Proof that the hash has been signed by signer.
 2520      /// @return True if the address recovered from the provided signature matches the input signer address.
 2521      function isValidSignature(
 2522          bytes32 hash,
 2523          address signerAddress,
 2524          bytes memory signature
 2525      )
  ...
 2577              );
 2578              v = uint8(signature[0]);
 2579              r = signature.readBytes32(1);
 2580              s = signature.readBytes32(33);
 2581              recovered = ecrecover(
 2582                  hash,
 2583                  v,
 2584                  r,
 2585                  s
  ...
 2595              );
 2596              v = uint8(signature[0]);
 2597              r = signature.readBytes32(1);
 2598              s = signature.readBytes32(33);
 2599              recovered = ecrecover(
 2600                  keccak256(abi.encodePacked(
 2601                      "\x19Ethereum Signed Message:\n32",
 2602                      hash
 2603                  )),
  ...
 2670          view
 2671          returns (bool isValid)
 2672      {
 2673          bytes memory calldata = abi.encodeWithSelector(
 2674              IWallet(walletAddress).isValidSignature.selector,
 2675              hash,
 2676              signature
 2677          );
 2678          bytes32 magic_salt = bytes32(bytes4(keccak256("isValidWalletSignature(bytes32,address,bytes)")));
  ...
 2741          view
 2742          returns (bool isValid)
 2743      {
 2744          bytes memory calldata = abi.encodeWithSelector(
 2745              IValidator(signerAddress).isValidSignature.selector,
 2746              hash,
 2747              signerAddress,
 2748              signature
 2749          );
  ...
 4092          // Transaction always valid if signer is sender of transaction
 4093          if (signerAddress != msg.sender) {
 4094              // Validate signature
 4095              require(
 4096                  isValidSignature(
 4097                      transactionHash,
 4098                      signerAddress,
 4099                      signature
 4100                  ),
  ...
```

# Review notes (Review08, 2026-11-17)

Reads at block 26,431,454 (publicnode; the draft's block 26,431,214 is past the node's non-archive window).

Source: Sourcify full match, `Exchange.sol` (single flattened file), `MixinSignatureValidator.isValidSignature(bytes32,address,bytes)`
at lines 2521-2654: the last signature byte selects the type; `EIP712` (2) and `EthSign` (3) call `ecrecover` for any
`signerAddress`, with no code check; `Wallet` (4) staticcalls `isValidSignature(bytes32,bytes)` on the signer and expects
the 0x-specific magic `0xb0671381` (not the ERC-1271 `0x1626ba7e`); `Validator` (5) needs a prior
`setSignatureValidatorApproval` by the signer; `PreSigned` (6) needs a prior `preSign`.
Callers: `fillOrder` path (line 1611, maker signature on first fill) and `executeTransaction` (line 4092, any signer,
used for taker fills and cancels on behalf of the signer).

| Call | Result |
|---|---|
| `Exchange.owner()` | `0x7d3455421bbc5ed534a83c88fd80387dc8271392` (Blockscout name `ZeroExGovernor`) |
| `getAssetProxy(0xf47261b0)` ERC20 | `0x95e6f48254609a6ee006f7d493c8e5fb97094cef` |
| `getAssetProxy(0x02571792)` ERC721 | `0xefc70a1b18c432bdc64b596838b4d138f6bc6cad` |
| `getAssetProxy(0x94cfcdd7)` MultiAsset | `0xef701d5389ae74503d633396c4d654eabedc9d78` |
| `getAssetProxy(0xa7cb5fb7)` ERC1155 | `0x7eefbd48fd63d441ec7435d024ec7c5131019add` |
| ERC20Proxy `getAuthorizedAddresses()` | v2.1 Exchange `0x080bf510…`, MultiAssetProxy `0xef701d53…`, v3 Exchange `0x61935cbd…`, ZrxVault `0xba7f8b5f…` |
| ERC721/ERC1155 proxies `getAuthorizedAddresses()` | include `0x080bf510…` |
| every asset proxy `owner()` | `0x7d3455421bbc5ed534a83c88fd80387dc8271392` |
| `0x7d3455…` `getOwners()` / `required()` / `secondsTimeLocked()` | 4 owners (`0x257619b7…`, `0x5ee2a00f…`, `0xa2d6e86e…`, `0x269984c9…`), 2 required, 1,209,600 s default time lock |
| Exchange ETH/token balance | 0 (onchain.json, block 26,431,214) |
