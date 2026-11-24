---
id: contract-2cc81b80-wallets-fixed-signers
format: 2
title: Wallet's ETH locks if three of its five fixed signers take real code
status: candidate
severity: INFORMATIONAL
justification: Breaks only if signers move to real code, which they can avoid; nothing replaces them, so the funds
  must move first.
category: migration-notice
pattern: PQ-17
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  code: bytecode
  code_url: https://etherscan.io/address/0x2cc81b80a293408a89084c77a0983de0730f731a#code
  copies: 31
  family: daae40664b3ee8373c01a402cdc2362c
  upgradeable: 'no'
value:
  usd: 47979732
  basis: held
activity:
  txs_90d: 14
impact: funds-locked
action: Move the funds to a wallet whose signers can be replaced before three of the five signers move to real code.
evidence_level: bytecode
checks:
- id: recover
  bytecode: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  has: 600186828585604051600081526020016040526040518085600019166000191681526020018460ff1660ff1681526020018360001916600019168152602001826000191660001916815260200194505050505060206040516020810390808403906000865af1
  says: each signature is recovered by a call to precompile 1 with all remaining gas, reading a word zeroed before
    the call
  for:
  - action
  - evidence-1
  - justification
  - what
- id: threshold
  bytecode: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  has: 6041955085600354028a51141515610cd357600080fd5b
  says: the signatures must be exactly the number in slot 3 times 65 bytes
  for:
  - action
  - evidence-1
  - what
- id: loop
  bytecode: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  has: 600354841015610e8e57
  says: one signature is recovered per unit of the number in slot 3
  for:
  - evidence-1
  - what
- id: signer-check
  bytecode: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  has: 610e0c8b846110a4565b9050610e1781610519565b1515610e2257600080fd5b610e2c8186611171565b15610e3657600080fd5b
  says: each recovered address must pass isSigner and must not repeat, or the call reverts
  for:
  - evidence-1
  - justification
  - what
- id: signer-list
  bytecode: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  has: 600080600090505b6000805490508110156105b157
  says: isSigner walks the address array in slot 0
  for:
  - evidence-1
  - what
- id: dispatch
  bytecode: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  has: 80632079fb9a146101335780637df73e27146101a0578063959f9114146101fb57806397f6c4481461021257806398f44b9a146102f25780639977c78a146103b9578063a0b7967b14610426578063abe3219c14610451578063e384346314610480575b
  says: the code dispatches nine functions and otherwise falls to its fallback
  for:
  - action
  - evidence-2
  - justification
  - what
- id: sel-signers
  selector: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  fn: signers(uint256)
  says: a read of the signer list
  for:
  - evidence-2
  - what
- id: sel-senders
  selector: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  fn: senders(uint256)
  says: a read of the sender list
  for:
  - evidence-2
  - what
- id: sel-issigner
  selector: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  fn: isSigner(address)
  says: 'a read: is an address a signer'
  for:
  - evidence-2
  - what
- id: sel-issender
  selector: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  fn: isSender(address)
  says: 'a read: is an address a sender'
  for:
  - evidence-2
  - what
- id: sel-safemode
  selector: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  fn: safeMode()
  says: a read of the safe-mode flag
  for:
  - evidence-2
  - what
- id: sel-seq
  selector: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  fn: getNextSequenceId()
  says: a read of the next sequence id
  for:
  - evidence-2
  - what
- id: sel-setsafe
  selector: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  fn: setSafeMode()
  says: the safe-mode switch
  for:
  - evidence-2
  - what
- id: safe-store
  bytecode: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  has: 6001600460006101000a81548160ff021916908315150217905550
  says: the safe-mode switch only sets the flag byte of slot 4 to one
  for:
  - action
  - evidence-2
  - justification
  - what
- id: seq-store
  bytecode: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  has: 82600583600a8110151561109a57fe5b0181905550
  says: the other write stores a sequence id in one of slots 5 to 14
  for:
  - action
  - evidence-2
  - justification
  - what
- id: sender-check
  bytecode: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  has: 600061098533610bca565b151561099057600080fd5b
  says: a send also requires its caller to pass isSender
  for:
  - notes
- id: n-signers
  storage: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  slot: 0
  is: 5
  says: the signer list holds five addresses
  for:
  - action
  - evidence-3
  - what
- id: n-needed
  storage: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  slot: 3
  is: 3
  says: three signatures are required
  for:
  - action
  - evidence-1
  - what
