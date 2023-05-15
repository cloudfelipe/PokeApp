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
        ScrollView {
            VStack(alignment: .leading) {
                gridStats
                
                Text("Type defenses")
                    .customFont(.title2)
                    .padding(.top, 20.0)
                    .padding(.bottom, 10.0)
                
                Text("The effectiveness of each type on \(pokemon.name)")
                    .customFont(.body)
                    .opacity(0.3)
                    .padding(.bottom, 15.0)
                
                gridEffectiveness
            }
        }
        .padding([.horizontal, .bottom])
    }
    
    private var gridStats: some View {
        
        func gridStatItem(title: String, value: Double, totalAmount: Double) -> some View {
            GridRow {
                Text(title)
                    .customFont(.headline)
                    .opacity(0.3)
                    .padding(.trailing, 20.0)
                Text("\(Int(value))")
                    .customFont(.headline)
                    .padding(.trailing, 20.0)
                ProgressBarView(value: value, totalAmount: totalAmount)
            }
        }
        
        return Grid(alignment: .leading) {
            gridStatItem(title: "HP", value: pokemon.hp, totalAmount: 100)
            gridStatItem(title: "Attack", value: pokemon.attack, totalAmount: 100)
            gridStatItem(title: "Defense", value: pokemon.defense, totalAmount: 100)
            gridStatItem(title: "Sp. Atk", value: pokemon.speciaAttack, totalAmount: 100)
            gridStatItem(title: "Sp. Def", value: pokemon.specialDefense, totalAmount: 100)
            gridStatItem(title: "Speed", value: pokemon.speed, totalAmount: 100)
            gridStatItem(title: "Total", value: pokemon.total, totalAmount: 999)
        }
    }
    
    private var gridEffectiveness: some View {
        LazyVGrid(columns: [
            GridItem(.flexible(minimum: 50), spacing: 2.0),
            GridItem(.flexible(minimum: 50), spacing: 2.0),
            GridItem(.flexible(minimum: 50), spacing: 2.0)
        ], alignment: .leading, spacing: 15.0, content: {
            ForEach(pokemon.typeEffectiveness.sorted(by: <), id: \.key) { key, value in
                EffectivenessTagView(type: key, value: value)
            }
        })
    }
}

private struct EffectivenessTagView: View {
    
    let type: PokemonType
    let value: Double
    
    var body: some View {
        Text("\(type.name) x\(formattedValue)")
            .customFont(.footnote2)
            .foregroundColor(color)
            .padding(.horizontal, 15.0)
            .padding(.vertical, 6.0)
            .background(
                RoundedRectangle(cornerRadius: 20.0)
                    .fill(color.opacity(0.3))
            )
    }
    
    private var color: Color {
        Color(hex: type.color) ?? .black
    }
    
    private var formattedValue: String {
        (value.truncatingRemainder(dividingBy: 1) == 0) ?
            String(format: "%.0f", value) :
            String(format: "%.1f", value)
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
                    let exceededAverage = idealWidth >= ( totalWidth / 2 )
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
        PokemonBaseStatsView(pokemon: listPokemon["#001"]!)
    }
}
