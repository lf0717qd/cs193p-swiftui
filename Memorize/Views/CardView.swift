import SwiftUI

struct CardView: View {
    let card: MemoryGame<String>.Card
    let color: Color

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Text(card.content)
                    .font(.system(size: 200))
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .cardify(isFaceUp: card.isFaceUp, color: color)
            .opacity(card.isMatched ? 0.35 : 1)
        }
    }
}
