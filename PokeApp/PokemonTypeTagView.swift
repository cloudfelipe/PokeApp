//
//  PokemonTypeTagView.swift
//  PokeApp
//
//  Created by Felipe Correa on 9/05/23.
//

import SwiftUI

struct PokemonTypeTagView: View {
    
    let pokemonType: PokemonType
    
    var body: some View {
//        ZStack {
//            RoundedRectangle(cornerRadius: 8)
//                .fill(Color.white.opacity(0.3))
//            Text(pokemonType.name)
//                .foregroundColor(Color.white)
//                .fontWeight(.medium)
//                .font(.caption)
//        }
        Text(pokemonType.name)
            .customFont(.caption)
            .foregroundColor(.white)
            .padding(.horizontal, 10.0)
            .padding(.vertical, 2.0)
            .background(
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(Color.white.opacity(0.3))
            )
    }
}

struct PokemonTypeTagView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonTypeTagView(pokemonType: .dark)
            .background(Color.blue)
    }
}
