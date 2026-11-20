---
id: redstonecoreoracle-0d99c644-fixed-signer
title: "RedstoneCoreOracle: signer fixed in code"
status: confirmed
severity: MEDIUM
patterns: [PQ-17]
impact: liveness
contracts:
- address: "0x0d99c644eadc9237550430d1aca226690eac4e4f"
  family: "367d52f980a4141ae7dc5c889d917ebf"
  copies: 127
  name: "RedstoneCoreOracle"
  label: "deployed by Euler: Deployer"
  upgradeable: "no"
  rating: MEDIUM
  txs_90d: 0
fix:
  layer: new-deployment
  who_acts: "Euler / the market curator: deploy a new oracle and point the vault's EulerRouter at it (govSetConfig)"
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
  verdict: confirmed
  rating: MEDIUM
  note: "Oracle feed, nothing held, no update path at this address, no known consumer that locks funds → MEDIUM (RedStone precedent). Any Euler consumer would reach it through an EulerRouter whose governor can govSetConfig, which would make it LOW, but no consumer was found and the empty cache suggests none uses it."
---

## Summary

Euler RedstoneCoreOracle for ezETH/USD with the RedStone primary-prod signers hardcoded (threshold 3). There is no update path, and the oracle holds nothing. Its cache has never been written, so no known consumer prices through it.

## Mechanism

PQ-17. Once that key's account has real code, every signed function stops. Users' funds behind it are stuck unless another path releases them; where only the operator's own money is at stake the operator withdraws and redeploys.

## Evidence

- How it was placed: RedStone (variant): signer looked up in a list of addresses fixed in the adapter's code; a threshold of distinct signers. Read from source.
- Update path, read at block 26,438,999: no proxy slot, no upgrade function.
- Source RedstoneCoreOracle.sol + PrimaryProdDataServiceConsumerBase.sol: getAuthorisedSignerIndex compares against 5 constant RedStone keys; immutables base/quote/feedId/maxStaleness; no setter, no proxy (row)
- @26438999: base=0xbf5495Ef… (ezETH), quote=0x…0348 (USD), feedId 'ezETH', maxStaleness 120, getUniqueSignersThreshold()=3, cache()=(0,0): updatePrice has never succeeded
- The 5 signer keys: code 0x, nonce 0 (node, latest)
- EulerRouter ConfigSet(asset0,asset1,oracle) logs naming this oracle: none in blocks 20621322-21521322 (creation block 20621322); the rest of the range was not scanned (RPC limits). facts.json: no code holds its address; 127 copies. txs_90d 0

## Impact and exposure

- Value held at block 26,438,999: $0 (ETH and 49 priced tokens, over 127 addresses).
- Activity: 0 transactions called it in the 90 days before that block.

## Remediation

New oracle deployment with replaceable or post-quantum signers, set through the consumer's router

## History

- 2026-11-19: reported as a row of triage entry `eip-8151-fixed-signer` (study `eip-8151-impact`).
- 2026-11-20: reviewed and filed: MEDIUM. Anon assigned the review to Claude, which also filed the triage entry (D-025).
