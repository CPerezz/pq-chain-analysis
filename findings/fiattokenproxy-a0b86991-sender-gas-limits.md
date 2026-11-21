---
id: fiattokenproxy-a0b86991-sender-gas-limits
format: 2
title: Relayed USDC authorization transfers with tight gas limits fail under EIP-8151
status: confirmed
severity: LOW
justification: The sender's gas limit, not a fixed amount in the code, causes the failure; a higher limit fixes
  it.
category: breaks-at-activation
pattern: PQ-18
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  name: FiatTokenProxy
  code: verified
  code_url: https://etherscan.io/address/0x43506849d7c04f9138d1a2050bbf3a0c054402dd#code
  proxy_of: '0x43506849d7c04f9138d1a2050bbf3a0c054402dd'
  copies: 341287
  family: 51dfccec0e9ce7b13786b6898dc14964
  upgradeable: 'yes'
  admin: '0xfcb19e6a322b27c06842a71e8c725399f049ae3a'
value:
  usd: 276417
  basis: held
activity: {}
impact: liveness
action: 'Tell relayers to re-estimate gas under EIP-8151: these transfers needed about 745 gas less than their limits
  yet failed.'
evidence_level: executed
checks:
- id: implslot
  storage: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  slot: '0x7050c9e0f4ca769c69bd3a8ef740bc37934f8e2c036e5a723fd8ee048ed3f8c3'
  is: '0x00000000000000000000000043506849d7c04f9138d1a2050bbf3a0c054402dd'
  says: the proxy's implementation slot holds the FiatToken implementation
  for:
  - proxy_of
- id: adminslot
  storage: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  slot: '0x10d6a54a4754c8869d6886b5f5d7fbfa5b4522237ea5c60d11bc4e7a1ff9390b'
  is: '0x000000000000000000000000807a96288a1a408dbc13de2b1d087d10356395d2'
  says: the proxy admin slot holds a non-zero address
  for:
  - upgradeable
- id: adminnonce
  nonce: '0x807a96288a1a408dbc13de2b1d087d10356395d2'
  min: 3
  says: the proxy admin is an account that has sent transactions
  for:
  - upgradeable
- id: upgradeto
  source: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  file: FiatTokenProxy.sol
  line: 246
  has: function upgradeTo(address newImplementation) external ifAdmin
  says: the admin can replace the implementation
  for:
  - upgradeable
- id: fwd
  source: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  file: FiatTokenProxy.sol
  line: 41
  has: delegatecall(gas, implementation, 0, calldatasize, 0, 0)
  says: the proxy forwards all gas to the implementation
  for:
  - action
  - evidence-3
  - justification
