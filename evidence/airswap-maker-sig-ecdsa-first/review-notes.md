# Review reads: airswap-maker-sig-ecdsa-first (2026-11-17, Review17)

- Sourcify full source of `0xd82e10b9a4107939e55fcca9b53a9ede6cf2fc46` (SwapERC20, solc 0.8.23, solady):
  - `swap` / `swapAnySender` -> `_check` (SwapERC20.sol 645-690): `signatory = authorized[signerWallet]` if set, else
    `signerWallet`; `SignatureCheckerLib.isValidSignatureNow(signatory, orderHash, abi.encodePacked(r, s, v))`.
  - solady `SignatureCheckerLib.isValidSignatureNow` (lines 32-92 of the bundled copy): for 64/65-byte signatures it
    calls `ecrecover` first and returns true if it matches `signer`; only otherwise calls ERC-1271
    `isValidSignature(hash, signature)`. No code-length check before `ecrecover`.
  - The ERC-1271 call receives only the 65 bytes `r || s || v` built from the function arguments (PQ-3).
  - `swapLight` (lines 243-325): `ECDSA.tryRecover(hash, v, r, s)` only; signatory must equal `signerWallet` or
    `authorized[signerWallet]`. No ERC-1271 path (PQ-1).
  - Tokens move by `safeTransferFrom(signerToken, signerWallet, recipient, signerAmount)`: the maker's allowance to
    this contract is what a forged order spends.
  - Owner functions (`setProtocolFee`, `setProtocolFeeLight`, `setProtocolFeeWallet`, `setBonusMax`,
    `setBonusScale`, `setStaking`) only; no upgrade or verifier setter.
- On-chain (onchain.json, block 26,431,214): no proxy code; `owner()` = Safe `0xf8bb149f9525875fa47b8cc632d368eb600faba3`
  (2 of 3); ETH 0, tokens ~$0.
- Blockscout `/addresses/0xd82e10b9…/transactions` (2026-11-17): latest direct calls `swap` 2026-10-22 (block
  26,247,248), `swapAnySender` 2026-09-16; creator `0x8b31f79d547f84f0ce7be9e5d1445486289000f9`.
- `data/report/curated_contracts.csv`: txs_y1 252,079 pre-quantum (`ecrecover`) transactions, usd_tx_y1 $187.7M.
- Maker approvals to this contract were not measured (would need every Approval event and current allowance x
  balance per maker).
