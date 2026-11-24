---
id: contract-59bd11f8-fixed-gas-recovery
format: 2
title: Rollup's signature fraud proofs fail once EIP-8151 raises the check's price
status: candidate
severity: CRITICAL
justification: 'A fixed 3,000 gas in code with no upgrade path: the signature check fails for good once a recovery
  costs more.'
category: breaks-at-activation
pattern: PQ-14
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  code: bytecode
  code_url: https://etherscan.io/address/0x59bd11f8a5a833f26723d044cbb501a40c9c5e43#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 45
  basis: held
activity:
  txs_90d: 0
impact: funds-loss
evidence_level: bytecode
checks:
- id: fixed-gas
  bytecode: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  has: 6001610bb8f1151510156118d55760208152602081fd5b
  says: the call to address 1 gets a constant 3,000 gas and the code reverts when the call fails
  for:
  - evidence-1
  - justification
  - what
- id: no-proxy
  storage: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty, so the address is not a proxy
  for:
  - evidence-2
  - justification
- id: no-upgrade
  selector: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - evidence-2
  - justification
- id: prove-witness
  selector: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: proveInvalidWitness(bytes,bytes)
  says: the code has the fraud proof for invalid witnesses
  for:
  - what
- id: prove-sum
  selector: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: proveInvalidSum(bytes,bytes)
  says: the code has the fraud proof for invalid sums
  for:
  - what
- id: published
  ref: https://github.com/FuelLabs/fuel-v1-contracts/blob/2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22/src/Witness.yulp#L137-L144
  says: the published Fuel v1 helper that recovers a transaction witness calls the precompile with 3,000 gas
  for:
  - evidence-3
  - what
- id: tip
  call: '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  fn: blockTip()(uint256)
  is: 3
  says: the rollup's block tip is 3
  for:
  - what
- id: eth
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  is: 3000000000000000
  says: the address holds 0.003 ETH
  for:
  - what
- id: usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  is: 20000000
  says: the address holds 20 USDC
  for:
  - what
- id: dai
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: balanceOf(address)(uint256)
  args:
  - '0x59bd11f8a5a833f26723d044cbb501a40c9c5e43'
  is: '20000000000000000000'
  says: the address holds 20 DAI
  for:
  - what
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

The rollup gives its signature check a fixed 3,000 gas and reverts if the call fails. Under EIP-8151 a recovery costs more, so every valid signature fails and signature fraud proofs cannot succeed. No transaction called it in 90 days and its block tip is 3. It holds 0.003 ETH, 20 USDC and 20 DAI.

## Evidence

- The [deployed code](https://etherscan.io/address/0x59bd11f8a5a833f26723d044cbb501a40c9c5e43#code) calls address 1 with a constant 3,000 gas and reverts when the call fails.
- The same [code page](https://etherscan.io/address/0x59bd11f8a5a833f26723d044cbb501a40c9c5e43#code) shows no proxy and no upgrade function.
- The [published Fuel v1 source](https://github.com/FuelLabs/fuel-v1-contracts/blob/2cfd8c2dc0261b78ab40acf6bf3267e0b475dc22/src/Witness.yulp#L137-L144) gives its recovery helper the same 3,000 gas.

## Reviewer notes

### Mechanism

Unverified Fuel v1 rollup (Yul+), dispatch includes proveInvalidWitness(bytes,bytes) and proveInvalidSum(bytes,bytes). One routine builds the ecrecover input in memory and runs CALL(gas=3000, to=0x01, in 0x00..0x80, out 0x80..0xa0) at bytecode offset ~0x18c5; if the call returns 0 the code reverts, otherwise it returns the word at 0x80 as the signer. Under EIP-8151 a successful recovery costs 3,200 (warm) or 6,100 (cold) gas, so 3,000 gas cannot pay for it: the call fails and the routine reverts for every valid signature (an invalid one still recovers nothing and costs 3,000). My static walk of the bytecode (jump targets and pushed return addresses; not re-runnable) finds that only those two prover functions reach the routine; commitBlock, commitRoot, deposit and withdraw do not. Opcode scan outside push data: no DELEGATECALL, CALLCODE or SELFDESTRUCT, 1 CREATE and 3 CREATE2 (funnel deployments), 7 CALL (token and ETH transfers); nothing replaces this code. The deployed version differs from the published source at the pinned commit: that one discards the call result, this one reverts.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: ERC-1271: the routine only calls address 1; the code has neither isValidSignature selector (0x1626ba7e, 0x20c13b0b).
- Ruled out: Failure handled: the code reverts on a failed call, it does not read a stale result as the source at the pinned commit does; the effect is that these proofs cannot succeed.
- Ruled out: Proxy or upgrade: EIP-1967 slot empty, no upgradeTo, no DELEGATECALL, CALLCODE or SELFDESTRUCT outside push data; the dispatch lists no setter for the code or the gas.
- Ruled out: Copies: none (one address runs this code); no dependents in the dossier.
- Ruled out: No transaction called it in the 90 days to the block and it has no traced recoveries (dossier): the card says it is dormant; the failure matters again only if block production restarts (the 93,046-block finalization delay means a block committed long ago is past challenge; whether blocks 1 to 3 are finalized was not checked).

### Questions

- Which external functions reach the recovery? A static walk finds proveInvalidWitness(bytes,bytes) and proveInvalidSum(bytes,bytes); a replay of a fraud proof on the fork engine would confirm it.
- Is anyone still running this rollup and may anyone besides its operator commit a block? Only event logs or a replay show it; who holds the deposits is not shown either.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-24: reviewed again and rewritten from checks that were re-run.
