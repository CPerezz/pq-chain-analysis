---
id: dach-64043a98-signed-shortcut-lost
format: 2
title: Dach's relayed Dai and Chai actions stop for accounts that take real code
status: confirmed
severity: INFORMATIONAL
justification: Breaks only if a holder moves its account to real code; the holder can still move its tokens directly.
category: migration-notice
pattern: PQ-19
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x64043a98f097fd6ef0d3ad41588a6b0424723b3a'
  name: Dach
  label: 'deployed by Chai: Deployer'
  code: verified
  code_url: https://etherscan.io/address/0x64043a98f097fd6ef0d3ad41588a6b0424723b3a#code
  copies: 1
  upgradeable: 'no'
value:
  usd: 2082
  basis: held
activity:
  txs_90d: 0
impact: liveness
action: Tell users that once their account takes real code, signed Dach actions fail and they must move Dai and
  Chai by direct calls.
evidence_level: source
checks:
- id: ec-daicheque
  source: '0x64043a98f097fd6ef0d3ad41588a6b0424723b3a'
  file: Dach.sol
  line: 116
  has: sender == ecrecover(digest(DAICHEQUE_TYPEHASH
  says: daiCheque runs only if the recovered signer equals the sender
  for:
  - action
  - evidence-1
  - justification
  - what
- id: ec-daiswap
  source: '0x64043a98f097fd6ef0d3ad41588a6b0424723b3a'
  file: Dach.sol
  line: 127
  has: sender == ecrecover(digest(DAISWAP_TYPEHASH
  says: daiSwap runs only if the recovered signer equals the sender
  for:
  - evidence-1
  - what
- id: ec-joinchai
  source: '0x64043a98f097fd6ef0d3ad41588a6b0424723b3a'
  file: Dach.sol
  line: 139
  has: sender == ecrecover(digest(CHAIJOIN_TYPEHASH
  says: joinChai runs only if the recovered signer equals the sender
  for:
  - evidence-1
  - what
- id: ec-chaicheque
  source: '0x64043a98f097fd6ef0d3ad41588a6b0424723b3a'
  file: Dach.sol
  line: 154
  has: sender == ecrecover(digest(CHAICHEQUE_TYPEHASH
  says: chaiCheque runs only if the recovered signer equals the sender
  for:
  - evidence-1
  - what
- id: ec-chaiswap
  source: '0x64043a98f097fd6ef0d3ad41588a6b0424723b3a'
  file: Dach.sol
  line: 165
  has: sender == ecrecover(digest(CHAISWAP_TYPEHASH
  says: chaiSwap runs only if the recovered signer equals the sender
  for:
  - evidence-1
  - what
- id: ec-exitchai
  source: '0x64043a98f097fd6ef0d3ad41588a6b0424723b3a'
  file: Dach.sol
  line: 177
  has: sender == ecrecover(digest(CHAIEXIT_TYPEHASH
  says: exitChai runs only if the recovered signer equals the sender
  for:
  - evidence-1
  - what
- id: pull-cheque
  source: '0x64043a98f097fd6ef0d3ad41588a6b0424723b3a'
  file: Dach.sol
  line: 121
  has: dai.transferFrom(sender, receiver, amount);
  says: a Dai cheque sends the sender's Dai to the receiver
  for:
  - what
- id: pull-swap
  source: '0x64043a98f097fd6ef0d3ad41588a6b0424723b3a'
  file: Dach.sol
  line: 133
  has: return daiUniswap.tokenToEthTransferInput(amount, min_eth, now, sender);
  says: a Dai swap sells the sender's Dai for ETH sent to the sender
  for:
  - what
- id: pull-join
  source: '0x64043a98f097fd6ef0d3ad41588a6b0424723b3a'
  file: Dach.sol
  line: 145
  has: chai.join(receiver, amount);
  says: a join converts the sender's Dai to Chai for the receiver
  for:
  - what
- id: dai-direct
  call: '0x6b175474e89094c44da98b954eedeac495271d0f'
  fn: transfer(address,uint256)(bool)
  args:
  - '0x00000000000000000000000000000000000000bb'
  - 0
  from: '0x00000000000000000000000000000000000000aa'
  is: true
  says: Dai accepts a transfer called directly by the holder, with no signature
  for:
  - action
  - evidence-2
  - justification
  - what
- id: chai-direct
  call: '0x06af07097c9eeb7fd685c692751d5c66db49c215'
  fn: transfer(address,uint256)(bool)
  args:
  - '0x00000000000000000000000000000000000000bb'
  - 0
  from: '0x00000000000000000000000000000000000000aa'
  is: true
  says: Chai accepts a transfer called directly by the holder, with no signature
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
  rating: LOW
reviews: []
related: []
---

## What happens

Dach lets a relayer send, swap or convert a holder's Dai or Chai when the holder signs the action with ECDSA. Once the holder's account takes real code, its signature stops counting and these actions fail; an EIP-7702 delegation keeps working. Direct transfers stay open.

## Evidence

- Each of the six actions in the [verified source](https://etherscan.io/address/0x64043a98f097fd6ef0d3ad41588a6b0424723b3a#code) runs only if ecrecover of the signed action equals the sender.
- [Dai](https://etherscan.io/token/0x6b175474e89094c44da98b954eedeac495271d0f) and [Chai](https://etherscan.io/token/0x06af07097c9eeb7fd685c692751d5c66db49c215) transfers sent by the holder itself need no signature.

## Reviewer notes

### Mechanism

daiCheque, daiSwap, joinChai, chaiCheque, chaiSwap and exitChai (lines 114-184) each require sender != 0 and sender == ecrecover(EIP-712 digest of the action, v, r, s), then consume nonces[sender] and check expiry. They then pull the sender's Dai or Chai with transferFrom (allowance given beforehand by permit or approve) and send it to the receiver, swap it on the Uniswap v1 exchange for ETH to the sender, or join/exit Chai, paying the relayer a fee. There is no other entry point: no owner, no pause, no ERC-1271 or code-size branch. Under EIP-8151 a sender whose account holds real code gets an empty recovery, so every action reverts with 'invalid ...'; a 7702-delegated sender still recovers. The holder keeps its tokens and can transfer them from its own address (Dai.transfer and Chai.transfer return true for a direct call from any address at the block). The 400 UNI the address holds (the $2,082) cannot be moved by any function of Dach; it is nobody's stake in this issue, so whose is left empty. Two dependents hold Dach's address (0x3238695287924b4b5a32d71653fc6c26b03b5209, 0x84b65d1c28c81ccf341f357eb669133dc5d74831); they were not read.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size path for signers with code: each action's only authorization is the ecrecover equality (lines 116, 127, 139, 154, 165, 177), and the contract has no other function.
- Ruled out: a fixed gas amount for the precompile: Solidity's ecrecover forwards the available gas and the scanner found no gas constant; nothing breaks with nobody migrating, so no rated gas finding sits beside this notice.
- Ruled out: a signature relied on before it is checked: each signature is checked once, when the relayer submits it, and its nonce is consumed then; no other party relies on it earlier.
- Ruled out: a closed path: Dach has no owner or pause; Dai, Chai and both Uniswap v1 exchanges have code at the block, and Dach's Dai allowance to Chai is still the maximum.
- Ruled out: replay evidence: the study has no replays and no recoveries in its trace window for this code, and 0 transactions in 90 days.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
