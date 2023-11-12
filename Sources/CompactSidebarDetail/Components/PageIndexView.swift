//
//  PageIndexView.swift
//  HorizontalSwipe
//
//  Created by Kaï-Zen Fœnyx Krysies Berg-Šæmañn on 2023-11-06.
//

import SwiftUI

struct PageIndexView<P: Hashable, Content: View>: View {
    @Binding var pages: [P]
    @Binding var selection: P?
    @ViewBuilder let content: (P) -> Content

    var body: some View {
        ScrollViewReader { scrollProxy in
            List(pages, id: \.self, selection: $selection) { page in
                content(page)
                    .listRowSeparator(.hidden)
                    .listRowBackground(page == selection ? Color.accentColor : .clear)
                    .id(page)
            }
            .scrollTargetBehavior(.paging)
            .scrollContentBackground(.hidden)
            .onAppear {
                withAnimation {
                    scrollProxy.scrollTo(selection, anchor: .center)
                }
            }
            .onChange(of: selection) {
                withAnimation {
                    scrollProxy.scrollTo(selection, anchor: .center)
                }
            }
        }
    }
}

#if DEBUG
struct PageIndexViewPreview: View {
    @State var pages = Array(1..<50)
    @State var selection: Int? = 25

    var body: some View {
        PageIndexView(pages: $pages, selection: $selection) { n in
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(.red)
                .overlay {
                    Text("\(n)")
                }
        }
    }
}

#Preview {
    PageIndexViewPreview()
}

#endif
