---
id: ecdsadkgvalidator-1a5f4f75-signature-rechecked
format: 2
title: tBTC wallet results fail approval if a signer gets real code
status: confirmed
severity: LOW
justification: An honest result is rejected once a signer has real code; an upgrade can fix it.
category: voided-by-migration
pattern: PQ-15
study: eip-8151-impact
as_of: 2026-11-18
block: 26438999
contract:
  address: '0x1a5f4f753bd071c907714aefb6e0bcee32401406'
  name: EcdsaDkgValidator
  code: verified
  code_url: https://etherscan.io/address/0x1a5f4f753bd071c907714aefb6e0bcee32401406#code
  copies: 3
  family: c7877dc4855722a5f03bf4c0c064af61
  upgradeable: 'no'
value:
  usd: 0
  whose: operator
  basis: held
activity: {}
impact: liveness
action: Upgrade the registry to check result signatures once, at submission, and not again at challenge or approval.
evidence_level: source
checks:
- id: recover
  source: '0x1a5f4f753bd071c907714aefb6e0bcee32401406'
  file: contracts/EcdsaDkgValidator.sol
  lines:
  - 289
  - 290
  has: .tryRecover(current);
  says: each DKG result signature is recovered with ECDSA
  for:
  - evidence-1
  - justification
  - what
- id: compare
  source: '0x1a5f4f753bd071c907714aefb6e0bcee32401406'
  file: contracts/EcdsaDkgValidator.sol
  lines:
  - 292
  - 297
  has: signingMemberAddresses[i] != recoveredAddress
  says: a signature whose recovered address is not the selected operator's fails the whole result, with no other
    path
  for:
  - evidence-1
  - justification
  - what
