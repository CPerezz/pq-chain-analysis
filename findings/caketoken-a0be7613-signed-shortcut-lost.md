---
id: caketoken-a0be7613-signed-shortcut-lost
format: 2
title: HYDX holders with real code lose vote delegation by signature
status: confirmed
severity: INFORMATIONAL
justification: 'Nothing is locked: a holder with real code loses delegation by signature and still delegates by
  a direct call.'
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa0be76135289aeb5781923ee0d47ca5527821f59'
  name: CakeToken
  code: verified
  code_url: https://etherscan.io/address/0xa0be76135289aeb5781923ee0d47ca5527821f59#code
  copies: 1
  upgradeable: 'no'
  admin: '0x4a712867409f569038c919c6e32550c8f3a73939'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 26
  last: 2026-11-14
impact: liveness
action: Tell holders to delegate with a direct call to delegate once their account has real code; signed delegations
  stop for them.
evidence_level: source
checks:
- id: recover
  source: '0xa0be76135289aeb5781923ee0d47ca5527821f59'
  file: contracts/CakeToken.sol
  line: 86
  has: address signatory = ecrecover(digest, v, r, s);
  says: delegateBySig recovers the signer of the delegation with ecrecover
  for:
  - action
  - evidence-1
  - justification
  - what
- id: zero
  source: '0xa0be76135289aeb5781923ee0d47ca5527821f59'
  file: contracts/CakeToken.sol
  line: 87
  has: 'require(signatory != address(0), "CAKE::delegateBySig: invalid signature");'
  says: a recovery that returns the zero address reverts
  for:
  - action
  - evidence-1
  - justification
  - what
- id: apply
  source: '0xa0be76135289aeb5781923ee0d47ca5527821f59'
  file: contracts/CakeToken.sol
  line: 90
  has: return _delegate(signatory, delegatee);
  says: the recovered signer is the account whose delegate is set
  for:
  - evidence-1
  - what
- id: direct
  source: '0xa0be76135289aeb5781923ee0d47ca5527821f59'
  file: contracts/CakeToken.sol
  lines:
  - 64
  - 66
  has: return _delegate(msg.sender, delegatee);
  says: delegate sets the caller's delegate with no signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: direct-live
  selector: '0xa0be76135289aeb5781923ee0d47ca5527821f59'
  fn: delegate(address)
  says: the direct delegate function is in the code that runs
  for:
  - action
  - evidence-2
  - justification
- id: bysig-live
  selector: '0xa0be76135289aeb5781923ee0d47ca5527821f59'
  fn: delegateBySig(address,uint256,uint256,uint8,bytes32,bytes32)
  says: the signed delegation function is in the code that runs
  for:
  - what
- id: symbol
  call: '0xa0be76135289aeb5781923ee0d47ca5527821f59'
  fn: symbol()(string)
  is: HYDX
  says: the token's symbol is HYDX
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-a0be7613, the row's refuter
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
    Kept as before (HYDX).'
related: []
---

## What happens

HYDX is a token whose holders delegate their votes by a direct call or by an ECDSA signature that anyone can submit. A holder whose account has real code can no longer delegate by signature; it still delegates by calling the token itself.

## Evidence

- [delegateBySig](https://etherscan.io/address/0xa0be76135289aeb5781923ee0d47ca5527821f59#code) recovers the signer with ecrecover, rejects the zero address and sets that signer's delegate.
- [delegate](https://etherscan.io/address/0xa0be76135289aeb5781923ee0d47ca5527821f59#code) sets the caller's delegate and takes no signature.

## Reviewer notes

### Mechanism

delegateBySig (contracts/CakeToken.sol, lines 77-91) builds an EIP-712 digest, calls ecrecover (line 86), requires a non-zero result (line 87), checks nonces[signatory] and the expiry (lines 88-89), then calls _delegate(signatory, delegatee) (line 90). The recovered address is compared with nothing else: whoever signed is the delegator. Under EIP-8151 a signer with real code recovers to zero and line 87 reverts. delegate (lines 64-66) calls _delegate(msg.sender, delegatee) with no signature, so the same act stays open to an account with code. The recovery is a plain Solidity 0.6.12 ecrecover with no fixed gas amount. A delegation already written stays in _delegates after the signer migrates; nothing re-checks the signature. The contract is not a proxy and has no pause; the owner (a contract) can mint (lines 9-12 and BEP20.sol line 211) and transfer or renounce ownership (Ownable.sol), nothing that touches delegation. The source has one ecrecover, at line 86. The token is a fork of the PancakeSwap CakeToken source and names itself Hyper-Dex Exchange, symbol HYDX.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size branch for signers with code: delegateBySig has none (lines 77-91); the only signature check is the ecrecover at line 86.
- Ruled out: no direct path: delegate(address) at lines 64-66 does the same _delegate for msg.sender, and its selector is in the runtime code.
- Ruled out: a closed path: CakeToken.sol has no pause or switch on delegate or delegateBySig; both selectors are in the code at the block.
- Ruled out: a signature re-checked later: the signature is used once in delegateBySig and the result is stored in _delegates (line 147); no other function recovers.
- Ruled out: breaking by itself: the scanner reads no constant gas for the precompile call, and the source uses the high-level ecrecover; the dossier lists no replays to run.
- Ruled out: unused implementation: the address is not a proxy target in the dossier, and totalSupply() at the block is 27226964800000000000000000.
- Ruled out: value: the address holds $0 at the block, so whose is left empty.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
