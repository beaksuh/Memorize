//
//  MemoryGameListView.swift
//  Memorize
//
//  Created by ETHAN2 on 2020/08/21.
//  Copyright © 2020 ethan.baek. All rights reserved.
//

import SwiftUI

struct MemoryGameListView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame())) {
                    Text("🐳🦖🔥 Emoji Memory Game")
                }
                
                NavigationLink(destination: ShapeSetGameView(viewModel: ShapeSetGame())) {
                    Text("🔶🔵🔲 Shape Set Game")
                }
            }
            .navigationBarTitle(Text("Memorizes"))
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameListView()
    }
}
