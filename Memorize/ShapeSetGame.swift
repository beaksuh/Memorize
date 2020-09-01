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
    
    static func createShapeSetGame() -> SetGame<ShapeDrawable> {
        var shapes = [ShapeDrawable]()
        
        shapes.append(RectangleSketch())
        shapes.append(CircleSketch())
        shapes.append(DiamondSketch())
        
        return SetGame<ShapeDrawable>(shapeCount: shapes.count) { shapeIndex in
            shapes[shapeIndex]
        }
    }
    
    func choose(card: SetGame<ShapeDrawable>.Card) {
        model.choose(card: card)
    }
    
    var cards: Array<SetGame<ShapeDrawable>.Card> {
        model.cards
    }
    
    var playingCards: Array<SetGame<ShapeDrawable>.Card> {
        model.cards.filter { card in card.isInPlayGround }
    }
    
    var setCards: Array<SetGame<ShapeDrawable>.Card> {
        model.cards.filter { card in card.isSet }
    }
    
    var idleCards: Array<SetGame<ShapeDrawable>.Card> {
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
    
    static func gerColor(from colorType: SetGame<ShapeDrawable>.Card.ColorType) -> Color {
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
