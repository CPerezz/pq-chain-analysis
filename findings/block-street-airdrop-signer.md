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
  links:
  - evidence/block-street-airdrop-signer/classification.jsonl
  - evidence/block-street-airdrop-signer/onchain.json
  - evidence/block-street-airdrop-signer/activity.json
  - evidence/block-street-airdrop-signer/source-excerpts.md
  - evidence/block-street-airdrop-signer/bytecode-notes.md
sources:
- by: ai-assisted
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  ref: data/curation/out_1.jsonl
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
- Read from bytecode (no verified source): [`bytecode-notes.md`](../evidence/block-street-airdrop-signer/bytecode-notes.md).

## Evidence

- CHECKED (bytecode, `cast selectors`/`cast 4byte`/`cast disassemble`, 2026-11-17): selectors and the claim path above,
  including the `STATICCALL` to `0x01` and the comparison with the stored signer. Not verified on Sourcify or Blockscout;
  `evidence.level` stays `bytecode`.
- CHECKED (on-chain reads at block ~26,431,500): `owner()` = `0x39830bb4…` (EOA, also the deployer per Blockscout);
  `signer()` = `0x7777ca93…` (EOA, nonce 0); `token()` = BSB `0xdb6ba5d5…`; `isEnded()` false; `totalClaimed()`
  1,024,511 BSB; BSB balance 225,489.
- CHECKED (on-chain read at block 26,431,214): not a proxy; holdings USD 16,534
  ([`onchain.json`](../evidence/block-street-airdrop-signer/onchain.json)); Blockscout prices BSB at USD 0.073252.
- CHECKED (Xatu, any function): 14 transactions 2026-10-16 to 2026-11-16, last on 2026-10-18
  ([`activity.json`](../evidence/block-street-airdrop-signer/activity.json)); 45,209 transactions with an `ecrecover`
  call in the year to March 2026 (`txs_y1`, `data/report/curated_contracts.csv`).

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

- 2026-11-04: classified from verified source or bytecode (hand classification pass; `data/curation/`).
- 2026-11-17: finding created by `scripts/15_findings.py` from that classification, on-chain state at block 26,431,214 and activity 2026-10-16 to 2026-11-16. Rated MEDIUM (step 4: fix by an upgrade, a new verifier or signer contract the admin points at, or a new deployment).
- 2026-11-17 review (Review19): MEDIUM -> LOW, step 5: MEDIUM by the fix (owner ends the airdrop and redeploys), under USD 50k held (USD 16.5k). Claim path confirmed from disassembly (ecrecover against `signer()` over sender, amount, deadline, chain, contract); status candidate -> confirmed (bytecode).
