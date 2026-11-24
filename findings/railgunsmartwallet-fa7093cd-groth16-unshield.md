---
id: railgunsmartwallet-fa7093cd-groth16-unshield
format: 2
title: Railgun's shielded pool pays out on proofs a quantum computer could forge
status: confirmed
severity: MEDIUM
justification: A forged proof could empty the pool; fixing it takes new circuits and an upgrade passed by a DAO
  vote.
category: quantum-exposure
pattern: PQ-7
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xfa7093cdd9ee6932b4eb2c9e1cde7ce00b1fa4b9'
  name: RailgunSmartWallet
  project: railgun
  code: verified
  code_url: https://etherscan.io/address/0xd662c4b1f22aceb0beacdf3a493de6f478686a0c#code
  proxy_of: '0xd662c4b1f22aceb0beacdf3a493de6f478686a0c'
  copies: 1
  upgradeable: 'yes'
  admin: '0x4f8e20f55f879bee7bc010bd6bd2138b34ac65c8'
value:
  usd: 98425406
  whose: users
  basis: held
activity: {}
impact: funds-loss
action: Prepare post-quantum circuits and a hash-based verifier, and pass the upgrade through the DAO before quantum
  computers arrive.
evidence_level: source
checks:
- id: author
  source: '0xd662c4b1f22aceb0beacdf3a493de6f478686a0c'
  file: contracts/logic/Verifier.sol
  line: 14
  has: '@author Railgun Contributors'
  says: the verified source names Railgun as its author
  for:
  - notes
- id: pairing
  source: '0xd662c4b1f22aceb0beacdf3a493de6f478686a0c'
  file: contracts/logic/Snark.sol
  line: 132
  has: success := staticcall(sub(gas(), 2000), 8, input, PAIRING_INPUT_WIDTH, out, 0x20)
  says: the proof check calls the BN254 pairing precompile at address 8
  for:
  - evidence-1
  - justification
  - what
