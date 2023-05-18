//
//  ContentView.swift
//  PokeApp
//
//  Created by Felipe Correa on 5/05/23.
//

import SwiftUI

struct ContentView: View {
    
    let pokemons: [Pokemon] = Pokemon.loadData()
    let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    @Namespace private var namespace
    @State var shown = false
    
    @State private var selectedPkmn: Pokemon?
    
    @State private var hasScrolled = false
    
    var body: some View {
        if !shown {
            ScrollView {
                
                scrollDetection
                
                LazyVGrid(columns: columns, spacing: 16.0) {
                    ForEach(pokemons) { item in
                        PokemonGridItemView(namespace: namespace, pokemon: item)
                            .frame(maxWidth: .infinity, idealHeight: 150, maxHeight: .infinity)
                            .onTapGesture {
                                
                                withAnimation(.easeInOut) {
                                    
                                    selectedPkmn = item
                                    shown.toggle()
                                }
                            }
                            .id(item.id)
                    }
                }
                .padding(.horizontal, 16)
            }
            .coordinateSpace(name: "scroll")
            .safeAreaInset(edge: .top) {
                Color.clear.frame(height: 120.0)
            }
            .overlay {
                headerView
            }
            
        } else {
            PokemonDetailView(namespace: namespace,
                              pokemon: selectedPkmn!,
                              isShown: $shown
            )
        }
    }
    
    private var headerView: some View {
        NavigationBar(title: "Pokedex",
                      subtitle: "",
                      isExpanded: .constant(!hasScrolled),
                      backButtonAction: {})
            .foregroundColor(.black)
            .background(Color.white)
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.horizontal)
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
                self.hasScrolled = value < -20
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
