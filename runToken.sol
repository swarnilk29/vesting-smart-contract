//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract RunToken is ERC20 {
    constructor() ERC20("RunToken", "RUN") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }
}