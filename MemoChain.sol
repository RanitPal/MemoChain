// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MemoChain - A Simple On-Chain Memory Card Matching Game
 * @author 
 * @notice This is a beginner-level Solidity example of a card matching game
 * @dev Simplified logic: cards are represented as integers; players try to match pairs.
 */
contract MemoChain {
    address public owner;
    uint8 public constant TOTAL_CARDS = 8; // Example: 4 pairs
    uint8 public revealedPairs;
    bool public gameActive;

    // Represent a card
    struct Card {
        uint8 id;          // unique card ID
        uint8 pairId;      // number indicating which cards are a pair
        bool matched;      // true if already matched
    }

    Card[TOTAL_CARDS] public cards;
    mapping(address => uint8) public playerScore;

    event GameStarted(address indexed starter);
    event CardMatched(address indexed player, uint8 card1, uint8 card2);
    event GameEnded(address winner, uint8 score);

    constructor() {
        owner = msg.sender;
        _initializeCards();
    }

    /// @dev Randomly initialize card pairs (for demo, pseudo-random)
    function _initializeCards() internal {
        uint8[8] memory pairIds = [1,1,2,2,3,3,4,4];
        for (uint8 i = 0; i < TOTAL_CARDS; i++) {
            cards[i] = Card({id: i, pairId: pairIds[i], matched: false});
        }
    }

    /// @notice Start a new game
    function startGame() external {
        require(!gameActive, "Game already active");
        revealedPairs = 0;
        gameActive = true;
        emit GameStarted(msg.sender);
    }

    /// @notice Player attempts to match two cards
    function matchCards(uint8 card1, uint8 card2) external {
        require(gameActive, "Game not active");
        require(card1 < TOTAL_CARDS && card2 < TOTAL_CARDS, "Invalid card");
        require(!cards[card1].matched && !cards[card2].matched, "Already matched");
        require(card1 != card2, "Can't match same card");

        if (cards[card1].pairId == cards[card2].pairId) {
            // It's a match!
            cards[card1].matched = true;
            cards[card2].matched = true;
            playerScore[msg.sender] += 1;
            revealedPairs += 1;

            emit CardMatched(msg.sender, card1, card2);

            // End game if all pairs found
            if (revealedPairs == TOTAL_CARDS / 2) {
                gameActive = false;
                emit GameEnded(msg.sender, playerScore[msg.sender]);
            }
        }
    }

    /// @notice View all cards (for demo/testing)
    function getAllCards() external view returns (Card[TOTAL_CARDS] memory) {
        return cards;
    }
}

