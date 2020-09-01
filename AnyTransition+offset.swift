//
//  AnyTransition+offset.swift
//  Memorize
//
//  Created by ETHAN2 on 2020/09/01.
//  Copyright © 2020 ethan.baek. All rights reserved.
//

import SwiftUI

extension AnyTransition {
    public static func offset(pos: CGPoint) -> AnyTransition {
        .offset(x: pos.x, y: pos.y)
    }
}
