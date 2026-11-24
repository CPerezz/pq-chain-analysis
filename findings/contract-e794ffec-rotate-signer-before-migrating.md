---
id: contract-e794ffec-rotate-signer-before-migrating
format: 2
title: Pool quotes fail if its stored signer moves its account to real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if the signer moves its account to real code, and the operations account can set a new
  signer first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xe794ffecc16a8e5f5c7d7818322ba7fe41a63f72'
  code: bytecode
  code_url: https://etherscan.io/address/0xe794ffecc16a8e5f5c7d7818322ba7fe41a63f72#code
  proxy_of: '0xacfaaa9da11e66a8cc8af8e3d844673968fff63f'
  copies: 10
  family: 3a1ff29795951c167c163fc0f92bb1ec
value:
  usd: 15007
  whose: operator
  basis: held
activity: {}
impact: liveness
action: Set a new signer with updateSigner before moving the current signer's account to real code.
evidence_level: bytecode
checks:
- id: ecrec
  bytecode: '0xacfaaa9da11e66a8cc8af8e3d844673968fff63f'
  has: 60019060a0016020604051602081039080840390855afa
  says: the signature is recovered by a STATICCALL to precompile 0x01 with all remaining gas
  for:
  - evidence-1
  - what
- id: cmp
  bytecode: '0xacfaaa9da11e66a8cc8af8e3d844673968fff63f'
  has: 5b6003546001600160a01b03166001826001811115611d3b57611d3b612f51565b03611d435750845b6001600160a01b038116611d578585612081565b6001600160a01b03161461
  says: the expected signer is storage slot 3 unless the quote type is 1; the recovered address must equal it
  for:
  - evidence-1
  - justification
  - what
- id: invalid
  bytecode: '0xacfaaa9da11e66a8cc8af8e3d844673968fff63f'
  has: 48617368666c6f77506f6f6c3a20496e76616c6964207369676e6572
  says: 'a mismatch reverts with HashflowPool: Invalid signer'
  for:
  - evidence-1
  - what
- id: setter
  bytecode: '0xacfaaa9da11e66a8cc8af8e3d844673968fff63f'
  has: 5b6004546001600160a01b03163314610ddf5760405162461bcd60e51b8152600401610497906130e4565b600380546001600160a01b0319166001600160a01b038316
  says: the function body requires the caller to be slot 4 and writes a new address into slot 3
  for:
  - action
  - evidence-2
  - justification
  - what
- id: sel
  selector: '0xacfaaa9da11e66a8cc8af8e3d844673968fff63f'
  fn: updateSigner(address)
  says: the setter is dispatched as updateSigner(address)
  for:
  - action
  - evidence-2
- id: nolog1271
  bytecode: '0xacfaaa9da11e66a8cc8af8e3d844673968fff63f'
  has: 631626ba7e
  absent: true
  says: the code never calls isValidSignature (ERC-1271)
  for:
  - notes
- id: lp
  bytecode: '0xacfaaa9da11e66a8cc8af8e3d844673968fff63f'
  has: 48617368666c6f77506f6f6c3a204c702061646472657373206d757374
  says: liquidity moves require the LP to be the operations address (Lp address must be operations)
  for:
  - whose
- id: init
  storage: '0xe794ffecc16a8e5f5c7d7818322ba7fe41a63f72'
  slot: 0
  is: '0x1'
  says: the clone is initialized
  for:
  - notes
- id: signer
  storage: '0xe794ffecc16a8e5f5c7d7818322ba7fe41a63f72'
  slot: 3
  is: '0xb882b3eec5748084c6848a51f0a8259522ef1fa3'
  says: the stored signer
  for:
  - evidence-3
  - what
