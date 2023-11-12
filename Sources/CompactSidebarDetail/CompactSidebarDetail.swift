// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct CompactSidebarDetail<Item: Hashable, Thumbnail: View, Detail: View>: View {
    public var items: [Item]
    @Binding public var selection: Item?
    @ViewBuilder public var thumbnail: (Item) -> Thumbnail
    @ViewBuilder public var detail: (Item) -> Detail

    public init(_ items: [Item],
                selection: Binding<Item?>,
                thumbnail: @escaping (Item) -> Thumbnail,
                detail: @escaping (Item) -> Detail) {
        self.items = items
        self._selection = selection
        self.thumbnail = thumbnail
        self.detail = detail
    }
    
    public var body: some View {
        GeometryReader { geo in
            HStack {
                PageIndexView(items: items, selection: $selection) {
                    thumbnail($0)
                }
                .frame(width: geo.size.width * 0.3)
                .background(.thinMaterial)
                .zIndex(1.0)
                HorizontalPagingView(items: items, selection: $selection) {
                    detail($0)
                }
                .scrollClipDisabled()
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
        CompactSidebarDetail(items, selection: $selection) { n in
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.black)
                .overlay {
                    Text("\(n)")
                        .foregroundStyle(.red)
                }
                .padding()
        } detail: { n in
            Rectangle()
                .overlay {
                    Text("Page \(n)")
                        .foregroundStyle(.red)
                }
        }
    }
}

#Preview {
    Preview()
}
#endif
