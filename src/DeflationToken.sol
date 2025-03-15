// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract DeflationToken is ERC20, ERC20Burnable {
    constructor() ERC20("DeflationToken", "DEF") {
        _mint(msg.sender, 100 ether);
    }
}
