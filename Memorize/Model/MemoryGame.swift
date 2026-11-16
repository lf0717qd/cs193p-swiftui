import Foundation

/// 纯逻辑的配对游戏模型，与 UI 完全解耦（MVVM 的 Model 层）。
struct MemoryGame<CardContent: Equatable> {
    private(set) var cards: [Card]
    private(set) var score: Int

    init(numberOfPairs: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        score = 0
        let pairs = max(1, numberOfPairs)
        for pairIndex in 0..<pairs {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: "\(pairIndex)a"))
            cards.append(Card(content: content, id: "\(pairIndex)b"))
        }
        cards.shuffle()
    }

    /// 当前唯一正面朝上的牌的索引（多于一张时返回 nil）。
    var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set {
            cards.indices.forEach { cards[$0].isFaceUp = (newValue == $0) }
        }
    }

    mutating func choose(_ card: Card) {
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) else { return }
        guard !cards[chosenIndex].isMatched, !cards[chosenIndex].isFaceUp else { return }

        if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
            cards[chosenIndex].isFaceUp = true
            if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                cards[chosenIndex].isMatched = true
                cards[potentialMatchIndex].isMatched = true
                score += 2
            } else {
                if cards[chosenIndex].hasBeenSeen { score -= 1 }
                if cards[potentialMatchIndex].hasBeenSeen { score -= 1 }
            }
            cards[chosenIndex].hasBeenSeen = true
            cards[potentialMatchIndex].hasBeenSeen = true
        } else {
            cards[chosenIndex].isFaceUp = true
        }
        cards[chosenIndex].hasBeenSeen = true
    }

    mutating func shuffle() {
        cards.shuffle()
    }

    var isGameOver: Bool {
        cards.allSatisfy { $0.isMatched }
    }

    struct Card: Identifiable, Equatable {
        var isFaceUp = false
        var isMatched = false
        var hasBeenSeen = false
        let content: CardContent
        let id: String
    }
}

extension Array {
    var only: Element? { count == 1 ? first : nil }
}
