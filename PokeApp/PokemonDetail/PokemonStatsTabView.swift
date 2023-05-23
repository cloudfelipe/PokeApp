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
    
    @Namespace var namespace
    
    @Binding var selectedTab: PokemonDetailTab
    
    var body: some View {
        HStack {
            content
        }
        .coordinateSpace(name: "TabView")
    }
    
    private var content: some View {
        ForEach(PokemonDetailTab.allCases) { tabItem in
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    self.selectedTab = tabItem
                }
            } label: {
                VStack(spacing: 0.0) {
                    Text(tabItem.title)
                        .customFont(.subheadline2)
                        .padding(.vertical, 10.0)
                        .overlay {
                            GeometryReader { proxy in
                                if selectedTab == tabItem {
                                    RoundedRectangle(cornerRadius: 2)
                                        .foregroundColor(Color(hex: "#6b79dc"))
                                        .frame(width: proxy.size.width, height: 4.0)
                                        .frame(maxHeight: .infinity, alignment: .bottom)
                                        .matchedGeometryEffect(id: "tab", in: namespace)
                                }
                            }
                        }
                }
            }
            .foregroundColor( selectedTab == tabItem ? .primary : .secondary)
            
            //TODO: Calculate last index instead of checking item directly
            if tabItem != .moves { Spacer() }
        }
        
    }
}

struct PokemonStatsView_Previews: PreviewProvider {
    
    @State static var selection: PokemonDetailTab = .about
    
    static var previews: some View {
        VStack {
            PokemonStatsTabView(selectedTab: $selection)
        }
    }
}
