//
//  PokemonDetailView.swift
//  PokeApp
//
//  Created by Felipe Correa on 9/05/23.
//

import SwiftUI

struct PokemonDetailView: View {
    
    var namespace: Namespace.ID
    
    @Binding var isShown: Bool
    @State var pokemon: Pokemon
    
    var body: some View {
        GeometryReader { m in
            ZStack {
                Color(hex: pokemon.mainType.color)
                    .matchedGeometryEffect(id: "pkmColor \(pokemon.id)", in: namespace)
                
                VStack(spacing: 0.0) {
                    
                    HStack {
                        Button {
                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                                isShown.toggle()
                            }
                        } label: {
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .frame(width: 20.0, height: 20.0)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "heart")
                                .resizable()
                                .frame(width: 20.0, height: 20.0)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 15.0)
                    
                    HStack {
                        Text(pokemon.name)
                            .customFont(.largeTitle)
                            .foregroundColor(.white)
                            .matchedGeometryEffect(id: "pkmName \(pokemon.id)", in: namespace)
                        Spacer()
                        Text(pokemon.id)
                            .customFont(.title2)
                            .foregroundColor(.white)
                            .matchedGeometryEffect(id: "pkmNumber \(pokemon.id)", in: namespace)
                    }
                    .padding(.bottom, 10.0)
                    HStack {
                        ForEach(pokemon.typeOfPokemon.suffix(2), id: \.self) { type in
                            Text(type.name)
                                .customFont(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 15.0)
                                .padding(.vertical, 5.0)
                                .background(
                                    RoundedRectangle(cornerRadius: 20.0)
                                        .fill(Color.white.opacity(0.3))
                                )
                                .matchedGeometryEffect(id: "pkm: \(pokemon.id) type: \(type.name)", in: namespace)
                        }
                        
                        Spacer()
                        
                        Text("\(pokemon.category) Pokemon")
                            .customFont(.body)
                            .foregroundColor(.white)
                            .layoutPriority(1)
                    }
                    .frame(height: 30.0)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                
                ZStack {
                    VStack {
                        PokemonStatsTabView()
                            .padding(.top, 25.0)
                        PokemonAboutView(pokemon: pokemon)
                            .frame(height: m.size.height * 0.57)
                    }
                    .background(Color.white)
                    .mask {
                        RoundedRectangle(cornerRadius: 20.0)
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
                .overlay {
                    overlayImage(proxy: m)
                }
            }
            .mask {
                RoundedRectangle(cornerRadius: 15.0)
                    .matchedGeometryEffect(id: "mask \(pokemon.id)", in: namespace)
            }
            .ignoresSafeArea()
        }
    }
    
    @State private var pokeballRotationAngle: Double = 0.0
    @State private var animatePokeball = false
    
    func overlayImage(proxy: GeometryProxy) -> some View {
        
        let offsetY = -((proxy.size.height * 0.40) / 2 )
        let pokemonSize = CGSize(width: 200, height: 200)
        
        return ZStack {
            Image("pokeball")
                .resizable()
                .foregroundColor(.white.opacity(0.2))
                .frame(width: pokemonSize.width - 20, height: pokemonSize.height - 20)
                .rotationEffect(.degrees(pokeballRotationAngle))
                .animation(.linear(duration: 10.0).repeatForever(autoreverses: false),
                           value: pokeballRotationAngle)
                .onAppear {
                    pokeballRotationAngle = 360
                }
                .offset(y: offsetY + 15.0)
            
            PokemonScrollableView(itemSize: pokemonSize,
                                  itemPadding: 20,
                                  selectedPokemon: $pokemon)
            .frame(height: pokemonSize.height)
            .offset(y: offsetY )
        }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        PokemonDetailView(namespace: namespace,
                          isShown: .constant(true),
                          pokemon: Pokemon.sample())
    }
}
