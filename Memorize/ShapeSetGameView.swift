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
                    ShapeCardView(drawingArea: geometry.size, card: card)
                        .transition(AnyTransition.offset(pos: outOfSize(size: geometry.size)))
                        .onTapGesture {
                            withAnimation(.linear) {
                                self.viewModel.choose(card: card)
                            }
                    }
                }
                
                HStack {
                    Button(action: {
                        withAnimation(.easeInOut) {
                            self.viewModel.moreDeal()
                        }
                    }, label: { Text("More 3 Deal").disabled(self.viewModel.idleCards.count < 3 || self.viewModel.playingCards.count == 0) })
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            self.viewModel.deal()
                        }
                    }, label: { Text("Deal") })
                    
                    
                    Spacer()
                    
                    Button(action: {
                        withAnimation(.easeInOut) {
                            self.viewModel.resetGame()
                        }
                    }, label: { Text("New Game") })
                    
                    Spacer()
                    
                    Text("Score: \(self.viewModel.setCards.count / 3)")
                }
                
            }
        }
    }
}

struct ShapeCardView: View {
    private(set) var drawingArea: CGSize
    private(set) var card: SetGame<String>.Card
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @State private var animateMovePosition = CGPoint(x: 0, y: 0)
    @State private var animateIsInPlayGround = false
    
    private func faceUpCard() {
        withAnimation(.easeIn(duration: 0.5)) {
            animateIsInPlayGround = true
        }
    }
    
    private func moveOutOfScreen() {
        withAnimation(.easeIn(duration: 2)) {
            animateMovePosition = outOfSize(size: drawingArea)
        }
    }
    
    @ViewBuilder
    func body(for size: CGSize) -> some View {
        if card.isInPlayGround || card.isChosen {
            ShapeCanvas(numberOfShapes: CGFloat(card.numberOfShapesInCard), category: card.shape)
                .stroke(will: card.shade == SetGame<String>.Card.ShadeType.empty, lineWidth: ShapeCardView.Constants.emptyEdgeLineWidth)
                .fill(ShapeSetGame.gerColor(from: card.color))
                .opacity(card.shade == SetGame<String>.Card.ShadeType.striped ?
                    ShapeCardView.Constants.stripedOpacity : ShapeCardView.Constants.solidOpacity)
                .cardify(isFaceUp: animateIsInPlayGround)
                . if (card.isInPlayGround) {
                    $0.onAppear {
                        self.faceUpCard()
                    }
            }
            .selectify(isSelected: card.isChosen, background: ShapeCardView.Constants.background)
            .if (card.isSet) {
                $0.position()
                    .onAppear {
                        self.moveOutOfScreen()
                }
            }
            .padding(5)
            .foregroundColor(ShapeCardView.Constants.background)
        }
    }
    
    struct Constants {
        static let background = Color.pink
        static let stripedOpacity = 0.5
        static let solidOpacity = 1.0
        static let emptyEdgeLineWidth: CGFloat = 2
    }
}

enum CompassDirection: CaseIterable {
    case east, west, south, north
}

func outOfSize(size: CGSize) -> CGPoint {
    var position: CGPoint
    let offset: CGFloat = 100
    
    switch CompassDirection.allCases.randomElement() {
    case .east:
        position = CGPoint(x: size.width + offset, y: CGFloat.random(in: 0...size.height))
    case .west:
        position = CGPoint(x: 0 - size.width - offset, y: CGFloat.random(in: 0...size.height))
    case .south:
        position = CGPoint(x: CGFloat.random(in: 0...size.width), y: size.height*2)
    case .north:
        position = CGPoint(x: CGFloat.random(in: 0...size.width), y: 0 - size.height - offset)
    case .none:
        position = CGPoint(x: size.width + offset, y: CGFloat.random(in: 0...size.height))
    }
    
    return position
}

struct ShapeSetGameView_Previews: PreviewProvider {
    static var previews: some View {
        ShapeSetGameView(viewModel: ShapeSetGame())
    }
}
