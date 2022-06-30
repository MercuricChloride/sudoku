//SPDX-License-Identifier: Unlicense
pragma solidity >=0.6.12;
pragma experimental ABIEncoderV2;

import "./SudokuChallenge.sol";
import "@openzeppelin/token/ERC20/ERC20.sol";

/** Rewards users for solving Sudoku challenges
 *
 * SudokuExchange provides a decentralized exchange connecting amateur Sudoku enthusiasts
 * with experienced Sudoku solvers. Those looking for solutions to their Sudoku challenges
 * call SudokuExchange.createReward, specifying the particular challenge they want solved
 * and the ERC20 reward token and amount the first solver will receive upon successfully
 * solving the challenge
*/
contract SudokuExchange {

    /** All the data necessary for solving a Sudoku challenge and claiming the reward */
    struct ChallengeReward {
        address challenge; // SudokuChallenge
        uint8 solved; //using a uint8 to represent a bool
        address token; // ERC20 token
        uint256 reward; // shouldn't pack this because token amounts are too large
    }

    // stores the Sudoku challenges and the data necessary to claim the reward
    // for a successful solution
    // key: SudokuChallenge
    // value: ChallengeReward
    mapping(address => ChallengeReward) public rewardChallenges;

    function createReward(ChallengeReward memory challengeReward) public {
        // first transfer in the user's token approved in a previous transaction
        ERC20(challengeReward.token).transferFrom(msg.sender, address(this), challengeReward.reward);

        // now store the reward so future callers of SudokuExchange.claimReward can solve the challenge
        // and claim the reward
        rewardChallenges[address(challengeReward.challenge)] = challengeReward;
    }

    // claim a previously created reward by solving the Sudoku challenge
    function claimReward(address challenge, uint8[81] calldata solution) public {
        require(rewardChallenges[challenge].reward > 0, "No reward for this challenge");
        require(rewardChallenges[challenge].solved == 0, "this challenge has already been solved");
        require(SudokuChallenge(challenge).validate(solution), "The solution is not correct");

        rewardChallenges[challenge].solved = 1;
        uint256 reward = rewardChallenges[challenge].reward;
        ERC20 rewardToken = ERC20(rewardChallenges[challenge].token);
        rewardToken.transfer(msg.sender, reward);
    }
}
