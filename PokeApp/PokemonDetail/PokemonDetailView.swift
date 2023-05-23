//
//  PokemonDetailView.swift
//  PokeApp
//
//  Created by Felipe Correa on 15/05/23.
//

import SwiftUI

struct PokemonDetailView: View {
    
    var namespace: Namespace.ID
    
    @State var pokemon: Pokemon
    @Binding var isShown: Bool
    
    @State private var isExpanded = true
    @State private var selectedTab: PokemonDetailTab = .about
    
    var body: some View {
        
        ZStack {
            Color(hex: pokemon.mainType.color)!
                .mask(
                    RoundedRectangle(cornerRadius: 40)
                        .matchedGeometryEffect(id: "pkmColor \(pokemon.id)", in: namespace)
                        .matchedGeometryEffect(id: "mask \(pokemon.id)",
                                               in: namespace)
                )
                .ignoresSafeArea()
            
            ZStack {
                VStack(spacing: 10) {
                    NavigationBar(namespace: namespace,
                                  title: pokemon.name,
                                  subtitle: pokemon.id,
                                  isExpanded: $isExpanded,
                                  backButtonAction: {
                        withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                            isShown.toggle()
                        }
                    }, trailingButtonAction: {})
                    .foregroundColor(.white)
                    subHeaderView
                        .opacity(isExpanded ? 1.0 : 0.0)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.horizontal)
                
                pokemonInfo
                
                Group {
                    PokeballView(animationDuration: 10.0)
                        .frame(width: 180, height: 180)
                    
                    PokemonScrollableView(namespace: namespace,
                                          itemSize: .init(width: 200, height: 200),
                                          itemPadding: 10,
                                          selectedPokemon: $pokemon)
                    .frame(height: 200.0)
                    .matchedGeometryEffect(id: "pkmAsset \(pokemon.id)",
                                           in: namespace,
                                           properties: .position)
                    
                }
                .opacity(isExpanded ? 1.0: 0.0)
                .frame(height: 200.0)
                .frame(maxHeight: .infinity, alignment: .center)
                .offset(y: -100)
            }
        }
    }
    
    private var subHeaderView: some View {
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
                    .matchedGeometryEffect(
                        id: "pkm: \(pokemon.id) type: \(type.name)",
                        in: namespace,
                        properties: .position)
            }
            
            Spacer()
            
            Text("\(pokemon.category) Pokemon")
                .customFont(.body)
                .foregroundColor(.white)
                .layoutPriority(1)
        }
        .frame(height: 30.0)
    }
    
    private var pokemonName: some View {
        Text(pokemon.name)
            .foregroundColor(.white)
            .matchedGeometryEffect(id: "pkmName2 \(pokemon.id)",
                                   in: namespace,
                                   properties: .position)
            .matchedGeometryEffect(id: "pkmName \(pokemon.id)",
                                   in: namespace,
                                   properties: .position)
    }
    
    private var pokemonInfo: some View {
        GeometryReader { proxy in
            let height = proxy.size.height
            
            ZStack {
                Color.white
                
                VStack {
                    
                    PokemonStatsTabView(selectedTab: $selectedTab)
                        .padding(.top, 30.0)
                        .padding(.horizontal)
                    
                    ScrollView(showsIndicators: false) {
                        
                        GeometryReader { m in
                            Color.clear
                                .preference(key: ScrollViewOffsetKey.self,
                                            value: m.frame(in: .named("scroll")).minY)
                        }
                        .frame(height: 0)
                        
                        switch selectedTab {
                        case .about:
                            PokemonAboutView(pokemon: pokemon)
                                .padding()
                        case .baseStats:
                            PokemonBaseStatsView(pokemon: pokemon)
                                .padding()
                        case .evolution:
                            PokemonEvolutionView(pokemon: pokemon)
                                .padding()
                        case .moves:
                            Rectangle()
                                .fill(.white)
                        }
                    }
                    .coordinateSpace(name: "scroll")
                    .onPreferenceChange(ScrollViewOffsetKey.self) { value in
                        if value > 30 && !isExpanded {
                            withAnimation(.easeOut) {
                                isExpanded = true
                            }
                        } else if value < -30 && isExpanded {
                            withAnimation(.easeOut) {
                                isExpanded = false
                            }
                        }
                    }
                }
            }
            .mask {
                RoundedRectangle(cornerRadius: 30.0)
            }
            .frame(height: isExpanded ? height * 0.60 : height * 0.94)
            .frame(maxHeight: .infinity, alignment: .bottom)
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
}

private struct ScrollViewOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout Value, nextValue: () -> Value) {
        value += nextValue()
    }
}

struct PokeballView: View {

    let animationDuration: Double
    @State private var pokeballRotationAngle: Double = 0.0
    @State private var animatePokeball = false
    
    init(animationDuration: Double = 10.0) {
        self.animationDuration = animationDuration
    }
    
    var body: some View {
        Image("pokeball")
            .resizable()
            .foregroundColor(.white.opacity(0.2))
            .rotationEffect(.degrees(pokeballRotationAngle))
            .animation(.linear(duration: animationDuration)
                .repeatForever(autoreverses: false),
                       value: pokeballRotationAngle)
            .onAppear {
                pokeballRotationAngle = 360
            }
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        PokemonDetailView(namespace: namespace,
                          pokemon: .sample(),
                          isShown: .constant(true))
    }
}


struct ScrollViewHeightPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
