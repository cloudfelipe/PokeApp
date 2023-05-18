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
    
    @State private var selectedTabItemFrame: CGRect = .zero
    @State private var tabItemFrames: [CGRect] = [.zero,.zero,.zero,.zero]
    
    var body: some View {
        HStack {
            content
        }
        .overlay (
            overlay
        )
        .coordinateSpace(name: "TabView")
    }
    
    private var content: some View {
        ForEach(Array(PokemonDetailTab.allCases.enumerated()), id: \.offset) { index, tabItem in
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                    self.selectedTab = tabItem
                    self.selectedTabItemFrame = tabItemFrames[index]
                }
            } label: {
                Text(tabItem.title)
                    .customFont(.subheadline2)
                    .frame(height: 40.0)
                    .overlay {
                        GeometryReader { proxy in
                            let frame = proxy.frame(in: .named("TabView"))
                            Color.clear
                                .preference(key: TabBarItemPreferenceFrameKey.self, value: frame)
                                .onPreferenceChange(TabBarItemPreferenceFrameKey.self) { value in
                                    tabItemFrames[index] = value
                                    //used for positioning first element when first run
                                    if selectedTab == tabItem {
                                        self.selectedTabItemFrame = tabItemFrames[index]
                                    }
                                }
                        }
                    }
            }
            .foregroundColor( selectedTab == tabItem ? .primary : .secondary)
            
            //TODO: Calculate last index instead to check item directly
            if tabItem != .moves { Spacer() }
        }
        
    }
    
    private var overlay: some View {
        HStack {
            RoundedRectangle(cornerRadius: 2)
                .foregroundColor(.purple.opacity(0.7))
                .frame(width: selectedTabItemFrame.width, height: 4.0)
                .position(x: selectedTabItemFrame.midX, y: selectedTabItemFrame.maxY)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
    }
}

private struct TabBarItemPreferenceFrameKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

struct PokemonStatsView_Previews: PreviewProvider {
    
    static var previews: some View {
        PokemonStatsTabView(selectedTab: .constant(.about))
    }
}
