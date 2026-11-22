---
id: 199b0999-fixed-gas-recovery
title: "0x199b0999: fixed gas for ecrecover below EIP-8151's price"
status: confirmed
severity: MEDIUM
patterns: [PQ-14]
impact: liveness
contracts:
- address: "0x199b0999e2ead19d0f0e9d459071351de77a210d"
  family: "ba7f1f3a1285f7996980979eb975595b"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: account-migration
  who_acts: "owner 0x236ebd377a44925a3428ed2d322014e4c0dc781a (EOA)"
evidence:
  level: bytecode
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-gas-recovery"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: "The money is the owner's own (a personal relayed wallet) and there is no upgrade path. The signed relay dies for good, but the funds are not locked: the owner can open the wallet with changeOwner(0x0) and pull the tokens out (shown by simulation), which counts as an owner path, so MEDIUM. If the reviewer does not accept the zero-owner trick (it relies on the unchecked, uncleared result word) as an owner path, the rating is HIGH (owner's funds locked)."
---

## Summary

Unverified Vyper meta-transaction wallet. Its four relayed functions (049afdbf approve+call, c9162298 arbitrary call, f6acc645 call+approve+call, 1c54e580 token transfer paying a relayer fee) all run one private check that calls ecrecover with 3,000 gas and requires the result to equal owner, so after EIP-8151 every valid owner signature fails. The tokens can still leave: a failed recovery reads as 0, so the owner can call changeOwner(0x0) and drain the wallet in the same atomic bundle.

## Mechanism

PQ-14. The gas operand of the call to `0x01` is a constant: 3,000 in the Oraclize helper and its copies, 3,072 in two wallet factories. From activation day every valid signature fails, with nobody migrating. What follows decides the damage: a revert kills the function; code that ignores the call's result reads "no signer" as a fact (Fuel v1 rewards it as fraud).

## Evidence

- How it was placed: 3000 gas to the precompile: every valid signature fails. Scanner only (outside the reading list).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Disassembly at 26438999: private check at pc 0x113-0x43d. When v is 27 or 28 it does CALL(gas 0x0bb8, to 0x01, out 0xc0) at pc 0x3de with the success flag ignored, then requires SLOAD(0) == mload(0xc0) or reverts 'Signer does not match owner'. The check is entered from 049afdbf (pc 0x17d2), c9162298 (0x1c42), f6acc645 (0x20ba) and 1c54e580 (0x2529). Memory 0xc0 is written nowhere else, so a failed recovery gives 0.
- Nothing else moves funds. The only CALLER check in the code is changeOwner a6f9dae1: owner-only, with no zero-address check. 9fa43b24, 77f0f67b, 68559884 and e752ac67 are hash helpers that make only identity-precompile (0x04) calls and no SSTORE. The fallback reverts. owner() = slot 0 = 0x236ebd37..., an EOA (code 0x, nonce 1). EIP-1967 slots are zero and there is no upgrade function.
- eth_call at block 26438999. 1c54e580(DAI, 0.4786e18, 0x...dEaD, fee stub, 65-byte signature that recovers nothing) reverts 'Signer does not match owner'. The same call succeeds once the owner slot is overridden to 0. changeOwner(0x0) succeeds when sent from the owner and reverts from any other sender.
- Holdings at 26438999: 0 ETH, 0.478637 DAI, 0 USDC. A full scan of Transfer logs from creation (block 9505002, tx 0x0d46c9de...) to 26438999 shows only DAI and USDC ever received, all in Feb 2020. txs_90d 0, last_active null.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

The owner sends changeOwner(0x0) and 1c54e580(token, balance, newWallet, feeStub, any signature) in one atomic step: a Flashbots bundle, or an EIP-7702 batch from the owner EOA. It must be atomic because once owner is 0 anyone can drain the wallet. Then retire the contract.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-gas-recovery` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry.
