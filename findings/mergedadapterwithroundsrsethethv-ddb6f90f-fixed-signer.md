---
id: mergedadapterwithroundsrsethethv-ddb6f90f-fixed-signer
title: "MergedAdapterWithRoundsRsethethV1: signer fixed in code"
status: confirmed
severity: LOW
patterns: [PQ-17]
impact: funds-locked
contracts:
- address: "0xddb6f90ffb4d3257dd666b69178e5b3c5bf41136"
  family: "4a78aa9e82ed2b96b3de5263561012f1"
  copies: 3
  name: "MergedAdapterWithRoundsRsethethV1"
  upgradeable: "yes"
  admin: "0x8223a6271d1e0bda019ee55d545d7b86eff1f573 (ProxyAdmin (Ownable)), owned by 0x6906f3a09bcc1b7cd3b0c8626724299618df4472 (Safe 1.3.0, 2-of-3 owners)"
  rating: LOW
  txs_90d: 909
  last_active: 2026-11-18
  recoveries_14d: 348
fix:
  layer: contract-upgrade
  who_acts: "proxy admin owner 0x6906f3a09bcc1b7cd3b0c8626724299618df4472"
evidence:
  level: executed
  block: 26438999
sources:
- by: ai-assisted
  study: eip-8151-impact
  who: "Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)"
  ref: "triage entry eip-8151-fixed-signer"
  date: 2026-11-19
  verdict: reported
  rating: LOW
reviews:
- who: "Claude, reviewer assigned by Anon (also the reporter of the triage entry)"
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: "LOW: a live party controls the proxy admin."
---

## Summary

RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers; EIP-8151 makes the fixed signer's signature fail once that signer has code.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read from source. Executed: a real transaction reverts with code at the signer.
- Update path, read at block 26,438,999: proxy to 0x3d3344c8f4abb279e192007f7b68eade3c8a5b28, admin 0x8223a6271d1e0bda019ee55d545d7b86eff1f573.
- EIP-1967 admin slot = 0x8223a6271d1e0bda019ee55d545d7b86eff1f573, implementation = 0x3d3344c8f4abb279e192007f7b68eade3c8a5b28 at block 26438999
- 0x8223a6271d1e0bda019ee55d545d7b86eff1f573: ProxyAdmin (Ownable); owner() = 0x6906f3a09bcc1b7cd3b0c8626724299618df4472
- 0x6906f3a09bcc1b7cd3b0c8626724299618df4472: Safe 1.3.0, 2-of-3 owners at block 26438999

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 3 addresses).
- Activity: 909 transactions called it in the 90 days before that block; last on 2026-11-18.
- 348 signature recoveries in the study's two-week trace window.

## Remediation

Admin owner upgrades the implementation to one with a replaceable signer or ERC-1271 support.

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: LOW. Anon assigned the review to Claude, which also filed the triage entry.
