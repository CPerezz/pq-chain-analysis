---
id: contract-859f912e-signature-rechecked
format: 2
title: Payee of a payment channel goes unpaid if the signer's account takes real code
status: candidate
severity: CRITICAL
justification: The payee's signed payments are voided if the signer's account takes real code; no upgrade or key
  change exists.
category: voided-by-migration
pattern: PQ-15
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  code: decompiled
  code_url: code/0xafadbb50e5272d07009227b705663eb4172dbee21cd58b065c865a2304786e6a.sol
  copies: 7
  family: 354598d4dfa46f57470f533d99ff0c1a
  upgradeable: 'no'
value:
  usd: 1805
  basis: held
activity:
  txs_90d: 0
impact: funds-locked
action: Have the payee settle its latest signed payment, or the key holder sign a withdrawal, before the key's account
  takes real code.
evidence_level: bytecode
checks:
- id: signator
  storage: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  slot: 1
  is: '0x0000000000000000000000d2ffe8f8f98b162f02140611e49c87de043021d500'
  says: slot 1 holds the signator in bytes 1-20 and the paused flag (false) in byte 0
  for:
  - action
  - evidence-1
  - justification
  - what
- id: counterparty
  storage: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  slot: 2
  is: '0x0000000000000000000000003ef230bc8eee62fb65f137b59381b6c7a1d0c859'
  says: slot 2 holds the payee (counterparty)
  for:
  - evidence-1
- id: idle
  storage: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  slot: 3
  is: '0x62f44b9b'
  says: the last payout time (or deployment) is 1660177307, 2022-08-11; only a payout rewrites slot 3, and it starts
    the 387-day wait
  for:
  - evidence-2
  - what
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  is: '1000000000000000000'
  says: the channel holds 1 ETH
  for:
  - what
- id: settle-sig
  call: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  data: '0xf54d853900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000041000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000011b00000000000000000000000000000000000000000000000000000000000000'
  from: '0x3ef230bc8eee62fb65f137b59381b6c7a1d0c859'
  reverts_with: Message signer must be signator to this channel
  says: a settlement by the payee with a signature not from the signator reverts on the signator check
  for:
  - action
  - evidence-1
  - justification
  - what
- id: settle-who
  call: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  data: '0xf54d853900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000041000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000011b00000000000000000000000000000000000000000000000000000000000000'
  from: '0x000000000000000000000000000000000000dead'
  reverts_with: Can only be settled by counterparty
  says: settlement by anyone but the payee reverts
  for:
  - action
  - evidence-1
- id: close-sig
  call: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  data: '0x29f1c8490000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dead0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000041000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000011b00000000000000000000000000000000000000000000000000000000000000'
  from: '0x3ef230bc8eee62fb65f137b59381b6c7a1d0c859'
  reverts_with: Message signer must be signator to this channel
  says: the payee's settle-and-close (0x29f1c849) also needs the signator's signature
  for:
  - action
  - evidence-1
  - what
- id: withdraw-sig
  call: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  data: '0x074540da0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000dead0000000000000000000000000000000000000000000000000000000000000001000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000a00000000000000000000000000000000000000000000000000000000000000041000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000011b00000000000000000000000000000000000000000000000000000000000000'
  from: '0x000000000000000000000000000000000000dead'
  reverts_with: Message signer must be signator to this channel
  says: withdraw is past its 387-day wait and open to anyone, but reverts without the signator's signature
  for:
  - action
  - evidence-2
  - what
- id: wait387
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 596f75206d757374207761697420756e74696c20746865206368616e6e656c20
  says: the code holds the 387-day wait message of withdraw
  for:
  - evidence-2
- id: ecrec
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 60019260a0808401939192601f1981019281900390910190855afa
  says: the recovery is a STATICCALL to precompile 0x01 with all remaining gas
  for:
  - what
- id: dispatch
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 60003560e01c8063074540da146100fe5780631f69565f146101d657806329f1c849146102275780633f4ba83a146102fd57806346fbf68e146103125780635c975abb146103595780636ef8d66d1461036e57806382dc1ec4146103835780638456cb59146103b6578063e4860339146103cb578063f54d853914610410575b
  says: the dispatcher lists all eleven functions, then falls to the deposit fallback
  for:
  - evidence-3
  - justification
  - what
