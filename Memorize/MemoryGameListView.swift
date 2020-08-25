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
                MemoryGameRow()
            }
            .navigationBarTitle(Text("Memorizes"))
        }
    }
}

struct MemoryGameRow: View {
    var body: some View {
        HStack {
            NavigationLink(destination: EmojiMemoryGameView(viewModel: EmojiMemoryGame())) {
                Text("🐳🦖🔥 Emoji Memory Game")
            }
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameListView()
    }
}
