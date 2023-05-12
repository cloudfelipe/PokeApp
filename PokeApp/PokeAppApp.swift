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
            ContentView()
        }
    }
}

let listPokemon = Pokemon.loadData()
    .reduce(into: [String: Pokemon]()) { $0[$1.id] = $1 }
