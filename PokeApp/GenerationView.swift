//
//  GenerationView.swift
//  PokeApp
//
//  Created by Felipe Correa on 23/05/23.
//

import SwiftUI

enum Generation: String {
    case I, II, III, IV, V, VI, VII, VIII
    
    var title: String {
        "Generation \(self.rawValue)"
    }
}

struct Starters: Identifiable {
    
    let id = UUID()
    let generation: Generation
    let starter1: String
    let starter2: String
    let starter3: String
    
    static var generations: [Starters] {
        [.init(generation: .I,
               starter1: "bulbasaur",
               starter2: "charmander",
               starter3: "squirtle"),
         
            .init(generation: .II,
               starter1: "chikorita",
               starter2: "cyndaquil",
               starter3: "totodile"),
         
            .init(generation: .III,
               starter1: "treecko",
               starter2: "torchic",
               starter3: "mudkip"),
         
            .init(generation: .IV,
               starter1: "piplup",
               starter2: "chimchar",
               starter3: "turtwig"),
         
            .init(generation: .V,
               starter1: "tepig",
               starter2: "snivy",
               starter3: "oshawott"),
         
            .init(generation: .VI,
               starter1: "froakie",
               starter2: "chespin",
               starter3: "fennekin"),
         
            .init(generation: .VII,
               starter1: "rowlet",
               starter2: "litten",
               starter3: "popplio"),
         
            .init(generation: .VIII,
               starter1: "grookey",
               starter2: "scorbunny",
               starter3: "sobble")]
    }
}

struct GenerationView: View {
    
    @Binding var generation: Generation
    
    private let colums = Array(repeating: GridItem(.flexible(), spacing: 0), count: 2)
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 30) {
                
                Text("Generation")
                    .customFont(.title2)
                
                LazyVGrid(columns: colums, spacing: 15) {
                    ForEach(Starters.generations) { starters in
                        Button {
                            withAnimation(.easeInOut) {
                                generation = starters.generation
                            }
                        } label: {
                            GenerationItemView(starters: starters)
                        }
                        .tint(.primary)
                    }
                }
            }
        }
        .padding()
        .padding(.top, 20)
        .ignoresSafeArea(.all, edges: .bottom)
    }
}

struct GenerationItemView: View {
    
    let starters: Starters
    
    var body: some View {
        VStack {
            Text(starters.generation.title)
                .customFont(.headline)
            
            HStack(spacing: 0) {
                let value = 55.0
                Image(starters.starter1)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: value, height: value)
                    .offset(x: 15)
                    
                Image(starters.starter2)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: value, height: value)
                    .zIndex(1)
                Image(starters.starter3)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: value, height: value)
                    .offset(x: -15)
            }
        }
        .padding(.vertical)
        .background {
            Image("pokeball")
                .resizable()
                .foregroundColor(.black.opacity(0.03))
                .frame(width: 100, height: 100)
                .offset(y: 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomTrailing)
        }
        .background(Color.white)
        .mask {
            RoundedRectangle(cornerRadius: 20.0, style: .continuous)
        }
        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 10)
    }
}

struct GenerationView_Previews: PreviewProvider {
    static var previews: some View {
        GenerationView(generation: .constant(.I))
    }
}
