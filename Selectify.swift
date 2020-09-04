//
//  Selectify.swift
//  Memorize
//
//  Created by ETHAN2 on 2020/09/04.
//  Copyright © 2020 ethan.baek. All rights reserved.
//

import SwiftUI

struct Selectify: AnimatableModifier {
    var rotation: Double
    var background: Color
    
    var isSelected: Bool {
        rotation < 90
    }
    
    var animatableData: Double {
        get { return rotation }
        set { rotation = newValue }
    }
    
    init(isSelected: Bool, background: Color) {
        rotation = isSelected ? 0 : 180
        self.background = background
    }
    
    @ViewBuilder
    func body(content: Content) -> some View {
        content
            . if (isSelected) {
                $0.overlay(RoundedRectangle(cornerRadius: cornerRadius).fill(background).opacity(selectOpacity))
                .scaleEffect(scale)
            }
            .rotation3DEffect(Angle.degrees(rotation), axis: (x: 0, y: 1, z: 0))
    }
    
    let cornerRadius: CGFloat = 10.0
    let selectOpacity: Double = 0.2
    let scale: CGFloat = 1.05
}

extension View {
    func selectify(isSelected: Bool, background: Color) -> some View {
        self.modifier(Selectify(isSelected: isSelected, background: background))
    }
}


