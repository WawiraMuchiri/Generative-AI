
# Beauty Product Guessing Game

## Overview

The **Beauty Product Guessing Game** is a fun and interactive command-line game built with the **JAC programming language**.
The program randomly selects a beauty product from a predefined list, and the player must guess the correct product within a limited number of attempts.

If the player guesses incorrectly, the game provides **AI-generated hints** (via a language model integration). If the player guesses correctly, they receive a personalized **congratulatory message**.

The game continues until the player types **`quit`** to exit.

---

## Features

* Randomly selects a secret beauty product (e.g., lipstick, eyeliner, mascara, etc.).
* Player inputs guesses interactively in the terminal.
* AI-powered hints if the guess is wrong.
* AI-generated congratulatory messages for correct guesses.
* Limited attempts (default is 3).
* Option to quit the game anytime by typing **`quit`**.

---

## Project Structure

The project is organized into two main files:

```
Beauty-Product-Guessing-Game/
│
├── beauty_game.jac        # Interface (declarations, walker, nodes, entry point)
├── beauty_game.impl.jac   # Implementation (game logic and behavior)
└── README.md              # Documentation
```

### 1. **Interface (`beauty_game.jac`)**

* Declares the `BeautyGame` walker.
* Defines the `turn` node (with the secret product and remaining attempts).
* Includes `give_hint` and `congratulate` functions connected to the LLM.
* Provides the entry loop for interactive user input.

### 2. **Implementation (`beauty_game.impl.jac`)**

* Implements the game logic:

  * Starts the game.
  * Processes player guesses.
  * Provides hints and congratulatory messages.
  * Handles win/lose conditions.

---

## Prerequisites

Before running the game, make sure you have the following installed:

1. **Python 3.12+**
2. **JAC language runtime** (`jaclang`)

   ```bash
   pip install jaclang
   ```
3. **byllm** package for LLM integration

   ```bash
   pip install byllm
   ```
4. An LLM provider (e.g., OpenAI, Gemini) configured in your environment.

---

## How to Run the Game

1. Clone this repository:

   ```bash
   git clone https://github.com/WawiraMuchiri/Generative-AI.git
   cd Beauty-Product-Guessing-Game
   ```

2. Run the JAC program:

   ```bash
   jac run beauty_game.jac beauty_game.impl.jac
   ```

3. Follow the prompts in the terminal:

   ```
   Welcome to the Beauty Product Guessing Game!
   I'm thinking of a beauty product... Can you guess which one?

   To quit the game type 'quit':
   ```

4. Keep guessing until you either:

   * Guess correctly and receive a congratulatory message.
   * Run out of attempts and see the correct answer.
   * Type `quit` to exit the game.

---

## Example Gameplay

```
Welcome to the Beauty Product Guessing Game!
I'm thinking of a beauty product... Can you guess which one?

To quit the game type 'quit': lipstick
❌ Nope, that’s not it! Try again
Hint: This product is used around the eyes...

To quit the game type 'quit': mascara
Congratulations! You guessed correctly.
```

---
## License

This project is licensed under the MIT License.
You are free to use, modify, and distribute it as long as proper attribution is provided.

---

