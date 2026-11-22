---
id: r-28acf731-fixed-gas-recovery
format: 2
title: Random-number contract rejects every oracle answer once EIP-8151 is live
status: candidate
severity: CRITICAL
justification: 'No update path: the fixed gas makes the check fail for good under EIP-8151, whatever the contract
  holds then.'
category: breaks-at-activation
pattern: PQ-14
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x28acf73120a256bae770f0249be20a46f18ee314'
  name: R
  code: verified
  code_url: https://etherscan.io/address/0x28acf73120a256bae770f0249be20a46f18ee314#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 4
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Move randomness requests to a new contract whose proof check gives the signature precompile enough gas;
  this one cannot change.
evidence_level: source
checks:
- id: fixed-gas
  source: '0x28acf73120a256bae770f0249be20a46f18ee314'
  file: R.sol
  line: 1246
  has: ret := call(3000, 1, 0, size, 128, size, 32)
  says: the signature precompile at 0x01 gets a constant 3,000 gas
  for:
  - action
  - evidence-1
  - justification
  - what
- id: fixed-gas-bytecode
  bytecode: '0x28acf73120a256bae770f0249be20a46f18ee314'
  has: 6001610bb8f1
  says: the deployed code calls address 1 with a constant 3,000 (0x0bb8) gas
  for:
  - evidence-1
  - what
- id: verifysig
  source: '0x28acf73120a256bae770f0249be20a46f18ee314'
  file: R.sol
  lines:
  - 1111
  - 1116
  has: (sigok, signer) = safer_ecrecover(_tosignh, 27, sigr, sigs);
  says: verifySig accepts a signature only if the address returned by the 3,000-gas call equals the key's address
  for:
  - evidence-2
  - what
