//
//  HorizontalPagingView.swift
//  CompactSidebarDetail
//
//  Created by Kaï-Zen Fœnyx Krysies Berg-Šæmañn on 2023-11-06.
//

import SwiftUI

struct HorizontalPagingView<Item: Hashable, Content: View>: View {
    var items: [Item]
    @Binding var selection: Item?
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
        .scrollPosition(id: $selection)
        .scrollTargetBehavior(.viewAligned)
    }
}

#if DEBUG
fileprivate struct Preview: View {
    @State var pages = Array(1..<5)
    @State var currentPage: Int?

    var body: some View {
        HorizontalPagingView(items: pages, selection: $currentPage) { n in
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(.red)
                .overlay {
                    Text("\(n)")
                }
                .padding()
        }
    }
}

#Preview {
    Preview()
}
#endif