- id: ops
  storage: '0xe794ffecc16a8e5f5c7d7818322ba7fe41a63f72'
  slot: 4
  is: '0x5d2f2d966af70114903b341b3378379eef59cd27'
  says: the operations account that may call updateSigner
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signercode
  code: '0xb882b3eec5748084c6848a51f0a8259522ef1fa3'
  is: empty
  says: the signer has no code
  for:
  - evidence-3
- id: signernonce
  nonce: '0xb882b3eec5748084c6848a51f0a8259522ef1fa3'
  is: 3
  says: the signer has sent 3 transactions
  for:
  - evidence-3
- id: opscode
  code: '0x5d2f2d966af70114903b341b3378379eef59cd27'
  is: empty
  says: the operations account has no code
  for:
  - evidence-2
- id: opsnonce
  nonce: '0x5d2f2d966af70114903b341b3378379eef59cd27'
  is: 17
  says: the operations account has sent 17 transactions
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-e794ffec, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Wording pass (''real code''); a fresh refuter agrees on every part; Claude read the changed sentences.
    Kept as before. Notes: only type-0 quotes depend on the stored signer (the body says so; the title is broader);
    the clone''s code has no working delegatecall, so ''not upgradeable'' could replace ''not established''.'
related: []
---

## What happens

This pool fills trades against signed quotes. Quotes of one of its two types need an ECDSA signature from the signer stored in the pool. If that signer's account moves to real code, those quotes fail until the operations account sets a new signer.

## Evidence

- The [pool code](https://etherscan.io/address/0xacfaaa9da11e66a8cc8af8e3d844673968fff63f#code) recovers the quote signature with ECDSA and reverts with Invalid signer unless it is the stored signer.
- [updateSigner](https://etherscan.io/address/0xe794ffecc16a8e5f5c7d7818322ba7fe41a63f72) replaces the signer; only the operations account, an address without code, can call it.
- The stored [signer](https://etherscan.io/address/0xb882b3eec5748084c6848a51f0a8259522ef1fa3) is set, is an address without code, and has sent 3 transactions.

## Reviewer notes

### Mechanism

This address is an EIP-1167 clone of 0xacfa...f63f (unverified, Hashflow pool by its revert strings); state is the clone's, initialized (slot 0 = 1). The trade path requires the caller to be an authorized router (mapping at slot 0x0a), then the signature check at 0x1d1b: expected signer = slot 3 (low 160 bits) when the quote's type field is 0, or quote word 0x80 (effectiveTrader, checked equal to the trader) when it is 1. It calls OpenZeppelin ECDSA.recover (precompile 0x01 with all remaining gas, at 0x24fd) and reverts with 'HashflowPool: Invalid signer' on mismatch. For type 1 the stored signer must instead be the relayer (plain address comparison, no recovery). updateSigner(address) (0xa7ecd37e, body at 0xdb5) requires CALLER == slot 4 (operations), writes slot 3 and emits UpdateSigner. At block 26,438,999: signer 0xb882...1fa3 (no code, nonce 3), operations 0x5d2f...cd27 (no code, nonce 17). Liquidity moves through the router with the LP required to equal the operations address.

### Checks

- Header facts: this address alone, at block 26,438,999; 10 addresses run this code.
- Ruled out: ERC-1271 for a signer with code: no PUSH4 0x1626ba7e in the implementation; the only check is ECDSA.recover against the stored address.
- Ruled out: a fixed gas amount: the precompile call passes GAS (all remaining), so the price rise alone does not break it.
- Ruled out: unused implementation: this address is an initialized clone (slot 0 = 1) with its own signer and operations set, holding the row's value.
- Ruled out: unset or contract signer: slot 3 holds 0xb882...1fa3, an address without code.
- Ruled out: a dead setter: updateSigner is gated on slot 4, an address without code that has sent 17 transactions.
- Ruled out: a signature rechecked after reliance: the quote is checked once, at the trade that fills it.

### Questions

- Which router is authorized in this pool's router mapping (slot 0x0a), and is it still routing trades? Whether the pool is still trading at the block was not established.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
