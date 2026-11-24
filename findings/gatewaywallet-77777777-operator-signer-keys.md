---
id: gatewaywallet-77777777-operator-signer-keys
format: 2
title: One forged batch-signer key can move depositors' USDC in Circle's Gateway
status: confirmed
severity: MEDIUM
justification: One forged key moves depositors' balances; the owner can upgrade the wallet to another signature
  scheme.
category: quantum-exposure
pattern: PQ-4
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  name: GatewayWallet
  code: verified
  code_url: https://etherscan.io/address/0xf7a6d9d7df917c072ac8987a820c58aa27a0e798#code
  proxy_of: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  copies: 1
  upgradeable: 'yes'
  admin: '0x2a6a86466f181721ec8ff946967b56f1aa4758c5'
value:
  usd: 56780896
  whose: users
  basis: held
activity:
  txs_90d: 10918
impact: funds-loss
action: Upgrade submitBatch to check a post-quantum signature; replacing a batch signer with another ECDSA key does
  not help.
evidence_level: source
checks:
- id: burn-recover
  source: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  file: src/modules/wallet/Burns.sol
  lines:
  - 254
  - 256
  has: address recoveredSigner = ECDSA.recover(keccak256(calldataBytes).toEthSignedMessageHash(), signature); if
    (!isBurnSigner(recoveredSigner)) { revert InvalidBurnSigner();
  says: gatewayBurn needs a registered burn signer's ECDSA signature on the whole calldata
  for:
  - notes
- id: burn-signer
  call: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  fn: isBurnSigner(address)(bool)
  args:
  - '0xb72f2bb8ad7adb4e40e3acd8f34160b4991e7ade'
  is: true
  says: the address recovered in every gatewayBurn of the window is a registered burn signer
  for:
  - notes
- id: burn-signer-eoa
  code: '0xb72f2bb8ad7adb4e40e3acd8f34160b4991e7ade'
  is: empty
  says: the burn signer is a key with no code
  for:
  - notes
- id: burn-signer-nonce
  nonce: '0xb72f2bb8ad7adb4e40e3acd8f34160b4991e7ade'
  is: 0
  says: the burn signer never sent a transaction; it only signs burns
  for:
  - notes
- id: intent-ecdsa
  source: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  file: src/modules/wallet/Burns.sol
  lines:
  - 326
  - 333
  has: if (recoveredSigner == sourceSigner) { return sourceSigner;
  says: each burn intent is first recovered with ECDSA and accepted if it recovers the intent's source signer
  for:
  - notes
- id: tee-vouch
  source: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  file: src/modules/wallet/Burns.sol
  lines:
  - 338
  - 339
  has: if (isContractSignatureSigner(recoveredSigner)) { return sourceSigner;
  says: a registered TEE key's ECDSA signature stands in for any source signer
  for:
  - notes
- id: erc1271-allowlisted
  source: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  file: src/modules/wallet/Burns.sol
  lines:
  - 344
  - 345
  has: if (_wasEverAllowlistedContractSigner(sourceSigner)) { if (!SignatureChecker.isValidERC1271SignatureNow(sourceSigner,
    digest, signature)) {
  says: ERC-1271 is asked only of source signers that were ever allowlisted
  for:
  - notes
- id: ever-authorized
  source: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  file: src/modules/wallet/Burns.sol
  line: 491
  has: if (!_wasEverAuthorizedForBalance(sourceToken, sourceDepositor, signer)) {
  says: the source signer must be the depositor or a delegate it ever authorized
  for:
  - notes
- id: burn-destroys
  source: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  file: src/modules/wallet/Burns.sol
  lines:
  - 411
  - 414
  has: IBurnableToken(token).burn(totalDeductedAmount - totalFee);
  says: a burn sends the fee to the fee recipient and destroys the rest of the debited USDC
  for:
  - notes
- id: batch-recover
  source: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  file: src/modules/wallet/Batches.sol
  lines:
  - 165
  - 167
  has: if (!isBatchSigner(recoveredSigner)) { revert InvalidBatchSigner();
  says: submitBatch needs only a registered batch signer's ECDSA signature
  for:
  - action
  - evidence-1
  - justification
  - what
- id: batch-credit
  source: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  file: src/modules/wallet/Batches.sol
  line: 209
  has: Balances._increaseAvailableBalance(tokenAddress, delta.depositor, uint256(delta.value));
  says: a positive delta credits any depositor's available balance
  for:
  - evidence-1
  - justification
  - what
- id: batch-debit
  source: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  file: src/modules/wallet/Batches.sol
  lines:
  - 219
  - 220
  has: _reduceBalance(tokenAddress, delta.depositor, amountToDeduct);
  says: a negative delta debits any depositor's balance
  for:
  - evidence-1
  - justification
  - what
- id: batch-add
  source: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  file: src/modules/wallet/Batches.sol
  line: 92
  has: function addBatchSigner(address signer) public onlyOwner {
  says: the owner registers batch signers
  for:
  - action
- id: tee-add
  source: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  file: src/modules/wallet/ContractSignatureSigners.sol
  line: 59
  has: function addContractSignatureSigner(address signer) public onlyOwner {
  says: the owner registers TEE signers
  for:
  - notes
- id: burn-not-batch
  call: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  fn: isBatchSigner(address)(bool)
  args:
  - '0xb72f2bb8ad7adb4e40e3acd8f34160b4991e7ade'
  is: false
  says: the burn signer is not a batch signer
  for:
  - notes
- id: burn-not-tee
  call: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  fn: isContractSignatureSigner(address)(bool)
  args:
  - '0xb72f2bb8ad7adb4e40e3acd8f34160b4991e7ade'
  is: false
  says: the burn signer is not a TEE signer
  for:
  - notes
- id: owner-not-batch
  call: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  fn: isBatchSigner(address)(bool)
  args:
  - '0x2a6a86466f181721ec8ff946967b56f1aa4758c5'
  is: false
  says: the owner is not a batch signer
  for:
  - notes
- id: intent-signer-not-tee
  call: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  fn: isContractSignatureSigner(address)(bool)
  args:
  - '0xd20a6c9f716532f01cd6b3dc926353de5c93a990'
  is: false
  says: the most frequent intent signer of the window is not a TEE signer, so it signed as a depositor or delegate
  for:
  - notes
- id: init-version
  storage: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  slot: '0xf0c57e16840df040f15088dc2f81fe391c3923bec73e23a9662efc9c229c6a00'
  is: 2
  says: the proxy was initialized up to version 2
  for:
  - notes
- id: impl
  storage: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  says: the proxy runs the GatewayWallet implementation read here
  for:
  - notes
- id: owner
  call: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  fn: owner()(address)
  is: '0x2a6a86466f181721ec8ff946967b56f1aa4758c5'
  says: the owner that registers signers and upgrades
  for:
  - action
  - evidence-3
  - justification
- id: owner-eoa
  code: '0x2a6a86466f181721ec8ff946967b56f1aa4758c5'
  is: empty
  says: the owner is a key with no code
  for:
  - evidence-3
- id: owner-live
  nonce: '0x2a6a86466f181721ec8ff946967b56f1aa4758c5'
  min: 15
  says: the owner has sent transactions
  for:
  - evidence-3
- id: upgrade
  source: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  file: src/GatewayCommon.sol
  line: 88
  has: function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}
  says: the owner can upgrade the implementation
  for:
  - action
  - evidence-3
  - justification
- id: withdraw
  source: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  file: src/modules/wallet/Withdrawals.sol
  lines:
  - 104
  - 113
  has: IERC20(token).safeTransfer(msg.sender, balanceToWithdraw);
  says: a depositor withdraws its own balance by a direct call, without a signature
  for:
  - evidence-3
  - what
  - whose
- id: delay
  call: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  fn: withdrawalDelay()(uint256)
  is: 50400
  says: a withdrawal completes 50,400 blocks after it starts
  for:
  - evidence-3
- id: not-paused
  call: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  fn: paused()(bool)
  is: false
  says: the wallet is not paused
  for:
  - evidence-3
- id: usdc
  call: '0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48'
  fn: balanceOf(address)(uint256)
  args:
  - '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  is: 56795280656610
  says: the wallet holds 56,795,280.66 USDC of depositors' balances
  for:
  - what
  - whose
- id: signers-added
  logs: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  topic: '0xceb230c3aed7aaaf620d28e444845b73c1083c4011d91d07e0cf321ef07b8016'
  from: 22960000
  count: 4
  says: BatchSignerAdded was emitted four times since the wallet was deployed
  for:
  - evidence-2
  - what
- id: signers-removed
  logs: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  topic: '0x0d46aa3c36e0d3ca3d9255a77e39f993dc0513a8aecf73b2f4d14f995ec05e46'
  from: 22960000
  count: 0
  says: BatchSignerRemoved was never emitted
  for:
  - evidence-2
  - what
- id: batches
  logs: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  topic: '0x8e9878875610f80a970e0cea1889a4c7de3012c1a52ae169d9d5d3ab2c08b670'
  from: 24920000
  count: 9
  says: nine batches were processed since the first batch signer was added
  for:
  - evidence-2
  - what
- id: last-batch
  tx: '0xe59f70bc75db9894ca62e7d70360894f19cbf6c97d86a402a7a2a807f02e1c4e'
  to: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  ok: true
  says: the latest submitBatch, at block 26,307,106, succeeded
  for:
  - evidence-2
- id: net-zero
  source: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  file: src/modules/wallet/Batches.sol
  line: 198
  has: The deltas must net to 0 by the end
  says: 'a batch only moves balances between depositors: its deltas must net to zero'
  for:
  - evidence-1
  - what
- id: deposit
  source: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  file: src/modules/wallet/Deposits.sol
  line: 61
  has: function deposit(address token, uint256 value)
  says: anyone deposits a supported token and is credited a balance
  for:
  - what
  - whose
- id: start-withdraw
  source: '0xf7a6d9d7df917c072ac8987a820c58aa27a0e798'
  file: src/modules/wallet/Withdrawals.sol
  line: 76
  has: function initiateWithdrawal(address token, uint256 value) external whenNotPaused tokenSupported(token) {
  says: a withdrawal is started by the balance's holder and can be stopped by pausing
  for:
  - evidence-3
- id: batch-signer-1
  call: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  fn: isBatchSigner(address)(bool)
  args:
  - '0x88637017175a63f5c684291166091e7a351bcff3'
  is: true
  says: 0x88637017… is a batch signer at the block
  for:
  - evidence-2
  - what
- id: batch-signer-1-code
  code: '0x88637017175a63f5c684291166091e7a351bcff3'
  is: empty
  says: '0x88637017… has no code: an ECDSA key'
  for:
  - evidence-2
  - what
- id: batch-signer-1-signed
  logs: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  topic: '0x8e9878875610f80a970e0cea1889a4c7de3012c1a52ae169d9d5d3ab2c08b670'
  from: 24920000
  has: '0x88637017175a63f5c684291166091e7a351bcff3'
  min: 1
  says: 0x88637017… signed at least one processed batch, so its signature is on-chain
  for:
  - evidence-2
  - what
- id: batch-signer-2
  call: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  fn: isBatchSigner(address)(bool)
  args:
  - '0x526f069e4f878d1092804c86befe9bcc5c8d5420'
  is: true
  says: 0x526f069e… is a batch signer at the block
  for:
  - evidence-2
  - what
- id: batch-signer-2-code
  code: '0x526f069e4f878d1092804c86befe9bcc5c8d5420'
  is: empty
  says: '0x526f069e… has no code: an ECDSA key'
  for:
  - evidence-2
  - what
- id: batch-signer-2-signed
  logs: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  topic: '0x8e9878875610f80a970e0cea1889a4c7de3012c1a52ae169d9d5d3ab2c08b670'
  from: 24920000
  has: '0x526f069e4f878d1092804c86befe9bcc5c8d5420'
  min: 1
  says: 0x526f069e… signed at least one processed batch, so its signature is on-chain
  for:
  - evidence-2
  - what
- id: batch-signer-3
  call: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  fn: isBatchSigner(address)(bool)
  args:
  - '0x7e7815ed4f6160e12625c9c74960de5a634182eb'
  is: true
  says: 0x7e7815ed… is a batch signer at the block
  for:
  - evidence-2
  - what
- id: batch-signer-3-code
  code: '0x7e7815ed4f6160e12625c9c74960de5a634182eb'
  is: empty
  says: '0x7e7815ed… has no code: an ECDSA key'
  for:
  - evidence-2
  - what
- id: batch-signer-3-signed
  logs: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  topic: '0x8e9878875610f80a970e0cea1889a4c7de3012c1a52ae169d9d5d3ab2c08b670'
  from: 24920000
  has: '0x7e7815ed4f6160e12625c9c74960de5a634182eb'
  min: 1
  says: 0x7e7815ed… signed at least one processed batch, so its signature is on-chain
  for:
  - evidence-2
  - what
- id: batch-signer-4
  call: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  fn: isBatchSigner(address)(bool)
  args:
  - '0xb045285ab7ed67858ac5980e2e01348195ec2fd1'
  is: true
  says: 0xb045285a… is a batch signer at the block
  for:
  - evidence-2
  - what
- id: batch-signer-4-code
  code: '0xb045285ab7ed67858ac5980e2e01348195ec2fd1'
  is: empty
  says: '0xb045285a… has no code: an ECDSA key'
  for:
  - evidence-2
  - what
- id: batch-signer-4-signed
  logs: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  topic: '0x8e9878875610f80a970e0cea1889a4c7de3012c1a52ae169d9d5d3ab2c08b670'
  from: 24920000
  has: '0xb045285ab7ed67858ac5980e2e01348195ec2fd1'
  min: 1
  says: 0xb045285a… signed at least one processed batch, so its signature is on-chain
  for:
  - evidence-2
  - what
- id: tee-signer-1
  call: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  fn: isContractSignatureSigner(address)(bool)
  args:
  - '0x7fd464ae631f779f6f71dd6ac54cbd8d9d75fa52'
  is: true
  says: 0x7fd464ae… is a registered TEE signer at the block
  for:
  - notes
- id: tee-signer-2
  call: '0x77777777dcc4d5a8b6e418fd04d8997ef11000ee'
  fn: isContractSignatureSigner(address)(bool)
  args:
  - '0xfd88e666f0fd61c42a747ce786d11e90795b0e7f'
  is: true
  says: 0xfd88e666… is a registered TEE signer at the block
  for:
  - notes
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review09 (finding review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; replayed on real transactions; not
    reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-77777777, the row's refuter
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row (also its author)
  date: 2026-11-22
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Circle''s GatewayWallet (an EIP-1967 proxy the owner can upgrade) holds 56.8M USDC of depositors''
    balances. MEDIUM, PQ-4: submitBatch moves balances between any depositors on one registered batch signer''s
    ECDSA signature; four batch signers are registered, none ever removed, all code-less, and each has signed a
    processed batch, so its public key is on-chain. Taking USDC out then needs the 50,400-block withdrawal delay,
    during which the operator can pause; the fix is an upgrade, since another ECDSA key does not help. The old finding
    named the burn signer, which alone debits nobody. Author A-77777777 stopped with a question that needed events;
    the reader read them (logreads/circle-gateway-signers.md) and wrote the card from the author''s checks (D-029:
    no second author). Refuter R-77777777 agreed with no objection on that card. Not claimed: the second path, a
    TEE signer''s key with the burn signer''s.'
related: []
---

## What happens

Circle's Gateway wallet holds 56.8M USDC that depositors keep there. submitBatch moves balances between any depositors on one batch signer's ECDSA signature. Four batch signers are registered, and each has signed a batch on-chain, so its public key is known.

## Evidence

- [submitBatch](https://etherscan.io/address/0xf7a6d9d7df917c072ac8987a820c58aa27a0e798#code) needs only a registered batch signer's ECDSA signature, then credits and debits any depositor's balance.
- Four batch signers are registered at the block, none with code; each signed a processed batch, the latest in [this transaction](https://etherscan.io/tx/0xe59f70bc75db9894ca62e7d70360894f19cbf6c97d86a402a7a2a807f02e1c4e).
- A balance leaves by [withdraw](https://etherscan.io/address/0xf7a6d9d7df917c072ac8987a820c58aa27a0e798#code) 50,400 blocks after the withdrawal starts; the [owner](https://etherscan.io/address/0x2a6a86466f181721ec8ff946967b56f1aa4758c5) can upgrade the wallet.

## Reviewer notes

### Mechanism

submitBatch (Batches.sol 119-240) recovers the signer of the batch calldata with ECDSA and requires it to be a registered batch signer (165-167). It then applies the batch's deltas: a positive one credits a depositor's available balance (209), a negative one debits a depositor's balance, the withdrawing part included (219-220); the deltas must net to zero (198, 237). No depositor signs anything. A forged batch signer's signature can therefore credit an attacker's own balance and debit the others'. The attacker then calls initiateWithdrawal (Withdrawals.sol 76) and withdraw (104-113), which pays out 50,400 blocks later, about a week; both carry whenNotPaused, so the operator can stop the payout in that week if it notices. Four batch signers are registered (BatchSignerAdded four times, never removed; isBatchSigner true for each at the block); none has code or has sent a transaction, and each appears as the signer of a BatchProcessed event (nine batches, the latest at block 26,307,106), so all four signatures, and with them the public keys, are on-chain. The owner, a code-less account that has sent transactions, registers signers (92) and authorizes upgrades (GatewayCommon.sol 88).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: the burn signer alone: gatewayBurn also needs, for each burn intent, the depositor's or an ever-authorized delegate's own ECDSA signature, a registered TEE signer's, or an ERC-1271 answer from an ever-allowlisted contract (Burns.sol 326-349, 491). The old finding named the burn signer; that key alone debits nobody.
- Ruled out: a second path, not this card's claim: two TEE signers are registered at the block (0x7fd464ae…, 0xfd88e666…), and a TEE signer's signature stands in for any source signer, so a TEE key together with the burn signer's key burns any depositor's balance. That needs two keys and destroys the USDC rather than taking it.
- Ruled out: ERC-1271 or another scheme for batch signers: _verifyBatchSignerSignature only recovers with ECDSA (Batches.sol 165-167).
- Ruled out: rotation as a fix: addBatchSigner registers another address checked the same way.
- Ruled out: an immediate exit: a batch only moves balances inside the wallet; taking USDC out needs the withdrawal delay, or a burn, which needs the burn signer's key as well.
- Ruled out: unused or paused: paused() is false at the block, 10,918 transactions called the wallet in the 90 days before, and the latest batch is from block 26,307,106.
- Ruled out: depositor intents tried with ECDSA before ERC-1271 (Burns.sol 326-349): another root issue, not filed here.
- Ruled out: Written by the main reviewer from the author's checks and the event read the author asked for; the author's own verdict was a question.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
