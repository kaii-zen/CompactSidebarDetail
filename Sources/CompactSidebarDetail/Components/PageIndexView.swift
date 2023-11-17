//
//  PageIndexView.swift
//  HorizontalSwipe
//
//  Created by Kaï-Zen Fœnyx Krysies Berg-Šæmañn on 2023-11-06.
//

import SwiftUI

struct PageIndexView<Item: Hashable, Content: View>: View {
    @Binding var items: [Item]
    @Binding var selection: Item?
    @Binding var scrollPosition: Item?
    @ViewBuilder let content: (Item) -> Content
    
    @State private var offsets: [Item: CGFloat] = [:]

    var body: some View {
        ScrollView {
            VStack {
                ForEach(items, id: \.self) { item in
                    content(item)
                        .aspectRatio(1, contentMode: .fill)
                        .onTapGesture {
                            withAnimation {
                                selection = item
                            }
                        }
                        .offset(x: offsets[item] ?? .zero)
                        .gesture(
                            DragGesture(minimumDistance: 1)
                                .onChanged { gesture in
                                    guard gesture.translation.width < 0 else { return }
                                    offsets[item] = gesture.translation.width
                                }
                                .onEnded { gesture in
                                    if gesture.predictedEndTranslation.width < -50 {
                                        withAnimation {
                                            items.removeAll { $0 == item }
                                        }
                                    } else {
                                        withAnimation {
                                            offsets[item] = .zero
                                        }
                                    }
                                }
                        )
                    //                                .id(item)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(id: $scrollPosition, anchor: .center)
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicatorsFlash(trigger: items)
        .sensoryFeedback(.increase, trigger: scrollPosition)
        .background {
                Rectangle()
                    .foregroundStyle(.ultraThinMaterial)
                    .ignoresSafeArea()
        }
    }
}

#if DEBUG
fileprivate struct Preview: View {
    @State var pages = Array(1..<50)
    @State var selection: Int?
    @State var scrollPosition: Int?

    var body: some View {
        PageIndexView(items: $pages,
                      selection: $selection,
                      scrollPosition: $scrollPosition) { n in
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
