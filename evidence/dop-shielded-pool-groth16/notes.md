# Review notes: dop-shielded-pool-groth16 (2026-11-17)

Reads with `cast` against https://ethereum-rpc.publicnode.com at block 26,431,454; source from Sourcify
(implementation `0x591334078a5a67f1136fedbc0bd3bc9c19003517`, `contracts/logic/DOPLogic.sol`, `Verifier.sol`, `Snark.sol`).

## Proxies

| Proxy | `cast implementation` | ProxyAdmin (EIP-1967 admin slot) | ProxyAdmin `owner()` | Logic `owner()` | `signer()` |
|---|---|---|---|---|---|
| `0x100063491afd897b58828b3d4fe738ab979e13df` | `0x591334078a5a…` | `0x8593da65d55ccdb9367377231925d0688efb5007` | Safe `0xb2e069ca34bd08eec485a9cc16f659c2ba7c18c1` (2 of 5) | Safe `0x2aa82a0eec78184b6089643fef2f11c2595f46e5` (2 of 3) | `0xd50667748f34edd56d74b041c0f89bf9aa7d45cf` |
| `0x9a3152b61420ed4d5e594c0b48bb932ee41b7376` | `0xb157dc78c281…` | `0x8593da65…` | Safe `0xb2e069ca…` (2 of 5) | Safe `0x2aa82a0e…` (2 of 3) | reverts (older logic) |
| `0x41350da0c6ca2842b567799e7dac6e24f43aca69` | `0x18d04735d184…` | `0x005a5956c22c142175b49e7916b7e0ebfe56b34a` | EOA `0x45faf7923bab5a5380515e055ca700519b3e4705` | `0x1c027004862bbf808f4b208ef11d453e2d381c48` (EIP-7702 account delegated to EIP7702StatelessDeleGator) | `0xd5066774…` |

Safe `0xb2e069ca…` owners: `0x614e4ebc…`, `0xec3f6e51…`, `0x366cdf90…`, `0x3dae2efe…`, `0x554b4a63…`.
Safe `0x2aa82a0e…` owners: `0x366cdf90…`, `0x3dae2efe…`, `0x554b4a63…`.

## Code path (DOPLogic / Verifier / Snark)

- `validateTransaction` (DOPLogic.sol line 409) returns `INVALID_SNARK_PROOF` unless `Verifier.verify(transaction)`
  (line 457); `Verifier.verify` loads the verifying key for the nullifier/commitment counts and calls
  `Snark.verify` → `pairing` → `staticcall(…, 8, …)` (Snark.sol line 109), a Groth16 check on BN254. Verifying keys are set
  by the owner (`setVerificationKey`, Verifier.sol line 38).
- Decrypt (unshield): `_processDecrypt` (line 705) transfers the note's token from the proxy to the recipient
  (`token.safeTransfer(recipient, base)`). Shielded balances sit in the proxy itself.
- `Verifier.verify` returns true when `tx.origin == VERIFICATION_BYPASS` (lines 84, 118), the constant `0x…dEaD`
  (Globals.sol line 12), which no one can sign for; used for gas estimation (Railgun convention).
- Encrypt requests wait in per-request vaults from `_VAULT_FACTORY`; `encryptApproved`/`encryptRejected` require
  `msg.sender == holding.holdee` and an ECDSA signature of `signer` over `(msg.sender, index, approved)`
  (`_validateSignature`, line 742). A forged signer signature only lets a depositor approve or reject their own pending
  deposit; nothing can be taken through it.

## Holdings

`onchain.json` (block 26,431,214): `0x10006349…` $224, `0x9a3152b6…` $45,745 (USDT $24,143, WETH $20,378, …),
`0x41350da0…` $7. Total $45,976.
