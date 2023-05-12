//
//  PokemonScrollableView.swift
//  PokeApp
//
//  Created by Felipe Correa on 8/05/23.
//

import SwiftUI

struct PokemonScrollableView: View {
    
    @State private var scrollEffectValue: Double = 13
    @State private var activePageIndex: Int = 0
    
    let itemSize: CGSize
    let itemPadding: CGFloat
    
    @Binding var selectedPokemon: Pokemon
    
    var pokemons: [Pokemon] {
        Pokemon.loadData()
            .prefix(10)
            .map { $0 }
    }
    
    var body: some View {

        TabView(selection: $selectedPokemon.animation(.easeInOut)) {
            ForEach(pokemons) { item in
                GeometryReader { m in
                    
                    let position = distanceFromCenter(geometry: m) * 2
                    
                    HStack(spacing: 16.0) {
                        Spacer()
                        
                        CachedAsyncImage(url: URL(string: item.imageUrl)!) { image in
                            ZStack {
                                image.resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(Color.black.opacity(position))
                                image.resizable()
                                    .opacity( 1 - position)
                            }
                            .aspectRatio(contentMode: .fit)
                            .frame(width: itemSize.width, height: itemSize.height)
                            .scaleEffect(calculateScale(geometry: m))
                        }
                        
                        Spacer()
                    }
                }
                .tag(item)
            }
        }
        .onChange(of: selectedPokemon, perform: { newValue in
            print(newValue.id)
        })
        .tabViewStyle(.page(indexDisplayMode: .never))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
        
    func distanceFromCenter(geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).midX
        let screenWidth = geometry.frame(in: .global).width
        return abs(screenWidth / 2 - offset) / screenWidth
    }
    
    func calculateScale(geometry: GeometryProxy) -> CGFloat {
        let scale = min(max(1 - distanceFromCenter(geometry: geometry), 0.6), 1.0)
        return scale
    }
}

struct PokemonScrollableView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonScrollableView(itemSize: .init(width: 260, height: 260),
                              itemPadding: 20,
                              selectedPokemon: .constant(Pokemon.sample()))
    }
}
