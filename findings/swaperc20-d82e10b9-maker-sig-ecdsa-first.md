---
id: swaperc20-d82e10b9-maker-sig-ecdsa-first
format: 2
title: AirSwap SwapERC20 lets a quantum attacker sign orders spending makers' approvals
status: confirmed
severity: HIGH
justification: Makers' approvals stay forgeable via ECDSA even after migrating; the contract is immutable, so AirSwap
  must redeploy.
category: quantum-exposure
pattern: PQ-2
study: top-callers-classification
as_of: 2026-11-18
block: 26438999
contract:
  address: '0xd82e10b9a4107939e55fcca9b53a9ede6cf2fc46'
  name: SwapERC20
  project: airswap
  code: verified
  code_url: https://etherscan.io/address/0xd82e10b9a4107939e55fcca9b53a9ede6cf2fc46#code
  copies: 1
  upgradeable: 'no'
  admin: '0xf8bb149f9525875fa47b8cc632d368eb600faba3'
value:
  usd: 0
  basis: held
activity:
  txs_90d: 1498
impact: funds-loss
action: Deploy a SwapERC20 that checks account code before ecrecover and passes full bytes signatures to ERC-1271.
evidence_level: source
checks:
- id: c1
  source: '0xd82e10b9a4107939e55fcca9b53a9ede6cf2fc46'
  file: contracts/SwapERC20.sol
  line: 259
  has: address signatory = ECDSA.tryRecover(
  says: swapLight recovers the signatory with ECDSA.tryRecover.
  for:
  - evidence-3
  - justification
  - what
- id: c3
  source: '0xd82e10b9a4107939e55fcca9b53a9ede6cf2fc46'
  file: contracts/SwapERC20.sol
  line: 672
  has: '!SignatureCheckerLib.isValidSignatureNow('
  says: _check verifies the order signature with isValidSignatureNow.
  for:
  - action
  - evidence-1
  - justification
  - what
- id: ecr-first
  source: '0xd82e10b9a4107939e55fcca9b53a9ede6cf2fc46'
  file: solady/src/utils/SignatureCheckerLib.sol
  has: if iszero(or(iszero(returndatasize()), xor(signer, mload(t)))) {
  line: 58
  says: An ecrecover match is accepted before ERC-1271.
  for:
  - action
  - evidence-2
  - justification
  - what
- id: packed
  source: '0xd82e10b9a4107939e55fcca9b53a9ede6cf2fc46'
  file: contracts/SwapERC20.sol
  has: abi.encodePacked(r, s, v)
  line: 684
  says: Only 65 bytes are passed as the signature.
  for:
  - evidence-1
- id: sl-eq
  source: '0xd82e10b9a4107939e55fcca9b53a9ede6cf2fc46'
  file: contracts/SwapERC20.sol
  has: if (signatory != signerWallet) revert SignatureInvalid();
  line: 296
  says: swapLight requires the recovered signatory to equal the signer wallet.
  for:
  - evidence-3
- id: xfer
  source: '0xd82e10b9a4107939e55fcca9b53a9ede6cf2fc46'
  file: contracts/SwapERC20.sol
  has: ERC20 token transferred from the signer
  line: 235
  says: Tokens are taken from the maker (signer) wallet.
  for:
  - what
sources:
- study: top-callers-classification
  who: hand classification (Claude Opus agents reading verified source and bytecode)
  date: 2026-11-04
  by: ai-assisted
  verdict: reported
  rating: ''
- study: top-callers-classification
  who: Review17 (full Sourcify source and on-chain reads)
  date: 2026-11-17
  by: ai-assisted
  verdict: confirmed
  rating: HIGH
- study: eip-8151-impact
  who: Claude (the study family's recovery functions read, a real transaction replayed four ways; not reviewed by
    a person)
  date: 2026-11-19
  by: ai-assisted
  verdict: confirmed
  rating: ''
reviews: []
related: []
---

## What happens

SwapERC20 settles maker-signed orders and pulls the maker's tokens. It accepts an ecrecover match before ERC-1271; swapLight uses ecrecover alone. A quantum attacker with a maker's key signs orders spending its approvals, even after the maker adds code.

## Evidence

- [_check](https://etherscan.io/address/0xd82e10b9a4107939e55fcca9b53a9ede6cf2fc46#code) verifies the maker with SignatureCheckerLib.isValidSignatureNow over 65 bytes (r, s, v).
- [isValidSignatureNow](https://etherscan.io/address/0xd82e10b9a4107939e55fcca9b53a9ede6cf2fc46#code) runs ecrecover and returns true on a match before any ERC-1271 call.
- [swapLight](https://etherscan.io/address/0xd82e10b9a4107939e55fcca9b53a9ede6cf2fc46#code) accepts an order when ECDSA.tryRecover returns the signer wallet.

## Reviewer notes

### Mechanism

swap/swapAnySender call _check (SwapERC20.sol 645-690): signatory = authorized[signerWallet] or signerWallet; line 672 calls solady SignatureCheckerLib.isValidSignatureNow(signatory, orderHash, abi.encodePacked(r, s, v)) (line 684). In the library (lines 32-115), a 65-byte signature is fed to ecrecover (precompile 1) and isValid=1 on a match with no extcodesize check; only otherwise is isValidSignature(hash, sig) called, with just those 65 bytes, so a post-quantum account cannot receive a PQ signature. swapLight (243-325) uses ECDSA.tryRecover (line 259) and requires signatory == signerWallet or its delegate (291-297). On success, the contract transfers signerToken from signerWallet, so a forged order spends the maker's allowance to this contract. The contract has no proxy; the owner only sets fees, so only a new deployment fixes it.

### Checks

- Header facts: this address alone, at block 26,438,999.
- Ruled out: No proxy: the owner cannot upgrade the verification logic.
- Ruled out: Contract holds about $0; exposure is maker allowances, not measured.

### History

- 2026-11-04: reported by study top-callers-classification.
- 2026-11-22: reviewed again and rewritten from checks that were re-run.
