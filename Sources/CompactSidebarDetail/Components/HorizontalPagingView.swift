//
//  HorizontalPagingView.swift
//  CompactSidebarDetail
//
//  Created by Kaï-Zen Fœnyx Krysies Berg-Šæmañn on 2023-11-06.
//

import SwiftUI

struct HorizontalPagingView<Item: Hashable, Content: View>: View {
    var items: [Item]
    @Binding var scrollPosition: Item?
    @ViewBuilder let content: (Item) -> Content


    var body: some View {
        ScrollView(.horizontal) {
            LazyHStack {
                ForEach(items, id: \.self) { item in
                    content(item)
                        .containerRelativeFrame(.horizontal)
                        .id(item)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $scrollPosition)
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicatorsFlash(trigger: items)
        .sensoryFeedback(.increase, trigger: scrollPosition)
        .task(id: items.count) {
            if scrollPosition == nil {
                scrollPosition = items.first
            }
        }
    }
}

#if DEBUG
fileprivate struct Preview: View {
    @State var pages = Array(1..<5)
    @State var scrollPosition: Int?

    var body: some View {
        NavigationStack {
            HorizontalPagingView(items: pages,
                                 scrollPosition: $scrollPosition) { n in
                RoundedRectangle(cornerRadius: 5)
                    .foregroundStyle(.red)
                    .overlay {
                        Text("\(n)")
                    }
                    .padding()
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button {
                        withAnimation {
                            pages.append(pages.count + 1)
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
}

#Preview {
    Preview()
}
#endif
