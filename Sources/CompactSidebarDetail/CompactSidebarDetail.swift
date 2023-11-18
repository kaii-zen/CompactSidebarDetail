// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct CompactSidebarDetail<Item, Thumbnail, Detail, DetailPlaceholder, Backdrop>: View
where Item: Hashable,
      Thumbnail: View,
      Detail: View,
      DetailPlaceholder: View,
      Backdrop: View
{
    public var items: [Item]
    @Binding public var selection: Item?
    public let thumbnail: (Item) -> Thumbnail
    public let detail: (Item) -> Detail
    public let detailPlaceholder: () -> DetailPlaceholder
    public let backdrop: () -> Backdrop

    @State private var sidebarScrollPosition: Item?
    @State private var detailScrollPosition: Item?

    public init(_ items: [Item],
                selection: Binding<Item?>,
                @ViewBuilder thumbnail: @escaping (Item) -> Thumbnail,
                @ViewBuilder detail: @escaping (Item) -> Detail,
                @ViewBuilder detailPlaceholder: @escaping () -> DetailPlaceholder = { EmptyView() },
                @ViewBuilder backdrop: @escaping () -> Backdrop = { EmptyView() }
    ) {
        self.items = items
        self._selection = selection
        self.thumbnail = thumbnail
        self.detail = detail
        self.detailPlaceholder = detailPlaceholder
        self.backdrop = backdrop
    }
    
    public var body: some View {
        GeometryReader { geo in
            HStack {
                if !items.isEmpty {
                    PageIndexView(items: items, selection: $selection, scrollPosition: $sidebarScrollPosition) {
                        thumbnail($0)
                    }
                    .animation(.default, value: items)
                    .frame(width: geo.size.width * 0.3)
                    .zIndex(1.0)
                    .transition(.move(edge: .leading))

                    HorizontalPagingView(items: items, scrollPosition: $detailScrollPosition) {
                        detail($0)
                    }
                    .scrollClipDisabled()
                } else {
                    detailPlaceholder()
                }
            }
            .background {
                backdrop()
            }
            .task(id: selection) {
                withAnimation {
                    sidebarScrollPosition = selection
                    detailScrollPosition = selection
                }
            }
            .task(id: detailScrollPosition) {
                withAnimation {
                    selection = detailScrollPosition
                }
            }
        }
    }
}

#if DEBUG
fileprivate struct Preview: View {
    @State var items = Array(1..<50)
    @State var selection: Int?

    var body: some View {
        CompactSidebarDetail(items, selection: $selection) { n in
            let selected = n == selection
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(selected ? .red : .black)
                .overlay {
                    Text("\(n)")
                        .foregroundStyle(selected ? .black : .red)
                }
                .padding()
        } detail: { n in
            Rectangle()
                .overlay {
                    Text("Page \(n)")
                        .foregroundStyle(.red)
                }
                .padding()
        } backdrop: {
            Color.red
                .ignoresSafeArea()
        }
    }
}

#Preview {
    Preview()
}
#endif
