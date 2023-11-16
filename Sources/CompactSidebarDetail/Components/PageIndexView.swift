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
        GeometryReader { geo in
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(items, id: \.self) { item in
                            content(item)
                                .containerRelativeFrame(
                                    .vertical, count: Int(round(geo.size.height / geo.size.width)), span: 1, spacing: 0)
                                .onTapGesture {
                                    selection = item
                                }
                                .animation(.easeInOut, value: selection)
                                .id(item)
                        }
                    }
                }
                .background {
                    Rectangle()
                        .foregroundStyle(.ultraThinMaterial)
                        .ignoresSafeArea()
                }
                .task(id: selection) {
                    do {
                        try await Task.sleep(for: .milliseconds(100))
                    } catch {}
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
            let selected = n == selection
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(selected ? .red : .black)
                .overlay {
                    Text("\(n)")
                        .foregroundStyle(selected ? .black : .red)
                }
                .padding()
        }
    }
}

#Preview {
    Preview()
}

#endif
