//
//  PokemonEvolutionView.swift
//  PokeApp
//
//  Created by Felipe Correa on 11/05/23.
//

import SwiftUI

struct PokemonEvolutionView: View {
    
    let pokemon: Pokemon
    
    var list: [Pokemon] {
        pokemon.evolutions
            .compactMap { listPokemon[$0] }
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Evolution Chain")
                .customFont(.title2)
                .padding(.bottom, 20.0)
            
            if list.count == 1 {
                HStack {
                    PokemonGrid(pokemon: pokemon)
                }
                .frame(maxWidth: .infinity)
                .padding()
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        ForEach(list) { pkm in
                            if let previous = listPokemon[pkm.evolvedFrom] {
                                PokemonEvolutionGrid(pokemon1: previous, pokemon2: pkm)
                                Divider()
                                    .padding()
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
            }
        }
    }
}

private struct PokemonGrid: View {
    
    let pokemon: Pokemon
    
    var body: some View {
        VStack {
            Image("pokeball")
                .resizable()
                .opacity(0.04)
                .frame(width: 100, height: 100)
                .overlay {
                    CachedAsyncImage(url: URL(string: pokemon.imageUrl)!) { image in
                        image.resizable()
                            .frame(width: 90, height: 90)
                    }
                    
                }
            Text(pokemon.name)
                .customFont(.title3)
        }
    }
}

private struct PokemonEvolutionGrid: View {
    let pokemon1: Pokemon
    let pokemon2: Pokemon
    
    var body: some View {
        HStack {
            PokemonGrid(pokemon: pokemon1)
            
            Spacer()
            VStack {
                Image(systemName: "arrow.right")
                    .customFont(.headline)
                    .opacity(0.3)
                Text(pokemon2.reason)
                    .customFont(.subheadline2)
            }
            Spacer()
            
            PokemonGrid(pokemon: pokemon2)
        }
    }
}

struct PokemonEvolutionView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonEvolutionView(pokemon: listPokemon["#069"]!)
    }
}
