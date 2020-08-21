//
//  EmojiMemoryGame.swift
//  Memorize
//
//  Created by ETHAN2 on 2020/08/21.
//  Copyright © 2020 ethan.baek. All rights reserved.
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published var model: MemoryGame<String> = EmojiMemoryGame.createEmojiMemoryGame()
    
    private static func createEmojiMemoryGame() -> MemoryGame<String> {
        let emojis = ["🐶", "🍄", "🍔"]
        return MemoryGame<String>(indexCount: emojis.count) { pairIndex in
            emojis[pairIndex]
        }
    }
    
    func choose(card: MemoryGame<String>.Card) {
        model.choose(card: card)
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
}
