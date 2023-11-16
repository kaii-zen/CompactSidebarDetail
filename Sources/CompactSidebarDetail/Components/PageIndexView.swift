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
    @ViewBuilder var content: (Item) -> Content

    var body: some View {
        ZStack {
            Rectangle()
                .ignoresSafeArea()
                .foregroundStyle(.ultraThinMaterial)
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(items, id: \.self) { item in
                            content(item)
                                .containerRelativeFrame(
                                    .vertical, count: 5, span: 1, spacing: 0)
                                .onTapGesture {
                                    selection = item
                                }
                                .animation(.easeInOut, value: selection)
                                .id(item)
                        }
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
}

#if DEBUG
fileprivate struct Preview: View {
    @State var pages = Array(1..<50)
    @State var selection: Int? = 25

    var body: some View {
        PageIndexView(items: pages, selection: $selection) { n in
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(.red)
                .overlay {
                    Text("\(n)")
                }
        }
    }
}

#Preview {
    Preview()
}

#endif
