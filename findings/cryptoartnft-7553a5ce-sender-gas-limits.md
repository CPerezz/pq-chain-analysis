---
id: cryptoartnft-7553a5ce-sender-gas-limits
format: 2
title: Cryptoart NFT claims sent with a tight gas limit fail after EIP-8151
status: confirmed
severity: LOW
justification: A real claim fails under the new price with its sender's gas limit and succeeds when given more gas,
  so it rates low.
category: breaks-at-activation
pattern: PQ-18
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x7553a5ced41c29fa4833ebe65ec9da6e2a9efdf0'
  name: CryptoartNFT
  code: verified
  code_url: https://etherscan.io/address/0x153294a5deb1f5bbdb05dd39f7b84fec6fd3927b#code
  proxy_of: '0x153294a5deb1f5bbdb05dd39f7b84fec6fd3927b'
  copies: 2
  family: 065db75090c563ccacdddf715717c8cd
  upgradeable: 'yes'
  admin: '0x3870d30c3d961a544143743fa02976b891018754'
value:
  usd: 20
  whose: operator
  basis: held
activity: {}
impact: liveness
action: 'Re-estimate claim and mint gas limits under EIP-8151: this claim used 3,100 more gas and still failed at
  its 348,397 limit.'
evidence_level: executed
checks:
- id: claim
  source: '0x153294a5deb1f5bbdb05dd39f7b84fec6fd3927b'
  file: src/CryptoartNFT.sol
  lines:
  - 274
  - 283
  has: _coreMint(data, tokenUriSet);
  says: claim mints through _coreMint, which validates the voucher
  for:
  - what
- id: recover
  source: '0x153294a5deb1f5bbdb05dd39f7b84fec6fd3927b'
  file: src/CryptoartNFT.sol
  lines:
  - 757
  - 766
  has: return signer == authoritySigner;
  says: the voucher signature is recovered with ECDSA and compared with the stored authority signer
  for:
  - evidence-2
  - what
- id: ecdsa
  source: '0x153294a5deb1f5bbdb05dd39f7b84fec6fd3927b'
  file: dependencies/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/utils/cryptography/ECDSA.sol
  line: 148
  has: address signer = ecrecover(hash, v, r, s);
  says: recovery uses the ecrecover builtin, which forwards all remaining gas
  for:
  - evidence-2
  - justification
  - what
- id: proxy-gas
  source: '0x7553a5ced41c29fa4833ebe65ec9da6e2a9efdf0'
  file: dependencies/openzeppelin-contracts-upgradeable/lib/openzeppelin-contracts/contracts/proxy/Proxy.sol
  line: 31
  has: delegatecall(gas(), implementation, 0, calldatasize(), 0, 0)
  says: the proxy forwards all gas to the implementation
  for:
  - action
  - evidence-2
  - justification
- id: withdraw
  source: '0x153294a5deb1f5bbdb05dd39f7b84fec6fd3927b'
  file: src/CryptoartNFT.sol
  lines:
  - 653
  - 662
  has: 'payable(msg.sender).call{value: balance}'
  says: the owner withdraws the whole ETH balance (mint payments)
  for:
  - whose
- id: owner
  call: '0x7553a5ced41c29fa4833ebe65ec9da6e2a9efdf0'
  fn: owner()(address)
  is: '0x9E216302cBa270B58B03Cc5Ceab1e9DDD6e64D3A'
  says: the owner who can withdraw is set
  for:
  - whose
- id: key
  call: '0x7553a5ced41c29fa4833ebe65ec9da6e2a9efdf0'
  fn: authoritySigner()(address)
  is: '0xEce3a6bd62C82324E0221165dd8C0c1e4133FeD1'
  says: the stored voucher signer is the address recovered in the replayed claim
  for:
  - evidence-3
  - what
- id: signer-code
  code: '0xece3a6bd62c82324e0221165dd8c0c1e4133fed1'
  is: delegation
  says: the voucher signer holds an EIP-7702 delegation, not real code
  for:
  - evidence-3
- id: tx
  tx: '0x6f387976c1ca3fcfcb764fa94dfa45f9bb9f171a079d710f4217f2ec4ef240b5'
  to: '0x7553a5ced41c29fa4833ebe65ec9da6e2a9efdf0'
  ok: true
  says: a real claim to this contract succeeded
  for:
  - action
  - evidence-1
  - justification
  - what
- id: replay-today
  replay: '0x6f387976c1ca3fcfcb764fa94dfa45f9bb9f171a079d710f4217f2ec4ef240b5'
  run: today
  ok: true
  says: the replay reproduces the real success
  for:
  - evidence-1
  - justification
  - what
- id: replay-8151
  replay: '0x6f387976c1ca3fcfcb764fa94dfa45f9bb9f171a079d710f4217f2ec4ef240b5'
  run: eip8151
  ok: false
  says: under EIP-8151 with the same gas limit the claim reverts
  for:
  - action
  - evidence-1
  - justification
  - what
- id: replay-delegated
  replay: '0x6f387976c1ca3fcfcb764fa94dfa45f9bb9f171a079d710f4217f2ec4ef240b5'
  run: eip8151_signer_delegated
  ok: false
  says: with a 7702 delegation at the signer the result is the same as plain EIP-8151
  for:
  - evidence-3
