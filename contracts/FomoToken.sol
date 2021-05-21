// SPDX-License-Identifier: MIT

pragma solidity 0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract FomoToken is ERC20 {
    constructor() ERC20("FomoToken", "FOMO") {
        _mint(msg.sender, 1000000000);
    }
}