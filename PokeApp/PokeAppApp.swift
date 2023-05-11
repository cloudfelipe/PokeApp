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
            PokemonScrollableView(itemSize: .init(width: 180, height: 180), itemPadding: 20, selectedPokemon: .constant(Pokemon.sample()))
        }
    }
}
