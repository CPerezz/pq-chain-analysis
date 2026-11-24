---
id: contract-0aa6f298-rotate-signer-before-migrating
format: 2
title: Executor operators lose relayed signing when their accounts take real code
status: candidate
severity: INFORMATIONAL
justification: Only the relayed path breaks; the operator can still call directly and the owner Safe can add a new
  key.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x0aa6f2988722c1f5ef8d1e2f2fbb75676093358c'
  code: decompiled
  code_url: code/0x539f03b56052e7cad7d19e23404c34d0c94d232454dcdd3c4aca30bdfb178644.sol
  proxy_of: '0x44480f176110ee31b0837856fba41ce3a04d6f9e'
  copies: 2
  family: 2cc64692c441edda064ef47c180155c3
  upgradeable: 'yes'
  admin: '0x0a061e4c1410864312915e8d7fd0123f2e04707c'
value:
  usd: 106
  whose: operator
  basis: held
activity: {}
impact: liveness
action: Before an operator moves to real code, register a new key via the owner Safe or call directly; EIP-7702
  delegation still works.
evidence_level: bytecode
checks:
- id: impl
  storage: '0x0aa6f2988722c1f5ef8d1e2f2fbb75676093358c'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x00000000000000000000000044480f176110ee31b0837856fba41ce3a04d6f9e'
  says: the proxy runs implementation 0x44480f17
  for:
  - what
- id: selector
  says: the implementation dispatches selector 0x952a2970, the signed batch entry
  bytecode: '0x44480f176110ee31b0837856fba41ce3a04d6f9e'
  has: 63952a2970
  for:
  - what
- id: ecrecover
  bytecode: '0x44480f176110ee31b0837856fba41ce3a04d6f9e'
  has: 60015afa
  says: the code calls the ecrecover precompile with all remaining gas
  for:
  - evidence-1
  - justification
  - what
- id: relayer
  bytecode: '0x44480f176110ee31b0837856fba41ce3a04d6f9e'
  has: 73a18fd8b6ff7091b15f9bc1c3876e6529a0f8e7aa33
  says: the signed path compares the caller with the fixed relayer 0xa18f...e7aa
  for:
  - what
- id: opcheck
  bytecode: '0x44480f176110ee31b0837856fba41ce3a04d6f9e'
  has: 165f52600560205260ff60405f20541615
  says: the recovered address is looked up in the operator mapping (slot 5) and the call reverts if it is not set
  for:
  - evidence-1
  - justification
  - what
- id: setter
  bytecode: '0x44480f176110ee31b0837856fba41ce3a04d6f9e'
  has: 7f966c160e1c4dbc7df8d69af4ace01e9297c3cf016397b7914971f2fbfa32672d91835f526005825261
  says: the operator setter writes the operator mapping (slot 5) and emits OperatorUpdated
  for:
  - action
  - evidence-1
  - justification
  - what
  - whose
- id: onlyowner
  bytecode: '0x44480f176110ee31b0837856fba41ce3a04d6f9e'
  has: 73ffffffffffffffffffffffffffffffffffffffff5f541633036126a657
  says: owner-only functions compare the caller with the owner in slot 0
  for:
  - action
  - justification
  - what
  - whose
- id: owner
  call: '0x0aa6f2988722c1f5ef8d1e2f2fbb75676093358c'
  fn: owner()(address)
  is: '0xC338094Bb79AA610E9c57166fc4FA959db6234Ab'
  says: the owner is Safe 0xc338...34ab
  for:
  - action
  - justification
  - whose
- id: threshold
  call: '0xc338094bb79aa610e9c57166fc4fa959db6234ab'
  fn: getThreshold()(uint256)
  is: '2'
  says: the owner Safe needs 2 signatures
  for:
  - action
  - justification
- id: ops
  logs: '0x0aa6f2988722c1f5ef8d1e2f2fbb75676093358c'
  topic: '0x966c160e1c4dbc7df8d69af4ace01e9297c3cf016397b7914971f2fbfa32672d'
  from: 25984157
  to: 26438999
  count: 7
  says: seven OperatorUpdated events since the proxy was created, each enabling an operator
  for:
  - what
