# Bytecode notes: 0xc6fd8084fb9b6a0768cf943c341049edd1085b82

Read 2026-11-17 with `cast code` / `cast disassemble` (352 bytes, solc 0.8.18 metadata, unverified).

Runtime code:

```
0x608060405234801561001057600080fd5b506004361061002b5760003560e01c8063a9059cbb14610030575b600080fd5b61004361003e366004610111565b610045565b005b600080368080601f0160208091040260200160405190810160405280939291908181526020018383808284376000920182905250845194955060046020602319909601959095049490940493925050505b8181101561010b57604483016020820281015160208484010282015160206002860285010283015160206003870286010284015193506040516323b872dd60e01b600052826004528160245284604452602060006064600080885af15060006060526040525050506001919091019050610096565b50505050565b60006020828403121561012357600080fd5b503591905056fea264697066735822122067d9eebf92a88f235f65a86b01b62d9f0f5b94d86347f6e4aad042b17bc3fdf764736f6c63430008120033
```

- One entry point, selector `0xa9059cbb` (named like `transfer(address,uint256)`), no caller check, no storage.
- 0x45–0x95: copies the whole calldata to memory and splits it into four equal word arrays.
- Loop 0x96–0x10a: for each index loads four words (target, from, to, amount), writes
  `0x23b872dd` (`transferFrom(address,address,uint256)`) with (from, to, amount) and does
  `CALL(gas, target, 0, mem, 0x64, 0, 0x20)` (0xf2), ignoring the result.
- No `STATICCALL`, no `ecrecover`, no hash of a message, no comparison against a key: the contract verifies nothing.

Transactions (Blockscout, `cast tx`):

- Creator and only caller: EOA `0xef7c73aa43254c2dc10ad786065590b9c88a0816` (nonce above 285,000), creation tx
  `0x16ace5294b363a886a4c7604e601fa4b7b3b533589121432b4373d32fc177df4`. Blockscout flags the contract
  `is_scam: true` with tag `Fake_Phishing1309278`.
- `0x950bb03f…dfe94` (block 24,430,785, 2026-02-11, last call): 51 tuples; targets USDT, USDC, LINK, DAI; amounts all
  zero; `from` victims, `to` look-alike addresses. This is zero-value `transferFrom` address poisoning.
- `0x97b0e5ab…6df7` (block 24,046,459, one of the 518 transactions the precompile trace counts as `p256verify`):
  calldata word 1 (the ABI length word of the `bytes` argument) is `0x100`. The loop's first target is read from that
  word, so the first `CALL` goes to address `0x100`, the P-256 precompile, with 100 bytes of `transferFrom` calldata.
  The precompile needs 160 bytes and returns nothing; the contract ignores the result. The "P-256 calls" are this
  parsing artefact, not signature checks.
