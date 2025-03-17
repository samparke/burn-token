// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/BurnToken.sol";

contract BurnTokenTest is Test {
    BurnToken token;
    address admin = address(1);
    address user1 = address(2);
    address user2 = address(3);
    uint256 conversion = (10 ** 18);

    function setUp() public {
        token = new BurnToken(admin);
    }

    function testInitialBalance() public view {
        uint256 balance = token.balanceOf(admin);
        assertGt(balance, 0);
    }

    function testTransfer() public {
        uint256 initialAdminBalance = token.balanceOf(admin);
        vm.prank(admin);
        token.transfer(user1, 10);
        uint256 user1Balance = token.balanceOf(user1);
        uint256 adminBalance = token.balanceOf(admin);
        uint256 mappingAdminBalance = token.burnedPerAddress(admin);

        assertEq(initialAdminBalance, 1000 * conversion);
        assertEq(user1Balance, 8 * conversion);
        assertEq(adminBalance, 990 * conversion);
        assertEq(mappingAdminBalance, 2 * conversion);
    }

    function testTransferFrom() public {
        vm.prank(admin);
        token.transfer(user1, 100);

        vm.prank(user1);
        token.approve(admin, 100 * conversion);

        vm.prank(admin);
        token.transferFrom(user1, user2, 10);
        uint256 mappingUserBalance = token.burnedPerAddress(user1);
        uint256 user2Balance = token.balanceOf(user2);
        assertEq(user2Balance, 8 * conversion);
        assertEq(mappingUserBalance, 2 * conversion);
    }
}
