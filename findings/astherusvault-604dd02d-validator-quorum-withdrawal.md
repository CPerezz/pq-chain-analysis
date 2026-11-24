---
id: astherusvault-604dd02d-validator-quorum-withdrawal
format: 2
title: Aster vault withdrawals rest on ECDSA validator and operator keys
status: confirmed
severity: MEDIUM
justification: Fixable only by a vault upgrade that a 4-of-7 Safe schedules through a one-day timelock.
category: quantum-exposure
pattern: PQ-5
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x604dd02d620633ae427888d41bfd15e38483736e'
  name: AstherusVault
  project: aster
  code: verified
  code_url: https://etherscan.io/address/0x2cc878ac49c3bf8b0f2b053af7845ba6590eec4f#code
  proxy_of: '0x2cc878ac49c3bf8b0f2b053af7845ba6590eec4f'
  copies: 1
  upgradeable: 'yes'
value:
  usd: 182970758
  whose: users
  basis: held
activity: {}
impact: funds-loss
action: Upgrade the vault through the timelock to accept post-quantum signatures instead of the validator, business
  and ledger ECDSA keys.
evidence_level: source
checks:
- id: recover
  source: '0x2cc878ac49c3bf8b0f2b053af7845ba6590eec4f'
  file: contracts/AstherusVault.sol
  line: 434
  has: address recover = validatorDigest.recover(validatorSignatures[i]);
  says: each validator signature is recovered with ECDSA
  for:
  - evidence-1
  - what
- id: quorum
  source: '0x2cc878ac49c3bf8b0f2b053af7845ba6590eec4f'
  file: contracts/AstherusVault.sol
  line: 447
  has: require(power >= totalPower * 2 / 3, "validator signature illegal");
  says: the matched signers must hold two thirds of the set's power
  for:
  - evidence-1
  - what
- id: operate
  source: '0x2cc878ac49c3bf8b0f2b053af7845ba6590eec4f'
  file: contracts/AstherusVault.sol
  line: 328
  has: whenNotPaused onlyRole(OPERATE_ROLE)
  says: the quorum withdrawal is callable only by an operator while not paused
  for:
  - evidence-2
  - what
- id: p2
  source: '0x2cc878ac49c3bf8b0f2b053af7845ba6590eec4f'
  file: contracts/AstherusVault.sol
  line: 381
  has: WITHDRAW_VALIDATOR.withdrawCheck(userRequestInfo, businessInfo, signatureInfo);
  says: the second withdrawal is approved by the external withdraw validator
  for:
  - evidence-2
  - what
- id: imm
  source: '0x2cc878ac49c3bf8b0f2b053af7845ba6590eec4f'
  file: contracts/AstherusVault.sol
  line: 84
  has: IAsterWithdrawValidator public immutable WITHDRAW_VALIDATOR;
  says: the withdraw validator is fixed in the implementation
  for:
  - action
  - evidence-2
- id: transfer
  source: '0x2cc878ac49c3bf8b0f2b053af7845ba6590eec4f'
  file: contracts/AstherusVault.sol
  line: 345
  has: _transfer(action.receiver, action.token, action.amount, action.fee);
  says: a valid quorum withdrawal sends the tokens to the signed receiver
  for:
  - what
- id: limit
  source: '0x2cc878ac49c3bf8b0f2b053af7845ba6590eec4f'
  file: contracts/AstherusVault.sol
  lines:
  - 454
  - 455
  has: _pause();
  says: a withdrawal above the hourly USD limit pauses the vault
  for:
  - what
- id: hourly
  call: '0x604dd02d620633ae427888d41bfd15e38483736e'
  fn: hourlyLimit()(uint256)
  is: '600000000000000'
  says: the hourly limit is $6M (8 decimals)
  for:
  - what
- id: notpaused
  call: '0x604dd02d620633ae427888d41bfd15e38483736e'
  fn: paused()(bool)
  is: 'false'
  says: the vault is not paused
  for:
  - evidence-2
- id: op-count
  call: '0x604dd02d620633ae427888d41bfd15e38483736e'
  fn: getRoleMemberCount(bytes32)(uint256)
  args:
  - '0x26dad9aff0b7a25cb40eba58d2c80f6e8234130942d17bd1ec8f5ad95a48c78e'
  is: '6'
  says: six accounts hold OPERATE_ROLE
  for:
  - evidence-2