- id: opcode1
  code: '0x1e9e18152552609175826f3ee6f8bfd639532e37'
  is: empty
  says: operator 0x1e9e1815 has no code at the block
  for:
  - what
- id: opset1
  call: '0x0aa6f2988722c1f5ef8d1e2f2fbb75676093358c'
  fn: operators(address)(bool)
  args:
  - '0x1e9e18152552609175826f3ee6f8bfd639532e37'
  is: 'true'
  says: 0x1e9e1815 is a registered operator at the block
  for:
  - what
- id: opcode2
  code: '0x25f4c6c1e5cc564071a1dc1768a1f1ff0ba9d5a1'
  is: empty
  says: operator 0x25f4c6c1 has no code at the block
  for:
  - what
- id: opset2
  call: '0x0aa6f2988722c1f5ef8d1e2f2fbb75676093358c'
  fn: operators(address)(bool)
  args:
  - '0x25f4c6c1e5cc564071a1dc1768a1f1ff0ba9d5a1'
  is: 'true'
  says: 0x25f4c6c1 is a registered operator at the block
  for:
  - what
- id: opcode3
  code: '0xf4bb8842dd662c8edded051e66376937e308b905'
  is: empty
  says: operator 0xf4bb8842 has no code at the block
  for:
  - what
- id: opset3
  call: '0x0aa6f2988722c1f5ef8d1e2f2fbb75676093358c'
  fn: operators(address)(bool)
  args:
  - '0xf4bb8842dd662c8edded051e66376937e308b905'
  is: 'true'
  says: 0xf4bb8842 is a registered operator at the block
  for:
  - what
- id: opcode4
  code: '0x1b613556c0edbba04c53e4685da338ace02896c4'
  is: empty
  says: operator 0x1b613556 has no code at the block
  for:
  - what
- id: opset4
  call: '0x0aa6f2988722c1f5ef8d1e2f2fbb75676093358c'
  fn: operators(address)(bool)
  args:
  - '0x1b613556c0edbba04c53e4685da338ace02896c4'
  is: 'true'
  says: 0x1b613556 is a registered operator at the block
  for:
  - what
- id: opcode5
  code: '0x728498b753bdbbb549c6a9a9c74bd12ba370ba8a'
  is: empty
  says: operator 0x728498b7 has no code at the block
  for:
  - what
- id: opset5
  call: '0x0aa6f2988722c1f5ef8d1e2f2fbb75676093358c'
  fn: operators(address)(bool)
  args:
  - '0x728498b753bdbbb549c6a9a9c74bd12ba370ba8a'
  is: 'true'
  says: 0x728498b7 is a registered operator at the block
  for:
  - what
- id: opcode6
  code: '0xdcff9f2a34c9e08ef88c2f5fa62f48f774ee339f'
  is: empty
  says: operator 0xdcff9f2a has no code at the block
  for:
  - what
- id: opset6
  call: '0x0aa6f2988722c1f5ef8d1e2f2fbb75676093358c'
  fn: operators(address)(bool)
  args:
  - '0xdcff9f2a34c9e08ef88c2f5fa62f48f774ee339f'
  is: 'true'
  says: 0xdcff9f2a is a registered operator at the block
  for:
  - what
- id: opcode7
  code: '0xb74967b4bccc012f4e155e4cdd4b831a80365f60'
  is: empty
  says: operator 0xb74967b4 has no code at the block
  for:
  - what
- id: opset7
  call: '0x0aa6f2988722c1f5ef8d1e2f2fbb75676093358c'
  fn: operators(address)(bool)
  args:
  - '0xb74967b4bccc012f4e155e4cdd4b831a80365f60'
  is: 'true'
  says: 0xb74967b4 is a registered operator at the block
  for:
  - what
- id: d09c5eabe
  says: the implementation dispatches direct entry 0x09c5eabe
  bytecode: '0x44480f176110ee31b0837856fba41ce3a04d6f9e'
  has: 6309c5eabe
  for:
  - what
- id: d28580b87
  says: the implementation dispatches direct entry 0x28580b87
  bytecode: '0x44480f176110ee31b0837856fba41ce3a04d6f9e'
  has: 6328580b87
  for:
  - what
