---
id: facetetherbridgev6-100524b6-fixed-signer
title: "FacetEtherBridgeV6: signer fixed in code"
status: not-affected
severity: NONE
patterns: [PQ-17]
impact: none
contracts:
- address: "0x100524b68fe88035623f1309bb3db9b64e924724"
  family: "165b5d280be5725c4c5890aea7ee6059"
  name: "FacetEtherBridgeV6"
  upgradeable: "no"
  rating: NONE
  txs_90d: 0
fix:
  layer: none
  who_acts: "nobody: not affected"
evidence:
  level: source-read
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: HIGH
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: refuted
  rating: NONE
  note: "An uninitialized implementation with admin 0 and nothing held: every path into it is dead. On the question asked: the admin is address(0) and can never be set here; the live admin 0xb2B0… administers the proxy, not this code."
---

## Summary

0x100524b6 is an uninitialized FacetEtherBridgeV6 implementation, not the bridge. Its constructor calls _disableInitializers, adminAddress is 0, and it holds 0 ETH. The live Facet bridge proxy 0x0000000000000b07ed…ce4c now points to a different implementation (0x0490244c…) and is upgradeable through Solady's ERC1967Factory by admin 0xb2B01DeC….

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: Facet bridge withdraw: signed by a signer address written into the code; the caller must be the transaction's origin. Read (function text).
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source: constructor() { _disableInitializers(); }. initialize() is callable only by ERC1967Factory and sets admin 0xb2B0…. setAdmin and adminWithdraw are onlyAdmin.
- cast at block 26438999: getAdmin() = 0x0; Initializable slot 0x…bf601132 = 0x1fffffffffffffffe (initializers disabled); balance 0; EIP-1967 slots are 0.
- Proxy 0x0000000000000b07ed…: implementation slot = 0x0490244c989b…; ERC1967Factory.adminOf(proxy) = 0xb2B01DeC… (contract, Safe-proxy-shaped bytecode); proxy balance 0 at block 26438999.
- Hard-coded signer 0x314d660b… has no code (nonce 0); txs.json shows no recovery by this code in the traced window.

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

None for this address. The live bridge is a separate proxy whose admin can upgrade it.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: not affected. Anon assigned the review to Claude, which also filed the triage entry (D-025).
