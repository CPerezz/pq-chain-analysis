# Review reads: curve-stableswap-ng-permit (2026-11-17, Review17)

- Sourcify (match, Vyper 0.3.10) `CurveStableSwapNG.vy` for `0x1d08e7adc263cfc70b1babe6dc5bb339c16eec52`:
  - line 67-68: `interface ERC1271: def isValidSignature(_hash: bytes32, _signature: Bytes[65]) -> bytes32: view`
  - `permit(_owner, _spender, _value, _deadline, _v, _r, _s)` (lines 1622-1668): if `_owner.is_contract`, builds
    `sig: Bytes[65] = concat(_abi_encode(_r, _s), slice(convert(_v, bytes32), 31, 1))` and requires
    `ERC1271(_owner).isValidSignature(digest, sig) == ERC1271_MAGIC_VAL`; else `ecrecover(digest, v, r, s) == _owner`.
    Code is checked first, but the ERC-1271 path can only carry 65 bytes (PQ-3).
  - Admin functions (`ramp_A`, `stop_ramp_A`, `set_new_fee`, `set_ma_exp_time`) require `msg.sender ==
    factory.admin()`; none touches `permit`. `factory` is an immutable set at deployment.
- Blockscout: creator (factory) `0x6a8cbed756804b16e05e741edabd5cb544ae21bf`; `admin()` of that factory =
  `0xeda0108d5bb8cde2ba4a59e22f3ed5d211c77187` (read 2026-11-17, latest block).
- Pool `name()` = "USD0/USD0++"; `totalSupply()` = 267,503.0 LP; `get_virtual_price()` = 1.0111 (latest block,
  2026-11-17), i.e. about $270k of LP tokens in total.
- `data/report/curated_contracts.csv`: 8 transactions with an `ecrecover` call in the yearly window.
