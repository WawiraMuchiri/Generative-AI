impl BeautyGame.start {
    if not [root --> (`?turn)] {
        next = root ++> turn(random.choice([
            "lipstick", "eyeliner", "foundation",
            "concealer", "mascara", "highlighter", "blush"
        ]));
    } else {
        next = [root --> (`?turn)];
    }
    visit next;

}

impl BeautyGame.process_guess {
    if [-->] {
        visit [-->];
    } else {
        if self.guess == here.secret_product {
            print(congratulate(self.guess));
            disengage;
        } else {
            here.attempts_left -= 1;
            if here.attempts_left > 0 {
                print("❌ Nope, that’s not it! Try again 💅");
                print(give_hint(self.guess, here.secret_product));
                here ++> turn(here.secret_product);
            } else {
                print("\n😢 Oh no! Out of attempts!");
                print(f"💔 The correct product was ***{here.secret_product.upper()}*** 💔");
                print("But hey… makeup wipes exist, so you can always try again 😉");
                disengage;
            }
        }
    }
}
