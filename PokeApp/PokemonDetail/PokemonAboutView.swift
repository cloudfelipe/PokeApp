//
//  PokemonAboutView.swift
//  PokeApp
//
//  Created by Felipe Correa on 11/05/23.
//

import SwiftUI

struct PokemonAboutView: View {
    
    let pokemon: Pokemon
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 25.0) {
                Text(pokemon.xDescription)
                    .customFont(.body)
                    .layoutPriority(1)
                
                HStack(spacing: 10.0) {
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text("Height")
                            .opacity(0.3)
                        Text(pokemon.height)
                    }
                    .customFont(.body)
                    
                    Color.clear
                        .frame(width: 20.0, height: 20.0)
                    
                    VStack(alignment: .leading, spacing: 5.0) {
                        Text("Weight")
                            .opacity(0.3)
                        Text(pokemon.weight)
                            
                    }
                    .customFont(.body)
                    
                    Spacer()
                }
                .padding(16)
                .background(Color.white)
                .mask {
                    RoundedRectangle(cornerRadius: 16)
                }
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 3)
                
                header(title: "Breeding")
                
                HStack {
                    VStack(alignment: .leading, spacing: 10.0) {
                        Text("Gender")
                        Text("Egg Groups")
                        Text("Egg Cycle")
                    }
                    .customFont(.body)
                    .opacity(0.4)
                    
                    Color.clear
                        .frame(width: 20.0, height: 20.0)
                    
                    VStack(alignment: .leading, spacing: 10.0) {
                        HStack(spacing: 20.0) {
                            Label {
                                Text(pokemon.malePercentage ?? "N/A")
                            } icon: {
                                Image("male")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                            }
                            
                            Label {
                                Text(pokemon.femalePercentage ?? "N/A")
                            } icon: {
                                Image("female")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 15, height: 15)
                            }
                        }
                        
                        Text(pokemon.eggGroups)
                        
                        Text(pokemon.cycles)
                    }
                    .customFont(.body)
                }
                
                header(title: "Location")
                
                Rectangle()
                    .foregroundColor(Color.gray.opacity(0.3))
                    .frame(height: 170.0)
                    .mask {
                        RoundedRectangle(cornerRadius: 16.0)
                    }
                
                header(title: "Training")
                itemRow(title: "Base EXP", value: pokemon.baseExp)
                
                Spacer()
            }
            .padding([.horizontal, .bottom])
        }
    }
    
    private func header(title: String) -> some View {
        Text(title)
            .customFont(.title3)
    }
    
    private func itemRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .customFont(.body)
                .opacity(0.4)
            
            Color.clear
                .frame(width: 20.0, height: 20.0)
            
            Text(value)
                .customFont(.body)
        }
    }
}

struct PokemonAboutView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { proxy in
            VStack(spacing: 20.0) {
                Spacer()
                PokemonStatsTabView(selectedTab: .constant(.about))
                PokemonAboutView(pokemon: Pokemon.sample())
//                    .padding(.horizontal, 16)
                    .frame(height: 400)
            }
            .frame(height: .infinity)
        }
    }
}
