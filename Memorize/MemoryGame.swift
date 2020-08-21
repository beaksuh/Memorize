//
//  MemoryGame.swift
//  Memorize
//
//  Created by ETHAN2 on 2020/08/20.
//  Copyright © 2020 ethan.baek. All rights reserved.
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards = Array<Card>()
    
    private var indexOfChosenForMatchingCard: Int? {
        get { cards.indices.filter( {cards[$0].isFaceUp} ).only }
        set {
            for index in cards.indices {
                cards[index].isFaceUp = index == newValue
            }
        }
    }
    
    init(indexCount: Int, memoryGameFactory: (Int) -> CardContent) {
        for pairIndex in 0..<indexCount {
            let content = memoryGameFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        
        cards.shuffle()
    }
    
    mutating func choose(card: MemoryGame<CardContent>.Card) {
        
        if let chosenIndex = cards.firstIndex(of: card), !cards[chosenIndex].isMatched {
            if let potentialMatchingCard = indexOfChosenForMatchingCard {
                if cards[potentialMatchingCard].content == cards[chosenIndex].content {
                    cards[chosenIndex].isMatched = true
                    cards[potentialMatchingCard].isMatched = true
                }
                cards[chosenIndex].isFaceUp = true

            } else {
                indexOfChosenForMatchingCard = chosenIndex
            }
        }
    }

    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        var content: CardContent
        var id: Int
    }
}