- id: safe-off
  storage: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  slot: 4
  is: 0
  says: safe mode is off
  for:
  - notes
- id: no-proxy
  storage: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: 0
  says: the EIP-1967 implementation slot is empty
  for:
  - notes
- id: balance
  call: '0xca11bde05977b3631167028862be2a173976ca11'
  fn: getEthBalance(address)(uint256)
  args:
  - '0x2cc81b80a293408a89084c77a0983de0730f731a'
  is: '26588050000061000000000'
  says: the wallet holds 26,588.05 ETH
  for:
  - what
- id: deposit
  tx: '0x0ea1a66a9efdf88e1a38c124946c989f77ea33dc576bc232587ad4bef51dbb37'
  to: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  ok: true
  says: a 2,590 ETH deposit to the wallet succeeded at block 26,404,393
  for:
  - evidence-3
- id: signer-0
  call: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  fn: signers(uint256)(address)
  args:
  - 0
  is: '0xcac178f2fed6a02208dcf8057cf76632d8a39065'
  says: signer 0 of the five
  for:
  - evidence-3
- id: signer-1
  call: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  fn: signers(uint256)(address)
  args:
  - 1
  is: '0xed90af46e440f83fff0a9270c6e09402a2a92e6c'
  says: signer 1 of the five
  for:
  - evidence-3
- id: signer-2
  call: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  fn: signers(uint256)(address)
  args:
  - 2
  is: '0xfbe8233b91234e8ee5a5e6a793d81cc9505f08d6'
  says: signer 2 of the five
  for:
  - evidence-3
- id: signer-3
  call: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  fn: signers(uint256)(address)
  args:
  - 3
  is: '0x7e9445753f67662d49d78d8beb37951b51cec080'
  says: signer 3 of the five
  for:
  - evidence-3
- id: signer-4
  call: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  fn: signers(uint256)(address)
  args:
  - 4
  is: '0x21fa44ac18448b6f4fda577579f02e597a436929'
  says: signer 4 of the five
  for:
  - evidence-3
- id: plain-0
  code: '0xcac178f2fed6a02208dcf8057cf76632d8a39065'
  is: empty
  says: signer 0 has no code
  for:
  - evidence-3
  - justification
- id: plain-1
  code: '0xed90af46e440f83fff0a9270c6e09402a2a92e6c'
  is: empty
  says: signer 1 has no code
  for:
  - evidence-3
  - justification
- id: plain-2
  code: '0xfbe8233b91234e8ee5a5e6a793d81cc9505f08d6'
  is: empty
  says: signer 2 has no code
  for:
  - evidence-3
  - justification
- id: plain-3
  code: '0x7e9445753f67662d49d78d8beb37951b51cec080'
  is: empty
  says: signer 3 has no code
  for:
  - evidence-3
  - justification
- id: plain-4
  code: '0x21fa44ac18448b6f4fda577579f02e597a436929'
  is: empty
  says: signer 4 has no code
  for:
  - evidence-3
  - justification
- id: nonce-0
  nonce: '0xcac178f2fed6a02208dcf8057cf76632d8a39065'
  is: 0
  says: signer 0 has sent 0 transactions
  for:
  - notes
- id: nonce-1
  nonce: '0xed90af46e440f83fff0a9270c6e09402a2a92e6c'
  is: 0
  says: signer 1 has sent 0 transactions
  for:
  - notes
- id: nonce-2
  nonce: '0xfbe8233b91234e8ee5a5e6a793d81cc9505f08d6'
  is: 0
  says: signer 2 has sent 0 transactions
  for:
  - notes
- id: nonce-3
  nonce: '0x7e9445753f67662d49d78d8beb37951b51cec080'
  is: 0
  says: signer 3 has sent 0 transactions
  for:
  - notes
- id: nonce-4
  nonce: '0x21fa44ac18448b6f4fda577579f02e597a436929'
  is: 4
  says: signer 4 has sent 4 transactions
  for:
  - notes
- id: n-senders
  storage: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  slot: 1
  is: 11
  says: the sender list holds eleven entries
  for:
  - notes
- id: seq-5
  storage: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  slot: 5
  is: 1
  says: sequence id 1 is used
  for:
  - notes
- id: seq-6
  storage: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  slot: 6
  is: 2
  says: sequence id 2 is used
  for:
  - notes
