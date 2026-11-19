---
id: eip-8151-own-signature-only-exit
title: "Funds or rights released only by the party's own ECDSA signature lock once that party has code under EIP-8151"
status: candidate
severity: HIGH
patterns: [PQ-16]
impact: funds-locked
contracts:
- {address: "0x09678741bd50c3e74301f38fbd0136307099ae5d", family: "afcdcf8075a5ec2aba20a474929c3d82", copies: 2, name: "LocalEthereumEscrows", label: "LocalEthereum 2", project: "localethereum", upgradeable: "no", rating: HIGH, value_usd: 8761, value_basis: "held", value_as_of: 2026-11-18, note: "LocalEthereum escrow v1: a dispute can be resolved only with a signature of the buyer or of the seller. Read by hand. Update path: no proxy slot, no upgrade function."}
- {address: "0xd60eea947aae39e507430b30ce11f142304d9cb1", family: "9299c0f31b2483e035bc87f424d5a94f", name: "PaymentChannels", upgradeable: "no", rating: HIGH, value_usd: 6594, value_basis: "held", value_as_of: 2026-11-18, recoveries_14d: 138, note: "PaymentChannels (newer, 138 recoveries in the window): as the older one: a staker starts or finishes an unstake only with its own ECDSA signature on a commitment; a staker whose account takes code…. Read by hand. Executed: a real transaction reverts with code at the signer. Update path: no proxy slot, no upgrade function."}
- {address: "0xede26ccc85ae521d06b5ef2604952a421c9124b6", family: "946542f811c596cddd93485f7d353f2b", name: "LocalCryptosETHEscrows", upgradeable: "no", rating: HIGH, value_usd: 6170, value_basis: "held", value_as_of: 2026-11-18, note: "LocalCryptos ETH escrow: a dispute can be resolved only with a signature of the buyer or of the seller. Read by hand. Update path: no proxy slot, no upgrade function."}
- {address: "0xda8b21b94668300ddbc0ecbaf57530d396287848", family: "14aa34f42cea291ad40ae28fc8637398", name: "LocalCoinSwapEthereumEscrow", upgradeable: "no", rating: HIGH, value_usd: 2215, value_basis: "held", value_as_of: 2026-11-18, note: "LocalCoinSwap ETH escrow (variant): a dispute can be resolved only with a signature of the buyer or of the seller. Read by hand. Update path: no proxy slot, no upgrade function."}
- {address: "0x0d7515af7a3f97f0678b0ac41a4408bbede25782", family: "d3e9357bd60bfdce33a50a998e3915ff", name: "BringTrade", upgradeable: "no", rating: HIGH, value_usd: 699, value_basis: "held", value_as_of: 2026-11-18, note: "BringTrade withdraw: the user's own EIP-712 signature and an APPROVE_ROLE signature; withdrawRequest also needs the user's signature; no direct or ERC-1271 path. Read. Update path: no proxy slot, no upgrade function."}
- {address: "0x9f543912b88b98b7a2729ab9dc713217e52c3c75", family: "19f602bc04cb48b2419d43e914a8712d", copies: 2, name: "LocalEthereumEscrows", upgradeable: "no", rating: HIGH, value_usd: 315, value_basis: "held", value_as_of: 2026-11-18, note: "LocalEthereum escrows: the arbitrator resolves a dispute only with the buyer's or seller's signature; same design as the filed LocalEthereum entry. Read. Update path: no proxy slot, no upgrade function."}
- {address: "0xe570ed5e3efff7bd706a8057b4dc37a3f0db6798", family: "c4830906b572de8b3f8722e3201f4d6e", copies: 7, name: "SignatureMerkleDrop128", upgradeable: "no", rating: HIGH, value_usd: 242, value_basis: "held", value_as_of: 2026-11-18, note: "1inch SignatureMerkleDrop128 claim: the account in the tree must sign to claim to a receiver; no direct claim. Read. Update path: no proxy slot, no upgrade function."}
- {address: "0xaeb12b5ab62a49c14e72fb3ad2c0e809a9b446b3", family: "5868423f7f310a6d8f152c403d2e95c4", copies: 2, name: "PirateLottery", upgradeable: "no", rating: HIGH, value_usd: 234, value_basis: "held", value_as_of: 2026-11-18, note: "PirateLottery claimPrize: the winning ticket's recorded owner must sign the claim; no claim without the signature. Read. Update path: no proxy slot, no upgrade function."}
- {address: "0xeb3a00bcb6c9ff626fe57a5dbbdcf01730e7898f", family: "d805e9543efffecc17f8dc897cc3ee17", name: "ZecSwap", upgradeable: "no", rating: HIGH, value_usd: 138, value_basis: "held", value_as_of: 2026-11-18, recoveries_14d: 3, note: "ZecSwap: user and maker authorise steps with ECDSA only (ecrecover == signer, no ERC-1271). A swap that pays into a shielded note can be paid only through payout, which needs the user's signature…. Read by hand. Executed: a real transaction reverts with code at the signer. Update path: no proxy slot, no upgrade function."}
- {address: "0x8b78bf6c12e35b9dfee7a97eb8899eef615a0b83", family: "d5e19f5c3ac74c6fa9496521d7b61020", name: "LocalCoinSwapDaiEscrow", upgradeable: "no", rating: HIGH, value_usd: 39, value_basis: "held", value_as_of: 2026-11-18, note: "LocalCoinSwap escrow (LocalEthereum fork): the arbitrator resolves a dispute only with the buyer's or seller's signature; same design as the filed LocalEthereum entry. Read. Update path: no proxy slot, no upgrade function."}
- {address: "0x9975e90fc7d9dc861a78b171428495e388468885", family: "1820f693ab9520e58f1dc197a5b98554", copies: 2, name: "LocalCoinSwapTetherEscrow", upgradeable: "no", rating: HIGH, value_usd: 11, value_basis: "held", value_as_of: 2026-11-18, note: "LocalCoinSwap escrow (LocalEthereum fork): the arbitrator resolves a dispute only with the buyer's or seller's signature; same design as the filed LocalEthereum entry. Read. Update path: no proxy slot, no upgrade function."}
- {address: "0x2f5e05a65f25d7bec3d8f02a9689cdf43eccd3e6", family: "d54dd91dc42dc30c395222a07c676a7a", copies: 3, name: "MerchantConsolidator", upgradeable: "no", rating: HIGH, recoveries_14d: 27, note: "the stored registrar signs every assignment; a change of the authorised recipient also needs a 65-byte ECDSA signature of the merchant (read): a merchant whose address has code cannot give it. Read by hand. Executed: a real transaction reverts with code at the signer. Update path: no proxy slot, no upgrade function."}
- {address: "0x7410dc72ea112a7b09e9380fd602836370cfe031", family: "3936b80dd9e3e56be5d3ee4e6b5cbcf1", upgradeable: "no", rating: HIGH, note: "Panther zAccount registration: the zAccount's master EOA is whatever address the registration signature recovers to (no ERC-1271, the caller does not count). An account with code can never be…. Read by hand. Update path: no proxy slot, no upgrade function."}
- {address: "0x3ea5eaaa2727a38f2a16151e8b85017f966e4656", family: "777e08a9ce4ae5874141449c0abf0ade", name: "SAClientERC20", upgradeable: "no", rating: MEDIUM, note: "SAClientERC20: tokens credited to a key address (saDest) move only by a relayed request signed by that key; no direct call. Read. Update path: no proxy slot, no upgrade function."}
- {address: "0xb40078c3871dcf6757e92f5369019fa20bf2bc15", family: "777e08a9ce4ae5874141449c0abf0ade", name: "SAClientERC20", upgradeable: "yes", rating: LOW, value_usd: 258, value_basis: "held", value_as_of: 2026-11-18, note: "SAClientERC20: tokens credited to a key address (saDest) move only by a relayed request signed by that key; no direct call. Read. Update path: proxy to 0x3ea5eaaa2727a38f2a16151e8b85017f966e4656, admin 0x0e46e654dc33f86bd9ee9b103a1bd3afdcc8d7de."}
- {address: "0xccad95719d3e26caf3b87dc73ea4a140a67c9510", family: "d54dd91dc42dc30c395222a07c676a7a", copies: 32, name: "MerchantConsolidator", upgradeable: "yes", rating: LOW, value_usd: 1, value_basis: "held", value_as_of: 2026-11-18, note: "the stored registrar signs every assignment; a change of the authorised recipient also needs a 65-byte ECDSA signature of the merchant (read): a merchant whose address has code cannot give it. Read by hand. Executed: a real transaction reverts with code at the signer. Update path: 7702 account: re-delegates."}
evidence: {level: executed, block: 26438999}
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, own funds only by one's own signature"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: [localcoinswap-relayer-signer]
reviews: []
---