- id: operators
  source: '0x1a5f4f753bd071c907714aefb6e0bcee32401406'
  file: contracts/EcdsaDkgValidator.sol
  line: 271
  has: address[] memory signingMemberAddresses = sortitionPool.getIDOperators(
  says: the expected signers are the operator addresses of the selected group members
  for:
  - what
- id: zero
  source: '0x1a5f4f753bd071c907714aefb6e0bcee32401406'
  file: '@openzeppelin/contracts/utils/cryptography/ECDSA.sol'
  lines:
  - 139
  - 140
  has: if (signer == address(0)) {
  says: an empty recovery is reported as an error, so the result fails
  for:
  - evidence-1
  - what
- id: inuse
  storage: '0x46d52e41c2f300bc82217ce22b920c34995204eb'
  slot: '0x98'
  is: '0x0000000000000000000000001a5f4f753bd071c907714aefb6e0bcee32401406'
  says: the tBTC wallet registry's DKG validator slot holds this address at the block
  for:
  - evidence-2
  - what
- id: oldval
  storage: '0x46d52e41c2f300bc82217ce22b920c34995204eb'
  slot: '0x98'
  at: 26409793
  is: '0x0000000000000000000000000125c8977a02b2fa3970b1ed9af02f5bedd4ef27'
  says: before the governance batch the validator slot held the older copy 0x0125c897
  for:
  - notes
- id: slotdoc
  source: '0x14fad0c11c83ac736e5929d5661bba7e6bb9c0d6'
  file: contracts/WalletRegistry.sol
  line: 482
  has: On an upgraded proxy slot 152 already holds the
  says: the registry implementation's source names slot 152 as its DKG validator
  for:
  - what
- id: impl
  storage: '0x46d52e41c2f300bc82217ce22b920c34995204eb'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x00000000000000000000000014fad0c11c83ac736e5929d5661bba7e6bb9c0d6'
  says: the registry proxy runs the verified implementation cited here
  for:
  - notes
- id: subhash
  source: '0x14fad0c11c83ac736e5929d5661bba7e6bb9c0d6'
  file: contracts/libraries/EcdsaDkg.sol
  lines:
  - 245
  - 271
  has: self.submittedResultHash = keccak256(abi.encode(result));
  says: submission checks the submitter and stores only the result's hash; it does not check signatures
  for:
  - action
- id: approve
  source: '0x14fad0c11c83ac736e5929d5661bba7e6bb9c0d6'
  file: contracts/libraries/EcdsaDkg.sol
  lines:
  - 372
  - 375
  has: (bool isValid, string memory errorMsg) = isResultValid(self, result);
  says: approval checks the stored result with the validator again and rejects it when it fails
  for:
  - action
  - evidence-2
  - justification
  - what
- id: reject
  source: '0x14fad0c11c83ac736e5929d5661bba7e6bb9c0d6'
  file: contracts/libraries/EcdsaDkg.sol
  lines:
  - 321
  - 332
  has: submittedResultCleanup(self);
  says: a rejection at approval clears the result and restarts the submission stage
  for:
  - evidence-2
  - what
- id: challenge
  source: '0x14fad0c11c83ac736e5929d5661bba7e6bb9c0d6'
  file: contracts/libraries/EcdsaDkg.sol
  lines:
  - 440
  - 450
  has: self.dkgValidator.validate(result, self.seed, self.startBlock)
  says: a challenge succeeds when the validator says the result is invalid
  for:
  - action
  - what
- id: puna
  source: '0x14fad0c11c83ac736e5929d5661bba7e6bb9c0d6'
  file: contracts/WalletRegistry.sol
  lines:
  - 947
  - 958
  has: _punishMaliciousDkgResultSubmitter(
  says: a rejected result punishes the submitter and returns before the refund
  for:
  - evidence-2
  - what
- id: refundline
  source: '0x14fad0c11c83ac736e5929d5661bba7e6bb9c0d6'
  file: contracts/WalletRegistry.sol
  lines:
  - 979
  - 987
  has: reimbursementPool.refund(
  says: a successful approval always ends with a refund call to the pool
  for:
  - what
- id: noauth
  call: '0x8adf3f35dbe4026112bcfc078872bcb967732ea8'
  fn: isAuthorized(address)(bool)
  args:
  - '0x46d52e41c2f300bc82217ce22b920c34995204eb'
  is: 'false'
  says: the refund pool does not authorize the wallet registry at the block
  for:
  - justification
  - what
- id: refundrev
  call: '0x8adf3f35dbe4026112bcfc078872bcb967732ea8'
  fn: refund(uint256,address)()
  args:
  - 100000
  - '0x049C418F942c21f5382727C6020A137675059922'
  from: '0x46d52e41c2f300bc82217ce22b920c34995204eb'
  reverts_with: Contract is not authorized for a refund
  says: a refund requested by the registry reverts at the block
  for:
  - what
- id: regpool
  call: '0x46d52e41c2f300bc82217ce22b920c34995204eb'
  fn: reimbursementPool()(address)
  is: '0x8adF3f35dBE4026112bCFc078872bcb967732Ea8'
  says: the registry's refund pool is 0x8adf3f35
  for:
  - notes
- id: poolowner
  call: '0x8adf3f35dbe4026112bcfc078872bcb967732ea8'
  fn: owner()(address)
  is: '0x9F6e831c8F8939DC0C830C6e492e7cEf4f9C2F5f'
  says: the refund pool is owned by the governance Safe 0x9f6e831c
  for:
  - what
- id: threshold
  call: '0x9f6e831c8f8939dc0c830c6e492e7cef4f9c2f5f'
  fn: getThreshold()(uint256)
  is: '6'
  says: the governance Safe needs 6 signatures
  for:
  - notes
- id: govtx
  tx: '0xdad127784152301e0be04a5d5bd40d676ab85f4a707331f0b82bd2323d9eab28'
  to: '0x9f6e831c8f8939dc0c830c6e492e7cef4f9c2f5f'
  ok: true
  says: the governance Safe's batch at block 26,409,794 succeeded
  for:
  - evidence-3
  - justification
  - what
- id: authlog
  logs: '0x8adf3f35dbe4026112bcfc078872bcb967732ea8'
  topic: '0x2c74592fddad593c2c4403101ce9b30930711ab87571268ddd1e1989ee1d7917'
  from: 26409794
  to: 26409794
  count: 1
  has: 46d52e41c2f300bc82217ce22b920c34995204eb
  says: in that block the pool authorized the registry (AuthorizedContract)
  for:
  - evidence-3
  - what
- id: approvedlog
  logs: '0x46d52e41c2f300bc82217ce22b920c34995204eb'
  topic: '0xe6e9d5eba171e82025efb3f3d44fd35905e7283d104284cb9f3bbc5bf1e4276f'
  from: 26409794
  to: 26409794
  count: 1
  has: 9f6e831c8f8939dc0c830c6e492e7cef4f9c2f5f
  says: in that block the governance Safe approved a DKG result (DkgResultApproved)
  for:
  - evidence-3
  - what
- id: unauthlog
  logs: '0x8adf3f35dbe4026112bcfc078872bcb967732ea8'
  topic: '0xe195aa139c7c69ba98f719c94aecd784e12fabc0789ef81335150078bc087317'
  from: 26409794
  to: 26409794
  count: 1
  has: 46d52e41c2f300bc82217ce22b920c34995204eb
  says: in that block the pool withdrew the registry's authorization (UnauthorizedContract)
  for:
  - evidence-3
  - what
- id: idle
  call: '0x46d52e41c2f300bc82217ce22b920c34995204eb'
  fn: getWalletCreationState()(uint8)
  is: '0'
  says: no wallet creation is in progress at the block (0 is IDLE)
  for:
  - notes
- id: idlenum
  source: '0x14fad0c11c83ac736e5929d5661bba7e6bb9c0d6'
  file: contracts/libraries/EcdsaDkg.sol
  line: 125
  has: IDLE,
  says: state 0 is IDLE
  for:
  - notes
- id: admin
  storage: '0x46d52e41c2f300bc82217ce22b920c34995204eb'
  slot: '0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103'
  is: '0x0000000000000000000000007affa05f726d293eb1193807a91617318292008e'
  says: the registry proxy's admin is the ProxyAdmin 0x7affa05f
  for:
  - action
  - justification
- id: paowner
  call: '0x7affa05f726d293eb1193807a91617318292008e'
  fn: owner()(address)
  is: '0x92f2d8b72a7F6a551Be60b9aa4194248E9B4913D'
  says: the ProxyAdmin is owned by 0x92f2d8b7
  for:
  - action
  - justification
- id: delay
  call: '0x92f2d8b72a7f6a551be60b9aa4194248e9b4913d'
  fn: getMinDelay()(uint256)
  is: '86400'
  says: the ProxyAdmin's owner is a timelock with a one-day delay
  for:
  - action
- id: setter
  source: '0x14fad0c11c83ac736e5929d5661bba7e6bb9c0d6'
  file: contracts/WalletRegistry.sol
  lines:
  - 497
  - 512
  has: dkg.dkgValidator = _dkgValidator;
  says: an upgrade through the proxy admin can install a new validator
  for:
  - action
  - justification
- id: noprocess
  selector: '0x5a444db12705706bd7b24393f823f3a8c67d71fb'
  fn: processSlashing(uint256)
  absent: true
  says: the staking implementation the registry reports to has no processSlashing function
  for:
  - whose
- id: staking
  call: '0x46d52e41c2f300bc82217ce22b920c34995204eb'
  fn: staking()(address)
  is: '0x01B67b1194C75264d06F808A921228a95C765dd7'
  says: the registry reports punishments to this staking contract
  for:
  - whose
- id: stimpl
  storage: '0x01b67b1194c75264d06f808a921228a95c765dd7'
  slot: '0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc'
  is: '0x0000000000000000000000005a444db12705706bd7b24393f823f3a8c67d71fb'
  says: the staking proxy's implementation
  for:
  - whose
- id: treasury
  call: '0x01b67b1194c75264d06f808a921228a95c765dd7'
  fn: notifiersTreasury()(uint256)
  is: '0'
  says: no notifier reward can be paid
  for:
  - whose
- id: punnote
  source: '0x14fad0c11c83ac736e5929d5661bba7e6bb9c0d6'
  file: contracts/WalletRegistry.sol
  lines:
  - 1069
  - 1078
  has: a challenged or rejected submitter keeps its stake and its
  says: punishing a submitter takes no stake and pays no reward on mainnet today
  for:
  - whose
- id: guard
  source: '0x14fad0c11c83ac736e5929d5661bba7e6bb9c0d6'
  file: contracts/WalletRegistry.sol
  lines:
  - 1121
  - 1123
  has: if (gasleft() < dkg.parameters.resultChallengeExtraGas) {
  says: a rejection reverts unless the extra gas is left, so a caller cannot fake a failed check by starving it
    of gas
  for:
  - notes
sources:
- study: eip-8151-impact
  who: Claude (families read, judged from bytecode or placed by measured rules)
  date: 2026-11-19
  by: ai-assisted
  verdict: reported
reviews:
- who: r-1a5f4f75, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: LOW
  note: 'kept: LOW (PQ-15): tBTC''s current DKG validator (WalletRegistry slot 152) re-checks operators'' signatures
    at challenge and approval; if a signer''s account takes real code after submission the honest result is rejected
    and the submitter marked malicious (losing nothing today). Approvals are gated today: the registry is not authorized
    on the reimbursement pool, and the governance Safe authorized, approved and withdrew it in one batch at block
    26,409,794. Fix: stop re-checking signatures after submission, by a registry upgrade through the one-day timelock.
    Third version; two refuters agree on it (the second measured validate() at about 1.68M gas, far inside the gas
    guard). Claude read the sheet.'
related: []
---

## What happens

tBTC's wallet registry checks new wallet results with this contract at challenge and approval. If a signer's account takes real code after submission, the honest result is rejected. Approvals now pass only when governance lets the registry use its gas refund pool.

## Evidence

- The [validator](https://etherscan.io/address/0x1a5f4f753bd071c907714aefb6e0bcee32401406#code) recovers each operator signature with ECDSA and fails the result on any mismatch.
- The [registry](https://etherscan.io/address/0x14fad0c11c83ac736e5929d5661bba7e6bb9c0d6#code) checks the result again at approval and rejects it on failure.
- A governance [batch](https://etherscan.io/tx/0xdad127784152301e0be04a5d5bd40d676ab85f4a707331f0b82bd2323d9eab28) authorized the registry, approved a result, then withdrew it.

## Reviewer notes

### Mechanism

WalletRegistry (proxy 0x46d52e41, implementation 0x14fad0c1) stores this address as dkg.dkgValidator (slot 152). submitDkgResult stores only a hash. challengeDkgResult and approveDkgResult (EcdsaDkg.approveResult -> isResultValid) call validate(), which recovers every signature with tryRecover and requires it to equal sortitionPool.getIDOperators(member); any mismatch or error returns false. At approval a false (or revert) rejects: the DKG returns to AWAITING_RESULT and the submitter is punished, before the refund call is reached. Under EIP-8151 an operator whose account takes real code after signing recovers to nothing (an EIP-7702 delegation still recovers), so the honest result is rejected. A successful approval ends with reimbursementPool.refund, which requires isAuthorized[registry]; the pool answers false at the block, so a normal approval reverts today. Governance (Safe 0x9f6e831c, pool owner) approved the last result by authorizing the registry, approving, and unauthorizing in one batch, which also installed this validator. A rejection needs no refund, so it still goes through while approvals are halted.

### Checks

- Header facts: this address alone, at block 26,438,999; 3 addresses run this code.
- Ruled out: ERC-1271 or a code-size branch for operators with code: validateSignatures has none (lines 278-298).
- Ruled out: A path to approve without revalidation: approveResult always calls isResultValid before the submitter check.
- Ruled out: Approvals closed for good: no. The pool's owner, governance Safe 0x9f6e831c, authorized the registry for the approval and can do so again; rejection needs no authorization.
- Ruled out: Funds lost by the submitter: none today. The punishment goes to staking contract 0x01b67b11, whose implementation has no processSlashing and whose notifiersTreasury() is 0; the registry's source (lines 1069-1078) says the submitter keeps its stake.
- Ruled out: Breaks with nobody migrating: no. A rejection must leave resultChallengeExtraGas (50,000) unspent, so the validator gets about 3.15M gas. The main reviewer's replay of tx 0xdad12778 used 3,263,068 gas today and 3,347,668 under EIP-8151 (+84,600 for 104 recoveries), below that floor; not in the dossier, not cited as a check.
- Ruled out: Copies 0x0125c897 (retired in tx 0xdad12778), 0x66efd639 and 0x97bb9bee run the same code for other registries; not judged here, each is its own row.
- Ruled out: State: getWalletCreationState() is 0 (IDLE) at the block, so no result is pending; the finding applies to the next wallet creation.

### History

- 2026-11-19: reported by study eip-8151-impact.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
