---
id: fairtoken-34b5f666-signed-shortcut-lost
format: 2
title: FAIR holders whose accounts take real code lose signed vote delegation
status: confirmed
severity: INFORMATIONAL
justification: A holder that moves its account to real code loses only the signed way to delegate; the direct call
  stays open.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x34b5f6669aba48c419b266e6bcb9f5ad03d66fba'
  name: FairToken
  code: verified
  code_url: https://etherscan.io/address/0x34b5f6669aba48c419b266e6bcb9f5ad03d66fba#code
  copies: 2
  family: 69fb2629de1b7d8396499470a1df1cb7
  upgradeable: 'no'
  admin: '0xf42ec65e678a0e3f990a819a3d9ca10ec1c62e3e'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: Tell holders whose accounts take real code to delegate by calling delegate directly, since signed delegation
  stops for them.
evidence_level: source
checks:
- id: sig
  source: '0x34b5f6669aba48c419b266e6bcb9f5ad03d66fba'
  file: FairToken.sol
  line: 903
  has: address signatory = ecrecover(digest, v, r, s);
  says: delegateBySig recovers the signer with ecrecover
  for:
  - evidence-1
  - justification
  - what
- id: sig-zero
  source: '0x34b5f6669aba48c419b266e6bcb9f5ad03d66fba'
  file: FairToken.sol
  line: 904
  has: 'require(signatory != address(0), "FAIR::delegateBySig: invalid signature");'
  says: an empty recovery makes delegateBySig revert
  for:
  - action
  - justification
  - what
- id: sig-self
  source: '0x34b5f6669aba48c419b266e6bcb9f5ad03d66fba'
  file: FairToken.sol
  line: 907
  has: return _delegate(signatory, delegatee);
  says: the signer changes its own delegate
  for:
  - evidence-1
  - what
  - whose
- id: votes
  source: '0x34b5f6669aba48c419b266e6bcb9f5ad03d66fba'
  file: FairToken.sol
  lines:
  - 972
  - 978
  has: uint256 delegatorBalance = balanceOf(delegator);
  says: _delegate moves the delegator's own token balance of votes
  for:
  - whose
- id: direct
  source: '0x34b5f6669aba48c419b266e6bcb9f5ad03d66fba'
  file: FairToken.sol
  lines:
  - 854
  - 856
  has: return _delegate(msg.sender, delegatee);
  says: delegate lets the caller set its delegate without a signature
  for:
  - action
  - evidence-1
  - justification
  - what
- id: supply-here
  call: '0x34b5f6669aba48c419b266e6bcb9f5ad03d66fba'
  fn: totalSupply()(uint256)
  is: '0'
  says: this address has no tokens in circulation
  for:
  - evidence-2
  - what
- id: supply-copy
  call: '0x3bbaf639f381b2d75b321903a921850fc2fe1538'
  fn: totalSupply()(uint256)
  is: '386225277109376867729270179'
  says: the copy holds the token supply (18 decimals)
  for:
  - evidence-2
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-34b5f666, the row's refuter
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: Author and refuter agree; sheet read by Claude. The card is true for both copies and says this address
    has no supply while 0x3bbaf639…1538 holds the 386M FAIR. Depending on Anon''s question 1, the card may move
    to the live copy; its text stays true either way.'
related: []
---

## What happens

FairToken lets a holder delegate its votes by calling delegate or by signing a message that anyone can submit. A holder whose account takes real code can no longer sign; an EIP-7702 delegation still can. This address has no tokens in circulation; its copy at 0x3bbaf639…1538 holds the supply.

## Evidence

- [delegateBySig](https://etherscan.io/address/0x34b5f6669aba48c419b266e6bcb9f5ad03d66fba#code) recovers the signer with ecrecover and sets that signer's delegate; delegate does the same for the caller.
- Total supply is 0 at this address and 386,225,277 FAIR at its [copy](https://etherscan.io/address/0x3bbaf639f381b2d75b321903a921850fc2fe1538#code), which runs the same code.

## Reviewer notes

### Mechanism

delegateBySig (lines 867-908) builds an EIP-712 digest over delegatee, nonce and expiry, recovers the signatory with ecrecover (line 903), requires it to be non-zero (904), consumes the signatory's nonce (905), checks expiry (906) and calls _delegate(signatory, delegatee) (907). _delegate (969-979) moves the signatory's whole balance of votes to the new delegate. delegate (854-856) does the same for msg.sender with no signature. Under EIP-8151 the recovery returns nothing for a signatory with real code, so the call reverts at line 904 and that holder must use delegate. No ERC-1271 path exists in the file. At block 26,438,999 this address has totalSupply 0 (no public burn: _burn at line 659 is never called), its owner is the contract 0xf42e…2e3e; the copy 0x3bba…1538 has 386,225,277 FAIR and owner 0xdd34…1b (a contract). The vote counts are only read by getCurrentVotes/getPriorVotes; the dossier lists no dependents, so no contract reading these votes was shown.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 or code-size branch for signers with code: the file has no isValidSignature and delegateBySig has none (lines 867-908).
- Ruled out: a fixed gas amount to the precompile: the solidity ecrecover builtin forwards the available gas, and the scan records no constant gas for this code.
- Ruled out: a signature checked again after others relied on it: the signature takes effect once in the same call; nothing later re-verifies it.
- Ruled out: proxy or implementation-only use: the address is not a proxy and has its own state; it has zero supply, so the copy 0x3bbaf639…1538 is the one in use, and the card says so.
- Ruled out: a closed path: there is no pause or switch; delegateBySig stays callable at both addresses.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
