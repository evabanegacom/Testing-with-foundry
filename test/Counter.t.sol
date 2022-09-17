// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    address owner = address(0x1223);
  address alice = address(0x1889);
  address bob = address(0x1778);
    function setUp() public {
       vm.startPrank(owner);
      counter = new Counter();
      vm.stopPrank(); 
    }

    function testMaxSupply() public {
        // testing the test setuo is okay
        assertEq(counter.MAX_SUPPLY(), 100);
    }

    function testMint() public {
        vm.startPrank(alice);
        vm.deal(alice, 1 ether);
        counter.safeMint{ value: 0.69 ether}(4);
        vm.stopPrank();
        assertEq(counter.balanceOf(alice), 1);
    }

    function testWithdraw() public {
      vm.startPrank(bob);
      vm.deal(bob, 1 ether);
      counter.safeMint{ value: 0.69 ether}(4);
      assertEq(counter.balanceOf(bob), 1);
      vm.stopPrank(); 
      vm.startPrank(owner);
      counter.withdraw();
      assertEq(owner.balance, 0.69 ether);
      vm.stopPrank(); 
    }

// https://bytemeta.vip/repo/cameronvoell/scaffold-eth-dex
    function testFailMint() public {
      vm.startPrank(bob);
      vm.deal(bob, 0.5 ether);
      counter.safeMint{ value: 0.69 ether}(4);
      vm.stopPrank();
      assertEq(counter.balanceOf(bob), 1);
    }
}
