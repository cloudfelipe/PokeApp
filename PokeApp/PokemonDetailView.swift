//
//  PokemonDetailView.swift
//  PokeApp
//
//  Created by Felipe Correa on 9/05/23.
//

import SwiftUI

struct PokemonDetailView: View {
    
    var namespace: Namespace.ID
    @Binding var isShown: Bool
    
    let pokemon: Pokemon
    
    var body: some View {
        GeometryReader { m in
            ZStack {
                Color(hex: pokemon.mainType.color)
                    .matchedGeometryEffect(id: "pkmColor \(pokemon.id)", in: namespace)

                VStack(spacing: 0.0) {
                    
                    HStack {
                        Button {
//                            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
//                                isShown.toggle()
//                            }
                            withAnimation(.easeInOut) {
                                isShown.toggle()
                            }
                        } label: {
                            Image(systemName: "arrow.backward")
                                .resizable()
                                .frame(width: 20.0, height: 20.0)
                                .foregroundColor(.white)
                        }
                        Spacer()
                        Button {
                            
                        } label: {
                            Image(systemName: "heart")
                                .resizable()
                                .frame(width: 20.0, height: 20.0)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.bottom, 15.0)
                    
                    HStack {
                        Text(pokemon.name)
                            .font(.largeTitle.weight(.bold))
                            .fontDesign(.rounded)
                            .foregroundColor(.white)
                            .matchedGeometryEffect(id: "pkmName \(pokemon.id)", in: namespace)
                        Spacer()
                        Text(pokemon.id)
                            .font(.title2.weight(.semibold))
                            .fontDesign(.rounded)
                            .foregroundColor(.white)
                            .matchedGeometryEffect(id: "pkmNumber \(pokemon.id)", in: namespace)
                    }
                    .padding(.bottom, 10.0)
                    HStack {
                        ForEach(pokemon.typeOfPokemon.suffix(2), id: \.self) { type in
                            Text(type.name)
                                .fontWeight(.medium)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 15.0)
                                .padding(.vertical, 5.0)
                                .background(
                                    RoundedRectangle(cornerRadius: 20.0)
                                        .fill(Color.white.opacity(0.3))
                                )
                                .matchedGeometryEffect(id: "pkm: \(pokemon.id) type: \(type.name)", in: namespace)
                        }
                        
                        Spacer()
                        
                        Text("\(pokemon.category) Pokemon")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .layoutPriority(1)
                    }
                    .frame(height: 30.0)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 60)
                
                GeometryReader { proxy in
                    VStack {
                        Spacer()
                        VStack {
                            Rectangle()
                                .fill(Color.white)
                                .frame(maxWidth: .infinity, maxHeight: m.size.height * 0.67)
                                .mask {
                                    RoundedRectangle(cornerRadius: 25.0)
                                }
                        }
                        .overlay {
                            VStack {
                                PokemonStatsTabView()
                                    .padding(.top, 25.0)
                                Spacer()
                            }
                        }
                    }
                    .overlay {
                        overlayImage(proxy: proxy)
                    }
                }
            }
            .mask {
                RoundedRectangle(cornerRadius: 15.0)
                    .matchedGeometryEffect(id: "mask \(pokemon.id)", in: namespace)
            }
            .ignoresSafeArea()
        }
    }
    
    @State private var pokeballRotationAngle: Double = 0.0
    @State private var animatePokeball = false
    
    func overlayImage(proxy: GeometryProxy) -> some View {
        ZStack {
            Image("pokeball")
                .resizable()
                .foregroundColor(.white.opacity(0.2))
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(pokeballRotationAngle))
                .animation(.linear(duration: 10.0).repeatForever(autoreverses: false),
                           value: pokeballRotationAngle)
                .onAppear {
                    pokeballRotationAngle = 360
//                    animatePokeball.toggle()
                }
                .offset(y: -((proxy.size.height * 0.30) / 2 ) )
            
            Image("bulbasaur")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
                .offset(y: -((proxy.size.height * 0.30) / 2 ) )
        }
    }
    
    var imageTab: some View {
        TabView {
            ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
                GeometryReader { m in
                    Image("bulbasaur")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150, height: 150)
                        .offset(y: -((m.size.height * 0.37) / 2 ) )
                        .rotation3DEffect(
                            .degrees(m.frame(in: .global).minX / -10),
                            axis: (x: 0, y: 1, z: 0))
                        .padding()
                }
            }
        }
        .frame(height: 200.0)
        .tabViewStyle(.page(indexDisplayMode: .never))
    }
}

struct PokemonDetailView_Previews: PreviewProvider {
    
    @Namespace static var namespace
    
    static var previews: some View {
        PokemonDetailView(namespace: namespace,
                          isShown: .constant(true),
                          pokemon: Pokemon.sample())
    }
}
