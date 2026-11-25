---
id: singletonpaymasterv7-77777777-paymaster-signer
format: 2
title: Pimlico paymaster's gas deposit open to forged ECDSA sponsorships
status: confirmed
severity: MEDIUM
justification: Sponsor keys are ECDSA, so rotating them does not help; MEDIUM because Pimlico must deploy a new
  paymaster.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x777777777777aec03fd955926dbf81597e66834c'
  name: SingletonPaymasterV7
  project: pimlico
  code: verified
  code_url: https://etherscan.io/address/0x777777777777aec03fd955926dbf81597e66834c#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 576
  basis: held
activity:
  txs_90d: 918704
impact: funds-loss
action: Deploy a paymaster that verifies sponsorship via ERC-1271 or a post-quantum scheme, and move deposits to
  it
evidence_level: source
checks:
- id: c1
  source: '0x777777777777aec03fd955926dbf81597e66834c'
  file: src/SingletonPaymasterV7.sol
  line: 170
  has: address recoveredSigner = ECDSA.recover(hash, signature);
  says: Verifying mode recovers the sponsor with ECDSA.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x777777777777aec03fd955926dbf81597e66834c'
  file: src/SingletonPaymasterV7.sol
  line: 199
  has: address recoveredSigner = ECDSA.recover(hash, cfg.signature);
  says: ERC-20 mode recovers the sponsor with ECDSA.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c6
  source: '0x777777777777aec03fd955926dbf81597e66834c'
  file: src/base/MultiSigner.sol
  line: 48
  has: function addSigner(address _signer) public onlyAdminOrManager {
  says: The admin or manager adds signers by address.
  for:
  - evidence-3
  - justification
- id: sig1
  source: '0x777777777777aec03fd955926dbf81597e66834c'
  file: src/SingletonPaymasterV7.sol
  has: bool isSignatureValid = signers[recoveredSigner];
  line: 172
  says: Verifying mode accepts the operation if the recovered address is a signer.
  for:
  - evidence-1
  - what
- id: sig2
  source: '0x777777777777aec03fd955926dbf81597e66834c'
  file: src/SingletonPaymasterV7.sol
  has: bool isSignatureValid = signers[recoveredSigner];
  line: 201
  says: ERC-20 mode accepts the operation if the recovered address is a signer.
  for:
  - evidence-2
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
reviews: []
related: []
---

## What happens

This ERC-4337 paymaster sponsors a user operation when ECDSA recovers a sponsor address that is in its signers set. A quantum attacker who derives a signer key signs sponsorship for its own operations and spends the paymaster's EntryPoint gas deposit.

## Evidence

- [_validateVerifyingMode](https://etherscan.io/address/0x777777777777aec03fd955926dbf81597e66834c#code) recovers the sponsor with ECDSA and accepts it if it is in signers.
- [_validateERC20Mode](https://etherscan.io/address/0x777777777777aec03fd955926dbf81597e66834c#code) uses the same ECDSA recovery for ERC-20 sponsorship.
- [addSigner](https://etherscan.io/address/0x777777777777aec03fd955926dbf81597e66834c#code) lets the admin or manager add another address, so a new signer is still an ECDSA key.

## Reviewer notes

### Mechanism

validatePaymasterUserOp (line 55) calls _validatePaymasterUserOp, which dispatches by mode. _validateVerifyingMode (159-177) hashes getHash(VERIFYING_MODE, userOp) with toEthSignedMessageHash (169), runs ECDSA.recover (170) and sets isSignatureValid = signers[recoveredSigner] (172). That result is packed into validationData, and the EntryPoint then pays gas from the paymaster's deposit. _validateERC20Mode (186-220) does the same at lines 198-201. In ERC-20 mode, tokens are pulled from userOp.sender, so a forged exchange rate only lowers the attacker's own payment while gas still comes from the deposit. Signers are managed by addSigner and removeSigner (onlyAdminOrManager), but every signer is an ECDSA address. Recovery goes through OpenZeppelin tryRecover, which calls ecrecover at line 142.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Tokens held by the paymaster are not reachable through the sponsorship signature.
- Ruled out: Users' funds are not at risk through this check.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
