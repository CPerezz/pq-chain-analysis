---
id: zoo-cny-48405642-rotate-signer-before-migrating
format: 2
title: 'Zoo_CNY: replace the signer before its account moves to real code'
status: confirmed
severity: INFORMATIONAL
justification: Nothing breaks unless a signer moves its account to real code, and the signer can be replaced first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x484056420889ccc1d16017ee6567311b6a025665'
  name: Zoo_CNY
  code: verified
  code_url: https://etherscan.io/address/0x484056420889ccc1d16017ee6567311b6a025665#code
  copies: 1
  upgradeable: 'no'
  admin: '0x483190c72d60554a7b677a3736f51e7d4379678c'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 5
impact: liveness
action: Replace the signer with setWhitelistSigningAddress before moving the current signer's account to real code.
evidence_level: source
checks:
- id: recover
  source: '0x484056420889ccc1d16017ee6567311b6a025665'
  file: contracts/EIP712Whitelisting.sol
  line: 44
  has: address recoveredAddress = digest.recover(signature);
  says: check recovers a signer with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: no-1271
  bytecode: '0x484056420889ccc1d16017ee6567311b6a025665'
  has: 1626ba7e
  absent: true
  says: the code holds no ERC-1271 isValidSignature selector
  for:
  - evidence-1
  - what
- id: no-1271-legacy
  bytecode: '0x484056420889ccc1d16017ee6567311b6a025665'
  has: 20c13b0b
  absent: true
  says: the code holds no legacy isValidSignature selector
  for:
  - evidence-1
  - what
- id: match
  source: '0x484056420889ccc1d16017ee6567311b6a025665'
  file: contracts/EIP712Whitelisting.sol
  line: 45
  has: require(recoveredAddress == whitelistSigningKey, "Invalid Signature");
  says: the recovered address must be the signer it keeps in storage
  for:
  - evidence-1
  - justification
  - what
- id: setter
  source: '0x484056420889ccc1d16017ee6567311b6a025665'
  file: contracts/EIP712Whitelisting.sol
  line: 31
  has: function setWhitelistSigningAddress
  says: setWhitelistSigningAddress changes the signer
  for:
  - action
  - evidence-2
  - justification
  - what
- id: signer-code
  code: '0xae7913df09e2979e877bcb2971bc5e96df33e70a'
  is: empty
  says: the address recovered in the latest signature check on record has no code
  for:
  - action
  - evidence-3
  - justification
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

Zoo_CNY checks an ECDSA signature in check and accepts only the signer it keeps in storage. If that account takes real code its signatures are refused; an EIP-7702 delegation keeps working. setWhitelistSigningAddress changes the signer.

## Evidence

- [check](https://etherscan.io/address/0x484056420889ccc1d16017ee6567311b6a025665#code) recovers the signature with ECDSA and accepts only the signer it keeps in storage; the code never asks that account.
- [setWhitelistSigningAddress](https://etherscan.io/address/0x484056420889ccc1d16017ee6567311b6a025665#code) changes the signer; only the owner can call it.
- The address recovered in its latest signature check on record is [0xae79…e70a](https://etherscan.io/address/0xae7913df09e2979e877bcb2971bc5e96df33e70a), an account without code.

## Reviewer notes

### Mechanism

check (contracts/EIP712Whitelisting.sol, line 35) recovers a signer on line 44 and tests it on line 45 against the signer it keeps in storage. Neither isValidSignature selector is in the code, so that account is never asked. setWhitelistSigningAddress (contracts/EIP712Whitelisting.sol, line 31) writes it. Under EIP-8151 the recovery returns no address for an account with real code, so its signatures are refused; a delegated account still recovers.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-test path for a signer with code: neither selector is in the code, and no function that recovers has such a branch.
- Ruled out: Not read here: whether the signed function can still run (a sale that ended, a cap reached, a one-time call). It last recovered a signature on record on 2022-03-17, recovering 0xae79…e70a; 5 transactions called the address in the 90 days before the block.
- Ruled out: On record means: the study's traced two weeks, the three latest transactions of the last 90 days, and a public table that ends in March 2026.
- Ruled out: Written by the signer recipe: the same reasoning on every card of this kind; the source lines, the function that changes the signer, the signer and the history were read at this contract and every check was run here. No author or refuter read this contract.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