- id: verifycall
  source: '0xd662c4b1f22aceb0beacdf3a493de6f478686a0c'
  file: contracts/logic/RailgunLogic.sol
  lines:
  - 472
  - 473
  has: (bool valid, bytes32 boundParamsHash) = Verifier.verify(_transaction); if (!valid) return (false, "Invalid
    Snark Proof", "");
  says: a transaction is valid only if its SNARK proof verifies
  for:
  - evidence-1
  - what
- id: proofreq
  source: '0xd662c4b1f22aceb0beacdf3a493de6f478686a0c'
  file: contracts/logic/RailgunSmartWallet.sol
  lines:
  - 113
  - 116
  has: 'require(valid, string.concat("RailgunSmartWallet: ", reason));'
  says: transact reverts unless every transaction validates
  for:
  - evidence-1
  - what
- id: unshield
  source: '0xd662c4b1f22aceb0beacdf3a493de6f478686a0c'
  file: contracts/logic/RailgunSmartWallet.sol
  line: 188
  has: RailgunLogic.transferTokenOut(_transactions[transactionIter].unshieldPreimage);
  says: transact pays out the unshield of each validated transaction
  for:
  - evidence-1
  - justification
  - what
- id: unshieldpay
  source: '0xd662c4b1f22aceb0beacdf3a493de6f478686a0c'
  file: contracts/logic/RailgunLogic.sol
  line: 331
  has: token.safeTransfer(address(uint160(uint256(_note.npk))), base);
  says: an unshield sends the pool's ERC20 tokens to the address in the note
  for:
  - evidence-1
  - what
- id: keyreq
  source: '0xd662c4b1f22aceb0beacdf3a493de6f478686a0c'
  file: contracts/logic/Verifier.sol
  line: 95
  has: 'require(verifyingKey.alpha1.x != 0, "Verifier: Key not set");'
  says: the verifier uses the stored key only when its alpha1.x is nonzero
  for:
  - what
- id: vkset
  call: '0xfa7093cdd9ee6932b4eb2c9e1cde7ce00b1fa4b9'
  fn: getVerificationKey(uint256,uint256)(uint256,uint256,uint256)
  args:
  - 1
  - 2
  is:
  - 32
  - 512
  - '20491192805390485299153009773594534940189261866228447918068658471970481763042'
  says: 'the first words of the stored key for 1 nullifier and 2 commitments: the third word, alpha1.x, is nonzero,
    so the key is set'
  for:
  - what
- id: shieldin
  source: '0xd662c4b1f22aceb0beacdf3a493de6f478686a0c'
  file: contracts/logic/RailgunLogic.sol
  line: 270
  has: token.safeTransferFrom(address(msg.sender), address(this), base);
  says: a shield moves the depositor's tokens into the pool itself
  for:
  - what
  - whose
- id: treasuryfee
  source: '0xd662c4b1f22aceb0beacdf3a493de6f478686a0c'
  file: contracts/logic/RailgunLogic.sol
  line: 279
  has: token.safeTransferFrom(address(msg.sender), treasury, fee);
  says: the protocol's fee goes to a separate treasury, so what the pool holds is its users' deposits
  for:
  - whose
- id: paused
  storage: '0xfa7093cdd9ee6932b4eb2c9e1cde7ce00b1fa4b9'
  slot: '0x8dea8703c3cf94703383ce38a9c894669dccd4ca8e65ddb43267aa0248711450'
  is: '0x0'
  says: the proxy's paused flag (keccak256('eip1967.proxy.paused') - 1) is false
  for:
  - evidence-2
  - what
- id: livetx
  tx: '0x96b6b5475fd6b2c6781579d5382db3b9451ccdccd52f6866eb3f214f98688549'
  to: '0xfa7093cdd9ee6932b4eb2c9e1cde7ce00b1fa4b9'
  ok: true
  says: a transact call (selector 0xd8ae136a) from an EOA to the pool succeeded at block 26,438,934
  for:
  - evidence-2
  - what
- id: adminslot
  storage: '0xfa7093cdd9ee6932b4eb2c9e1cde7ce00b1fa4b9'
  slot: '0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103'
  is: '0x4f8e20f55f879bee7bc010bd6bd2138b34ac65c8'
  says: the proxy's admin is the ProxyAdmin 0x4f8e20f5
  for:
  - evidence-3
- id: pupgrade
  source: '0xfa7093cdd9ee6932b4eb2c9e1cde7ce00b1fa4b9'
  file: contracts/proxy/Proxy.sol
  lines:
  - 92
  - 135
  has: function upgrade(address _newImplementation) external onlyOwner
  says: only the address in the admin slot can upgrade the proxy (onlyOwner compares the caller with it at line
    92)
  for:
  - action
  - evidence-3
  - justification
- id: pa
  source: '0x4f8e20f55f879bee7bc010bd6bd2138b34ac65c8'
  file: contracts/proxy/ProxyAdmin.sol
  lines:
  - 37
  - 38
  has: function upgrade(PausableUpgradableProxy _proxy, address _newImplementation) external onlyOwner{ _proxy.upgrade(_newImplementation);
  says: the ProxyAdmin's owner can upgrade the proxy
  for:
  - action
  - evidence-3
  - justification
- id: paowner
  call: '0x4f8e20f55f879bee7bc010bd6bd2138b34ac65c8'
  fn: owner()(address)
  is: '0xb6d513f6222ee92fff975e901bd792e2513fb53b'
  says: the ProxyAdmin's owner is the Delegator 0xb6d513f6
  for:
  - evidence-3
- id: delowner
  call: '0xb6d513f6222ee92fff975e901bd792e2513fb53b'
  fn: owner()(address)
  is: '0xc480f68a3dcc3edd82134fab45c14a0fcf1da3cc'
  says: the Delegator's owner is the Voting contract 0xc480f68a
  for:
  - evidence-3
- id: delexec
  source: '0xb6d513f6222ee92fff975e901bd792e2513fb53b'
  file: contracts/governance/Delegator.sol
  lines:
  - 150
  - 154
  has: 'return _contract.call{value: _value}(_data);'
  says: the Delegator forwards calls from its owner or permission holders
  for:
  - evidence-3
  - justification
- id: vexec
  source: '0xc480f68a3dcc3edd82134fab45c14a0fcf1da3cc'
  file: contracts/governance/Voting.sol
  lines:
  - 387
  - 407
  has: 'require(proposal.yayVotes >= QUORUM, "Voting: Quorum hasn''t been reached");'
  says: Voting executes a proposal through the Delegator only after a token-vote quorum
  for:
  - action
  - evidence-3
  - justification
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: review (Review01)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
reviews:
- who: r-fa7093cd, the row's refuter
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  note: agree, no objection
- who: claude-main, the reader who settled the row
  date: 2026-11-21
  by: ai-assisted
  verdict: confirmed
  rating: MEDIUM
  note: 'kept: Kev''s first-study finding, MEDIUM (PQ-7): Railgun''s shielded pool ($98.4M of users'' tokens) pays
    out an unshield when a Groth16 proof over BN254 verifies (transact -> Verifier.verify -> Snark.verify -> the
    pairing precompile, then transferTokenOut from the pool''s own balance); the pool is live and not paused; the
    fix is new circuits and an upgrade through the ProxyAdmin owned by Railgun''s Delegator, which the token-vote
    Voting contract owns. Two refuters agree; Claude read the sheet.'
related: []
---

## What happens

Railgun's shielded pool holds its users' tokens and pays out an unshield when a Groth16 proof over the BN254 curve verifies. A quantum computer could recover the setup's secret from the public verifying keys, forge such proofs and empty the pool. The pool is live and not paused.

## Evidence

- [The verifier](https://etherscan.io/address/0xd662c4b1f22aceb0beacdf3a493de6f478686a0c#code) checks each spend with a BN254 pairing; when it passes, transact sends the unshielded tokens out.
- [A recent transact call](https://etherscan.io/tx/0x96b6b5475fd6b2c6781579d5382db3b9451ccdccd52f6866eb3f214f98688549) to the pool succeeded, and the pool is not paused.
- [The proxy's](https://etherscan.io/address/0xfa7093cdd9ee6932b4eb2c9e1cde7ce00b1fa4b9#code) admin is a ProxyAdmin owned by Railgun's Delegator, which Railgun's token-vote Voting contract owns.

## Reviewer notes

### Mechanism

RailgunSmartWallet.transact (proxy 0xfa7093cd, implementation 0xd662c4b1) runs RailgunLogic.validateTransaction for each transaction and requires it to be valid (RailgunSmartWallet line 116). validateTransaction calls Verifier.verify (RailgunLogic line 472). That function loads the verifying key stored for the nullifier and commitment counts, requires it to be set (Verifier line 95) and runs Snark.verify. Snark.verify is a Groth16 check whose pairing calls the BN254 pairing precompile at address 8 (Snark line 132). For an unshield, transact then calls transferTokenOut (RailgunSmartWallet line 188), which sends ERC20 tokens to the address in the note (RailgunLogic line 331). Note ownership and Merkle membership are proved inside the circuit, so with the setup trapdoor a forged proof spends notes that do not exist. The scheme is fixed in the implementation code. Upgrade path: the proxy's upgrade is open only to the address in its admin slot (Proxy lines 92, 135). That address is the ProxyAdmin 0x4f8e20f5, whose upgrade(proxy, impl) is onlyOwner (ProxyAdmin lines 37-38). Its owner is the Delegator 0xb6d513f6, whose callContract forwards calls from its owner or from permission holders (Delegator lines 84, 150-154). The Delegator's owner is Voting 0xc480f68a, which executes proposals through the Delegator after a 2,000,000-token quorum (Voting lines 387, 407).

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: a signature-recovery path: the spend path verifies a SNARK, and the implementation's source has no ecrecover. This row is the quantum-exposure finding, not an EIP-8151 one.
- Ruled out: an implementation used only behind proxies: this address is the proxy users call. A transact call to it succeeded at block 26,438,934, and it holds the tokens.
- Ruled out: keys unset: the key for 1 nullifier and 2 commitments has a nonzero alpha1.x, the field the verifier requires to be nonzero.
- Ruled out: the verification bypass: Verifier returns true only when tx.origin is 0x...dEaD. That is for gas estimation, and nobody is known to hold that key.
- Ruled out: a fix through setVerificationKey: the owner can replace the keys, but new keys are still a Groth16 setup over BN254 and just as forgeable. Only an implementation upgrade changes the proof system.
- Ruled out: pausing as a fix: the ProxyAdmin owner can pause the proxy, but that stops every spend and fixes nothing.
- Ruled out: who else can upgrade: other Delegator permission holders are recorded only in event logs, which were not read here. Voting can upgrade through the Delegator either way, and the rating rests on the fix being an upgrade, not on who passes it.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-20: reviewed again and rewritten from checks that were re-run.
