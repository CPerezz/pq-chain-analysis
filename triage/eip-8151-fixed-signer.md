---
id: eip-8151-fixed-signer
title: "Contracts whose signer is fixed in code stop once that signer's account has code under EIP-8151"
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- {address: "0xb1d39657ca16fd08883c5fbb03e1488457a285e3", family: "ebf836d3bd23273c3fe8565057a69d08", copies: 161, upgradeable: "no", rating: HIGH, recoveries_14d: 8, note: "161 ERC-1271 contracts answering for an operator that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer. Update path: no proxy slot, no upgrade function."}
- {address: "0x83fcaef2230ec6f36d84717c2222817431e9b377", family: "de4f706dd2fabf52beef2f4658d0ad05", label: "deployed by moneycanbuy.fun: Deployer", upgradeable: "no", rating: HIGH, recoveries_14d: 2, note: "attestations signed by an oracle signer that is a constant in the code. Bytecode and names. Executed: a real transaction loses its effect with code at the signer. Update path: no proxy slot, no upgrade function."}
- {address: "0x87c3f2c6f12e68e7722cdb7bb11b1befb33f98c5", family: "d46ae5492b72427ba9c8d254d76b0509", copies: 2, upgradeable: "no", rating: HIGH, recoveries_14d: 2, note: "forwarding addresses (4) whose sweeps need a fixed party's signature; inferred. Bytecode and names. Executed: a real transaction reverts with code at the signer. Update path: no proxy slot, no upgrade function."}
- {address: "0x49bf3845f50d6ae4529d300516643e526ead262e", family: "abc52467f6aec5a0471827d5d5208f2b", copies: 204, upgradeable: "no", rating: HIGH, note: "204 ERC-1271 clones answering for a signer that is a constant in the code. Bytecode and names. Update path: delegates to a fixed address."}
- {address: "0x8f31f2d7dad5221b12143e2bfa2f32faecd97bc1", family: "5aef529fb528017b9c9da9cca29b04db", upgradeable: "no", rating: HIGH, note: "Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own. Update path: no proxy slot, no upgrade function."}
- {address: "0x6081d7f04a8c31e929f25152d4ad37c83638c62b", family: "9ae269e9cefd61add8d83e053edc37bf", name: "DevRewardDistributor", upgradeable: "no", rating: MEDIUM, value_usd: 38, value_basis: "held", value_as_of: 2026-11-18, note: "DevRewardDistributor.claimTokens: a signed claim gate; quick read, no setter found, value at this address is 0.021 ETH. Placed by contract type, not checked in source."}
- {address: "0x00000063f648c943346d2a239f0969bad32ff184", family: "722b00ab7bc038485569f0e344138c52", upgradeable: "no", rating: MEDIUM, value_usd: 17, value_basis: "held", value_as_of: 2026-11-18, note: "Operator bot (unverified): the recovered address must be a stored key that no function replaces (card; no address setter in the decompile); holds nothing. Bytecode."}
- {address: "0x80eabd6df366b62fbb970029363c3e52eff00953", family: "7163e52d8dfe75a07b2c68225439a20a", upgradeable: "no", rating: MEDIUM, value_usd: 14, value_basis: "held", value_as_of: 2026-11-18, note: "Operator bot (unverified): calls made on a signed request must recover to the constant key 0x14400c74; holds nothing. Bytecode."}
- {address: "0xe44a2179edab1e638eac86079fe4ed850ca77b6c", family: "269fa83ae386e5e0a2362f0fc569b37d", upgradeable: "no", rating: MEDIUM, value_usd: 5, value_basis: "held", value_as_of: 2026-11-18, note: "Operator bot (unverified): calls made on a signed request must recover to the constant key 0x14400c74; holds nothing. Bytecode."}
- {address: "0xaf0b0000f0210d0f421f0009c72406703b50506b", family: "ae7c99d8c64e940199ef1ccd3f5dcfa6", upgradeable: "no", rating: MEDIUM, value_usd: 1, value_basis: "held", value_as_of: 2026-11-18, note: "Operator bot (unverified): the recovered address must be a stored key that no function replaces (card; no address setter in the decompile); holds nothing. Bytecode."}
- {address: "0xe2f011b751bc2421ce0618bff526ad3de582ce7d", family: "259218ec8ad7c226a793cd8d3557f133", upgradeable: "no", rating: MEDIUM, value_usd: 1, value_basis: "held", value_as_of: 2026-11-18, note: "Operator bot (unverified): calls made on a signed request must recover to the constant key 0x14400c74; holds nothing. Bytecode."}
- {address: "0x19445bb9f1b704dd973f8f9a4dce5ea5e55444da", family: "ddc4a91b2a4188e6082de44483a490d8", name: "AppliedPrimateEngineering", upgradeable: "no", rating: MEDIUM, note: "AppliedPrimateEngineering._validateAttributeSignature: an attribute-update gate, no funds; quick read. Placed by contract type, not checked in source."}
- {address: "0x241357313e802e16eeb9380f2b027224e90b56dd", family: "79ff8521e54d5889e28ada48f505300d", name: "MaskDAO", upgradeable: "no", rating: MEDIUM, note: "MaskDAO.claim: _signer (an airdrop-claim authority) is set once in the constructor, no setter found; mints to msg.sender on a valid claim, so only the claim stops, no funds at risk. Read."}
- {address: "0x4f2ba7296391ab85ce4f4fc9f64608db6a267101", family: "64e9cd85a9e1a1ab70f2642a3874ab8e", copies: 4, name: "AngryDinos", label: "Angry Dinos: AD Token", upgradeable: "no", rating: MEDIUM, note: "AngryDinos.whitelistMint: an allowlist mint gate only, no funds; quick read, no setter found. Placed by contract type, not checked in source."}
- {address: "0x7a30f7736e48d6599356464ba4c150d8da0302ff", family: "86d647c02e9befc67125c8206bbfbc21", copies: 2, upgradeable: "no", rating: MEDIUM, note: "Oracle-confirmed operations (unverified; 2023): confirmations must come from the oracle set, which no function writes after construction. Bytecode."}
- {address: "0xb1160236017bbc3fe961957a785e24efd808c0cc", family: "50ec7f1f4326388a5710eb1c24f7366e", copies: 2, name: "PokeRaidHookV2", upgradeable: "no", rating: MEDIUM, note: "PokeRaidHookV2._resolveAuthenticatedUser: a Uniswap v4 game hook's user-authentication gate, no funds beyond the swap itself; quick read. Placed by contract type, not checked in source."}
- {address: "0xbe47e195607e408dc1ede1d67bfaed6187197ead", family: "f4b679e9afd7cdfaed93ec8d67173e85", name: "SCAIGenesis", upgradeable: "no", rating: MEDIUM, note: "SCAIGenesis presalePurchase: the same coupon-mint-gate pattern as SatoshiIslandCitizenshipNFTs; a failed check reverts the paid mint atomically. Placed by contract type, not checked in source."}
- {address: "0xc54567b294d7ec7807529fbaec71d326543453c5", family: "bb621d94ea877648689f0cdb1c49c0ca", name: "CoinStatsGLXY", label: "CoinStatsGLXY: GLXY Token", upgradeable: "no", rating: MEDIUM, note: "CoinStatsGLXY.mint: SignatureHelper.signer is set once in the constructor, no setter found; gates a free mint only, no funds. Read."}
- {address: "0xf1f3ca6268f330fda08418db12171c3173ee39c9", family: "751ef665538fea40b10046695e938f2b", name: "Zapper_NFT_V2_0_1", label: "Zapper: ZPR NFT Token", upgradeable: "no", rating: MEDIUM, note: "Zapper_NFT_V2 claimVolts: SignatureVerifier_V2's signer is set once in the constructor, no setter found anywhere in Zapper_NFT_V2 or its base; Volts are an in-app point balance, not a held asset, so…. Read."}
evidence: {level: executed, block: 26438999}
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, fixed key: pool or service"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: [clipper-designated-signer, unidentified-1c6ad754-signer-key, unidentified-fbeedcfe-signer-key]
reviews: []
---

