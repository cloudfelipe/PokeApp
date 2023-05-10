//
//  TextView.swift
//  PokeApp
//
//  Created by Felipe Correa on 6/05/23.
//

import SwiftUI

struct TextView: View {
    
    @Namespace var nameSpace
    @State var shown = false
    
    var body: some View {
        ZStack {
            if !shown {
                VStack(alignment: .leading, spacing: 12.0) {
                    Text("SwiftUI")
                        .font(.largeTitle.weight(.bold))
                        .matchedGeometryEffect(id: "title", in: nameSpace)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Very nice app".uppercased())
                        .font(.footnote.weight(.semibold))
                        .matchedGeometryEffect(id: "subtitle", in: nameSpace)
                    Text("This text will disappear")
                        .font(.footnote)
                        .matchedGeometryEffect(id: "notes", in: nameSpace)
                }
                .padding(20)
                .foregroundColor(.white)
                .background(
                    Color.red
                        .matchedGeometryEffect(id: "background", in: nameSpace)
                )
                .padding(20)
            } else {
                VStack(alignment: .leading, spacing: 12.0) {
                    Spacer()
                    Text("Very nice app".uppercased())
                        .font(.footnote.weight(.semibold))
                        .matchedGeometryEffect(id: "subtitle", in: nameSpace)
                    Text("SwiftUI")
                        .font(.largeTitle.weight(.bold))
                        .matchedGeometryEffect(id: "title", in: nameSpace)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(20)
                .foregroundColor(.black)
                .background(
                    Color.blue
                        .matchedGeometryEffect(id: "background", in: nameSpace)
                )
            }
        }
        .onTapGesture {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                shown.toggle()
            }
        }
    }
}

struct TextView_Previews: PreviewProvider {
    static var previews: some View {
        TextView()
    }
}
