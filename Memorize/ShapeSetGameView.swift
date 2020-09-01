//
//  SetGameView.swift
//  Memorize
//
//  Created by ETHAN2 on 2020/08/25.
//  Copyright © 2020 ethan.baek. All rights reserved.
//

import SwiftUI

struct ShapeSetGameView: View {
    @ObservedObject var viewModel: ShapeSetGame
        
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Grid(items: self.viewModel.playingCards) { card in
                    ShapeCardView(card: card)
                        .transition(AnyTransition.offset(pos: self.moveOutOfScreen(size: geometry.size)))
                        .onTapGesture {
                            withAnimation(.linear) {
                                self.viewModel.choose(card: card)
                            }
                    }
                }
                
                HStack {
                    Button(action: {
                        withAnimation(.linear) {
                            self.viewModel.moreDeal()
                        }
                    }, label: { Text("3 More Deal") }).disabled(self.viewModel.playingCards.count < 12)
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.linear) {
                            self.viewModel.deal()
                        }
                    }, label: { Text("Deal") })
                    
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.linear) {
                            self.viewModel.resetGame()
                        }
                    }, label: { Text("New Game") })
                }
                
            }
        }
    }
    
    enum CardinalPoints: CaseIterable {
        case east, west, south, north
    }
    
    func moveOutOfScreen(size: CGSize) -> CGPoint {
        var position: CGPoint
        
        switch CardinalPoints.allCases.randomElement() {
        case .east:
            position = CGPoint(x: size.width, y: CGFloat.random(in: 0...size.height))
        case .west:
            position = CGPoint(x: 0 - size.width, y: CGFloat.random(in: 0...size.height))
        case .south:
            position = CGPoint(x: CGFloat.random(in: 0...size.width), y: size.height*2)
        case .north:
            position = CGPoint(x: CGFloat.random(in: 0...size.width), y: 0 - size.height)
        case .none:
            position = CGPoint(x: size.width, y: CGFloat.random(in: 0...size.height))
        }
        
        return position
    }
}

struct ShapeCardView: View {
    var card: SetGame<ShapeDrawable>.Card
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    func body(for size: CGSize) -> some View {
        ShapeCanvas(numberOfShapes: CGFloat(card.numberOfShapesInCard), sketch: card.shape.sketch)
            .stroke(will: card.shade == SetGame<ShapeDrawable>.Card.ShadeType.empty, lineWidth: 2)
            .fill(ShapeSetGame.gerColor(from: card.color))
            .opacity(card.shade == SetGame<ShapeDrawable>.Card.ShadeType.striped ? 0.5 : 1.0)
            .cardify(isFaceUp: card.isInPlayGround)
            .selectify(isSelected: card.isChosen)
            .padding(5)
            .foregroundColor(Color.red)
    }
    
    let cornerRadius: CGFloat = 10.0
    let edgeLineWidth: CGFloat = 2
}

struct Selectify: AnimatableModifier {
    var isSelected: Bool = false
    
    @ViewBuilder
    func body(content: Content) -> some View {
        if isSelected {
            content
                .overlay(RoundedRectangle(cornerRadius: 10.0).fill(Color.yellow).opacity(0.2))
            .scaleEffect(1.05)
        } else {
            content
        }
    }
}

extension View {
    func selectify(isSelected: Bool) -> some View {
        self.modifier(Selectify(isSelected: isSelected))
    }
}


struct ShapeSetGameView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeSetGameView(viewModel: ShapeSetGame())
    }
}

