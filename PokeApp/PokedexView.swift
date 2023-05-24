//
//  PokedexView.swift
//  PokeApp
//
//  Created by Felipe Correa on 19/05/23.
//

import SwiftUI

struct PokedexView: View {
    
    @Namespace private var namespace
    
    @State private var isShown = false
    @State private var selectedPokemon = Pokemon.sample()
    @State private var hasScrolled = false
    
    @State private var showFilter = false
    
    let pokemons: [Pokemon] = Pokemon.loadData()
    
    private var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    }
    
    var body: some View {
        
        ZStack {
            Color.white
                .ignoresSafeArea()
                .zIndex(0)
            
            navigationBar
            
            list
                .offset(y: 50.0)
//                .overlay {
//                    Rectangle()
//                        .fill(.white.opacity(0.4))
//                        .frame(height: 50.0)
//                        .background(.ultraThinMaterial)
//                        .blur(radius: 3)
//                        .opacity(0.9)
//                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
//
//                }
                .overlay {
                    filter
                    .ignoresSafeArea()
                }
                .ignoresSafeArea(.all, edges: .bottom)
                .zIndex(1)
            
            if isShown {
                PokemonDetailView2(pokemon: selectedPokemon,
                                   shown: $isShown,
                                   namespace: namespace)
                .zIndex(2)
            }
        }
    }
    
    var navigationBar: some View {
        
        VStack(spacing: 0) {
            
            HStack {
                Button {
                    
                } label: {
                    Label(title: {}, icon: {
                        Image(systemName: "arrow.backward")
                            .customFont(.title)
                    })
                }
                
                Spacer()
                
                if hasScrolled {
                    Text("Pokedex")
                        .customFont(.title)
                        .matchedGeometryEffect(id: "pokedexTitle", in: namespace, properties: .position)
                    Spacer()
                }
                
                Button {
                    
                } label: {
                    Label(title: {}, icon: {
                        Image(systemName: "list.bullet")
                            .customFont(.title2)
                    })
                }
                .background {
                    AnimatedPokeballView(animationDuration: 5.0,
                                         color: .black.opacity(0.3))
                    .frame(width: 200, height: 200)
                }
                
            }
            
            .frame(height: 60.0)
            .foregroundColor(.black)
            
            if !hasScrolled {
                Text("Pokedex")
                    .customFont(.largeTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .matchedGeometryEffect(id: "pokedexTitle",
                                           in: namespace, properties: .position)
            }
        }
        .padding(.horizontal)
        .frame(maxHeight: .infinity, alignment: .top)
        
    }
    
    var filter: some View {
        Group {
            if showFilter {
                Color.black.opacity(0.5)
            } else {
                Color.clear
            }
        }
        .overlay {
            FilterStack(showFilter: $showFilter)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
            .padding(.horizontal)
            .padding(.vertical, 40)
        }
    }
    
    var list: some View {
        ScrollView(showsIndicators: false) {
            
            scrollDetection
            
            if isShown {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(pokemons) { _ in
                        Rectangle()
                            .fill(.black)
                            .frame(height: 150)
                            .cornerRadius(30)
                            .opacity(0.3)
                    }
                }
            } else {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(pokemons) { pokemon in
                        PokemonGridItemView(namespace: namespace, pokemon: pokemon)
                            .frame(height: 150)
                            .onTapGesture {
                                selectedPokemon = pokemon
                                fadeIn()
                            }
                    }
                }
            }
        }
        .coordinateSpace(name: "scroll")
        .safeAreaInset(edge: .top) {
            Color.clear.frame(height: 50.0)
        }
        .padding()
        .zIndex(0)
    }
    
    private var scrollDetection: some View {
        GeometryReader { proxy in
            let minY = proxy.frame(in: .named("scroll")).minY
            Color.clear
                .preference(key: ScrollPreferenceKey.self,
                            value: minY)
        }
        .frame(height: 0)
        .onPreferenceChange(ScrollPreferenceKey.self) { value in
            withAnimation(.easeInOut(duration: 0.2)) {
                self.hasScrolled = value < -10
            }
        }
    }
    
    private func fadeIn() {
        withAnimation(.easeInOut) {
            isShown.toggle()
        }
    }
}

struct FilterStack: View {
    
    struct Filter: Identifiable {
        let id = UUID()
        let title: String
        let imageName: String
    }
    
    let filters: [Filter] = [
        .init(title: "Favourite Pokemon", imageName: "heart.fill"),
        .init(title: "All Type", imageName: "fanblades.fill"),
        .init(title: "All Gen", imageName: "bolt.fill"),
        .init(title: "Search", imageName: "magnifyingglass")
    ]
    
    @Binding var showFilter: Bool
    
    @State private var appears = [false, false, false, false]
    @State private var enableAction = true
    
    @State private var showSelectGeneration = false
    
    var body: some View {
        VStack(alignment: .trailing) {
            ForEach(Array(filters.enumerated()), id: \.offset) { index, filter in
                if appears[index] {
                    Button(action: {
                        withAnimation {
                            showSelectGeneration.toggle()
//                            showFilter = false
                        }
                    }, label: {
                        HStack {
                            Text(filter.title)
                                .customFont(.subheadline2)
                                .foregroundColor(.primary)
                            Image(systemName: filter.imageName)
                                .customFont(.subheadline2)
                                .foregroundColor(Color(hex: "#6b79dc"))
                        }
                    })
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(.white)
                    .mask { RoundedRectangle(cornerRadius: 20, style: .continuous) }
                    .transition(.asymmetric(insertion: .move(edge: .trailing),
                                            removal: .opacity))
                }
            }
            
            Button(action: action) {
                Image(systemName: showFilter ? "xmark" : "slider.horizontal.3")
                    .customFont(.title2)
                    .foregroundColor(.white.opacity(0.6))
                    .frame(width: 55, height: 55)
                    .background(Color(hex: "#6b79dc"))
                    .mask { Circle() }
                    .shadow(radius: 20, x: 0, y: 10)
            }
            .allowsHitTesting(enableAction)
            .padding(.top, 20)
        }
        .onChange(of: showFilter) { newValue in
            if newValue {
                fadeIn()
            } else {
                fadeOff()
            }
        }
        .sheet(isPresented: $showSelectGeneration) {
            GenerationView(generation: .constant(.I))
            .presentationDetents([.fraction(0.5), .fraction(0.9)])
        }
    }
    
    private func action() {
        withAnimation(.linear) {
            showFilter.toggle()
        }
    }
    
    private func fadeIn() {
        for (index, _) in appears.enumerated() {
            withAnimation(.spring().delay( (0.05 * Double(index)))) {
                appears[3 - index].toggle()
            }
        }
    }
    
    private func fadeOff() {

        withAnimation() {
            for (index, _) in appears.enumerated() {
                appears[index].toggle()
            }
        }
    }
}

struct PokedexView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            PokedexView()
        }
    }
}
