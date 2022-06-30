// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SudokuChallenge.sol";
import "../src/SudokuExchange.sol";
import "@openzeppelin/token/ERC20/ERC20.sol";

contract Token is ERC20 {
  constructor(string memory name, string memory symbol)ERC20(name, symbol){}
  function mint(address to) public {
    _mint(to, 100*10**18);
  }
}

interface ISudokuExchange {
  struct ChallengeReward {
    address challenge;
    uint8 solved;
    address token;
    uint256 reward;
  }
  function createReward(ChallengeReward memory challengeReward) external;
  mapping(address => ChallengeReward) public rewardChallenges;
}

contract SudokuExchangeTest is Test {

    SudokuChallenge public sc;
    SudokuExchange public ex;
    Token public token;

    address payable[] internal users;
    address internal alice;
    address internal bob;

    uint8[81] public challenge = 
    [
      3, 0, 6, 5, 0, 8, 4, 0, 0,
      5, 2, 0, 0, 0, 0, 0, 0, 0,
      0, 8, 7, 0, 0, 0, 0, 3, 1,
      0, 0, 3, 0, 1, 0, 0, 8, 0,
      9, 0, 0, 8, 6, 3, 0, 0, 5,
      0, 5, 0, 0, 9, 0, 6, 0, 0,
      1, 3, 0, 0, 0, 0, 2, 5, 0,
      0, 0, 0, 0, 0, 0, 0, 7, 4,
      0, 0, 5, 2, 0, 6, 3, 0, 0
    ];

    uint8[81] public solution = 
    [
      3, 1, 6, 5, 7, 8, 4, 9, 2,
      5, 2, 9, 1, 3, 4, 7, 6, 8,
      4, 8, 7, 6, 2, 9, 5, 3, 1,
      2, 6, 3, 4, 1, 5, 9, 8, 7,
      9, 7, 4, 8, 6, 3, 1, 2, 5,
      8, 5, 1, 7, 9, 2, 6, 4, 3,
      1, 3, 8, 9, 4, 7, 2, 5, 6,
      6, 9, 2, 3, 5, 1, 8, 7, 4,
      7, 4, 5, 2, 8, 6, 3, 1, 9
    ];

    function setUp() public {
      sc = new SudokuChallenge(challenge);
      ex = new SudokuExchange();
      alice = users[0];
      bob = users[1];
      token = new Token("TOKEN", "TKN");
      token.mint(alice);
    }

    function testCreateReward() public {
      uint256 reward = 100*10**18;
      vm.prank(alice);
      ex.createReward(SudokuExchange.ChallengeReward(address(sc), 0, address(token), reward));
      // test that the values submitted at the index are correct
    }

    function testClaimReward() public {
      // test that you can only claim if you submit the correct solution
    }

    function testEdgeCases() public {
      // test that you can't claim if you haven't submitted the correct solution
      // test that you can't claim if you've already claimed
      // test that the reward is transfered to the correct address and that the correct amount is transferred
      // test that you cannot drain the contract via re-entrancy
    }

}
