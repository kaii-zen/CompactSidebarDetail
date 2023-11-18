// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct CompactSidebarDetail<Item, Thumbnail, Detail, DetailPlaceholder>: View
where Item: Hashable,
      Thumbnail: View,
      Detail: View,
      DetailPlaceholder: View
{
    public var items: [Item]
    @Binding public var selection: Item?
    @Binding public var hidingSidebar: Bool
    public let thumbnail: (Item) -> Thumbnail
    public let detail: (Item) -> Detail
    public let detailPlaceholder: () -> DetailPlaceholder

    @State private var sidebarScrollPosition: Item?
    @State private var detailScrollPosition: Item?

    public init(_ items: [Item],
                selection: Binding<Item?>,
                hidingSidebar: Binding<Bool> = .constant(false),
                @ViewBuilder thumbnail: @escaping (Item) -> Thumbnail,
                @ViewBuilder detail: @escaping (Item) -> Detail,
                @ViewBuilder detailPlaceholder: @escaping () -> DetailPlaceholder = { EmptyView() }
    ) {
        self.items = items
        self._selection = selection
        self._hidingSidebar = hidingSidebar
        self.thumbnail = thumbnail
        self.detail = detail
        self.detailPlaceholder = detailPlaceholder
    }
    
    public var body: some View {
        HStack {
            if items.isEmpty {
                detailPlaceholder()
            } else {
                if !hidingSidebar {
                    PageIndexView(items: items, selection: $selection, scrollPosition: $sidebarScrollPosition) {
                        thumbnail($0)
                    }
                    .transition(.move(edge: .leading).combined(with: .opacity))
                    .containerRelativeFrame(.horizontal, { length, _ in
                        length / 3.0
                    })
                    .zIndex(1.0)
                }

                HorizontalPagingView(items: items, scrollPosition: $detailScrollPosition) {
                    detail($0)
                }
                .scrollClipDisabled()
            }
        }
        .animation(.default, value: items)
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

#if DEBUG
fileprivate struct Preview: View {
    @State var items = Array(1..<50)
    @State var selection: Int?
    @State var hidingSidebar = false

    var body: some View {
        CompactSidebarDetail(items, selection: $selection, hidingSidebar: $hidingSidebar) { n in
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
                    VStack {
                        Text("Page \(n)")
                        Text("Double tap to hide sidebar")
                            .font(.caption)
                    }
                    .foregroundStyle(.red)
                }
                .padding()
                .onTapGesture(count: 2) {
                    withAnimation {
                        hidingSidebar.toggle()
                    }
                }
        }
        .background {
            Color.red
                .ignoresSafeArea()
        }
    }
}

#Preview {
    Preview()
}
#endif