## Summary

These contracts let a party act on its own funds or rights only with an ECDSA signature of its own address: no direct call, no ERC-1271. 16 code families, 59 addresses, $26k held, 168 recoveries in the study's two-week window. Rows by rating: HIGH 13, MEDIUM 1, LOW 2. 4 rows were checked on a real transaction; the others were read from source, judged from bytecode or placed by measured rules (each row's note says which).

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- Each row's note says how it was decided: read from verified source, judged from bytecode and function names, placed by a rule measured against hand readings, or executed: a real transaction replayed on the fork's reference implementation with only the precompile changed, state at block 26,438,999.
- ETHEscrowV2 `0x3a362a1966ff5aab35298e1565bda2c9fb124e41` and ERC20EscrowV2 `0xccb2718d633ed28bdf0639134380e2f5b05162b5`: `resolveDispute` requires `signer == buyer || signer == seller`. Executed: resolutions `0x34e6fa77b3850be07f6a71491781750c6a792c81c1ef5a51e29e02a91aa1b117` (ETH) and `0x47b43aced505820e8d2224d965b3bdf2c6c8b079b64f7ff0ef7228f210482ea0` (USDT) revert with code at the signing party; the escrow then waits 180 days for the operator's sweep.

## Impact and exposure

Largest rows by value held at block 26,438,999:
- `0x09678741bd50c3e74301f38fbd0136307099ae5d` (LocalEthereumEscrows): $9k, HIGH, 2 addresses
- `0xd60eea947aae39e507430b30ce11f142304d9cb1` (PaymentChannels): $7k, HIGH
- `0xede26ccc85ae521d06b5ef2604952a421c9124b6` (LocalCryptosETHEscrows): $6k, HIGH
- `0xda8b21b94668300ddbc0ecbaf57530d396287848` (LocalCoinSwapEthereumEscrow): $2k, HIGH
- `0x0d7515af7a3f97f0678b0ac41a4408bbede25782` (BringTrade): $699, HIGH
- `0x9f543912b88b98b7a2729ab9dc713217e52c3c75` (LocalEthereumEscrows): $315, HIGH, 2 addresses
- `0xb40078c3871dcf6757e92f5369019fa20bf2bc15` (SAClientERC20): $258, LOW
- `0xe570ed5e3efff7bd706a8057b4dc37a3f0db6798` (SignatureMerkleDrop128): $242, HIGH, 7 addresses
- `0xaeb12b5ab62a49c14e72fb3ad2c0e809a9b446b3` (PirateLottery): $234, HIGH, 2 addresses
- `0xeb3a00bcb6c9ff626fe57a5dbbdcf01730e7898f` (ZecSwap): $138, HIGH

Every row is in the header; `generated/triage_contracts.csv` lists them for search.

## Remediation

Act before migrating the address; new deployments accept ERC-1271 or a direct call.

## History

- 2026-11-19: filed from study `eip-8151-impact`, one entry per root issue (D-022). The per-project entries filed earlier that day are in git history (commit `d9c90af`).
- Full write-ups of the executed rows before the merge: [unidentified-3a362a19-escrow-dispute-party-code](https://github.com/kevaundray/pq-chain-analysis/blob/d9c90afac8137e134d5e884865dfc37bbcb0d397/triage/unidentified-3a362a19-escrow-dispute-party-code.md).
- 2026-11-19: 5 rows added with --add from `verdicts.csv`.
- 2026-11-19: 2 rows added with --add from `verdicts.csv`.
- 2026-11-19: rows rated by how hard the fix is, one row per family and update path (D-024).
