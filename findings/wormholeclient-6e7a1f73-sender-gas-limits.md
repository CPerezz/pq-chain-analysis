---
id: wormholeclient-6e7a1f73-sender-gas-limits
format: 2
title: Audius WormholeClient transfers revert on their sender's tight gas limit
status: candidate
severity: LOW
justification: Breaks with nobody acting; the limit that runs out is the sender's, not one the contract fixes, so
  more gas is enough.
category: breaks-at-activation
pattern: PQ-18
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x6e7a1f7339bbb62b23d44797b63e4258d283e095'
  name: WormholeClient
  project: audius
  code: verified
  code_url: https://etherscan.io/address/0x8ce2fd8af10d5000e11a68ad7695c9375bd8794e#code
  proxy_of: '0x8ce2fd8af10d5000e11a68ad7695c9375bd8794e'
  copies: 2
  family: a64f430d61a1797e1578d27c76a3a6e6
  upgradeable: 'yes'
  admin: '0x4deca517d6817b6510798b7328f2314d3003abac'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: 'Re-estimate the gas limit of transferTokens under EIP-8151: this transfer used 3,100 more gas and still
  failed at its 199,539 limit.'
evidence_level: executed
checks:
- id: domain
  source: '0x8ce2fd8af10d5000e11a68ad7695c9375bd8794e'
  file: WormholeClient.sol
  line: 837
  has: keccak256(bytes("AudiusWormholeClient")),
  says: the signing domain names the contract AudiusWormholeClient
  for:
  - what
- id: ecdsa
  source: '0x8ce2fd8af10d5000e11a68ad7695c9375bd8794e'
  file: WormholeClient.sol
  line: 887
  has: address recoveredAddress = ecrecover(digest, v, r, s);
  says: transferTokens recovers the signer with ecrecover and gives it all remaining gas
  for:
  - action
  - evidence-1
  - justification
  - what
- id: match
  source: '0x8ce2fd8af10d5000e11a68ad7695c9375bd8794e'
  file: WormholeClient.sol
  lines:
  - 888
  - 891
  has: recoveredAddress != address(0) && recoveredAddress == from,
  says: the recovered address must be the account the tokens come from
  for:
  - evidence-1
  - what
- id: pull
  source: '0x8ce2fd8af10d5000e11a68ad7695c9375bd8794e'
  file: WormholeClient.sol
  line: 893
  has: transferToken.safeTransferFrom(from, address(this), amount);
  says: the tokens moved are the signer's own
  for:
  - evidence-1
  - what
  - whose
- id: pull-call
  source: '0x8ce2fd8af10d5000e11a68ad7695c9375bd8794e'
  file: WormholeClient.sol
  line: 385
  has: (bool success, bytes memory returndata) = address(token).call(data);
  says: the token call forwards all remaining gas, with no fixed amount
  for:
  - action
  - justification
