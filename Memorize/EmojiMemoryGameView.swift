//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  Created by ETHAN2 on 2020/08/20.
//  Copyright © 2020 ethan.baek. All rights reserved.
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        VStack {
            Grid(items: viewModel.cards) { card in
                CardView(card: card).onTapGesture {
                    withAnimation(.linear) {
                        self.viewModel.choose(card: card)
                    }
                }
                .padding(5)
            }
            .foregroundColor(Color.orange)
            .padding()
            
            Button(action: {
                withAnimation(.easeInOut) {
                    self.viewModel.resetGame()
                }
            }, label: { Text("New Game") })
        }
    }
}

struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            self.body(for: geometry.size)
        }
    }
    
    @State private var animateBonusReaming: Double = 0
    
    private func startBonusTimeAnimation() {
        animateBonusReaming = card.bonusRemaining
        withAnimation(.linear(duration: card.bonusTimeRemaining)) {
            animateBonusReaming = 0
        }
    }
    
    @ViewBuilder
    private func body(for size: CGSize) -> some View {
        if card.isFaceUp || !card.isMatched {
            ZStack {
                Group {
                    if card.isConsumingBonusTime {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-animateBonusReaming*360-90), clockwise: true)
                            .onAppear {
                                self.startBonusTimeAnimation()
                        }
                    } else {
                        Pie(startAngle: Angle.degrees(0-90), endAngle: Angle.degrees(-card.bonusRemaining*360-90), clockwise: true)
                            .onAppear {
                                self.startBonusTimeAnimation()
                        }
                    }
                }
                .padding(5).opacity(0.4)
                
                Text(card.content)
                    .font(Font.system(size: fontSize(for: size)))
                    .rotationEffect(Angle.degrees(card.isMatched ? 360 : 0))
                    .animation(card.isMatched ? Animation.linear.repeatForever(autoreverses: false) : .default)
                
            }
            .cardify(isFaceUp: card.isFaceUp)
            .transition(AnyTransition.scale)
        }
    }
    
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let game = EmojiMemoryGame()
        game.choose(card: game.cards[0])
        return EmojiMemoryGameView(viewModel: game)
    }
}
