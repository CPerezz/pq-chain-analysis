---
id: contract-20e2288d-rotate-signer-before-migrating
format: 2
title: Quotes from a provider whose account takes real code stop being accepted
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a quote provider moves its account to real code; the owner can approve a new provider
  key first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x20e2288d9ce9f6356f45e0f950fa782a12dd1d03'
  code: decompiled
  code_url: code/0x4a32f9b292feac50d745b55ecaa258214e10c12e3a303ebb93e7dd7acc0f3927.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 13
  last: 2026-11-17
impact: liveness
action: Approve the provider's new key on the contract it serves before the current quote provider moves its account
  to real code.
evidence_level: executed
checks:
- id: zero-signer
  bytecode: '0x20e2288d9ce9f6356f45e0f950fa782a12dd1d03'
  has: 01600160a01b038316610cea576040516337e8456b60e01b815260
  says: after the recovery the code reverts with 0x37e8456b when the recovered address is zero
  for:
  - what
- id: no-1271
  selector: '0x20e2288d9ce9f6356f45e0f950fa782a12dd1d03'
  fn: isValidSignature(bytes32,bytes)
  absent: true
  says: this code has no ERC-1271 path for a signer with code
  for:
  - what
- id: vault-slot
  storage: '0x68f77dfabc311df0530b24b22e4d7da413d4f054'
  slot: 163
  is: '0x20e2288d9ce9f6356f45e0f950fa782a12dd1d03'
  says: the vault stores this contract as its quote checker
  for:
  - what
- id: vault-calls
  bytecode: '0x39e9f3fe8f71818b86a8be163995d4f34039579a'
  has: 60a3546040516306d7ce8160e01b815273beefeee67296951651296456e543894de2e8a966916306d7ce81916121479185916099916001600160a01b03169060a090600401
  says: the vault's quote path loads slot 163 and delegatecalls the library with slots 0x99 and 0xa0
  for:
  - what
- id: lib-check
  bytecode: '0xbeefeee67296951651296456e543894de2e8a966'
  has: 5b506001600160a01b03811660009081526020859052604090205490915060ff1661063f576040516282b42960e81b815260040160405180910390fd
  says: after the verifier call the library reverts Unauthorized unless mapping[signer] is set
  for:
  - what
- id: lib-calls
  bytecode: '0xbeefeee67296951651296456e543894de2e8a966'
  has: 63f6293486
  says: the library calls the quote check of this contract (selector 0xf6293486)
  for:
  - notes
- id: approved
  call: '0x68f77dfabc311df0530b24b22e4d7da413d4f054'
  fn: quoteProviders(address)(bool)
  args:
  - '0x2f673fc3c8ca9700df43d30d68fe3ac851531e8c'
  is: true
  says: the provider recovered in real transactions is approved
  for:
  - evidence-2
  - what
- id: setter-code
  bytecode: '0x39e9f3fe8f71818b86a8be163995d4f34039579a'
  has: 600081815260a06020908152604091829020805460ff1916851515908117909155
  says: a function writes the bool mapping at slot 0xa0 (quoteProviders)
  for:
  - action
  - evidence-2
  - justification
  - what
- id: setter-event
  bytecode: '0x39e9f3fe8f71818b86a8be163995d4f34039579a'
  has: 7f47c70bb1526c07afd34cff9782f8d258035d0275fbdc5beb1ee6f944724bab07
  says: the implementation emits QuoteProviderSet(address,bool)
  for:
  - notes
- id: setter-owner
  call: '0x68f77dfabc311df0530b24b22e4d7da413d4f054'
  data: '0x96e041d50000000000000000000000002f673fc3c8ca9700df43d30d68fe3ac851531e8c0000000000000000000000000000000000000000000000000000000000000000'
  from: '0x67540f004d06b0145278857e1ec2b9507bbfaee8'
  is: 0x
  says: the owner can call the provider setter (0x96e041d5) at the block
  for:
  - action
  - evidence-2
  - justification
  - what
- id: setter-stranger
  call: '0x68f77dfabc311df0530b24b22e4d7da413d4f054'
  data: '0x96e041d50000000000000000000000002f673fc3c8ca9700df43d30d68fe3ac851531e8c0000000000000000000000000000000000000000000000000000000000000000'
  from: '0x6593cae3336ce36e6f7338f7103d2b07226fc297'
  reverts_with: 'Ownable: caller is not the owner'
  says: anyone else is refused
  for:
  - evidence-2
  - what
- id: owner
  call: '0x68f77dfabc311df0530b24b22e4d7da413d4f054'
  fn: owner()(address)
  is: '0x67540f004d06b0145278857e1ec2b9507bbfaee8'
  says: the vault's owner
  for:
  - action
  - evidence-2
- id: owner-eoa
  nonce: '0x67540f004d06b0145278857e1ec2b9507bbfaee8'
  min: 1
  says: the owner key has sent transactions
  for:
  - notes
