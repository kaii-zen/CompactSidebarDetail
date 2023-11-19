//
//  PageIndexView.swift
//  HorizontalSwipe
//
//  Created by Kaï-Zen Fœnyx Krysies Berg-Šæmañn on 2023-11-06.
//

import SwiftUI

struct PageIndexView<Item: Hashable, Content: View>: View {
    var items: [Item]
    @Binding var selection: Item?
    @Binding var scrollPosition: Item?
    @ViewBuilder let content: (Item) -> Content
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(items, id: \.self) { item in
                    content(item)
                        .aspectRatio(1, contentMode: .fill)
                        .onTapGesture {
                            withAnimation {
                                selection = item
                            }
                        }
                        .id(item)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $scrollPosition, anchor: .center)
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicatorsFlash(trigger: items)
        .contentMargins(.horizontal, 5, for: .scrollContent)
        .background {
            Rectangle()
                .foregroundStyle(.ultraThinMaterial)
                .ignoresSafeArea()
        }
    }
}

#if DEBUG
fileprivate struct Preview: View {
    @State var pages = Array(1..<50)
    @State var selection: Int?
    @State var scrollPosition: Int?

    var body: some View {
        ZStack {
            Color.clear
            HStack {
                PageIndexView(items: pages,
                              selection: $selection,
                              scrollPosition: $scrollPosition) { n in
                    let selected = n == selection
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(selected ? .red : .black)
                        .overlay {
                            Text("\(n)")
                                .foregroundStyle(selected ? .black : .red)
                        }
                        .padding()
                }
                .containerRelativeFrame(.horizontal) { length, _ in
                    length / 3.0
                }
                Spacer()
            }
        }
    }
}

#Preview {
    Preview()
}

#endif
