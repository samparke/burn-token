// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract BurnToken is ERC20, ERC20Burnable, Ownable {
    uint256 public constant BURN_RATE = 2000; // 2% burn rate
    uint256 public constant BASE = 10000;
    uint256 public totalBurned; // total number of tokens burned
    mapping(address => uint256) public burnedPerAddress; // the amount of tokens a user burned

    constructor(address initialOwner) ERC20("BurnToken", "BURN") Ownable(initialOwner) {
        _mint(initialOwner, 1000 * (10 ** decimals()));
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        uint256 rawAmount = amount * (10 ** decimals());
        uint256 burnAmount = calculateBurn(rawAmount);
        uint256 sendAmount = rawAmount - burnAmount;

        _burn(msg.sender, burnAmount);
        burnedPerAddress[msg.sender] += burnAmount;
        totalBurned += burnAmount;

        return super.transfer(recipient, sendAmount);
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        uint256 rawAmount = amount * (10 ** decimals());
        uint256 burnAmount = calculateBurn(rawAmount);
        uint256 sendAmount = rawAmount - burnAmount;

        _burn(sender, burnAmount);
        burnedPerAddress[sender] += burnAmount;
        totalBurned += burnAmount;

        return super.transferFrom(sender, recipient, sendAmount);
    }

    function calculateBurn(uint256 amount) internal pure returns (uint256) {
        return (amount * BURN_RATE) / BASE;
    }
}
