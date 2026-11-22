---
id: appproxyupgradeable-ae7ab965-steth-permit-code-first
format: 2
title: Lido stETH permit shuts out smart accounts with post-quantum signers
status: confirmed
severity: LOW
justification: 'Low: PQ accounts lose only gasless permit, approve remains; Lido DAO can fix it by upgrading the
  Lido app'
category: quantum-exposure
pattern: PQ-3
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xae7ab96520de3a18e5e111b5eaab095312d7fe84'
  name: AppProxyUpgradeable
  project: lido
  code: verified
  code_url: https://etherscan.io/address/0xae7ab96520de3a18e5e111b5eaab095312d7fe84#code
  copies: 1
value:
  usd: 3471083
  basis: held
activity:
  txs_90d: 228058
impact: liveness
action: Upgrade the Lido app with a permit overload taking a bytes signature that passes it whole to ERC-1271
evidence_level: source
checks:
- id: proxy-fwd
  source: '0xae7ab96520de3a18e5e111b5eaab095312d7fe84'
  file: AppProxyUpgradeable.sol
  has: delegatedFwd(target, msg.data);
  line: 283
  says: The fallback delegates all calls to the implementation
  for:
  - evidence-1
  - what
- id: proxy-impl
  source: '0xae7ab96520de3a18e5e111b5eaab095312d7fe84'
  file: AppProxyUpgradeable.sol
  has: return getAppBase(appId());
  line: 383
  says: The implementation is the Kernel's app base for this appId
  for:
  - action
  - evidence-2
  - justification
  - what
- id: kernel-getapp
  source: '0xae7ab96520de3a18e5e111b5eaab095312d7fe84'
  file: AppProxyUpgradeable.sol
  has: return kernel().getApp(KERNEL_APP_BASES_NAMESPACE, _appId);
  line: 355
  says: The app base is looked up in the Kernel
  for:
  - evidence-2
  - what
- id: kernel-setapp
  source: '0xae7ab96520de3a18e5e111b5eaab095312d7fe84'
  file: AppProxyUpgradeable.sol
  has: function setApp(bytes32 namespace, bytes32 appId, address app) public;
  line: 100
  says: The Kernel can set a new app base, which is how an upgrade is done
  for:
  - action
  - evidence-2
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review07 (registry review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
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

The stETH proxy forwards every call, including permit, to the Lido implementation that the Aragon Kernel names. That permit sends account-holding owners' ERC-1271 check only a 65-byte (v, r, s) signature, so a post-quantum smart account cannot sign a permit; nothing extra is forgeable.

## Evidence

- The [fallback](https://etherscan.io/address/0xae7ab96520de3a18e5e111b5eaab095312d7fe84#code) delegates every call to the implementation, where permit takes the signature as (v, r, s).
- [implementation()](https://etherscan.io/address/0xae7ab96520de3a18e5e111b5eaab095312d7fe84#code) reads the app base from the Kernel, so a Kernel setApp upgrade changes permit.

## Reviewer notes

### Mechanism

The AppProxyUpgradeable fallback (line 251) forwards calls with delegatedFwd to implementation() (line 382). implementation() returns kernel().getApp(KERNEL_APP_BASES_NAMESPACE, appId) (line 355). In the Lido implementation, StETHPermit.permit(_owner,_spender,_value,_deadline,_v,_r,_s) builds an EIP-712 hash and calls SignatureUtils.isValidSignature. When the owner has code, that function calls ERC-1271 isValidSignature(hash, abi.encodePacked(r,s,v)). Otherwise it uses ECDSA.recover(hash,v,r,s) == owner. The 65-byte interface cannot carry a post-quantum signature, so post-quantum smart accounts are locked out of permit and must use approve or Permit2. The Lido DAO fixes this through Kernel.setApp, via Agent under Dual Governance.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No forgery beyond each account's own key: owners with code are asked through ERC-1271, and code-less owners use ecrecover.
- Ruled out: No funds are exposed through this check; approve remains as an alternative.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
