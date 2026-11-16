import SwiftUI

/// 把任意 View「卡片化」：正面白底描边，背面填充主题色，并带翻转动画数据。
struct Cardify: ViewModifier, Animatable {
    var rotation: Double
    let color: Color

    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }

    init(isFaceUp: Bool, color: Color) {
        self.rotation = isFaceUp ? 0 : 180
        self.color = color
    }

    func body(content: Content) -> some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: Constants.cornerRadius)
            if rotation < 90 {
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: Constants.lineWidth).foregroundColor(color)
            } else {
                shape.fill(color)
            }
            content.opacity(rotation < 90 ? 1 : 0)
        }
        .rotation3DEffect(.degrees(rotation), axis: (x: 0, y: 1, z: 0))
    }

    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let lineWidth: CGFloat = 2
    }
}

extension View {
    func cardify(isFaceUp: Bool, color: Color) -> some View {
        modifier(Cardify(isFaceUp: isFaceUp, color: color))
    }
}
