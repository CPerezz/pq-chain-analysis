---
id: eip-8151-fixed-gas-recovery
title: "Contracts that give ecrecover a fixed gas amount below EIP-8151's price: every valid signature fails from activation day"
status: candidate
severity: HIGH
patterns: [PQ-14]
impact: funds-locked
contracts:
- {address: "0xfef0d2f3a79b4338d8418003dd9df89281242063", family: "282894bb13f9f0bf91c1179f2c5838f3", name: "LiquidityTransformer", label: "deployed by Wise: Deployer", upgradeable: "no", rating: HIGH, value_usd: 1204, value_basis: "held", value_as_of: 2026-11-18, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
- {address: "0x4c1f06cdc59dd46f6d763d995e938605c0d9e8f0", family: "2b1798f5400b05301b6de43d244818b1", upgradeable: "no", rating: HIGH, value_usd: 509, value_basis: "held", value_as_of: 2026-11-18, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
- {address: "0xfeaf6470ace0c148469fd8990e069bdcc6b72f10", family: "b9588f8b08e769e8717f32f8b7d0f749", copies: 3, name: "Eth17", upgradeable: "no", rating: HIGH, value_usd: 361, value_basis: "held", value_as_of: 2026-11-18, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
- {address: "0x656db34fd512fb22ce16bbc621c58394ebb823c4", family: "3506ea2115157e22235a163e82b13159", copies: 3, name: "Game", upgradeable: "no", rating: HIGH, value_usd: 90, value_basis: "held", value_as_of: 2026-11-18, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
- {address: "0x199b0999e2ead19d0f0e9d459071351de77a210d", family: "ba7f1f3a1285f7996980979eb975595b", upgradeable: "no", rating: HIGH, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
- {address: "0x343eadbdff2eee8fea52e8204d6e58491a9e931a", family: "7bba566f43f5c40f9c585af6f6d2d289", label: "deployed by Methuselah Foundation 2", upgradeable: "no", rating: HIGH, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
- {address: "0x5a13caa82851342e14cd2ad0257707cddb8a31b7", family: "0261295d12cad4757c99a608b47afff3", name: "EthereumPot", upgradeable: "no", rating: HIGH, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
- {address: "0x5fbce55cb14b2c99e611a26a9066e77e6d3ae55f", family: "b7b87df5355d43eee49107111bc0f29b", copies: 6, upgradeable: "no", rating: HIGH, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
- {address: "0x979b2dd26bcf1b391ff5afa7b0c818209889a832", family: "acd4a1772d63a1cb880f56543bccf158", upgradeable: "no", rating: HIGH, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
- {address: "0xbb623896fa9fa698dc0706f1cd62a26d217b1f7c", family: "fb9619b51b18d4f3337a43f160806e44", upgradeable: "no", rating: HIGH, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
- {address: "0xc22407b1f34e494b7f85187fafc2ce5d13871ffb", family: "41c6f38fcd0778362c91521e6105700b", name: "GratitudeCrowdsale", upgradeable: "no", rating: HIGH, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
- {address: "0xc2a4705ecc9dab55dcc9432c7530731321490323", family: "02767e1e1591e7362cd896095b2c22dd", name: "LiquidityTransformer", label: "deployed by SWAPP Protocol: Deployer", upgradeable: "no", rating: HIGH, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
- {address: "0xc59162bbe31b2eca8e3d7d3401dc05f64e293f83", family: "bf52cbad6e524d92cbe9d706f69d3cd8", copies: 3, upgradeable: "no", rating: HIGH, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
- {address: "0xe16a567ea438a81994ec7859b9abb0184f3d6028", family: "6456d1201a826e449a5be0e76a58d837", name: "Lottery", upgradeable: "no", rating: HIGH, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
- {address: "0xe5e5214ccf899bfc77e4dd9858737902cc1f0b0a", family: "68b957711ed4ed3cfeee36cba3528373", upgradeable: "no", rating: HIGH, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: no proxy slot, no upgrade function."}
- {address: "0xb4a448387403554616eb5b50aa4c48f75243a015", family: "b063805f94cf9b39667802b7b2b854b3", name: "Mobius2Dv2", upgradeable: "yes", rating: LOW, value_usd: 10, value_basis: "held", value_as_of: 2026-11-18, note: "3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list). Update path: upgrade(address), owner 0x853012bce9eacabc6e9047be9630a7e6b3739a7a."}
evidence: {level: executed, block: 26438999}
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions; not reviewed by a person)"
  ref: "studies/eip-8151-impact, fixed gas"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
related: []
reviews: []
---

## Summary

These contracts forward a fixed amount of gas to `ecrecover` that is below the price of a successful recovery under EIP-8151 (3,200 warm, 6,100 cold). 16 code families, 27 addresses, $2k held, 0 recoveries in the study's two-week window. Rows by rating: HIGH 15, LOW 1. 0 rows were checked on a real transaction; the others were read from source, judged from bytecode or placed by measured rules (each row's note says which).

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- Each row's note says how it was decided: read from verified source, judged from bytecode and function names, placed by a rule measured against hand readings, or executed: a real transaction replayed on the fork's reference implementation with only the precompile changed, state at block 26,438,999.
- Fuel v1 `0x6880f6fd960d1581c2730a451a22eed1081cfd72`: `src/Witness.yulp` L137–144 of FuelLabs/fuel-v1-contracts@2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22 does `call(3000, 1, 0, 0, 128, 160, 32)` and ignores the result. Executed (`eth_simulateV1`, block 26,438,999): with a recovery that cannot finish in 3,000 gas, `proveInvalidWitness` on an honestly signed transaction emits `FraudCommitted(9, 8, 150)` and pays the caller 0.25 ETH; today it finds nothing.
- 3,072-gas wallets (factory `0xcd097b8dd0505aed5ed3f6a02416b0fb9e19fc59`): bytecode pc 187–207 `PUSH2 0x0c00`, `STATICCALL` to `0x01`, `INVALID` on failure. Executed: transaction `0x0323ebe3274b24b64ec6193d93729c9a37fecb1371d921cfd6d7dc98628dbd0f` (block 26,432,607) succeeds today with 64,082 gas, as its receipt says; under EIP-8151 it hits `INVALID` and uses the whole 200,000.

## Impact and exposure

Largest rows by value held at block 26,438,999:
- `0xfef0d2f3a79b4338d8418003dd9df89281242063` (LiquidityTransformer): $1k, HIGH
- `0x4c1f06cdc59dd46f6d763d995e938605c0d9e8f0` (unverified): $509, HIGH
- `0xfeaf6470ace0c148469fd8990e069bdcc6b72f10` (Eth17): $361, HIGH, 3 addresses
- `0x656db34fd512fb22ce16bbc621c58394ebb823c4` (Game): $90, HIGH, 3 addresses
- `0xb4a448387403554616eb5b50aa4c48f75243a015` (Mobius2Dv2): $10, LOW

Every row is in the header; `generated/triage_contracts.csv` lists them for search.

## Remediation

Immutable code cannot change: holders move what the contracts hold before activation. Where an owner can withdraw or upgrade, the owner acts.

## History

- 2026-11-19: filed from study `eip-8151-impact`, one entry per root issue (D-022). The per-project entries filed earlier that day are in git history (commit `d9c90af`).
- Full write-ups of the executed rows before the merge: [fuel-v1-fixed-gas-witness-recovery](https://github.com/kevaundray/pq-chain-analysis/blob/d9c90afac8137e134d5e884865dfc37bbcb0d397/triage/fuel-v1-fixed-gas-witness-recovery.md), [unidentified-cd097b8d-wallets-fixed-gas-recovery](https://github.com/kevaundray/pq-chain-analysis/blob/d9c90afac8137e134d5e884865dfc37bbcb0d397/triage/unidentified-cd097b8d-wallets-fixed-gas-recovery.md).
- 2026-11-19: rows rated by how hard the fix is, one row per family and update path (D-024).
