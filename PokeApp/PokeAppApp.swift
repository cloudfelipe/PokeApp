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
                .onAppear{ Pokemon.sample()}
        }
    }
}
