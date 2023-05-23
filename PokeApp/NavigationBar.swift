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
    
    var namespace: Namespace.ID
    
    let title: String
    let subtitle: String
    
    @Binding var isExpanded: Bool
    let backButtonAction: () -> Void
    let trailingButtonAction: () -> Void
    
    var body: some View {
        HStack {
            Button {
                backButtonAction()
            } label: {
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
            
            Button {
                trailingButtonAction()
            } label: {
                Label(title: {}, icon: {
                    Image(systemName: "heart")
                        .customFont(.title)
                })
            }
            .background {
                AnimatedPokeballView(animationDuration: 5.0)
                    .frame(width: 150, height: 150)
                    .opacity(isExpanded ? 0.0 : 1.0)
            }
            
        }
        .frame(height: 60.0)
        .foregroundColor(.white)
    }
}

struct NavigationBar_Previews: PreviewProvider {
    @Namespace static var namespace
    static var previews: some View {
        NavigationBar(namespace: namespace, title: "Pokemon", subtitle: "???", isExpanded: .constant(false), backButtonAction: {}, trailingButtonAction: {})
            .background(Color.secondary)
    }
}
