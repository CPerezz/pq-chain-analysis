---
id: contract-63242a4e-quote-signer
format: 2
title: KyberSwap executor trusts an ECDSA signer key a quantum attacker could recover
status: candidate
severity: MEDIUM
justification: The signer key is ECDSA; the executor lacks ERC-1271, so KyberSwap must retire or redeploy it to
  fix this.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x63242a4ea82847b20e506b63b0e2e2eff0cc6cb0'
  project: kyberswap
  code: decompiled
  code_url: code/0xfc0f2df2614d0de542805849c0a1905dc417b15ff306a72c9656c4016a7da98d.sol
  copies: 1
  admin: '0x697161a9ece8afd6ae30946d790077050f993cbc'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 100
impact: funds-loss
action: Retire this executor or deploy a replacement that verifies a post-quantum signer; revoke SIGNER_ROLE meanwhile.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x63242a4ea82847b20e506b63b0e2e2eff0cc6cb0'
  has: 60015afa
  says: The runtime code calls the ecrecover precompile.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-signer-role
  selector: '0x63242a4ea82847b20e506b63b0e2e2eff0cc6cb0'
  fn: SIGNER_ROLE()
  says: The contract has a SIGNER_ROLE getter.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: sel-callbytes
  selector: '0x63242a4ea82847b20e506b63b0e2e2eff0cc6cb0'
  fn: callBytes(bytes)
  says: The contract has the executor entry point callBytes.
  for:
  - evidence-2
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review13 (re-read KEM hook source on Sourcify; signer, owner and admin reads; executor call path)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
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

This KyberSwap aggregation executor checks signatures with ecrecover against holders of a signer role. A quantum attacker who recovers a signer key can produce signatures the executor accepts.

## Evidence

- The [runtime code](https://etherscan.io/address/0x63242a4ea82847b20e506b63b0e2e2eff0cc6cb0#code) calls the ecrecover precompile.
- The [contract](https://etherscan.io/address/0x63242a4ea82847b20e506b63b0e2e2eff0cc6cb0#code) exposes SIGNER_ROLE() and callBytes(bytes).

## Reviewer notes

### Mechanism

Unverified bytecode (22786 bytes). The runtime code calls the ecrecover precompile (bytes 60015afa at offset 22666). The contract exposes SIGNER_ROLE(), callBytes(bytes), msgSender() and refundCollector(), and kev's analysis finds no isValidSignature selector. Per kev, ecrecover is checked against SIGNER_ROLE holders, so a recovered signer key yields accepted signatures. MetaAggregationRouterV2 calls this executor during swaps. What the signature authorises, and who holds SIGNER_ROLE, comes only from bytecode reading and was not established. Admin 0x697161a9… is an ECDSA EOA.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Not a proxy.
- Ruled out: Balance is dust, not the exposure.
- Ruled out: Activity is low (17 calls in 30 days).

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
