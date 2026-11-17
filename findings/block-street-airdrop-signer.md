---
id: block-street-airdrop-signer
title: "Block Street BSB airdrop: one ECDSA claim-signer key authorises every claim, so a quantum attacker who recovers it can claim the remaining BSB (about USD 16.5k) from the airdrop contract"
project: block-street
status: confirmed
severity: LOW
patterns: [PQ-4]
primitives: [ecrecover]
trigger: operator-key
impact: funds-loss
alternative: key-rotation-only
role: core
contracts:
- address: "0x974b08e3ca65406451cb5867c032eb276fcf90b4"
  implementation: null
  name: BSB airdrop claim contract (unverified; claim/setSigner/endAirdrop/withdrawRemaining)
  upgradeable: config-only
  admin: owner EOA 0x39830bb4a204278e7d2efd6ae6da50454add9999 (setSigner, endAirdrop, withdrawRemaining); signer EOA 0x7777ca93a25733502999ffff9eeb9ca139e35629 (read at block ~26,431,500)
  value_usd: 16534
  value_basis: held
  value_as_of: 2026-11-17
  last_active: 2026-10-18
  txs_30d: 14
families: []
fix:
  layer: new-deployment
  who_acts: owner EOA 0x39830bb4a204278e7d2efd6ae6da50454add9999 ends the airdrop and withdraws the remaining BSB (endAirdrop, withdrawRemaining), and redeploys claims as a Merkle distribution or with a post-quantum signer
  protocol_change: not-needed
evidence:
  level: bytecode
  block: 26431214
  raw: https://github.com/kevaundray/pq-chain-analysis/tree/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/block-street-airdrop-signer
sources:
- by: ai-assisted
  study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/out_1.jsonl
  date: 2026-11-04
  verdict: reported
  rating: ''
related: []
---

## Summary

The Block Street (BSB) airdrop contract `0x974b08e3…` releases BSB to whoever presents a claim signed by one
off-chain ECDSA key, `signer()` = `0x7777ca93…` (PQ-4). Every claim transaction carries such a signature, so the key's
public key is on-chain; a CRQC holder who recovers it can sign claims for any amount to fresh addresses and empty the
contract. It holds 225,489 BSB (USD 16.5k on 2026-11-17). The owner can only rotate the signer to another ECDSA key, or
end the airdrop and withdraw the rest. Rated LOW: MEDIUM by the fix (step 4: a new deployment by the owner), lowered one
level because under USD 50k is exposed (step 5).

## Mechanism

- `claim(amount, deadline, signature)` (selector `0x5eddd157`): requires the airdrop not ended, `!hasClaimed[msg.sender]`,
  a deadline within 300 s, and `amount > 0`; hashes `abi.encodePacked(msg.sender, amount, deadline, chainid,
  address(this))` under the `"\x19Ethereum Signed Message:\n32"` prefix; recovers the signer with OpenZeppelin `ECDSA`
  (precompile `0x01`) and requires it to equal `signer()`; then transfers `amount` BSB to `msg.sender`.
- One claim per address, but the signed amount is free: a forged signer can claim the whole balance in one call.
- `setSigner(address)` (owner) only swaps one ECDSA key for another; `endAirdrop()` and `withdrawRemaining(address)`
  (owner) stop claims and move the balance out.
