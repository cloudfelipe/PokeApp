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
            ScrollViewReader { reader in
                ScrollView {
                    
//                    scrollDetection
                    
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
//                    .onAppear {
//                        if let id = selectedPkmn?.id {
//                            reader.scrollTo(id, anchor: .center)
//                        }
//                    }
                }
                .coordinateSpace(name: "scroll")
                .onPreferenceChange(ScrollPreferenceKey.self) { value in
                    withAnimation(.easeInOut) {
                        self.hasScrolled = value < 0
                    }
                }
                .safeAreaInset(edge: .top) {
                    Color.clear.frame(height: 70.0)
                }
                .overlay {
                    headerView
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                }
            }
            
        } else {
            PokemonDetailView(namespace: namespace,
                              pokemon: selectedPkmn!,
                              isShown: $shown
            )
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Pokedex")
                .customFont(.largeTitle)
            Spacer()
        }
        .padding(16.0)
        .background(content: {
            if hasScrolled {
                Color.clear
                    .background(.ultraThinMaterial)
            } else {
                Color.clear
            }
        })
    }
    
    private var scrollDetection: some View {
        GeometryReader { proxy in
            Color.clear
                .preference(key: ScrollPreferenceKey.self,
                            value: proxy.frame(in: .named("scroll")).minY)
        }
        .frame(height: 0)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
