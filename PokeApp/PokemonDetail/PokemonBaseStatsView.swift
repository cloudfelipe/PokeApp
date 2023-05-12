//
//  PokemonBaseStatsView.swift
//  PokeApp
//
//  Created by Felipe Correa on 12/05/23.
//

import SwiftUI

struct PokemonBaseStatsView: View {
    
    let pokemon: Pokemon
    
    var body: some View {
        VStack(alignment: .leading) {
            gridStats
            Text("Type defenses")
                .customFont(.title2)
                .padding(.top, 20.0)
                .padding(.bottom, 10.0)
            Text("The effectiveness of each type on \(pokemon.name)")
                .customFont(.body)
                .opacity(0.3)
        }
        .padding()
    }
    
    var gridStats: some View {
        Grid(alignment: .leading) {
            gridStatItem(title: "HP", value: pokemon.hp, totalAmount: 100)
            gridStatItem(title: "Attack", value: pokemon.attack, totalAmount: 100)
            gridStatItem(title: "Defense", value: pokemon.defense, totalAmount: 100)
            gridStatItem(title: "Sp. Atk", value: pokemon.speciaAttack, totalAmount: 100)
            gridStatItem(title: "Sp. Def", value: pokemon.specialDefense, totalAmount: 100)
            gridStatItem(title: "Speed", value: pokemon.speed, totalAmount: 100)
            gridStatItem(title: "Total", value: pokemon.total, totalAmount: 999)
        }
    }
    
    private func gridStatItem(title: String, value: Double, totalAmount: Double) -> some View {
        GridRow {
            Text(title)
                .customFont(.headline)
                .opacity(0.3)
                .padding(.trailing, 20.0)
            Text(title)
                .customFont(.headline)
                .padding(.trailing, 20.0)
            ProgressBarView(value: value, totalAmount: totalAmount)
        }
    }
}

private struct ProgressBarView: View {
    
    private struct ProgressBarViewPreferenceKey: PreferenceKey {
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = nextValue()
        }
        
        static var defaultValue: CGFloat = 0.0
    }
    
    let value: Double
    let totalAmount: Double
    
    @State private var idealWidth: Double = 0.0
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16.0)
            .fill(.black.opacity(0.1))
            .overlay {
                GeometryReader { proxy in
                    let totalWidth = proxy.size.width
                    let exceededAverage = idealWidth > ( totalWidth / 2 )
                    RoundedRectangle(cornerRadius: 16.0)
                        .fill(exceededAverage ? Color.green : Color.red)
                        .frame(width: idealWidth)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .preference(key: ProgressBarViewPreferenceKey.self,
                                    value: proxy.size.width)
                }
            }
            .onPreferenceChange(ProgressBarViewPreferenceKey.self, perform: { totalWidth in
                withAnimation(.easeInOut(duration: 0.7)) {
                    guard totalAmount > 0.0 else { return }
                    self.idealWidth = ( value * totalWidth ) / totalAmount
                }
            })
            .frame(height: 5)
    }
}

struct PokemonBaseStatsView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonBaseStatsView(pokemon: listPokemon["#004"]!)
    }
}