- id: bridge-call
  source: '0x8ce2fd8af10d5000e11a68ad7695c9375bd8794e'
  file: WormholeClient.sol
  lines:
  - 896
  - 903
  has: wormhole.transferTokens(
  says: the bridge call is a plain call with no fixed gas amount
  for:
  - action
  - justification
- id: token-set
  call: '0x6e7a1f7339bbb62b23d44797b63e4258d283e095'
  fn: token()(address)
  is: '0x18aAA7115705e8be94bfFEBDE57Af9BFc265B998'
  says: the proxy is initialized with a token
  for:
  - what
- id: admin
  call: '0x6e7a1f7339bbb62b23d44797b63e4258d283e095'
  fn: getAudiusProxyAdminAddress()(address)
  is: '0x4deca517d6817b6510798b7328f2314d3003abac'
  says: the proxy's admin, kept in its own slot rather than the EIP-1967 admin slot
  for:
  - admin
  - upgradeable
- id: impl-uninit
  call: '0x8ce2fd8af10d5000e11a68ad7695c9375bd8794e'
  fn: token()(address)
  reverts_with: 'InitializableV2: Not initialized'
  says: the other copy, the implementation, was never initialized
  for:
  - notes
- id: tx-ok
  tx: '0x8fb5d3ff9f5b01f7498fbfe87d9ea2e14d3609314ccfb33d6b35e1c74e706d67'
  to: '0x6e7a1f7339bbb62b23d44797b63e4258d283e095'
  ok: true
  says: a real transferTokens call to this proxy succeeded
  for:
  - evidence-2
  - what
- id: r-today
  replay: '0x8fb5d3ff9f5b01f7498fbfe87d9ea2e14d3609314ccfb33d6b35e1c74e706d67'
  run: today
  ok: true
  says: the replay without the change reproduces the success
  for:
  - evidence-2
  - what
- id: r-8151
  replay: '0x8fb5d3ff9f5b01f7498fbfe87d9ea2e14d3609314ccfb33d6b35e1c74e706d67'
  run: eip8151
  ok: false
  says: under EIP-8151, with the sender's own gas limit, the same transaction reverts
  for:
  - action
  - evidence-2
  - justification
  - what
- id: r-code
  replay: '0x8fb5d3ff9f5b01f7498fbfe87d9ea2e14d3609314ccfb33d6b35e1c74e706d67'
  run: eip8151_signer_code
  ok: false
  says: with real code at the signer the transaction reverts as well (the separate migration notice)
  for:
  - notes
- id: r-more-gas
  replay: '0x8fb5d3ff9f5b01f7498fbfe87d9ea2e14d3609314ccfb33d6b35e1c74e706d67'
  run: eip8151_more_gas
  ok: true
  says: the same transaction, with 300,000 more gas, succeeds under EIP-8151
  for:
  - action
  - justification
- id: upgrade-gate
  source: '0x6e7a1f7339bbb62b23d44797b63e4258d283e095'
  file: AudiusAdminUpgradeabilityProxy.sol
  lines:
  - 240
  - 242
  has: "function upgradeTo(address _newImplementation) external {\n        require(msg.sender == proxyAdmin, ERROR_ONLY_ADMIN);"
  says: only the proxy admin can change the implementation
  for:
  - upgradeable
- id: admin-code
  code: '0x4deca517d6817b6510798b7328f2314d3003abac'
  is: contract
  says: the proxy admin is a live contract, not an unset or burned key
  for:
  - upgradeable
- id: signer-empty
  code: '0x9707e14aff5849fa2af33a0966841934773863dd'
  is: empty
  says: the recovered signer has no code, so EIP-8151 still returns it
  for:
  - evidence-2
  - justification
  - what
- id: signer-nonce
  nonce: '0x9707e14aff5849fa2af33a0966841934773863dd'
  is: 0
  says: the signer never sent a transaction itself; someone else submitted its transfer
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

Audius's WormholeClient moves a user's tokens to the Wormhole bridge when the user signs the transfer and someone else submits it. A real relayed transfer that passes today reverts under EIP-8151 with the gas its sender gave, because the signature check costs more.

## Evidence

- [transferTokens](https://etherscan.io/address/0x8ce2fd8af10d5000e11a68ad7695c9375bd8794e#code) recovers the signer, requires it to equal `from`, then pulls the tokens from `from`.
- [This transfer](https://etherscan.io/tx/0x8fb5d3ff9f5b01f7498fbfe87d9ea2e14d3609314ccfb33d6b35e1c74e706d67) succeeds today and reverts replayed under EIP-8151; its signer has no code.

## Reviewer notes

### Mechanism

The proxy 0x6e7a…e095 (AudiusAdminUpgradeabilityProxy) delegates to WormholeClient 0x8ce2…794e; upgradeTo (proxy lines 240-243) lets the proxy admin 0x4DEc…AbAC, a contract at the block, replace the implementation. transferTokens (lines 853-904) builds an EIP-712 digest over from, amount, chain, recipient, fee, nonce and deadline, calls ecrecover with all remaining gas (line 887), requires the result to be non-zero and equal to from (lines 888-891), pulls amount from from with safeTransferFrom (line 893, a plain .call with all gas, line 385), approves the bridge and calls wormhole.transferTokens (lines 896-903) with all gas. No call in the path fixes a gas amount, so the only gas limit is the transaction's. Real transaction 0x8fb5…6d67 (block 26,387,393) was sent by the EOA 0x1a42…f1cb with a 199,539 gas limit and used 156,106; the recovered signer 0x9707…63dd has no code and nonce 0 at block 26,438,999, so EIP-8151 still returns it and only the recovery's price changes. Replayed under EIP-8151 the transaction reverts (194,844 gas used), and the same with a 7702 delegation at the signer; with 300,000 more gas it succeeds (159,206 used). The study's replay job lists one recovery in the transaction, in this contract, so no other signed step is bundled. State at the block: initialized (token() answers 0x18aA…B998), nonces(signer) is 1.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: a gas amount fixed in the code (that would be the fixed-gas root issue): ecrecover, the token pull and the bridge call all forward the remaining gas (lines 887, 385, 896-903).
- Ruled out: a bundled signed step that fails for another reason: the transaction calls transferTokens on this proxy directly, and the study's replay job counts a single recovery, in this contract.
- Ruled out: a signer with code: 0x9707…63dd has no code and nonce 0 at the block, so the EIP-8151 run differs from today only by the recovery's price.
- Ruled out: an unused copy: the other address running this code is the implementation 0x8ce2…794e itself, which is not initialized (token() reverts 'InitializableV2: Not initialized'); this proxy is the copy in use.
- Ruled out: beside this rated issue there is a migration notice: transferTokens has no ERC-1271 or direct path, so a user whose account takes real code can no longer use it (the replay with code at the signer reverts); an EIP-7702 delegation still recovers. That notice is a separate finding for the reviewer to link.
- Ruled out: Number from the replays (156,106 gas today, 159,206 with more gas); nested calls keep back 1/64.

### Questions

- Who runs the sender 0x1a42f739652a56f98dafbea38215b088ac00f1cb is not shown by any check; it is presumably the transfer relayer, but no check ties it to Audius.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