- id: signer-code
  code: '0xd2ffe8f8f98b162f02140611e49c87de043021d5'
  is: empty
  says: the signator's account has no code at the block
  for:
  - notes
- id: signer-nonce
  nonce: '0xd2ffe8f8f98b162f02140611e49c87de043021d5'
  is: 0
  says: the signator has sent no transaction
  for:
  - notes
- id: stores
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 6001805460ff19169055
  says: unpause clears only the low byte of slot 1 (SLOAD, AND NOT 0xff, SSTORE), keeping the signator bits
  for:
  - evidence-3
  - justification
  - what
- id: stores2
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 6001805460ff191681179055
  says: pause sets only the low byte of slot 1, keeping the signator bits
  for:
  - evidence-3
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

This one-way payment channel holds 1 ETH and pays out only on messages signed by a key fixed at deployment; it has paid nothing out since August 2022. If that key's account takes real code, the payee's signed payments stop paying and the ETH stays locked; an EIP-7702 delegation keeps working.

## Evidence

- [Settling](https://etherscan.io/address/0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae#code) is for the payee only and reverts with "Message signer must be signator to this channel" unless the key signed.
- [Withdrawing](https://etherscan.io/address/0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae#code) after 387 idle days is open to anyone but needs the same key's signature; the wait ended in 2023.
- [No function](https://etherscan.io/address/0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae#code) replaces the signing key or the payee; pause and unpause rewrite only the paused flag beside the key.

## Reviewer notes

### Mechanism

Unverified code, read from bytecode and a decompiled listing. Storage slot 1 holds the paused flag (byte 0) and the signator 0xd2ffe8f8f98b162f02140611e49c87de043021d5 (bytes 1-20); slot 2 holds the counterparty (payee) 0x3ef230bc8eee62fb65f137b59381b6c7a1d0c859; slot 3 the time of the last payout. Three functions move money and each recovers a signature with the ecrecover precompile (all gas forwarded, output zeroed first) and requires it to equal the signator: 0xf54d8539 (payee only: pays the payee an amount for a token or ETH, with a per-token nonce), 0x29f1c849 (payee only: pays the payee, then sends the rest to an address in the message) and withdraw(address,address,uint256,uint256,bytes) (anyone, once 387 days passed since the last payout: the same split). The other functions are pauser roles, pause and unpause (they rewrite only byte 0 of slot 1), the nonce getter tokens(address), getTokenInfo and a payable fallback that takes deposits. No code path writes the signator or the payee after deployment, and the contract is not a proxy. Under EIP-8151 the recovery returns nothing once the signator's account has real code, so every voucher the payee holds stops paying and no path releases the ETH.

### Checks

- Header facts: this address alone, at block 26,438,999; 7 addresses run this code.
- Ruled out: fixed gas to the precompile: the recovery passes all remaining gas (GAS before STATICCALL to 0x01), so nothing breaks on activation day.
- Ruled out: an ERC-1271 or code-size path for a signator with code: none; the three payout functions all end in the same recovery and equality check.
- Ruled out: the key unset or already a contract: slot 1 holds a non-zero signator whose account has no code and has sent no transaction (presumed live).
- Ruled out: a direct call by the signator: no function lets the signator act without a signature; the payee can settle only with one.
- Ruled out: a setter or upgrade: the code writes slots 1 (byte 0 only), 3, and the nonce and pauser mappings; slot 2 and the signator bits never; not a proxy.
- Ruled out: the old root issue fixed-signer (a notice): the key signs vouchers the payee relies on and can void them by migrating, so this is a rated finding.
- Ruled out: a separate notice for the signator's own exit (withdraw after 387 days needs its own signature) sits beside this one and is covered by the same action.
- Ruled out: the 7 copies of this code: this card is this address alone; it is in use as a funded open channel, though idle.

### Questions

- Does the payee still hold unredeemed vouchers? The ETH and WETH nonce counters are zero, which suggests no payout from them has been settled; vouchers are off-chain and cannot be read.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-24: reviewed again and rewritten from checks that were re-run.
