---
id: ecdsadkgvalidator-0125c897-dkg-result-rechecked
format: 2
title: tBTC wallet creation fails if an operator moves its account to code mid-check
status: confirmed
severity: LOW
justification: An operator can void its signature during the challenge window; Threshold can change the check by an upgrade.
category: voided-by-migration
pattern: PQ-15
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: "0x0125c8977a02b2fa3970b1ed9af02f5bedd4ef27"
  name: EcdsaDkgValidator
  project: tbtc
  label:
  code: verified
  code_url: https://etherscan.io/address/0x0125c8977a02b2fa3970b1ed9af02f5bedd4ef27#code
  proxy_of:
  copies: 3
  family: c7877dc4855722a5f03bf4c0c064af61
  upgradeable: "no"
  admin: none
value:
  usd: 0
  whose:
  basis: held
activity:
  txs_90d: 1
  last: 2026-11-14
impact: liveness
action: Upgrade WalletRegistry so a result is checked once, or so operators whose accounts have code can sign.
evidence_level: executed
checks:
- id: recover
  source: "0x0125c8977a02b2fa3970b1ed9af02f5bedd4ef27"
  file: contracts/EcdsaDkgValidator.sol
  lines: [250, 252]
  has: "address recoveredAddress = hash.recover(current);"
  says: every signature of a result must recover to the selected operator's address
  for: [what, evidence-1, justification]
- id: window
  call: "0x46d52e41c2f300bc82217ce22b920c34995204eb"
  fn: dkgParameters()(uint256,uint256,uint256,uint256,uint256)
  is: [11520, 11520, 50000, 536, 20]
  says: a result can be challenged for 11,520 blocks, about 38 hours (the second value)
  for: [what]
- id: last-use
  tx: "0xdad127784152301e0be04a5d5bd40d676ab85f4a707331f0b82bd2323d9eab28"
  ok: true
  says: the approval of 2026-11-14, which ran this check through WalletRegistry
  for: [evidence-2]
- id: upgradeable-registry
  storage: "0x46d52e41c2f300bc82217ce22b920c34995204eb"
  slot: "0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103"
  is: "0x0000000000000000000000007affa05f726d293eb1193807a91617318292008e"
  says: WalletRegistry, which calls the validator, is a proxy with an admin, so the check can be changed
  for: [justification, action]
- id: executed
  ref: "https://github.com/kevaundray/pq-chain-analysis/blob/d9c90afac8137e134d5e884865dfc37bbcb0d397/triage/tbtc-dkg-result-signer-code.md"
  says: the study's run of a challenge with code at one operator, the honest submitter is penalised
  for: [what, justification]
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: Anon
  date: 2026-11-20
  by: other
  verdict: confirmed
  rating: LOW
  note: Threshold's governance can change the check by upgrading WalletRegistry
related: []
---

## What happens

When tBTC creates a wallet, 100 operators sign the key-generation result. The signatures are checked again during a
38-hour challenge window, so an operator that moves its account to code in that window makes an honest result fail
and its submitter be penalised.

## Evidence

- [Verified source](https://etherscan.io/address/0x0125c8977a02b2fa3970b1ed9af02f5bedd4ef27#code),
  `validateSignatures`: every signature must recover to the address of the selected operator.
- WalletRegistry runs this check when a result is challenged or approved, the last time in
  [this transaction](https://etherscan.io/tx/0xdad127784152301e0be04a5d5bd40d676ab85f4a707331f0b82bd2323d9eab28).

## Reviewer notes

### Mechanism

`EcdsaDkg.submitResult` stores only the result's hash. `challengeResult` re-runs `validate` and, when it fails, treats
the submitter as malicious (`DkgMaliciousResultSlashed`) and reopens submission; approval runs the check too. A
result needs 51 of the 100 signatures, so an operator whose account already has code at submission is left out.

### Checks

- Block 26,438,999: WalletRegistry 0x46d5…04eb is a proxy; its ProxyAdmin 0x7aff…008e is owned by 0x92f2…913d;
  `governance()` is 0x6aed…7fe8; `dkgParameters` gives a challenge period of 11,520 blocks.
- `walletOwner()` of WalletRegistry is 0x5e48…8e7b, whose verified Bridge source deposits into TBTCVault: hence tbtc.
- Study replay of the 2026-11-14 result with one byte of code at operator 0xb71c…e012: approval reverts, and an
  outsider's challenge succeeds with `DkgMaliciousResultSlashed(400 T, submitter)`. Threshold's `seize` only emits an
  event today, so no tokens move; the key generation restarts.

### History

- 2026-11-19: reported and executed (study eip-8151-impact).
- 2026-11-20: LOW, decided by Anon.
