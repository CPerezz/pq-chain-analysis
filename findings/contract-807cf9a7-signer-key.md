---
id: contract-807cf9a7-signer-key
format: 2
title: 1inch maker vault accepts ECDSA signatures a quantum attacker could forge
status: candidate
severity: MEDIUM
justification: A recovered executor key lets forged 1inch orders sell vault tokens; MEDIUM since the 2-of-3 multisig
  can upgrade it
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x807cf9a772d5a3f9cefbc1192e939d62f0d9bd38'
  code: decompiled
  code_url: code/0x0f29e732e0cf360fb81be458b347d4467e13f9c934850ccd1225b151e3912107.sol
  proxy_of: '0xbe4e645caaae7c1d0874bb8d1c8d337f31d79dd8'
  copies: 1
  upgradeable: 'yes'
  admin: '0x291baf88f60e8f83de7568ae56280a3e29ac725e'
value:
  usd: 1
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
action: Upgrade isValidSignature to a post-quantum verifier via the multisig, or withdraw the remaining tokens and
  retire the vault
evidence_level: bytecode
checks:
- id: sel-isvalidsig
  selector: '0xbe4e645caaae7c1d0874bb8d1c8d337f31d79dd8'
  fn: isValidSignature(bytes32,bytes)
  says: The implementation exposes the ERC-1271 signature check.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: sel-executor
  selector: '0xbe4e645caaae7c1d0874bb8d1c8d337f31d79dd8'
  fn: executorSigner()
  says: The implementation stores an executor signer address.
  for:
  - evidence-2
  - justification
  - what
- id: sel-isoperator
  selector: '0xbe4e645caaae7c1d0874bb8d1c8d337f31d79dd8'
  fn: isOperator(address)
  says: The implementation keeps an operator list of addresses.
  for:
  - what
- id: sel-withdraw
  selector: '0xbe4e645caaae7c1d0874bb8d1c8d337f31d79dd8'
  fn: withdraw(address,uint256,address)
  says: The implementation has a withdraw function for its tokens.
  for:
  - action
  - evidence-3
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review14 (selectors, trace of the last ecrecover call, admin reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews: []
related: []
---

## What happens

The vault acts as an ERC-1271 maker for 1inch limit orders and answers isValidSignature by recovering an ECDSA signer and checking it against its executor or operator keys. A quantum attacker who recovers that key signs orders the router accepts, selling the vault's tokens.

## Evidence

- [isValidSignature](https://etherscan.io/address/0xbe4e645caaae7c1d0874bb8d1c8d337f31d79dd8#code) is the ERC-1271 entry point the 1inch router calls to accept the vault's orders.
- [executorSigner](https://etherscan.io/address/0xbe4e645caaae7c1d0874bb8d1c8d337f31d79dd8#code) stores the single ECDSA key the vault's signatures are checked against.
- [withdraw](https://etherscan.io/address/0xbe4e645caaae7c1d0874bb8d1c8d337f31d79dd8#code) lets the operator pull the vault's remaining tokens out.

## Reviewer notes

### Mechanism

TransparentUpgradeableProxy 0x807cf9a7 delegates to unverified implementation 0xbe4e…9dd8. The 1inch AggregationRouterV6 staticcalls isValidSignature(bytes32,bytes) (0x1626ba7e) on the vault when filling an order whose maker is the vault; the last such call (block 23,974,448) is paired with the vault's ecrecover. Per kev, isValidSignature recovers the signer with ecrecover and accepts it if it equals executorSigner() (EOA 0xe9f1…a31a) or an operator (isOperator mapping); operator setters only accept other addresses, i.e. ECDSA keys. Recovering the executor key from its public key lets an attacker sign orders that sell the vault's token balance. ProxyAdmin 0x291b…725e is owned by a 2-of-3 multisig that can upgrade the implementation; withdraw(address,uint256,address) can empty the vault. The signer comparison is inferred from bytecode and trace pairing, not verified source.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No protocol change needed: the fix is a contract upgrade or withdrawal.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
