import SwiftUI

/// 在给定空间内，用最少的列数铺满，同时保持每张卡片的宽高比（A3 的 AspectVGrid 思路）。
struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    private let items: [Item]
    private let aspectRatio: CGFloat
    private let content: (Item) -> ItemView

    init(_ items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            let itemWidth = widthThatFits(count: items.count, in: geometry.size, at: aspectRatio)
            LazyVGrid(columns: [GridItem(.adaptive(minimum: itemWidth), spacing: 0)], spacing: 0) {
                ForEach(items) { item in
                    content(item)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                }
            }
        }
    }

    private func widthThatFits(count: Int, in size: CGSize, at aspectRatio: CGFloat) -> CGFloat {
        guard count > 0, size.width > 0, size.height > 0 else { return 40 }
        let count = CGFloat(count)
        var columnCount: CGFloat = 1
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height <= size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
}
