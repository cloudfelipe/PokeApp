//
//  PokemonStatsView.swift
//  PokeApp
//
//  Created by Felipe Correa on 8/05/23.
//

import SwiftUI
 
enum PokemonDetailTab: String, CaseIterable, Identifiable {
    case about
    case baseStats
    case evolution
    case moves
    
    var title: String {
        switch self {
        case .about:
            return "About"
        case .baseStats:
            return "Base Stats"
        case .evolution:
            return "Evolution"
        case .moves:
            return "Moves"
        }
    }
    
    var id: String {
        return self.rawValue
    }
}

struct PokemonStatsTabView: View {
    
    @Binding var selectedTab: PokemonDetailTab
    
    var body: some View {
        HStack {
            content
        }
        .padding(.vertical)
        .mask {
            RoundedRectangle(cornerRadius: 24.0, style: .continuous)
        }
    }
    
    private var content: some View {
        ForEach(PokemonDetailTab.allCases) { tabItem in
            Button {
                withAnimation(.easeOut) {
                    selectedTab = tabItem
                }
            } label: {
                Text(tabItem.title)
                    .customFont(.subheadline2)
                    .foregroundColor(.black)
                    .opacity(selectedTab == tabItem ? 1 : 0.5)
                    .background(
                        VStack (spacing: 15.0){
                            Spacer()
                            RoundedRectangle(cornerRadius: 2)
                                .foregroundColor(.purple.opacity(0.7))
                                .frame(width: selectedTab == tabItem ? 50.0 : 0.0, height: 4.0)
                                .offset(y: 8)
                            .opacity(selectedTab == tabItem ? 1 : 0.0)
                        }
                    )
            }
            .frame(maxWidth: .infinity, idealHeight: 40.0)
            
        }
    }
}

struct PokemonStatsView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonStatsTabView(selectedTab: .constant(.about))
    }
}