- id: provider-eoa
  code: '0x2f673fc3c8ca9700df43d30d68fe3ac851531e8c'
  is: empty
  says: the approved provider has no code today
  for:
  - notes
- id: tx
  tx: '0x4ae18e5afe9ae0ddff681a405fed77723904dc7817b07ae8da447e19c23e204f'
  to: '0x68f77dfabc311df0530b24b22e4d7da413d4f054'
  ok: true
  says: a real quote trade through the vault succeeded
  for:
  - evidence-1
- id: replay-alone
  replay: '0x4ae18e5afe9ae0ddff681a405fed77723904dc7817b07ae8da447e19c23e204f'
  run: eip8151
  ok: true
  says: under EIP-8151 alone the trade still succeeds
  for:
  - justification
- id: replay-code
  replay: '0x4ae18e5afe9ae0ddff681a405fed77723904dc7817b07ae8da447e19c23e204f'
  run: eip8151_signer_code
  ok: false
  says: with real code at the provider the trade reverts
  for:
  - evidence-1
  - justification
  - what
- id: replay-deleg
  replay: '0x4ae18e5afe9ae0ddff681a405fed77723904dc7817b07ae8da447e19c23e204f'
  run: eip8151_signer_delegated
  ok: true
  says: with an EIP-7702 delegation at the provider it succeeds
  for:
  - evidence-1
  - what
- id: lib-no-recheck
  bytecode: '0xbeefeee67296951651296456e543894de2e8a966'
  has: 63da00f047
  absent: true
  says: the library never calls the other recovering function of this contract
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews: []
related: []
---

## What happens

It checks the signed quotes used by the contract at 0x68f77dfabc311df0530b24b22e4d7da413d4f054, which takes quotes from providers its owner approves. Once a provider's account takes real code, its quotes are rejected; an EIP-7702 delegation keeps working.

## Evidence

- [A real trade](https://etherscan.io/tx/0x4ae18e5afe9ae0ddff681a405fed77723904dc7817b07ae8da447e19c23e204f) replayed with real code at the provider reverts; with an EIP-7702 delegation it succeeds.
- [The contract it serves](https://etherscan.io/address/0x68f77dfabc311df0530b24b22e4d7da413d4f054) has the provider approved, and its owner can approve or remove providers.

## Reviewer notes

### Mechanism

Unverified. The quote function (selector 0xf6293486) builds the EIP-712 digest, calls the ecrecover precompile with all remaining gas, reverts with 0x37e8456b when the recovered address is zero, burns the signer's nonce and returns the signer. It has no ERC-1271 branch. The proxy 0x68f77dfabc311df0530b24b22e4d7da413d4f054 (implementation 0x39e9f3fe8f71818b86a8be163995d4f34039579a) stores this address in slot 163; its quote entry (0xe1c1bb63) loads slot 163 and delegatecalls library 0xbeefeee67296951651296456e543894de2e8a966 function 0x06d7ce81 with storage slots 0x99 and 0xa0. The library calls f6293486 on the stored verifier, reads mapping[signer] at the slot it was given and reverts Unauthorized (0x82b42900) when false, then requires msg.sender to be the quote's executor. Slot 0xa0 (160) is the quoteProviders(address) mapping; the owner-only function 0x96e041d5(address,bool) writes it and emits QuoteProviderSet(address,bool). Provider 0x2f673fc3c8ca9700df43d30d68fe3ac851531e8c (EOA) is approved; owner 0x67540f004d06b0145278857e1ec2b9507bbfaee8 is an EOA with nonce 82. Under EIP-8151 a provider with real code recovers to zero, this contract reverts and the quote fails (replay); the owner can approve a new provider key.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: signed shortcut (the row's old issue): the recovered address is an approved quote provider of the vault, not a user acting by signature beside a direct call; no direct-call equivalent was shown, so the issue is a replaceable signer.
- Ruled out: ERC-1271 or a code-size branch: no isValidSignature selector in this code; a zero recovery reverts (0x37e8456b).
- Ruled out: fixed gas: the precompile call forwards GAS (5afa); the replay under EIP-8151 alone succeeds, so nothing breaks with nobody migrating.
- Ruled out: bundled signatures in the replayed tx: the scan saw one recovery per transaction (8 calls, 8 txs), all by this contract; the vault only reads a mapping on the returned signer.
- Ruled out: signature checked again later: the vault code and its library never call the second recovering function 0xda00f047; f6293486 burns the nonce at use.
- Ruled out: unused or closed: the vault stores this address (slot 163) and used it in real transactions up to block 26,435,460; the provider is still approved.
- Ruled out: value: this address holds nothing; the funds involved are the vault's, not counted here.
- Ruled out: a revert unrelated to the signature in the replay: the run with real code at the provider stops at 69,845 gas of 1.6 million, where the vault's quote entry first calls the check, before any transfer.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
