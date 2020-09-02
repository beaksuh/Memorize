//
//  ShapeSetGame.swift
//  Memorize
//
//  Created by ETHAN2 on 2020/08/25.
//  Copyright © 2020 ethan.baek. All rights reserved.
//

import SwiftUI

class ShapeSetGame: ObservableObject {
    @Published private(set) var model = ShapeSetGame.createShapeSetGame()
    
    static func createShapeSetGame() -> SetGame<String> {
        let shapes = [RectangleSketch.Category, CircleSketch.Category, DiamondSketch.Category]
        return SetGame<String>(shapeCount: shapes.count) { shapeIndex in
            shapes[shapeIndex]
        }
    }
        
    func choose(card: SetGame<String>.Card) {
        model.choose(card: card)
    }
    
    var cards: Array<SetGame<String>.Card> {
        model.cards
    }
    
    var playingCards: Array<SetGame<String>.Card> {
        model.cards.filter { card in card.isInPlayGround }
    }
    
    var setCards: Array<SetGame<String>.Card> {
        model.cards.filter { card in card.isSet }
    }
    
    var idleCards: Array<SetGame<String>.Card> {
        model.cards.filter { card in !card.isInPlayGround }
    }
    
    func resetGame() {
        model = ShapeSetGame.createShapeSetGame()
    }
    
    func deal() {
        model.deal()
    }
    
    func moreDeal() {
        model.moreDeal()
    }
    
    static func gerColor(from colorType: SetGame<String>.Card.ColorType) -> Color {
        switch colorType {
        case .black:
            return Color.black
        case .blue:
            return Color.blue
        case .red:
            return Color.red
        }
    }
}