- id: paused
  call: '0x7553a5ced41c29fa4833ebe65ec9da6e2a9efdf0'
  fn: paused()(bool)
  is: false
  says: claims are open at the block
  for:
  - notes
- id: replay-more-gas
  replay: '0x6f387976c1ca3fcfcb764fa94dfa45f9bb9f171a079d710f4217f2ec4ef240b5'
  run: eip8151_more_gas
  ok: true
  says: under EIP-8151 with 300,000 more gas the claim succeeds
  for:
  - action
  - evidence-1
  - justification
- id: impl-init
  storage: '0x153294a5deb1f5bbdb05dd39f7b84fec6fd3927b'
  slot: '0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00'
  is: '0x000000000000000000000000000000000000000000000000ffffffffffffffff'
  says: the implementation's initializers are disabled
  for:
  - notes
- id: impl-signer
  call: '0x153294a5deb1f5bbdb05dd39f7b84fec6fd3927b'
  fn: authoritySigner()(address)
  is: '0x0000000000000000000000000000000000000000'
  says: the implementation has no voucher signer of its own
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-7553a5ce, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection (the card was edited after this answer)
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: 'kept: LOW (PQ-18): Cryptoart NFT claims sent with a tight gas limit fail after EIP-8151. A real claim fails
    under the new price with its sender''s gas limit and succeeds when given more gas, so it rates low. Two refuters
    had agreed (one objected to the flat per-signature figure); Claude replaced that figure with what the replays
    measured. Settled by Claude (D-029). Claude read the card and the answers.'
related: []
---

## What happens

Cryptoart NFT mints and claims a token only with a voucher from its authority signer, checked with ECDSA. Under EIP-8151 that check costs up to 3,100 more gas, and a real claim sent with today's tight gas limit reverts.

## Evidence

- [A real claim](https://etherscan.io/tx/0x6f387976c1ca3fcfcb764fa94dfa45f9bb9f171a079d710f4217f2ec4ef240b5) reverts under EIP-8151 with its own gas limit and succeeds with 300,000 more gas.
- [The voucher check](https://etherscan.io/address/0x153294a5deb1f5bbdb05dd39f7b84fec6fd3927b#code) gives the signature check all remaining gas; no amount is fixed in the code.
- [The voucher signer](https://etherscan.io/address/0xece3a6bd62c82324e0221165dd8c0c1e4133fed1) holds an EIP-7702 delegation, which still recovers, so the replay fails on gas, not on the signer.

## Reviewer notes

### Mechanism

claim (selector 0xd56a9eb3, CryptoartNFT.sol 274-283) -> _coreMint -> _validateMintAuthorization -> _validateSignature -> _isValidSignature (757-766): ECDSA.recover over the voucher hash, compared with the stored authoritySigner. OZ ECDSA calls the ecrecover builtin, which forwards all remaining gas (ECDSA.sol 148); the proxy forwards gas() to the implementation (Proxy.sol 31). The real claim 0x6f38...40b5 (block 26,393,394) had gas limit 348,397 and used 340,654. Replayed under EIP-8151 it reverts after 343,475 gas, leaving 4,922 unused: about 1/64 of the gas the proxy forwarded, which is what is left when the delegatecall runs out of gas and the proxy reverts. The signer 0xece3...fed1 is the stored authoritySigner and holds a 7702 delegation, so under EIP-8151 it still recovers; the run with code at the signer stops early (56,185 gas) instead. Replayed under EIP-8151 with 300,000 more gas it succeeds (343,754 gas used), so the sender's gas limit, not a budget in the code, is what fails. At the block the contract is not paused and 1,728 of 6,564 tokens are minted, so claims are open.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: fixed-gas-recovery: no constant gas is given to the precompile; the ecrecover builtin (ECDSA.sol 148) and the proxy delegatecall (Proxy.sol 31) forward all gas, and the scan saw no constant gas amount (ec_gas_const null).
- Ruled out: another signed step in the replayed tx: the study's trace window shows one recovery in this transaction, by this contract, of the authority signer; the claimer 0x0258...8b5b is not recovered (recovered_is_sender 0). _safeMint does call onERC721Received on the claimer, whose account holds a 7702 delegation, but no recovery happens there.
- Ruled out: the signer having real code: authoritySigner 0xece3...fed1 holds a 7702 delegation, which EIP-8151 still recovers.
- Ruled out: a separate migration notice sits beside this finding: authoritySigner is a stored key that the owner can replace (updateAuthoritySigner, 630-635); not folded in here.
- Ruled out: a copy in use: the only other address on this code, 0x1532...927b, is this proxy's own implementation, never initialized (initializable slot 0xf0c5...6a00 = 2^64-1, owner and authoritySigner zero at the block), so it is not a copy in use.
- Ruled out: The number: Claude took it from the replays, not from a per-signature figure. The today run used 340,654 gas and the eip8151_more_gas run 343,754, so this transaction needs 3,100 more. A limit raised by exactly that may still fail: each nested call keeps back 1/64 of what is left.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
