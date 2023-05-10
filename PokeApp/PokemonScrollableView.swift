//
//  PokemonScrollableView.swift
//  PokeApp
//
//  Created by Felipe Correa on 8/05/23.
//

import SwiftUI

struct PokemonScrollableView: View {
    
    @State private var scrollEffectValue: Double = 13
    @State private var activePageIndex: Int = 0
    
    let itemWidth: CGFloat = 260
    let itemPadding: CGFloat = 20
    
    var body: some View {
        
        GeometryReader { geometry in
            AdaptivePagingScrollView(currentPageIndex: self.$activePageIndex,
                                     itemsAmount: 5,
                                     itemWidth: self.itemWidth,
                                     itemPadding: self.itemPadding,
                                     pageWidth: geometry.size.width) {
                ForEach(0..<5) { card in
                    GeometryReader { screen in
                        Image("bulbasaur")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 150, height: 150)
                            .background(Color.blue)
//                            .scaleEffect(calculateScale(geometry: geometry))
//                            .rotation3DEffect(Angle(degrees: (Double(screen.frame(in: .global).minX) - 20) / -15),
//                                              axis: (x: 0, y: 90.0, z: 0))
                        
//                            .scaleEffect(activePageIndex == onboardData.cards.firstIndex(of: card) ?? 0 ? 1.05 : 1)
                    }
                    .frame(width: self.itemWidth, height: 600)
                }
            }
        }
        
//        TabView {
//            ForEach(/*@START_MENU_TOKEN@*/0 ..< 5/*@END_MENU_TOKEN@*/) { item in
//                GeometryReader { m in
//                    HStack(spacing: 16.0) {
//                        Spacer()
//                        Image("bulbasaur")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 150, height: 150)
//                            .background(Color.blue)
//                            .scaleEffect(calculateScale(geometry: m))
//
//                        Spacer()
//                    }
//                }
//            }
//        }
//        .frame(height: 150)
//        .background(Color.red)
//        .tabViewStyle(.page(indexDisplayMode: .never))
    }
    
    func calculateScale(geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).midX
        let screenWidth = geometry.frame(in: .global).width
        let distanceFromCenter = abs(screenWidth / 2 - offset)
        let scale = min(max(1 - distanceFromCenter / screenWidth, 0.7), 1.0)
        return scale
    }
}

struct PokemonScrollableView2: View {

    @State private var currentPage = 0

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 60) {
                    ForEach(0..<4) { _ in
                        Image("bulbasaur")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 150)
                            .background(Color.blue)
//                            .frame(width: geometry.size.width)
                    }
                }
                .frame(width: geometry.size.width)
                .offset(x: -CGFloat(currentPage) * geometry.size.width, y: 0)
                .animation(.easeInOut(duration: 0.3))
            }
            .gesture(DragGesture()
                .onEnded({ value in
                    let offset = value.translation.width / geometry.size.width
                    let newIndex = (CGFloat(currentPage) - offset).rounded()
                    currentPage = max(min(Int(newIndex), 3 - 1), 0)
                })
            )
        }
    }
}

struct PokemonScrollableView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonScrollableView()
    }
}

struct AdaptivePagingScrollView: View {
    
    private let items: [AnyView]
    private let itemPadding: CGFloat
    private let itemSpacing: CGFloat
    private let itemWidth: CGFloat
    private let itemsAmount: Int
    private let contentWidth: CGFloat
    
    private let leadingOffset: CGFloat
    private let scrollDampingFactor: CGFloat = 0.66
    
    @Binding var currentPageIndex: Int
    
    @State private var currentScrollOffset: CGFloat = 0
    @State private var gestureDragOffset: CGFloat = 0
        
    private func countOffset(for pageIndex: Int) -> CGFloat {
        
        let activePageOffset = CGFloat(pageIndex) * (itemWidth + itemPadding)
        return leadingOffset - activePageOffset
    }
    
    private func countPageIndex(for offset: CGFloat) -> Int {
        
        guard itemsAmount > 0 else { return 0 }
        
        let offset = countLogicalOffset(offset)
        let floatIndex = (offset)/(itemWidth + itemPadding)
        
        var index = Int(round(floatIndex))
        if max(index, 0) > itemsAmount {
            index = itemsAmount
        }
        
        return min(max(index, 0), itemsAmount - 1)
    }
    
    private func countCurrentScrollOffset() -> CGFloat {
        return countOffset(for: currentPageIndex) + gestureDragOffset
    }
    
    private func countLogicalOffset(_ trueOffset: CGFloat) -> CGFloat {
        return (trueOffset-leadingOffset) * -1.0
    }
    
    init<A: View>(currentPageIndex: Binding<Int>,
                  itemsAmount: Int,
                  itemWidth: CGFloat,
                  itemPadding: CGFloat,
                  pageWidth: CGFloat,
                  @ViewBuilder content: () -> A) {
        
        let views = content()
        self.items = [AnyView(views)]
        
        self._currentPageIndex = currentPageIndex
         
        self.itemsAmount = itemsAmount
        self.itemSpacing = itemPadding
        self.itemWidth = itemWidth
        self.itemPadding = itemPadding
        self.contentWidth = (itemWidth+itemPadding)*CGFloat(itemsAmount)
        
        let itemRemain = (pageWidth-itemWidth-2*itemPadding)/2
        self.leadingOffset = itemRemain + itemPadding
    }
    
    
    var body: some View {
        GeometryReader { viewGeometry in
            HStack(alignment: .center, spacing: itemSpacing) {
                ForEach(items.indices, id: \.self) { itemIndex in
                    items[itemIndex].frame(width: itemWidth)
                }
            }
        }
        .onAppear {
            currentScrollOffset = countOffset(for: currentPageIndex)
        }
        .background(Color.black.opacity(0.00001)) // hack - this allows gesture recognizing even when background is transparent
        .frame(width: contentWidth)
        .offset(x: self.currentScrollOffset, y: 0)
        .simultaneousGesture(
            DragGesture(minimumDistance: 1, coordinateSpace: .local)
                .onChanged { value in
                    gestureDragOffset = value.translation.width
                    currentScrollOffset = countCurrentScrollOffset()
                }
                .onEnded { value in
                    let cleanOffset = (value.predictedEndTranslation.width - gestureDragOffset)
                    let velocityDiff = cleanOffset * scrollDampingFactor
                    
                    var newPageIndex = countPageIndex(for: currentScrollOffset + velocityDiff)
                    
                    let currentItemOffset = CGFloat(currentPageIndex) * (itemWidth + itemPadding)
                    
                    if currentScrollOffset < -(currentItemOffset),
                       newPageIndex == currentPageIndex {
                        newPageIndex += 1
                    }
                    
                    gestureDragOffset = 0
                    
                    withAnimation(.interpolatingSpring(mass: 0.1,
                                                       stiffness: 20,
                                                       damping: 1.5,
                                                       initialVelocity: 0)) {
                        self.currentPageIndex = newPageIndex
                        self.currentScrollOffset = self.countCurrentScrollOffset()
                    }
                }
        )
    }
}