- id: upgrade
  source: '0x2cc878ac49c3bf8b0f2b053af7845ba6590eec4f'
  file: contracts/AstherusVault.sol
  line: 148
  has: function _authorizeUpgrade(address newImplementation) internal onlyTimeLock override {}
  says: only the timelock can upgrade the vault
  for:
  - action
  - evidence-3
  - justification
- id: tl
  call: '0x604dd02d620633ae427888d41bfd15e38483736e'
  fn: TIMELOCK_ADDRESS()(address)
  is: '0x20F4E8cBf7C0062464E1496164B6847112ec41BF'
  says: the timelock address
  for:
  - evidence-3
- id: tl-delay
  call: '0x20f4e8cbf7c0062464e1496164b6847112ec41bf'
  fn: getMinDelay()(uint256)
  is: '86400'
  says: the timelock delay is one day
  for:
  - evidence-3
  - justification
- id: tl-proposer
  call: '0x20f4e8cbf7c0062464e1496164b6847112ec41bf'
  fn: hasRole(bytes32,address)(bool)
  args:
  - '0xb09aa5aeb3702cfd50b6b62bc4532604938f21248a27a1d5ca736082b6819cc1'
  - '0x1FE3Fe2Ddd19AB58B0c56054a5AF217Afb27eCEA'
  is: 'true'
  says: the Safe can propose timelock operations
  for:
  - action
  - evidence-3
  - justification
- id: safe-threshold
  call: '0x1fe3fe2ddd19ab58b0c56054a5af217afb27ecea'
  fn: getThreshold()(uint256)
  is: '4'
  says: the Safe needs four of its owners
  for:
  - evidence-3
  - justification
- id: deposit
  source: '0x2cc878ac49c3bf8b0f2b053af7845ba6590eec4f'
  file: contracts/AstherusVault.sol
  line: 294
  has: emit Deposit(msg.sender, currency, false, erc20.balanceOf(address(this)) - before, broker);
  says: the tokens held are users' deposits credited to them
  for:
  - whose
- id: vset
  logs: '0x604dd02d620633ae427888d41bfd15e38483736e'
  topic: '0x8dab9a2a283c7b6ba069309ca8068fffe547519cf6029bad20d31ce4ac81d210'
  from: 20067877
  to: 26438999
  count: 1
  has: 5b27f4b3a264145f4decbca5cf5b3a407ed230172d38a35b7be691035815a528
  says: one validator set was ever added
  for:
  - what
- id: vset-power
  call: '0x604dd02d620633ae427888d41bfd15e38483736e'
  fn: availableValidators(bytes32)(uint256)
  args:
  - '0x5b27f4b3a264145f4decbca5cf5b3a407ed230172d38a35b7be691035815a528'
  is: '90'
  says: that set is registered with total power 90
  for:
  - what
- id: v-ecrec
  bytecode: '0x1006511304aada32ea80a259dcf140a6ecbd30dc'
  has: 60019060a0016020604051602081039080840390855afa
  says: the withdraw validator calls the ecrecover precompile
  for:
  - what
- id: v-biz
  call: '0x1006511304aada32ea80a259dcf140a6ecbd30dc'
  fn: BUSINESS_SIGNER()(address)
  is: '0x71c91e0cfF08242739EBc4411f36deb400523bD0'
  says: the business signer
  for:
  - what
- id: v-ledger
  call: '0x1006511304aada32ea80a259dcf140a6ecbd30dc'
  fn: LEDGER_SIGNER()(address)
  is: '0xA35eB116Bd85F05C56bFD7d62945B394Ad744fbB'
  says: the ledger signer
  for:
  - what
- id: v-biz-const
  bytecode: '0x1006511304aada32ea80a259dcf140a6ecbd30dc'
  has: 71c91e0cff08242739ebc4411f36deb400523bd0
  says: the business signer is a constant in the code
  for:
  - what
- id: v-ledger-const
  bytecode: '0x1006511304aada32ea80a259dcf140a6ecbd30dc'
  has: a35eb116bd85f05c56bfd7d62945b394ad744fbb
  says: the ledger signer is a constant in the code
  for:
  - what
