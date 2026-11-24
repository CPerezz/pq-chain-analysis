---
id: contract-859f912e-fixed-signer
format: 2
title: Payment channel stops paying if its fixed signer's account takes real code
status: candidate
severity: INFORMATIONAL
justification: Fails only if the signer moves its own account to real code; the signer is fixed at deployment.
category: migration-notice
pattern: PQ-17
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
evidence_level: bytecode
checks:
- id: dispatch
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 60806040526004361061008c5760003560e01c8063074540da146100fe5780631f69565f146101d657806329f1c849146102275780633f4ba83a146102fd57806346fbf68e146103125780635c975abb146103595780636ef8d66d1461036e57806382dc1ec4146103835780638456cb59146103b6578063e4860339146103cb578063f54d85391461041057
  says: the code's function table holds exactly these 11 selectors
  for:
  - justification
  - what
- id: ecrec
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 60ff8416828401526060820186905260808201859052915160019260a0808401939192601f1981019281900390910190855afa
  says: the recovery calls address 1 (ecrecover) with all remaining gas
  for:
  - evidence-1
  - justification
  - what
- id: cmp
  bytecode: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  has: 6001549091506001600160a01b038083166101009092041614
  says: the recovered address is compared with storage slot 1 shifted right by one byte
  for:
  - evidence-1
  - justification
  - what
- id: slot1
  storage: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  slot: '0x01'
  is: '0x000000000000000000000000d2ffe8f8f98b162f02140611e49c87de043021d500'
  says: slot 1 holds the signer d2ff…21d5 above a zero pause flag
  for:
  - evidence-1
  - justification
  - what
- id: signator-eoa
  code: '0xd2ffe8f8f98b162f02140611e49c87de043021d5'
  is: empty
  says: the signer's account has no code
  for:
  - evidence-2
  - what
- id: signator-nonce
  nonce: '0xd2ffe8f8f98b162f02140611e49c87de043021d5'
  is: 0
  says: the signer has sent no transaction
  for:
  - evidence-2
- id: bal
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  is: '1000000000000000000'
  says: the channel holds 1 ETH
  for:
  - evidence-3
  - what
- id: count-eth
  call: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  data: '0xe48603390000000000000000000000000000000000000000000000000000000000000000'
  is: '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: the settled-payment counter for ETH is zero
  for:
  - evidence-3
- id: count-weth
  call: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  data: '0xe4860339000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2'
  is: '0x0000000000000000000000000000000000000000000000000000000000000000'
  says: the settled-payment counter for WETH is zero
  for:
  - evidence-3
- id: idle
  storage: '0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae'
  slot: '0x03'
  is: '0x0000000000000000000000000000000000000000000000000000000062f44b9b'
  says: slot 3 holds 0x62f44b9b, a timestamp of 11 August 2022; the decompiled idle exit requires block time above
    this slot plus 387 days
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

This payment channel releases funds only against messages signed by one signer, fixed at deployment. It recovers each signature with ECDSA. If the signer's account takes real code, signed payments cannot be redeemed and the 1 ETH cannot be withdrawn. An EIP-7702 delegation keeps working.

## Evidence

- The [bytecode](https://etherscan.io/address/0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae#code) recovers each message with ecrecover and compares the result with the address kept in storage slot 1.
- The signer [0xd2ff…21d5](https://etherscan.io/address/0xd2ffe8f8f98b162f02140611e49c87de043021d5) has no code and has sent no transaction.
- The [channel](https://etherscan.io/address/0x859f912e02a3f44b15cdf73dc8e66722deb1a6ae) holds 1 ETH. Its settled-payment counters for ETH and WETH are zero and its idle timer reads August 2022.

## Reviewer notes

### Mechanism

The dispatcher lists 11 selectors: three settlement functions (0x074540da after a 387-day idle period, 0x29f1c849 and 0xf54d8539 called by the counterparty), pauser-role and pause functions, a token-info getter, a pauser getter and a counter getter. Settlement runs the recovery helper (ecrecover with all gas) and requires the result to equal storage slot 1 shifted right by one byte, else it reverts with 'Message signer must be signator to this channel'; the nonce must exceed the stored counter. The only writes to slot 1 are the pause and unpause functions, which change its lowest byte. The signer is the address in slot 1 (0xd2ff…21d5) and the counterparty is slot 2. The function purposes come from a decompiler plus the author's reading of the disassembly; neither is re-run by a check beyond the byte sequences cited. Rating: the contract checks the signature once, when a payment is redeemed, and no signature someone relied on is shown (both counters are zero, vouchers are off-chain), so it is a migration notice (PQ-17, INFORMATIONAL); the author's PQ-15 HIGH was re-rated by the reader after the refuter objected.

### Checks

- Header facts: this address alone, at block 26,438,999; 7 addresses run this code.
- Ruled out: an ERC-1271 path for a signer with real code: the dispatcher and the recovery helper show none, and neither ERC-1271 selector appears in the code.
- Ruled out: a function that replaces the signer: none of the 11 selectors is a setter and slot 1 is written only by pause and unpause (disassembly and decompiler reading, not a re-runnable check).
- Ruled out: a fixed gas amount: the recovery call forwards all gas (GAS before STATICCALL).
- Ruled out: an upgrade path: the EIP-1967 implementation slot is empty and the code has no delegatecall that the author found.
- Ruled out: a signature-free exit: the three functions that move funds all reach the signer comparison; the pauser functions move nothing (disassembly and decompiler reading).
- Ruled out: the other six addresses that run this code: their addresses are not in the dossier, so each would need its own row.

### Questions

- Who holds the signer key, and who deposited the 1 ETH? Neither is readable on chain, so whose and action stay empty.
- Does the counterparty hold a signed payment it has not redeemed? It is off-chain. If it does, a signer that moves to real code voids it: the finding is then signature-rechecked (PQ-15) and rated HIGH or CRITICAL.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-24: reviewed again and rewritten from checks that were re-run.
