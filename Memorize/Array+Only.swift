//
//  Array+Only.swift
//  Memorize
//
//  Created by ETHAN2 on 2020/08/21.
//  Copyright © 2020 ethan.baek. All rights reserved.
//

import Foundation

extension Array {
    var only: Element? {
        self.count == 1 ? first : nil
    }
}

extension Array {
    var set: Array? {
        self.count == 3 ? self : nil
    }
}
