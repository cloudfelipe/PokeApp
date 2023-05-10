//
//  ScrollPreferenceKey.swift
//  PokeApp
//
//  Created by Felipe Correa on 9/05/23.
//

import SwiftUI

struct ScrollPreferenceKey: PreferenceKey {
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
    
    static var defaultValue: CGFloat = 0.0
}
