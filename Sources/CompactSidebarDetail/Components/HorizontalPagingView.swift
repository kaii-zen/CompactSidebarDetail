//
//  HorizontalPagingView.swift
//  HorizontalSwipe
//
//  Created by Kaï-Zen Fœnyx Krysies Berg-Šæmañn on 2023-11-06.
//

import SwiftUI

struct HorizontalPagingView<P: Hashable, Content: View>: View {
    @Binding var pages: [P]
    @Binding var currentPage: P?
    @ViewBuilder let content: (P) -> Content

    var body: some View {
        GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(pages, id: \.self) {
                        content($0)
                    }
                    .frame(width: geo.size.width)
                }
                .scrollTargetLayout()
            }
            .scrollPosition(id: $currentPage)
            .scrollTargetBehavior(.viewAligned)
        }
    }
}

#if DEBUG
fileprivate struct Preview: View {
    @State var pages = Array(1..<5)
    @State var currentPage: Int?

    var body: some View {
        HorizontalPagingView(pages: $pages, currentPage: $currentPage) { n in
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
