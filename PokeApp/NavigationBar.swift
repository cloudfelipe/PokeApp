//
//  NavigationBar.swift
//  PokeApp
//
//  Created by Felipe Correa on 17/05/23.
//

import SwiftUI

struct AnimatableFontModifier: AnimatableModifier {
    var textStyle: TextStyle
    
    var animatableData: TextStyle {
        get { textStyle }
        set { textStyle = newValue }
    }
    
    func body(content: Content) -> some View {
        content
            .customFont(textStyle)
    }
}

extension View {
    func animatableTextStyle(_ textStyle: TextStyle) -> some View {
        self.modifier(AnimatableFontModifier(textStyle: textStyle))
    }
}

struct NavigationBar: View {
    
    @Namespace private var namespace
    
    let title: String
    let subtitle: String
    
    @Binding var isExpanded: Bool
    let backButtonAction: () -> Void
    
    var body: some View {
        VStack(spacing: 0.0) {
            
            HStack {
                Button { backButtonAction() } label: {
                    Label(title: {}, icon: {
                        Image(systemName: "arrow.backward")
                            .customFont(.title)
                    })
                }
                
                Spacer()
                if !isExpanded {
                    Text(title)
                        .animatableTextStyle(.title)
                        .matchedGeometryEffect(id: "title", in: namespace, properties: .position)
                    Spacer()
                }
                
                Button { backButtonAction() } label: {
                    Label(title: {}, icon: {
                        Image(systemName: "heart")
                            .customFont(.title)
                    })
                }
                .overlay {
                    PokeballView(animationDuration: 5.0)
                        .frame(width: 150, height: 150)
                        .opacity(isExpanded ? 0.0: 1.0)
                }
                
            }
            .frame(height: 60.0)
            
            HStack {
                if isExpanded {
                    Text(title)
                        .animatableTextStyle(.largeTitle)
                        .matchedGeometryEffect(id: "navBarTitle:\(title)", in: namespace, properties: .position)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                if isExpanded && !subtitle.isEmpty {
                    Text(subtitle)
                        .customFont(.title2)
                        .transition(.opacity)
                        .matchedGeometryEffect(id: "navBarSubtitle:\(subtitle)",
                                               in: namespace,
                                               properties: .position)
                }
            }
        }
        .onTapGesture {
            withAnimation(.linear(duration: 0.05)) {
                isExpanded.toggle()
            }
        }
    }
}

struct NavigationBar_Previews: PreviewProvider {
    static var previews: some View {
        NavigationBar(title: "Pokemon", subtitle: "???", isExpanded: .constant(true), backButtonAction: {})
            .background(Color.secondary)
    }
}
