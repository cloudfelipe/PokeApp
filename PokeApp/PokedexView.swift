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
    
    let pokemons = Pokemon.loadData()
    
    var body: some View {
        
        ZStack {
            Color.white
                .ignoresSafeArea()
                .zIndex(0)
            
            list
                .overlay {
                    Rectangle()
                        .fill(.white.opacity(0.4))
                        .frame(height: 50.0)
                        .background(.ultraThinMaterial)
                        .blur(radius: 3)
                        .opacity(0.9)
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                    
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
    
    var columns: [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 16), count: 2)
    }
    
    var list: some View {
        ScrollView(showsIndicators: false) {
            
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
        .padding()
        .zIndex(0)
    }
    
    private func fadeIn() {
        withAnimation(.easeInOut) {
            isShown.toggle()
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
