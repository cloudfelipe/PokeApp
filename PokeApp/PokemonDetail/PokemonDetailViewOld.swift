//
//  PokemonDetailViewOld.swift
//  PokeApp
//
//  Created by Felipe Correa on 9/05/23.
//

import SwiftUI

struct PokemonDetailViewOld: View {
    
    var namespace: Namespace.ID
    
    @State var pokemon: Pokemon
    @Binding var isShown: Bool
    
    @State var selectedTab: PokemonDetailTab = .about
    
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
                        PokemonStatsTabView(selectedTab: $selectedTab)
                            .padding(.top, 25.0)
                        ScrollView {
                            GeometryReader { proxy in
                                Color.clear
                                    .preference(key: ScrollPreferenceKey.self,
                                                value: proxy.frame(in: .named("scroll2")).minY)
                            }
                            .frame(height: 0)
                            switch selectedTab {
                            case .about:
                                PokemonAboutView(pokemon: pokemon)
                            case .baseStats:
                                PokemonBaseStatsView(pokemon: pokemon)
                            case .evolution:
                                PokemonEvolutionView(pokemon: pokemon)
                            case .moves:
                                Rectangle()
                                    .fill(.white)
                            }
                        }
                        
                        .padding([.horizontal, .bottom])
                        .padding(.top, 10.0)
                        .padding(.horizontal, 5.0)
                        .frame(height: m.size.height * 0.7)
                    }
                    .background(Color.white)
                    .mask {
                        RoundedRectangle(cornerRadius: 20.0)
                    }
                    .frame(maxHeight: .infinity, alignment: .bottom)
                }
                .coordinateSpace(name: "scroll2")
                .onPreferenceChange(ScrollPreferenceKey.self) { value in
                    withAnimation(.easeInOut) {
                        debugPrint(value)
                    }
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
            
//            PokemonScrollableView(itemSize: pokemonSize,
//                                  itemPadding: 20,
//                                  selectedPokemon: $pokemon)
//            .frame(height: pokemonSize.height)
//            .offset(y: offsetY )
        }
    }
}

struct PokemonDetailViewOld_Previews: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        PokemonDetailViewOld(namespace: namespace,
                          pokemon: Pokemon.sample(),
                          isShown: .constant(true))
    }
}