- id: d813d363d
  says: the implementation dispatches direct entry 0x813d363d
  bytecode: '0x44480f176110ee31b0837856fba41ce3a04d6f9e'
  has: 63813d363d
  for:
  - what
- id: d8a994829
  says: the implementation dispatches direct entry 0x8a994829
  bytecode: '0x44480f176110ee31b0837856fba41ce3a04d6f9e'
  has: 638a994829
  for:
  - what
- id: dcd601439
  says: the implementation dispatches direct entry 0xcd601439
  bytecode: '0x44480f176110ee31b0837856fba41ce3a04d6f9e'
  has: 63cd601439
  for:
  - what
- id: directcheck
  bytecode: '0x44480f176110ee31b0837856fba41ce3a04d6f9e'
  has: 335f52600560205260ff60405f205416156113
  says: direct entries look the caller itself up in the operator mapping (slot 5), with no signature
  for:
  - action
  - justification
  - what
- id: directerr
  bytecode: '0x44480f176110ee31b0837856fba41ce3a04d6f9e'
  has: 7f4d739bfe
  says: a caller that is not an operator is refused with error 0x4d739bfe
  for:
  - what
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-0aa6f298, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'kept: INFORMATIONAL candidate (PQ-17, bytecode): the proxy in use over 0x44480f17 accepts relayed batches
    (0x952a2970, only from relayer 0xa18f…e7aa) when the recovered ECDSA signer is a registered operator; an operator
    whose account takes real code loses only that relayed path and keeps five direct entries checked on msg.sender;
    the 2-of-2 owner Safe can register a new key. Seven operators registered, none with code (Claude''s log read,
    cited). Refuter agrees after disassembling the code; Claude read the sheet.'
related: []
---

## What happens

This executor proxy runs batches a fixed relayer submits with an operator's ECDSA signature, or an operator calls directly. Seven operators are registered, all plain accounts; the owner sets them. An operator whose account takes real code is refused on the relayed path; direct calls keep working.

## Evidence

- [Implementation code](https://etherscan.io/address/0x44480f176110ee31b0837856fba41ce3a04d6f9e#code) recovers the signer with ecrecover and requires it in the owner-set operator list.

## Reviewer notes

### Mechanism

Proxy 0x0aa6 (EIP-1967) delegates to 0x44480f17 (unverified). Selector 0x952a2970 (dispatch to 0x1525): requires deadline >= block.number, requires CALLER == 0xa18fd8b6ff7091b15f9bc1c3876e6529a0f8e7aa (else revert 0x27d92fad), builds an EIP-712-style struct hash with chainid and address(this), wraps it in the eth_sign prefix, calls precompile 0x01 with all gas (PUSH1 1 GAS STATICCALL at 0x1682), then reads mapping slot 5 at the recovered address (operators, getter 0x13e7c9d8) and reverts 0x6acaf8b3 if unset, else continues into the batch execution. Setter 0x558a7297 (owner-only: slot0 == CALLER, error 0x118cdaa7) writes slot 5 and emits OperatorUpdated. Owner at the block is Safe 0xc338 (2 of 2), which also owns the ProxyAdmin 0x0a06. The relayer 0xa18f has no code and nonce 477.

### Checks

- Header facts: this address alone, at block 26,438,999; 2 addresses run this code.
- Ruled out: an ERC-1271 path: the implementation code holds no 0x1626ba7e selector.
- Ruled out: fixed gas: the recovery forwards all gas (GAS before STATICCALL), so no budget breaks at activation.
- Ruled out: the relayer itself: it is checked as CALLER, not recovered, and is not an operator (operators(relayer) is false).
- Ruled out: copy 0x44480f17 is the implementation itself, owned by 0xdead; it is not used on its own.
- Ruled out: a direct path: five entries (0x09c5eabe, 0x28580b87, 0x813d363d, 0x8a994829, 0xcd601439) check the caller against the operator mapping without a signature (error 0x4d739bfe); stated on the card.
- Ruled out: an operator already with code: all seven enabled operators have empty code and operators() true at the block.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
