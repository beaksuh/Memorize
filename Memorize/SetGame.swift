//
//  SetGame.swift
//  Memorize
//
//  Created by ETHAN2 on 2020/08/25.
//  Copyright © 2020 ethan.baek. All rights reserved.
//

import Foundation

struct SetGame<SetContent> where SetContent: Equatable {
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
        for index in cards.indices {
            cards[index].isInPlayGround = false
        }
        
        cards.shuffle()
        
        var addedNumberOfCard = 0, index = 0
        while addedNumberOfCard < numberOfDealCard {
            if cards.indices.contains(index) {
                if !cards[index].isSet {
                    cards[index].isInPlayGround = true
                    addedNumberOfCard += 1
                }
                
                index += 1
            }
        }
    }
    
    mutating func moreDeal() {
        let moreIndex = min(cards.count - 1, numberOfDealCard+3)
        var addedNumberOfCard = numberOfDealCard
        var index = cards.indices.filter( {cards[$0].isInPlayGround} ).last ?? 0
        
        while addedNumberOfCard <= moreIndex {
            if cards.indices.contains(index) {
                if !cards[index].isSet {
                    cards[index].isInPlayGround = true
                    addedNumberOfCard += 1
                }
                
                index += 1
            } else {
                break
            }
        }
        
        numberOfDealCard = moreIndex
    }
    
    mutating func choose(card: SetGame<SetContent>.Card) {
        if let chosenIndex = cards.firstIndex(of: card), cards[chosenIndex].isInPlayGround, !cards[chosenIndex].isSet {
            cards[chosenIndex].isChosen = !cards[chosenIndex].isChosen
            
            if let chosenIndexOfCards = cards.indices.filter( {cards[$0].isChosen} ).triple {
                if checkSet(indexOfcards: chosenIndexOfCards) {
                    for chosenIndexOfCard in chosenIndexOfCards {
                        cards[chosenIndexOfCard].isSet = true
                        cards[chosenIndexOfCard].isInPlayGround = false
                    }
                    numberOfDealCard = numberOfDealCard - 3
                }
                
                for chosenIndexOfCard in chosenIndexOfCards {
                    cards[chosenIndexOfCard].isChosen = false
                }
            }
        }
    }
    
    func checkSet(indexOfcards: Array<Int>) -> Bool {
        let checkCards = [ cards[indexOfcards[0]], cards[indexOfcards[1]], cards[indexOfcards[2]] ]
        
        let shadeSet = checkCards.allSatisfy({$0.shade == checkCards.last!.shade }) ||
            (checkCards[0].shade != checkCards[1].shade &&
                checkCards[0].shade != checkCards[2].shade &&
                checkCards[1].shade != checkCards[2].shade)
        
        let shapeSet = checkCards.allSatisfy({$0.shape == checkCards.last!.shape }) ||
            (checkCards[0].shape != checkCards[1].shape &&
                checkCards[0].shape != checkCards[2].shape &&
                checkCards[1].shape != checkCards[2].shape)
        
        let colorSet = checkCards.allSatisfy({$0.color == checkCards.last!.color }) ||
            (checkCards[0].color != checkCards[1].color &&
                checkCards[0].color != checkCards[2].color &&
                checkCards[1].color != checkCards[2].color)
        
        return shadeSet && shapeSet && colorSet
    }
    
    struct Card: Identifiable {
        enum ShadeType: CaseIterable {
            case empty, striped, solid
        }
        
        enum ColorType: CaseIterable {
            case black, blue, red
        }
        
        var isSet: Bool = false
        var applyEffectForFailOfSet: Bool = false
        
        var isChosen: Bool = false
        var isInPlayGround: Bool = false
        
        var color: ColorType
        var shade: ShadeType
        var numberOfShapesInCard: Int
        var shape: SetContent
        
        var id: Int
    }
}
