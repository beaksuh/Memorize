//
//  SetGame.swift
//  Memorize
//
//  Created by ETHAN2 on 2020/08/25.
//  Copyright © 2020 ethan.baek. All rights reserved.
//

import Foundation

struct SetGame<SetContent> {
    private(set) var cards: Array<Card>
    private let numberOfShapesInCardLimit: Int = 3
    private var numberOfDealCard: Int = 12
    private var uniqueId = 0
    
    init(shapeCount: Int, setGameFactory: (Int) -> SetContent) {
        cards = Array<Card>()
        
        for shapeIndex in 0..<shapeCount {
            let content = setGameFactory(shapeIndex)
            for numberOfShapesInCard in 0..<numberOfShapesInCardLimit {
                for shade in Card.ShadeType.allCases {
                    for color in Card.ColorType.allCases {
                        cards.append(Card(color: color, shade: shade, numberOfShapesInCard: numberOfShapesInCard+1, shape: content, id: uniqueId))
                        uniqueId += 1
                    }
                }
            }
        }
        
        cards.shuffle()
    }
    
    mutating func deal() {
        for index in 0..<cards.count {
            cards[index].isInPlayGround = false
        }
        
        cards.shuffle()
        
        for index in 0..<numberOfDealCard {
            cards[index].isInPlayGround = true
        }
    }
    
    mutating func moreDeal() {
        let moreIndex = min(cards.count - 1, numberOfDealCard+3)
        for index in numberOfDealCard..<moreIndex {
            cards[index].isInPlayGround = true
        }
        numberOfDealCard = moreIndex
    }
    
    var indexOfChosenForSetCard = Array<SetGame<SetContent>.Card>()
    
    mutating func choose(card: SetGame<SetContent>.Card) {
        if let chosenIndex = cards.firstIndex(of: card), cards[chosenIndex].isInPlayGround, !cards[chosenIndex].isSet {
            cards[chosenIndex].isChosen = !cards[chosenIndex].isChosen
            
            if let chosenCards = cards.indices.filter( {cards[$0].isChosen} ).set {
                if setRule(indexOfcards: chosenCards) {
                    cards[chosenCards[0]].isSet = true
                    cards[chosenCards[1]].isSet = true
                    cards[chosenCards[2]].isSet = true
                } else {
                    cards[chosenCards[0]].isChosen = false
                    cards[chosenCards[1]].isChosen = false
                    cards[chosenCards[2]].isChosen = false
                }
            }
        }
    }
    
    func setRule(indexOfcards: Array<Int>) -> Bool {
        
        var shadeRule: Bool = false
        if cards[indexOfcards[0]].shade == cards[indexOfcards[1]].shade, cards[indexOfcards[1]].shade == cards[indexOfcards[2]].shade {
            shadeRule = true
        } else if cards[indexOfcards[0]].shade != cards[indexOfcards[1]].shade, cards[indexOfcards[1]].shade != cards[indexOfcards[2]].shade, cards[indexOfcards[0]].shade != cards[indexOfcards[2]].shade {
            shadeRule = true
        }
        
        var colorRule: Bool = false
        if shadeRule {
            if cards[indexOfcards[0]].color == cards[indexOfcards[1]].color, cards[indexOfcards[1]].color == cards[indexOfcards[2]].color {
                colorRule = true
            } else if cards[indexOfcards[0]].color != cards[indexOfcards[1]].color, cards[indexOfcards[1]].color != cards[indexOfcards[2]].color, cards[indexOfcards[0]].color != cards[indexOfcards[2]].color {
                colorRule = true
            }
        }
        
        var shapeRule: Bool = false
//        if colorRule {
//            if cards[indexOfcards[0]].shape == cards[indexOfcards[1]].shape, cards[indexOfcards[1]].shape == cards[indexOfcards[2]].shape {
//                shapeRule = true
//            } else if cards[indexOfcards[0]].shape != cards[indexOfcards[1]].shape, cards[indexOfcards[1]].shape != cards[indexOfcards[2]].shape, cards[indexOfcards[0]].shape != cards[indexOfcards[2]].shape {
//                shapeRule = true
//            }
//        }
        
        return shapeRule
    }
    
    struct Card: Identifiable {
        enum ShadeType: CaseIterable {
            case empty, striped, solid
        }
        
        enum ColorType: CaseIterable {
            case black, blue, red
        }
        
        var isSet: Bool = false
        var isChosen: Bool = false
        var isInPlayGround: Bool = false
       
        var color: ColorType
        var shade: ShadeType
        var numberOfShapesInCard: Int
        var shape: SetContent
        
        var id: Int
    }
}
