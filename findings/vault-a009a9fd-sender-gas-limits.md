---
id: vault-a009a9fd-sender-gas-limits
format: 2
title: Relayed deposits with tight gas limits fail once signature checks cost more
status: candidate
severity: LOW
justification: A real deposit reverts under the change with its signer unchanged; the sender's gas limit is a simple
  fix.
category: breaks-at-activation
pattern: PQ-18
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xa009a9fdc0ef474e7a3938a89f80329139291568'
  name: Vault
  code: verified
  code_url: https://etherscan.io/address/0xded92703c7883ebdc983d1aab1ddefec5eea13d5#code
  proxy_of: '0xded92703c7883ebdc983d1aab1ddefec5eea13d5'
  copies: 4
  family: 0f93914f4d57f6e6b229a16e165c23ce
  upgradeable: 'yes'
value:
  usd: 0
  whose: users
  basis: held
activity: {}
impact: liveness
action: 'Have the relayers re-estimate deposit gas limits under EIP-8151: this deposit used 3,100 more gas and failed
  at its 177,027 limit.'
evidence_level: executed
checks:
- id: ecdsa
  source: '0xded92703c7883ebdc983d1aab1ddefec5eea13d5'
  file: src/Vault.sol
  line: 198
  has: address signer = signedMessageHash.recover(signature);
  says: the request signature is recovered with ECDSA
  for:
  - evidence-1
  - what
- id: verify
  source: '0xded92703c7883ebdc983d1aab1ddefec5eea13d5'
  file: src/Vault.sol
  lines:
  - 218
  - 219
  has: 'require(success, "Vault: Invalid signature or from");'
  says: deposit reverts unless the recovered signer is the named party
  for:
  - evidence-1
  - what
- id: sender
  source: '0xded92703c7883ebdc983d1aab1ddefec5eea13d5'
  file: src/Vault.sol
  line: 230
  has: 'require(msg.sender == from || hasRole(MIDDLEWARE_ROLE, msg.sender), "Vault: Invalid Sender");'
  says: a deposit with a fee is sent by the party or by a holder of the middleware role
  for:
  - what
- id: pull
  source: '0xded92703c7883ebdc983d1aab1ddefec5eea13d5'
  file: src/Vault.sol
  line: 243
  has: token.safeTransferFrom(from, address(this), request.sources[chainIndex].value);
  says: the vault pulls the depositor's own tokens into itself
  for:
  - whose
- id: role
  call: '0xa009a9fdc0ef474e7a3938a89f80329139291568'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0x98cc91a5442060c87a4011de96e2926e239b5530239140eb873f560f7086b24f'
  - '0x6002440ba96e0ad91b62cc088370c8b1dfd7d5ef'
  is: true
  says: the sender of the replayed deposit holds MIDDLEWARE_ROLE
  for:
  - action
  - what
- id: tx
  tx: '0xb18ea9d61f5cc4da7288207aa2e955604333aa29dc420cd7041cb946da8313d3'
  to: '0xa009a9fdc0ef474e7a3938a89f80329139291568'
  ok: true
  says: the deposit was sent to this vault and succeeded
  for:
  - evidence-2
  - what
- id: r-today
  replay: '0xb18ea9d61f5cc4da7288207aa2e955604333aa29dc420cd7041cb946da8313d3'
  run: today
  ok: true
  says: the replay today reproduces the receipt
  for:
  - evidence-2
  - justification
  - what
- id: r-8151
  replay: '0xb18ea9d61f5cc4da7288207aa2e955604333aa29dc420cd7041cb946da8313d3'
  run: eip8151
  ok: false
  says: under EIP-8151 alone, with no account migrated, the same transaction reverts
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-eoa-then
  code: '0xc4a881aa68111fc9b31944254bcc6800d9008688'
  is: empty
  at: 26408672
  says: the depositor who signed had no code when the deposit ran
  for:
  - evidence-2
  - justification
  - what
- id: moregas
  replay: '0xb18ea9d61f5cc4da7288207aa2e955604333aa29dc420cd7041cb946da8313d3'
  run: eip8151_more_gas
  ok: true
  says: with 300,000 more gas the same deposit succeeds under EIP-8151
  for:
  - action
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

This vault takes cross-chain deposits that the depositor signs, and a relayer with its middleware role can send them. A real relayed deposit, replayed under the change with its signer still an ordinary account, reverts: the signature check costs more and the gas limit leaves no room.

## Evidence

- [deposit](https://etherscan.io/address/0xded92703c7883ebdc983d1aab1ddefec5eea13d5#code) recovers the depositor's signature with ECDSA and reverts unless it is the named party.
- [A relayed deposit](https://etherscan.io/tx/0xb18ea9d61f5cc4da7288207aa2e955604333aa29dc420cd7041cb946da8313d3) succeeds today and reverts when replayed under the change; its signer has no code.

## Reviewer notes

### Mechanism

The proxy delegates to Vault (EIP-1967 slot = 0xded9... at the tx block and at the pinned block). deposit (lines 211-261) calls _verifyRequest (188-200): OpenZeppelin ECDSA.recover over an EIP-191 hash, no gas cap, compared with the party named in the request; mismatch reverts (219). The tx 0xb18e... (selector 0x784431c4 = deposit) was sent by 0x6002..., which holds MIDDLEWARE_ROLE at the pinned block, for party 0xc4a8..., which had no code at the tx block or the pinned block. Gas limit 177,027 (eth_getTransactionByHash); used 169,600 today. Dossier replays: today ok as receipt; eip8151 reverts after 174,602 gas; with code at the signer it reverts at 55,547, i.e. at the signature. So the plain eip8151 run passed the signature check and failed later; 177,027 - 174,602 = 2,425 is about the 1/64 the proxy keeps back at its delegatecall, consistent with the implementation frame running out of gas. The replay job records spare 384 gas in the frame. EIP-8151 changes only the precompile's output for signers with code and its price; the signer has no code and Vault has no gasleft() branch, so the price is what breaks it.

### Checks

- Header facts: this address alone, at block 26,438,999; 4 addresses run this code.
- Ruled out: fixed gas to the precompile: recovery is OpenZeppelin ECDSA.recover with all gas (line 198); the scanner found no gas constant.
- Ruled out: signer with code: 0xc4a8... has empty code at block 26,408,672 and 26,438,999, so the recovery returns the same address under the change.
- Ruled out: a different failure than the price: the run with code at the signer fails at 55,547 gas, far earlier than the plain run (174,602), so the plain run got past the signature check.
- Ruled out: wrong code: the EIP-1967 slot pointed to 0xded9... at the tx block too, the code the replay ran.
- Ruled out: unused address: this proxy is initialized and was called in the replayed transaction.
- Ruled out: settle (verifier key, replaceable by the admin through roles) and the party's own-signature paths are other root issues, not this row.
- Ruled out: The number: Claude took it from the replays, not from a per-signature figure. The today run used 169,600 gas and the eip8151_more_gas run 172,700, so this transaction needs 3,100 more. A limit raised by exactly that may still fail: each nested call keeps back 1/64 of what is left.

### Questions

- No replay with a higher gas limit is in the dossier: that the deposit passes with about 3,100 more gas follows from the reasoning in Mechanism, but was not run here.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
