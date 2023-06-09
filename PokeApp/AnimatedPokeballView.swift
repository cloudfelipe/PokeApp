//
//  AnimatedPokeballView.swift
//  PokeApp
//
//  Created by Felipe Correa on 22/05/23.
//

import SwiftUI

struct AnimatedPokeballView: View {
    
    let animationDuration: Double
    let color: Color
    @State private var pokeballRotationAngle: Double = 0.0
    @State private var animatePokeball = false
    
    init(animationDuration: Double = 10.0, color: Color = .white) {
        self.animationDuration = animationDuration
        self.color = color
    }
    
    var body: some View {
        Image("pokeball")
            .resizable()
            .foregroundColor(color.opacity(0.2))
            .rotationEffect(.degrees(pokeballRotationAngle))
            .animation(.linear(duration: animationDuration)
                .repeatForever(autoreverses: false),
                       value: pokeballRotationAngle)
            .onAppear {
                pokeballRotationAngle = 360
            }
    }
}

struct AnimatedPokeballView_Previews: PreviewProvider {
    static var previews: some View {
        AnimatedPokeballView()
            .frame(width: 200, height: 200)
            .background(Color.black)
    }
}
