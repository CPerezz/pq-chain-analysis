---
id: eip-8151-own-signature-only-exit
title: "Funds or rights released only by the party's own ECDSA signature lock once that party has code under EIP-8151"
status: candidate
severity: CRITICAL
patterns: [PQ-16]
impact: funds-locked
contracts:
- {address: "0xccb2718d633ed28bdf0639134380e2f5b05162b5", family: "ba1ed685933342c5f46663c2bfeb2adf", name: "ERC20EscrowV2", upgradeable: "no", rating: CRITICAL, value_usd: 151583, value_basis: "held", value_as_of: 2026-11-18, recoveries_14d: 3984, note: "trade escrow in tokens, the same design as ETHEscrowV2 (its functions and caller checks listed by grep, ETH version read): direct release and buyerCancel, relayed signatures, disputes only with a…. Read by hand. Executed: a real transaction reverts with code at the signer."}
- {address: "0xa0fb83ad673bb6f0c8ce0a0024451888dddb0e83", family: "f37d66ccf0e1a2b64767777737114dec", copies: 2, name: "PaymentChannels", upgradeable: "no", rating: CRITICAL, value_usd: 101416, value_basis: "held", value_as_of: 2026-11-18, note: "PaymentChannels: a staker can start or finish an unstake only with its own ECDSA signature on a commitment, next to the notary's; there is no path without it, so a staker whose account takes code…. Read by hand."}
- {address: "0x2b78a837c37549539c62ab54a235a8e19fea812f", family: "1567048089bd6f48b2aaddca70022941", name: "CentWallet", label: "Cent.co: Wallet", upgradeable: "no", rating: CRITICAL, value_usd: 70017, value_basis: "held", value_as_of: 2026-11-18, note: "CentWallet: every function is for the admin only and takes the signature of a key linked to the wallet; a wallet whose linked keys all sit on accounts with code cannot withdraw. 39 ETH, no recovery…. Read by hand."}
- {address: "0x3a362a1966ff5aab35298e1565bda2c9fb124e41", family: "8343030030f4553952f8408c98f9bb4f", name: "ETHEscrowV2", upgradeable: "no", rating: CRITICAL, value_usd: 46197, value_basis: "held", value_as_of: 2026-11-18, recoveries_14d: 5121, note: "trade escrow in ETH (function map, resolveDispute and claimStuck read): seller and buyer settle by their own call (release, buyerCancel) or by a relayed signature; a dispute can be resolved by the…. Read by hand. Executed: a real transaction reverts with code at the signer."}
- {address: "0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6", family: "0d0deff0f3a759cfc98bad3d4001f3df", copies: 2, name: "CoordinationPaymentChannels", upgradeable: "no", rating: CRITICAL, value_usd: 15700, value_basis: "held", value_as_of: 2026-11-18, note: "CoordinationPaymentChannels: a staker withdraws only with its own ECDSA signature on a commitment next to the coordinator's; a staker whose account takes code cannot withdraw. Read by hand."}
- {address: "0x867ffb5a3871b500f65bdfafe0136f9667deae06", family: "583c5a3723df423540d14111dee85852", copies: 2, name: "LocalEthereumEscrows", label: "LocalEthereum 1", project: "localethereum", upgradeable: "no", rating: CRITICAL, value_usd: 12091, value_basis: "held", value_as_of: 2026-11-18, note: "LocalEthereum escrow: as LocalCoinSwap: a dispute can be resolved only with a signature of the buyer or of the seller. Read by hand."}
- {address: "0x09678741bd50c3e74301f38fbd0136307099ae5d", family: "afcdcf8075a5ec2aba20a474929c3d82", copies: 2, name: "LocalEthereumEscrows", label: "LocalEthereum 2", project: "localethereum", upgradeable: "no", rating: CRITICAL, value_usd: 8842, value_basis: "held", value_as_of: 2026-11-18, note: "LocalEthereum escrow v1: a dispute can be resolved only with a signature of the buyer or of the seller. Read by hand."}
- {address: "0xd60eea947aae39e507430b30ce11f142304d9cb1", family: "9299c0f31b2483e035bc87f424d5a94f", name: "PaymentChannels", upgradeable: "no", rating: CRITICAL, value_usd: 6496, value_basis: "held", value_as_of: 2026-11-18, recoveries_14d: 138, note: "PaymentChannels (newer, 138 recoveries in the window): as the older one: a staker starts or finishes an unstake only with its own ECDSA signature on a commitment; a staker whose account takes code…. Read by hand. Executed: a real transaction reverts with code at the signer."}
- {address: "0xede26ccc85ae521d06b5ef2604952a421c9124b6", family: "946542f811c596cddd93485f7d353f2b", name: "LocalCryptosETHEscrows", upgradeable: "no", rating: CRITICAL, value_usd: 6136, value_basis: "held", value_as_of: 2026-11-18, note: "LocalCryptos ETH escrow: a dispute can be resolved only with a signature of the buyer or of the seller. Read by hand."}
- {address: "0xda8b21b94668300ddbc0ecbaf57530d396287848", family: "14aa34f42cea291ad40ae28fc8637398", name: "LocalCoinSwapEthereumEscrow", upgradeable: "no", rating: CRITICAL, value_usd: 2165, value_basis: "held", value_as_of: 2026-11-18, note: "LocalCoinSwap ETH escrow (variant): a dispute can be resolved only with a signature of the buyer or of the seller. Read by hand."}
- {address: "0xeb3a00bcb6c9ff626fe57a5dbbdcf01730e7898f", family: "d805e9543efffecc17f8dc897cc3ee17", name: "ZecSwap", upgradeable: "no", rating: CRITICAL, value_usd: 180, value_basis: "held", value_as_of: 2026-11-18, recoveries_14d: 3, note: "ZecSwap: user and maker authorise steps with ECDSA only (ecrecover == signer, no ERC-1271). A swap that pays into a shielded note can be paid only through payout, which needs the user's signature…. Read by hand. Executed: a real transaction reverts with code at the signer."}
- {address: "0xccad95719d3e26caf3b87dc73ea4a140a67c9510", family: "d54dd91dc42dc30c395222a07c676a7a", copies: 35, name: "MerchantConsolidator", upgradeable: "no", rating: CRITICAL, recoveries_14d: 27, note: "the stored registrar signs every assignment; a change of the authorised recipient also needs a 65-byte ECDSA signature of the merchant (read): a merchant whose address has code cannot give it. Read by hand. Executed: a real transaction reverts with code at the signer."}
- {address: "0x7410dc72ea112a7b09e9380fd602836370cfe031", family: "3936b80dd9e3e56be5d3ee4e6b5cbcf1", upgradeable: "no", rating: CRITICAL, recoveries_14d: 3, note: "Panther zAccount registration: the zAccount's master EOA is whatever address the registration signature recovers to (no ERC-1271, the caller does not count). An account with code can never be…. Read by hand."}
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

