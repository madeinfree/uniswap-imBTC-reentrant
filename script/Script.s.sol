// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "./Constants.sol";
import "src/Attacker.sol";

contract AttackerScript is Script {
    
    Attacker attacker;

    function setUp() public {
        vm.createSelectFork(FORK_URL, BLOCK_NUMBER);
        attacker = new Attacker();
    }

    function run() public {
      vm.deal(address(attacker), 3600 ether);
      attacker.run();
    }
}
