---
id: memecoin-b131f4a5-meme-permit
format: 2
title: Memeland MEME accepts ECDSA permits a quantum attacker could forge for holders
status: confirmed
severity: LOW
justification: Forged permits only approve tokenPool; the owner Safe can make the path inert, so the risk is low.
category: quantum-exposure
pattern: PQ-1
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xb131f4a55907b10d1f0a50d8ab8fa09ec342cd74'
  name: Memecoin
  project: memeland
  code: verified
  code_url: https://etherscan.io/address/0xb131f4a55907b10d1f0a50d8ab8fa09ec342cd74#code
  copies: 1
  upgradeable: 'no'
  admin: '0x06b1ba8c14d3dd9486012d2bc962a5a58ec6eaa7'
value:
  usd: 1078
  basis: held
activity:
  txs_90d: 29320
impact: funds-loss
action: Set tokenPool to an address nobody controls, then renounce ownership of the token.
evidence_level: source
checks:
- id: c1
  source: '0xb131f4a55907b10d1f0a50d8ab8fa09ec342cd74'
  file: '@openzeppelin/contracts/token/ERC20/extensions/ERC20Permit.sol'
  line: 64
  has: address signer = ECDSA.recover(hash, v, r, s);
  says: permit accepts the signature when ECDSA.recover returns the owner.
  for:
  - evidence-1
  - justification
  - what
- id: c2
  source: '0xb131f4a55907b10d1f0a50d8ab8fa09ec342cd74'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  line: 139
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile.
  for:
  - evidence-2
  - what
- id: sel-settokenpool
  selector: '0xb131f4a55907b10d1f0a50d8ab8fa09ec342cd74'
  fn: setTokenPool(address)
  says: The owner can change the permit spender tokenPool.
  for:
  - action
  - evidence-3
  - justification
  - what
- id: sel-tokenpool
  selector: '0xb131f4a55907b10d1f0a50d8ab8fa09ec342cd74'
  fn: tokenPool()
  says: The token exposes the tokenPool address.
  for:
  - what
- id: sel-renounce
  selector: '0xb131f4a55907b10d1f0a50d8ab8fa09ec342cd74'
  fn: renounceOwnership()
  says: The owner can renounce ownership.
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
  who: review (Review22)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: LOW
- study: eip-8151-impact
  who: Claude (study families read or judged, the registry text read; not executed; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews: []
related: []
---

## What happens

MEME's permit sets a holder's allowance once ECDSA recovers the holder from the signature. A quantum attacker can forge a permit for any holder whose key has signed. The approval only reaches tokenPool, which the owner sets.

## Evidence

- [permit](https://etherscan.io/address/0xb131f4a55907b10d1f0a50d8ab8fa09ec342cd74#code) approves the spender once ECDSA.recover returns the owner.
- [ECDSA.tryRecover](https://etherscan.io/address/0xb131f4a55907b10d1f0a50d8ab8fa09ec342cd74#code) derives the signer with ecrecover.
- The [token](https://etherscan.io/address/0xb131f4a55907b10d1f0a50d8ab8fa09ec342cd74#code) has setTokenPool and renounceOwnership for its owner.

## Reviewer notes

### Mechanism

Memecoin.permit reverts unless spender == tokenPool, then calls OpenZeppelin ERC20Permit.permit (lines 49-68): ECDSA.recover(hash, v, r, s) at line 64 must equal owner, then _approve(owner, spender, value). ECDSA.tryRecover uses ecrecover (line 139), with no ERC-1271 path. tokenPool is MemecoinDelegate, whose transferFrom is restricted to two authorised Memeland contracts that pull only from their own caller. So a forged permit gives the delegate an allowance nobody can use against the holder, unless the attacker also forges 2 of 3 owners of the token's owner Safe (setTokenPool to the attacker) or of the delegate's owner Safe (addAuthorizedAddress).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: A forged permit alone cannot move tokens: the delegate's authorised callers pull only from msg.sender.
- Ruled out: The token is not a proxy.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
