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
    @Binding public var items: [Item]
    @Binding public var selection: Item?
    public let thumbnail: (Item) -> Thumbnail
    public let detail: (Item) -> Detail
    public let detailPlaceholder: () -> DetailPlaceholder
    public let backdrop: () -> Backdrop

    public init(_ items: Binding<[Item]>,
                selection: Binding<Item?>,
                @ViewBuilder thumbnail: @escaping (Item) -> Thumbnail,
                @ViewBuilder detail: @escaping (Item) -> Detail,
                @ViewBuilder detailPlaceholder: @escaping () -> DetailPlaceholder = { EmptyView() },
                @ViewBuilder backdrop: @escaping () -> Backdrop = { EmptyView() }
    ) {
        self._items = items
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
                    PageIndexView(items: $items, selection: $selection) {
                        thumbnail($0)
                    }
                    .frame(width: geo.size.width * 0.3)
                    .zIndex(1.0)
                    .transition(.move(edge: .leading))
                    HorizontalPagingView(items: items, selection: $selection) {
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
            .animation(.default, value: selection)
        }
    }
}

#if DEBUG
fileprivate struct Preview: View {
    @State var items = Array(1..<50)
    @State var selection: Int?

    var body: some View {
        CompactSidebarDetail($items, selection: $selection) { n in
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
