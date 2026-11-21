---
id: contract-2dedcda7-fixed-gas-recovery
format: 2
title: Oraclize random-number payouts fail for good once EIP-8151 is live
status: candidate
severity: MEDIUM
justification: The draw dies at activation if Oraclize still answers; no owner or upgrade fixes it; it holds no
  ETH now.
category: breaks-at-activation
pattern: PQ-14
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2dedcda70c6724a5833a8e07c0103c0e5face529'
  label: 'deployed by Wise: Deployer'
  code: decompiled
  code_url: code/0x0905763ee80de2fff3582868d61195be59e7cfc42dfb27829171f512bfebd7a9.sol
  copies: 1
  upgradeable: 'no'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Stop sending this contract ETH and retire it before EIP-8151 activates; its code cannot be changed.
evidence_level: bytecode
checks:
- id: fixed-gas
  bytecode: '0x2dedcda70c6724a5833a8e07c0103c0e5face529'
  has: 6001610bb8f1
  says: the code calls precompile 0x01 with a constant 3,000 gas (PUSH1 0x01 PUSH2 0x0bb8 CALL)
  for:
  - action
  - evidence-1
  - justification
  - what
- id: ledger-key
  bytecode: '0x2dedcda70c6724a5833a8e07c0103c0e5face529'
  has: 7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4
  says: the code holds Oraclize's Ledger public key, the constant of its random-number proof check
  for:
  - evidence-1
  - what
- id: callback
  selector: '0x2dedcda70c6724a5833a8e07c0103c0e5face529'
  fn: __callback(bytes32,string,bytes)
  says: the code has the Oraclize callback that receives an answer with its proof
  for:
  - what
- id: dispatch
  bytecode: '0x2dedcda70c6724a5833a8e07c0103c0e5face529'
  has: 63205282f01461005b57806327dc297e1461007257806338bbfa501461014457610056565b36610056576509184e72a000471115610054576100536102ad565b5b005b600080fd
  says: dispatcher knows only doCall and the two callbacks; other selectors revert; a plain transfer above 1e13
    wei starts a query
  for:
  - action
  - evidence-2
  - justification
  - what
- id: oar
  storage: '0x2dedcda70c6724a5833a8e07c0103c0e5face529'
  slot: '0x1'
  is: '0x0000000000000000000000001d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed'
  says: the contract is set to the mainnet Oraclize address resolver
  for:
  - what
- id: connector
  call: '0x1d3b2638a7cc9f2cb3d298a3da7a90b67e5506ed'
  fn: getAddress()(address)
  is: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  says: the resolver names connector 0x3dbd…dcf6, the one this contract uses
  for:
  - evidence-3
  - what
- id: cb-unregistered
  call: '0x3dbdc81a6edc94c720b0b88fb65dbd7e395fdcf6'
  fn: cbAddress()(address)
  from: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: '0x0000000000000000000000000000000000000000'
  says: the connector returns the caller as callback address only when registered; for Oraclize's long-known answering
    account it returns zero
  for:
  - evidence-3
  - what
- id: cb-nonce-2022
  nonce: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  at: 14000000
  is: 584553
  says: Oraclize's long-known answering account had sent 584,553 transactions by block 14,000,000 (early 2022)
  for:
  - evidence-3
  - what
- id: cb-nonce
  nonce: '0x26588a9301b0428d95e6fc3a5024fce8bec12d51'
  is: 584553
  says: 'the same count at the study''s block: it has sent nothing since'
  for:
  - evidence-3
  - what
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x2dedcda70c6724a5833a8e07c0103c0e5face529'
  is: 0
  says: the contract holds no ETH
  for:
  - justification
- id: no-proxy
  storage: '0x2dedcda70c6724a5833a8e07c0103c0e5face529'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty, so the address is not a proxy
  for:
  - action
  - evidence-2
  - justification
  - what
