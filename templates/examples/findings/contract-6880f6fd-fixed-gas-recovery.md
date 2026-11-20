---
id: contract-6880f6fd-fixed-gas-recovery
format: 2
title: Rollup bridge will treat honest blocks as fraud once EIP-8151 is live
status: confirmed
severity: CRITICAL
justification: Anyone could prove an honest block fraudulent and take the operator's bond, and the code cannot change.
category: breaks-at-activation
pattern: PQ-14
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: "0x6880f6fd960d1581c2730a451a22eed1081cfd72"
  name:
  project:
  label: "Fuel: Bridge"
  code: bytecode
  code_url: https://etherscan.io/address/0x6880f6fd960d1581c2730a451a22eed1081cfd72#code
  proxy_of:
  copies: 1
  family:
  upgradeable: "no"
  admin:
value:
  usd: 18
  whose:
  basis: held
activity:
  txs_90d: 6
  last: 2026-11-16
impact: funds-loss
action: Exit and retire this bridge before EIP-8151 activates; its code cannot be changed.
evidence_level: executed
checks:
- id: fixed-gas
  bytecode: "0x6880f6fd960d1581c2730a451a22eed1081cfd72"
  has: "6001610bb8f150"
  says: the call to the signature check gets a constant 3,000 gas and its result is dropped
  for: [what, evidence-1, justification]
- id: no-proxy
  storage: "0x6880f6fd960d1581c2730a451a22eed1081cfd72"
  slot: "0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc"
  is: 0
  says: the EIP-1967 implementation slot is empty, so the address is not a proxy
  for: [justification, action]
- id: no-upgrade
  selector: "0x6880f6fd960d1581c2730a451a22eed1081cfd72"
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for: [justification, action]
- id: executed
  ref: "https://github.com/kevaundray/pq-chain-analysis/blob/d9c90afac8137e134d5e884865dfc37bbcb0d397/triage/fuel-v1-fixed-gas-witness-recovery.md"
  says: the study's simulation with the new price, a fraud proof against an honest block pays its caller
  for: [what, evidence-2, justification]
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: Claude, reviewer assigned by Anon
  date: 2026-11-20
  by: ai-assisted
  verdict: confirmed
  rating: CRITICAL
  note: executed; no upgrade path
related: []
---

## What happens

The bridge checks witness signatures with a fixed 3,000 gas and ignores failures. Once EIP-8151 makes the check cost
more, it always fails, so anyone can prove an honestly signed block fraudulent and be paid from the operator's bond.

## Evidence

- Lines 137-144 of the [published source](https://github.com/FuelLabs/fuel-v1-contracts/blob/2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22/src/Witness.yulp#L137-L144)
  call the check with 3,000 gas and ignore the result; the deployed code does the same.
- Simulated with the new price, `proveInvalidWitness` on an honestly signed transaction pays the caller 0.25 ETH
  ([write-up](https://github.com/kevaundray/pq-chain-analysis/blob/d9c90afac8137e134d5e884865dfc37bbcb0d397/triage/fuel-v1-fixed-gas-witness-recovery.md)).

## Reviewer notes

### Mechanism

The witness routine calls `0x01` with a constant 3,000 gas (bytecode at 0x2a70: `PUSH1 0x01 PUSH2 0x0bb8 CALL POP`),
discards the success flag and reads its output buffer as the signer. Under EIP-8151 a successful recovery needs 3,200
or 6,100 gas, so the call fails, the routine reads a stale address, and `proveInvalidWitness` records fraud.

### Checks

- Block 26,438,999: no proxy slot, no upgrade function; `operator()` is 0xfa99…e39c. With `eth_simulateV1` and the new
  price, the proof emits `FraudCommitted(9, 8, 150)` and pays the caller 0.25 ETH; under today's price it finds nothing.
- Not verified on Etherscan or Sourcify: name and project are left empty; the label is the explorer's tag. The recovery
  site in the bytecode matches `Witness.yulp` of the published Fuel v1 source.

### History

- 2026-11-19: reported and executed (study eip-8151-impact).
- 2026-11-20: reviewed, CRITICAL.
