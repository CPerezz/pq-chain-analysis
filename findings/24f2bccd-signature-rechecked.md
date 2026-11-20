---
id: 24f2bccd-signature-rechecked
title: "0x24f2bccd: a signature checked again after others relied on it"
status: not-affected
severity: NONE
patterns: [PQ-15]
impact: none
contracts:
- address: "0x24f2bccde24614c0937c78331acdec4e30dd3131"
  family: "1ab16f5075241a5033ef0427ecef1d36"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-signature-rechecked"
  date: 2026-11-19
  verdict: reported
  rating: CRITICAL
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "The wallet is uninitialized and inert, so the result is the same before and after EIP-8151; the template claim does not apply."
---

## Summary

Not a BitFi Vault. This is a single-owner wallet: 0x6de725a3(bytes,address,uint256,bytes) sends ETH when ecrecover(sig) equals the owner in slot 3, and it also has ERC721/1155 receiver hooks. This instance was never initialized: the owner and flag in slot 3 are 0, and every path calls store_d=0x75729c82…, which has no code, so every call reverts. EIP-8151 changes nothing.

## Mechanism

PQ-15. The second check reads the signer's account code at that time. Once that account has real code it recovers no address: the party that relied on the signature loses, and a signer can cause it on purpose by migrating between the two steps.

## Evidence

- How it was placed: per-trade Vault (18 clones): settlement pays out only with a presign of coreAddrs[1] and an MPC signature of coreAddrs[0], both fixed in the vault; after the timeout anyone can…. Same code idiom as template ec3bbcc8, not read on its own.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- heimdall decompile: ecrecover result compared to address(slot3>>8), then payable(arg1).transfer(arg2)
- cast storage @26438999: slot3 = 0 (owner unset, initialized flag 0); slot0 = 0x75729c82335892fb704c5534b5e9d258cafb542c, which has no code (nonce 0)
- cast balance @26438999 = 0; ecrecover is called with all gas forwarded (DUP6 GAS STATICCALL)

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

none

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-signature-rechecked` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
- 2026-11-20: the same contract was also a row of triage entry `eip-8151-fixed-signer`; as a fixed signer it is not affected either: the wallet was never initialized (owner slot 0) and every path reverts (D-025).