- Read from bytecode (no verified source): [`bytecode-notes.md`](#bytecode-and-state-reads-block-street-airdrop-signer).

## Evidence

- CHECKED (bytecode, `cast selectors`/`cast 4byte`/`cast disassemble`, 2026-11-17): selectors and the claim path above,
  including the `STATICCALL` to `0x01` and the comparison with the stored signer. Not verified on Sourcify or Blockscout;
  `evidence.level` stays `bytecode`.
- CHECKED (on-chain reads at block ~26,431,500): `owner()` = `0x39830bb4…` (EOA, also the deployer per Blockscout);
  `signer()` = `0x7777ca93…` (EOA, nonce 0); `token()` = BSB `0xdb6ba5d5…`; `isEnded()` false; `totalClaimed()`
  1,024,511 BSB; BSB balance 225,489.
- CHECKED (on-chain read at block 26,431,214): not a proxy; holdings USD 16,534
  ([`onchain.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/block-street-airdrop-signer/onchain.json)); Blockscout prices BSB at USD 0.073252.
- CHECKED (Xatu, any function): 14 transactions 2026-10-16 to 2026-11-16, last on 2026-10-18
  ([`activity.json`](https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/evidence/block-street-airdrop-signer/activity.json)); 45,209 transactions with an `ecrecover`
  call in the year to March 2026 (`txs_y1`, `studies/top-callers-classification/results/curated_contracts.csv`).

## Impact and exposure

| Contract | Upgradeable | Held now | Last active | 30-day txs |
|---|---|---|---|---|
| `0x974b08e3…` BSB airdrop claim contract | config-only | $16.5k | 2026-10-18 | 14 |

Exposure is the contract's own BSB balance (basis `held`). The forged key cannot mint BSB or touch other contracts. No
other Block Street contract was found calling `ecrecover` in the curated set.

## Remediation

- Owner `0x39830bb4…`: call `endAirdrop()` and `withdrawRemaining(...)` once claims are done, and run any further
  distribution as a Merkle-root claim (hash-based, post-quantum safe) or with a post-quantum signature verifier. Rotating
  the signer with `setSigner` does not help.
- No protocol change needed. Claimants cannot protect the pool themselves.

## History

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `https://github.com/kevaundray/pq-chain-analysis/blob/b0951d2b2e136d18e43266b184e4589157eb8c73/data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review19): MEDIUM -> LOW, step 5: MEDIUM by the fix (owner ends the airdrop and redeploys), under USD 50k held (USD 16.5k). Claim path confirmed from disassembly (ecrecover against `signer()` over sender, amount, deadline, chain, contract); status candidate -> confirmed (bytecode).

# Source excerpts: block-street-airdrop-signer

Lines around the pre-quantum checks in verified source (Sourcify, else Blockscout). Generated by scripts/14_excerpts.py.

## Contract `0x974b08e3ca65406451cb5867c032eb276fcf90b4`

No verified source on Sourcify or Blockscout.

# Bytecode and state reads: block-street-airdrop-signer

Contract `0x974b08e3ca65406451cb5867c032eb276fcf90b4` (2,755 bytes, not verified on Sourcify or Blockscout; Blockscout
creator `0x39830bb4a204278e7d2efd6ae6da50454add9999`). Read 2026-11-17 with `cast` against
`ethereum-rpc.publicnode.com` at latest (block about 26,431,500).

## Selectors (`cast selectors`, names from `cast 4byte`)

`claim(uint256,uint256,bytes)` 0x5eddd157, `signer()` 0x238ac933, `setSigner(address)` 0x6c19e783, `endAirdrop()`
0x726b5bad, `isEnded()` 0xa4fd6f56, `withdrawRemaining(address)` 0xfd0cdcdb, `hasClaimed(address)` 0x73b2e80e,
`claimedAmount(address)` 0x04e86903, `totalClaimed()` 0xd54ad2a1, `token()` 0xfc0c546a, OpenZeppelin `Ownable`
(`owner`, `transferOwnership`, `renounceOwnership`, error `OwnableUnauthorizedAccount` 0x118cdaa7).

## Claim path (`cast disassemble`)

`claim(amount, deadline, signature)`: reentrancy guard (ERC-7201 slot `0x9b779b17…`); revert if the ended flag in slot 1
is set; revert if `hasClaimed[msg.sender]`; require `deadline > block.timestamp` and `deadline <= block.timestamp + 300`;
require `amount > 0`; digest = `keccak256(abi.encodePacked(msg.sender, amount, deadline, chainid, address(this)))`
wrapped with `"\x19Ethereum Signed Message:\n32"`; OpenZeppelin `ECDSA` (s-value bound
`0x7fff…5d576e7357a4501ddfe92f46681b20a0`) then `STATICCALL` to precompile `0x01`; the recovered address must equal
the signer stored in slot 1; then `balanceOf(this)` on BSB and `transfer(msg.sender, amount)`.

## State

| Read | Value |
|---|---|
| `owner()` | `0x39830bb4a204278e7d2efd6ae6da50454add9999` (no code: EOA) |
| `signer()` | `0x7777ca93a25733502999ffff9eeb9ca139e35629` (no code, nonce 0: signs off-chain only) |
| `token()` | `0xdb6ba5d510f114f9b2ea08bea7d30e32eee33411` (BSB, "Block Street") |
| `isEnded()` | false |
| `totalClaimed()` | 1,024,511.16 BSB |
| BSB `balanceOf(contract)` | 225,488.84 BSB |
| Blockscout token-balances (2026-11-17) | BSB at USD 0.073252 = USD 16,517; USDT 16.23; HEX and ETIM dust |
