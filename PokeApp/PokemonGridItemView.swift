//
//  PokemonGridItemView.swift
//  PokeApp
//
//  Created by Felipe Correa on 5/05/23.
//

import SwiftUI

struct PokemonGridItemView: View {
    
    var namespace: Namespace.ID
    let pokemon: Pokemon
    
    var body: some View {
        GeometryReader { m in
            ZStack(alignment: .bottomTrailing) {
                
                VStack {
                    HStack {
                        Spacer()
                        Text(pokemon.id)
                            .foregroundColor(Color.black.opacity(0.2))
                            .customFont(.title3)
                            .matchedGeometryEffect(id: "pkmNumber \(pokemon.id)",
                                                   in: namespace,
                                                   properties: .position,
                                                   isSource: false)
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            
                            Text(pokemon.name)
                                .customFont(.title3)
                                .foregroundColor(Color.white)
                                .fontDesign(.rounded)
                                .matchedGeometryEffect(id: "pkmName \(pokemon.id)",
                                                       in: namespace,
                                                       properties: .position)
                            
                            
                            VStack(alignment: .leading, spacing: 10.0) {
                                ForEach(pokemon.typeOfPokemon.suffix(2), id: \.self) { type in
                                    Text(type.name)
                                        .fontWeight(.medium)
                                        .customFont(.caption)
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 10.0)
                                        .padding(.vertical, 3.0)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20.0)
                                                .fill(Color.white.opacity(0.3))
                                        )
                                        .matchedGeometryEffect(
                                            id: "pkm: \(pokemon.id) type: \(type.name)",
                                            in: namespace,
                                            properties: .position)
                                }
                            }
                            Spacer()
                        }
                        Spacer()
                    }
                }
                .padding(.horizontal, 15.0)
                .padding(.vertical, 10.0)
                
                Image("pokeball")
                    .resizable()
                    .foregroundColor(.white.opacity(0.2))
                    .frame(width: m.size.width * 0.5, height: m.size.width * 0.5)
                    .overlay {
                        CachedAsyncImage(url: URL(string: pokemon.imageUrl)!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .matchedGeometryEffect(id: "pkmAsset \(pokemon.id)",
                                               in: namespace,
                                               properties: .position)
                        .frame(width: m.size.width * 0.5, height: m.size.width * 0.5)
                        .offset(y: 2)
                    }
            }
            .background(
                Color(hex: pokemon.mainType.color)
                    .matchedGeometryEffect(id: "pkmColor \(pokemon.id)", in: namespace)
            )
            .mask {
                RoundedRectangle(cornerRadius: 15.0)
                    .matchedGeometryEffect(id: "mask \(pokemon.id)",
                                           in: namespace)
            }
        }
    }
    
}

struct PokemonGridItemView_Previews: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        ZStack {
            PokemonGridItemView(namespace: namespace, pokemon: .sample())
                .frame(width: 300, height: 200)
        }
    }
}
