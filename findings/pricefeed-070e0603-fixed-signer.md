---
id: pricefeed-070e0603-fixed-signer
format: 2
title: Price feed stops updating if its fixed attester moves its account to real code
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless the attester's account takes real code; the key is fixed, so a new feed would
  then be needed.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x070e0603737242b01abc1d223f7c92d63e86ec97'
  name: PriceFeed
  code: verified
  code_url: https://etherscan.io/address/0x070e0603737242b01abc1d223f7c92d63e86ec97#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1274
  last: 2026-11-17
impact: liveness
action: Ask the oracle service to warn before its attester takes real code; a new key needs a new feed and a new
  0x297b85af…, which pins it.
evidence_level: source
checks:
- id: recover
  source: '0x070e0603737242b01abc1d223f7c92d63e86ec97'
  file: src/SwarmFeed.sol
  line: 273
  has: if (_recover(digest, sig) != attester) revert InvalidSignature();
  says: an attestation is rejected unless the recovered address equals the attester
  for:
  - evidence-1
  - justification
  - what
- id: ecrecover
  source: '0x070e0603737242b01abc1d223f7c92d63e86ec97'
  file: src/SwarmFeed.sol
  line: 390
  has: signer = ecrecover(digest, v, r, s);
  says: the recovery is a plain ecrecover with no branch for a signer with code
  for:
  - evidence-1
  - what
- id: accept
  source: '0x070e0603737242b01abc1d223f7c92d63e86ec97'
  file: src/SwarmFeed.sol
  line: 279
  has: _accept(value, a.issuedAt);
  says: the value is stored inside submitAttestation, after the signature check
  for:
  - what
- id: immutable
  source: '0x070e0603737242b01abc1d223f7c92d63e86ec97'
  file: src/SwarmFeed.sol
  line: 136
  has: address public immutable attester;
  says: the attester is an immutable, so no function can replace it
  for:
  - action
  - evidence-1
  - justification
  - what
- id: nonzero
  source: '0x070e0603737242b01abc1d223f7c92d63e86ec97'
  file: src/SwarmFeed.sol
  line: 190
  has: if (attester_ == address(0)
  says: the attester cannot be the zero address, so an empty recovery never matches it
  for:
  - what
- id: constant
  source: '0x070e0603737242b01abc1d223f7c92d63e86ec97'
  file: src/DeploymentConfig.sol
  line: 60
  has: address constant ORACLE_ATTESTER = 0x5598Aa9146215Bc13eb26f2c692Ad1461Fd32982;
  says: the attester address is a constant of the source
  for:
  - evidence-2
- id: attester
  call: '0x070e0603737242b01abc1d223f7c92d63e86ec97'
  fn: attester()(address)
  is: '0x5598aa9146215bc13eb26f2c692ad1461fd32982'
  says: the attester the feed checks against
  for:
  - evidence-2
  - what
- id: attester-code
  code: '0x5598aa9146215bc13eb26f2c692ad1461fd32982'
  is: empty
  says: the attester's account has no code at the block
  for:
  - evidence-2
  - justification
- id: stale
  call: '0x070e0603737242b01abc1d223f7c92d63e86ec97'
  fn: isStale()(bool)
  is: true
  says: the feed reports its value as stale at the block
  for:
  - what
- id: maxage
  call: '0x070e0603737242b01abc1d223f7c92d63e86ec97'
  fn: maxAge()(uint256)
  is: 3600
  says: a value is fresh for 3,600 seconds
  for:
  - what
- id: service-key
  source: '0x070e0603737242b01abc1d223f7c92d63e86ec97'
  file: src/SwarmFeed.sol
  line: 521
  has: whose key is the oracle service's and not ours
  says: the attester key belongs to the oracle service, not to the feed's team
  for:
  - action
- id: attester-src
  source: '0x070e0603737242b01abc1d223f7c92d63e86ec97'
  file: src/DeploymentConfig.sol
  line: 59
  has: Signer of every IdentityMD oracle attestation, recovered from live attestation signatures.
  says: the attester was taken from the oracle service's live signatures
  for:
  - action
- id: ondemand
  source: '0x070e0603737242b01abc1d223f7c92d63e86ec97'
  file: src/SwarmFeed.sol
  line: 45
  has: Price feeds live one hour and are bought on demand, so being stale is their normal state,
  says: staleness between purchases is the feed's normal state by design
  for:
  - what
- id: dependent
  bytecode: '0x297b85afc6bbf9d9cca636f7ed74c56da79287a0'
  has: 7f000000000000000000000000070e0603737242b01abc1d223f7c92d63e86ec97
  says: contract 0x297b85af… holds this feed's address as a constant in its code
  for:
  - action
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews: []
related: []
---

## What happens

This price feed takes a new price only when signed by one attester key fixed at deployment. If that account takes real code, its signatures fail and the price stops updating; an EIP-7702 delegation still works. Prices are bought on demand and live an hour, so being stale between purchases is normal.

## Evidence

- The [verified source](https://etherscan.io/address/0x070e0603737242b01abc1d223f7c92d63e86ec97#code) rejects an attestation unless ecrecover returns the attester, an immutable.
- The [attester](https://etherscan.io/address/0x5598aa9146215bc13eb26f2c692ad1461fd32982) is a constant of the source and its account has no code today.

## Reviewer notes

### Mechanism

submitAttestation (SwarmFeed.sol 262-281) checks the caller is the immutable relayer 0x9aeb55c7… (a contract), validates the payload, builds an EIP-712 digest and reverts InvalidSignature unless _recover (379-391, a plain ecrecover with all gas, low-s and v checked) equals the immutable attester. Only then _accept (526-536) stores the value. The constructor refuses a zero attester (190), so an empty ecrecover result never matches. PriceFeed passes ORACLE_ATTESTER, a constant of DeploymentConfig.sol (line 60), and adds no function that sets a value. No owner, admin or setter; not a proxy. At the block: attester() is 0x5598aa91… with no code and nonce 0; isStale() is true, the last value is stamped 1794926491, 42,988 s before the block's timestamp, with maxAge 3600; 64 recoveries of that attester in the study's two-week window, the last at block 26435431, so the feed is in use and refreshed on demand rather than on a clock (SwarmFeed.sol 45, DeploymentConfig.sol 31-37). The attester key is the oracle service's (SwarmFeed.sol 521, DeploymentConfig.sol 59).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: An ERC-1271 or code-size branch for the attester: _recover (379-391) is a bare ecrecover and line 273 compares its result with the immutable; there is none.
- Ruled out: A second way to set the value: _accept is internal and its only call in the verified source is line 279, after the signature check; PriceFeed.sol adds only minAgreed and questionPolicy; no reporter, owner or setter function exists.
- Ruled out: Key unset or already a contract: attester() returns 0x5598aa91… and its code is empty at the block.
- Ruled out: Breaks by itself: the scanner found no constant gas on the precompile call and the source uses the Solidity ecrecover builtin; the dossier lists no replay, so this is read from source, not executed. The relayer 0x9aeb55c7… (8,127 hex chars of code) and the callers above it were not read for gas caps.
- Ruled out: Path closed for good: the feed is stale at the block, but staleness is not closure; submitAttestation accepts a fresh attestation at any time and 64 landed in the window.
- Ruled out: Read only as bytecode: the dependent 0x297b85af… pushes this feed's address as a constant (4 times) and also holds Chainlink's ETH/USD feed 0x5f4ec3df…; what it stops when this feed is stale is not claimed. The project is not named: the source names only the oracle service's EIP-712 domain, 'IdentityMD Oracle', which is not shown to be this contract's team.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
