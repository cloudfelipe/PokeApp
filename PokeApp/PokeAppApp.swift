//
//  PokeAppApp.swift
//  PokeApp
//
//  Created by Felipe Correa on 5/05/23.
//

import SwiftUI

@main
struct PokeAppApp: App {
    var body: some Scene {
        WindowGroup {
//            NavigationBar(backButtonAction: {})
            PokedexView()
//            PokemonBaseStatsView(pokemon: listPokemon["#004"]!)
        }
    }
}

let listPokemon = Pokemon.loadData()
    .reduce(into: [String: Pokemon]()) { $0[$1.id] = $1 }
