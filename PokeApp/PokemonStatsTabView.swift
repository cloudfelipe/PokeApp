//
//  PokemonStatsView.swift
//  PokeApp
//
//  Created by Felipe Correa on 8/05/23.
//

import SwiftUI

private enum Tab: String, CaseIterable, Identifiable {
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
    
    @State private var selectedTab: Tab = .about
    
    var body: some View {
        VStack {
            HStack {
                content
            }
            .padding(8.0)
            .mask {
                RoundedRectangle(cornerRadius: 24.0, style: .continuous)
            }
            Spacer()
        }
    }
    
    private var content: some View {
        ForEach(Tab.allCases) { tabItem in
            Button {
                withAnimation {
                    selectedTab = tabItem
                }
            } label: {
                Text(tabItem.title)
                    .font(.subheadline.weight(.semibold))
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
            .frame(maxWidth: .infinity, minHeight: 40.0)
        }
    }
}

struct PokemonStatsView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonStatsTabView()
    }
}