- id: step5
  source: '0x28acf73120a256bae770f0249be20a46f18ee314'
  file: R.sol
  line: 1198
  has: if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) {
  says: every proof check verifies the session key's signature
  for:
  - evidence-2
  - what
- id: returncode
  source: '0x28acf73120a256bae770f0249be20a46f18ee314'
  file: R.sol
  lines:
  - 1152
  - 1154
  has: return 2;
  says: a failed proof gives return code 2
  for:
  - evidence-2
  - what
- id: callback
  source: '0x28acf73120a256bae770f0249be20a46f18ee314'
  file: R.sol
  line: 1327
  has: require(provable_randomDS_proofVerify__returnCode(_queryId, _result, _proof) == 0, 'Bad Proof');
  says: the callback reverts with 'Bad Proof' unless the proof verifies
  for:
  - evidence-2
  - justification
  - what
- id: emit
  source: '0x28acf73120a256bae770f0249be20a46f18ee314'
  file: R.sol
  line: 1331
  has: emit generatedRandomNumber(result);
  says: the random number is emitted only after the proof check
  for:
  - what
- id: generate
  source: '0x28acf73120a256bae770f0249be20a46f18ee314'
  file: R.sol
  lines:
  - 1334
  - 1339
  has: bytes32 qid = provable_newRandomDSQuery(
  says: generate sends a Provable random query with a Ledger proof
  for:
  - what
- id: price
  call: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  fn: getPrice(string,uint256)(uint256)
  args:
  - random
  - 200000
  from: '0x28acf73120a256bae770f0249be20a46f18ee314'
  is: 4042379346001950
  says: one random query with 200,000 callback gas costs this contract 0.00404 ETH
  for:
  - notes
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x28acf73120a256bae770f0249be20a46f18ee314'
  is: 1943736145025700
  says: the contract holds 0.0019 ETH
  for:
  - notes
- id: bad-address
  source: '0x28acf73120a256bae770f0249be20a46f18ee314'
  file: R.sol
  line: 1326
  has: require(msg.sender == provable_cbAddress(), 'Bad Address');
  says: the callback accepts an answer only from an address the connector registers as a callback sender
  for:
  - what
- id: sender-used
  nonce: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  is: 62508
  at: 12000000
  says: the callback sender had sent 62,508 transactions at block 12,000,000 (March 2021)
  for:
  - what
- id: sender-registered
  call: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  fn: cbAddress()(address)
  from: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  is: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  at: 13000000
  says: the connector recognised it as a callback sender at block 13,000,000 (August 2021)
  for:
  - what
- id: sender-dropped
  call: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  fn: cbAddress()(address)
  from: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  is: '0x0000000000000000000000000000000000000000'
  at: 14000000
  says: the connector no longer recognised it at block 14,000,000 (January 2022)
  for:
  - what
- id: sender-dropped-now
  call: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  fn: cbAddress()(address)
  from: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  is: '0x0000000000000000000000000000000000000000'
  says: it is still not a callback sender at block 26,438,999
  for:
  - what
- id: sender-idle
  nonce: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  is: 63426
  at: 14000000
  says: the sender had sent 63,426 transactions at block 14,000,000
  for:
  - what
- id: sender-idle-now
  nonce: '0x000042425e06b0b1e8e20a811c91d6864608324b'
  is: 63426
  says: 'it has sent none since: still 63,426 at block 26,438,999'
  for:
  - what
- id: oar
  call: '0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed'
  fn: getAddress()(address)
  is: '0x3dBDc81a6edc94c720B0B88FB65dBD7e395fDcf6'
  says: the Provable address resolver the contract uses points to the oracle connector
  for:
  - what
- id: fee
  source: '0x28acf73120a256bae770f0249be20a46f18ee314'
  file: R.sol
  line: 647
  has: 'return provable.queryN_withGasLimit{value: price}(0, _datasource, args, _gasLimit);'
  says: the contract's ETH leaves only as the oracle's query fee
  for:
  - justification
- id: no-proxy
  storage: '0x28acf73120a256bae770f0249be20a46f18ee314'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty, so the address is not a proxy
  for:
  - action
  - evidence-3
  - justification
- id: no-upgrade
  selector: '0x28acf73120a256bae770f0249be20a46f18ee314'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - action
  - evidence-3
  - justification
- id: no-owner
  selector: '0x28acf73120a256bae770f0249be20a46f18ee314'
  fn: owner()
  absent: true
  says: the code has no owner function
  for:
  - action
  - evidence-3
  - justification
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

It emits a random number from the Provable oracle only after checking the oracle's signed proof. Each check gives the precompile a fixed 3,000 gas, so EIP-8151 rejects every answer. The oracle has looked silent since early 2022: its 2021 callback sender was deregistered and sent nothing since.

## Evidence

- The [signature check](https://etherscan.io/address/0x28acf73120a256bae770f0249be20a46f18ee314#code) calls the precompile with a fixed 3,000 gas; the deployed code holds the same constant.
- The [callback](https://etherscan.io/address/0x28acf73120a256bae770f0249be20a46f18ee314#code) rejects an answer with 'Bad Proof' unless its proof signatures recover to the expected keys.
- The [contract](https://etherscan.io/address/0x28acf73120a256bae770f0249be20a46f18ee314#code) has no owner and no upgrade function, so its code cannot change.

## Reviewer notes

### Mechanism

generate (anyone, payable) sets from/to and sends a Provable 'random' query with a Ledger proof, paying the fee from the contract's balance (provable_query, line 647). Provable answers through __callback (line 1319), which requires msg.sender == the connector's cbAddress() ('Bad Address', line 1326) and provable_randomDS_proofVerify__returnCode == 0, else reverts 'Bad Proof' (line 1327). The proof check (__main, lines 1170-1205) always runs verifySig on sig1 with the session key (step 5, line 1198), and on first use of a session key also the app-key and Ledger-key signatures. verifySig (lines 1096-1118) calls safer_ecrecover with v=27 then v=28 and compares the returned address with keccak256(pubkey); it ignores the success flag. safer_ecrecover (line 1246) calls 0x01 with a constant 3,000 gas (bytecode 6001610bb8f1). Under EIP-8151 a recovery costs 3,200 (warm) or 6,100 (cold), so the call runs out of gas, the buffer keeps the input hash, the comparison fails, returnCode is 2 and the callback reverts. Nothing is locked by the change: the only ETH out is the query fee. Oracle state: connector cbAddress() from 0x0000…324B returns it at blocks 12M and 13M, zero at 14M and 26,438,999; its nonce is 63,426 at both.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a wrong verdict: a failed recovery leaves the input hash in the buffer, which does not equal the expected key's address, so the proof fails closed (lines 1111-1116).
- Ruled out: a second path to emit a number: the only emit is in __callback after the proof check (line 1331); the two-argument __callback forwards to it with an empty proof.
- Ruled out: an update path: no EIP-1967 implementation, no upgradeTo and no owner() selector at block 26,438,999.
- Ruled out: a skipped check: the cached session-key flag skips only steps 6-7; step 5 (line 1198) runs on every answer.
- Ruled out: the signers having code: the keys are Ledger and Provable session keys passed as public keys; the break is the gas, with nobody migrating.
- Ruled out: funds locked: the contract has no withdraw function; its 0.0019 ETH can only pay query fees (line 647), before and after the change, and is less than one query's price (0.00404 ETH at the block).
- Ruled out: path closed (oracle dead): the sender seen in 2021 is deregistered and idle, so __callback would already revert 'Bad Address'; but the connector's sender mapping cannot be listed without logs, so a later sender is not excluded. Kept as a finding and rated as if the oracle answers.

### Questions

- Whose is the 0.0019 ETH? The earlier review reports it is the deployer's leftover from two paid generate() calls in 2021; I could not cite those transactions (no hashes in the dossier, no log scans), so whose stays empty.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