- id: v-biz-eoa
  code: '0x71c91e0cff08242739ebc4411f36deb400523bd0'
  is: empty
  says: the business signer has no code
  for:
  - notes
- id: v-ledger-eoa
  code: '0xa35eb116bd85f05c56bfd7d62945b394ad744fbb'
  is: empty
  says: the ledger signer has no code
  for:
  - notes
- id: v-no1271
  bytecode: '0x1006511304aada32ea80a259dcf140a6ecbd30dc'
  has: 1626ba7e
  absent: true
  says: the withdraw validator has no ERC-1271 call
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
  who: Review10 (source and on-chain review)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
- study: eip-8151-impact
  who: Claude (study families read, judged from bytecode or placed by rules; not reviewed by a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
  rating: LOW
reviews:
- who: r-604dd02d, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-5): Aster''s vault (about $183M) pays withdrawals on ECDSA
    signatures from two thirds of its one registered validator set (3 validators, power 90, all also operators;
    Claude''s log read), or through the immutable withdraw validator''s two fixed ECDSA keys; draws within the $6M
    hourly budget pay out; only a vault upgrade (4-of-7 Safe through a one-day timelock) fixes both paths. Two refuters
    agree; Claude read the sheet.'
related: []
---

## What happens

Aster's vault pays out when an operator submits a withdrawal signed by two thirds of its one validator set's power, or approved by a fixed withdraw validator. Forged validator keys, or the withdraw validator's two fixed ECDSA keys, plus one operator key drain it in draws under an hourly limit.

## Evidence

- [verifyValidatorSignature](https://etherscan.io/address/0x2cc878ac49c3bf8b0f2b053af7845ba6590eec4f#code) recovers each signature with ECDSA and requires two thirds of the set's power.
- [withdraw](https://etherscan.io/address/0x2cc878ac49c3bf8b0f2b053af7845ba6590eec4f#code) is open to six operators and is not paused; the second withdraw asks an immutable validator contract.
- [_authorizeUpgrade](https://etherscan.io/address/0x2cc878ac49c3bf8b0f2b053af7845ba6590eec4f#code) accepts only the timelock, whose proposer is a 4-of-7 Safe with a one-day delay.

## Reviewer notes

### Mechanism

withdraw(id, validators, action, validatorSignatures) (onlyRole OPERATE_ROLE, lines 328-348) builds a digest of id, chain id, vault, token, amount, fee and receiver; verifyValidatorSignature (lines 426-448) looks up the total power of the set by keccak256(abi.encode(validators)) in availableValidators, recovers each signature over the EIP-191 hash with OpenZeppelin ECDSA, matches it against the ordered signer list and requires power >= 2/3 of the total. Sets are added and removed by ADMIN_ROLE (lines 157-176), held by Safe 0x1fe3...ceea (4 of 7). The second withdraw (lines 358-389) calls the immutable WITHDRAW_VALIDATOR 0x10065113...30dc withdrawCheck; its runtime code holds BUSINESS_SIGNER 0x71c9...3bd0 and LEDGER_SIGNER 0xa35e...4fbb as constants (accounts with no code) and calls the ecrecover precompile. Both paths pass checkLimit (lines 450-458): a withdrawal pauses the vault only when the hour's total would exceed hourlyLimit ($6M), so draws under the limit repeat each hour until a pauser acts. One validator set (3 validators, power 90) was ever added (one ValidatorAdd log, none removed).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: an ERC-1271 or code-size branch for validators: verifyValidatorSignature has none (lines 426-448).
- Ruled out: unused implementation: the address is the proxy itself, initialized, with ADMIN_ROLE held by the Safe and the vault holding the value the tool read.
- Ruled out: a direct withdrawal without signatures: the only other exits are withdrawFee (accrued fees only, ADMIN_ROLE, lines 178-191) and an upgrade.
- Ruled out: OPERATE_ROLE has six members at the block, not five as the old card said: five accounts without code and the Safe.
- Ruled out: an ERC-1271 path for the withdraw validator's business and ledger keys: its code has no isValidSignature selector, and both keys are accounts without code; its only other external check is a Safe checkSignatures call (selector 934f3a11).

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
