//SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.12;

contract SudokuChallenge {
    uint8[81] public challenge;
    // create a contract with an initial Sudoku challenge. Recall that Sudoku
    // is a boardgame with a square board made of 9 3x3 square subgrids. See
    // the following URL for an introduction to Sudoku:
    //
    // https://sudoku.com/how-to-play/sudoku-rules-for-complete-beginners/
    //
    // Each element of the array represents the possible cell values
    // 1 - 9. A cell value of 0 is used to represent a cell which does not have
    // an assigned value yet.
    //
    // Example for a challenge:
    //
    // [
    //    3, 0, 6, 5, 0, 8, 4, 0, 0,
    //    5, 2, 0, 0, 0, 0, 0, 0, 0,
    //    0, 8, 7, 0, 0, 0, 0, 3, 1,
    //    0, 0, 3, 0, 1, 0, 0, 8, 0,
    //    9, 0, 0, 8, 6, 3, 0, 0, 5,
    //    0, 5, 0, 0, 9, 0, 6, 0, 0,
    //    1, 3, 0, 0, 0, 0, 2, 5, 0,
    //    0, 0, 0, 0, 0, 0, 0, 7, 4,
    //    0, 0, 5, 2, 0, 6, 3, 0, 0
    // ]
    //
    // Example correct input to the `SudokuChallenge.validate` call
    // 
    //  [
    //    3, 1, 6, 5, 7, 8, 4, 9, 2,
    //    5, 2, 9, 1, 3, 4, 7, 6, 8,
    //    4, 8, 7, 6, 2, 9, 5, 3, 1,
    //    2, 6, 3, 4, 1, 5, 9, 8, 7,
    //    9, 7, 4, 8, 6, 3, 1, 2, 5,
    //    8, 5, 1, 7, 9, 2, 6, 4, 3,
    //    1, 3, 8, 9, 4, 7, 2, 5, 6,
    //    6, 9, 2, 3, 5, 1, 8, 7, 4,
    //    7, 4, 5, 2, 8, 6, 3, 1, 9
    //  ]
    constructor(uint8[81] memory _challenge) {
      challenge = _challenge;
    }

    function validateSet(uint8[9] memory _input) public pure returns (bool) {
      for (uint8 i = 0; i < 9; i++) {
        if (_input[i] == 0) {
          return false;
        }
        for (uint8 j = 0; j < 9; j++) {
          if (i == j) {
            continue;
          }
          if (_input[i] == _input[j]) {
            return false;
          }
        }
      }
      return true;
    }

    function validateRows(uint8[81] memory _input) public pure returns (bool) {
      for (uint8 i = 0; i < 9; i++) {
        uint8[9] memory row;
        for (uint8 j = 0; j < 9; j++) {
          row[j] = _input[i * 9 + j];
        }
        if (!validateSet(row)) {
          return false;
        }
      }
      return true;
    }

    function validateColumns(uint8[81] memory _input) public pure returns (bool) {
      for (uint8 i = 0; i < 9; i++) {
        uint8[9] memory column;
        for (uint8 j = 0; j < 9; j++) {
          column[j] = _input[i + j * 9];
        }
        if (!validateSet(column)) {
          return false;
        }
      }
      return true;
    }

    // EXPLANATION:
    // i is the starting row index of the subgrid.
    // j is the starting column index of the subgrid.
    // k is the offset from j, or current index.
    // (i+k/3)*9
    // i is the row start, then every time k increases by 3, we drop down a row.
    // (j+k%3)
    //j is the column start index + k%3, which is the column index of the current cell.
    function validateSubgrids(uint8[81] memory _input) public pure returns (bool) {
      for (uint i; i < 9; i+=3) {

        for (uint j; j < 9; j+=3) {

          uint8[9] memory subgrid;

          for (uint k; k < 9; k++) {
            subgrid[k] = _input[((i + k / 3) * 9) + (j + k % 3)];
            }
            if (!validateSet(subgrid)) {
              return false;
            }
          }

        }

      return true;
      }
    function validate( uint8[81] calldata potentialSolution ) public pure returns (bool isCorrect) {
      require(validateRows(potentialSolution), "One of the rows are invalid");
      require(validateColumns(potentialSolution), "One of the columns are invalid");
      require(validateSubgrids(potentialSolution), "One of the subgrids are invalid");
      return true;
    }
}
