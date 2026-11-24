---
id: growdefitoken-7bd075e7-signed-shortcut-lost
format: 2
title: GrowDeFi token holders whose accounts take real code lose signed vote delegation
status: confirmed
severity: INFORMATIONAL
justification: 'Nothing is locked: a holder whose account takes real code can still delegate its votes with a direct
  call.'
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7bd075e70977b8c026ba29624340a70f832df3c9'
  name: GrowDeFiToken
  code: verified
  code_url: https://etherscan.io/address/0x7bd075e70977b8c026ba29624340a70f832df3c9#code
  copies: 1
  upgradeable: 'no'
  admin: '0xafab51b7cc291e2682806f9f9f90e255bb5d6792'
value:
  usd: 0
  whose: users
  basis: held
activity:
  txs_90d: 28
  last: 2026-10-06
impact: liveness
action: Tell holders that once their accounts take real code they must delegate votes with a direct call, not a
  signed message.
evidence_level: source
checks:
- id: ecdsa
  source: '0x7bd075e70977b8c026ba29624340a70f832df3c9'
  file: GrowDeFiToken.sol
  lines:
  - 873
  - 874
  has: address signatory = ecrecover(digest, v, r, s);
  says: delegateBySig recovers the signer with ECDSA and reverts when recovery returns zero
  for:
  - action
  - evidence-1
  - justification
  - what
- id: no-1271
  source: '0x7bd075e70977b8c026ba29624340a70f832df3c9'
  file: GrowDeFiToken.sol
  lines:
  - 873
  - 877
  has: return _delegate(signatory, delegatee);
  says: after recovery the signatory is used directly, with no ERC-1271 or other branch
  for:
  - what
- id: own-votes
  source: '0x7bd075e70977b8c026ba29624340a70f832df3c9'
  file: GrowDeFiToken.sol
  lines:
  - 939
  - 948
  has: uint256 delegatorBalance = balanceOf(delegator);
  says: _delegate moves the delegator's own balance of votes to the delegatee
  for:
  - evidence-1
  - what
  - whose
- id: direct
  source: '0x7bd075e70977b8c026ba29624340a70f832df3c9'
  file: GrowDeFiToken.sol
  lines:
  - 824
  - 826
  has: return _delegate(msg.sender, delegatee);
  says: delegate() lets the caller delegate its own votes with no signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: supply
  call: '0x7bd075e70977b8c026ba29624340a70f832df3c9'
  fn: totalSupply()(uint256)
  is: '14749823260586110777433193'
  says: the token has supply at the block
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
- who: r-7bd075e7, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Author and refuter agree; sheet read by Claude. GrowDeFi: delegateBySig ECDSA-only, delegate direct;
    the owner contract holds about 99.5% of supply. INFORMATIONAL (was LOW).'
related: []
---

## What happens

The GrowDeFi token lets a holder delegate its votes with a signed message that anyone can submit, or by calling the token directly. Once a holder's account takes real code, its signed delegations stop working; an EIP-7702 delegation keeps them working.

## Evidence

- [delegateBySig](https://etherscan.io/address/0x7bd075e70977b8c026ba29624340a70f832df3c9#code) recovers the signer with ECDSA and moves that signer's votes.
- [delegate](https://etherscan.io/address/0x7bd075e70977b8c026ba29624340a70f832df3c9#code) does the same for the caller, with no signature.

## Reviewer notes

### Mechanism

delegateBySig (lines 837-878) builds an EIP-712 digest over (delegatee, nonce, expiry), recovers the signatory with the ecrecover builtin, requires it non-zero, consumes nonces[signatory] and checks expiry, then calls _delegate(signatory, delegatee), which moves the signatory's balance-weighted votes (lines 939-949). There is no ERC-1271 or code-size branch, so under EIP-8151 a signatory with real code recovers as zero and the call reverts with 'invalid signature'. delegate(delegatee) (lines 824-826) calls _delegate(msg.sender, delegatee) with no signature, so the same act stays open to any holder, including one with real code. The token is not a proxy and has no upgrade path. At block 26,438,999 the total supply is 14,749,823 GRDEFI, and the owner, a contract, holds 14,675,207 of it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 path for signers with code: delegateBySig has none (lines 873-877).
- Ruled out: a fixed gas amount for the recovery: the Solidity ecrecover builtin forwards all gas, so nothing breaks before a holder migrates.
- Ruled out: a signature checked again later: the delegation takes effect in the same call.
- Ruled out: the path being closed: the contract has no pause; total supply is non-zero at the block.
- Ruled out: a lost right: delegate() is a direct alternative for the same act (lines 824-826).

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
