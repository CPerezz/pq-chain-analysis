---
id: contract-1c6ad754-signer-key
format: 2
title: Unidentified paymaster trusts an ECDSA signer a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: A forged sponsor signature spends the operator's gas deposit; MEDIUM as the owner can keep it empty
  or redeploy.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1c6ad754810b4385ec3c46b0340e2954350c3e00'
  code: decompiled
  code_url: code/0xaea237f6da263979a16dda51e50808a2b4de5c3bf9d18a736af6b09534109336.sol
  copies: 1
  admin: '0xbe4c70a00dcc0c0757257740e4e6f3f57d9a7c85'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Keep the EntryPoint deposit at zero, or sponsor through a paymaster that verifies a post-quantum signature.
evidence_level: bytecode
checks:
- id: b1
  bytecode: '0x1c6ad754810b4385ec3c46b0340e2954350c3e00'
  has: 60015afa
  says: The runtime code calls the ecrecover precompile.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-validate
  selector: '0x1c6ad754810b4385ec3c46b0340e2954350c3e00'
  fn: validatePaymasterUserOp((address,uint256,bytes,bytes,uint256,uint256,uint256,uint256,uint256,bytes,bytes),bytes32,uint256)
  says: validatePaymasterUserOp selector is present.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-signer
  selector: '0x1c6ad754810b4385ec3c46b0340e2954350c3e00'
  fn: verifyingSigner()
  says: verifyingSigner() selector is present.
  for:
  - evidence-2
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review08 (paymaster bytecode, EntryPoint deposit reads, deployer siblings)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: LOW
- study: top-callers-classification
  who: Review18 (LiquidityBank bytecode strings and selectors, proxy and paymaster reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: LOW
- study: top-callers-classification
  who: Review15 (co-signer bytecode, module immutable, traced user operation)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
- study: top-callers-classification
  who: Review22 (module bytecode, NAME/VERSION, trace, account enumeration and balances; moved from biconomy-ecdsa-validator)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
reviews: []
related: []
---

## What happens

This paymaster sponsors gas for ERC-4337 user operations and accepts a sponsorship with an ECDSA signature it recovers via ecrecover. A quantum attacker who recovers the signer key can sign sponsorships that spend the paymaster's EntryPoint deposit.

## Evidence

- [validatePaymasterUserOp](https://etherscan.io/address/0x1c6ad754810b4385ec3c46b0340e2954350c3e00#code) is in the code, and the code calls the ecrecover precompile.
- [verifyingSigner](https://etherscan.io/address/0x1c6ad754810b4385ec3c46b0340e2954350c3e00#code) names the key whose signatures approve sponsorship.

## Reviewer notes

### Mechanism

Bytecode-only eth-infinitism v0.6 VerifyingPaymaster with a tx.origin allow-list (removeOrigin, 'Invalid origin'). EntryPoint v0.6 0x5ff137d4 calls validatePaymasterUserOp (0xf465c77e); it hashes paymasterAndData with getHash and recovers the signer via ecrecover (precompile call at byte offset 5530), comparing it with verifyingSigner. On success the EntryPoint charges gas to the paymaster's deposit. The owner (Ownable, onlyOwner on addStake/unlockStake/withdraw) controls deposits. Per kev, the deposit was 0 when read, so exposure returns only if it is refilled.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Deposit was zero when kev read it; no current funds at stake.
- Ruled out: No verified source; signer comparison is inferred from the eth-infinitism pattern.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
