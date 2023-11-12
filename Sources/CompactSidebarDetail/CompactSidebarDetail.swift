// The Swift Programming Language
// https://docs.swift.org/swift-book

import SwiftUI

public struct CompactSidebarDetail<P: Hashable, Thumbnail: View, Detail: View>: View {
    @Binding public var pages: [P]
    @Binding public var selection: P?
    @ViewBuilder public var thumbnail: (P) -> Thumbnail
    @ViewBuilder public var detail: (P) -> Detail

    public init(_ pages: Binding<[P]>,
                selection: Binding<P?>,
                thumbnail: @escaping (P) -> Thumbnail,
                detail: @escaping (P) -> Detail) {
        self._pages = pages
        self._selection = selection
        self.thumbnail = thumbnail
        self.detail = detail
    }
    
    public var body: some View {
        GeometryReader { geo in
            HStack {
                PageIndexView(pages: $pages, selection: $selection) {
                    thumbnail($0)
                }
                .frame(width: geo.size.width * 0.3)
                .background(.thinMaterial)
                .zIndex(1.0)
                HorizontalPagingView(pages: $pages, currentPage: $selection) {
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
    @State var pages = Array(1..<50)
    @State var selection: Int?

    var body: some View {
        CompactSidebarDetail($pages, selection: $selection) { n in
            RoundedRectangle(cornerRadius: 5)
                .foregroundStyle(.red)
                .overlay {
                    Text("\(n)")
                }
        } detail: { n in
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
