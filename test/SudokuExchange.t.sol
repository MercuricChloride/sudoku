// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SudokuChallenge.sol";

contract SudokuChallengeTest is Test {

    SudokuChallenge public sc;
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
    }

    function testvalidateRow() public {
        uint8[9] memory input;
        for(uint8 i = 0; i < 9; i++) {
            input[i] = solution[i];
        }
        assertTrue(sc.validateSet(input));
    }

    function testFailvalidateRow() public {
        uint8[9] memory input;
        for(uint8 i = 0; i < 9; i++) {
            input[i] = challenge[i];
        }
        assertTrue(sc.validateSet(input));
    }

    function testValidateCol() public {
        uint8[9] memory input;
        for(uint8 i = 0; i < 9; i++) {
            input[i] = solution[i*9];
        }
        assertTrue(sc.validateSet(input));
    }

    function testFailValidateCol() public {
        uint8[9] memory input;
        for(uint8 i = 0; i < 9; i++) {
            input[i] = challenge[i*9];
        }
        assertTrue(sc.validateSet(input));
    }

    function testValidateBlock() public {
        uint8[9] memory input;
        uint count;
        for(uint8 i = 0; i < 3; i++) {
            for(uint8 j = 0; j < 3; j++) {
                input[count] = solution[i*9+j];
                count++;
            }
        }
        assertTrue(sc.validateSet(input));
    }

    function testFailValidateBlock() public {
        uint8[9] memory input;
        uint count;
        for(uint8 i = 0; i < 3; i++) {
            for(uint8 j = 0; j < 3; j++) {
                input[count] = solution[i*9+j];
                count++;
            }
        }
        assertFalse(sc.validateSet(input));
    }

    function testValidateRows() public {
      assertTrue(sc.validateRows(solution));
    }

    function testFailValidateRows() public {
      assertTrue(sc.validateRows(challenge));
    }

    function testValidateColumns() public {
      assertTrue(sc.validateColumns(solution));
    }

    function testFailValidateColumns() public {
      assertTrue(sc.validateColumns(challenge));
    }

    function testSubgrids() public {
      assertTrue(sc.validateSubgrids(solution));
    }

    function testFailSubgrids() public {
      assertTrue(sc.validateSubgrids(challenge));
    }

    function testSolution() public {
        assertTrue(sc.validate(solution));
    }

    function testFailSolution() public {
        sc.validate(challenge);
    }
}
