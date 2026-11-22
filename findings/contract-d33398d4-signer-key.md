---
id: contract-d33398d4-signer-key
format: 2
title: Gated Uniswap v4 hook lets a forged ECDSA approval admit unapproved traders
status: candidate
severity: LOW
justification: A recovered approver key only bypasses the trading gate; the owner can upgrade the hook to a post-quantum
  approval.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd33398d46cb5749c7319ae1fabc498cdeb0f0fc0'
  code: decompiled
  code_url: code/0x502cea18a3b198c235a8e5ab046819cb38381d4096f0693bb806cae5f51857f6.sol
  proxy_of: '0xba7b889588d6c449a30066344dd47759cfcb4fc0'
  copies: 1
  upgradeable: 'yes'
  admin: '0xc5d3c245acb2f3eb41e19a609f9bf06ef77dd21d'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 10531
impact: liveness
action: Upgrade the hooks to verify a post-quantum approval signature, and move ownership to a post-quantum account.
evidence_level: bytecode
checks:
- id: sel-approver
  selector: '0xba7b889588d6c449a30066344dd47759cfcb4fc0'
  fn: approver()
  says: approver() selector is in the code
  for:
  - evidence-1
  - justification
  - what
- id: sel-setapprover
  selector: '0xba7b889588d6c449a30066344dd47759cfcb4fc0'
  fn: setApprover(address)
  says: setApprover selector is in the code
  for:
  - action
  - evidence-2
  - justification
  - what
- id: sel-nonce
  selector: '0xba7b889588d6c449a30066344dd47759cfcb4fc0'
  fn: nextNonce(address)
  says: per-address nonce getter is in the code
  for:
  - what
- id: sel-upgrade
  selector: '0xba7b889588d6c449a30066344dd47759cfcb4fc0'
  fn: upgradeToAndCall(address,bytes)
  says: UUPS upgrade selector is in the code
  for:
  - action
  - evidence-3
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review02 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: LOW
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

This Uniswap v4 hook gates trading in its pools on an approval signed by the approver() key, which the owner sets. A quantum attacker who recovers the approver key can sign approvals and trade in the gated pools without the operator's consent.

## Evidence

- [approver()](https://etherscan.io/address/0xba7b889588d6c449a30066344dd47759cfcb4fc0#code) exposes the address whose signatures the hook accepts.
- [setApprover](https://etherscan.io/address/0xba7b889588d6c449a30066344dd47759cfcb4fc0#code) lets the owner replace the approver key.
- [upgradeToAndCall](https://etherscan.io/address/0xba7b889588d6c449a30066344dd47759cfcb4fc0#code) lets the owner upgrade the hook logic.

## Reviewer notes

### Mechanism

The implementation is unverified. Its bytecode contains approver(), setApprover(address) (owner-only in the decompile), nextNonce(address) and upgradeToAndCall(address,bytes). Kev's finding infers that beforeSwap recovers the signer of an approval in the hook data with ecrecover, using a per-trader nonce, and reverts unless the signer equals approver(). The hook address bits grant before/after liquidity and swap callbacks without any return-delta flag, so the hook cannot change swap amounts. A forged approval only grants access to the gated pools at pool prices.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Taking swap amounts through the hook: no return-delta permissions
- Ruled out: Funds held by the hook: it holds nothing

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