## Summary

These contracts accept signatures only from a key fixed in their code (operator, issuer, quote or claim signer). 64 code families, 4,758 addresses, $621 held, 856 recoveries in the study's two-week window. Rows by rating: HIGH 30, MEDIUM 34. 10 rows were checked on a real transaction; the others were read from source, judged from bytecode or placed by measured rules (each row's note says which).

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- Each row's note says how it was decided: read from verified source, judged from bytecode and function names, placed by a rule measured against hand readings, or executed: a real transaction replayed on the fork's reference implementation with only the precompile changed, state at block 26,438,999.

## Impact and exposure

Largest rows by value held at block 26,438,999:
- `0x585207660179242b75559a0365acd54b6f877508` (unverified): $545, HIGH
- `0x6081d7f04a8c31e929f25152d4ad37c83638c62b` (DevRewardDistributor): $38, MEDIUM
- `0x00000063f648c943346d2a239f0969bad32ff184` (unverified): $17, MEDIUM
- `0x80eabd6df366b62fbb970029363c3e52eff00953` (unverified): $14, MEDIUM
- `0xe44a2179edab1e638eac86079fe4ed850ca77b6c` (unverified): $5, MEDIUM
- `0xaf0b0000f0210d0f421f0009c72406703b50506b` (unverified): $1, MEDIUM
- `0xe2f011b751bc2421ce0618bff526ad3de582ce7d` (unverified): $1, MEDIUM

Every row is in the header.

## Remediation

The operator keeps the signing key without code, or moves users to a new deployment.

## History

- 2026-11-19: filed from study `eip-8151-impact`, one entry per root issue (D-022). The per-project entries filed earlier that day are in git history (commit `d9c90af`).
- 2026-11-19: 58 rows added with --add from `verdicts.csv`.
- 2026-11-19: 76 rows added with --add from `verdicts.csv`.
- 2026-11-19: rows rated by how hard the fix is, one row per family and update path (D-024).
- 2026-11-20: 5 rows added with --add from `verdicts.csv`.
- 2026-11-20: 25 rows added from gate-1 `verdicts.csv`.
- 2026-11-20: 10 rows added from gate-1 `verdicts.csv`.