- id: seq-7
  storage: '0x2cc81b80a293408a89084c77a0983de0730f731a'
  slot: 7
  is: 3
  says: sequence id 3 is used
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules; active ones replayed on real transactions)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: HIGH
reviews:
- who: r-2cc81b80, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: INFORMATIONAL
  note: 'moved: An unverified wallet that moves ETH and tokens only with ECDSA signatures of three of its five signers;
    no function changes the signers or the number; it holds 26,588 ETH; 30 more addresses run this code and were
    not read. INFORMATIONAL, PQ-17, candidate (bytecode evidence; was HIGH): nothing breaks unless three signers
    move their accounts to real code, and the funds can be moved first. Moved from custody-wallets-fixed-signers
    to wallets-fixed-signers: whose money the wallet holds cannot be shown, so ''custody'' is not established. Author
    A-2cc81b80; refuter R-2cc81b80 agreed with no objection; the reader changed nothing. Not tested: a sender''s
    tight gas limit, since no replay exists for this contract.'
related: []
---

## What happens

This wallet moves ETH and tokens only with ECDSA signatures of three of its five signers, and no function changes the signers or that number. If three signers move their accounts to real code, the 26,588 ETH it holds stays locked; an EIP-7702 delegation keeps working.

## Evidence

- The [contract's code](https://etherscan.io/address/0x2cc81b80a293408a89084c77a0983de0730f731a#code) recovers three ECDSA signatures per send and requires three different stored signers.
- Of its nine [functions](https://etherscan.io/address/0x2cc81b80a293408a89084c77a0983de0730f731a#code), two send funds on signatures; none changes the signer list or the number required.
- It still takes deposits ([2,590 ETH](https://etherscan.io/tx/0x0ea1a66a9efdf88e1a38c124946c989f77ea33dc576bc232587ad4bef51dbb37)), and none of its five signers has real code yet.

## Reviewer notes

### Mechanism

Unverified; read from the disassembly (offsets are program counters). No DELEGATECALL, CREATE or SELFDESTRUCT; nine functions. The two sends (0x97f6c448 ETH, 0x98f44b9a ERC-20) require isSender(msg.sender) (0x0bca, array in slot 1: 11 entries, the same five signers repeated), then run the verifier at 0x0c6d: in safe mode (slot 4) the destination must be a signer; expireTime >= now; the sequence id goes into slots 5-14 (at most 10,000 above the lowest); signatures.length must equal slot 3 (3) x 65; for each 65-byte chunk the routine at 0x10a4 fixes v, calls precompile 0x01 with all remaining gas (GAS CALL at 0x114b) and reads the output word zeroed before the call; the address must pass isSigner (0x0519, array in slot 0: 5 entries) and not repeat (0x1171). Then ETH leaves by transfer (2,300-gas stipend) to the signed destination, or the token's transfer(address,uint256) is called. Under EIP-8151 a signer whose account has real code recovers nothing, the zeroed word reads as address 0, isSigner fails and the send reverts; with three of five so migrated no send can pass. The only SSTOREs are at 0x05ea (safe-mode flag, set to one, never cleared) and 0x109e (sequence ids): nothing writes slots 0, 1 or 3. The fallback accepts ETH and logs deposits.

### Checks

- Header facts: this address alone, at block 26,438,999; 31 addresses run this code.
- Ruled out: an ERC-1271 or code-size path for signers: the code makes three calls only (ETH transfer 0x07fb, token transfer 0x0f81, recovery 0x114b); none asks a signer.
- Ruled out: a fixed gas amount: the recovery forwards all remaining gas, so nothing here breaks on activation by its own budget. The dossier holds no replay of this family and no traced recovery, so a sender's tight gas limit on a send was not tested.
- Ruled out: a setter or upgrade: two SSTOREs only (safe-mode flag, sequence ids), no DELEGATECALL, EIP-1967 slot empty.
- Ruled out: a direct path: a sender's call without three valid signatures reverts; the fallback only takes deposits.
- Ruled out: an unused address: it holds 26,588.05 ETH, took a 2,590 ETH deposit at block 26,404,393, and sequence ids 1, 2 and 3 are used (slots 5-7).
- Ruled out: the two other calls in the dossier (0x87fca027... initialize(address), 0x70c7ba2b... withdraw(address)) name functions this code lacks: they reached the fallback, emitted nothing and changed nothing.
- Ruled out: copies: 30 other addresses run this code; the dossier names none, and their state was not read.
- Ruled out: a signer with code today: all five signer accounts are empty; four have nonce 0 and are presumed live, the fifth (0x21fa...6929) has nonce 4.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
