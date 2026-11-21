---
id: eip-8151-fixed-signer
title: "Contracts whose signer is fixed in code stop once that signer's account has code under EIP-8151"
status: candidate
severity: HIGH
patterns: [PQ-17]
impact: funds-locked
contracts:
- {address: "0x585207660179242b75559a0365acd54b6f877508", family: "ada95977ac269797f5d3f353519265c5", upgradeable: "no", rating: HIGH, value_usd: 545, value_basis: "held", value_as_of: 2026-11-18, note: "Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own. Update path: no proxy slot, no upgrade function."}
- {address: "0xa8dcdf1f1d624d37949b54c34e9a85394c72936a", family: "312db0016986261bda8a7a4f59a5190f", copies: 7, name: "DaimoPayPricer", upgradeable: "no", rating: HIGH, recoveries_14d: 844, note: "DaimoPay pricer: the signer must be trustedSigner, fixed in the code. Read from source. Executed: a real transaction reverts with code at the signer. Update path: no proxy slot, no upgrade function."}
- {address: "0xb1d39657ca16fd08883c5fbb03e1488457a285e3", family: "ebf836d3bd23273c3fe8565057a69d08", copies: 161, upgradeable: "no", rating: HIGH, recoveries_14d: 8, note: "161 ERC-1271 contracts answering for an operator that is a constant in the code. Bytecode and names. Executed: a real transaction reverts with code at the signer. Update path: no proxy slot, no upgrade function."}
- {address: "0x83fcaef2230ec6f36d84717c2222817431e9b377", family: "de4f706dd2fabf52beef2f4658d0ad05", label: "deployed by moneycanbuy.fun: Deployer", upgradeable: "no", rating: HIGH, recoveries_14d: 2, note: "attestations signed by an oracle signer that is a constant in the code. Bytecode and names. Executed: a real transaction loses its effect with code at the signer. Update path: no proxy slot, no upgrade function."}
- {address: "0x87c3f2c6f12e68e7722cdb7bb11b1befb33f98c5", family: "d46ae5492b72427ba9c8d254d76b0509", copies: 2, upgradeable: "no", rating: HIGH, recoveries_14d: 2, note: "forwarding addresses (4) whose sweeps need a fixed party's signature; inferred. Bytecode and names. Executed: a real transaction reverts with code at the signer. Update path: no proxy slot, no upgrade function."}
- {address: "0x259c2ff4e10e7e2b31a2045c93ed8513299c8e04", family: "99f423b19277c7cbe0fe3c25248edb4f", name: "WarStaking", upgradeable: "no", rating: HIGH, note: "WarStaking.leaveWar: SIGNER is a fixed constant with no setter found; _leaveWar is only reachable from this one signed entry point, and no unsigned unstake was found in the time available, so staked…. Read."}
- {address: "0x49bf3845f50d6ae4529d300516643e526ead262e", family: "abc52467f6aec5a0471827d5d5208f2b", copies: 204, upgradeable: "no", rating: HIGH, note: "204 ERC-1271 clones answering for a signer that is a constant in the code. Bytecode and names. Update path: delegates to a fixed address."}
- {address: "0x8f31f2d7dad5221b12143e2bfa2f32faecd97bc1", family: "5aef529fb528017b9c9da9cca29b04db", upgradeable: "no", rating: HIGH, note: "Presale: deposit and claim need a signature of SIGNER, fixed in the code. Same code idiom as template 80af2596, not read on its own. Update path: no proxy slot, no upgrade function."}
- {address: "0xc7335a836ad85a6ac0830c6cef602d735b9d8a8a", family: "1297dfe34193cc428e67d851fe69c8d3", name: "SwarmWorkOracle", upgradeable: "no", rating: HIGH, note: "SwarmFeed: the attestation must be signed by `attester`, fixed in the code / SwarmFeed._recover: returns the signer. Read (function text). Update path: no proxy slot, no upgrade function."}
- {address: "0x6081d7f04a8c31e929f25152d4ad37c83638c62b", family: "9ae269e9cefd61add8d83e053edc37bf", name: "DevRewardDistributor", upgradeable: "no", rating: MEDIUM, value_usd: 38, value_basis: "held", value_as_of: 2026-11-18, note: "DevRewardDistributor.claimTokens: a signed claim gate; quick read, no setter found, value at this address is 0.021 ETH. Placed by contract type, not checked in source."}
- {address: "0x00000063f648c943346d2a239f0969bad32ff184", family: "722b00ab7bc038485569f0e344138c52", upgradeable: "no", rating: MEDIUM, value_usd: 17, value_basis: "held", value_as_of: 2026-11-18, note: "Operator bot (unverified): the recovered address must be a stored key that no function replaces (card; no address setter in the decompile); holds nothing. Bytecode."}
- {address: "0x80eabd6df366b62fbb970029363c3e52eff00953", family: "7163e52d8dfe75a07b2c68225439a20a", upgradeable: "no", rating: MEDIUM, value_usd: 14, value_basis: "held", value_as_of: 2026-11-18, note: "Operator bot (unverified): calls made on a signed request must recover to the constant key 0x14400c74; holds nothing. Bytecode."}
- {address: "0xe44a2179edab1e638eac86079fe4ed850ca77b6c", family: "269fa83ae386e5e0a2362f0fc569b37d", upgradeable: "no", rating: MEDIUM, value_usd: 5, value_basis: "held", value_as_of: 2026-11-18, note: "Operator bot (unverified): calls made on a signed request must recover to the constant key 0x14400c74; holds nothing. Bytecode."}
- {address: "0xaf0b0000f0210d0f421f0009c72406703b50506b", family: "ae7c99d8c64e940199ef1ccd3f5dcfa6", upgradeable: "no", rating: MEDIUM, value_usd: 1, value_basis: "held", value_as_of: 2026-11-18, note: "Operator bot (unverified): the recovered address must be a stored key that no function replaces (card; no address setter in the decompile); holds nothing. Bytecode."}
- {address: "0xe2f011b751bc2421ce0618bff526ad3de582ce7d", family: "259218ec8ad7c226a793cd8d3557f133", upgradeable: "no", rating: MEDIUM, value_usd: 1, value_basis: "held", value_as_of: 2026-11-18, note: "Operator bot (unverified): calls made on a signed request must recover to the constant key 0x14400c74; holds nothing. Bytecode."}
- {address: "0x0000005c9426e6910f22f0c00ed3690a4884dd6e", family: "eb04fedbe0a3cf33de991960f14b5617", copies: 6, upgradeable: "no", rating: MEDIUM, note: "Operator bot (unverified): the recovered address must be a stored key that no function replaces (card; no address setter in the decompile); holds nothing. Bytecode."}
- {address: "0x000000cce580fb2b76b2d1196c237db199d82505", family: "2d0dc8d9480e22928cd6b1e0d5dff982", upgradeable: "no", rating: MEDIUM, note: "Operator bot (unverified): the recovered address must be a stored key that no function replaces (card; no address setter in the decompile); holds nothing. Bytecode."}
- {address: "0x000d2d31815990fca6f69dfd978c4d4a56b2ed6b", family: "6940c3a52092c3a5c97356fe640de931", name: "TrueProfileLogic", upgradeable: "no", rating: MEDIUM, note: "TrueProfileLogic (second family, same contract shape as 08687f12). Placed by contract type, not checked in source."}
- {address: "0x19445bb9f1b704dd973f8f9a4dce5ea5e55444da", family: "ddc4a91b2a4188e6082de44483a490d8", name: "AppliedPrimateEngineering", upgradeable: "no", rating: MEDIUM, note: "AppliedPrimateEngineering._validateAttributeSignature: an attribute-update gate, no funds; quick read. Placed by contract type, not checked in source."}
- {address: "0x20bd0551f05dc40117d6b91dfa9f67d25307d1d8", family: "be5ae432f342bf3e43af83fb9c0905b1", name: "AbnormalJean", label: "Abnormal Jean: JEAN Token", upgradeable: "no", rating: MEDIUM, note: "AbnormalJean.purchase: the same whitelist-signer pattern and conclusion as LovelessCityMetropass (shared code). Placed by contract type, not checked in source."}
- {address: "0x241357313e802e16eeb9380f2b027224e90b56dd", family: "79ff8521e54d5889e28ada48f505300d", name: "MaskDAO", upgradeable: "no", rating: MEDIUM, note: "MaskDAO.claim: _signer (an airdrop-claim authority) is set once in the constructor, no setter found; mints to msg.sender on a valid claim, so only the claim stops, no funds at risk. Read."}
- {address: "0x38251dbc366d8069d9310dc79917fee6a5403002", family: "28f276d9dc9531da9fd4f7d1b47df7f3", name: "Etherean", upgradeable: "no", rating: MEDIUM, note: "Etherean.mint: _verifyMintSignature gates a (handle, svg, palette) mint only, no funds; quick read, no setter found. Placed by contract type, not checked in source."}
- {address: "0x4f2ba7296391ab85ce4f4fc9f64608db6a267101", family: "64e9cd85a9e1a1ab70f2642a3874ab8e", copies: 4, name: "AngryDinos", label: "Angry Dinos: AD Token", upgradeable: "no", rating: MEDIUM, note: "AngryDinos.whitelistMint: an allowlist mint gate only, no funds; quick read, no setter found. Placed by contract type, not checked in source."}
- {address: "0x57a204aa1042f6e66dd7730813f4024114d74f37", family: "b890b36c3cff3afe0d9c0b66976dcf60", name: "Kongz", label: "CyberKongz: KONGZ Token", upgradeable: "no", rating: MEDIUM, note: "Kongz.ascend: a utility/upgrade-style gate, no custody apparent; quick read. Placed by contract type, not checked in source."}
- {address: "0x5bf5bcc5362f88721167c1068b58c60cad075aac", family: "29b7406cc9eef001c4a2f4febabe1b70", name: "ProofOfStake_Pages", label: "Proof Of Stake Pages: PoSp Token", upgradeable: "no", rating: MEDIUM, note: "ProofOfStake_Pages.updateIfSigned: a fixed, named celebrity signer (the deployer's own joke/vanity design, not rotatable); gates a content update only, no funds. Read."}
- {address: "0x615771e3510a5898b38ab46da2f5b4ef67a2f077", family: "5b6d1f203793a21c0b49ed50bca2faf2", name: "MintGateV2", upgradeable: "no", rating: MEDIUM, note: "MintGateV2.mint: SIGNER is set once in the constructor, no setter found; a mint gate, no funds. Placed by contract type, not checked in source."}
- {address: "0x6f2235864cf897078fcdcc2854b76c482cd16874", family: "7123342869a70c2811c0f99d0058260c", name: "PoapDelegatedMint", upgradeable: "no", rating: MEDIUM, note: "PoapDelegatedMint._isValidData: validSigner is set once in the constructor, no setter found; gates a free POAP mint only, no funds at risk. Read."}
- {address: "0x743776e5a345fe62d7d85282407c94e616a03176", family: "6e6256af68ce37623339917ef2ad12d8", name: "PixelmonEvolution", upgradeable: "no", rating: MEDIUM, note: "PixelmonEvolution.evolvePixelmon: SIGNER is an immutable-style constant with no setter found; a game action (evolving), no funds. Placed by contract type, not checked in source."}
- {address: "0x7a30f7736e48d6599356464ba4c150d8da0302ff", family: "86d647c02e9befc67125c8206bbfbc21", copies: 2, upgradeable: "no", rating: MEDIUM, note: "Oracle-confirmed operations (unverified; 2023): confirmations must come from the oracle set, which no function writes after construction. Bytecode."}
- {address: "0x829f3eb4ca4f7519228a79f5b0cdc45b4e58d40c", family: "8a24387b4fec7804288c9188a153a0c4", upgradeable: "no", rating: MEDIUM, note: "Operator bot (unverified): the recovered address must be a stored key that no function replaces (card; no address setter in the decompile); holds nothing. Bytecode."}
- {address: "0x8338d085aae3ac048b9e1de285fdef508ce73e45", family: "a89fa3737cd164f6b9adb20c54196ff5", name: "LovelessCityMetropass", label: "Loveless City Metropass: $LOVE Token", upgradeable: "no", rating: MEDIUM, note: "LovelessCityMetropass.purchase: a whitelist-signer gate (_validateSignature) over a paid mint; a failed check reverts the whole call, so ETH is never trapped, only whitelist minting stops. No setter…. Placed by contract type, not checked in source."}
- {address: "0x88cf4a8047b5ab9278ef1a15dd22f30fef04dc47", family: "b7b9500fe3c71faa01bd2ef025d3b2ee", upgradeable: "no", rating: MEDIUM, note: "Operator bot (unverified): ETH withdrawals need a signature from the constant key 0xf96d1059; holds nothing. Bytecode."}
- {address: "0x90c70dc9f3fda4a1d78a2b7d90ca087088355717", family: "3a732bbffc149f99e2c7c218ac429d33", name: "SatoshiIslandCitizenshipNFTs", upgradeable: "no", rating: MEDIUM, note: "SatoshiIslandCitizenshipNFTs Coupon.verifySignature: an admin-issued mint coupon, no funds. Placed by contract type, not checked in source."}
- {address: "0xb1160236017bbc3fe961957a785e24efd808c0cc", family: "50ec7f1f4326388a5710eb1c24f7366e", copies: 2, name: "PokeRaidHookV2", upgradeable: "no", rating: MEDIUM, note: "PokeRaidHookV2._resolveAuthenticatedUser: a Uniswap v4 game hook's user-authentication gate, no funds beyond the swap itself; quick read. Placed by contract type, not checked in source."}
- {address: "0xbe47e195607e408dc1ede1d67bfaed6187197ead", family: "f4b679e9afd7cdfaed93ec8d67173e85", name: "SCAIGenesis", upgradeable: "no", rating: MEDIUM, note: "SCAIGenesis presalePurchase: the same coupon-mint-gate pattern as SatoshiIslandCitizenshipNFTs; a failed check reverts the paid mint atomically. Placed by contract type, not checked in source."}
- {address: "0xc54567b294d7ec7807529fbaec71d326543453c5", family: "bb621d94ea877648689f0cdb1c49c0ca", name: "CoinStatsGLXY", label: "CoinStatsGLXY: GLXY Token", upgradeable: "no", rating: MEDIUM, note: "CoinStatsGLXY.mint: SignatureHelper.signer is set once in the constructor, no setter found; gates a free mint only, no funds. Read."}
- {address: "0xd0466448fb6bf17beaf9325974b7f71c6937609b", family: "08687f128c0e0889a7d1ff1527af3f60", name: "TrueProfileLogic", upgradeable: "no", rating: MEDIUM, note: "TrueProfileLogic.addTrueProof/isValidSignatureTrueProof: a reputation-attestation gate, no funds; quick read. Placed by contract type, not checked in source."}
- {address: "0xd4c3c23349348fa67f6d044f1357c54d8e6a661b", family: "6f3cb7e7d3d450e6a656c1f1892b24bd", name: "ApeKidsPets", upgradeable: "no", rating: MEDIUM, note: "ApeKidsPets.mint: isOGed/isWhitelisted gate an allowlist mint only, no funds; quick read, no setter found for the comparison signer. Placed by contract type, not checked in source."}
- {address: "0xd6d80461b1875a8679fe789db689156f42b7f86b", family: "e31067343a8ce2fe2f18af46f010dd59", name: "MegaShapeShifterz", label: "MegaShapeShifterz: MEGA Token", upgradeable: "no", rating: MEDIUM, note: "MegaShapeShifterz mutate/claimTax: an operator-signed gate over a game action and a token claim, no ETH value; quick read. Placed by contract type, not checked in source."}
- {address: "0xd88b8b8c45a0531229dbbf93b8c503bfbe17e86a", family: "a8c8bbbb1e66b191fb0d17f46a0671ae", name: "Ad", label: "ADNFT: Asian Disappointments Token", upgradeable: "no", rating: MEDIUM, note: "Ad.prePublicMint: _verifySinger mint-coupon gate, no funds; quick read. Placed by contract type, not checked in source."}
- {address: "0xde3e5a990bce7fc60a6f017e7c4a95fc4939299e", family: "f30d5b71095446914b36474f29ff6302", name: "TokenDistributor", label: "Gitcoin: GTC Distributor", upgradeable: "no", rating: MEDIUM, note: "TokenDistributor.claimTokens: a signature AND a Merkle proof are both required; the signer looks like a fixed platform co-signer (no setter found); value held is 0. Placed by contract type, not checked in source."}
- {address: "0xeca22c0fd4ac62d81a5633eb547e6797c9579462", family: "681f72531af6c5272a7621b1aae8705a", name: "DigiMiners", upgradeable: "no", rating: MEDIUM, note: "DigiMiners.publicMint: _signerAddress mint gate, no funds; quick read. Placed by contract type, not checked in source."}
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

Every row is in the header; `generated/triage_contracts.csv` lists them for search.

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
