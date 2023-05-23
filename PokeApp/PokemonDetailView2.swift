//
//  PokemonDetailView2.swift
//  PokeApp
//
//  Created by Felipe Correa on 22/05/23.
//

import SwiftUI

struct PokemonDetailView2: View {
    
    @State var pokemon: Pokemon
    @Binding var shown: Bool
    var namespace: Namespace.ID
    
    @State private var isExpanded = true
    @State private var appear: [Bool] = [false, false, false]
    @State private var selectedTab: PokemonDetailTab = .about
    
    var body: some View {
        content
            .onAppear { fadeIn() }
    }
    
    private var content: some View {
        ZStack {
            Color(hex: pokemon.mainType.color)
                .ignoresSafeArea()
            
            VStack(spacing: 10) {
                NavigationBar(namespace: namespace,
                              title: pokemon.name,
                              subtitle: "",
                              isExpanded: $isExpanded,
                              backButtonAction: fadeOff,
                              trailingButtonAction: expandAction)
                .frame(height: 60.0)
                .foregroundColor(.white)
                
                if isExpanded {
                    HStack {
                        
                        Text(pokemon.name)
                            .customFont(.largeTitle)
                            .matchedGeometryEffect(id: "pkmName \(pokemon.id)",
                                                   in: namespace,
                                                   properties: .position)
                            .matchedGeometryEffect(id: "title", in: namespace, properties: .position)
                        
                        Spacer()
                        
                        if appear[1] {
                            Text(pokemon.id)
                                .customFont(.title2)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                                .matchedGeometryEffect(id: "pkmNumber \(pokemon.id)",
                                                       in: namespace,
                                                       properties: .position)
                        }
                    }
                    .foregroundColor(.white)
                    
                    HStack {
                        ForEach(pokemon.typeOfPokemon.suffix(2), id: \.self) { type in
                            Text(type.name)
                                .customFont(.subheadline)
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
                        Spacer()
                        if appear[1] {
                            Text("\(pokemon.category) Pokemon")
                                .customFont(.subheadline2)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .transition(.move(edge: .trailing).combined(with: .opacity))
                                .zIndex(3)
                        }
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxHeight: .infinity, alignment: .top)
            
            
            GeometryReader { proxy in
                
                let width = proxy.size.width
                let height = proxy.size.height
                
                if appear[0] {
                    ZStack {
                        if appear[1] {
                            pokemonInfo
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                                .frame(maxHeight: .infinity, alignment: .top)
                        }
                    }
                    .frame(width: width, height: height * ( isExpanded ? 0.6 : 0.9))
                    .background(
                        Color.white
                    )
                    .mask {
                        RoundedRectangle(cornerRadius: 30.0)
                    }
                    .transition(.move(edge: .bottom))
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .zIndex(2)
                }
                
                Group {
                    let offsetY = -(height*0.54)
                    if appear[2] {
                        AnimatedPokeballView(animationDuration: 6)
                            .frame(width: 200, height: 200)
                            .offset(y: offsetY)
                            .zIndex(0)
                            .transition(.opacity.animation(.default.delay(0.6)))
                    }
                    
                    if appear[0] {
                        CachedAsyncImage(url: URL(string: pokemon.imageUrl)!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                        .matchedGeometryEffect(id: "pkmAsset \(pokemon.id)",
                                               in: namespace, properties: .position)
                        .frame(width: 200, height: 200)
                        .offset(y: offsetY)
                        .opacity(isExpanded ? 1.0 : 0)
                        .transition(.opacity)
                        .zIndex(3)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
            }
            .ignoresSafeArea(.all, edges: .bottom)
        }
    }
    
    private var pokemonInfo: some View {
        VStack {
            
            PokemonStatsTabView(selectedTab: $selectedTab)
                .padding(.top, 30.0)
                .padding(.horizontal)
            
            ScrollView(showsIndicators: false) {
                
                //                GeometryReader { m in
                //                    Color.clear
                //                        .preference(key: ScrollViewOffsetKey.self,
                //                                    value: m.frame(in: .named("scroll")).minY)
                //                }
                //                .frame(height: 0)
                
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
        }
    }
    
    private func expandAction() {
        withAnimation(.easeInOut) {
            isExpanded.toggle()
        }
    }
    
    private func fadeIn() {
        withAnimation(.spring().delay(0.1)) {
            appear[0].toggle()
        }
        withAnimation(.spring().delay(0.2)) {
            appear[1].toggle()
        }
        withAnimation(.easeOut.delay(0.3)) {
            appear[2].toggle()
        }
    }
    
    private func fadeOff() {
        withAnimation(.spring()) {
            appear[0] = false
            appear[1] = false
            appear[2] = false
        }
        withAnimation(.easeInOut) {
            shown = false
        }
    }
}

struct PokemonDetailView2_Previews: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        VStack {
            PokemonDetailView2(pokemon: Pokemon.sample(),
                               shown: .constant(true),
                               namespace: namespace)
        }
    }
}
