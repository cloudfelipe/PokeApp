//
//  TestFontsView.swift
//  PokeApp
//
//  Created by Felipe Correa on 11/05/23.
//

import SwiftUI

struct TestFontsView: View {
    var body: some View {
        VStack(spacing: 10.0) {
            ForEach(TextStyle.allCases, id: \.self) { type in
                Text("\(type.rawValue)")
                    .customFont(type)
            }
        }
    }
}

struct TestFontsView_Previews: PreviewProvider {
    static var previews: some View {
        TestFontsView()
    }
}