- id: twa
  source: '0x43506849d7c04f9138d1a2050bbf3a0c054402dd'
  file: EIP3009.sol
  lines:
  - 126
  - 127
  has: _requireValidAuthorization(from, nonce, validAfter, validBefore); _requireValidSignature(
  says: transferWithAuthorization checks the authorization and then the signature of `from`
  for:
  - what
- id: reqsig
  source: '0x43506849d7c04f9138d1a2050bbf3a0c054402dd'
  file: EIP3009.sol
  lines:
  - 281
  - 287
  has: SignatureChecker.isValidSignatureNow(
  says: the signature check goes through SignatureChecker and reverts if it fails
  for:
  - evidence-3
  - what
- id: sigbranch
  source: '0x43506849d7c04f9138d1a2050bbf3a0c054402dd'
  file: SignatureChecker.sol
  lines:
  - 43
  - 46
  has: if (!isContract(signer)) { return ECRecover.recover(digest, signature) == signer; } return isValidERC1271SignatureNow(signer,
    digest, signature);
  says: a signer without code is recovered with ecrecover; a signer with code is asked through ERC-1271
  for:
  - evidence-3
  - what
- id: sigstatic
  source: '0x43506849d7c04f9138d1a2050bbf3a0c054402dd'
  file: SignatureChecker.sol
  lines:
  - 64
  - 70
  has: (bool success, bytes memory result) = signer.staticcall( abi.encodeWithSelector( IERC1271.isValidSignature.selector,
    digest, signature ) );
  says: the ERC-1271 call to the signer names no gas amount, so it gets all remaining gas
  for:
  - evidence-3
  - justification
  - what
- id: paused
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: paused()(bool)
  is: false
  says: the token is not paused at the block
  for:
  - what
- id: tx1
  tx: '0xe7aafe9fb6412b4bf1e321a012d31826bae06c5291a6bba6710be9e29c4fafd0'
  to: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  ok: true
  says: the first transfer is a direct call to USDC and succeeded
  for:
  - action
  - evidence-1
  - what
- id: r1today
  replay: '0xe7aafe9fb6412b4bf1e321a012d31826bae06c5291a6bba6710be9e29c4fafd0'
  run: today
  ok: true
  says: the replay reproduces today's success
  for:
  - action
  - evidence-1
- id: r1
  replay: '0xe7aafe9fb6412b4bf1e321a012d31826bae06c5291a6bba6710be9e29c4fafd0'
  run: eip8151
  ok: false
  says: under EIP-8151 the transfer fails as sent
  for:
  - action
  - evidence-1
  - what
- id: r1more
  replay: '0xe7aafe9fb6412b4bf1e321a012d31826bae06c5291a6bba6710be9e29c4fafd0'
  run: eip8151_more_gas
  ok: true
  says: with 300,000 more gas it succeeds under EIP-8151
  for:
  - action
  - evidence-1
  - justification
  - what
- id: deleg1
  code: '0x40c641e8c81c035f9645505af6059fae392dc7ec'
  is: delegation
  target: '0x63c0c19a282a1b52b07dd5a65b58948a07dae32b'
  says: the first transfer's signer holds an EIP-7702 delegation
  for:
  - evidence-1
- id: tx2
  tx: '0x1c02473e41910cea77414a3174c939d212e0ed2baf8df16f695e9d1db02ed0de'
  to: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  ok: true
  says: the second transfer is a direct call to USDC and succeeded
  for:
  - action
  - evidence-2
  - what
- id: r2today
  replay: '0x1c02473e41910cea77414a3174c939d212e0ed2baf8df16f695e9d1db02ed0de'
  run: today
  ok: true
  says: the replay reproduces today's success
  for:
  - action
  - evidence-2
- id: r2
  replay: '0x1c02473e41910cea77414a3174c939d212e0ed2baf8df16f695e9d1db02ed0de'
  run: eip8151
  ok: false
  says: under EIP-8151 the transfer fails as sent
  for:
  - action
  - evidence-2
  - what
- id: r2more
  replay: '0x1c02473e41910cea77414a3174c939d212e0ed2baf8df16f695e9d1db02ed0de'
  run: eip8151_more_gas
  ok: true
  says: with 300,000 more gas it succeeds under EIP-8151
  for:
  - action
  - evidence-2
  - justification
  - what
- id: deleg2
  code: '0x8b2423dded67cd3c37899026eebdc9b0dd381295'
  is: delegation
  target: '0xd2e28229f6f2c235e57de2ebc727025a1d0530fb'
  says: the second transfer's signer holds an EIP-7702 delegation
  for:
  - evidence-2
- id: libext
  source: '0x43506849d7c04f9138d1a2050bbf3a0c054402dd'
  file: SignatureChecker.sol
  lines:
  - 38
  - 42
  has: external view returns (bool)
  says: isValidSignatureNow is an external library function, reached by DELEGATECALL
  for:
  - action
  - evidence-3
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: [circle-usdc-permit-code-first]
---

## What happens

USDC moves tokens on a signed authorization that a relayer submits, and asks the signer's account to confirm it when the account holds code, such as an EIP-7702 delegation. Real transfers sent with tight gas limits fail under EIP-8151 and pass with more gas.

## Evidence

- [A relayed transfer](https://etherscan.io/tx/0xe7aafe9fb6412b4bf1e321a012d31826bae06c5291a6bba6710be9e29c4fafd0) for a delegated account succeeds today, fails under EIP-8151 as sent, and succeeds with more gas.
- [A second relayed transfer](https://etherscan.io/tx/0x1c02473e41910cea77414a3174c939d212e0ed2baf8df16f695e9d1db02ed0de) for another delegated account behaves the same way.
- [The signature check](https://etherscan.io/address/0x43506849d7c04f9138d1a2050bbf3a0c054402dd#code) asks a signer with code through ERC-1271 in an external library; each nested call keeps back 1/64 of its gas.

## Reviewer notes

### Mechanism

The proxy delegates every call with all gas to the implementation in the zeppelinos implementation slot. transferWithAuthorization (selector 0xe3ee160e, v/r/s form) checks the authorization's time window and nonce, then _requireValidSignature calls SignatureChecker.isValidSignatureNow on the EIP-712 digest. For a signer with no code it recovers with ecrecover and compares with `from`; for a signer whose account has code (extcodesize > 0, so an EIP-7702 delegation counts) it staticcalls isValidSignature on that account with all remaining gas, and requires the ERC-1271 magic value. No call in this path pins a gas amount. Both cited transactions are sent straight to USDC by the EOA 0xf7833c90... (nonce 5,067), each with one transferWithAuthorization whose `from` (0x40c641e8..., 0x8b2423dd..., read from the calldata) holds an EIP-7702 delegation (to 0x63c0c19a... and 0xd2e28229...). The fork engine replays both: success as sent today, failure under EIP-8151 as sent (gas limits 92,282 and 92,657), success under EIP-8151 with 300,000 more gas. The only signature checked in each transaction is this one, so the failure is this contract's path running out of the sender's gas.

### Checks

- Header facts: this address alone, at block 26,438,999; 341,287 addresses run this code.
- Ruled out: a gas amount fixed in code: the proxy delegatecall forwards all gas, SignatureChecker staticcalls the signer without a gas argument, and both replays pass under EIP-8151 with 300,000 more gas.
- Ruled out: another signed step failing in the same transaction: both transactions are direct calls to USDC with a single transferWithAuthorization and one signer.
- Ruled out: a paused or retired token: paused() is false at the block.
- Ruled out: an unused implementation: this is the proxy users call; the implementation slot points at 0x43506849d7c04f9138d1a2050bbf3a0c054402dd.
- Ruled out: a migration notice instead: under EIP-8151 an account with an EIP-7702 delegation still recovers, and the replays fail with nobody migrating, so this is the rated gas issue; holders whose accounts take real code are asked through ERC-1271 and keep the signed path.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