These contracts let a party act on its own funds or rights only with an ECDSA signature of its own address: no direct call, no ERC-1271. 13 code families, 51 addresses, $421k held, 9,276 recoveries in the study's two-week window. Rows by rating: CRITICAL 13. 5 rows were checked on a real transaction; the others were read from source, judged from bytecode or placed by measured rules (each row's note says which).

## Mechanism

PQ-16. Once the party's account has real code the signature recovers no address, and nobody else can act for it unless an administrator can.

## Evidence

- Each row's note says how it was decided: read from verified source, judged from bytecode and function names, placed by a rule measured against hand readings, or executed: a real transaction replayed on the fork's reference implementation with only the precompile changed, state at block 26,438,999.
- ETHEscrowV2 `0x3a362a1966ff5aab35298e1565bda2c9fb124e41` and ERC20EscrowV2 `0xccb2718d633ed28bdf0639134380e2f5b05162b5`: `resolveDispute` requires `signer == buyer || signer == seller`. Executed: resolutions `0x34e6fa77b3850be07f6a71491781750c6a792c81c1ef5a51e29e02a91aa1b117` (ETH) and `0x47b43aced505820e8d2224d965b3bdf2c6c8b079b64f7ff0ef7228f210482ea0` (USDT) revert with code at the signing party; the escrow then waits 180 days for the operator's sweep.

## Impact and exposure

Largest rows by value held at block 26,438,999:
- `0xccb2718d633ed28bdf0639134380e2f5b05162b5` (ERC20EscrowV2): $152k, CRITICAL
- `0xa0fb83ad673bb6f0c8ce0a0024451888dddb0e83` (PaymentChannels): $101k, CRITICAL, 2 addresses
- `0x2b78a837c37549539c62ab54a235a8e19fea812f` (CentWallet): $70k, CRITICAL
- `0x3a362a1966ff5aab35298e1565bda2c9fb124e41` (ETHEscrowV2): $46k, CRITICAL
- `0x2f06f0df5433fd9ed67845ef6bcc1f50be4117a6` (CoordinationPaymentChannels): $16k, CRITICAL, 2 addresses
- `0x867ffb5a3871b500f65bdfafe0136f9667deae06` (LocalEthereumEscrows): $12k, CRITICAL, 2 addresses
- `0x09678741bd50c3e74301f38fbd0136307099ae5d` (LocalEthereumEscrows): $9k, CRITICAL, 2 addresses
- `0xd60eea947aae39e507430b30ce11f142304d9cb1` (PaymentChannels): $6k, CRITICAL
- `0xede26ccc85ae521d06b5ef2604952a421c9124b6` (LocalCryptosETHEscrows): $6k, CRITICAL
- `0xda8b21b94668300ddbc0ecbaf57530d396287848` (LocalCoinSwapEthereumEscrow): $2k, CRITICAL

Every row is in the header; `generated/triage_contracts.csv` lists them for search.

## Remediation

Act before migrating the address; new deployments accept ERC-1271 or a direct call.

## History

- 2026-11-19: filed from study `eip-8151-impact`, one entry per root issue (D-022). The per-project entries filed earlier that day are in git history (commit `d9c90af`).
- Full write-ups of the executed rows before the merge: [unidentified-3a362a19-escrow-dispute-party-code](https://github.com/kevaundray/pq-chain-analysis/blob/d9c90afac8137e134d5e884865dfc37bbcb0d397/triage/unidentified-3a362a19-escrow-dispute-party-code.md).
