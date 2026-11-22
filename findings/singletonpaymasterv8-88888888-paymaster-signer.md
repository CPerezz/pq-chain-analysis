---
id: singletonpaymasterv8-88888888-paymaster-signer
format: 2
title: Quantum-forgeable ECDSA sponsorship drains Pimlico V8 gas deposit
status: confirmed
severity: MEDIUM
justification: A recovered signer key lets an attacker spend the gas deposit; rotation cannot help, Pimlico must
  redeploy. MEDIUM.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x888888888888ec68a58ab8094cc1ad20ba3d2402'
  name: SingletonPaymasterV8
  project: pimlico
  code: verified
  code_url: https://etherscan.io/address/0x888888888888ec68a58ab8094cc1ad20ba3d2402#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 151727
impact: funds-loss
action: Deploy a paymaster verifying sponsorship via ERC-1271 or a post-quantum scheme, move the deposit and point
  the API at it
evidence_level: source
checks:
- id: c1
  source: '0x888888888888ec68a58ab8094cc1ad20ba3d2402'
  file: src/SingletonPaymasterV7.sol
  line: 170
  has: address recoveredSigner = ECDSA.recover(hash, signature);
  says: Verifying mode recovers the signer with ECDSA.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: c2
  source: '0x888888888888ec68a58ab8094cc1ad20ba3d2402'
  file: src/SingletonPaymasterV7.sol
  line: 199
  has: address recoveredSigner = ECDSA.recover(hash, cfg.signature);
  says: ERC-20 mode recovers the signer with ECDSA.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: c3
  source: '0x888888888888ec68a58ab8094cc1ad20ba3d2402'
  file: lib/openzeppelin-contracts-v5.0.2/contracts/utils/cryptography/ECDSA.sol
  line: 142
  has: address signer = ecrecover(hash, v, r, s);
  says: Recovery uses the ecrecover precompile.
  for:
  - what
- id: c5
  source: '0x888888888888ec68a58ab8094cc1ad20ba3d2402'
  file: src/base/MultiSigner.sol
  line: 43
  has: function removeSigner(address _signer) public onlyAdminOrManager {
  says: Admin or manager can remove signers.
  for:
  - evidence-3
- id: c6
  source: '0x888888888888ec68a58ab8094cc1ad20ba3d2402'
  file: src/base/MultiSigner.sol
  line: 48
  has: function addSigner(address _signer) public onlyAdminOrManager {
  says: Admin or manager can add signers.
  for:
  - evidence-3
  - justification
- id: sig-ok
  source: '0x888888888888ec68a58ab8094cc1ad20ba3d2402'
  file: src/SingletonPaymasterV7.sol
  has: bool isSignatureValid = signers[recoveredSigner];
  line: 172
  says: Sponsorship is valid when the recovered address is in signers.
  for:
  - evidence-1
  - what
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

This paymaster sponsors user operations whose paymaster data carries an ECDSA signature from a key in its signers set. A quantum attacker who recovers a signer key can sponsor its own operations and have their gas paid from the paymaster's deposit.

## Evidence

- [_validateVerifyingMode](https://etherscan.io/address/0x888888888888ec68a58ab8094cc1ad20ba3d2402#code) recovers the signer with ECDSA and accepts if it is in signers.
- [_validateERC20Mode](https://etherscan.io/address/0x888888888888ec68a58ab8094cc1ad20ba3d2402#code) uses the same ECDSA recovery for ERC-20 sponsorship.
- [addSigner](https://etherscan.io/address/0x888888888888ec68a58ab8094cc1ad20ba3d2402#code) lets the admin or manager swap one ECDSA signer for another.

## Reviewer notes

### Mechanism

validatePaymasterUserOp (line 55) calls _validatePaymasterUserOp, which dispatches to _validateVerifyingMode (lines 159-177) or _validateERC20Mode (lines 186-220). Both hash the operation with getHash and toEthSignedMessageHash, call ECDSA.recover (lines 170, 199; ecrecover at ECDSA.sol line 142) and set isSignatureValid = signers[recoveredSigner] (lines 172, 201). The EntryPoint then charges gas to the paymaster's deposit. A signer's public key is exposed by any sponsored operation, so a quantum attacker can derive the key and sign arbitrary operations. addSigner/removeSigner (MultiSigner lines 43, 48, onlyAdminOrManager) can only rotate to other ECDSA keys. In ERC-20 mode tokens come from the operation's own sender, so a forged exchange rate only cuts the attacker's own payment.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: Users' tokens are not taken via a forged sponsorship; ERC-20 transfers pull from the operation's own sender.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
