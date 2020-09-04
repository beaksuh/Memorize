//
//  View+If.swift
//  Memorize
//
//  Created by ETHAN2 on 2020/09/04.
//  Copyright © 2020 ethan.baek. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder func `if`<T>(_ condition: Bool, transform: (Self) -> T) -> some View where T : View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
}
