# 🧠 MemoChain

A simple beginner **Solidity smart contract** project — an **on-chain card matching memory game** built to help new developers understand smart contract development on Ethereum-compatible blockchains.  

---

## 🎮 Project Description

**MemoChain** is a straightforward implementation of a **memory card matching game**, written in Solidity and deployed on-chain.  
The goal is to provide a fun, hands-on example for those learning smart contract logic, state variables, mappings, structs, and events — all through an interactive and gamified concept.  

Each card in the game has a hidden pair, and players attempt to match cards by calling functions directly on the blockchain.  
The logic runs **entirely on-chain**, demonstrating transparency and immutability in a playful way.

---

## ⚙️ What It Does

- Initializes a simple deck of 8 cards (4 pairs).  
- Lets a player start a game using the `startGame()` function.  
- Players can try to match two cards with `matchCards(card1, card2)`.  
- If a correct match is found, it updates the player's score on-chain.  
- The game ends automatically when all pairs are matched.  

---

## ✨ Features

- 🔹 **Beginner-friendly Solidity codebase** — clean and easy to read.  
- 🔹 **On-chain logic** — every match and score update happens transparently on the blockchain.  
- 🔹 **Events** — emits `GameStarted`, `CardMatched`, and `GameEnded` for tracking game state.  
- 🔹 **State tracking** — keeps track of matched cards, scores, and active games.  
- 🔹 **Celo Testnet Deployment** — live and verifiable on Celo Sepolia Testnet.  

---

## 🌍 Deployed Smart Contract

**Network:** Celo Sepolia Testnet  
**Contract Address:** [`0x9A9352316462253Af84202581c9bb66795657694`](https://celo-sepolia.blockscout.com/address/0x9A9352316462253Af84202581c9bb66795657694)  

---

## 🧩 Smart Contract Code

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MemoChain - A Simple On-Chain Memory Card Matching Game
 * @notice This is a beginner-level Solidity example of a card matching game
 * @dev Simplified logic: cards are represented as integers; players try to match pairs.
 */
contract MemoChain {
    address public owner;
    uint8 public constant TOTAL_CARDS = 8; // Example: 4 pairs
    uint8 public revealedPairs;
    bool public gameActive;

    struct Card {
        uint8 id;
        uint8 pairId;
        bool matched;
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

    function _initializeCards() internal {
        uint8[8] memory pairIds = [1,1,2,2,3,3,4,4];
        for (uint8 i = 0; i < TOTAL_CARDS; i++) {
            cards[i] = Card({id: i, pairId: pairIds[i], matched: false});
        }
    }

    function startGame() external {
        require(!gameActive, "Game already active");
        revealedPairs = 0;
        gameActive = true;
        emit GameStarted(msg.sender);
    }

    function matchCards(uint8 card1, uint8 card2) external {
        require(gameActive, "Game not active");
        require(card1 < TOTAL_CARDS && card2 < TOTAL_CARDS, "Invalid card");
        require(!cards[card1].matched && !cards[card2].matched, "Already matched");
        require(card1 != card2, "Can't match same card");

        if (cards[card1].pairId == cards[card2].pairId) {
            cards[card1].matched = true;
            cards[card2].matched = true;
            playerScore[msg.sender] += 1;
            revealedPairs += 1;

            emit CardMatched(msg.sender, card1, card2);

            if (revealedPairs == TOTAL_CARDS / 2) {
                gameActive = false;
                emit GameEnded(msg.sender, playerScore[msg.sender]);
            }
        }
    }

    function getAllCards() external view returns (Card[TOTAL_CARDS] memory) {
        return cards;
    }
}
