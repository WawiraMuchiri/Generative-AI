"""Beauty Product Guessing Game"""

import random;
import from byllm.llm { Model }

# Choose LLM model
glob llm = Model(model_name="gemini/gemini-2.5-flash", verbose=False);

"""Provide a fun hint if guess is incorrect"""
def give_hint(wrong_guess: str, secret: str) -> str by llm();

"""Generate a fabulous congratulatory message if guess is correct"""
def congratulate(correct_guess: str) -> str by llm();

walker BeautyGame {
    has guess: str;

    can start with `root entry;
    can process_guess with turn entry;
}

node turn {
    has secret_product: str = random.choice([
        "lipstick", "eyeliner", "foundation",
        "concealer", "mascara", "highlighter", "blush"
    ]);
    has attempts_left: int = 3;
}

# Will run when in CLI mode (not in cloud)
with entry:__main__ {
    while (True) {
        product = input("""\n💄✨ Welcome to the Beauty Product Guessing Game! ✨💄
        I'm thinking of a beauty product... Can you guess which one?\n
        To quit the game type 'quit': """);

        if (product == "quit") {
            break;
        }

        root spawn BeautyGame(product);
    }
}