- id: no-upgrade
  selector: '0x2dedcda70c6724a5833a8e07c0103c0e5face529'
  fn: upgradeTo(address)
  absent: true
  says: the code has no upgrade function
  for:
  - action
  - evidence-2
  - justification
  - what
- id: no-owner
  call: '0x2dedcda70c6724a5833a8e07c0103c0e5face529'
  fn: owner()(address)
  reverts: true
  says: the contract has no owner() getter
  for:
  - action
  - evidence-2
  - justification
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

It pays out ETH by an Oraclize random number if the answer's proof signature checks out. That check gets a fixed 3,000 gas, so under EIP-8151 every answer fails and ETH sent for draws is lost. Oraclize looks silent since early 2022: its known answering account stopped and is not registered.

## Evidence

- The [deployed code](https://etherscan.io/address/0x2dedcda70c6724a5833a8e07c0103c0e5face529#code) calls address 0x01 with a constant 3,000 gas inside the Oraclize random-proof check.
- The [same code](https://etherscan.io/address/0x2dedcda70c6724a5833a8e07c0103c0e5face529#code) has three functions and no owner, upgrade or withdrawal; its proxy slot is empty.
- [Oraclize's answering account](https://etherscan.io/address/0x26588a9301b0428d95e6fc3a5024fce8bec12d51) sent nothing after block 14,000,000 and is not registered with this contract's connector.

## Reviewer notes

### Mechanism

Unverified Solidity code on oraclizeAPI. The dispatcher knows doCall() (0x205282f0, not payable), __callback(bytes32,string) (0x27dc297e) and __callback(bytes32,string,bytes) (0x38bbfa50); other selectors revert; a plain ETH transfer is accepted and starts a random query once the balance is at least 1e13 wei (bytes 0x38-0x55). The query fee goes to the connector (slot 0, resolver in slot 1). Each callback requires msg.sender == connector.cbAddress(), which the connector returns only when registered, then runs the random-DS proof: a stored commitment (slot 3), then safer_ecrecover CALL(3000, 0x01) at 0x318e with the success flag dropped; the recovered key must match the constant Ledger key. Only then does it transfer keccak(result) % 1e18 wei to one of two addresses (slots 5, 6) via the CALLs at 0x4fa/0x56d. Under EIP-8151 the 3,000-gas call fails, the key never matches, and no answer is accepted. ETH then has no exit but the query fee: no withdrawal, owner, upgrade, selfdestruct or delegatecall in the code.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: old issue fixed-signer: the Ledger key is constant, but the 3,000-gas call breaks every proof at activation with nobody migrating, so the rated issue is fixed-gas-recovery.
- Ruled out: path-closed: the oracle's long-known answering account 0x2658…2d51 has the same nonce (584,553) at blocks 14,000,000 and 26,438,999 and the connector does not report it as registered; the connector's sender mapping cannot be listed without logs, so a later sender is not excluded. Kept as a finding and rated as if the oracle answered; if nobody answers, the draw is already dead and nothing changes at activation.
- Ruled out: reachability: a jump-resolving walk of the bytecode (earlier draft) reaches the CALL at 0x318e from both callbacks and not from receive or doCall.
- Ruled out: payout without the check: a local evm run of the deployed code (earlier draft; stubbed resolver/connector, crafted proof) pays at 0x4fa with a valid signature; with the 3,000 patched to 1 it pays nothing. Local, not pinned: evidence stays bytecode.
- Ruled out: an ERC-1271 or code-size branch: none; the signer comes from a public key carried in the proof.
- Ruled out: an admin path: owner() reverts, no upgradeTo, EIP-1967 slot empty, three selectors only, no SELFDESTRUCT, DELEGATECALL or CALLCODE opcode.
- Ruled out: copies: none listed; slots 0-2 hold mainnet Oraclize values, so this address was configured itself.

### Questions

- Whether Oraclize/Provable still answers queries on mainnet: its known answering accounts stopped by early 2022, but a later registered sender cannot be excluded without logs.
- Who funds this contract and who holds the two payee addresses in slots 5 and 6: no history was read (no log scans).

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
